/*
 * Waltz - Enterprise Architecture
 * Copyright (C) 2016, 2017, 2018, 2019 Waltz open source project
 * See README.md for more information
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific
 *
 */

package org.finos.waltz.data.report_grid;


import org.finos.waltz.common.DateTimeUtilities;
import org.finos.waltz.common.SetUtilities;
import org.finos.waltz.data.GenericSelector;
import org.finos.waltz.data.InlineSelectFieldFactory;
import org.finos.waltz.model.EntityKind;
import org.finos.waltz.model.EntityReference;
import org.finos.waltz.model.entity_field_reference.EntityFieldReference;
import org.finos.waltz.model.entity_field_reference.ImmutableEntityFieldReference;
import org.finos.waltz.model.report_grid.*;
import org.finos.waltz.schema.Tables;
import org.finos.waltz.schema.tables.records.ReportGridColumnDefinitionRecord;
import org.finos.waltz.schema.tables.records.ReportGridRecord;
import org.jooq.*;
import org.jooq.impl.DSL;
import org.jooq.lambda.tuple.Tuple2;
import org.jooq.lambda.tuple.Tuple3;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Repository;

import java.util.Comparator;
import java.util.*;
import java.util.function.Function;
import java.util.function.ToIntFunction;
import java.util.stream.IntStream;

import static java.lang.String.format;
import static java.util.Collections.emptyList;
import static java.util.Collections.emptySet;
import static java.util.function.Function.identity;
import static java.util.stream.Collectors.*;
import static org.finos.waltz.common.DateTimeUtilities.toLocalDateTime;
import static org.finos.waltz.common.ListUtilities.newArrayList;
import static org.finos.waltz.common.MapUtilities.groupBy;
import static org.finos.waltz.common.SetUtilities.map;
import static org.finos.waltz.common.SetUtilities.union;
import static org.finos.waltz.common.StringUtilities.join;
import static org.finos.waltz.model.EntityReference.mkRef;
import static org.finos.waltz.model.survey.SurveyInstanceStatus.APPROVED;
import static org.finos.waltz.model.survey.SurveyInstanceStatus.COMPLETED;
import static org.finos.waltz.schema.Tables.*;
import static org.finos.waltz.schema.tables.InvolvementKind.INVOLVEMENT_KIND;
import static org.jooq.lambda.tuple.Tuple.tuple;

@Repository
public class ReportGridDao {

    private final DSLContext dsl;

    private final org.finos.waltz.schema.tables.Measurable m = MEASURABLE.as("m");
    private final org.finos.waltz.schema.tables.MeasurableRating mr = MEASURABLE_RATING.as("mr");
    private final org.finos.waltz.schema.tables.MeasurableCategory mc = MEASURABLE_CATEGORY.as("mc");
    private final org.finos.waltz.schema.tables.ReportGridColumnDefinition rgcd = REPORT_GRID_COLUMN_DEFINITION.as("rgcd");
    private final org.finos.waltz.schema.tables.ReportGrid rg = Tables.REPORT_GRID.as("rg");
    private final org.finos.waltz.schema.tables.RatingSchemeItem rsi = RATING_SCHEME_ITEM.as("rsi");
    private final org.finos.waltz.schema.tables.EntityHierarchy eh = ENTITY_HIERARCHY.as("eh");
    private final org.finos.waltz.schema.tables.AssessmentDefinition ad = ASSESSMENT_DEFINITION.as("ad");
    private final org.finos.waltz.schema.tables.AssessmentRating ar = ASSESSMENT_RATING.as("ar");
    private final org.finos.waltz.schema.tables.CostKind ck = COST_KIND.as("ck");
    private final org.finos.waltz.schema.tables.Cost c = COST.as("c");
    private final org.finos.waltz.schema.tables.Involvement inv = INVOLVEMENT.as("inv");
    private final org.finos.waltz.schema.tables.InvolvementKind ik = INVOLVEMENT_KIND.as("ik");
    private final org.finos.waltz.schema.tables.Person p = Tables.PERSON.as("p");
    private final org.finos.waltz.schema.tables.SurveyQuestion sq = SURVEY_QUESTION.as("sq");
    private final org.finos.waltz.schema.tables.EntityFieldReference efr = ENTITY_FIELD_REFERENCE.as("efr");
    private final org.finos.waltz.schema.tables.SurveyTemplate st = SURVEY_TEMPLATE.as("st");
    private final org.finos.waltz.schema.tables.Application a = APPLICATION.as("a");
    private final org.finos.waltz.schema.tables.ChangeInitiative ci = CHANGE_INITIATIVE.as("ci");

    private static final Field<String> ENTITY_NAME_FIELD = InlineSelectFieldFactory.mkNameField(
                    SURVEY_QUESTION_RESPONSE.ENTITY_RESPONSE_ID,
                    SURVEY_QUESTION_RESPONSE.ENTITY_RESPONSE_KIND,
                    newArrayList(EntityKind.PERSON, EntityKind.APPLICATION))
            .as("entity_name");

    @Autowired
    public ReportGridDao(DSLContext dsl) {
        this.dsl = dsl;
    }


    public Set<ReportGridDefinition> findAll(){
        return dsl
                .select(rg.fields())
                .from(rg)
                .fetchSet(r -> mkReportGridDefinition(rgcd.REPORT_GRID_ID.eq(r.get(rg.ID)), r.into(REPORT_GRID)));
    }


    public Set<ReportGridDefinition> findForUser(String username){
        return dsl
                .select(rg.fields())
                .from(rg)
                .leftJoin(REPORT_GRID_MEMBER)
                .on(rg.ID.eq(REPORT_GRID_MEMBER.GRID_ID))
                .where(rg.KIND.eq(ReportGridKind.PUBLIC.name()).or(REPORT_GRID_MEMBER.USER_ID.eq(username)))
                .fetchSet(r -> mkReportGridDefinition(rgcd.REPORT_GRID_ID.eq(r.get(rg.ID)), r.into(REPORT_GRID)));
    }


    public Set<ReportGridCell> findCellDataByGridId(long id,
                                                    GenericSelector genericSelector) {
        return findCellDataByGridCondition(rg.ID.eq(id), genericSelector);
    }


    public Set<ReportGridCell> findCellDataByGridExternalId(String externalId,
                                                            GenericSelector genericSelector) {
        return findCellDataByGridCondition(rg.EXTERNAL_ID.eq(externalId), genericSelector);
    }


    public ReportGridDefinition getGridDefinitionById(long id) {
        return getGridDefinitionByCondition(rg.ID.eq(id));
    }


    public ReportGridDefinition getGridDefinitionByExternalId(String externalId) {
        return getGridDefinitionByCondition(rg.EXTERNAL_ID.eq(externalId));
    }


    public int updateColumnDefinitions(long gridId, List<ReportGridColumnDefinition> columnDefinitions) {

        int clearedColumns = dsl
                .deleteFrom(rgcd)
                .where(rgcd.REPORT_GRID_ID.eq(gridId))
                .execute();

        int[] columnsUpdated = columnDefinitions
                .stream()
                .map(d -> {
                    Long fieldReferenceId = d.entityFieldReference() == null
                            ? null
                            : d.entityFieldReference().id().orElse(null);

                    ReportGridColumnDefinitionRecord record = dsl.newRecord(rgcd);
                    record.setReportGridId(gridId);
                    record.setColumnEntityId(d.columnEntityId());
                    record.setColumnEntityKind(d.columnEntityKind().name());
                    record.setColumnUsageKind(d.usageKind().name());
                    record.setRatingRollupRule(d.ratingRollupRule().name());
                    record.setPosition(Long.valueOf(d.position()).intValue());
                    record.setDisplayName(d.displayName());
                    record.setEntityFieldReferenceId(fieldReferenceId);
                    return record;
                })
                .collect(collectingAndThen(toSet(), d -> dsl.batchInsert(d).execute()));

        return IntStream.of(columnsUpdated).sum();
    }


    public long create(ReportGridCreateCommand createCommand, String username) {
        ReportGridRecord record = dsl.newRecord(rg);
        record.setName(createCommand.name());
        record.setExternalId(createCommand.toExtId(username));
        record.setDescription(createCommand.description());
        record.setLastUpdatedAt(DateTimeUtilities.nowUtcTimestamp());
        record.setLastUpdatedBy(username);
        record.setProvenance("waltz");
        record.setSubjectKind(createCommand.subjectKind().name());
        record.setKind(createCommand.kind().name());

        try {
            int insert = record.insert();
            return record.getId();
        } catch (DataIntegrityViolationException exception) {
            throw new DataIntegrityViolationException(format(
                    "Grid already exists with the name: %s for user.",
                    createCommand.name()));
        }
    }

    public long update(long id, ReportGridUpdateCommand updateCommand, String username) {
        return dsl
                .update(rg)
                .set(rg.NAME, updateCommand.name())
                .set(rg.DESCRIPTION, updateCommand.description())
                .set(rg.KIND, updateCommand.kind().name())
                .set(rg.LAST_UPDATED_AT, DateTimeUtilities.nowUtcTimestamp())
                .set(rg.LAST_UPDATED_BY, username)
                .where(rg.ID.eq(id))
                .execute();
    }

    // --- Helpers ---

    private ReportGridDefinition getGridDefinitionByCondition(Condition condition) {
        return dsl
                .select(rg.fields())
                .from(rg)
                .where(condition)
                .fetchOne(r -> mkReportGridDefinition(condition, r.into(REPORT_GRID)));
    }


    private List<ReportGridColumnDefinition> getColumnDefinitions(Condition condition) {

        SelectConditionStep<Record13<String, String, Long, String, String, Integer, String, String, Long, String, String, String, String>> measurableColumns = mkColumnDefinitionQuery(
                EntityKind.MEASURABLE,
                m,
                m.ID,
                m.NAME,
                m.DESCRIPTION,
                condition);

        SelectConditionStep<Record13<String, String, Long, String, String, Integer, String, String, Long, String, String, String, String>> assessmentDefinitionColumns = mkColumnDefinitionQuery(
                EntityKind.ASSESSMENT_DEFINITION,
                ad,
                ad.ID,
                ad.NAME,
                ad.DESCRIPTION,
                condition);

        SelectConditionStep<Record13<String, String, Long, String, String, Integer, String, String, Long, String, String, String, String>> costKindColumns = mkColumnDefinitionQuery(
                EntityKind.COST_KIND,
                ck,
                ck.ID,
                ck.NAME,
                ck.DESCRIPTION,
                condition);

        SelectConditionStep<Record13<String, String, Long, String, String, Integer, String, String, Long, String, String, String, String>> involvementKindColumns = mkColumnDefinitionQuery(
                EntityKind.INVOLVEMENT_KIND,
                ik,
                ik.ID,
                ik.NAME,
                ik.DESCRIPTION,
                condition);

        SelectConditionStep<Record13<String, String, Long, String, String, Integer, String, String, Long, String, String, String, String>> surveyQuestionColumns = mkColumnDefinitionQuery(
                EntityKind.SURVEY_QUESTION,
                sq,
                sq.ID,
                sq.QUESTION_TEXT,
                sq.HELP_TEXT,
                condition);

        SelectConditionStep<Record13<String, String, Long, String, String, Integer, String, String, Long, String, String, String, String>> surveyMetaColumns = mkColumnDefinitionQuery(
                EntityKind.SURVEY_TEMPLATE,
                st,
                st.ID,
                st.NAME,
                st.DESCRIPTION,
                condition);

        SelectConditionStep<Record13<String, String, Long, String, String, Integer, String, String, Long, String, String, String, String>> applicationMetaColumns = mkColumnDefinitionQuery(
                EntityKind.APPLICATION,
                a,
                a.ID,
                a.NAME,
                a.DESCRIPTION,
                condition);

        SelectConditionStep<Record13<String, String, Long, String, String, Integer, String, String, Long, String, String, String, String>> changeInitiativeMetaColumns = mkColumnDefinitionQuery(
                EntityKind.CHANGE_INITIATIVE,
                ci,
                ci.ID,
                ci.NAME,
                ci.DESCRIPTION,
                condition);

        return assessmentDefinitionColumns
                .unionAll(measurableColumns)
                .unionAll(costKindColumns)
                .unionAll(involvementKindColumns)
                .unionAll(surveyQuestionColumns)
                .unionAll(surveyMetaColumns)
                .unionAll(applicationMetaColumns)
                .unionAll(changeInitiativeMetaColumns)
                .orderBy(rgcd.POSITION, DSL.field("name", String.class))
                .fetch(r -> {

                    Long fieldReferenceId = r.get(rgcd.ENTITY_FIELD_REFERENCE_ID);

                    ImmutableEntityFieldReference entityFieldReference = fieldReferenceId == null
                            ? null
                            : ImmutableEntityFieldReference.builder()
                            .id(fieldReferenceId)
                            .fieldName(r.get(efr.FIELD_NAME))
                            .entityKind(EntityKind.valueOf(r.get(efr.ENTITY_KIND)))
                            .displayName(r.get(efr.DISPLAY_NAME))
                            .description(r.get(efr.DESCRIPTION))
                            .build();

                    ImmutableReportGridColumnDefinition defn = ImmutableReportGridColumnDefinition.builder()
                            .columnEntityId(r.get(rgcd.COLUMN_ENTITY_ID))
                            .columnEntityKind(EntityKind.valueOf(r.get(rgcd.COLUMN_ENTITY_KIND)))
                            .columnName(r.get("name", String.class))
                            .columnDescription(r.get("desc", String.class))
                            .displayName(r.get(rgcd.DISPLAY_NAME))
                            .position(r.get(rgcd.POSITION))
                            .usageKind(ColumnUsageKind.valueOf(r.get(rgcd.COLUMN_USAGE_KIND)))
                            .ratingRollupRule(RatingRollupRule.valueOf(r.get(rgcd.RATING_ROLLUP_RULE)))
                            .entityFieldReference(entityFieldReference)
                            .build();

                    return defn;
                });
    }

    private SelectConditionStep<Record13<String, String, Long, String, String, Integer, String, String, Long, String, String, String, String>> mkColumnDefinitionQuery(EntityKind entityKind,
                                                                                                                                                                       Table<?> t,
                                                                                                                                                                       TableField<? extends Record, Long> ID,
                                                                                                                                                                       TableField<? extends Record, String> NAME,
                                                                                                                                                                       TableField<? extends Record, String> DESCRIPTION,
                                                                                                                                                                       Condition reportCondition) {
        return dsl
                .select(DSL.coalesce(NAME, DSL.val(entityKind.prettyName())).as("name"),
                        rgcd.DISPLAY_NAME,
                        rgcd.COLUMN_ENTITY_ID,
                        rgcd.COLUMN_ENTITY_KIND,
                        DESCRIPTION.as("desc"),
                        rgcd.POSITION,
                        rgcd.COLUMN_USAGE_KIND,
                        rgcd.RATING_ROLLUP_RULE,
                        rgcd.ENTITY_FIELD_REFERENCE_ID,
                        efr.ENTITY_KIND,
                        efr.DISPLAY_NAME,
                        efr.DESCRIPTION,
                        efr.FIELD_NAME)
                .from(rgcd)
                .innerJoin(rg).on(rg.ID.eq(rgcd.REPORT_GRID_ID))
                .leftJoin(t).on(ID.eq(rgcd.COLUMN_ENTITY_ID).and(rgcd.COLUMN_ENTITY_KIND.eq(entityKind.name())))
                .leftJoin(efr).on(rgcd.ENTITY_FIELD_REFERENCE_ID.eq(efr.ID))
                .where(reportCondition)
                .and(rgcd.COLUMN_ENTITY_KIND.eq(entityKind.name()));
    }


    private Set<ReportGridCell> findCellDataByGridCondition(Condition gridCondition,
                                                            GenericSelector genericSelector) {

        ReportGridDefinition gridDefn = getGridDefinitionByCondition(gridCondition);

        if (gridDefn == null) {
            return emptySet();

        } else {

            Map<Boolean, Collection<ReportGridColumnDefinition>> gridDefinitionsByContainingFieldRef = groupBy(
                    gridDefn.columnDefinitions(),
                    d -> d.entityFieldReference() == null);

            Collection<ReportGridColumnDefinition> simpleGridDefs = gridDefinitionsByContainingFieldRef.getOrDefault(true, Collections.emptyList());
            Collection<ReportGridColumnDefinition> complexGridDefs = gridDefinitionsByContainingFieldRef.getOrDefault(false, Collections.emptyList());

            // SIMPLE GRID DEFS

            Map<EntityKind, Collection<ReportGridColumnDefinition>> colsByKind = groupBy(
                    simpleGridDefs,
                    cd -> cd.columnEntityKind());

            Set<Long> requiredAssessmentDefinitions = map(
                    colsByKind.getOrDefault(EntityKind.ASSESSMENT_DEFINITION, emptySet()),
                    cd -> cd.columnEntityId());

            Map<RatingRollupRule, Collection<ReportGridColumnDefinition>> measurableColumnsByRollupKind = groupBy(
                    colsByKind.getOrDefault(EntityKind.MEASURABLE, emptySet()),
                    ReportGridColumnDefinition::ratingRollupRule);

            Set<Long> exactMeasurableIds = map(
                    measurableColumnsByRollupKind.get(RatingRollupRule.NONE),
                    cd -> cd.columnEntityId());

            Set<Long> summaryMeasurableIdsUsingHighest = map(
                    measurableColumnsByRollupKind.get(RatingRollupRule.PICK_HIGHEST),
                    cd -> cd.columnEntityId());

            Set<Long> summaryMeasurableIdsUsingLowest = map(
                    measurableColumnsByRollupKind.get(RatingRollupRule.PICK_LOWEST),
                    cd -> cd.columnEntityId());

            Set<Long> requiredCostKinds = map(
                    colsByKind.getOrDefault(EntityKind.COST_KIND, emptySet()),
                    cd -> cd.columnEntityId());

            Set<Long> requiredInvolvementKinds = map(
                    colsByKind.getOrDefault(EntityKind.INVOLVEMENT_KIND, emptySet()),
                    cd -> cd.columnEntityId());

            Set<Long> requiredSurveyQuestionIds = map(
                    colsByKind.getOrDefault(EntityKind.SURVEY_QUESTION, emptySet()),
                    cd -> cd.columnEntityId());


            // COMPLEX GRID DEFS

            Map<Long, EntityFieldReference> fieldReferencesById = dsl
                    .select(efr.fields())
                    .from(efr)
                    .where(efr.ID.in(map(complexGridDefs, r -> r.entityFieldReference().id().get())))
                    .fetchMap(
                            r -> r.get(efr.ID),
                            r -> ImmutableEntityFieldReference.builder()
                                    .id(r.get(efr.ID))
                                    .entityKind(EntityKind.valueOf(r.get(efr.ENTITY_KIND)))
                                    .fieldName(r.get(efr.FIELD_NAME))
                                    .displayName(r.get(efr.DISPLAY_NAME))
                                    .description(r.get(efr.DESCRIPTION))
                                    .build());

            Map<EntityKind, Set<Tuple2<ReportGridColumnDefinition, EntityFieldReference>>> complexColsByKind = complexGridDefs
                    .stream()
                    .map(d -> tuple(d, fieldReferencesById.get(d.entityFieldReference().id().get())))
                    .collect(groupingBy(t -> t.v2.entityKind(), toSet()));

            Set<Tuple2<ReportGridColumnDefinition, EntityFieldReference>> requiredSurveyTemplateIds = complexColsByKind
                    .getOrDefault(EntityKind.SURVEY_INSTANCE, emptySet());

            Set<Tuple2<ReportGridColumnDefinition, EntityFieldReference>> requiredApplicationColumns = complexColsByKind
                    .getOrDefault(EntityKind.APPLICATION, emptySet());

            Set<Tuple2<ReportGridColumnDefinition, EntityFieldReference>> requiredChangeInitiativeColumns = complexColsByKind
                    .getOrDefault(EntityKind.CHANGE_INITIATIVE, emptySet());

            return union(
                    fetchSummaryMeasurableData(genericSelector, summaryMeasurableIdsUsingHighest, summaryMeasurableIdsUsingLowest),
                    fetchAssessmentData(genericSelector, requiredAssessmentDefinitions),
                    fetchExactMeasurableData(genericSelector, exactMeasurableIds),
                    fetchCostData(genericSelector, requiredCostKinds),
                    fetchInvolvementData(genericSelector, requiredInvolvementKinds),
                    fetchSurveyQuestionResponseData(genericSelector, requiredSurveyQuestionIds),
                    fetchSurveyFieldReferenceData(genericSelector, requiredSurveyTemplateIds),
                    fetchApplicationFieldReferenceData(genericSelector, requiredApplicationColumns),
                    fetchChangeInitiativeFieldReferenceData(genericSelector, requiredChangeInitiativeColumns));
        }
    }


    public Set<ReportGridCell> fetchApplicationFieldReferenceData(GenericSelector selector,
                                                                  Set<Tuple2<ReportGridColumnDefinition, EntityFieldReference>> requiredApplicationColumns) {

        if (requiredApplicationColumns.size() == 0) {
            return emptySet();
        } else {

            Set<String> fields = map(requiredApplicationColumns, d -> d.v2.fieldName());

            Map<String, ReportGridColumnDefinition> columnDefinitionsByFieldReference = requiredApplicationColumns
                    .stream()
                    .collect(toMap(k -> k.v2.fieldName(), v -> v.v1));

            return dsl
                    .select(APPLICATION.fields())
                    .from(APPLICATION)
                    .where(APPLICATION.ID.in(selector.selector()))
                    .fetch()
                    .stream()
                    .flatMap(appRecord -> fields
                            .stream()
                            .map(fieldName -> {
                                ReportGridColumnDefinition colDefn = columnDefinitionsByFieldReference.get(fieldName);

                                Object value = appRecord.get(APPLICATION.field(fieldName));

                                if (value == null) {
                                    return null;
                                }

                                return ImmutableReportGridCell
                                        .builder()
                                        .subjectId(appRecord.get(APPLICATION.ID))
                                        .columnEntityId(colDefn.columnEntityId())
                                        .columnEntityKind(EntityKind.APPLICATION)
                                        .text(String.valueOf(value))
                                        .entityFieldReferenceId(colDefn.entityFieldReference().id().get())
                                        .build();
                            }))
                    .filter(Objects::nonNull)
                    .collect(toSet());
        }
    }


    public Set<ReportGridCell> fetchChangeInitiativeFieldReferenceData(GenericSelector selector,
                                                                       Set<Tuple2<ReportGridColumnDefinition, EntityFieldReference>> requiredChangeInitiativeColumns) {

        if (requiredChangeInitiativeColumns.size() == 0) {
            return emptySet();
        } else {

            Set<String> fields = map(requiredChangeInitiativeColumns, d -> d.v2.fieldName());

            Map<String, ReportGridColumnDefinition> columnDefinitionsByFieldReference = requiredChangeInitiativeColumns
                    .stream()
                    .collect(toMap(k -> k.v2.fieldName(), v -> v.v1));

            return dsl
                    .select(CHANGE_INITIATIVE.fields())
                    .from(CHANGE_INITIATIVE)
                    .where(CHANGE_INITIATIVE.ID.in(selector.selector()))
                    .fetch()
                    .stream()
                    .flatMap(ciRecord -> fields
                            .stream()
                            .map(fieldName -> {
                                ReportGridColumnDefinition colDefn = columnDefinitionsByFieldReference.get(fieldName);

                                Object value = ciRecord.get(CHANGE_INITIATIVE.field(fieldName));

                                if (value == null) {
                                    return null;
                                }

                                return ImmutableReportGridCell
                                        .builder()
                                        .subjectId(ciRecord.get(CHANGE_INITIATIVE.ID))
                                        .columnEntityId(colDefn.columnEntityId())
                                        .columnEntityKind(EntityKind.CHANGE_INITIATIVE)
                                        .text(String.valueOf(value))
                                        .entityFieldReferenceId(colDefn.entityFieldReference().id().get())
                                        .build();
                            }))
                    .filter(Objects::nonNull)
                    .collect(toSet());
        }
    }


    public Set<ReportGridCell> fetchSurveyFieldReferenceData(GenericSelector selector,
                                                             Set<Tuple2<ReportGridColumnDefinition, EntityFieldReference>> surveyInstanceInfo) {
        if (surveyInstanceInfo.size() == 0) {
            return emptySet();
        } else {

            Map<Long, Collection<EntityFieldReference>> fieldReferencesByTemplateId = groupBy(
                    surveyInstanceInfo,
                    r -> r.v1.columnEntityId(),
                    v -> v.v2);

            Set<Long> surveyTemplateIds = map(surveyInstanceInfo, d -> d.v1.columnEntityId());

            SelectConditionStep<Record> qry = dsl
                    .select(SURVEY_INSTANCE.fields())
                    .select(SURVEY_RUN.SURVEY_TEMPLATE_ID)
                    .from(SURVEY_INSTANCE)
                    .innerJoin(SURVEY_RUN).on(SURVEY_INSTANCE.SURVEY_RUN_ID.eq(SURVEY_RUN.ID))
                    .where(SURVEY_INSTANCE.ENTITY_ID.in(selector.selector())
                            .and(SURVEY_INSTANCE.ENTITY_KIND.eq(selector.kind().name())
                                    .and(SURVEY_RUN.SURVEY_TEMPLATE_ID.in(surveyTemplateIds)
                                            .and(SURVEY_INSTANCE.ORIGINAL_INSTANCE_ID.isNull()))));

            return qry
                    .fetch()
                    .stream()
                    .flatMap(surveyRecord -> {
                        Long templateId = surveyRecord.get(SURVEY_RUN.SURVEY_TEMPLATE_ID);

                        return fieldReferencesByTemplateId
                                .getOrDefault(templateId, emptySet())
                                .stream()
                                .map(fieldRef -> {
                                    Object value = surveyRecord.get(SURVEY_INSTANCE.field(fieldRef.fieldName()));

                                    if (value == null) {
                                        return null;
                                    }

                                    return ImmutableReportGridCell
                                            .builder()
                                            .subjectId(surveyRecord.get(SURVEY_INSTANCE.ENTITY_ID))
                                            .columnEntityId(templateId)
                                            .columnEntityKind(EntityKind.SURVEY_TEMPLATE)
                                            .text(String.valueOf(value))
                                            .entityFieldReferenceId(fieldRef.id().get())
                                            .build();
                                });
                    })
                    .filter(Objects::nonNull)
                    .collect(toSet());
        }
    }


    private Set<ReportGridCell> fetchInvolvementData(GenericSelector selector,
                                                     Set<Long> requiredInvolvementKinds) {
        if (requiredInvolvementKinds.size() == 0) {
            return emptySet();
        } else {
            return SetUtilities.fromCollection(dsl
                    .select(
                            inv.ENTITY_ID,
                            inv.KIND_ID,
                            p.EMAIL)
                    .from(inv)
                    .innerJoin(p).on(p.EMPLOYEE_ID.eq(inv.EMPLOYEE_ID))
                    .where(inv.ENTITY_KIND.eq(selector.kind().name()))
                    .and(inv.ENTITY_ID.in(selector.selector()))
                    .and(inv.KIND_ID.in(requiredInvolvementKinds))
                    .and(p.IS_REMOVED.isFalse())
                    .fetchSet(r -> ImmutableReportGridCell
                            .builder()
                            .subjectId(r.get(inv.ENTITY_ID))
                            .columnEntityId(r.get(inv.KIND_ID))
                            .columnEntityKind(EntityKind.INVOLVEMENT_KIND)
                            .text(r.get(p.EMAIL))
                            .entityFieldReferenceId(null)
                            .build())
                    // we now convert to a map so we can merge text values of cells with the same coordinates (appId, entId)
                    .stream()
                    .collect(toMap(
                            c -> tuple(c.subjectId(), c.columnEntityId()),
                            identity(),
                            (a, b) -> ImmutableReportGridCell
                                    .copyOf(a)
                                    .withText(a.text() + "; " + b.text())))
                    // and then we simply return the values of that temporary map.
                    .values());
        }
    }


    private Set<ReportGridCell> fetchCostData(GenericSelector selector,
                                              Set<Long> requiredCostKinds) {

        if (requiredCostKinds.size() == 0) {
            return emptySet();
        } else {

            SelectHavingStep<Record2<Long, Integer>> costKindLastestYear = dsl
                    .select(COST.COST_KIND_ID, DSL.max(COST.YEAR).as("latest_year"))
                    .from(COST)
                    .where(dsl.renderInlined(COST.ENTITY_ID.in(selector.selector())
                            .and(COST.ENTITY_KIND.eq(selector.kind().name()))))
                    .groupBy(COST.COST_KIND_ID);

            Condition latestYearForKind = c.COST_KIND_ID.eq(costKindLastestYear.field(COST.COST_KIND_ID))
                    .and(c.YEAR.eq(costKindLastestYear.field("latest_year", Integer.class)));

            return dsl
                    .select(c.ENTITY_ID,
                            c.COST_KIND_ID,
                            c.AMOUNT)
                    .from(c)
                    .innerJoin(costKindLastestYear).on(latestYearForKind)
                    .where(dsl.renderInlined(c.COST_KIND_ID.in(requiredCostKinds)
                            .and(c.ENTITY_KIND.eq(selector.kind().name()))
                            .and(c.ENTITY_ID.in(selector.selector()))))
                    .fetchSet(r -> ImmutableReportGridCell.builder()
                            .subjectId(r.get(c.ENTITY_ID))
                            .columnEntityId(r.get(c.COST_KIND_ID))
                            .columnEntityKind(EntityKind.COST_KIND)
                            .value(r.get(c.AMOUNT))
                            .entityFieldReferenceId(null)
                            .build());
        }
    }


    private Set<ReportGridCell> fetchSummaryMeasurableData(GenericSelector selector,
                                                           Set<Long> measurableIdsUsingHighest,
                                                           Set<Long> measurableIdsUsingLowest) {

        if (measurableIdsUsingHighest.size() == 0 && measurableIdsUsingLowest.size() == 0) {
            return emptySet();
        }

        Table<Record5<Long, String, Long, Integer, String>> ratingSchemeItems = DSL
                .select(mc.ID.as("mcId"),
                        rsi.CODE.as("rsiCode"),
                        rsi.ID.as("rsiId"),
                        rsi.POSITION.as("rsiPos"),
                        rsi.NAME.as("rsiName"))
                .from(mc)
                .innerJoin(rsi)
                .on(rsi.SCHEME_ID.eq(mc.RATING_SCHEME_ID))
                .asTable("ratingSchemeItems");

        SelectConditionStep<Record5<Long, Long, Long, Integer, String>> ratings = DSL
                .select(
                        m.ID,
                        mr.ENTITY_ID,
                        ratingSchemeItems.field("rsiId", Long.class),
                        ratingSchemeItems.field("rsiPos", Integer.class),
                        ratingSchemeItems.field("rsiName", String.class))
                .from(mr)
                .innerJoin(eh)
                .on(eh.ID.eq(mr.MEASURABLE_ID))
                .and(eh.KIND.eq(EntityKind.MEASURABLE.name()))
                .innerJoin(m)
                .on(eh.ANCESTOR_ID.eq(m.ID))
                .innerJoin(ratingSchemeItems)
                .on(m.MEASURABLE_CATEGORY_ID.eq(ratingSchemeItems.field("mcId", Long.class)))
                .and(mr.RATING.eq(ratingSchemeItems.field("rsiCode", String.class)))
                .where(mr.ENTITY_KIND.eq(selector.kind().name())
                        .and(mr.ENTITY_ID.in(selector.selector()))
                        .and(m.ID.in(union(measurableIdsUsingHighest, measurableIdsUsingLowest))));

        return dsl
                .resultQuery(dsl.renderInlined(ratings))
                .fetchGroups(
                        r -> tuple(
                                mkRef(selector.kind(), r.get(mr.ENTITY_ID)),
                                r.get(m.ID)),
                        r -> tuple(
                                r.get("rsiId", Long.class),
                                r.get("rsiPos", Integer.class),
                                r.get("rsiName", String.class)))
                .entrySet()
                .stream()
                .map(e -> {

                    Tuple2<EntityReference, Long> entityAndMeasurable = e.getKey();
                    Long measurableId = entityAndMeasurable.v2();
                    long entityId = entityAndMeasurable.v1().id();
                    List<Tuple3<Long, Integer, String>> ratingsForEntityAndMeasurable = e.getValue();

                    ToIntFunction<Tuple3<Long, Integer, String>> compareByPositionAsc = t -> t.v2;
                    ToIntFunction<Tuple3<Long, Integer, String>> compareByPositionDesc = t -> t.v2 * -1;
                    Function<? super Tuple3<Long, Integer, String>, String> compareByName = t -> t.v3;

                    Comparator<Tuple3<Long, Integer, String>> cmp = Comparator
                            .comparingInt(measurableIdsUsingHighest.contains(measurableId)
                                    ? compareByPositionAsc
                                    : compareByPositionDesc)
                            .thenComparing(compareByName);

                    return ratingsForEntityAndMeasurable
                            .stream()
                            .min(cmp)
                            .map(t -> ImmutableReportGridCell
                                    .builder()
                                    .subjectId(entityId)
                                    .columnEntityId(measurableId)
                                    .columnEntityKind(EntityKind.MEASURABLE)
                                    .ratingId(t.v1)
                                    .entityFieldReferenceId(null)
                                    .build())
                            .orElse(null);
                })
                .filter(Objects::nonNull)
                .collect(toSet());
    }


    private Set<ReportGridCell> fetchExactMeasurableData(GenericSelector selector,
                                                         Set<Long> exactMeasurableIds) {

        if (exactMeasurableIds.size() == 0) {
            return emptySet();
        }

        SelectConditionStep<Record4<Long, Long, Long, String>> qry = dsl
                .select(mr.ENTITY_ID,
                        mr.MEASURABLE_ID,
                        rsi.ID,
                        mr.DESCRIPTION)
                .from(mr)
                .innerJoin(m).on(m.ID.eq(mr.MEASURABLE_ID))
                .innerJoin(mc).on(mc.ID.eq(m.MEASURABLE_CATEGORY_ID))
                .innerJoin(rsi).on(rsi.CODE.eq(mr.RATING)).and(rsi.SCHEME_ID.eq(mc.RATING_SCHEME_ID))
                .where(mr.MEASURABLE_ID.in(exactMeasurableIds))
                .and(mr.ENTITY_ID.in(selector.selector()))
                .and(mr.ENTITY_KIND.eq(selector.kind().name()));

        return  dsl
                .resultQuery(dsl.renderInlined(qry))
                .fetchSet(r -> ImmutableReportGridCell.builder()
                        .subjectId(r.get(mr.ENTITY_ID))
                        .columnEntityId(r.get(mr.MEASURABLE_ID))
                        .columnEntityKind(EntityKind.MEASURABLE)
                        .ratingId(r.get(rsi.ID))
                        .comment(r.get(mr.DESCRIPTION))
                        .entityFieldReferenceId(null)
                        .build());
    }


    private Set<ReportGridCell> fetchAssessmentData(GenericSelector selector,
                                                    Set<Long> requiredAssessmentDefinitionIds) {
        if (requiredAssessmentDefinitionIds.size() == 0) {
            return emptySet();
        } else {
            return dsl
                    .select(ar.ENTITY_ID,
                            ar.ASSESSMENT_DEFINITION_ID,
                            ar.RATING_ID,
                            ar.DESCRIPTION)
                    .from(ar)
                    .where(ar.ASSESSMENT_DEFINITION_ID.in(requiredAssessmentDefinitionIds)
                            .and(ar.ENTITY_KIND.eq(selector.kind().name()))
                            .and(ar.ENTITY_ID.in(selector.selector())))
                    .fetchSet(r -> ImmutableReportGridCell.builder()
                            .subjectId(r.get(ar.ENTITY_ID))
                            .columnEntityId(r.get(ar.ASSESSMENT_DEFINITION_ID))
                            .columnEntityKind(EntityKind.ASSESSMENT_DEFINITION)
                            .ratingId(r.get(ar.RATING_ID))
                            .comment(r.get(ar.DESCRIPTION))
                            .entityFieldReferenceId(null)
                            .build());
        }
    }


    private Set<ReportGridCell> fetchSurveyQuestionResponseData(GenericSelector selector,
                                                                Set<Long> requiredSurveyQuestionIds) {
        if (requiredSurveyQuestionIds.size() == 0) {
            return emptySet();
        } else {

            Field<Long> latest_instance = DSL
                    .firstValue(SURVEY_INSTANCE.ID)
                    .over()
                    .partitionBy(SURVEY_INSTANCE.ENTITY_ID, SURVEY_INSTANCE.ENTITY_KIND, SURVEY_QUESTION.ID)
                    .orderBy(SURVEY_INSTANCE.APPROVED_AT.desc().nullsLast())
                    .as("latest_instance");

            Table<Record> responsesWithQuestionTypeAndEntity = dsl
                    .select(latest_instance)
                    .select(SURVEY_INSTANCE.ID.as("sid"),
                            SURVEY_INSTANCE.ENTITY_ID,
                            SURVEY_INSTANCE.ENTITY_KIND,
                            SURVEY_QUESTION.ID)
                    .select(SURVEY_QUESTION.FIELD_TYPE)
                    .select(ENTITY_NAME_FIELD)
                    .select(SURVEY_QUESTION_RESPONSE.COMMENT)
                    .select(DSL.coalesce(
                            SURVEY_QUESTION_RESPONSE.STRING_RESPONSE,
                            DSL.when(SURVEY_QUESTION_RESPONSE.BOOLEAN_RESPONSE.isNull(), DSL.castNull(String.class))
                                    .when(SURVEY_QUESTION_RESPONSE.BOOLEAN_RESPONSE.isTrue(), DSL.val("true"))
                                    .otherwise(DSL.val("false")),
                            DSL.cast(SURVEY_QUESTION_RESPONSE.NUMBER_RESPONSE, String.class),
                            DSL.cast(SURVEY_QUESTION_RESPONSE.DATE_RESPONSE, String.class),
                            DSL.cast(SURVEY_QUESTION_RESPONSE.LIST_RESPONSE_CONCAT, String.class)).as("response")) // for entity responses need to join entity name field
                    .from(SURVEY_QUESTION_RESPONSE)
                    .innerJoin(SURVEY_INSTANCE)
                    .on(SURVEY_QUESTION_RESPONSE.SURVEY_INSTANCE_ID.eq(SURVEY_INSTANCE.ID))
                    .innerJoin(SURVEY_QUESTION)
                    .on(SURVEY_QUESTION.ID.eq(SURVEY_QUESTION_RESPONSE.QUESTION_ID))
                    .where(SURVEY_INSTANCE.STATUS.in(APPROVED.name(), COMPLETED.name())
                            .and(SURVEY_QUESTION.ID.in(requiredSurveyQuestionIds))
                            .and(SURVEY_INSTANCE.ENTITY_ID.in(selector.selector()))
                            .and(SURVEY_INSTANCE.ENTITY_KIND.eq(selector.kind().name())))
                    .asTable();


            Map<Tuple2<Long, Long>, List<String>> responsesByInstanceQuestionKey = dsl
                    .select(SURVEY_QUESTION_LIST_RESPONSE.SURVEY_INSTANCE_ID,
                            SURVEY_QUESTION_LIST_RESPONSE.QUESTION_ID,
                            SURVEY_QUESTION_LIST_RESPONSE.RESPONSE)
                    .from(SURVEY_QUESTION_LIST_RESPONSE)
                    .innerJoin(SURVEY_INSTANCE).on(SURVEY_QUESTION_LIST_RESPONSE.SURVEY_INSTANCE_ID.eq(SURVEY_INSTANCE.ID))
                    .where(SURVEY_QUESTION_LIST_RESPONSE.QUESTION_ID.in(requiredSurveyQuestionIds))
                    .and(SURVEY_INSTANCE.ENTITY_ID.in(selector.selector()))
                    .and(SURVEY_INSTANCE.ENTITY_KIND.eq(selector.kind().name()))
                    .fetchGroups(
                            k -> tuple(k.get(SURVEY_QUESTION_LIST_RESPONSE.SURVEY_INSTANCE_ID), k.get(SURVEY_QUESTION_LIST_RESPONSE.QUESTION_ID)),
                            v -> v.get(SURVEY_QUESTION_LIST_RESPONSE.RESPONSE));

            SelectConditionStep<Record> qry = dsl
                    .select(responsesWithQuestionTypeAndEntity.fields())
                    .from(responsesWithQuestionTypeAndEntity)
                    .where(responsesWithQuestionTypeAndEntity.field(latest_instance)
                            .eq(responsesWithQuestionTypeAndEntity.field("sid", Long.class)));

            return qry
                    .fetchSet(r -> {
                        String fieldType = r.get(SURVEY_QUESTION.FIELD_TYPE);

                        Long instanceId = r.get("sid", Long.class);
                        Long questionId = r.get(SURVEY_QUESTION.ID, Long.class);
                        String entityName = r.get(ENTITY_NAME_FIELD);
                        String response = r.get("response", String.class);

                        List<String> listResponses = responsesByInstanceQuestionKey.getOrDefault(tuple(instanceId, questionId), emptyList());

                        return ImmutableReportGridCell.builder()
                                .subjectId(r.get(SURVEY_INSTANCE.ENTITY_ID))
                                .columnEntityId(questionId)
                                .columnEntityKind(EntityKind.SURVEY_QUESTION)
                                .text(determineDisplayText(fieldType, entityName, response, listResponses))
                                .comment(r.get(SURVEY_QUESTION_RESPONSE.COMMENT))
                                .entityFieldReferenceId(null)
                                .build();
                    });
        }
    }


    private String determineDisplayText(String fieldType,
                                        String entityName,
                                        String response,
                                        List<String> listResponses) {
        switch (fieldType) {
            case "PERSON":
            case "APPLICATION":
                return entityName;
            case "MEASURABLE_MULTI_SELECT":
                return join(listResponses, "; ");
            default:
                return response;
        }
    }


    private ImmutableReportGridDefinition mkReportGridDefinition(Condition condition,
                                                                 ReportGridRecord r) {
        return ImmutableReportGridDefinition
                .builder()
                .id(r.get(rg.ID))
                .name(r.get(rg.NAME))
                .description(r.get(rg.DESCRIPTION))
                .externalId(Optional.ofNullable(r.get(rg.EXTERNAL_ID)))
                .provenance(r.get(rg.PROVENANCE))
                .lastUpdatedAt(toLocalDateTime(r.get(rg.LAST_UPDATED_AT)))
                .lastUpdatedBy(r.get(rg.LAST_UPDATED_BY))
                .columnDefinitions(getColumnDefinitions(condition))
                .subjectKind(EntityKind.valueOf(r.get(rg.SUBJECT_KIND)))
                .kind(ReportGridKind.valueOf(r.get(rg.KIND)))
                .build();
    }


    public Set<ReportGridDefinition> findForOwner(String username) {
        Condition isOwner = REPORT_GRID_MEMBER.USER_ID.eq(username)
                .and(REPORT_GRID_MEMBER.ROLE.eq(ReportGridMemberRole.OWNER.name()));

        return dsl
                .select(rg.fields())
                .from(rg)
                .innerJoin(REPORT_GRID_MEMBER)
                .on(rg.ID.eq(REPORT_GRID_MEMBER.GRID_ID))
                .where(isOwner)
                .fetchSet(r -> mkReportGridDefinition(rgcd.REPORT_GRID_ID.eq(r.get(rg.ID)), r.into(REPORT_GRID)));
    }


    public boolean remove(long gridId) {
        return dsl
                .deleteFrom(REPORT_GRID)
                .where(REPORT_GRID.ID.eq(gridId))
                .execute() == 1;
    }
}

