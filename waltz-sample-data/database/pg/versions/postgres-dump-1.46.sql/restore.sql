--
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 10.15 (Debian 10.15-1.pgdg90+1)
-- Dumped by pg_dump version 12.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--DROP DATABASE waltz;
--
-- Name: waltz; Type: DATABASE; Schema: -; Owner: waltz
--

--CREATE DATABASE waltz WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE waltz OWNER TO waltz;

\connect waltz

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

--
-- Name: access_log; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.access_log (
    id integer NOT NULL,
    user_id character varying(128) NOT NULL,
    state character varying(255) NOT NULL,
    params character varying(1024),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.access_log OWNER TO waltz;

--
-- Name: TABLE access_log; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.access_log IS 'logs user page and section views';


--
-- Name: COLUMN access_log.user_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.access_log.user_id IS 'identifier of the user accessing the page or section';


--
-- Name: COLUMN access_log.state; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.access_log.state IS 'identifier of the page  plus optionally a section identifier (format: state|section)';


--
-- Name: COLUMN access_log.params; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.access_log.params IS 'additional params provided to page/section';


--
-- Name: access_log_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.access_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_log_id_seq OWNER TO waltz;

--
-- Name: access_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.access_log_id_seq OWNED BY public.access_log.id;


--
-- Name: actor; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.actor (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now(),
    last_updated_by character varying(255) NOT NULL,
    is_external boolean DEFAULT false NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    external_id character varying(200)
);


ALTER TABLE public.actor OWNER TO waltz;

--
-- Name: TABLE actor; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.actor IS 'represents a non application entity, typically used in flows.  Examples include exchanges, departments, counterpart organisations';


--
-- Name: COLUMN actor.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.actor.name IS 'short name identifying the actor (i.e. Bank of England)';


--
-- Name: COLUMN actor.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.actor.description IS 'longer textual description of the actor';


--
-- Name: COLUMN actor.is_external; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.actor.is_external IS 'flag to indicate whether this is an internal actor (e.g. Chief Risk Officer) or external actor (e.g. Bank of England)';


--
-- Name: COLUMN actor.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.actor.provenance IS 'where did this actor record originate, will be ''waltz'' if provided via the UI';


--
-- Name: COLUMN actor.external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.actor.external_id IS 'identifier this actor is known by externally.  Should not change, unlike the name which may change.';


--
-- Name: aggregate_overlay_diagram; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.aggregate_overlay_diagram (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    svg text NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    aggregated_entity_kind character varying(64) DEFAULT NULL::character varying NOT NULL
);


ALTER TABLE public.aggregate_overlay_diagram OWNER TO waltz;

--
-- Name: TABLE aggregate_overlay_diagram; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.aggregate_overlay_diagram IS 'svg diagram used to overlay waltz information, uses a data-cell-id attribute on the svg element to link to the cell_ext_id on aggregate_overlay_diagram_cell_data';


--
-- Name: COLUMN aggregate_overlay_diagram.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram.id IS 'unique identifier for this aggregate overlay diagram record within waltz';


--
-- Name: COLUMN aggregate_overlay_diagram.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram.name IS 'the name of this aggregate overlay diagram';


--
-- Name: COLUMN aggregate_overlay_diagram.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram.description IS 'longer description to provide more information about this aggregate overlay diagram';


--
-- Name: COLUMN aggregate_overlay_diagram.svg; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram.svg IS 'the svg diagram used to overlay waltz data onto, uses a data-cell-id attribute to lookup data';


--
-- Name: COLUMN aggregate_overlay_diagram.last_updated_at; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram.last_updated_at IS 'the datetime this aggregate overlay diagram record was last updated';


--
-- Name: COLUMN aggregate_overlay_diagram.last_updated_by; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram.last_updated_by IS 'the last user to update this aggregate overlay diagram record';


--
-- Name: COLUMN aggregate_overlay_diagram.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram.provenance IS 'origination of this aggregate overlay diagram';


--
-- Name: COLUMN aggregate_overlay_diagram.aggregated_entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram.aggregated_entity_kind IS 'the kind of entity this diagram is aggregating';


--
-- Name: aggregate_overlay_diagram_callout; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.aggregate_overlay_diagram_callout (
    id bigint NOT NULL,
    diagram_instance_id bigint NOT NULL,
    title character varying(255) NOT NULL,
    content character varying(4000),
    start_color character varying(64) NOT NULL,
    end_color character varying(64) NOT NULL,
    cell_external_id character varying(200) NOT NULL
);


ALTER TABLE public.aggregate_overlay_diagram_callout OWNER TO waltz;

--
-- Name: aggregate_overlay_diagram_callout_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

ALTER TABLE public.aggregate_overlay_diagram_callout ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.aggregate_overlay_diagram_callout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: aggregate_overlay_diagram_cell_data; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.aggregate_overlay_diagram_cell_data (
    id bigint NOT NULL,
    diagram_id bigint NOT NULL,
    cell_external_id character varying(200) NOT NULL,
    related_entity_kind character varying(64) NOT NULL,
    related_entity_id bigint NOT NULL
);


ALTER TABLE public.aggregate_overlay_diagram_cell_data OWNER TO waltz;

--
-- Name: TABLE aggregate_overlay_diagram_cell_data; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.aggregate_overlay_diagram_cell_data IS 'links entities in waltz to an svg diagram listed in the aggregate_overlay_diagram table';


--
-- Name: COLUMN aggregate_overlay_diagram_cell_data.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_cell_data.id IS 'unique identifier for this aggregate overlay diagram cell data record within waltz';


--
-- Name: COLUMN aggregate_overlay_diagram_cell_data.diagram_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_cell_data.diagram_id IS 'the reference to the aggregate overlay diagram that these entities relate to';


--
-- Name: COLUMN aggregate_overlay_diagram_cell_data.cell_external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_cell_data.cell_external_id IS 'used to assign the entity in waltz to an evg element on the related diagram, via the data-cell-id attribute';


--
-- Name: COLUMN aggregate_overlay_diagram_cell_data.related_entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_cell_data.related_entity_kind IS 'the kind of entity being linked to the aggregate overlay diagram';


--
-- Name: COLUMN aggregate_overlay_diagram_cell_data.related_entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_cell_data.related_entity_id IS 'the identifier for the entity being linked to the aggregate overlay diagram';


--
-- Name: aggregate_overlay_diagram_cell_data_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

ALTER TABLE public.aggregate_overlay_diagram_cell_data ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.aggregate_overlay_diagram_cell_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: aggregate_overlay_diagram_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

ALTER TABLE public.aggregate_overlay_diagram ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.aggregate_overlay_diagram_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: aggregate_overlay_diagram_instance; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.aggregate_overlay_diagram_instance (
    id bigint NOT NULL,
    diagram_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    parent_entity_kind character varying(64) NOT NULL,
    parent_entity_id bigint NOT NULL,
    svg text NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    snapshot_data text
);


ALTER TABLE public.aggregate_overlay_diagram_instance OWNER TO waltz;

--
-- Name: TABLE aggregate_overlay_diagram_instance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.aggregate_overlay_diagram_instance IS 'an instance of an aggregate overlay diagram, specific to a particular vantage point in waltz e.g. an particular ORG_UNIT';


--
-- Name: COLUMN aggregate_overlay_diagram_instance.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_instance.id IS 'unique identifier for this aggregate overlay diagram instance record within waltz';


--
-- Name: COLUMN aggregate_overlay_diagram_instance.diagram_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_instance.diagram_id IS 'the reference to the aggregate overlay diagram that this instance references';


--
-- Name: COLUMN aggregate_overlay_diagram_instance.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_instance.name IS 'the name of this aggregate overlay diagram instance';


--
-- Name: COLUMN aggregate_overlay_diagram_instance.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_instance.description IS 'longer description to provide more information about this aggregate overlay diagram instance';


--
-- Name: COLUMN aggregate_overlay_diagram_instance.parent_entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_instance.parent_entity_kind IS 'the kind of entity which describes the in scope applications for this diagram';


--
-- Name: COLUMN aggregate_overlay_diagram_instance.parent_entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_instance.parent_entity_id IS 'the identifier for the entity which describes the in scope applications for this diagram';


--
-- Name: COLUMN aggregate_overlay_diagram_instance.last_updated_at; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_instance.last_updated_at IS 'the datetime this aggregate overlay diagram record was last updated';


--
-- Name: COLUMN aggregate_overlay_diagram_instance.last_updated_by; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_instance.last_updated_by IS 'the last user to update this aggregate overlay diagram instance record';


--
-- Name: COLUMN aggregate_overlay_diagram_instance.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_instance.provenance IS 'origination of this aggregate overlay diagram instance';


--
-- Name: COLUMN aggregate_overlay_diagram_instance.snapshot_data; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.aggregate_overlay_diagram_instance.snapshot_data IS 'json copy of the data backing this diagram instance.  Each row should be very flat and contain (at a minimum) a column ref so the client can present the appropriate tranche of data in the UI';


--
-- Name: aggregate_overlay_diagram_instance_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

ALTER TABLE public.aggregate_overlay_diagram_instance ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.aggregate_overlay_diagram_instance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: aggregate_overlay_diagram_preset; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.aggregate_overlay_diagram_preset (
    id bigint NOT NULL,
    diagram_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    external_id character varying(200) NOT NULL,
    overlay_config character varying(4000) NOT NULL,
    filter_config character varying(4000) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL
);


ALTER TABLE public.aggregate_overlay_diagram_preset OWNER TO waltz;

--
-- Name: aggregate_overlay_diagram_preset_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

ALTER TABLE public.aggregate_overlay_diagram_preset ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.aggregate_overlay_diagram_preset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: allocation; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.allocation (
    allocation_scheme_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    measurable_id bigint NOT NULL,
    allocation_percentage integer DEFAULT 0 NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    external_id character varying(200),
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.allocation OWNER TO waltz;

--
-- Name: TABLE allocation; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.allocation IS 'allocations are used to apportion shares of a particular scheme (i.e. TCO) against an entity (e.g. applications) and measurable.  The total for a given scheme and entity should be lte 100';


--
-- Name: COLUMN allocation.allocation_scheme_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.allocation.allocation_scheme_id IS 'identifier (and fk) to a particular allocation scheme';


--
-- Name: COLUMN allocation.entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.allocation.entity_id IS 'identifier of the entity this allocation refers to';


--
-- Name: COLUMN allocation.entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.allocation.entity_kind IS 'kind of the entity (e.g. APPLICATION) this allocation refers to';


--
-- Name: COLUMN allocation.measurable_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.allocation.measurable_id IS 'which measurable is being given an allocation for this entity';


--
-- Name: COLUMN allocation.allocation_percentage; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.allocation.allocation_percentage IS 'the allocation percentage given to this entity/measurable';


--
-- Name: allocation_scheme; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.allocation_scheme (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000) NOT NULL,
    measurable_category_id bigint NOT NULL,
    external_id character varying(200) DEFAULT 'TEMP'::character varying NOT NULL
);


ALTER TABLE public.allocation_scheme OWNER TO waltz;

--
-- Name: TABLE allocation_scheme; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.allocation_scheme IS 'allocation_schemes provide a named definition which allows entities to record allocations against a particular measurable category. (e.g. the ''Function Cost Shred'' would be for applications to record allocations against their Functional Taxonomy measurable mappings)';


--
-- Name: COLUMN allocation_scheme.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.allocation_scheme.name IS 'short name describing this allocation scheme (i.e. ''Function Cost Shred'')';


--
-- Name: COLUMN allocation_scheme.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.allocation_scheme.description IS 'longer description to provide more information about this allocation scheme';


--
-- Name: COLUMN allocation_scheme.measurable_category_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.allocation_scheme.measurable_category_id IS 'defines the category of measurables this allocation scheme refers to';


--
-- Name: COLUMN allocation_scheme.external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.allocation_scheme.external_id IS 'typically used when setting allocations via external batch processes (e.g. ''FT_COST'')';


--
-- Name: allocation_scheme_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.allocation_scheme_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.allocation_scheme_id_seq OWNER TO waltz;

--
-- Name: allocation_scheme_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.allocation_scheme_id_seq OWNED BY public.allocation_scheme.id;


--
-- Name: application; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.application (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(4000),
    asset_code character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    organisational_unit_id bigint NOT NULL,
    kind character varying(128) DEFAULT 'IN_HOUSE'::character varying NOT NULL,
    lifecycle_phase character varying(128) DEFAULT 'PRODUCTION'::character varying NOT NULL,
    parent_asset_code character varying(255),
    overall_rating character(1) DEFAULT 'Z'::bpchar NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    business_criticality character varying(128) DEFAULT 'UNKNOWN'::character varying NOT NULL,
    is_removed boolean DEFAULT false NOT NULL,
    entity_lifecycle_status character varying(64) DEFAULT 'ACTIVE'::character varying NOT NULL,
    planned_retirement_date timestamp without time zone,
    actual_retirement_date timestamp without time zone,
    commission_date timestamp without time zone
);


ALTER TABLE public.application OWNER TO waltz;

--
-- Name: TABLE application; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.application IS 'represents an application (with an entity_kind of ''APPLICATION'')';


--
-- Name: COLUMN application.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.name IS 'name of this application (aliases can be added in the entity_alias table)';


--
-- Name: COLUMN application.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.description IS 'longer description to provide more information about this application.  Markdown is supported';


--
-- Name: COLUMN application.asset_code; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.asset_code IS 'external identifier representing this application';


--
-- Name: COLUMN application.organisational_unit_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.organisational_unit_id IS 'reference to the owning org unit';


--
-- Name: COLUMN application.kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.kind IS 'broad category of this application (e.g. IN_HOUSE, EXTERNALLY_HOSTED, THIRD_PARTY, EUC, etc)';


--
-- Name: COLUMN application.lifecycle_phase; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.lifecycle_phase IS 'the current application lifecycle state of this application (one of: CONCEPTUAL, DEVELOPMENT, PRODUCTION, RETIRED)';


--
-- Name: COLUMN application.parent_asset_code; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.parent_asset_code IS 'asset code of any parent application';


--
-- Name: COLUMN application.overall_rating; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.overall_rating IS 'investment rating scheme (one of: R, A, G, Z / which equates to Disinvest, Maintain, Invest, Unknown)';


--
-- Name: COLUMN application.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.provenance IS 'origination of this application record.  Will be ''waltz'' if entered via the UI';


--
-- Name: COLUMN application.business_criticality; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.business_criticality IS 'business criticality of this application (one of: LOW, MEDIUM, HIGH, VERY_HIGH, NONE, UNKNOWN)';


--
-- Name: COLUMN application.is_removed; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.is_removed IS 'should this record logically be treated as if it has been physically deleted';


--
-- Name: COLUMN application.entity_lifecycle_status; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.entity_lifecycle_status IS 'the lifecycle state of this entity record, slightly different from is_removed as does not imply the record is ''gone''  (one of: ACTIVE, PENDING, REMOVED)';


--
-- Name: COLUMN application.planned_retirement_date; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.planned_retirement_date IS 'date when this application is (or was) planning to retire';


--
-- Name: COLUMN application.actual_retirement_date; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.actual_retirement_date IS 'date when this application actually retired from production, null if not planned';


--
-- Name: COLUMN application.commission_date; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application.commission_date IS 'when was this application commissioned, null if unknown';


--
-- Name: application_group; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.application_group (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    kind character varying(64) DEFAULT 'PUBLIC'::character varying NOT NULL,
    description text,
    external_id character varying(200),
    is_removed boolean DEFAULT false NOT NULL,
    is_favourite_group boolean DEFAULT false NOT NULL
);


ALTER TABLE public.application_group OWNER TO waltz;

--
-- Name: TABLE application_group; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.application_group IS 'represents an ad-hoc collection of applications';


--
-- Name: COLUMN application_group.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group.name IS 'display name for the group';


--
-- Name: COLUMN application_group.kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group.kind IS 'the type of group (one of: PUBLIC, PRIVATE).  Note, private groups can still be seen, they are merely unlisted in the UI';


--
-- Name: COLUMN application_group.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group.description IS 'longer description of the group, supports markdown';


--
-- Name: COLUMN application_group.external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group.external_id IS 'external identifier, typically used when creating/syncing groups via external jobs';


--
-- Name: COLUMN application_group.is_removed; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group.is_removed IS 'flag indicating if the group has been deleted';


--
-- Name: COLUMN application_group.is_favourite_group; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group.is_favourite_group IS 'a favourite group is assigned to each user to allow them to quickly bookmark apps and populate the change calendar on the homepage';


--
-- Name: application_group_entry; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.application_group_entry (
    group_id bigint NOT NULL,
    application_id bigint NOT NULL,
    is_readonly boolean DEFAULT false NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.application_group_entry OWNER TO waltz;

--
-- Name: TABLE application_group_entry; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.application_group_entry IS 'a reference to a specific application in a group';


--
-- Name: COLUMN application_group_entry.group_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_entry.group_id IS 'reference to the group this entry belongs to';


--
-- Name: COLUMN application_group_entry.application_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_entry.application_id IS 'reference to the application this entry refers to';


--
-- Name: COLUMN application_group_entry.is_readonly; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_entry.is_readonly IS 'flag to indicate that the value is readonly.  Typically set if group entries are added by external jobs';


--
-- Name: COLUMN application_group_entry.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_entry.provenance IS 'indicates where this record originated. Will be ''waltz'' if created via the UI';


--
-- Name: COLUMN application_group_entry.created_at; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_entry.created_at IS 'the date this entry was created, sometimes used to ''age'' entries out the group, i.e. in exception lists';


--
-- Name: application_group_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.application_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.application_group_id_seq OWNER TO waltz;

--
-- Name: application_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.application_group_id_seq OWNED BY public.application_group.id;


--
-- Name: application_group_member; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.application_group_member (
    group_id bigint NOT NULL,
    user_id character varying(128) NOT NULL,
    role character varying(64) DEFAULT 'VIEWER'::character varying NOT NULL
);


ALTER TABLE public.application_group_member OWNER TO waltz;

--
-- Name: TABLE application_group_member; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.application_group_member IS 'users granted viewer or ownership rights to app groups';


--
-- Name: COLUMN application_group_member.group_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_member.group_id IS 'reference to the group this member belongs to';


--
-- Name: COLUMN application_group_member.user_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_member.user_id IS 'reference to the user id of the group member';


--
-- Name: COLUMN application_group_member.role; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_member.role IS 'the role of the user in the group (one of: VIEWER, OWNER)';


--
-- Name: application_group_ou_entry; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.application_group_ou_entry (
    group_id bigint NOT NULL,
    org_unit_id bigint NOT NULL,
    is_readonly boolean DEFAULT false NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.application_group_ou_entry OWNER TO waltz;

--
-- Name: TABLE application_group_ou_entry; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.application_group_ou_entry IS 'app groups can include reference to org units. Apps associated to the org unit are included in the group at runtime';


--
-- Name: COLUMN application_group_ou_entry.group_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_ou_entry.group_id IS 'reference to the group this entry belongs to';


--
-- Name: COLUMN application_group_ou_entry.org_unit_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_ou_entry.org_unit_id IS 'reference to the org unit this entry belongs to';


--
-- Name: COLUMN application_group_ou_entry.is_readonly; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_ou_entry.is_readonly IS 'flag to indicate that the value is readonly.  Typically set if group entries are added by external jobs';


--
-- Name: COLUMN application_group_ou_entry.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_ou_entry.provenance IS 'indicates where this record originated. Will be ''waltz'' if created via the UI';


--
-- Name: COLUMN application_group_ou_entry.created_at; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.application_group_ou_entry.created_at IS 'the date this entry was created';


--
-- Name: application_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.application_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.application_id_seq OWNER TO waltz;

--
-- Name: application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.application_id_seq OWNED BY public.application.id;


--
-- Name: assessment_definition; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.assessment_definition (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    external_id character varying(200),
    rating_scheme_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    description character varying(4000),
    permitted_role character varying(255),
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    is_readonly boolean DEFAULT false NOT NULL,
    provenance character varying(64) NOT NULL,
    visibility character varying(64) DEFAULT 'PRIMARY'::character varying NOT NULL,
    definition_group character varying(255) DEFAULT 'Uncategorized'::character varying NOT NULL,
    qualifier_kind character varying(64),
    qualifier_id bigint
);


ALTER TABLE public.assessment_definition OWNER TO waltz;

--
-- Name: TABLE assessment_definition; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.assessment_definition IS 'assessments are used to record enumerated data points against apps. The definition describes each type of definition, linking to the applicable entity types and possible values.';


--
-- Name: COLUMN assessment_definition.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_definition.name IS 'display name for this assessment definition';


--
-- Name: COLUMN assessment_definition.external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_definition.external_id IS 'external identifier, typically used when external jobs are updating the associated ratings';


--
-- Name: COLUMN assessment_definition.rating_scheme_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_definition.rating_scheme_id IS 'reference to the rating scheme which provides the acceptable values for this assessment';


--
-- Name: COLUMN assessment_definition.entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_definition.entity_kind IS 'the kind of entity the assessment can be associated with (typically the _main_ entities: APPLICATION, CHANGE_INITIATIVE, etc';


--
-- Name: COLUMN assessment_definition.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_definition.description IS 'longer description of this assessment.  Markdown is supported';


--
-- Name: COLUMN assessment_definition.permitted_role; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_definition.permitted_role IS 'if defined, only users with this role can update the definition';


--
-- Name: COLUMN assessment_definition.is_readonly; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_definition.is_readonly IS 'flag inidcating that the record is read only.  Typically set if the assessment values are mastered outside of Waltz and updated via an external job';


--
-- Name: COLUMN assessment_definition.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_definition.provenance IS 'where this definition came from.  Will be ''waltz'' if created via the UI';


--
-- Name: COLUMN assessment_definition.visibility; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_definition.visibility IS 'indicates if this assessment should be included in the users primary, short-list by default (permissible values are: PRIMARY, SECONDARY).  Note: users are free to remove assessments from their short lists.';


--
-- Name: COLUMN assessment_definition.definition_group; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_definition.definition_group IS 'Used to categorized assessments into a basic 2 level tree, useful when the number of assessments gets large';


--
-- Name: COLUMN assessment_definition.qualifier_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_definition.qualifier_kind IS 'An optional reference a qualifier kind, to further identify where this assessment is applicable';


--
-- Name: COLUMN assessment_definition.qualifier_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_definition.qualifier_id IS 'An optional reference a qualifier id, to further identify where this assessment is applicable';


--
-- Name: assessment_definition_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.assessment_definition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_definition_id_seq OWNER TO waltz;

--
-- Name: assessment_definition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.assessment_definition_id_seq OWNED BY public.assessment_definition.id;


--
-- Name: assessment_rating; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.assessment_rating (
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    assessment_definition_id bigint NOT NULL,
    rating_id bigint NOT NULL,
    description character varying(4000),
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) NOT NULL,
    is_readonly boolean DEFAULT false NOT NULL
);


ALTER TABLE public.assessment_rating OWNER TO waltz;

--
-- Name: TABLE assessment_rating; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.assessment_rating IS 'an individual rating, linking an entity (e.g. app) to an assessment and value';


--
-- Name: COLUMN assessment_rating.entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_rating.entity_id IS 'the entity id of the entity being assessed and rated';


--
-- Name: COLUMN assessment_rating.entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_rating.entity_kind IS 'the entity kind of the entity being assessed and rated (typically APPLICATION or CHANGE_INITIATVE)';


--
-- Name: COLUMN assessment_rating.assessment_definition_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_rating.assessment_definition_id IS 'reference to the assessment definition being assessed for this rating record';


--
-- Name: COLUMN assessment_rating.rating_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_rating.rating_id IS 'reference to the rating scheme item, providing the value of this assessment rating. Note: this should be one of the scheme items defined within the rating scheme of the assessment definition';


--
-- Name: COLUMN assessment_rating.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_rating.description IS 'optional user provided comment';


--
-- Name: COLUMN assessment_rating.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_rating.provenance IS 'where this rating came from.  Will be ''waltz'' if created via the UI';


--
-- Name: COLUMN assessment_rating.is_readonly; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.assessment_rating.is_readonly IS 'Specifically lock this rating, note the readonly value with the associated definition takes precedence';


--
-- Name: attestation_instance; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.attestation_instance (
    id bigint NOT NULL,
    attestation_run_id bigint NOT NULL,
    parent_entity_id bigint NOT NULL,
    parent_entity_kind character varying(64) NOT NULL,
    attested_at timestamp without time zone,
    attested_by character varying(255),
    attested_entity_kind character varying(64) NOT NULL
);


ALTER TABLE public.attestation_instance OWNER TO waltz;

--
-- Name: TABLE attestation_instance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.attestation_instance IS 'a specific attestation of an entity for a particular kind (e.g. an APPLICATION for LOGICAL_FLOWs)';


--
-- Name: COLUMN attestation_instance.attestation_run_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_instance.attestation_run_id IS 'reference to the attestation run which owns this instance';


--
-- Name: COLUMN attestation_instance.parent_entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_instance.parent_entity_id IS 'the identifier of the entity being attested';


--
-- Name: COLUMN attestation_instance.parent_entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_instance.parent_entity_kind IS 'the type of entity being attested';


--
-- Name: COLUMN attestation_instance.attested_at; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_instance.attested_at IS 'the date/time the attestation occured';


--
-- Name: COLUMN attestation_instance.attested_by; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_instance.attested_by IS 'who initiated the attestation';


--
-- Name: COLUMN attestation_instance.attested_entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_instance.attested_entity_kind IS 'what was being attested for the parent entity (typically: MEASURABLE, LOGICAL_FLOW, PHYSICAL_FLOW)';


--
-- Name: attestation_instance_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.attestation_instance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attestation_instance_id_seq OWNER TO waltz;

--
-- Name: attestation_instance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.attestation_instance_id_seq OWNED BY public.attestation_instance.id;


--
-- Name: attestation_instance_recipient; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.attestation_instance_recipient (
    id bigint NOT NULL,
    attestation_instance_id bigint NOT NULL,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.attestation_instance_recipient OWNER TO waltz;

--
-- Name: TABLE attestation_instance_recipient; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.attestation_instance_recipient IS 'associates an attestation instance to a user who is responsible for doing the attestation';


--
-- Name: COLUMN attestation_instance_recipient.attestation_instance_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_instance_recipient.attestation_instance_id IS 'reference to the attestation instance';


--
-- Name: COLUMN attestation_instance_recipient.user_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_instance_recipient.user_id IS 'the user responsible for doing the attestations';


--
-- Name: attestation_instance_recipient_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.attestation_instance_recipient_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attestation_instance_recipient_id_seq OWNER TO waltz;

--
-- Name: attestation_instance_recipient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.attestation_instance_recipient_id_seq OWNED BY public.attestation_instance_recipient.id;


--
-- Name: attestation_run; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.attestation_run (
    id bigint NOT NULL,
    target_entity_kind character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    selector_entity_kind character varying(64) NOT NULL,
    selector_entity_id bigint NOT NULL,
    selector_hierarchy_scope character varying(64) NOT NULL,
    involvement_kind_ids character varying(255) NOT NULL,
    issued_by character varying(255),
    issued_on date,
    due_date date NOT NULL,
    attested_entity_kind character varying(64) NOT NULL,
    attested_entity_id bigint,
    status character varying(64) DEFAULT 'ISSUED'::character varying NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL
);


ALTER TABLE public.attestation_run OWNER TO waltz;

--
-- Name: TABLE attestation_run; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.attestation_run IS 'an attestation run defines the parameters needed to orchestrate an attestation cycle against multiple entities';


--
-- Name: COLUMN attestation_run.target_entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.target_entity_kind IS 'the kind of entities which are being attested (i.e. APPLICATION or CHANGE_INITIAIVE)';


--
-- Name: COLUMN attestation_run.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.name IS 'display name for the run';


--
-- Name: COLUMN attestation_run.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.description IS 'descriptive text for the run. Markdown is supported';


--
-- Name: COLUMN attestation_run.selector_entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.selector_entity_kind IS 'the selector defines which entity is used to derive the set of entities (e.g. apps) being attested. This is the kind of that selector entity (e.g. ORG_UNIT)';


--
-- Name: COLUMN attestation_run.selector_entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.selector_entity_id IS 'the selector defines which entity is used to derive the set of entities (e.g. apps) being attested. This is the id of that selector entity (e.g. 32)';


--
-- Name: COLUMN attestation_run.selector_hierarchy_scope; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.selector_hierarchy_scope IS 'if the selector points at a hierarchical entity, this part indicates whether to match against EXACT, CHILDREN, or PARENT entities';


--
-- Name: COLUMN attestation_run.involvement_kind_ids; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.involvement_kind_ids IS 'attestation instances are issued against individuals via their involvement roles. This is a delimited list containing the involvement_kind identifiers';


--
-- Name: COLUMN attestation_run.issued_by; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.issued_by IS 'user id of the issuer';


--
-- Name: COLUMN attestation_run.issued_on; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.issued_on IS 'the date the attestation was issued';


--
-- Name: COLUMN attestation_run.due_date; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.due_date IS 'the date the attestations should be completed by';


--
-- Name: COLUMN attestation_run.attested_entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.attested_entity_kind IS 'indicates what releated entity is being attestated for the target entity kind.  e.g. LOGICAL_FLOW, MEASURABLE_CATEGORY';


--
-- Name: COLUMN attestation_run.attested_entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.attested_entity_id IS 'if the attested entity kind needs a qualifier then this optional identifier provides that (e.g. category 12)';


--
-- Name: COLUMN attestation_run.status; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.status IS 'status of the attestation run (one of: DRAFT, PENDING, ISSUING, ISSUED, INVALID)';


--
-- Name: COLUMN attestation_run.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.attestation_run.provenance IS 'where this run came from.  Will be ''waltz'' if created via the UI';


--
-- Name: attestation_run_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.attestation_run_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attestation_run_id_seq OWNER TO waltz;

--
-- Name: attestation_run_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.attestation_run_id_seq OWNED BY public.attestation_run.id;


--
-- Name: attribute_change; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.attribute_change (
    id bigint NOT NULL,
    change_unit_id bigint NOT NULL,
    type character varying(64) NOT NULL,
    new_value character varying(4000),
    old_value character varying(4000),
    name character varying(255) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.attribute_change OWNER TO waltz;

--
-- Name: attribute_change_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.attribute_change_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attribute_change_id_seq OWNER TO waltz;

--
-- Name: attribute_change_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.attribute_change_id_seq OWNED BY public.attribute_change.id;


--
-- Name: bookmark; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.bookmark (
    id bigint NOT NULL,
    title character varying(255),
    description character varying(4000),
    kind character varying(255),
    url character varying(500),
    parent_kind character varying(255),
    parent_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    is_required boolean DEFAULT false NOT NULL,
    is_restricted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.bookmark OWNER TO waltz;

--
-- Name: bookmark_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.bookmark_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bookmark_id_seq OWNER TO waltz;

--
-- Name: bookmark_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.bookmark_id_seq OWNED BY public.bookmark.id;


--
-- Name: change_initiative; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.change_initiative (
    id bigint NOT NULL,
    parent_id bigint,
    external_id character varying(128),
    name character varying(128) NOT NULL,
    kind character varying(64) DEFAULT 'PROGRAMME'::character varying NOT NULL,
    lifecycle_phase character varying(64) DEFAULT 'DEVELOPMENT'::character varying NOT NULL,
    description character varying(4000),
    last_update date,
    start_date date NOT NULL,
    end_date date NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    organisational_unit_id bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.change_initiative OWNER TO waltz;

--
-- Name: TABLE change_initiative; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.change_initiative IS 'represents an change initiative (with an entity_kind of ''CHANGE_INITIATIVE'')';


--
-- Name: COLUMN change_initiative.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_initiative.id IS 'unique identifier for this change initiative within waltz';


--
-- Name: COLUMN change_initiative.parent_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_initiative.parent_id IS 'the id of the parent change initiative';


--
-- Name: COLUMN change_initiative.external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_initiative.external_id IS 'external identifier for this change initiative';


--
-- Name: COLUMN change_initiative.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_initiative.name IS 'name of this change initiative';


--
-- Name: COLUMN change_initiative.kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_initiative.kind IS 'the type of change initiative this is (one of: PROJECT, PROGRAMME, INITIATIVE)';


--
-- Name: COLUMN change_initiative.lifecycle_phase; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_initiative.lifecycle_phase IS 'the current lifecycle phase of this change initiative (one of: CONCEPTUAL, DEVELOPMENT, PRODUCTION, RETIRED)';


--
-- Name: COLUMN change_initiative.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_initiative.description IS 'longer description to provide more information about this change initiative.  Markdown is supported';


--
-- Name: COLUMN change_initiative.last_update; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_initiative.last_update IS 'the date information in this change initiative record was last updated';


--
-- Name: COLUMN change_initiative.start_date; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_initiative.start_date IS 'the start date of this change initiative';


--
-- Name: COLUMN change_initiative.end_date; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_initiative.end_date IS 'the end date of this change initiative';


--
-- Name: COLUMN change_initiative.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_initiative.provenance IS 'origination of this change initiative record';


--
-- Name: COLUMN change_initiative.organisational_unit_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_initiative.organisational_unit_id IS 'reference to the owning organisational unit of this change initiative';


--
-- Name: change_log; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.change_log (
    id integer NOT NULL,
    parent_kind character varying(128) NOT NULL,
    parent_id bigint NOT NULL,
    message character varying(4000) NOT NULL,
    user_id character varying(128) NOT NULL,
    severity character varying(32) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    child_kind character varying(64),
    operation character varying(64) DEFAULT 'UNKNOWN'::character varying NOT NULL
);


ALTER TABLE public.change_log OWNER TO waltz;

--
-- Name: TABLE change_log; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.change_log IS 'tracks all the data changes made within waltz';


--
-- Name: COLUMN change_log.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_log.id IS 'unique identifier for this change log record within waltz';


--
-- Name: COLUMN change_log.parent_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_log.parent_kind IS 'the kind of entity this change log belongs to';


--
-- Name: COLUMN change_log.parent_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_log.parent_id IS 'the identifier of the entity this change log belongs to';


--
-- Name: COLUMN change_log.message; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_log.message IS 'a description of the change that has been made';


--
-- Name: COLUMN change_log.user_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_log.user_id IS 'the user responsible for making the change';


--
-- Name: COLUMN change_log.severity; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_log.severity IS 'the severity of the change log (one of: INFORMATION, WARNING, ERROR)';


--
-- Name: COLUMN change_log.created_at; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_log.created_at IS 'the datetime this entry was created';


--
-- Name: COLUMN change_log.child_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_log.child_kind IS 'the kind of entity this change relates to (e.g. LOGICAL_FLOW)';


--
-- Name: COLUMN change_log.operation; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_log.operation IS 'what sort of change was made (one of: ADD, ATTEST, REMOVE, UPDATE, UNKNOWN)';


--
-- Name: change_log_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.change_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.change_log_id_seq OWNER TO waltz;

--
-- Name: change_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.change_log_id_seq OWNED BY public.change_log.id;


--
-- Name: change_set; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.change_set (
    id bigint NOT NULL,
    parent_entity_kind character varying(64),
    parent_entity_id bigint,
    planned_date timestamp without time zone,
    entity_lifecycle_status character varying(64) DEFAULT 'ACTIVE'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    external_id character varying(200),
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.change_set OWNER TO waltz;

--
-- Name: TABLE change_set; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.change_set IS 'a logical grouping of smaller change units that belong to a parent entity';


--
-- Name: COLUMN change_set.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_set.id IS 'unique identifier for this change set record within waltz';


--
-- Name: COLUMN change_set.parent_entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_set.parent_entity_kind IS 'the kind of entity that owns this change set';


--
-- Name: COLUMN change_set.parent_entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_set.parent_entity_id IS 'the identifier for the entity that owns this change set';


--
-- Name: COLUMN change_set.planned_date; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_set.planned_date IS 'the planned date for the completion of the change set';


--
-- Name: COLUMN change_set.entity_lifecycle_status; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_set.entity_lifecycle_status IS 'the lifecycle state of this entity record (one of: ACTIVE, PENDING, REMOVED)';


--
-- Name: COLUMN change_set.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_set.name IS 'the name of this change set';


--
-- Name: COLUMN change_set.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_set.description IS 'longer description to provide more information about this change set.  Markdown is supported';


--
-- Name: COLUMN change_set.last_updated_at; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_set.last_updated_at IS 'the datetime this record was last updated';


--
-- Name: COLUMN change_set.last_updated_by; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_set.last_updated_by IS 'the last user to update this change set record';


--
-- Name: COLUMN change_set.external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_set.external_id IS 'external identifier for this change set';


--
-- Name: COLUMN change_set.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_set.provenance IS 'origination of this change set record';


--
-- Name: change_set_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.change_set_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.change_set_id_seq OWNER TO waltz;

--
-- Name: change_set_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.change_set_id_seq OWNED BY public.change_set.id;


--
-- Name: change_unit; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.change_unit (
    id bigint NOT NULL,
    change_set_id bigint,
    subject_entity_kind character varying(64) NOT NULL,
    subject_entity_id bigint NOT NULL,
    subject_initial_status character varying(64) NOT NULL,
    action character varying(64) NOT NULL,
    execution_status character varying(64) DEFAULT 'PENDING'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    external_id character varying(200),
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.change_unit OWNER TO waltz;

--
-- Name: TABLE change_unit; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.change_unit IS 'a smaller unit of change that describes an activation, retirement or modification of an entity';


--
-- Name: COLUMN change_unit.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.id IS 'unique identifier for this change unit record within waltz';


--
-- Name: COLUMN change_unit.change_set_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.change_set_id IS 'the reference to the change set that this change unit belongs to';


--
-- Name: COLUMN change_unit.subject_entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.subject_entity_kind IS 'the kind of entity that is being changed';


--
-- Name: COLUMN change_unit.subject_entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.subject_entity_id IS 'the entity which is being changed';


--
-- Name: COLUMN change_unit.subject_initial_status; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.subject_initial_status IS 'the lifecycle status of the entity before the change (one of: ACTIVE, PENDING, REMOVED)';


--
-- Name: COLUMN change_unit.action; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.action IS 'describes the type of change taking place (one of: ACTIVATE, RETIRE, MODIFY)';


--
-- Name: COLUMN change_unit.execution_status; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.execution_status IS 'the state of the change unit (one of:  PENDING, COMPLETE, DISCARDED)';


--
-- Name: COLUMN change_unit.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.name IS 'the name of this change unit';


--
-- Name: COLUMN change_unit.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.description IS 'longer description to provide more information about this change set.  Markdown is supported';


--
-- Name: COLUMN change_unit.last_updated_at; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.last_updated_at IS 'the datetime this change unit record was last updated';


--
-- Name: COLUMN change_unit.last_updated_by; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.last_updated_by IS 'the last user to update this change unit record';


--
-- Name: COLUMN change_unit.external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.external_id IS 'external identifier for this change unit';


--
-- Name: COLUMN change_unit.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.change_unit.provenance IS 'origination of this change unit record';


--
-- Name: change_unit_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.change_unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.change_unit_id_seq OWNER TO waltz;

--
-- Name: change_unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.change_unit_id_seq OWNED BY public.change_unit.id;


--
-- Name: client_cache_key; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.client_cache_key (
    key character varying(255) NOT NULL,
    guid character varying(64) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.client_cache_key OWNER TO waltz;

--
-- Name: complexity; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.complexity (
    id bigint NOT NULL,
    complexity_kind_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    score numeric(10,3) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL
);


ALTER TABLE public.complexity OWNER TO waltz;

--
-- Name: TABLE complexity; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.complexity IS 'a score of a given complexity kind for an entity in waltz';


--
-- Name: COLUMN complexity.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity.id IS 'unique identifier for this complexity record within waltz';


--
-- Name: COLUMN complexity.complexity_kind_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity.complexity_kind_id IS 'the reference to the complexity kind that describes this score';


--
-- Name: COLUMN complexity.entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity.entity_id IS 'the identifier for the entity this score belongs to';


--
-- Name: COLUMN complexity.entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity.entity_kind IS 'the kind of the entity this score belongs to';


--
-- Name: COLUMN complexity.score; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity.score IS 'the value of the complexity, the value should fall between 0 and 1 indicating proximity to a baseline (up to 3 decimal places)';


--
-- Name: COLUMN complexity.last_updated_at; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity.last_updated_at IS 'the datetime this complexity record was last updated';


--
-- Name: COLUMN complexity.last_updated_by; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity.last_updated_by IS 'the last user to update this complexity record';


--
-- Name: COLUMN complexity.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity.provenance IS 'origination of this change unit record';


--
-- Name: complexity_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.complexity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.complexity_id_seq OWNER TO waltz;

--
-- Name: complexity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.complexity_id_seq OWNED BY public.complexity.id;


--
-- Name: complexity_kind; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.complexity_kind (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    external_id character varying(200),
    is_default boolean DEFAULT false NOT NULL
);


ALTER TABLE public.complexity_kind OWNER TO waltz;

--
-- Name: TABLE complexity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.complexity_kind IS 'complexity can be used to give a decimal score for an entity in waltz against a complexity kind (e.g. Flow Complexity). The complexity kind describes the type of complexity being evaluated.';


--
-- Name: COLUMN complexity_kind.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity_kind.id IS 'unique identifier for this complexity kind record within waltz';


--
-- Name: COLUMN complexity_kind.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity_kind.name IS 'the name of this complexity kind';


--
-- Name: COLUMN complexity_kind.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity_kind.description IS 'longer description to provide more information about this complexity kind';


--
-- Name: COLUMN complexity_kind.external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity_kind.external_id IS 'external identifier for this complexity kind';


--
-- Name: COLUMN complexity_kind.is_default; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.complexity_kind.is_default IS 'indicates the complexity kind to be shown on the entity overview by default';


--
-- Name: complexity_kind_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.complexity_kind_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.complexity_kind_id_seq OWNER TO waltz;

--
-- Name: complexity_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.complexity_kind_id_seq OWNED BY public.complexity_kind.id;


--
-- Name: complexity_score_old; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.complexity_score_old (
    entity_kind character varying(128) NOT NULL,
    entity_id bigint NOT NULL,
    complexity_kind character varying(64) NOT NULL,
    score numeric(10,3) NOT NULL
);


ALTER TABLE public.complexity_score_old OWNER TO waltz;

--
-- Name: cost; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.cost (
    id bigint NOT NULL,
    cost_kind_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    year integer NOT NULL,
    amount numeric(16,2) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL
);


ALTER TABLE public.cost OWNER TO waltz;

--
-- Name: TABLE cost; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.cost IS 'cost value belonging to an entity, given for a specified kind';


--
-- Name: COLUMN cost.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost.id IS 'unique identifier for this cost record within waltz';


--
-- Name: COLUMN cost.cost_kind_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost.cost_kind_id IS 'the type of cost the value relates to';


--
-- Name: COLUMN cost.entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost.entity_id IS 'the identifier for the entity the cost belongs to';


--
-- Name: COLUMN cost.entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost.entity_kind IS 'the kind of entity the cost belongs to';


--
-- Name: COLUMN cost.year; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost.year IS 'the year the cost value relates to';


--
-- Name: COLUMN cost.amount; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost.amount IS 'the value of the cost (2 decimal places)';


--
-- Name: COLUMN cost.last_updated_at; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost.last_updated_at IS 'the datetime this cost record was last updated';


--
-- Name: COLUMN cost.last_updated_by; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost.last_updated_by IS 'the last user to update this cost record';


--
-- Name: COLUMN cost.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost.provenance IS 'origination of this cost record';


--
-- Name: cost_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.cost_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cost_id_seq OWNER TO waltz;

--
-- Name: cost_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.cost_id_seq OWNED BY public.cost.id;


--
-- Name: cost_kind; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.cost_kind (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    is_default boolean DEFAULT false NOT NULL,
    external_id character varying(200) NOT NULL
);


ALTER TABLE public.cost_kind OWNER TO waltz;

--
-- Name: TABLE cost_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.cost_kind IS 'different types of cost can be linked to an entity in waltz, the cost kind describes the type';


--
-- Name: COLUMN cost_kind.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost_kind.id IS 'unique identifier for this cost kind record within waltz';


--
-- Name: COLUMN cost_kind.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost_kind.name IS 'the name of the cost kind';


--
-- Name: COLUMN cost_kind.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost_kind.description IS 'longer description to provide more information about this cost kind';


--
-- Name: COLUMN cost_kind.is_default; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost_kind.is_default IS 'indicates the cost kind to be shown on the entity overview by default';


--
-- Name: COLUMN cost_kind.external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.cost_kind.external_id IS 'external identifier for this cost kind';


--
-- Name: cost_kind_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.cost_kind_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cost_kind_id_seq OWNER TO waltz;

--
-- Name: cost_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.cost_kind_id_seq OWNED BY public.cost_kind.id;


--
-- Name: custom_environment; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.custom_environment (
    id bigint NOT NULL,
    owning_entity_id bigint NOT NULL,
    owning_entity_kind character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    external_id character varying(200) NOT NULL,
    group_name character varying(255) DEFAULT 'Default'::character varying NOT NULL
);


ALTER TABLE public.custom_environment OWNER TO waltz;

--
-- Name: custom_environment_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.custom_environment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.custom_environment_id_seq OWNER TO waltz;

--
-- Name: custom_environment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.custom_environment_id_seq OWNED BY public.custom_environment.id;


--
-- Name: custom_environment_usage; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.custom_environment_usage (
    id bigint NOT NULL,
    custom_environment_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by character varying(255) NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL
);


ALTER TABLE public.custom_environment_usage OWNER TO waltz;

--
-- Name: custom_environment_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.custom_environment_usage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.custom_environment_usage_id_seq OWNER TO waltz;

--
-- Name: custom_environment_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.custom_environment_usage_id_seq OWNED BY public.custom_environment_usage.id;


--
-- Name: logical_flow; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.logical_flow (
    source_entity_kind character varying(128) NOT NULL,
    source_entity_id bigint NOT NULL,
    target_entity_kind character varying(128) NOT NULL,
    target_entity_id bigint NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    id bigint NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    last_attested_at timestamp without time zone,
    last_attested_by character varying(255),
    entity_lifecycle_status character varying(64) DEFAULT 'ACTIVE'::character varying NOT NULL,
    is_removed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by character varying(255) NOT NULL,
    is_readonly boolean DEFAULT false NOT NULL
);


ALTER TABLE public.logical_flow OWNER TO waltz;

--
-- Name: data_flow_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.data_flow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.data_flow_id_seq OWNER TO waltz;

--
-- Name: data_flow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.data_flow_id_seq OWNED BY public.logical_flow.id;


--
-- Name: data_type; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.data_type (
    code character varying(128) NOT NULL,
    name character varying(256) NOT NULL,
    description character varying(4000),
    id bigint NOT NULL,
    parent_id bigint,
    concrete boolean DEFAULT true NOT NULL,
    unknown boolean DEFAULT false NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deprecated boolean DEFAULT false NOT NULL
);


ALTER TABLE public.data_type OWNER TO waltz;

--
-- Name: data_type_usage; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.data_type_usage (
    entity_kind character varying(128) NOT NULL,
    entity_id bigint NOT NULL,
    usage_kind character varying(128) NOT NULL,
    description character varying(2048) DEFAULT ''::character varying NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    is_selected boolean,
    data_type_id bigint NOT NULL
);


ALTER TABLE public.data_type_usage OWNER TO waltz;

--
-- Name: database_information; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.database_information (
    id bigint NOT NULL,
    database_name character varying(255) DEFAULT 'waltz'::character varying NOT NULL,
    instance_name character varying(255) DEFAULT 'waltz'::character varying NOT NULL,
    dbms_vendor character varying(255) NOT NULL,
    dbms_name character varying(255) NOT NULL,
    dbms_version character varying(128) NOT NULL,
    external_id character varying(200) DEFAULT 'waltz'::character varying,
    end_of_life_date date,
    lifecycle_status character varying(64),
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL
);


ALTER TABLE public.database_information OWNER TO waltz;

--
-- Name: database_information_2_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.database_information_2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.database_information_2_id_seq OWNER TO waltz;

--
-- Name: database_information_2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.database_information_2_id_seq OWNED BY public.database_information.id;


--
-- Name: database_usage; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.database_usage (
    id bigint NOT NULL,
    database_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    entity_id bigint NOT NULL,
    environment character varying(64) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.database_usage OWNER TO waltz;

--
-- Name: database_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.database_usage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.database_usage_id_seq OWNER TO waltz;

--
-- Name: database_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.database_usage_id_seq OWNED BY public.database_usage.id;


--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO waltz;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO waltz;

--
-- Name: end_user_application; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.end_user_application (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    kind character varying(128) DEFAULT 'MS_EXCEL'::character varying NOT NULL,
    lifecycle_phase character varying(128) DEFAULT 'PRODUCTION'::character varying NOT NULL,
    risk_rating character varying(128) DEFAULT 'MEDIUM'::character varying NOT NULL,
    organisational_unit_id bigint NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    external_id character varying(200),
    is_promoted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.end_user_application OWNER TO waltz;

--
-- Name: entity_alias; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_alias (
    id bigint NOT NULL,
    alias character varying(255) NOT NULL,
    kind character varying(128) DEFAULT 'APPLICATION'::character varying NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL
);


ALTER TABLE public.entity_alias OWNER TO waltz;

--
-- Name: entity_enum_definition; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_enum_definition (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    icon_name character varying(64) DEFAULT 'fw'::character varying NOT NULL,
    entity_kind character varying(64) NOT NULL,
    enum_value_type character varying(64) NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    is_editable boolean DEFAULT false NOT NULL
);


ALTER TABLE public.entity_enum_definition OWNER TO waltz;

--
-- Name: TABLE entity_enum_definition; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.entity_enum_definition IS 'Store entity enum definitions';


--
-- Name: COLUMN entity_enum_definition.icon_name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.entity_enum_definition.icon_name IS 'The default value fw, stands for fixed-width which acts like a spacer icon';


--
-- Name: entity_enum_definition_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.entity_enum_definition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entity_enum_definition_id_seq OWNER TO waltz;

--
-- Name: entity_enum_definition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.entity_enum_definition_id_seq OWNED BY public.entity_enum_definition.id;


--
-- Name: entity_enum_value; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_enum_value (
    definition_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    entity_id bigint NOT NULL,
    enum_value_key character varying(64) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.entity_enum_value OWNER TO waltz;

--
-- Name: TABLE entity_enum_value; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.entity_enum_value IS 'Store entity enum values';


--
-- Name: entity_field_reference; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_field_reference (
    id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    field_name character varying(64) NOT NULL,
    display_name character varying(255) NOT NULL,
    description character varying(4000) NOT NULL
);


ALTER TABLE public.entity_field_reference OWNER TO waltz;

--
-- Name: entity_field_reference_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

ALTER TABLE public.entity_field_reference ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.entity_field_reference_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: entity_hierarchy; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_hierarchy (
    kind character varying(128) NOT NULL,
    id bigint NOT NULL,
    ancestor_id bigint,
    level integer NOT NULL,
    descendant_level integer DEFAULT 0
);


ALTER TABLE public.entity_hierarchy OWNER TO waltz;

--
-- Name: TABLE entity_hierarchy; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.entity_hierarchy IS 'a bridge (or closure) table which stores information for quick hierarchy traversals';


--
-- Name: COLUMN entity_hierarchy.kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.entity_hierarchy.kind IS 'type of entity this record represents (ORG_UNIT, MEASURABLE, etc)';


--
-- Name: COLUMN entity_hierarchy.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.entity_hierarchy.id IS 'the id of the descendant (lower) entity in the hierarchy';


--
-- Name: COLUMN entity_hierarchy.ancestor_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.entity_hierarchy.ancestor_id IS 'the id of the ancestor (higher) entity in the hierarchy';


--
-- Name: COLUMN entity_hierarchy.level; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.entity_hierarchy.level IS 'the depth of the ancestor';


--
-- Name: COLUMN entity_hierarchy.descendant_level; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.entity_hierarchy.descendant_level IS 'the depth of the descendant';


--
-- Name: entity_named_note; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_named_note (
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    named_note_type_id bigint NOT NULL,
    note_text character varying NOT NULL,
    provenance character varying(64) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL
);


ALTER TABLE public.entity_named_note OWNER TO waltz;

--
-- Name: TABLE entity_named_note; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.entity_named_note IS 'Named notes associated with entities';


--
-- Name: entity_named_note_type; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_named_note_type (
    id bigint NOT NULL,
    applicable_entity_kinds character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000) NOT NULL,
    is_readonly boolean DEFAULT false NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    external_id character varying(200)
);


ALTER TABLE public.entity_named_note_type OWNER TO waltz;

--
-- Name: TABLE entity_named_note_type; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.entity_named_note_type IS 'Named note types that can associated with entities';


--
-- Name: entity_named_note_type_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.entity_named_note_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entity_named_note_type_id_seq OWNER TO waltz;

--
-- Name: entity_named_note_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.entity_named_note_type_id_seq OWNED BY public.entity_named_note_type.id;


--
-- Name: entity_relationship; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_relationship (
    kind_a character varying(128) NOT NULL,
    id_a bigint NOT NULL,
    kind_b character varying(128) NOT NULL,
    id_b bigint NOT NULL,
    relationship character varying(128) NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    description character varying(4000),
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) DEFAULT 'admin'::character varying NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.entity_relationship OWNER TO waltz;

--
-- Name: entity_relationship_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.entity_relationship_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entity_relationship_id_seq OWNER TO waltz;

--
-- Name: entity_relationship_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.entity_relationship_id_seq OWNED BY public.entity_relationship.id;


--
-- Name: entity_statistic_definition; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_statistic_definition (
    name character varying(128) NOT NULL,
    description character varying(4000),
    type character varying(128) NOT NULL,
    category character varying(128) NOT NULL,
    active boolean NOT NULL,
    renderer character varying(128) NOT NULL,
    historic_renderer character varying(128) NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    parent_id bigint,
    id bigint NOT NULL,
    entity_visibility boolean DEFAULT true NOT NULL,
    rollup_visibility boolean DEFAULT true NOT NULL,
    rollup_kind character varying(64) DEFAULT 'COUNT_BY_ENTITY'::character varying NOT NULL
);


ALTER TABLE public.entity_statistic_definition OWNER TO waltz;

--
-- Name: entity_statistic_value; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_statistic_value (
    id bigint NOT NULL,
    statistic_id bigint NOT NULL,
    entity_kind character varying(128) NOT NULL,
    entity_id bigint NOT NULL,
    value character varying(128),
    outcome character varying(128) NOT NULL,
    state character varying(128) NOT NULL,
    reason character varying(4000),
    created_at timestamp without time zone NOT NULL,
    current boolean NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL
);


ALTER TABLE public.entity_statistic_value OWNER TO waltz;

--
-- Name: entity_statistic_value_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.entity_statistic_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entity_statistic_value_id_seq OWNER TO waltz;

--
-- Name: entity_statistic_value_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.entity_statistic_value_id_seq OWNED BY public.entity_statistic_value.id;


--
-- Name: entity_svg_diagram; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_svg_diagram (
    id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    entity_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    svg text NOT NULL,
    description character varying(4000),
    provenance character varying(64) NOT NULL,
    external_id character varying(200)
);


ALTER TABLE public.entity_svg_diagram OWNER TO waltz;

--
-- Name: TABLE entity_svg_diagram; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.entity_svg_diagram IS 'SVG diagrams associated to a specific entity';


--
-- Name: entity_svg_diagram_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.entity_svg_diagram_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entity_svg_diagram_id_seq OWNER TO waltz;

--
-- Name: entity_svg_diagram_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.entity_svg_diagram_id_seq OWNED BY public.entity_svg_diagram.id;


--
-- Name: entity_tag; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_tag (
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    tag character varying(255) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.entity_tag OWNER TO waltz;

--
-- Name: TABLE entity_tag; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.entity_tag IS 'Allows for association of zero or more tags with entities';


--
-- Name: entity_workflow_definition; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_workflow_definition (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000)
);


ALTER TABLE public.entity_workflow_definition OWNER TO waltz;

--
-- Name: TABLE entity_workflow_definition; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.entity_workflow_definition IS 'Store entity workflow definitions';


--
-- Name: entity_workflow_definition_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.entity_workflow_definition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entity_workflow_definition_id_seq OWNER TO waltz;

--
-- Name: entity_workflow_definition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.entity_workflow_definition_id_seq OWNED BY public.entity_workflow_definition.id;


--
-- Name: entity_workflow_state; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_workflow_state (
    workflow_id bigint,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    state character varying(64) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) NOT NULL,
    description character varying(4000)
);


ALTER TABLE public.entity_workflow_state OWNER TO waltz;

--
-- Name: TABLE entity_workflow_state; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.entity_workflow_state IS 'Store entity workflow states';


--
-- Name: entity_workflow_transition; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.entity_workflow_transition (
    workflow_id bigint,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    from_state character varying(64),
    to_state character varying(64) NOT NULL,
    reason character varying(4000),
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.entity_workflow_transition OWNER TO waltz;

--
-- Name: TABLE entity_workflow_transition; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.entity_workflow_transition IS 'Store entity workflow transitions';


--
-- Name: enum_value; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.enum_value (
    type character varying(64) NOT NULL,
    key character varying(64) NOT NULL,
    display_name character varying(255) NOT NULL,
    description character varying(4000) NOT NULL,
    icon_name character varying(64) DEFAULT 'fw'::character varying NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    icon_color character varying(64) DEFAULT 'none'::character varying NOT NULL
);


ALTER TABLE public.enum_value OWNER TO waltz;

--
-- Name: TABLE enum_value; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.enum_value IS 'Store enum values - display names, descriptions and icon names';


--
-- Name: COLUMN enum_value.icon_name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.enum_value.icon_name IS 'The default value fw, stands for fixed-width which acts like a spacer icon';


--
-- Name: enum_value_alias; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.enum_value_alias (
    enum_type character varying(64) NOT NULL,
    enum_key character varying(64) NOT NULL,
    alias character varying(255) NOT NULL
);


ALTER TABLE public.enum_value_alias OWNER TO waltz;

--
-- Name: external_identifier; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.external_identifier (
    entity_kind character varying(64) NOT NULL,
    entity_id bigint NOT NULL,
    system character varying(64) NOT NULL,
    external_id character varying(200) NOT NULL
);


ALTER TABLE public.external_identifier OWNER TO waltz;

--
-- Name: flow_classification; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.flow_classification (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    code character varying(200) NOT NULL,
    color character varying(255) NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    is_custom boolean DEFAULT true NOT NULL,
    user_selectable boolean DEFAULT true NOT NULL
);


ALTER TABLE public.flow_classification OWNER TO waltz;

--
-- Name: flow_classification_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.flow_classification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.flow_classification_id_seq OWNER TO waltz;

--
-- Name: flow_classification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.flow_classification_id_seq OWNED BY public.flow_classification.id;


--
-- Name: flow_classification_rule; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.flow_classification_rule (
    id bigint NOT NULL,
    parent_kind character varying(64) NOT NULL,
    parent_id bigint NOT NULL,
    application_id bigint NOT NULL,
    data_type_id bigint NOT NULL,
    flow_classification_id bigint NOT NULL,
    description character varying(4000),
    external_id character varying(200),
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) DEFAULT 'admin'::character varying NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    is_readonly boolean DEFAULT false NOT NULL
);


ALTER TABLE public.flow_classification_rule OWNER TO waltz;

--
-- Name: flow_classification_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.flow_classification_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.flow_classification_rule_id_seq OWNER TO waltz;

--
-- Name: flow_classification_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.flow_classification_rule_id_seq OWNED BY public.flow_classification_rule.id;


--
-- Name: flow_diagram; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.flow_diagram (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    layout_data text NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    is_removed boolean DEFAULT false NOT NULL,
    editor_role character varying(64)
);


ALTER TABLE public.flow_diagram OWNER TO waltz;

--
-- Name: TABLE flow_diagram; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.flow_diagram IS 'The flow diagram table represents the metadata and layout data associated with a flow diagram';


--
-- Name: flow_diagram_annotation; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.flow_diagram_annotation (
    annotation_id character varying(64) NOT NULL,
    diagram_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    note character varying(4000) NOT NULL
);


ALTER TABLE public.flow_diagram_annotation OWNER TO waltz;

--
-- Name: TABLE flow_diagram_annotation; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.flow_diagram_annotation IS 'Annotations associated with a specific flow diagram';


--
-- Name: flow_diagram_entity; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.flow_diagram_entity (
    diagram_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    is_notable boolean DEFAULT false
);


ALTER TABLE public.flow_diagram_entity OWNER TO waltz;

--
-- Name: TABLE flow_diagram_entity; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.flow_diagram_entity IS 'A Bill of Materials (BoM) for a flow diagram';


--
-- Name: flow_diagram_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.flow_diagram_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.flow_diagram_id_seq OWNER TO waltz;

--
-- Name: flow_diagram_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.flow_diagram_id_seq OWNED BY public.flow_diagram.id;


--
-- Name: flow_diagram_overlay_group; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.flow_diagram_overlay_group (
    id bigint NOT NULL,
    flow_diagram_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    external_id character varying(200) NOT NULL,
    is_default boolean DEFAULT false NOT NULL
);


ALTER TABLE public.flow_diagram_overlay_group OWNER TO waltz;

--
-- Name: flow_diagram_overlay_group_entry; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.flow_diagram_overlay_group_entry (
    id bigint NOT NULL,
    overlay_group_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    symbol character varying(64) NOT NULL,
    fill character varying(64) NOT NULL,
    stroke character varying(64) NOT NULL
);


ALTER TABLE public.flow_diagram_overlay_group_entry OWNER TO waltz;

--
-- Name: flow_diagram_overlay_group_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.flow_diagram_overlay_group_entry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.flow_diagram_overlay_group_entry_id_seq OWNER TO waltz;

--
-- Name: flow_diagram_overlay_group_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.flow_diagram_overlay_group_entry_id_seq OWNED BY public.flow_diagram_overlay_group_entry.id;


--
-- Name: flow_diagram_overlay_group_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.flow_diagram_overlay_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.flow_diagram_overlay_group_id_seq OWNER TO waltz;

--
-- Name: flow_diagram_overlay_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.flow_diagram_overlay_group_id_seq OWNED BY public.flow_diagram_overlay_group.id;


--
-- Name: involvement; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.involvement (
    entity_kind character varying(128) NOT NULL,
    entity_id bigint NOT NULL,
    employee_id character varying(128) NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    kind_id bigint NOT NULL,
    is_readonly boolean DEFAULT true NOT NULL
);


ALTER TABLE public.involvement OWNER TO waltz;

--
-- Name: TABLE involvement; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.involvement IS 'defines a specific instance of an involvement kind between a person and an entity (e.g. ''User X'' is ''IT Owner'' for ''APPLICATION/32'')';


--
-- Name: COLUMN involvement.entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement.entity_kind IS 'the kind of entity the person is involved with';


--
-- Name: COLUMN involvement.entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement.entity_id IS 'the identifier of the entity the person is involved with';


--
-- Name: COLUMN involvement.employee_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement.employee_id IS 'reference to the person involved with the entity';


--
-- Name: COLUMN involvement.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement.provenance IS 'where did this involvement record originate, will be ''waltz'' if provided via the UI';


--
-- Name: COLUMN involvement.kind_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement.kind_id IS 'the type of involvement between the person and the entity (e.g. ''IT Owner'')';


--
-- Name: COLUMN involvement.is_readonly; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement.is_readonly IS 'can this involvement be edited/removed by users (e.g. set to true if externally mastered)';


--
-- Name: involvement_group; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.involvement_group (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    external_id character varying(200) NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.involvement_group OWNER TO waltz;

--
-- Name: TABLE involvement_group; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.involvement_group IS 'collection of involvement kinds';


--
-- Name: COLUMN involvement_group.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement_group.id IS 'unique identifier for this involvement group within waltz';


--
-- Name: COLUMN involvement_group.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement_group.name IS 'name of this involvement group';


--
-- Name: COLUMN involvement_group.external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement_group.external_id IS 'external identifier for this involvement group';


--
-- Name: COLUMN involvement_group.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement_group.provenance IS 'origination of this involvement group';


--
-- Name: involvement_group_entry; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.involvement_group_entry (
    involvement_group_id bigint NOT NULL,
    involvement_kind_id bigint NOT NULL
);


ALTER TABLE public.involvement_group_entry OWNER TO waltz;

--
-- Name: TABLE involvement_group_entry; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.involvement_group_entry IS 'describes the association of an involvement kind to an involvement group';


--
-- Name: COLUMN involvement_group_entry.involvement_group_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement_group_entry.involvement_group_id IS 'identifier of the group this involvement kind is included in';


--
-- Name: COLUMN involvement_group_entry.involvement_kind_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement_group_entry.involvement_kind_id IS 'identifier of the involvement kind this entry refers to';


--
-- Name: involvement_group_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.involvement_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.involvement_group_id_seq OWNER TO waltz;

--
-- Name: involvement_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.involvement_group_id_seq OWNED BY public.involvement_group.id;


--
-- Name: involvement_kind; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.involvement_kind (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now(),
    last_updated_by character varying(255) NOT NULL,
    external_id character varying(200),
    user_selectable boolean DEFAULT true NOT NULL
);


ALTER TABLE public.involvement_kind OWNER TO waltz;

--
-- Name: TABLE involvement_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.involvement_kind IS 'defines a particular type of involvement a person may have in relation to an entity (e.g. IT Owner for an APPLICATION)';


--
-- Name: COLUMN involvement_kind.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement_kind.name IS 'display name for the involvement kind';


--
-- Name: COLUMN involvement_kind.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement_kind.description IS 'longer textual description of the involvement';


--
-- Name: COLUMN involvement_kind.external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement_kind.external_id IS 'external identifier, typically used when external jobs are updating the associated involvements';


--
-- Name: COLUMN involvement_kind.user_selectable; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.involvement_kind.user_selectable IS 'flag to allow users to add people to an entity with this involvement (set to false to restrict usage, i.e. if involvement is mastered in another system)';


--
-- Name: involvement_kind_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.involvement_kind_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.involvement_kind_id_seq OWNER TO waltz;

--
-- Name: involvement_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.involvement_kind_id_seq OWNED BY public.actor.id;


--
-- Name: involvement_kind_id_seq1; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.involvement_kind_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.involvement_kind_id_seq1 OWNER TO waltz;

--
-- Name: involvement_kind_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.involvement_kind_id_seq1 OWNED BY public.involvement_kind.id;


--
-- Name: key_involvement_kind; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.key_involvement_kind (
    involvement_kind_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL
);


ALTER TABLE public.key_involvement_kind OWNER TO waltz;

--
-- Name: TABLE key_involvement_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.key_involvement_kind IS 'Key Involvement Kind For Entity Kind';


--
-- Name: licence; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.licence (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    external_id character varying(200),
    approval_status character varying(64),
    created_by character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.licence OWNER TO waltz;

--
-- Name: licence_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.licence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.licence_id_seq OWNER TO waltz;

--
-- Name: licence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.licence_id_seq OWNED BY public.licence.id;


--
-- Name: logical_data_element; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.logical_data_element (
    id bigint NOT NULL,
    external_id character varying(200),
    name character varying(255) NOT NULL,
    description character varying(4000),
    type character varying(64) NOT NULL,
    provenance character varying(64) NOT NULL,
    entity_lifecycle_status character varying(64) DEFAULT 'ACTIVE'::character varying NOT NULL,
    parent_data_type_id bigint DEFAULT '-1'::integer NOT NULL
);


ALTER TABLE public.logical_data_element OWNER TO waltz;

--
-- Name: logical_data_element_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.logical_data_element_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logical_data_element_id_seq OWNER TO waltz;

--
-- Name: logical_data_element_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.logical_data_element_id_seq OWNED BY public.logical_data_element.id;


--
-- Name: logical_flow_decorator; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.logical_flow_decorator (
    logical_flow_id bigint NOT NULL,
    decorator_entity_kind character varying(128) NOT NULL,
    decorator_entity_id bigint NOT NULL,
    rating character varying(32) DEFAULT 'NO_OPINION'::character varying NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    id bigint NOT NULL,
    is_readonly boolean DEFAULT false NOT NULL,
    flow_classification_rule_id bigint
);


ALTER TABLE public.logical_flow_decorator OWNER TO waltz;

--
-- Name: logical_flow_decorator_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.logical_flow_decorator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logical_flow_decorator_id_seq OWNER TO waltz;

--
-- Name: logical_flow_decorator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.logical_flow_decorator_id_seq OWNED BY public.logical_flow_decorator.id;


--
-- Name: measurable; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.measurable (
    id bigint NOT NULL,
    parent_id bigint,
    name character varying(255) NOT NULL,
    concrete boolean DEFAULT true NOT NULL,
    description character varying(4000) NOT NULL,
    external_id character varying(200),
    last_updated_at timestamp without time zone DEFAULT now(),
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) NOT NULL,
    measurable_category_id bigint,
    external_parent_id character varying(200),
    entity_lifecycle_status character varying(64) DEFAULT 'ACTIVE'::character varying NOT NULL,
    organisational_unit_id bigint
);


ALTER TABLE public.measurable OWNER TO waltz;

--
-- Name: COLUMN measurable.organisational_unit_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.measurable.organisational_unit_id IS 'The, optional, owner of this measurable';


--
-- Name: measurable_category; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.measurable_category (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000) NOT NULL,
    external_id character varying(200),
    last_updated_at timestamp without time zone DEFAULT now(),
    last_updated_by character varying(255) NOT NULL,
    rating_scheme_id bigint NOT NULL,
    editable boolean DEFAULT false NOT NULL,
    rating_editor_role character varying(64) DEFAULT 'RATING_EDITOR'::character varying NOT NULL,
    constraining_assessment_definition_id bigint
);


ALTER TABLE public.measurable_category OWNER TO waltz;

--
-- Name: measurable_category_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.measurable_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.measurable_category_id_seq OWNER TO waltz;

--
-- Name: measurable_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.measurable_category_id_seq OWNED BY public.measurable_category.id;


--
-- Name: measurable_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.measurable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.measurable_id_seq OWNER TO waltz;

--
-- Name: measurable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.measurable_id_seq OWNED BY public.measurable.id;


--
-- Name: measurable_rating; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.measurable_rating (
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    measurable_id bigint NOT NULL,
    rating character(1) DEFAULT 'Z'::bpchar NOT NULL,
    description character varying(4000),
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) NOT NULL,
    is_readonly boolean DEFAULT false NOT NULL
);


ALTER TABLE public.measurable_rating OWNER TO waltz;

--
-- Name: measurable_rating_planned_decommission; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.measurable_rating_planned_decommission (
    id bigint NOT NULL,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    measurable_id bigint NOT NULL,
    planned_decommission_date date NOT NULL,
    created_by character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_by character varying(255) NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.measurable_rating_planned_decommission OWNER TO waltz;

--
-- Name: measurable_rating_planned_decommission_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.measurable_rating_planned_decommission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.measurable_rating_planned_decommission_id_seq OWNER TO waltz;

--
-- Name: measurable_rating_planned_decommission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.measurable_rating_planned_decommission_id_seq OWNED BY public.measurable_rating_planned_decommission.id;


--
-- Name: measurable_rating_replacement; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.measurable_rating_replacement (
    id bigint NOT NULL,
    decommission_id bigint NOT NULL,
    planned_commission_date date NOT NULL,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    created_by character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_by character varying(255) NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.measurable_rating_replacement OWNER TO waltz;

--
-- Name: measurable_rating_replacement_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.measurable_rating_replacement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.measurable_rating_replacement_id_seq OWNER TO waltz;

--
-- Name: measurable_rating_replacement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.measurable_rating_replacement_id_seq OWNED BY public.measurable_rating_replacement.id;


--
-- Name: organisational_unit; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.organisational_unit (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(4000),
    parent_id bigint,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_at timestamp without time zone NOT NULL,
    external_id character varying(200),
    created_by character varying(255) DEFAULT 'waltz'::character varying NOT NULL,
    last_updated_by character varying(255) DEFAULT 'waltz'::character varying NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL
);


ALTER TABLE public.organisational_unit OWNER TO waltz;

--
-- Name: permission_group; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.permission_group (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    external_id character varying(200) NOT NULL,
    description character varying(4000),
    provenance character varying(64) NOT NULL,
    is_default boolean DEFAULT true NOT NULL
);


ALTER TABLE public.permission_group OWNER TO waltz;

--
-- Name: TABLE permission_group; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.permission_group IS 'group describing the permissions different involvement kinds have against waltz entities';


--
-- Name: COLUMN permission_group.id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group.id IS 'unique identifier for this cost record within waltz';


--
-- Name: COLUMN permission_group.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group.name IS 'name of the permission group';


--
-- Name: COLUMN permission_group.external_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group.external_id IS 'external identifier for this permission group';


--
-- Name: COLUMN permission_group.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group.description IS 'longer description to provide more information about this permission group';


--
-- Name: COLUMN permission_group.provenance; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group.provenance IS 'origination of this permission group';


--
-- Name: COLUMN permission_group.is_default; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group.is_default IS 'flag to identify the default permission group';


--
-- Name: permission_group_entry; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.permission_group_entry (
    entity_id bigint NOT NULL,
    permission_group_id bigint NOT NULL,
    entity_kind character varying(64) DEFAULT NULL::character varying NOT NULL
);


ALTER TABLE public.permission_group_entry OWNER TO waltz;

--
-- Name: TABLE permission_group_entry; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.permission_group_entry IS 'entities which have specific permissions which replace the default permission group';


--
-- Name: COLUMN permission_group_entry.entity_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group_entry.entity_id IS 'the id of the entity being given specific permissions';


--
-- Name: COLUMN permission_group_entry.permission_group_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group_entry.permission_group_id IS 'identifier of the permission group being linked to';


--
-- Name: COLUMN permission_group_entry.entity_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group_entry.entity_kind IS 'the type of the entity being given specific permissions';


--
-- Name: permission_group_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.permission_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permission_group_id_seq OWNER TO waltz;

--
-- Name: permission_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.permission_group_id_seq OWNED BY public.permission_group.id;


--
-- Name: permission_group_involvement; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.permission_group_involvement (
    permission_group_id bigint NOT NULL,
    involvement_group_id bigint,
    operation character varying(64) DEFAULT 'UNKNOWN'::character varying NOT NULL,
    parent_kind character varying(64) DEFAULT NULL::character varying NOT NULL,
    subject_kind character varying(64),
    qualifier_kind character varying(64),
    qualifier_id bigint
);


ALTER TABLE public.permission_group_involvement OWNER TO waltz;

--
-- Name: TABLE permission_group_involvement; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.permission_group_involvement IS 'links a group of involvements to a given operation on an entity kind';


--
-- Name: COLUMN permission_group_involvement.permission_group_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group_involvement.permission_group_id IS 'identifier of the permission group this association is tied to';


--
-- Name: COLUMN permission_group_involvement.involvement_group_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group_involvement.involvement_group_id IS 'identifier of the involvement group';


--
-- Name: COLUMN permission_group_involvement.operation; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group_involvement.operation IS 'type of operation this involvement group is allowed to perform (one of: ADD, ATTEST, REMOVE, UPDATE, UNKNOWN)';


--
-- Name: COLUMN permission_group_involvement.parent_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group_involvement.parent_kind IS 'kind of the parent entity the change is related to e.g. APPLICATION';


--
-- Name: COLUMN permission_group_involvement.subject_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group_involvement.subject_kind IS 'kind of the entity the change acting upon e.g. MEASURABLE_RATING';


--
-- Name: COLUMN permission_group_involvement.qualifier_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group_involvement.qualifier_kind IS 'kind of qualifier entity needed to specify a more specific permission e.g. MEASURABLE_CATEGORY';


--
-- Name: COLUMN permission_group_involvement.qualifier_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.permission_group_involvement.qualifier_id IS 'identifier of the qualifier entity needed to specify a more specific permission';


--
-- Name: person; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.person (
    id bigint NOT NULL,
    employee_id character varying(128),
    display_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    user_principal_name character varying(255),
    department_name character varying(255),
    kind character varying(255) NOT NULL,
    manager_employee_id character varying(128),
    title character varying(255),
    office_phone character varying(128),
    mobile_phone character varying(128),
    organisational_unit_id bigint,
    is_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE public.person OWNER TO waltz;

--
-- Name: person_hierarchy; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.person_hierarchy (
    manager_id character varying(128) NOT NULL,
    employee_id character varying(128) NOT NULL,
    level integer DEFAULT 99 NOT NULL
);


ALTER TABLE public.person_hierarchy OWNER TO waltz;

--
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_id_seq OWNER TO waltz;

--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.person_id_seq OWNED BY public.person.id;


--
-- Name: physical_specification; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.physical_specification (
    id bigint NOT NULL,
    owning_entity_id bigint NOT NULL,
    external_id character varying(200) NOT NULL,
    name character varying(255) NOT NULL,
    format character varying(64) NOT NULL,
    description character varying(4000) NOT NULL,
    provenance character varying(64) NOT NULL,
    owning_entity_kind character varying(64) DEFAULT 'APPLICATION'::character varying NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    is_removed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by character varying(255) NOT NULL
);


ALTER TABLE public.physical_specification OWNER TO waltz;

--
-- Name: physical_data_article_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.physical_data_article_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.physical_data_article_id_seq OWNER TO waltz;

--
-- Name: physical_data_article_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.physical_data_article_id_seq OWNED BY public.physical_specification.id;


--
-- Name: physical_flow; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.physical_flow (
    id bigint NOT NULL,
    specification_id bigint NOT NULL,
    basis_offset integer NOT NULL,
    frequency character varying(64) NOT NULL,
    transport character varying(64) NOT NULL,
    description character varying(4000) NOT NULL,
    provenance character varying(64) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    logical_flow_id bigint NOT NULL,
    specification_definition_id bigint,
    is_removed boolean DEFAULT false NOT NULL,
    last_attested_at timestamp without time zone,
    last_attested_by character varying(255),
    criticality character varying(64) DEFAULT 'MEDIUM'::character varying NOT NULL,
    external_id character varying(200),
    entity_lifecycle_status character varying(64) DEFAULT 'ACTIVE'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by character varying(255) NOT NULL,
    is_readonly boolean DEFAULT false NOT NULL,
    name character varying(255)
);


ALTER TABLE public.physical_flow OWNER TO waltz;

--
-- Name: COLUMN physical_flow.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.physical_flow.name IS 'optional name, if provided this effectively overrides the associated specification name';


--
-- Name: physical_data_flow_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.physical_data_flow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.physical_data_flow_id_seq OWNER TO waltz;

--
-- Name: physical_data_flow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.physical_data_flow_id_seq OWNED BY public.physical_flow.id;


--
-- Name: physical_flow_participant; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.physical_flow_participant (
    physical_flow_id bigint NOT NULL,
    kind character varying(64) NOT NULL,
    participant_entity_kind character varying(64) NOT NULL,
    participant_entity_id bigint NOT NULL,
    description character varying(4000),
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.physical_flow_participant OWNER TO waltz;

--
-- Name: physical_spec_data_type; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.physical_spec_data_type (
    specification_id bigint NOT NULL,
    data_type_id bigint NOT NULL,
    provenance character varying(64) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    is_readonly boolean DEFAULT false NOT NULL
);


ALTER TABLE public.physical_spec_data_type OWNER TO waltz;

--
-- Name: TABLE physical_spec_data_type; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.physical_spec_data_type IS 'Decorates physical specs with data types';


--
-- Name: physical_spec_defn; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.physical_spec_defn (
    id bigint NOT NULL,
    specification_id bigint NOT NULL,
    version character varying(64) NOT NULL,
    delimiter character(1),
    type character varying(64) NOT NULL,
    provenance character varying(64) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by character varying(255) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    status character varying(64) NOT NULL
);


ALTER TABLE public.physical_spec_defn OWNER TO waltz;

--
-- Name: TABLE physical_spec_defn; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.physical_spec_defn IS 'Stores physical spec definition records';


--
-- Name: physical_spec_defn_field; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.physical_spec_defn_field (
    id bigint NOT NULL,
    spec_defn_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    "position" integer NOT NULL,
    type character varying(64) NOT NULL,
    description character varying(4000) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    logical_data_element_id bigint
);


ALTER TABLE public.physical_spec_defn_field OWNER TO waltz;

--
-- Name: TABLE physical_spec_defn_field; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.physical_spec_defn_field IS 'Stores physical spec definition fields';


--
-- Name: physical_spec_defn_field_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.physical_spec_defn_field_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.physical_spec_defn_field_id_seq OWNER TO waltz;

--
-- Name: physical_spec_defn_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.physical_spec_defn_field_id_seq OWNED BY public.physical_spec_defn_field.id;


--
-- Name: physical_spec_defn_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.physical_spec_defn_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.physical_spec_defn_id_seq OWNER TO waltz;

--
-- Name: physical_spec_defn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.physical_spec_defn_id_seq OWNED BY public.physical_spec_defn.id;


--
-- Name: physical_spec_defn_sample_file; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.physical_spec_defn_sample_file (
    id bigint NOT NULL,
    spec_defn_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    file_data text NOT NULL
);


ALTER TABLE public.physical_spec_defn_sample_file OWNER TO waltz;

--
-- Name: TABLE physical_spec_defn_sample_file; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.physical_spec_defn_sample_file IS 'Stores physical spec definition sample file data';


--
-- Name: physical_spec_defn_sample_file_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.physical_spec_defn_sample_file_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.physical_spec_defn_sample_file_id_seq OWNER TO waltz;

--
-- Name: physical_spec_defn_sample_file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.physical_spec_defn_sample_file_id_seq OWNED BY public.physical_spec_defn_sample_file.id;


--
-- Name: process_diagram; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.process_diagram (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000) NOT NULL,
    diagram_kind character varying(64) DEFAULT 'WALTZ_PROCESS_JSON'::character varying NOT NULL,
    layout_data text NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by character varying(255) NOT NULL,
    external_id character varying(200),
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.process_diagram OWNER TO waltz;

--
-- Name: TABLE process_diagram; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.process_diagram IS 'The process diagram table represents the metadata and layout data associated with a process diagram';


--
-- Name: process_diagram_entity; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.process_diagram_entity (
    diagram_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    is_notable boolean DEFAULT false
);


ALTER TABLE public.process_diagram_entity OWNER TO waltz;

--
-- Name: TABLE process_diagram_entity; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.process_diagram_entity IS 'A Bill of Materials (BoM) for a process diagram';


--
-- Name: process_diagram_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.process_diagram_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.process_diagram_id_seq OWNER TO waltz;

--
-- Name: process_diagram_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.process_diagram_id_seq OWNED BY public.process_diagram.id;


--
-- Name: rating_scheme; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.rating_scheme (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000) NOT NULL
);


ALTER TABLE public.rating_scheme OWNER TO waltz;

--
-- Name: rating_scheme_definition_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.rating_scheme_definition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rating_scheme_definition_id_seq OWNER TO waltz;

--
-- Name: rating_scheme_definition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.rating_scheme_definition_id_seq OWNED BY public.rating_scheme.id;


--
-- Name: rating_scheme_item; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.rating_scheme_item (
    id bigint NOT NULL,
    scheme_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000) NOT NULL,
    code character(1) NOT NULL,
    color character varying(255) NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    user_selectable boolean DEFAULT true NOT NULL,
    external_id character varying(200)
);


ALTER TABLE public.rating_scheme_item OWNER TO waltz;

--
-- Name: rating_scheme_definition_item_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.rating_scheme_definition_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rating_scheme_definition_item_id_seq OWNER TO waltz;

--
-- Name: rating_scheme_definition_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.rating_scheme_definition_item_id_seq OWNED BY public.rating_scheme_item.id;


--
-- Name: relationship_kind; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.relationship_kind (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    kind_a character varying(128) NOT NULL,
    kind_b character varying(128) NOT NULL,
    category_a bigint,
    category_b bigint,
    is_readonly boolean DEFAULT false NOT NULL,
    code character varying(128) NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    reverse_name character varying(255) NOT NULL
);


ALTER TABLE public.relationship_kind OWNER TO waltz;

--
-- Name: TABLE relationship_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.relationship_kind IS 'Describes types of relationships between entities';


--
-- Name: COLUMN relationship_kind.category_a; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.relationship_kind.category_a IS 'Placeholder: if kind_a is a MEASURABLE then this may (optionally) be used to restrict it based on category';


--
-- Name: COLUMN relationship_kind.category_b; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.relationship_kind.category_b IS 'Placeholder: if kind_b is a MEASURABLE then this may (optionally) be used to restrict it based on category';


--
-- Name: relationship_kind_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.relationship_kind_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relationship_kind_id_seq OWNER TO waltz;

--
-- Name: relationship_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.relationship_kind_id_seq OWNED BY public.relationship_kind.id;


--
-- Name: report_grid; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.report_grid (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    external_id character varying(200) NOT NULL,
    kind character varying(64) DEFAULT 'PUBLIC'::character varying NOT NULL,
    subject_kind character varying(200) NOT NULL
);


ALTER TABLE public.report_grid OWNER TO waltz;

--
-- Name: report_grid_column_definition; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.report_grid_column_definition (
    id bigint NOT NULL,
    report_grid_id bigint NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.report_grid_column_definition OWNER TO waltz;

--
-- Name: report_grid_fixed_column_definition; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.report_grid_fixed_column_definition (
    id bigint NOT NULL,
    column_entity_kind character varying(64) NOT NULL,
    column_entity_id bigint,
    display_name character varying(255),
    additional_column_options character varying(64) DEFAULT 'NONE'::character varying NOT NULL,
    entity_field_reference_id bigint,
    column_qualifier_kind character varying(64),
    column_qualifier_id bigint,
    external_id character varying(200),
    grid_column_id bigint NOT NULL
);


ALTER TABLE public.report_grid_fixed_column_definition OWNER TO waltz;

--
-- Name: COLUMN report_grid_fixed_column_definition.column_qualifier_kind; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.report_grid_fixed_column_definition.column_qualifier_kind IS 'An optional reference a qualifier kind, to further identify this item of grid data';


--
-- Name: COLUMN report_grid_fixed_column_definition.column_qualifier_id; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.report_grid_fixed_column_definition.column_qualifier_id IS 'An optional reference a qualifier id, to further identify this item of grid data';


--
-- Name: report_grid_column_definition_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.report_grid_column_definition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_grid_column_definition_id_seq OWNER TO waltz;

--
-- Name: report_grid_column_definition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.report_grid_column_definition_id_seq OWNED BY public.report_grid_fixed_column_definition.id;


--
-- Name: report_grid_derived_column_definition; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.report_grid_derived_column_definition (
    id bigint NOT NULL,
    display_name character varying(255) NOT NULL,
    column_description character varying(4000),
    derivation_script character varying NOT NULL,
    external_id character varying(200),
    grid_column_id bigint NOT NULL
);


ALTER TABLE public.report_grid_derived_column_definition OWNER TO waltz;

--
-- Name: report_grid_derived_column_definition_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

ALTER TABLE public.report_grid_derived_column_definition ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.report_grid_derived_column_definition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: report_grid_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.report_grid_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_grid_id_seq OWNER TO waltz;

--
-- Name: report_grid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.report_grid_id_seq OWNED BY public.report_grid.id;


--
-- Name: report_grid_member; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.report_grid_member (
    grid_id bigint NOT NULL,
    user_id character varying(255) NOT NULL,
    role character varying(64) DEFAULT 'VIEWER'::character varying NOT NULL
);


ALTER TABLE public.report_grid_member OWNER TO waltz;

--
-- Name: roadmap; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.roadmap (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    row_type_kind character varying(64) NOT NULL,
    rating_scheme_id bigint NOT NULL,
    row_type_id bigint NOT NULL,
    column_type_kind character varying(64) NOT NULL,
    column_type_id bigint NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    entity_lifecycle_status character varying(64) DEFAULT 'ACTIVE'::character varying NOT NULL
);


ALTER TABLE public.roadmap OWNER TO waltz;

--
-- Name: roadmap_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.roadmap_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roadmap_id_seq OWNER TO waltz;

--
-- Name: roadmap_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.roadmap_id_seq OWNED BY public.roadmap.id;


--
-- Name: role; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.role (
    key character varying(255) NOT NULL,
    is_custom boolean DEFAULT true NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000) NOT NULL,
    user_selectable boolean DEFAULT true NOT NULL
);


ALTER TABLE public.role OWNER TO waltz;

--
-- Name: scenario; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.scenario (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    lifecycle_status character varying(64) NOT NULL,
    roadmap_id bigint NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    effective_date date NOT NULL,
    scenario_type character varying(64) DEFAULT 'TARGET'::character varying NOT NULL,
    release_status character varying(64) DEFAULT 'ACTIVE'::character varying NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.scenario OWNER TO waltz;

--
-- Name: scenario_axis_item; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.scenario_axis_item (
    id bigint NOT NULL,
    orientation character varying(64) NOT NULL,
    scenario_id bigint NOT NULL,
    "position" integer NOT NULL,
    domain_item_kind character varying(64) NOT NULL,
    domain_item_id bigint NOT NULL
);


ALTER TABLE public.scenario_axis_item OWNER TO waltz;

--
-- Name: scenario_axis_item_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.scenario_axis_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scenario_axis_item_id_seq OWNER TO waltz;

--
-- Name: scenario_axis_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.scenario_axis_item_id_seq OWNED BY public.scenario_axis_item.id;


--
-- Name: scenario_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.scenario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scenario_id_seq OWNER TO waltz;

--
-- Name: scenario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.scenario_id_seq OWNED BY public.scenario.id;


--
-- Name: scenario_rating_item; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.scenario_rating_item (
    id bigint NOT NULL,
    scenario_id bigint NOT NULL,
    rating character(1) NOT NULL,
    domain_item_kind character varying(64) NOT NULL,
    domain_item_id bigint NOT NULL,
    row_kind character varying(64) NOT NULL,
    row_id bigint NOT NULL,
    column_kind character varying(64) NOT NULL,
    column_id bigint NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    description character varying(4000)
);


ALTER TABLE public.scenario_rating_item OWNER TO waltz;

--
-- Name: scenario_rating_item_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.scenario_rating_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scenario_rating_item_id_seq OWNER TO waltz;

--
-- Name: scenario_rating_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.scenario_rating_item_id_seq OWNED BY public.scenario_rating_item.id;


--
-- Name: server_information; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.server_information (
    id bigint NOT NULL,
    hostname character varying(255) NOT NULL,
    operating_system character varying(128) DEFAULT 'UNKNOWN'::character varying NOT NULL,
    location character varying(128) NOT NULL,
    operating_system_version character varying(128) NOT NULL,
    country character varying(128) NOT NULL,
    is_virtual boolean,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    os_end_of_life_date date,
    hw_end_of_life_date date,
    lifecycle_status character varying(64) DEFAULT 'UNKNOWN'::character varying NOT NULL,
    external_id character varying(200)
);


ALTER TABLE public.server_information OWNER TO waltz;

--
-- Name: server_information_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.server_information_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_information_id_seq OWNER TO waltz;

--
-- Name: server_information_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.server_information_id_seq OWNED BY public.server_information.id;


--
-- Name: server_usage; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.server_usage (
    server_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    entity_id bigint NOT NULL,
    environment character varying(64) DEFAULT 'UNKNOWN'::character varying NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    provenance character varying(64) NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.server_usage OWNER TO waltz;

--
-- Name: server_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.server_usage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_usage_id_seq OWNER TO waltz;

--
-- Name: server_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.server_usage_id_seq OWNED BY public.server_usage.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.settings (
    name character varying(128) NOT NULL,
    value character varying(255),
    restricted boolean DEFAULT false NOT NULL,
    description character varying(4000)
);


ALTER TABLE public.settings OWNER TO waltz;

--
-- Name: TABLE settings; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.settings IS 'contains configuration data which controls the operation of Waltz.';


--
-- Name: COLUMN settings.name; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.settings.name IS 'the key name of the setting, often uses dotted notation.  Strongly recommended to put client specific settings under their own namespace (i.e. mycorp.somesetting)';


--
-- Name: COLUMN settings.value; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.settings.value IS 'the value of the setting, if the setting is a boolean it should be entered as lowercase';


--
-- Name: COLUMN settings.restricted; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.settings.restricted IS 'restricted settings are internal to Waltz and not available via API/external calls';


--
-- Name: COLUMN settings.description; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON COLUMN public.settings.description IS 'optional comment to describe this setting';


--
-- Name: shared_preference; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.shared_preference (
    key character varying(120) NOT NULL,
    category character varying(128) NOT NULL,
    value character varying(4000) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL
);


ALTER TABLE public.shared_preference OWNER TO waltz;

--
-- Name: TABLE shared_preference; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.shared_preference IS 'Store shared preference values';


--
-- Name: software_package; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.software_package (
    id bigint NOT NULL,
    vendor character varying(255),
    name character varying(255) NOT NULL,
    notable boolean DEFAULT false,
    description character varying(4000),
    external_id character varying(200) DEFAULT NULL::character varying,
    provenance character varying(64) DEFAULT 'waltz'::character varying NOT NULL,
    created_by character varying(255) DEFAULT 'admin'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    "group" character varying(255)
);


ALTER TABLE public.software_package OWNER TO waltz;

--
-- Name: software_package_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.software_package_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.software_package_id_seq OWNER TO waltz;

--
-- Name: software_package_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.software_package_id_seq OWNED BY public.software_package.id;


--
-- Name: software_usage; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.software_usage (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    software_version_id bigint NOT NULL,
    created_by character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.software_usage OWNER TO waltz;

--
-- Name: software_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.software_usage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.software_usage_id_seq OWNER TO waltz;

--
-- Name: software_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.software_usage_id_seq OWNED BY public.software_usage.id;


--
-- Name: software_version; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.software_version (
    id bigint NOT NULL,
    software_package_id bigint NOT NULL,
    version character varying(64),
    description character varying(4000),
    external_id character varying(200),
    created_by character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    provenance character varying(64) NOT NULL,
    release_date date
);


ALTER TABLE public.software_version OWNER TO waltz;

--
-- Name: software_version_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.software_version_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.software_version_id_seq OWNER TO waltz;

--
-- Name: software_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.software_version_id_seq OWNED BY public.software_version.id;


--
-- Name: software_version_licence; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.software_version_licence (
    id bigint NOT NULL,
    software_version_id bigint NOT NULL,
    licence_id bigint NOT NULL,
    created_by character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.software_version_licence OWNER TO waltz;

--
-- Name: software_version_licence_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.software_version_licence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.software_version_licence_id_seq OWNER TO waltz;

--
-- Name: software_version_licence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.software_version_licence_id_seq OWNED BY public.software_version_licence.id;


--
-- Name: software_version_vulnerability; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.software_version_vulnerability (
    software_version_id bigint NOT NULL,
    vulnerability_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.software_version_vulnerability OWNER TO waltz;

--
-- Name: source_data_rating; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.source_data_rating (
    source_name character varying(128) NOT NULL,
    entity_kind character varying(128) NOT NULL,
    authoritativeness character(1) DEFAULT 'Z'::bpchar NOT NULL,
    accuracy character(1) DEFAULT 'Z'::bpchar NOT NULL,
    completeness character(1) DEFAULT 'Z'::bpchar NOT NULL,
    last_import timestamp without time zone DEFAULT now()
);


ALTER TABLE public.source_data_rating OWNER TO waltz;

--
-- Name: static_panel; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.static_panel (
    id bigint NOT NULL,
    "group" character varying(128) NOT NULL,
    title character varying(255) NOT NULL,
    icon character varying(64) DEFAULT 'info'::character varying NOT NULL,
    priority integer NOT NULL,
    width integer DEFAULT 12 NOT NULL,
    encoding character varying(64) DEFAULT 'HTML'::character varying NOT NULL,
    content text NOT NULL
);


ALTER TABLE public.static_panel OWNER TO waltz;

--
-- Name: static_panel_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.static_panel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.static_panel_id_seq OWNER TO waltz;

--
-- Name: static_panel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.static_panel_id_seq OWNED BY public.static_panel.id;


--
-- Name: survey_instance; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.survey_instance (
    id bigint NOT NULL,
    survey_run_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    entity_id bigint NOT NULL,
    status character varying(64) NOT NULL,
    submitted_at timestamp without time zone,
    submitted_by character varying(255),
    due_date date NOT NULL,
    original_instance_id bigint,
    approved_at timestamp without time zone,
    approved_by character varying(255),
    owning_role character varying(255),
    entity_qualifier_id bigint,
    entity_qualifier_kind character varying(64),
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    approval_due_date date NOT NULL,
    issued_on timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.survey_instance OWNER TO waltz;

--
-- Name: survey_instance_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.survey_instance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.survey_instance_id_seq OWNER TO waltz;

--
-- Name: survey_instance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.survey_instance_id_seq OWNED BY public.survey_instance.id;


--
-- Name: survey_instance_owner; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.survey_instance_owner (
    id bigint NOT NULL,
    survey_instance_id bigint NOT NULL,
    person_id bigint NOT NULL
);


ALTER TABLE public.survey_instance_owner OWNER TO waltz;

--
-- Name: survey_instance_owner_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.survey_instance_owner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.survey_instance_owner_id_seq OWNER TO waltz;

--
-- Name: survey_instance_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.survey_instance_owner_id_seq OWNED BY public.survey_instance_owner.id;


--
-- Name: survey_instance_recipient; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.survey_instance_recipient (
    id bigint NOT NULL,
    survey_instance_id bigint NOT NULL,
    person_id bigint NOT NULL
);


ALTER TABLE public.survey_instance_recipient OWNER TO waltz;

--
-- Name: survey_instance_recipient_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.survey_instance_recipient_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.survey_instance_recipient_id_seq OWNER TO waltz;

--
-- Name: survey_instance_recipient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.survey_instance_recipient_id_seq OWNED BY public.survey_instance_recipient.id;


--
-- Name: survey_question; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.survey_question (
    id bigint NOT NULL,
    survey_template_id bigint NOT NULL,
    question_text character varying(4000) NOT NULL,
    field_type character varying(64) NOT NULL,
    section_name character varying(255),
    "position" integer NOT NULL,
    is_mandatory boolean NOT NULL,
    allow_comment boolean NOT NULL,
    help_text character varying(4000),
    external_id character varying(200),
    inclusion_predicate character varying(500),
    entity_qualifier_id bigint,
    entity_qualifier_kind character varying(64),
    parent_external_id character varying(200),
    label character varying(255)
);


ALTER TABLE public.survey_question OWNER TO waltz;

--
-- Name: survey_question_dropdown_entry; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.survey_question_dropdown_entry (
    id bigint NOT NULL,
    question_id bigint NOT NULL,
    value character varying(4000) NOT NULL,
    "position" integer NOT NULL
);


ALTER TABLE public.survey_question_dropdown_entry OWNER TO waltz;

--
-- Name: TABLE survey_question_dropdown_entry; Type: COMMENT; Schema: public; Owner: waltz
--

COMMENT ON TABLE public.survey_question_dropdown_entry IS 'Stores allowed dropdown values for a survey question';


--
-- Name: survey_question_dropdown_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.survey_question_dropdown_entry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.survey_question_dropdown_entry_id_seq OWNER TO waltz;

--
-- Name: survey_question_dropdown_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.survey_question_dropdown_entry_id_seq OWNED BY public.survey_question_dropdown_entry.id;


--
-- Name: survey_question_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.survey_question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.survey_question_id_seq OWNER TO waltz;

--
-- Name: survey_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.survey_question_id_seq OWNED BY public.survey_question.id;


--
-- Name: survey_question_list_response; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.survey_question_list_response (
    survey_instance_id bigint NOT NULL,
    question_id bigint NOT NULL,
    response character varying NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    entity_id bigint,
    entity_kind character varying(64)
);


ALTER TABLE public.survey_question_list_response OWNER TO waltz;

--
-- Name: survey_question_response; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.survey_question_response (
    survey_instance_id bigint NOT NULL,
    question_id bigint NOT NULL,
    person_id bigint NOT NULL,
    comment character varying(4000),
    last_updated_at timestamp without time zone NOT NULL,
    string_response character varying(4000),
    number_response numeric(19,4),
    boolean_response boolean,
    entity_response_id bigint,
    entity_response_kind character varying(64),
    date_response date,
    list_response_concat character varying
);


ALTER TABLE public.survey_question_response OWNER TO waltz;

--
-- Name: survey_run; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.survey_run (
    id bigint NOT NULL,
    survey_template_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    selector_entity_kind character varying(64) NOT NULL,
    selector_entity_id bigint NOT NULL,
    selector_hierarchy_scope character varying(64) NOT NULL,
    involvement_kind_ids character varying(255),
    issued_on date,
    due_date date NOT NULL,
    issuance_kind character varying(64) NOT NULL,
    owner_id bigint NOT NULL,
    contact_email character varying(255) NOT NULL,
    status character varying(64) NOT NULL,
    owner_inv_kind_ids character varying(255),
    is_default boolean DEFAULT false NOT NULL,
    approval_due_date date NOT NULL
);


ALTER TABLE public.survey_run OWNER TO waltz;

--
-- Name: survey_run_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.survey_run_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.survey_run_id_seq OWNER TO waltz;

--
-- Name: survey_run_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.survey_run_id_seq OWNED BY public.survey_run.id;


--
-- Name: survey_template; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.survey_template (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    target_entity_kind character varying(64) NOT NULL,
    owner_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    status character varying(64) NOT NULL,
    external_id character varying(200)
);


ALTER TABLE public.survey_template OWNER TO waltz;

--
-- Name: survey_template_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.survey_template_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.survey_template_id_seq OWNER TO waltz;

--
-- Name: survey_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.survey_template_id_seq OWNED BY public.survey_template.id;


--
-- Name: svg_diagram; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.svg_diagram (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    "group" character varying(128) NOT NULL,
    priority integer NOT NULL,
    description text,
    svg text NOT NULL,
    key_property character varying(64) NOT NULL,
    product character varying(64) NOT NULL,
    display_width_percent integer,
    display_height_percent integer
);


ALTER TABLE public.svg_diagram OWNER TO waltz;

--
-- Name: svg_diagram_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.svg_diagram_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.svg_diagram_id_seq OWNER TO waltz;

--
-- Name: svg_diagram_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.svg_diagram_id_seq OWNED BY public.svg_diagram.id;


--
-- Name: system_job_log; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.system_job_log (
    name character varying(128) NOT NULL,
    entity_kind character varying(128) NOT NULL,
    status character varying(64) NOT NULL,
    description character varying(2048),
    start timestamp without time zone NOT NULL,
    "end" timestamp without time zone
);


ALTER TABLE public.system_job_log OWNER TO waltz;

--
-- Name: tag; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.tag (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    target_kind character varying(64) NOT NULL
);


ALTER TABLE public.tag OWNER TO waltz;

--
-- Name: tag_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tag_id_seq OWNER TO waltz;

--
-- Name: tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.tag_id_seq OWNED BY public.tag.id;


--
-- Name: tag_usage; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.tag_usage (
    tag_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    entity_kind character varying(64) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by character varying(255) NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.tag_usage OWNER TO waltz;

--
-- Name: taxonomy_change; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.taxonomy_change (
    id bigint NOT NULL,
    change_type character varying(64) NOT NULL,
    description character varying(4000),
    domain_kind character varying(64) NOT NULL,
    domain_id bigint NOT NULL,
    primary_reference_kind character varying(64) NOT NULL,
    primary_reference_id bigint NOT NULL,
    status character varying(64) DEFAULT 'DRAFT'::character varying NOT NULL,
    params character varying(4000) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by character varying(255) NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL
);


ALTER TABLE public.taxonomy_change OWNER TO waltz;

--
-- Name: taxonomy_change_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.taxonomy_change_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taxonomy_change_id_seq OWNER TO waltz;

--
-- Name: taxonomy_change_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.taxonomy_change_id_seq OWNED BY public.taxonomy_change.id;


--
-- Name: thumbnail; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.thumbnail (
    parent_entity_kind character varying(64) NOT NULL,
    parent_entity_id bigint NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_by character varying(255) NOT NULL,
    mime_type character varying(255) NOT NULL,
    blob bytea NOT NULL,
    external_id character varying(200),
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.thumbnail OWNER TO waltz;

--
-- Name: user; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public."user" (
    user_name character varying(255) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE public."user" OWNER TO waltz;

--
-- Name: user_agent_info; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.user_agent_info (
    id integer NOT NULL,
    user_name character varying(128) NOT NULL,
    user_agent character varying(500) NOT NULL,
    resolution character varying(128) NOT NULL,
    operating_system character varying(128) NOT NULL,
    ip_address character varying(128) NOT NULL,
    login_timestamp timestamp without time zone NOT NULL
);


ALTER TABLE public.user_agent_info OWNER TO waltz;

--
-- Name: user_agent_info_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.user_agent_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_agent_info_id_seq OWNER TO waltz;

--
-- Name: user_agent_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.user_agent_info_id_seq OWNED BY public.user_agent_info.id;


--
-- Name: user_preference; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.user_preference (
    key character varying(120) NOT NULL,
    value character varying(2048) NOT NULL,
    user_name character varying(255) NOT NULL
);


ALTER TABLE public.user_preference OWNER TO waltz;

--
-- Name: user_role; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.user_role (
    user_name character varying(255) NOT NULL,
    role character varying(255) NOT NULL
);


ALTER TABLE public.user_role OWNER TO waltz;

--
-- Name: vulnerability; Type: TABLE; Schema: public; Owner: waltz
--

CREATE TABLE public.vulnerability (
    id bigint NOT NULL,
    external_id character varying(200) NOT NULL,
    severity character varying(64) NOT NULL,
    description character varying(4000),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    provenance character varying(64) NOT NULL
);


ALTER TABLE public.vulnerability OWNER TO waltz;

--
-- Name: vulnerability_id_seq; Type: SEQUENCE; Schema: public; Owner: waltz
--

CREATE SEQUENCE public.vulnerability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vulnerability_id_seq OWNER TO waltz;

--
-- Name: vulnerability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waltz
--

ALTER SEQUENCE public.vulnerability_id_seq OWNED BY public.vulnerability.id;


--
-- Name: access_log id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.access_log ALTER COLUMN id SET DEFAULT nextval('public.access_log_id_seq'::regclass);


--
-- Name: actor id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.actor ALTER COLUMN id SET DEFAULT nextval('public.involvement_kind_id_seq'::regclass);


--
-- Name: allocation_scheme id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.allocation_scheme ALTER COLUMN id SET DEFAULT nextval('public.allocation_scheme_id_seq'::regclass);


--
-- Name: application id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.application ALTER COLUMN id SET DEFAULT nextval('public.application_id_seq'::regclass);


--
-- Name: application_group id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.application_group ALTER COLUMN id SET DEFAULT nextval('public.application_group_id_seq'::regclass);


--
-- Name: assessment_definition id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.assessment_definition ALTER COLUMN id SET DEFAULT nextval('public.assessment_definition_id_seq'::regclass);


--
-- Name: attestation_instance id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.attestation_instance ALTER COLUMN id SET DEFAULT nextval('public.attestation_instance_id_seq'::regclass);


--
-- Name: attestation_instance_recipient id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.attestation_instance_recipient ALTER COLUMN id SET DEFAULT nextval('public.attestation_instance_recipient_id_seq'::regclass);


--
-- Name: attestation_run id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.attestation_run ALTER COLUMN id SET DEFAULT nextval('public.attestation_run_id_seq'::regclass);


--
-- Name: attribute_change id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.attribute_change ALTER COLUMN id SET DEFAULT nextval('public.attribute_change_id_seq'::regclass);


--
-- Name: bookmark id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.bookmark ALTER COLUMN id SET DEFAULT nextval('public.bookmark_id_seq'::regclass);


--
-- Name: change_log id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.change_log ALTER COLUMN id SET DEFAULT nextval('public.change_log_id_seq'::regclass);


--
-- Name: change_set id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.change_set ALTER COLUMN id SET DEFAULT nextval('public.change_set_id_seq'::regclass);


--
-- Name: change_unit id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.change_unit ALTER COLUMN id SET DEFAULT nextval('public.change_unit_id_seq'::regclass);


--
-- Name: complexity id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.complexity ALTER COLUMN id SET DEFAULT nextval('public.complexity_id_seq'::regclass);


--
-- Name: complexity_kind id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.complexity_kind ALTER COLUMN id SET DEFAULT nextval('public.complexity_kind_id_seq'::regclass);


--
-- Name: cost id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.cost ALTER COLUMN id SET DEFAULT nextval('public.cost_id_seq'::regclass);


--
-- Name: cost_kind id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.cost_kind ALTER COLUMN id SET DEFAULT nextval('public.cost_kind_id_seq'::regclass);


--
-- Name: custom_environment id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.custom_environment ALTER COLUMN id SET DEFAULT nextval('public.custom_environment_id_seq'::regclass);


--
-- Name: custom_environment_usage id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.custom_environment_usage ALTER COLUMN id SET DEFAULT nextval('public.custom_environment_usage_id_seq'::regclass);


--
-- Name: database_information id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.database_information ALTER COLUMN id SET DEFAULT nextval('public.database_information_2_id_seq'::regclass);


--
-- Name: database_usage id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.database_usage ALTER COLUMN id SET DEFAULT nextval('public.database_usage_id_seq'::regclass);


--
-- Name: entity_enum_definition id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_enum_definition ALTER COLUMN id SET DEFAULT nextval('public.entity_enum_definition_id_seq'::regclass);


--
-- Name: entity_named_note_type id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_named_note_type ALTER COLUMN id SET DEFAULT nextval('public.entity_named_note_type_id_seq'::regclass);


--
-- Name: entity_relationship id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_relationship ALTER COLUMN id SET DEFAULT nextval('public.entity_relationship_id_seq'::regclass);


--
-- Name: entity_statistic_value id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_statistic_value ALTER COLUMN id SET DEFAULT nextval('public.entity_statistic_value_id_seq'::regclass);


--
-- Name: entity_svg_diagram id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_svg_diagram ALTER COLUMN id SET DEFAULT nextval('public.entity_svg_diagram_id_seq'::regclass);


--
-- Name: entity_workflow_definition id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_workflow_definition ALTER COLUMN id SET DEFAULT nextval('public.entity_workflow_definition_id_seq'::regclass);


--
-- Name: flow_classification id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_classification ALTER COLUMN id SET DEFAULT nextval('public.flow_classification_id_seq'::regclass);


--
-- Name: flow_classification_rule id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_classification_rule ALTER COLUMN id SET DEFAULT nextval('public.flow_classification_rule_id_seq'::regclass);


--
-- Name: flow_diagram id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_diagram ALTER COLUMN id SET DEFAULT nextval('public.flow_diagram_id_seq'::regclass);


--
-- Name: flow_diagram_overlay_group id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_diagram_overlay_group ALTER COLUMN id SET DEFAULT nextval('public.flow_diagram_overlay_group_id_seq'::regclass);


--
-- Name: flow_diagram_overlay_group_entry id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_diagram_overlay_group_entry ALTER COLUMN id SET DEFAULT nextval('public.flow_diagram_overlay_group_entry_id_seq'::regclass);


--
-- Name: involvement_group id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.involvement_group ALTER COLUMN id SET DEFAULT nextval('public.involvement_group_id_seq'::regclass);


--
-- Name: involvement_kind id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.involvement_kind ALTER COLUMN id SET DEFAULT nextval('public.involvement_kind_id_seq1'::regclass);


--
-- Name: licence id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.licence ALTER COLUMN id SET DEFAULT nextval('public.licence_id_seq'::regclass);


--
-- Name: logical_data_element id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.logical_data_element ALTER COLUMN id SET DEFAULT nextval('public.logical_data_element_id_seq'::regclass);


--
-- Name: logical_flow id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.logical_flow ALTER COLUMN id SET DEFAULT nextval('public.data_flow_id_seq'::regclass);


--
-- Name: logical_flow_decorator id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.logical_flow_decorator ALTER COLUMN id SET DEFAULT nextval('public.logical_flow_decorator_id_seq'::regclass);


--
-- Name: measurable id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable ALTER COLUMN id SET DEFAULT nextval('public.measurable_id_seq'::regclass);


--
-- Name: measurable_category id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable_category ALTER COLUMN id SET DEFAULT nextval('public.measurable_category_id_seq'::regclass);


--
-- Name: measurable_rating_planned_decommission id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable_rating_planned_decommission ALTER COLUMN id SET DEFAULT nextval('public.measurable_rating_planned_decommission_id_seq'::regclass);


--
-- Name: measurable_rating_replacement id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable_rating_replacement ALTER COLUMN id SET DEFAULT nextval('public.measurable_rating_replacement_id_seq'::regclass);


--
-- Name: permission_group id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.permission_group ALTER COLUMN id SET DEFAULT nextval('public.permission_group_id_seq'::regclass);


--
-- Name: person id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.person ALTER COLUMN id SET DEFAULT nextval('public.person_id_seq'::regclass);


--
-- Name: physical_flow id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_flow ALTER COLUMN id SET DEFAULT nextval('public.physical_data_flow_id_seq'::regclass);


--
-- Name: physical_spec_defn id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_spec_defn ALTER COLUMN id SET DEFAULT nextval('public.physical_spec_defn_id_seq'::regclass);


--
-- Name: physical_spec_defn_field id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_spec_defn_field ALTER COLUMN id SET DEFAULT nextval('public.physical_spec_defn_field_id_seq'::regclass);


--
-- Name: physical_spec_defn_sample_file id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_spec_defn_sample_file ALTER COLUMN id SET DEFAULT nextval('public.physical_spec_defn_sample_file_id_seq'::regclass);


--
-- Name: physical_specification id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_specification ALTER COLUMN id SET DEFAULT nextval('public.physical_data_article_id_seq'::regclass);


--
-- Name: process_diagram id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.process_diagram ALTER COLUMN id SET DEFAULT nextval('public.process_diagram_id_seq'::regclass);


--
-- Name: rating_scheme id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.rating_scheme ALTER COLUMN id SET DEFAULT nextval('public.rating_scheme_definition_id_seq'::regclass);


--
-- Name: rating_scheme_item id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.rating_scheme_item ALTER COLUMN id SET DEFAULT nextval('public.rating_scheme_definition_item_id_seq'::regclass);


--
-- Name: relationship_kind id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.relationship_kind ALTER COLUMN id SET DEFAULT nextval('public.relationship_kind_id_seq'::regclass);


--
-- Name: report_grid id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.report_grid ALTER COLUMN id SET DEFAULT nextval('public.report_grid_id_seq'::regclass);


--
-- Name: report_grid_fixed_column_definition id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.report_grid_fixed_column_definition ALTER COLUMN id SET DEFAULT nextval('public.report_grid_column_definition_id_seq'::regclass);


--
-- Name: roadmap id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.roadmap ALTER COLUMN id SET DEFAULT nextval('public.roadmap_id_seq'::regclass);


--
-- Name: scenario id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.scenario ALTER COLUMN id SET DEFAULT nextval('public.scenario_id_seq'::regclass);


--
-- Name: scenario_axis_item id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.scenario_axis_item ALTER COLUMN id SET DEFAULT nextval('public.scenario_axis_item_id_seq'::regclass);


--
-- Name: scenario_rating_item id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.scenario_rating_item ALTER COLUMN id SET DEFAULT nextval('public.scenario_rating_item_id_seq'::regclass);


--
-- Name: server_information id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.server_information ALTER COLUMN id SET DEFAULT nextval('public.server_information_id_seq'::regclass);


--
-- Name: server_usage id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.server_usage ALTER COLUMN id SET DEFAULT nextval('public.server_usage_id_seq'::regclass);


--
-- Name: software_package id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.software_package ALTER COLUMN id SET DEFAULT nextval('public.software_package_id_seq'::regclass);


--
-- Name: software_usage id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.software_usage ALTER COLUMN id SET DEFAULT nextval('public.software_usage_id_seq'::regclass);


--
-- Name: software_version id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.software_version ALTER COLUMN id SET DEFAULT nextval('public.software_version_id_seq'::regclass);


--
-- Name: software_version_licence id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.software_version_licence ALTER COLUMN id SET DEFAULT nextval('public.software_version_licence_id_seq'::regclass);


--
-- Name: static_panel id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.static_panel ALTER COLUMN id SET DEFAULT nextval('public.static_panel_id_seq'::regclass);


--
-- Name: survey_instance id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_instance ALTER COLUMN id SET DEFAULT nextval('public.survey_instance_id_seq'::regclass);


--
-- Name: survey_instance_owner id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_instance_owner ALTER COLUMN id SET DEFAULT nextval('public.survey_instance_owner_id_seq'::regclass);


--
-- Name: survey_instance_recipient id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_instance_recipient ALTER COLUMN id SET DEFAULT nextval('public.survey_instance_recipient_id_seq'::regclass);


--
-- Name: survey_question id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_question ALTER COLUMN id SET DEFAULT nextval('public.survey_question_id_seq'::regclass);


--
-- Name: survey_question_dropdown_entry id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_question_dropdown_entry ALTER COLUMN id SET DEFAULT nextval('public.survey_question_dropdown_entry_id_seq'::regclass);


--
-- Name: survey_run id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_run ALTER COLUMN id SET DEFAULT nextval('public.survey_run_id_seq'::regclass);


--
-- Name: survey_template id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_template ALTER COLUMN id SET DEFAULT nextval('public.survey_template_id_seq'::regclass);


--
-- Name: svg_diagram id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.svg_diagram ALTER COLUMN id SET DEFAULT nextval('public.svg_diagram_id_seq'::regclass);


--
-- Name: tag id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.tag ALTER COLUMN id SET DEFAULT nextval('public.tag_id_seq'::regclass);


--
-- Name: taxonomy_change id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.taxonomy_change ALTER COLUMN id SET DEFAULT nextval('public.taxonomy_change_id_seq'::regclass);


--
-- Name: user_agent_info id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.user_agent_info ALTER COLUMN id SET DEFAULT nextval('public.user_agent_info_id_seq'::regclass);


--
-- Name: vulnerability id; Type: DEFAULT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.vulnerability ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_id_seq'::regclass);


--
-- Data for Name: access_log; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.access_log (id, user_id, state, params, created_at) FROM stdin;
\.
COPY public.access_log (id, user_id, state, params, created_at) FROM '/docker-entrypoint-initdb.d/4381.dat';

--
-- Data for Name: actor; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.actor (id, name, description, last_updated_at, last_updated_by, is_external, provenance, external_id) FROM stdin;
\.
COPY public.actor (id, name, description, last_updated_at, last_updated_by, is_external, provenance, external_id) FROM '/docker-entrypoint-initdb.d/4383.dat';

--
-- Data for Name: aggregate_overlay_diagram; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.aggregate_overlay_diagram (id, name, description, svg, last_updated_at, last_updated_by, provenance, aggregated_entity_kind) FROM stdin;
\.
COPY public.aggregate_overlay_diagram (id, name, description, svg, last_updated_at, last_updated_by, provenance, aggregated_entity_kind) FROM '/docker-entrypoint-initdb.d/4593.dat';

--
-- Data for Name: aggregate_overlay_diagram_callout; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.aggregate_overlay_diagram_callout (id, diagram_instance_id, title, content, start_color, end_color, cell_external_id) FROM stdin;
\.
COPY public.aggregate_overlay_diagram_callout (id, diagram_instance_id, title, content, start_color, end_color, cell_external_id) FROM '/docker-entrypoint-initdb.d/4599.dat';

--
-- Data for Name: aggregate_overlay_diagram_cell_data; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.aggregate_overlay_diagram_cell_data (id, diagram_id, cell_external_id, related_entity_kind, related_entity_id) FROM stdin;
\.
COPY public.aggregate_overlay_diagram_cell_data (id, diagram_id, cell_external_id, related_entity_kind, related_entity_id) FROM '/docker-entrypoint-initdb.d/4595.dat';

--
-- Data for Name: aggregate_overlay_diagram_instance; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.aggregate_overlay_diagram_instance (id, diagram_id, name, description, parent_entity_kind, parent_entity_id, svg, last_updated_at, last_updated_by, provenance, snapshot_data) FROM stdin;
\.
COPY public.aggregate_overlay_diagram_instance (id, diagram_id, name, description, parent_entity_kind, parent_entity_id, svg, last_updated_at, last_updated_by, provenance, snapshot_data) FROM '/docker-entrypoint-initdb.d/4597.dat';

--
-- Data for Name: aggregate_overlay_diagram_preset; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.aggregate_overlay_diagram_preset (id, diagram_id, name, description, external_id, overlay_config, filter_config, last_updated_at, last_updated_by, provenance) FROM stdin;
\.
COPY public.aggregate_overlay_diagram_preset (id, diagram_id, name, description, external_id, overlay_config, filter_config, last_updated_at, last_updated_by, provenance) FROM '/docker-entrypoint-initdb.d/4601.dat';

--
-- Data for Name: allocation; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.allocation (allocation_scheme_id, entity_id, entity_kind, measurable_id, allocation_percentage, last_updated_at, last_updated_by, external_id, provenance) FROM stdin;
\.
COPY public.allocation (allocation_scheme_id, entity_id, entity_kind, measurable_id, allocation_percentage, last_updated_at, last_updated_by, external_id, provenance) FROM '/docker-entrypoint-initdb.d/4384.dat';

--
-- Data for Name: allocation_scheme; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.allocation_scheme (id, name, description, measurable_category_id, external_id) FROM stdin;
\.
COPY public.allocation_scheme (id, name, description, measurable_category_id, external_id) FROM '/docker-entrypoint-initdb.d/4385.dat';

--
-- Data for Name: application; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.application (id, name, description, asset_code, created_at, updated_at, organisational_unit_id, kind, lifecycle_phase, parent_asset_code, overall_rating, provenance, business_criticality, is_removed, entity_lifecycle_status, planned_retirement_date, actual_retirement_date, commission_date) FROM stdin;
\.
COPY public.application (id, name, description, asset_code, created_at, updated_at, organisational_unit_id, kind, lifecycle_phase, parent_asset_code, overall_rating, provenance, business_criticality, is_removed, entity_lifecycle_status, planned_retirement_date, actual_retirement_date, commission_date) FROM '/docker-entrypoint-initdb.d/4387.dat';

--
-- Data for Name: application_group; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.application_group (id, name, kind, description, external_id, is_removed, is_favourite_group) FROM stdin;
\.
COPY public.application_group (id, name, kind, description, external_id, is_removed, is_favourite_group) FROM '/docker-entrypoint-initdb.d/4388.dat';

--
-- Data for Name: application_group_entry; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.application_group_entry (group_id, application_id, is_readonly, provenance, created_at) FROM stdin;
\.
COPY public.application_group_entry (group_id, application_id, is_readonly, provenance, created_at) FROM '/docker-entrypoint-initdb.d/4389.dat';

--
-- Data for Name: application_group_member; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.application_group_member (group_id, user_id, role) FROM stdin;
\.
COPY public.application_group_member (group_id, user_id, role) FROM '/docker-entrypoint-initdb.d/4391.dat';

--
-- Data for Name: application_group_ou_entry; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.application_group_ou_entry (group_id, org_unit_id, is_readonly, provenance, created_at) FROM stdin;
\.
COPY public.application_group_ou_entry (group_id, org_unit_id, is_readonly, provenance, created_at) FROM '/docker-entrypoint-initdb.d/4392.dat';

--
-- Data for Name: assessment_definition; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.assessment_definition (id, name, external_id, rating_scheme_id, entity_kind, description, permitted_role, last_updated_at, last_updated_by, is_readonly, provenance, visibility, definition_group, qualifier_kind, qualifier_id) FROM stdin;
\.
COPY public.assessment_definition (id, name, external_id, rating_scheme_id, entity_kind, description, permitted_role, last_updated_at, last_updated_by, is_readonly, provenance, visibility, definition_group, qualifier_kind, qualifier_id) FROM '/docker-entrypoint-initdb.d/4394.dat';

--
-- Data for Name: assessment_rating; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.assessment_rating (entity_id, entity_kind, assessment_definition_id, rating_id, description, last_updated_at, last_updated_by, provenance, is_readonly) FROM stdin;
\.
COPY public.assessment_rating (entity_id, entity_kind, assessment_definition_id, rating_id, description, last_updated_at, last_updated_by, provenance, is_readonly) FROM '/docker-entrypoint-initdb.d/4396.dat';

--
-- Data for Name: attestation_instance; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.attestation_instance (id, attestation_run_id, parent_entity_id, parent_entity_kind, attested_at, attested_by, attested_entity_kind) FROM stdin;
\.
COPY public.attestation_instance (id, attestation_run_id, parent_entity_id, parent_entity_kind, attested_at, attested_by, attested_entity_kind) FROM '/docker-entrypoint-initdb.d/4397.dat';

--
-- Data for Name: attestation_instance_recipient; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.attestation_instance_recipient (id, attestation_instance_id, user_id) FROM stdin;
\.
COPY public.attestation_instance_recipient (id, attestation_instance_id, user_id) FROM '/docker-entrypoint-initdb.d/4399.dat';

--
-- Data for Name: attestation_run; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.attestation_run (id, target_entity_kind, name, description, selector_entity_kind, selector_entity_id, selector_hierarchy_scope, involvement_kind_ids, issued_by, issued_on, due_date, attested_entity_kind, attested_entity_id, status, provenance) FROM stdin;
\.
COPY public.attestation_run (id, target_entity_kind, name, description, selector_entity_kind, selector_entity_id, selector_hierarchy_scope, involvement_kind_ids, issued_by, issued_on, due_date, attested_entity_kind, attested_entity_id, status, provenance) FROM '/docker-entrypoint-initdb.d/4401.dat';

--
-- Data for Name: attribute_change; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.attribute_change (id, change_unit_id, type, new_value, old_value, name, last_updated_at, last_updated_by, provenance) FROM stdin;
\.
COPY public.attribute_change (id, change_unit_id, type, new_value, old_value, name, last_updated_at, last_updated_by, provenance) FROM '/docker-entrypoint-initdb.d/4403.dat';

--
-- Data for Name: bookmark; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.bookmark (id, title, description, kind, url, parent_kind, parent_id, created_at, updated_at, is_primary, provenance, last_updated_by, is_required, is_restricted) FROM stdin;
\.
COPY public.bookmark (id, title, description, kind, url, parent_kind, parent_id, created_at, updated_at, is_primary, provenance, last_updated_by, is_required, is_restricted) FROM '/docker-entrypoint-initdb.d/4405.dat';

--
-- Data for Name: change_initiative; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.change_initiative (id, parent_id, external_id, name, kind, lifecycle_phase, description, last_update, start_date, end_date, provenance, organisational_unit_id) FROM stdin;
\.
COPY public.change_initiative (id, parent_id, external_id, name, kind, lifecycle_phase, description, last_update, start_date, end_date, provenance, organisational_unit_id) FROM '/docker-entrypoint-initdb.d/4407.dat';

--
-- Data for Name: change_log; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.change_log (id, parent_kind, parent_id, message, user_id, severity, created_at, child_kind, operation) FROM stdin;
\.
COPY public.change_log (id, parent_kind, parent_id, message, user_id, severity, created_at, child_kind, operation) FROM '/docker-entrypoint-initdb.d/4408.dat';

--
-- Data for Name: change_set; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.change_set (id, parent_entity_kind, parent_entity_id, planned_date, entity_lifecycle_status, name, description, last_updated_at, last_updated_by, external_id, provenance) FROM stdin;
\.
COPY public.change_set (id, parent_entity_kind, parent_entity_id, planned_date, entity_lifecycle_status, name, description, last_updated_at, last_updated_by, external_id, provenance) FROM '/docker-entrypoint-initdb.d/4410.dat';

--
-- Data for Name: change_unit; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.change_unit (id, change_set_id, subject_entity_kind, subject_entity_id, subject_initial_status, action, execution_status, name, description, last_updated_at, last_updated_by, external_id, provenance) FROM stdin;
\.
COPY public.change_unit (id, change_set_id, subject_entity_kind, subject_entity_id, subject_initial_status, action, execution_status, name, description, last_updated_at, last_updated_by, external_id, provenance) FROM '/docker-entrypoint-initdb.d/4412.dat';

--
-- Data for Name: client_cache_key; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.client_cache_key (key, guid, last_updated_at) FROM stdin;
\.
COPY public.client_cache_key (key, guid, last_updated_at) FROM '/docker-entrypoint-initdb.d/4414.dat';

--
-- Data for Name: complexity; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.complexity (id, complexity_kind_id, entity_id, entity_kind, score, last_updated_at, last_updated_by, provenance) FROM stdin;
\.
COPY public.complexity (id, complexity_kind_id, entity_id, entity_kind, score, last_updated_at, last_updated_by, provenance) FROM '/docker-entrypoint-initdb.d/4565.dat';

--
-- Data for Name: complexity_kind; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.complexity_kind (id, name, description, external_id, is_default) FROM stdin;
\.
COPY public.complexity_kind (id, name, description, external_id, is_default) FROM '/docker-entrypoint-initdb.d/4563.dat';

--
-- Data for Name: complexity_score_old; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.complexity_score_old (entity_kind, entity_id, complexity_kind, score) FROM stdin;
\.
COPY public.complexity_score_old (entity_kind, entity_id, complexity_kind, score) FROM '/docker-entrypoint-initdb.d/4415.dat';

--
-- Data for Name: cost; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.cost (id, cost_kind_id, entity_id, entity_kind, year, amount, last_updated_at, last_updated_by, provenance) FROM stdin;
\.
COPY public.cost (id, cost_kind_id, entity_id, entity_kind, year, amount, last_updated_at, last_updated_by, provenance) FROM '/docker-entrypoint-initdb.d/4416.dat';

--
-- Data for Name: cost_kind; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.cost_kind (id, name, description, is_default, external_id) FROM stdin;
\.
COPY public.cost_kind (id, name, description, is_default, external_id) FROM '/docker-entrypoint-initdb.d/4418.dat';

--
-- Data for Name: custom_environment; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.custom_environment (id, owning_entity_id, owning_entity_kind, name, description, external_id, group_name) FROM stdin;
\.
COPY public.custom_environment (id, owning_entity_id, owning_entity_kind, name, description, external_id, group_name) FROM '/docker-entrypoint-initdb.d/4569.dat';

--
-- Data for Name: custom_environment_usage; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.custom_environment_usage (id, custom_environment_id, entity_id, entity_kind, created_at, created_by, provenance) FROM stdin;
\.
COPY public.custom_environment_usage (id, custom_environment_id, entity_id, entity_kind, created_at, created_by, provenance) FROM '/docker-entrypoint-initdb.d/4571.dat';

--
-- Data for Name: data_type; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.data_type (code, name, description, id, parent_id, concrete, unknown, last_updated_at, deprecated) FROM stdin;
\.
COPY public.data_type (code, name, description, id, parent_id, concrete, unknown, last_updated_at, deprecated) FROM '/docker-entrypoint-initdb.d/4422.dat';

--
-- Data for Name: data_type_usage; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.data_type_usage (entity_kind, entity_id, usage_kind, description, provenance, is_selected, data_type_id) FROM stdin;
\.
COPY public.data_type_usage (entity_kind, entity_id, usage_kind, description, provenance, is_selected, data_type_id) FROM '/docker-entrypoint-initdb.d/4423.dat';

--
-- Data for Name: database_information; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.database_information (id, database_name, instance_name, dbms_vendor, dbms_name, dbms_version, external_id, end_of_life_date, lifecycle_status, provenance) FROM stdin;
\.
COPY public.database_information (id, database_name, instance_name, dbms_vendor, dbms_name, dbms_version, external_id, end_of_life_date, lifecycle_status, provenance) FROM '/docker-entrypoint-initdb.d/4575.dat';

--
-- Data for Name: database_usage; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.database_usage (id, database_id, entity_kind, entity_id, environment, last_updated_at, last_updated_by, provenance) FROM stdin;
\.
COPY public.database_usage (id, database_id, entity_kind, entity_id, environment, last_updated_at, last_updated_by, provenance) FROM '/docker-entrypoint-initdb.d/4573.dat';

--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
\.
COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM '/docker-entrypoint-initdb.d/4424.dat';

--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
\.
COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM '/docker-entrypoint-initdb.d/4425.dat';

--
-- Data for Name: end_user_application; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.end_user_application (id, name, description, kind, lifecycle_phase, risk_rating, organisational_unit_id, provenance, external_id, is_promoted) FROM stdin;
\.
COPY public.end_user_application (id, name, description, kind, lifecycle_phase, risk_rating, organisational_unit_id, provenance, external_id, is_promoted) FROM '/docker-entrypoint-initdb.d/4426.dat';

--
-- Data for Name: entity_alias; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_alias (id, alias, kind, provenance) FROM stdin;
\.
COPY public.entity_alias (id, alias, kind, provenance) FROM '/docker-entrypoint-initdb.d/4427.dat';

--
-- Data for Name: entity_enum_definition; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_enum_definition (id, name, description, icon_name, entity_kind, enum_value_type, "position", is_editable) FROM stdin;
\.
COPY public.entity_enum_definition (id, name, description, icon_name, entity_kind, enum_value_type, "position", is_editable) FROM '/docker-entrypoint-initdb.d/4428.dat';

--
-- Data for Name: entity_enum_value; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_enum_value (definition_id, entity_kind, entity_id, enum_value_key, last_updated_at, last_updated_by, provenance) FROM stdin;
\.
COPY public.entity_enum_value (definition_id, entity_kind, entity_id, enum_value_key, last_updated_at, last_updated_by, provenance) FROM '/docker-entrypoint-initdb.d/4430.dat';

--
-- Data for Name: entity_field_reference; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_field_reference (id, entity_kind, field_name, display_name, description) FROM stdin;
\.
COPY public.entity_field_reference (id, entity_kind, field_name, display_name, description) FROM '/docker-entrypoint-initdb.d/4591.dat';

--
-- Data for Name: entity_hierarchy; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_hierarchy (kind, id, ancestor_id, level, descendant_level) FROM stdin;
\.
COPY public.entity_hierarchy (kind, id, ancestor_id, level, descendant_level) FROM '/docker-entrypoint-initdb.d/4431.dat';

--
-- Data for Name: entity_named_note; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_named_note (entity_id, entity_kind, named_note_type_id, note_text, provenance, last_updated_at, last_updated_by) FROM stdin;
\.
COPY public.entity_named_note (entity_id, entity_kind, named_note_type_id, note_text, provenance, last_updated_at, last_updated_by) FROM '/docker-entrypoint-initdb.d/4432.dat';

--
-- Data for Name: entity_named_note_type; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_named_note_type (id, applicable_entity_kinds, name, description, is_readonly, "position", external_id) FROM stdin;
\.
COPY public.entity_named_note_type (id, applicable_entity_kinds, name, description, is_readonly, "position", external_id) FROM '/docker-entrypoint-initdb.d/4433.dat';

--
-- Data for Name: entity_relationship; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_relationship (kind_a, id_a, kind_b, id_b, relationship, provenance, description, last_updated_at, last_updated_by, id) FROM stdin;
\.
COPY public.entity_relationship (kind_a, id_a, kind_b, id_b, relationship, provenance, description, last_updated_at, last_updated_by, id) FROM '/docker-entrypoint-initdb.d/4435.dat';

--
-- Data for Name: entity_statistic_definition; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_statistic_definition (name, description, type, category, active, renderer, historic_renderer, provenance, parent_id, id, entity_visibility, rollup_visibility, rollup_kind) FROM stdin;
\.
COPY public.entity_statistic_definition (name, description, type, category, active, renderer, historic_renderer, provenance, parent_id, id, entity_visibility, rollup_visibility, rollup_kind) FROM '/docker-entrypoint-initdb.d/4436.dat';

--
-- Data for Name: entity_statistic_value; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_statistic_value (id, statistic_id, entity_kind, entity_id, value, outcome, state, reason, created_at, current, provenance) FROM stdin;
\.
COPY public.entity_statistic_value (id, statistic_id, entity_kind, entity_id, value, outcome, state, reason, created_at, current, provenance) FROM '/docker-entrypoint-initdb.d/4437.dat';

--
-- Data for Name: entity_svg_diagram; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_svg_diagram (id, entity_kind, entity_id, name, svg, description, provenance, external_id) FROM stdin;
\.
COPY public.entity_svg_diagram (id, entity_kind, entity_id, name, svg, description, provenance, external_id) FROM '/docker-entrypoint-initdb.d/4439.dat';

--
-- Data for Name: entity_tag; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_tag (entity_id, entity_kind, tag, last_updated_at, last_updated_by, provenance) FROM stdin;
\.
COPY public.entity_tag (entity_id, entity_kind, tag, last_updated_at, last_updated_by, provenance) FROM '/docker-entrypoint-initdb.d/4441.dat';

--
-- Data for Name: entity_workflow_definition; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_workflow_definition (id, name, description) FROM stdin;
\.
COPY public.entity_workflow_definition (id, name, description) FROM '/docker-entrypoint-initdb.d/4442.dat';

--
-- Data for Name: entity_workflow_state; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_workflow_state (workflow_id, entity_id, entity_kind, state, last_updated_at, last_updated_by, provenance, description) FROM stdin;
\.
COPY public.entity_workflow_state (workflow_id, entity_id, entity_kind, state, last_updated_at, last_updated_by, provenance, description) FROM '/docker-entrypoint-initdb.d/4444.dat';

--
-- Data for Name: entity_workflow_transition; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.entity_workflow_transition (workflow_id, entity_id, entity_kind, from_state, to_state, reason, last_updated_at, last_updated_by, provenance) FROM stdin;
\.
COPY public.entity_workflow_transition (workflow_id, entity_id, entity_kind, from_state, to_state, reason, last_updated_at, last_updated_by, provenance) FROM '/docker-entrypoint-initdb.d/4445.dat';

--
-- Data for Name: enum_value; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.enum_value (type, key, display_name, description, icon_name, "position", icon_color) FROM stdin;
\.
COPY public.enum_value (type, key, display_name, description, icon_name, "position", icon_color) FROM '/docker-entrypoint-initdb.d/4446.dat';

--
-- Data for Name: enum_value_alias; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.enum_value_alias (enum_type, enum_key, alias) FROM stdin;
\.
COPY public.enum_value_alias (enum_type, enum_key, alias) FROM '/docker-entrypoint-initdb.d/4447.dat';

--
-- Data for Name: external_identifier; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.external_identifier (entity_kind, entity_id, system, external_id) FROM stdin;
\.
COPY public.external_identifier (entity_kind, entity_id, system, external_id) FROM '/docker-entrypoint-initdb.d/4448.dat';

--
-- Data for Name: flow_classification; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.flow_classification (id, name, description, code, color, "position", is_custom, user_selectable) FROM stdin;
\.
COPY public.flow_classification (id, name, description, code, color, "position", is_custom, user_selectable) FROM '/docker-entrypoint-initdb.d/4583.dat';

--
-- Data for Name: flow_classification_rule; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.flow_classification_rule (id, parent_kind, parent_id, application_id, data_type_id, flow_classification_id, description, external_id, last_updated_at, last_updated_by, provenance, is_readonly) FROM stdin;
\.
COPY public.flow_classification_rule (id, parent_kind, parent_id, application_id, data_type_id, flow_classification_id, description, external_id, last_updated_at, last_updated_by, provenance, is_readonly) FROM '/docker-entrypoint-initdb.d/4581.dat';

--
-- Data for Name: flow_diagram; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.flow_diagram (id, name, description, layout_data, last_updated_at, last_updated_by, is_removed, editor_role) FROM stdin;
\.
COPY public.flow_diagram (id, name, description, layout_data, last_updated_at, last_updated_by, is_removed, editor_role) FROM '/docker-entrypoint-initdb.d/4449.dat';

--
-- Data for Name: flow_diagram_annotation; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.flow_diagram_annotation (annotation_id, diagram_id, entity_id, entity_kind, note) FROM stdin;
\.
COPY public.flow_diagram_annotation (annotation_id, diagram_id, entity_id, entity_kind, note) FROM '/docker-entrypoint-initdb.d/4450.dat';

--
-- Data for Name: flow_diagram_entity; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.flow_diagram_entity (diagram_id, entity_id, entity_kind, is_notable) FROM stdin;
\.
COPY public.flow_diagram_entity (diagram_id, entity_id, entity_kind, is_notable) FROM '/docker-entrypoint-initdb.d/4451.dat';

--
-- Data for Name: flow_diagram_overlay_group; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.flow_diagram_overlay_group (id, flow_diagram_id, name, description, external_id, is_default) FROM stdin;
\.
COPY public.flow_diagram_overlay_group (id, flow_diagram_id, name, description, external_id, is_default) FROM '/docker-entrypoint-initdb.d/4577.dat';

--
-- Data for Name: flow_diagram_overlay_group_entry; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.flow_diagram_overlay_group_entry (id, overlay_group_id, entity_id, entity_kind, symbol, fill, stroke) FROM stdin;
\.
COPY public.flow_diagram_overlay_group_entry (id, overlay_group_id, entity_id, entity_kind, symbol, fill, stroke) FROM '/docker-entrypoint-initdb.d/4579.dat';

--
-- Data for Name: involvement; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.involvement (entity_kind, entity_id, employee_id, provenance, kind_id, is_readonly) FROM stdin;
\.
COPY public.involvement (entity_kind, entity_id, employee_id, provenance, kind_id, is_readonly) FROM '/docker-entrypoint-initdb.d/4453.dat';

--
-- Data for Name: involvement_group; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.involvement_group (id, name, external_id, provenance) FROM stdin;
\.
COPY public.involvement_group (id, name, external_id, provenance) FROM '/docker-entrypoint-initdb.d/4454.dat';

--
-- Data for Name: involvement_group_entry; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.involvement_group_entry (involvement_group_id, involvement_kind_id) FROM stdin;
\.
COPY public.involvement_group_entry (involvement_group_id, involvement_kind_id) FROM '/docker-entrypoint-initdb.d/4455.dat';

--
-- Data for Name: involvement_kind; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.involvement_kind (id, name, description, last_updated_at, last_updated_by, external_id, user_selectable) FROM stdin;
\.
COPY public.involvement_kind (id, name, description, last_updated_at, last_updated_by, external_id, user_selectable) FROM '/docker-entrypoint-initdb.d/4457.dat';

--
-- Data for Name: key_involvement_kind; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.key_involvement_kind (involvement_kind_id, entity_kind) FROM stdin;
\.
COPY public.key_involvement_kind (involvement_kind_id, entity_kind) FROM '/docker-entrypoint-initdb.d/4460.dat';

--
-- Data for Name: licence; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.licence (id, name, description, external_id, approval_status, created_by, created_at, last_updated_by, last_updated_at, provenance) FROM stdin;
\.
COPY public.licence (id, name, description, external_id, approval_status, created_by, created_at, last_updated_by, last_updated_at, provenance) FROM '/docker-entrypoint-initdb.d/4461.dat';

--
-- Data for Name: logical_data_element; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.logical_data_element (id, external_id, name, description, type, provenance, entity_lifecycle_status, parent_data_type_id) FROM stdin;
\.
COPY public.logical_data_element (id, external_id, name, description, type, provenance, entity_lifecycle_status, parent_data_type_id) FROM '/docker-entrypoint-initdb.d/4463.dat';

--
-- Data for Name: logical_flow; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.logical_flow (source_entity_kind, source_entity_id, target_entity_kind, target_entity_id, provenance, id, last_updated_at, last_updated_by, last_attested_at, last_attested_by, entity_lifecycle_status, is_removed, created_at, created_by, is_readonly) FROM stdin;
\.
COPY public.logical_flow (source_entity_kind, source_entity_id, target_entity_kind, target_entity_id, provenance, id, last_updated_at, last_updated_by, last_attested_at, last_attested_by, entity_lifecycle_status, is_removed, created_at, created_by, is_readonly) FROM '/docker-entrypoint-initdb.d/4420.dat';

--
-- Data for Name: logical_flow_decorator; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.logical_flow_decorator (logical_flow_id, decorator_entity_kind, decorator_entity_id, rating, provenance, last_updated_at, last_updated_by, id, is_readonly, flow_classification_rule_id) FROM stdin;
\.
COPY public.logical_flow_decorator (logical_flow_id, decorator_entity_kind, decorator_entity_id, rating, provenance, last_updated_at, last_updated_by, id, is_readonly, flow_classification_rule_id) FROM '/docker-entrypoint-initdb.d/4465.dat';

--
-- Data for Name: measurable; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.measurable (id, parent_id, name, concrete, description, external_id, last_updated_at, last_updated_by, provenance, measurable_category_id, external_parent_id, entity_lifecycle_status, organisational_unit_id) FROM stdin;
\.
COPY public.measurable (id, parent_id, name, concrete, description, external_id, last_updated_at, last_updated_by, provenance, measurable_category_id, external_parent_id, entity_lifecycle_status, organisational_unit_id) FROM '/docker-entrypoint-initdb.d/4467.dat';

--
-- Data for Name: measurable_category; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.measurable_category (id, name, description, external_id, last_updated_at, last_updated_by, rating_scheme_id, editable, rating_editor_role, constraining_assessment_definition_id) FROM stdin;
\.
COPY public.measurable_category (id, name, description, external_id, last_updated_at, last_updated_by, rating_scheme_id, editable, rating_editor_role, constraining_assessment_definition_id) FROM '/docker-entrypoint-initdb.d/4468.dat';

--
-- Data for Name: measurable_rating; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.measurable_rating (entity_id, entity_kind, measurable_id, rating, description, last_updated_at, last_updated_by, provenance, is_readonly) FROM stdin;
\.
COPY public.measurable_rating (entity_id, entity_kind, measurable_id, rating, description, last_updated_at, last_updated_by, provenance, is_readonly) FROM '/docker-entrypoint-initdb.d/4471.dat';

--
-- Data for Name: measurable_rating_planned_decommission; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.measurable_rating_planned_decommission (id, entity_id, entity_kind, measurable_id, planned_decommission_date, created_by, created_at, updated_by, updated_at) FROM stdin;
\.
COPY public.measurable_rating_planned_decommission (id, entity_id, entity_kind, measurable_id, planned_decommission_date, created_by, created_at, updated_by, updated_at) FROM '/docker-entrypoint-initdb.d/4472.dat';

--
-- Data for Name: measurable_rating_replacement; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.measurable_rating_replacement (id, decommission_id, planned_commission_date, entity_id, entity_kind, created_by, created_at, updated_by, updated_at) FROM stdin;
\.
COPY public.measurable_rating_replacement (id, decommission_id, planned_commission_date, entity_id, entity_kind, created_by, created_at, updated_by, updated_at) FROM '/docker-entrypoint-initdb.d/4474.dat';

--
-- Data for Name: organisational_unit; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.organisational_unit (id, name, description, parent_id, created_at, last_updated_at, external_id, created_by, last_updated_by, provenance) FROM stdin;
\.
COPY public.organisational_unit (id, name, description, parent_id, created_at, last_updated_at, external_id, created_by, last_updated_by, provenance) FROM '/docker-entrypoint-initdb.d/4476.dat';

--
-- Data for Name: permission_group; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.permission_group (id, name, external_id, description, provenance, is_default) FROM stdin;
\.
COPY public.permission_group (id, name, external_id, description, provenance, is_default) FROM '/docker-entrypoint-initdb.d/4477.dat';

--
-- Data for Name: permission_group_entry; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.permission_group_entry (entity_id, permission_group_id, entity_kind) FROM stdin;
\.
COPY public.permission_group_entry (entity_id, permission_group_id, entity_kind) FROM '/docker-entrypoint-initdb.d/4478.dat';

--
-- Data for Name: permission_group_involvement; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.permission_group_involvement (permission_group_id, involvement_group_id, operation, parent_kind, subject_kind, qualifier_kind, qualifier_id) FROM stdin;
\.
COPY public.permission_group_involvement (permission_group_id, involvement_group_id, operation, parent_kind, subject_kind, qualifier_kind, qualifier_id) FROM '/docker-entrypoint-initdb.d/4480.dat';

--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.person (id, employee_id, display_name, email, user_principal_name, department_name, kind, manager_employee_id, title, office_phone, mobile_phone, organisational_unit_id, is_removed) FROM stdin;
\.
COPY public.person (id, employee_id, display_name, email, user_principal_name, department_name, kind, manager_employee_id, title, office_phone, mobile_phone, organisational_unit_id, is_removed) FROM '/docker-entrypoint-initdb.d/4481.dat';

--
-- Data for Name: person_hierarchy; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.person_hierarchy (manager_id, employee_id, level) FROM stdin;
\.
COPY public.person_hierarchy (manager_id, employee_id, level) FROM '/docker-entrypoint-initdb.d/4482.dat';

--
-- Data for Name: physical_flow; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.physical_flow (id, specification_id, basis_offset, frequency, transport, description, provenance, last_updated_at, last_updated_by, logical_flow_id, specification_definition_id, is_removed, last_attested_at, last_attested_by, criticality, external_id, entity_lifecycle_status, created_at, created_by, is_readonly, name) FROM stdin;
\.
COPY public.physical_flow (id, specification_id, basis_offset, frequency, transport, description, provenance, last_updated_at, last_updated_by, logical_flow_id, specification_definition_id, is_removed, last_attested_at, last_attested_by, criticality, external_id, entity_lifecycle_status, created_at, created_by, is_readonly, name) FROM '/docker-entrypoint-initdb.d/4486.dat';

--
-- Data for Name: physical_flow_participant; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.physical_flow_participant (physical_flow_id, kind, participant_entity_kind, participant_entity_id, description, last_updated_at, last_updated_by, provenance) FROM stdin;
\.
COPY public.physical_flow_participant (physical_flow_id, kind, participant_entity_kind, participant_entity_id, description, last_updated_at, last_updated_by, provenance) FROM '/docker-entrypoint-initdb.d/4488.dat';

--
-- Data for Name: physical_spec_data_type; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.physical_spec_data_type (specification_id, data_type_id, provenance, last_updated_at, last_updated_by, is_readonly) FROM stdin;
\.
COPY public.physical_spec_data_type (specification_id, data_type_id, provenance, last_updated_at, last_updated_by, is_readonly) FROM '/docker-entrypoint-initdb.d/4489.dat';

--
-- Data for Name: physical_spec_defn; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.physical_spec_defn (id, specification_id, version, delimiter, type, provenance, created_at, created_by, last_updated_at, last_updated_by, status) FROM stdin;
\.
COPY public.physical_spec_defn (id, specification_id, version, delimiter, type, provenance, created_at, created_by, last_updated_at, last_updated_by, status) FROM '/docker-entrypoint-initdb.d/4490.dat';

--
-- Data for Name: physical_spec_defn_field; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.physical_spec_defn_field (id, spec_defn_id, name, "position", type, description, last_updated_at, last_updated_by, logical_data_element_id) FROM stdin;
\.
COPY public.physical_spec_defn_field (id, spec_defn_id, name, "position", type, description, last_updated_at, last_updated_by, logical_data_element_id) FROM '/docker-entrypoint-initdb.d/4491.dat';

--
-- Data for Name: physical_spec_defn_sample_file; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.physical_spec_defn_sample_file (id, spec_defn_id, name, file_data) FROM stdin;
\.
COPY public.physical_spec_defn_sample_file (id, spec_defn_id, name, file_data) FROM '/docker-entrypoint-initdb.d/4494.dat';

--
-- Data for Name: physical_specification; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.physical_specification (id, owning_entity_id, external_id, name, format, description, provenance, owning_entity_kind, last_updated_at, last_updated_by, is_removed, created_at, created_by) FROM stdin;
\.
COPY public.physical_specification (id, owning_entity_id, external_id, name, format, description, provenance, owning_entity_kind, last_updated_at, last_updated_by, is_removed, created_at, created_by) FROM '/docker-entrypoint-initdb.d/4484.dat';

--
-- Data for Name: process_diagram; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.process_diagram (id, name, description, diagram_kind, layout_data, last_updated_at, last_updated_by, created_at, created_by, external_id, provenance) FROM stdin;
\.
COPY public.process_diagram (id, name, description, diagram_kind, layout_data, last_updated_at, last_updated_by, created_at, created_by, external_id, provenance) FROM '/docker-entrypoint-initdb.d/4585.dat';

--
-- Data for Name: process_diagram_entity; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.process_diagram_entity (diagram_id, entity_id, entity_kind, is_notable) FROM stdin;
\.
COPY public.process_diagram_entity (diagram_id, entity_id, entity_kind, is_notable) FROM '/docker-entrypoint-initdb.d/4586.dat';

--
-- Data for Name: rating_scheme; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.rating_scheme (id, name, description) FROM stdin;
\.
COPY public.rating_scheme (id, name, description) FROM '/docker-entrypoint-initdb.d/4496.dat';

--
-- Data for Name: rating_scheme_item; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.rating_scheme_item (id, scheme_id, name, description, code, color, "position", user_selectable, external_id) FROM stdin;
\.
COPY public.rating_scheme_item (id, scheme_id, name, description, code, color, "position", user_selectable, external_id) FROM '/docker-entrypoint-initdb.d/4498.dat';

--
-- Data for Name: relationship_kind; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.relationship_kind (id, name, description, kind_a, kind_b, category_a, category_b, is_readonly, code, "position", reverse_name) FROM stdin;
\.
COPY public.relationship_kind (id, name, description, kind_a, kind_b, category_a, category_b, is_readonly, code, "position", reverse_name) FROM '/docker-entrypoint-initdb.d/4500.dat';

--
-- Data for Name: report_grid; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.report_grid (id, name, description, last_updated_at, last_updated_by, provenance, external_id, kind, subject_kind) FROM stdin;
\.
COPY public.report_grid (id, name, description, last_updated_at, last_updated_by, provenance, external_id, kind, subject_kind) FROM '/docker-entrypoint-initdb.d/4502.dat';

--
-- Data for Name: report_grid_column_definition; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.report_grid_column_definition (id, report_grid_id, "position") FROM stdin;
\.
COPY public.report_grid_column_definition (id, report_grid_id, "position") FROM '/docker-entrypoint-initdb.d/4604.dat';

--
-- Data for Name: report_grid_derived_column_definition; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.report_grid_derived_column_definition (id, display_name, column_description, derivation_script, external_id, grid_column_id) FROM stdin;
\.
COPY public.report_grid_derived_column_definition (id, display_name, column_description, derivation_script, external_id, grid_column_id) FROM '/docker-entrypoint-initdb.d/4603.dat';

--
-- Data for Name: report_grid_fixed_column_definition; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.report_grid_fixed_column_definition (id, column_entity_kind, column_entity_id, display_name, additional_column_options, entity_field_reference_id, column_qualifier_kind, column_qualifier_id, external_id, grid_column_id) FROM stdin;
\.
COPY public.report_grid_fixed_column_definition (id, column_entity_kind, column_entity_id, display_name, additional_column_options, entity_field_reference_id, column_qualifier_kind, column_qualifier_id, external_id, grid_column_id) FROM '/docker-entrypoint-initdb.d/4503.dat';

--
-- Data for Name: report_grid_member; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.report_grid_member (grid_id, user_id, role) FROM stdin;
\.
COPY public.report_grid_member (grid_id, user_id, role) FROM '/docker-entrypoint-initdb.d/4589.dat';

--
-- Data for Name: roadmap; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.roadmap (id, name, description, row_type_kind, rating_scheme_id, row_type_id, column_type_kind, column_type_id, last_updated_at, last_updated_by, entity_lifecycle_status) FROM stdin;
\.
COPY public.roadmap (id, name, description, row_type_kind, rating_scheme_id, row_type_id, column_type_kind, column_type_id, last_updated_at, last_updated_by, entity_lifecycle_status) FROM '/docker-entrypoint-initdb.d/4506.dat';

--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.role (key, is_custom, name, description, user_selectable) FROM stdin;
\.
COPY public.role (key, is_custom, name, description, user_selectable) FROM '/docker-entrypoint-initdb.d/4508.dat';

--
-- Data for Name: scenario; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.scenario (id, name, description, lifecycle_status, roadmap_id, last_updated_at, last_updated_by, effective_date, scenario_type, release_status, "position") FROM stdin;
\.
COPY public.scenario (id, name, description, lifecycle_status, roadmap_id, last_updated_at, last_updated_by, effective_date, scenario_type, release_status, "position") FROM '/docker-entrypoint-initdb.d/4509.dat';

--
-- Data for Name: scenario_axis_item; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.scenario_axis_item (id, orientation, scenario_id, "position", domain_item_kind, domain_item_id) FROM stdin;
\.
COPY public.scenario_axis_item (id, orientation, scenario_id, "position", domain_item_kind, domain_item_id) FROM '/docker-entrypoint-initdb.d/4510.dat';

--
-- Data for Name: scenario_rating_item; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.scenario_rating_item (id, scenario_id, rating, domain_item_kind, domain_item_id, row_kind, row_id, column_kind, column_id, last_updated_at, last_updated_by, description) FROM stdin;
\.
COPY public.scenario_rating_item (id, scenario_id, rating, domain_item_kind, domain_item_id, row_kind, row_id, column_kind, column_id, last_updated_at, last_updated_by, description) FROM '/docker-entrypoint-initdb.d/4513.dat';

--
-- Data for Name: server_information; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.server_information (id, hostname, operating_system, location, operating_system_version, country, is_virtual, provenance, os_end_of_life_date, hw_end_of_life_date, lifecycle_status, external_id) FROM stdin;
\.
COPY public.server_information (id, hostname, operating_system, location, operating_system_version, country, is_virtual, provenance, os_end_of_life_date, hw_end_of_life_date, lifecycle_status, external_id) FROM '/docker-entrypoint-initdb.d/4515.dat';

--
-- Data for Name: server_usage; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.server_usage (server_id, entity_kind, entity_id, environment, last_updated_at, last_updated_by, provenance, id) FROM stdin;
\.
COPY public.server_usage (server_id, entity_kind, entity_id, environment, last_updated_at, last_updated_by, provenance, id) FROM '/docker-entrypoint-initdb.d/4517.dat';

--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.settings (name, value, restricted, description) FROM stdin;
\.
COPY public.settings (name, value, restricted, description) FROM '/docker-entrypoint-initdb.d/4518.dat';

--
-- Data for Name: shared_preference; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.shared_preference (key, category, value, last_updated_at, last_updated_by) FROM stdin;
\.
COPY public.shared_preference (key, category, value, last_updated_at, last_updated_by) FROM '/docker-entrypoint-initdb.d/4519.dat';

--
-- Data for Name: software_package; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.software_package (id, vendor, name, notable, description, external_id, provenance, created_by, created_at, "group") FROM stdin;
\.
COPY public.software_package (id, vendor, name, notable, description, external_id, provenance, created_by, created_at, "group") FROM '/docker-entrypoint-initdb.d/4520.dat';

--
-- Data for Name: software_usage; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.software_usage (id, application_id, software_version_id, created_by, created_at, provenance) FROM stdin;
\.
COPY public.software_usage (id, application_id, software_version_id, created_by, created_at, provenance) FROM '/docker-entrypoint-initdb.d/4522.dat';

--
-- Data for Name: software_version; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.software_version (id, software_package_id, version, description, external_id, created_by, created_at, provenance, release_date) FROM stdin;
\.
COPY public.software_version (id, software_package_id, version, description, external_id, created_by, created_at, provenance, release_date) FROM '/docker-entrypoint-initdb.d/4524.dat';

--
-- Data for Name: software_version_licence; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.software_version_licence (id, software_version_id, licence_id, created_by, created_at, provenance) FROM stdin;
\.
COPY public.software_version_licence (id, software_version_id, licence_id, created_by, created_at, provenance) FROM '/docker-entrypoint-initdb.d/4526.dat';

--
-- Data for Name: software_version_vulnerability; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.software_version_vulnerability (software_version_id, vulnerability_id, created_at, provenance) FROM stdin;
\.
COPY public.software_version_vulnerability (software_version_id, vulnerability_id, created_at, provenance) FROM '/docker-entrypoint-initdb.d/4528.dat';

--
-- Data for Name: source_data_rating; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.source_data_rating (source_name, entity_kind, authoritativeness, accuracy, completeness, last_import) FROM stdin;
\.
COPY public.source_data_rating (source_name, entity_kind, authoritativeness, accuracy, completeness, last_import) FROM '/docker-entrypoint-initdb.d/4529.dat';

--
-- Data for Name: static_panel; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.static_panel (id, "group", title, icon, priority, width, encoding, content) FROM stdin;
\.
COPY public.static_panel (id, "group", title, icon, priority, width, encoding, content) FROM '/docker-entrypoint-initdb.d/4530.dat';

--
-- Data for Name: survey_instance; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.survey_instance (id, survey_run_id, entity_kind, entity_id, status, submitted_at, submitted_by, due_date, original_instance_id, approved_at, approved_by, owning_role, entity_qualifier_id, entity_qualifier_kind, name, approval_due_date, issued_on) FROM stdin;
\.
COPY public.survey_instance (id, survey_run_id, entity_kind, entity_id, status, submitted_at, submitted_by, due_date, original_instance_id, approved_at, approved_by, owning_role, entity_qualifier_id, entity_qualifier_kind, name, approval_due_date, issued_on) FROM '/docker-entrypoint-initdb.d/4532.dat';

--
-- Data for Name: survey_instance_owner; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.survey_instance_owner (id, survey_instance_id, person_id) FROM stdin;
\.
COPY public.survey_instance_owner (id, survey_instance_id, person_id) FROM '/docker-entrypoint-initdb.d/4588.dat';

--
-- Data for Name: survey_instance_recipient; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.survey_instance_recipient (id, survey_instance_id, person_id) FROM stdin;
\.
COPY public.survey_instance_recipient (id, survey_instance_id, person_id) FROM '/docker-entrypoint-initdb.d/4534.dat';

--
-- Data for Name: survey_question; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.survey_question (id, survey_template_id, question_text, field_type, section_name, "position", is_mandatory, allow_comment, help_text, external_id, inclusion_predicate, entity_qualifier_id, entity_qualifier_kind, parent_external_id, label) FROM stdin;
\.
COPY public.survey_question (id, survey_template_id, question_text, field_type, section_name, "position", is_mandatory, allow_comment, help_text, external_id, inclusion_predicate, entity_qualifier_id, entity_qualifier_kind, parent_external_id, label) FROM '/docker-entrypoint-initdb.d/4536.dat';

--
-- Data for Name: survey_question_dropdown_entry; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.survey_question_dropdown_entry (id, question_id, value, "position") FROM stdin;
\.
COPY public.survey_question_dropdown_entry (id, question_id, value, "position") FROM '/docker-entrypoint-initdb.d/4537.dat';

--
-- Data for Name: survey_question_list_response; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.survey_question_list_response (survey_instance_id, question_id, response, "position", entity_id, entity_kind) FROM stdin;
\.
COPY public.survey_question_list_response (survey_instance_id, question_id, response, "position", entity_id, entity_kind) FROM '/docker-entrypoint-initdb.d/4540.dat';

--
-- Data for Name: survey_question_response; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.survey_question_response (survey_instance_id, question_id, person_id, comment, last_updated_at, string_response, number_response, boolean_response, entity_response_id, entity_response_kind, date_response, list_response_concat) FROM stdin;
\.
COPY public.survey_question_response (survey_instance_id, question_id, person_id, comment, last_updated_at, string_response, number_response, boolean_response, entity_response_id, entity_response_kind, date_response, list_response_concat) FROM '/docker-entrypoint-initdb.d/4541.dat';

--
-- Data for Name: survey_run; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.survey_run (id, survey_template_id, name, description, selector_entity_kind, selector_entity_id, selector_hierarchy_scope, involvement_kind_ids, issued_on, due_date, issuance_kind, owner_id, contact_email, status, owner_inv_kind_ids, is_default, approval_due_date) FROM stdin;
\.
COPY public.survey_run (id, survey_template_id, name, description, selector_entity_kind, selector_entity_id, selector_hierarchy_scope, involvement_kind_ids, issued_on, due_date, issuance_kind, owner_id, contact_email, status, owner_inv_kind_ids, is_default, approval_due_date) FROM '/docker-entrypoint-initdb.d/4542.dat';

--
-- Data for Name: survey_template; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.survey_template (id, name, description, target_entity_kind, owner_id, created_at, status, external_id) FROM stdin;
\.
COPY public.survey_template (id, name, description, target_entity_kind, owner_id, created_at, status, external_id) FROM '/docker-entrypoint-initdb.d/4544.dat';

--
-- Data for Name: svg_diagram; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.svg_diagram (id, name, "group", priority, description, svg, key_property, product, display_width_percent, display_height_percent) FROM stdin;
\.
COPY public.svg_diagram (id, name, "group", priority, description, svg, key_property, product, display_width_percent, display_height_percent) FROM '/docker-entrypoint-initdb.d/4546.dat';

--
-- Data for Name: system_job_log; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.system_job_log (name, entity_kind, status, description, start, "end") FROM stdin;
\.
COPY public.system_job_log (name, entity_kind, status, description, start, "end") FROM '/docker-entrypoint-initdb.d/4548.dat';

--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.tag (id, name, target_kind) FROM stdin;
\.
COPY public.tag (id, name, target_kind) FROM '/docker-entrypoint-initdb.d/4549.dat';

--
-- Data for Name: tag_usage; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.tag_usage (tag_id, entity_id, entity_kind, created_at, created_by, provenance) FROM stdin;
\.
COPY public.tag_usage (tag_id, entity_id, entity_kind, created_at, created_by, provenance) FROM '/docker-entrypoint-initdb.d/4551.dat';

--
-- Data for Name: taxonomy_change; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.taxonomy_change (id, change_type, description, domain_kind, domain_id, primary_reference_kind, primary_reference_id, status, params, created_at, created_by, last_updated_at, last_updated_by) FROM stdin;
\.
COPY public.taxonomy_change (id, change_type, description, domain_kind, domain_id, primary_reference_kind, primary_reference_id, status, params, created_at, created_by, last_updated_at, last_updated_by) FROM '/docker-entrypoint-initdb.d/4552.dat';

--
-- Data for Name: thumbnail; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.thumbnail (parent_entity_kind, parent_entity_id, last_updated_at, last_updated_by, mime_type, blob, external_id, provenance) FROM stdin;
\.
COPY public.thumbnail (parent_entity_kind, parent_entity_id, last_updated_at, last_updated_by, mime_type, blob, external_id, provenance) FROM '/docker-entrypoint-initdb.d/4554.dat';

--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public."user" (user_name, password) FROM stdin;
\.
COPY public."user" (user_name, password) FROM '/docker-entrypoint-initdb.d/4555.dat';

--
-- Data for Name: user_agent_info; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.user_agent_info (id, user_name, user_agent, resolution, operating_system, ip_address, login_timestamp) FROM stdin;
\.
COPY public.user_agent_info (id, user_name, user_agent, resolution, operating_system, ip_address, login_timestamp) FROM '/docker-entrypoint-initdb.d/4556.dat';

--
-- Data for Name: user_preference; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.user_preference (key, value, user_name) FROM stdin;
\.
COPY public.user_preference (key, value, user_name) FROM '/docker-entrypoint-initdb.d/4558.dat';

--
-- Data for Name: user_role; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.user_role (user_name, role) FROM stdin;
\.
COPY public.user_role (user_name, role) FROM '/docker-entrypoint-initdb.d/4559.dat';

--
-- Data for Name: vulnerability; Type: TABLE DATA; Schema: public; Owner: waltz
--

COPY public.vulnerability (id, external_id, severity, description, created_at, provenance) FROM stdin;
\.
COPY public.vulnerability (id, external_id, severity, description, created_at, provenance) FROM '/docker-entrypoint-initdb.d/4560.dat';

--
-- Name: access_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.access_log_id_seq', 11801, true);


--
-- Name: aggregate_overlay_diagram_callout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.aggregate_overlay_diagram_callout_id_seq', 1, false);


--
-- Name: aggregate_overlay_diagram_cell_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.aggregate_overlay_diagram_cell_data_id_seq', 33, true);


--
-- Name: aggregate_overlay_diagram_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.aggregate_overlay_diagram_id_seq', 1, true);


--
-- Name: aggregate_overlay_diagram_instance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.aggregate_overlay_diagram_instance_id_seq', 1, false);


--
-- Name: aggregate_overlay_diagram_preset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.aggregate_overlay_diagram_preset_id_seq', 1, false);


--
-- Name: allocation_scheme_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.allocation_scheme_id_seq', 1, false);


--
-- Name: application_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.application_group_id_seq', 17, true);


--
-- Name: application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.application_id_seq', 101, true);


--
-- Name: assessment_definition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.assessment_definition_id_seq', 30, true);


--
-- Name: attestation_instance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.attestation_instance_id_seq', 156, true);


--
-- Name: attestation_instance_recipient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.attestation_instance_recipient_id_seq', 690, true);


--
-- Name: attestation_run_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.attestation_run_id_seq', 16, true);


--
-- Name: attribute_change_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.attribute_change_id_seq', 5, true);


--
-- Name: bookmark_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.bookmark_id_seq', 1993, true);


--
-- Name: change_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.change_log_id_seq', 3855, true);


--
-- Name: change_set_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.change_set_id_seq', 5, true);


--
-- Name: change_unit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.change_unit_id_seq', 12, true);


--
-- Name: complexity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.complexity_id_seq', 586, true);


--
-- Name: complexity_kind_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.complexity_kind_id_seq', 4, true);


--
-- Name: cost_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.cost_id_seq', 500, true);


--
-- Name: cost_kind_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.cost_kind_id_seq', 5, true);


--
-- Name: custom_environment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.custom_environment_id_seq', 12, true);


--
-- Name: custom_environment_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.custom_environment_usage_id_seq', 54, true);


--
-- Name: data_flow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.data_flow_id_seq', 443, true);


--
-- Name: database_information_2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.database_information_2_id_seq', 692, true);


--
-- Name: database_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.database_usage_id_seq', 737, true);


--
-- Name: entity_enum_definition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.entity_enum_definition_id_seq', 1, false);


--
-- Name: entity_field_reference_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.entity_field_reference_id_seq', 23, true);


--
-- Name: entity_named_note_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.entity_named_note_type_id_seq', 5, true);


--
-- Name: entity_relationship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.entity_relationship_id_seq', 51, true);


--
-- Name: entity_statistic_value_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.entity_statistic_value_id_seq', 30430, true);


--
-- Name: entity_svg_diagram_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.entity_svg_diagram_id_seq', 1, false);


--
-- Name: entity_workflow_definition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.entity_workflow_definition_id_seq', 1, false);


--
-- Name: flow_classification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.flow_classification_id_seq', 5, true);


--
-- Name: flow_classification_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.flow_classification_rule_id_seq', 23, true);


--
-- Name: flow_diagram_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.flow_diagram_id_seq', 10, true);


--
-- Name: flow_diagram_overlay_group_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.flow_diagram_overlay_group_entry_id_seq', 1, false);


--
-- Name: flow_diagram_overlay_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.flow_diagram_overlay_group_id_seq', 5, true);


--
-- Name: involvement_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.involvement_group_id_seq', 1, true);


--
-- Name: involvement_kind_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.involvement_kind_id_seq', 14, true);


--
-- Name: involvement_kind_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.involvement_kind_id_seq1', 14, true);


--
-- Name: licence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.licence_id_seq', 396, true);


--
-- Name: logical_data_element_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.logical_data_element_id_seq', 1, false);


--
-- Name: logical_flow_decorator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.logical_flow_decorator_id_seq', 451, true);


--
-- Name: measurable_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.measurable_category_id_seq', 7, true);


--
-- Name: measurable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.measurable_id_seq', 74976, true);


--
-- Name: measurable_rating_planned_decommission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.measurable_rating_planned_decommission_id_seq', 2, true);


--
-- Name: measurable_rating_replacement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.measurable_rating_replacement_id_seq', 2, true);


--
-- Name: permission_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.permission_group_id_seq', 1, true);


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.person_id_seq', 209, true);


--
-- Name: physical_data_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.physical_data_article_id_seq', 124, true);


--
-- Name: physical_data_flow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.physical_data_flow_id_seq', 612, true);


--
-- Name: physical_spec_defn_field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.physical_spec_defn_field_id_seq', 2, true);


--
-- Name: physical_spec_defn_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.physical_spec_defn_id_seq', 1, true);


--
-- Name: physical_spec_defn_sample_file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.physical_spec_defn_sample_file_id_seq', 1, false);


--
-- Name: process_diagram_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.process_diagram_id_seq', 1, false);


--
-- Name: rating_scheme_definition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.rating_scheme_definition_id_seq', 9, true);


--
-- Name: rating_scheme_definition_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.rating_scheme_definition_item_id_seq', 42, true);


--
-- Name: relationship_kind_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.relationship_kind_id_seq', 27, true);


--
-- Name: report_grid_column_definition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.report_grid_column_definition_id_seq', 167, true);


--
-- Name: report_grid_derived_column_definition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.report_grid_derived_column_definition_id_seq', 1, false);


--
-- Name: report_grid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.report_grid_id_seq', 10, true);


--
-- Name: roadmap_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.roadmap_id_seq', 2, true);


--
-- Name: scenario_axis_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.scenario_axis_item_id_seq', 21, true);


--
-- Name: scenario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.scenario_id_seq', 2, true);


--
-- Name: scenario_rating_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.scenario_rating_item_id_seq', 198, true);


--
-- Name: server_information_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.server_information_id_seq', 10000, true);


--
-- Name: server_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.server_usage_id_seq', 19782, true);


--
-- Name: software_package_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.software_package_id_seq', 1, false);


--
-- Name: software_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.software_usage_id_seq', 1, false);


--
-- Name: software_version_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.software_version_id_seq', 1, false);


--
-- Name: software_version_licence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.software_version_licence_id_seq', 1, false);


--
-- Name: static_panel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.static_panel_id_seq', 9, true);


--
-- Name: survey_instance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.survey_instance_id_seq', 152, true);


--
-- Name: survey_instance_owner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.survey_instance_owner_id_seq', 152, true);


--
-- Name: survey_instance_recipient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.survey_instance_recipient_id_seq', 394, true);


--
-- Name: survey_question_dropdown_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.survey_question_dropdown_entry_id_seq', 24, true);


--
-- Name: survey_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.survey_question_id_seq', 30, true);


--
-- Name: survey_run_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.survey_run_id_seq', 40, true);


--
-- Name: survey_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.survey_template_id_seq', 4, true);


--
-- Name: svg_diagram_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.svg_diagram_id_seq', 3, true);


--
-- Name: tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.tag_id_seq', 1, true);


--
-- Name: taxonomy_change_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.taxonomy_change_id_seq', 8, true);


--
-- Name: user_agent_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.user_agent_info_id_seq', 5326, true);


--
-- Name: vulnerability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: waltz
--

SELECT pg_catalog.setval('public.vulnerability_id_seq', 1, false);


--
-- Name: access_log access_log_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.access_log
    ADD CONSTRAINT access_log_pkey PRIMARY KEY (id);


--
-- Name: actor actor_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_pkey PRIMARY KEY (id);


--
-- Name: aggregate_overlay_diagram_callout aggregate_overlay_diagram_callout_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.aggregate_overlay_diagram_callout
    ADD CONSTRAINT aggregate_overlay_diagram_callout_pkey PRIMARY KEY (id);


--
-- Name: aggregate_overlay_diagram_cell_data aggregate_overlay_diagram_cell_data_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.aggregate_overlay_diagram_cell_data
    ADD CONSTRAINT aggregate_overlay_diagram_cell_data_pkey PRIMARY KEY (id);


--
-- Name: aggregate_overlay_diagram_instance aggregate_overlay_diagram_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.aggregate_overlay_diagram_instance
    ADD CONSTRAINT aggregate_overlay_diagram_instance_pkey PRIMARY KEY (id);


--
-- Name: aggregate_overlay_diagram aggregate_overlay_diagram_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.aggregate_overlay_diagram
    ADD CONSTRAINT aggregate_overlay_diagram_pkey PRIMARY KEY (id);


--
-- Name: aggregate_overlay_diagram_preset aggregate_overlay_diagram_preset_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.aggregate_overlay_diagram_preset
    ADD CONSTRAINT aggregate_overlay_diagram_preset_pkey PRIMARY KEY (id);


--
-- Name: allocation_scheme alloc_scheme_definition_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.allocation_scheme
    ADD CONSTRAINT alloc_scheme_definition_pkey PRIMARY KEY (id);


--
-- Name: allocation allocation_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.allocation
    ADD CONSTRAINT allocation_pkey PRIMARY KEY (allocation_scheme_id, measurable_id, entity_id, entity_kind);


--
-- Name: application_group_ou_entry app_group_ou_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.application_group_ou_entry
    ADD CONSTRAINT app_group_ou_entry_pkey PRIMARY KEY (group_id, org_unit_id);


--
-- Name: application_group_entry application_group_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.application_group_entry
    ADD CONSTRAINT application_group_entry_pkey PRIMARY KEY (group_id, application_id);


--
-- Name: application_group_member application_group_member_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.application_group_member
    ADD CONSTRAINT application_group_member_pkey PRIMARY KEY (group_id, user_id);


--
-- Name: application_group application_group_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.application_group
    ADD CONSTRAINT application_group_pkey PRIMARY KEY (id);


--
-- Name: application application_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_pkey PRIMARY KEY (id);


--
-- Name: assessment_definition assessment_definition_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.assessment_definition
    ADD CONSTRAINT assessment_definition_pkey PRIMARY KEY (id);


--
-- Name: assessment_rating assessment_rating_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.assessment_rating
    ADD CONSTRAINT assessment_rating_pkey PRIMARY KEY (entity_id, entity_kind, assessment_definition_id);


--
-- Name: attestation_instance attestation_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.attestation_instance
    ADD CONSTRAINT attestation_instance_pkey PRIMARY KEY (id);


--
-- Name: attestation_instance_recipient attestation_instance_recipient_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.attestation_instance_recipient
    ADD CONSTRAINT attestation_instance_recipient_pkey PRIMARY KEY (id);


--
-- Name: attestation_run attestation_run_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.attestation_run
    ADD CONSTRAINT attestation_run_pkey PRIMARY KEY (id);


--
-- Name: attribute_change attribute_change_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.attribute_change
    ADD CONSTRAINT attribute_change_pkey PRIMARY KEY (id);


--
-- Name: bookmark bookmark_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.bookmark
    ADD CONSTRAINT bookmark_pkey PRIMARY KEY (id);


--
-- Name: client_cache_key cache_key_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.client_cache_key
    ADD CONSTRAINT cache_key_pkey PRIMARY KEY (key);


--
-- Name: change_initiative change_initiative_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.change_initiative
    ADD CONSTRAINT change_initiative_pkey PRIMARY KEY (id);


--
-- Name: change_log change_log_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.change_log
    ADD CONSTRAINT change_log_pkey PRIMARY KEY (id);


--
-- Name: change_set change_set_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.change_set
    ADD CONSTRAINT change_set_pkey PRIMARY KEY (id);


--
-- Name: change_unit change_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.change_unit
    ADD CONSTRAINT change_unit_pkey PRIMARY KEY (id);


--
-- Name: complexity_kind complexity_kind_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.complexity_kind
    ADD CONSTRAINT complexity_kind_pkey PRIMARY KEY (id);


--
-- Name: complexity complexity_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.complexity
    ADD CONSTRAINT complexity_pkey PRIMARY KEY (id);


--
-- Name: complexity_score_old complexity_score_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.complexity_score_old
    ADD CONSTRAINT complexity_score_pkey PRIMARY KEY (entity_kind, entity_id, complexity_kind);


--
-- Name: cost_kind cost_kind_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.cost_kind
    ADD CONSTRAINT cost_kind_pkey PRIMARY KEY (id);


--
-- Name: cost cost_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.cost
    ADD CONSTRAINT cost_pkey PRIMARY KEY (id);


--
-- Name: custom_environment_usage custom_env_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.custom_environment_usage
    ADD CONSTRAINT custom_env_usage_pkey PRIMARY KEY (id);


--
-- Name: custom_environment custom_environment_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.custom_environment
    ADD CONSTRAINT custom_environment_pkey PRIMARY KEY (id);


--
-- Name: data_type data_type_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.data_type
    ADD CONSTRAINT data_type_pkey PRIMARY KEY (id);


--
-- Name: data_type_usage data_type_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.data_type_usage
    ADD CONSTRAINT data_type_usage_pkey PRIMARY KEY (entity_kind, entity_id, data_type_id, usage_kind);


--
-- Name: database_information database_information_2_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.database_information
    ADD CONSTRAINT database_information_2_pkey PRIMARY KEY (id);


--
-- Name: database_usage database_usage_id_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.database_usage
    ADD CONSTRAINT database_usage_id_pkey PRIMARY KEY (id);


--
-- Name: end_user_application end_user_application_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.end_user_application
    ADD CONSTRAINT end_user_application_pkey PRIMARY KEY (id);


--
-- Name: entity_alias entity_alias_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_alias
    ADD CONSTRAINT entity_alias_pkey PRIMARY KEY (id, kind, alias);


--
-- Name: entity_enum_definition entity_enum_defn_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_enum_definition
    ADD CONSTRAINT entity_enum_defn_pkey PRIMARY KEY (id);


--
-- Name: entity_field_reference entity_field_reference_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_field_reference
    ADD CONSTRAINT entity_field_reference_pkey PRIMARY KEY (id);


--
-- Name: entity_named_note entity_named_note_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_named_note
    ADD CONSTRAINT entity_named_note_pkey PRIMARY KEY (entity_id, entity_kind, named_note_type_id);


--
-- Name: entity_named_note_type entity_named_note_type_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_named_note_type
    ADD CONSTRAINT entity_named_note_type_pkey PRIMARY KEY (id);


--
-- Name: entity_relationship entity_relationship_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_relationship
    ADD CONSTRAINT entity_relationship_pkey PRIMARY KEY (id);


--
-- Name: entity_statistic_definition entity_statistic_defn_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_statistic_definition
    ADD CONSTRAINT entity_statistic_defn_pkey PRIMARY KEY (id);


--
-- Name: entity_statistic_value entity_statistic_value_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_statistic_value
    ADD CONSTRAINT entity_statistic_value_pkey PRIMARY KEY (id);


--
-- Name: entity_svg_diagram entity_svg_diagram_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_svg_diagram
    ADD CONSTRAINT entity_svg_diagram_pkey PRIMARY KEY (id);


--
-- Name: entity_tag entity_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_tag
    ADD CONSTRAINT entity_tag_pkey PRIMARY KEY (entity_id, entity_kind, tag);


--
-- Name: entity_workflow_definition entity_workflow_defn_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_workflow_definition
    ADD CONSTRAINT entity_workflow_defn_pkey PRIMARY KEY (id);


--
-- Name: enum_value enum_value_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.enum_value
    ADD CONSTRAINT enum_value_pkey PRIMARY KEY (type, key);


--
-- Name: external_identifier external_identifier_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.external_identifier
    ADD CONSTRAINT external_identifier_pkey PRIMARY KEY (entity_id, entity_kind, system, external_id);


--
-- Name: flow_classification flow_classification_id_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_classification
    ADD CONSTRAINT flow_classification_id_pkey PRIMARY KEY (id);


--
-- Name: flow_classification_rule flow_classification_rule_id_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_classification_rule
    ADD CONSTRAINT flow_classification_rule_id_pkey PRIMARY KEY (id);


--
-- Name: flow_diagram_annotation flow_diagram_annotation_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_diagram_annotation
    ADD CONSTRAINT flow_diagram_annotation_pkey PRIMARY KEY (diagram_id, annotation_id);


--
-- Name: flow_diagram_entity flow_diagram_entity_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_diagram_entity
    ADD CONSTRAINT flow_diagram_entity_pkey PRIMARY KEY (diagram_id, entity_id, entity_kind);


--
-- Name: flow_diagram flow_diagram_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_diagram
    ADD CONSTRAINT flow_diagram_pkey PRIMARY KEY (id);


--
-- Name: involvement_group idx_involvement_group_external_id; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.involvement_group
    ADD CONSTRAINT idx_involvement_group_external_id UNIQUE (external_id);


--
-- Name: permission_group idx_permission_group_external_id; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.permission_group
    ADD CONSTRAINT idx_permission_group_external_id UNIQUE (external_id);


--
-- Name: report_grid idx_report_grid_external_id; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.report_grid
    ADD CONSTRAINT idx_report_grid_external_id UNIQUE (external_id);


--
-- Name: vulnerability idx_vulnerability_external_id; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.vulnerability
    ADD CONSTRAINT idx_vulnerability_external_id UNIQUE (external_id);


--
-- Name: involvement_group involvement_group_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.involvement_group
    ADD CONSTRAINT involvement_group_pkey PRIMARY KEY (id);


--
-- Name: actor involvement_kind_name_key; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT involvement_kind_name_key UNIQUE (name);


--
-- Name: involvement_kind involvement_kind_name_key1; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.involvement_kind
    ADD CONSTRAINT involvement_kind_name_key1 UNIQUE (name);


--
-- Name: involvement_kind involvement_kind_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.involvement_kind
    ADD CONSTRAINT involvement_kind_pkey PRIMARY KEY (id);


--
-- Name: licence licence_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.licence
    ADD CONSTRAINT licence_pkey PRIMARY KEY (id);


--
-- Name: logical_data_element logical_data_element_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.logical_data_element
    ADD CONSTRAINT logical_data_element_pkey PRIMARY KEY (id);


--
-- Name: logical_flow_decorator logical_flow_decorator_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.logical_flow_decorator
    ADD CONSTRAINT logical_flow_decorator_pkey PRIMARY KEY (id);


--
-- Name: logical_flow logical_flow_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.logical_flow
    ADD CONSTRAINT logical_flow_pkey PRIMARY KEY (id);


--
-- Name: measurable_category measurable_category_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable_category
    ADD CONSTRAINT measurable_category_pkey PRIMARY KEY (id);


--
-- Name: measurable measurable_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable
    ADD CONSTRAINT measurable_pkey PRIMARY KEY (id);


--
-- Name: measurable_rating measurable_rating_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable_rating
    ADD CONSTRAINT measurable_rating_pkey PRIMARY KEY (entity_id, entity_kind, measurable_id);


--
-- Name: measurable_rating_planned_decommission measurable_rating_planned_decommission_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable_rating_planned_decommission
    ADD CONSTRAINT measurable_rating_planned_decommission_pkey PRIMARY KEY (id);


--
-- Name: measurable_rating_replacement measurable_rating_replacement_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable_rating_replacement
    ADD CONSTRAINT measurable_rating_replacement_pkey PRIMARY KEY (id);


--
-- Name: organisational_unit organisational_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.organisational_unit
    ADD CONSTRAINT organisational_unit_pkey PRIMARY KEY (id);


--
-- Name: flow_diagram_overlay_group_entry overlay_group_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_diagram_overlay_group_entry
    ADD CONSTRAINT overlay_group_entry_pkey PRIMARY KEY (id);


--
-- Name: flow_diagram_overlay_group overlay_group_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_diagram_overlay_group
    ADD CONSTRAINT overlay_group_pkey PRIMARY KEY (id);


--
-- Name: permission_group permission_group_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.permission_group
    ADD CONSTRAINT permission_group_pkey PRIMARY KEY (id);


--
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: physical_spec_defn_sample_file phy_spec_defn_sample_file_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_spec_defn_sample_file
    ADD CONSTRAINT phy_spec_defn_sample_file_pkey PRIMARY KEY (id);


--
-- Name: physical_spec_defn phy_spec_defn_unique_version; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_spec_defn
    ADD CONSTRAINT phy_spec_defn_unique_version UNIQUE (specification_id, version);


--
-- Name: physical_specification physical_data_article_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_specification
    ADD CONSTRAINT physical_data_article_pkey PRIMARY KEY (id);


--
-- Name: physical_flow physical_data_flow_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_flow
    ADD CONSTRAINT physical_data_flow_pkey PRIMARY KEY (id);


--
-- Name: physical_flow_participant physical_flow_participant_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_flow_participant
    ADD CONSTRAINT physical_flow_participant_pkey PRIMARY KEY (physical_flow_id, participant_entity_id, participant_entity_kind, kind);


--
-- Name: physical_spec_data_type physical_spec_data_type_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_spec_data_type
    ADD CONSTRAINT physical_spec_data_type_pkey PRIMARY KEY (specification_id, data_type_id);


--
-- Name: physical_spec_defn_field physical_spec_defn_field_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_spec_defn_field
    ADD CONSTRAINT physical_spec_defn_field_pkey PRIMARY KEY (id);


--
-- Name: physical_spec_defn physical_spec_defn_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.physical_spec_defn
    ADD CONSTRAINT physical_spec_defn_pkey PRIMARY KEY (id);


--
-- Name: databasechangeloglock pk_databasechangeloglock; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);


--
-- Name: process_diagram_entity process_diagram_entity_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.process_diagram_entity
    ADD CONSTRAINT process_diagram_entity_pkey PRIMARY KEY (diagram_id, entity_id, entity_kind);


--
-- Name: process_diagram process_diagram_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.process_diagram
    ADD CONSTRAINT process_diagram_pkey PRIMARY KEY (id);


--
-- Name: rating_scheme_item rating_definition_item_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.rating_scheme_item
    ADD CONSTRAINT rating_definition_item_pkey PRIMARY KEY (id);


--
-- Name: rating_scheme rating_scheme_definition_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.rating_scheme
    ADD CONSTRAINT rating_scheme_definition_pkey PRIMARY KEY (id);


--
-- Name: relationship_kind relationship_kind_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.relationship_kind
    ADD CONSTRAINT relationship_kind_pkey PRIMARY KEY (id);


--
-- Name: report_grid_column_definition report_grid_column_defn_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.report_grid_column_definition
    ADD CONSTRAINT report_grid_column_defn_pkey PRIMARY KEY (id);


--
-- Name: report_grid_derived_column_definition report_grid_derived_column_defn_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.report_grid_derived_column_definition
    ADD CONSTRAINT report_grid_derived_column_defn_pkey PRIMARY KEY (id);


--
-- Name: report_grid_fixed_column_definition report_grid_fixed_column_defn_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.report_grid_fixed_column_definition
    ADD CONSTRAINT report_grid_fixed_column_defn_pkey PRIMARY KEY (id);


--
-- Name: report_grid_member report_grid_member_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.report_grid_member
    ADD CONSTRAINT report_grid_member_pkey PRIMARY KEY (grid_id, user_id);


--
-- Name: report_grid report_grid_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.report_grid
    ADD CONSTRAINT report_grid_pkey PRIMARY KEY (id);


--
-- Name: person_hierarchy reportee_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.person_hierarchy
    ADD CONSTRAINT reportee_pkey PRIMARY KEY (manager_id, employee_id);


--
-- Name: roadmap roadmap_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.roadmap
    ADD CONSTRAINT roadmap_pkey PRIMARY KEY (id);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (key);


--
-- Name: scenario_axis_item scenario_axis_item_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.scenario_axis_item
    ADD CONSTRAINT scenario_axis_item_pkey PRIMARY KEY (id);


--
-- Name: scenario scenario_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.scenario
    ADD CONSTRAINT scenario_pkey PRIMARY KEY (id);


--
-- Name: scenario_rating_item scenario_rating_item_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.scenario_rating_item
    ADD CONSTRAINT scenario_rating_item_pkey PRIMARY KEY (id);


--
-- Name: server_information server_information_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.server_information
    ADD CONSTRAINT server_information_pkey PRIMARY KEY (id);


--
-- Name: server_usage server_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.server_usage
    ADD CONSTRAINT server_usage_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (name);


--
-- Name: shared_preference shared_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.shared_preference
    ADD CONSTRAINT shared_preference_pkey PRIMARY KEY (key, category);


--
-- Name: software_package software_package_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.software_package
    ADD CONSTRAINT software_package_pkey PRIMARY KEY (id);


--
-- Name: software_usage software_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.software_usage
    ADD CONSTRAINT software_usage_pkey PRIMARY KEY (id);


--
-- Name: software_version_licence software_version_licence_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.software_version_licence
    ADD CONSTRAINT software_version_licence_pkey PRIMARY KEY (id);


--
-- Name: software_version software_version_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.software_version
    ADD CONSTRAINT software_version_pkey PRIMARY KEY (id);


--
-- Name: source_data_rating source_data_rating_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.source_data_rating
    ADD CONSTRAINT source_data_rating_pkey PRIMARY KEY (source_name, entity_kind);


--
-- Name: survey_question_dropdown_entry sq_dropdown_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_question_dropdown_entry
    ADD CONSTRAINT sq_dropdown_entry_pkey PRIMARY KEY (id);


--
-- Name: static_panel static_panel_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.static_panel
    ADD CONSTRAINT static_panel_pkey PRIMARY KEY (id);


--
-- Name: survey_instance_owner survey_instance_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_instance_owner
    ADD CONSTRAINT survey_instance_owner_pkey PRIMARY KEY (id);


--
-- Name: survey_instance survey_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_instance
    ADD CONSTRAINT survey_instance_pkey PRIMARY KEY (id);


--
-- Name: survey_instance_recipient survey_instance_recipient_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_instance_recipient
    ADD CONSTRAINT survey_instance_recipient_pkey PRIMARY KEY (id);


--
-- Name: survey_question survey_question_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_question
    ADD CONSTRAINT survey_question_pkey PRIMARY KEY (id);


--
-- Name: survey_question_response survey_question_response_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_question_response
    ADD CONSTRAINT survey_question_response_pkey PRIMARY KEY (survey_instance_id, question_id);


--
-- Name: survey_run survey_run_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_run
    ADD CONSTRAINT survey_run_pkey PRIMARY KEY (id);


--
-- Name: survey_template survey_template_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_template
    ADD CONSTRAINT survey_template_pkey PRIMARY KEY (id);


--
-- Name: survey_template survey_template_unique_name; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_template
    ADD CONSTRAINT survey_template_unique_name UNIQUE (name);


--
-- Name: svg_diagram svg_diagram_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.svg_diagram
    ADD CONSTRAINT svg_diagram_pkey PRIMARY KEY (id);


--
-- Name: system_job_log system_job_log_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.system_job_log
    ADD CONSTRAINT system_job_log_pkey PRIMARY KEY (name, entity_kind, start);


--
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);


--
-- Name: tag_usage tag_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.tag_usage
    ADD CONSTRAINT tag_usage_pkey PRIMARY KEY (tag_id, entity_id, entity_kind);


--
-- Name: taxonomy_change taxonomy_change_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.taxonomy_change
    ADD CONSTRAINT taxonomy_change_pkey PRIMARY KEY (id);


--
-- Name: thumbnail thumbnail_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.thumbnail
    ADD CONSTRAINT thumbnail_pkey PRIMARY KEY (parent_entity_id, parent_entity_kind);


--
-- Name: actor unique_actor_ext_id; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT unique_actor_ext_id UNIQUE (external_id);


--
-- Name: person unique_employee_id; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT unique_employee_id UNIQUE (employee_id);


--
-- Name: key_involvement_kind unique_inv_kind_entity_kind; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.key_involvement_kind
    ADD CONSTRAINT unique_inv_kind_entity_kind UNIQUE (involvement_kind_id, entity_kind);


--
-- Name: logical_flow unique_logical_flow; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.logical_flow
    ADD CONSTRAINT unique_logical_flow UNIQUE (source_entity_kind, source_entity_id, target_entity_kind, target_entity_id);


--
-- Name: relationship_kind unique_rel_kind; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.relationship_kind
    ADD CONSTRAINT unique_rel_kind UNIQUE (kind_a, kind_b, code);


--
-- Name: survey_instance_owner unique_survey_instance_owner_id; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_instance_owner
    ADD CONSTRAINT unique_survey_instance_owner_id UNIQUE (survey_instance_id, person_id);


--
-- Name: user_agent_info user_agent_info_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.user_agent_info
    ADD CONSTRAINT user_agent_info_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_name);


--
-- Name: user_preference user_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.user_preference
    ADD CONSTRAINT user_preference_pkey PRIMARY KEY (user_name, key);


--
-- Name: vulnerability vulnerability_pkey; Type: CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.vulnerability
    ADD CONSTRAINT vulnerability_pkey PRIMARY KEY (id);


--
-- Name: idx_agg_overlay_diagram_cell_data; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_agg_overlay_diagram_cell_data ON public.aggregate_overlay_diagram_cell_data USING btree (diagram_id, cell_external_id, related_entity_kind, related_entity_id);


--
-- Name: idx_air_user_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_air_user_id ON public.attestation_instance_recipient USING btree (user_id);


--
-- Name: idx_alloc_scheme_name_cat; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_alloc_scheme_name_cat ON public.allocation_scheme USING btree (name, measurable_category_id);


--
-- Name: idx_article_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_article_id ON public.physical_flow USING btree (specification_id);


--
-- Name: idx_assessment_rating_entity; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_assessment_rating_entity ON public.assessment_rating USING btree (entity_id, entity_kind);


--
-- Name: idx_asset_code; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_asset_code ON public.application USING btree (asset_code);


--
-- Name: idx_attestation_instance_parent_entity_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_attestation_instance_parent_entity_id ON public.attestation_instance USING btree (parent_entity_id);


--
-- Name: idx_attribute_change_change_unit; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_attribute_change_change_unit ON public.attribute_change USING btree (change_unit_id);


--
-- Name: idx_bookmark_parent; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_bookmark_parent ON public.bookmark USING btree (parent_id, parent_kind);


--
-- Name: idx_category_ext_id_not_null; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_category_ext_id_not_null ON public.measurable USING btree (measurable_category_id, external_id);


--
-- Name: idx_change_log_user_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_change_log_user_id ON public.change_log USING btree (user_id);


--
-- Name: idx_change_set_parent_ref; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_change_set_parent_ref ON public.change_set USING btree (parent_entity_id, parent_entity_kind);


--
-- Name: idx_change_unit_change_set; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_change_unit_change_set ON public.change_unit USING btree (change_set_id);


--
-- Name: idx_change_unit_subject_ref; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_change_unit_subject_ref ON public.change_unit USING btree (subject_entity_id, subject_entity_kind);


--
-- Name: idx_code; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_code ON public.data_type USING btree (code);


--
-- Name: idx_cost_cost_kind; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_cost_cost_kind ON public.cost USING btree (cost_kind_id);


--
-- Name: idx_els_application; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_els_application ON public.application USING btree (entity_lifecycle_status);


--
-- Name: idx_entity_hier_kind_ancestor; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_entity_hier_kind_ancestor ON public.entity_hierarchy USING btree (kind, ancestor_id);


--
-- Name: idx_entity_named_note_type_ext_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_entity_named_note_type_ext_id ON public.entity_named_note_type USING btree (external_id);


--
-- Name: idx_entity_relationship_a; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_entity_relationship_a ON public.entity_relationship USING btree (kind_a, id_a);


--
-- Name: idx_entity_relationship_b; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_entity_relationship_b ON public.entity_relationship USING btree (kind_b, id_b);


--
-- Name: idx_env_id_entity; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_env_id_entity ON public.custom_environment_usage USING btree (custom_environment_id, entity_kind, entity_id);


--
-- Name: idx_er_ida_ka_idb_kb_rel; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_er_ida_ka_idb_kb_rel ON public.entity_relationship USING btree (kind_a, id_a, kind_b, id_b, relationship);


--
-- Name: idx_esv_entity_ref_current; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_esv_entity_ref_current ON public.entity_statistic_value USING btree (entity_id, current, entity_kind);


--
-- Name: idx_esv_statistic_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_esv_statistic_id ON public.entity_statistic_value USING btree (statistic_id);


--
-- Name: idx_esv_statistic_id_outcome; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_esv_statistic_id_outcome ON public.entity_statistic_value USING btree (statistic_id, outcome);


--
-- Name: idx_external_identifier_ent_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_external_identifier_ent_id ON public.external_identifier USING btree (entity_kind, entity_id);


--
-- Name: idx_external_identifier_ext_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_external_identifier_ext_id ON public.external_identifier USING btree (system, external_id);


--
-- Name: idx_fcr_scope_dt_app; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_fcr_scope_dt_app ON public.flow_classification_rule USING btree (parent_kind, parent_id, application_id, data_type_id);


--
-- Name: idx_fda_diagram_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_fda_diagram_id ON public.flow_diagram_annotation USING btree (diagram_id);


--
-- Name: idx_inv_kind_ext_id_uniq; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_inv_kind_ext_id_uniq ON public.involvement_kind USING btree (external_id);


--
-- Name: idx_involvement_entity_emp; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_involvement_entity_emp ON public.involvement USING btree (entity_kind, entity_id, employee_id);


--
-- Name: idx_lfd_lfid_deckind; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_lfd_lfid_deckind ON public.logical_flow_decorator USING btree (logical_flow_id, decorator_entity_kind);


--
-- Name: idx_lfd_lfid_deckind_decid; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_lfd_lfid_deckind_decid ON public.logical_flow_decorator USING btree (logical_flow_id, decorator_entity_kind, decorator_entity_id);


--
-- Name: idx_licence_external_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_licence_external_id ON public.licence USING btree (external_id);


--
-- Name: idx_m_rating_entity; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_m_rating_entity ON public.measurable_rating USING btree (entity_id, entity_kind);


--
-- Name: idx_m_rating_measurable; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_m_rating_measurable ON public.measurable_rating USING btree (measurable_id);


--
-- Name: idx_measurable_category; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_measurable_category ON public.measurable USING btree (measurable_category_id);


--
-- Name: idx_organisational_unit_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_organisational_unit_id ON public.application USING btree (organisational_unit_id);


--
-- Name: idx_owning_entity; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_owning_entity ON public.physical_specification USING btree (owning_entity_id, owning_entity_kind);


--
-- Name: idx_owning_entity_name; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_owning_entity_name ON public.custom_environment USING btree (name, owning_entity_kind, owning_entity_id);


--
-- Name: idx_person_email; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_person_email ON public.person USING btree (email);


--
-- Name: idx_pf_ext_id_provenance; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_pf_ext_id_provenance ON public.physical_flow USING btree (external_id, provenance);


--
-- Name: idx_psd_specification_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_psd_specification_id ON public.physical_spec_defn USING btree (specification_id);


--
-- Name: idx_psdf_spec_defn_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_psdf_spec_defn_id ON public.physical_spec_defn_field USING btree (spec_defn_id);


--
-- Name: idx_psdsf_spec_defn_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_psdsf_spec_defn_id ON public.physical_spec_defn_sample_file USING btree (spec_defn_id);


--
-- Name: idx_rating_scheme_item_unique; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_rating_scheme_item_unique ON public.rating_scheme_item USING btree (scheme_id, code);


--
-- Name: idx_scenario_axis_scenario_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_scenario_axis_scenario_id ON public.scenario_axis_item USING btree (scenario_id);


--
-- Name: idx_scenario_axis_uniq; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_scenario_axis_uniq ON public.scenario_axis_item USING btree (scenario_id, orientation, domain_item_kind, domain_item_id);


--
-- Name: idx_scenario_rating_domain; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_scenario_rating_domain ON public.scenario_rating_item USING btree (domain_item_kind, domain_item_id);


--
-- Name: idx_scenario_rating_scenario_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_scenario_rating_scenario_id ON public.scenario_rating_item USING btree (scenario_id);


--
-- Name: idx_scenario_roadmap_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_scenario_roadmap_id ON public.scenario USING btree (roadmap_id);


--
-- Name: idx_si_external_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_si_external_id ON public.server_information USING btree (external_id);


--
-- Name: idx_si_hostname; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_si_hostname ON public.server_information USING btree (hostname);


--
-- Name: idx_sir_person; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_sir_person ON public.survey_instance_recipient USING btree (person_id);


--
-- Name: idx_software_package_ext_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_software_package_ext_id ON public.software_package USING btree (external_id);


--
-- Name: idx_software_version_ext_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_software_version_ext_id ON public.software_version USING btree (external_id);


--
-- Name: idx_sp_name_vendor; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_sp_name_vendor ON public.software_package USING btree (name, "group", vendor);


--
-- Name: idx_static_panel_group; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_static_panel_group ON public.static_panel USING btree ("group");


--
-- Name: idx_su_app_version; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_su_app_version ON public.software_usage USING btree (application_id, software_version_id);


--
-- Name: idx_su_s_id_id_kind_env; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_su_s_id_id_kind_env ON public.server_usage USING btree (server_id, entity_id, entity_kind, environment);


--
-- Name: idx_su_version_spid; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_su_version_spid ON public.software_version USING btree (version, software_package_id);


--
-- Name: idx_survey_instance_entity; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_survey_instance_entity ON public.survey_instance USING btree (entity_id, entity_kind);


--
-- Name: idx_survey_instance_run; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_survey_instance_run ON public.survey_instance USING btree (survey_run_id);


--
-- Name: idx_survey_q_tmpl_id_ext_id; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_survey_q_tmpl_id_ext_id ON public.survey_question USING btree (survey_template_id, external_id);


--
-- Name: idx_survey_question_template; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_survey_question_template ON public.survey_question USING btree (survey_template_id);


--
-- Name: idx_survey_recipient_instance; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_survey_recipient_instance ON public.survey_instance_recipient USING btree (survey_instance_id);


--
-- Name: idx_survey_run_template; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_survey_run_template ON public.survey_run USING btree (survey_template_id);


--
-- Name: idx_svg_diagram_group; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_svg_diagram_group ON public.svg_diagram USING btree ("group");


--
-- Name: idx_svl_version_licence; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_svl_version_licence ON public.software_version_licence USING btree (software_version_id, licence_id);


--
-- Name: idx_svv_version_vulnerability; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_svv_version_vulnerability ON public.software_version_vulnerability USING btree (software_version_id, vulnerability_id);


--
-- Name: idx_tag_target_kind; Type: INDEX; Schema: public; Owner: waltz
--

CREATE UNIQUE INDEX idx_tag_target_kind ON public.tag USING btree (name, target_kind);


--
-- Name: idx_taxonomy_change_domain; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_taxonomy_change_domain ON public.taxonomy_change USING btree (domain_kind, domain_id);


--
-- Name: idx_taxonomy_change_pref; Type: INDEX; Schema: public; Owner: waltz
--

CREATE INDEX idx_taxonomy_change_pref ON public.taxonomy_change USING btree (primary_reference_kind, primary_reference_id);


--
-- Name: aggregate_overlay_diagram_callout agg_overlay_diag_callout_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.aggregate_overlay_diagram_callout
    ADD CONSTRAINT agg_overlay_diag_callout_fk FOREIGN KEY (diagram_instance_id) REFERENCES public.aggregate_overlay_diagram_instance(id) ON DELETE CASCADE;


--
-- Name: aggregate_overlay_diagram_cell_data agg_overlay_diag_cell_data_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.aggregate_overlay_diagram_cell_data
    ADD CONSTRAINT agg_overlay_diag_cell_data_fk FOREIGN KEY (diagram_id) REFERENCES public.aggregate_overlay_diagram(id) ON DELETE CASCADE;


--
-- Name: aggregate_overlay_diagram_instance agg_overlay_diag_instance_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.aggregate_overlay_diagram_instance
    ADD CONSTRAINT agg_overlay_diag_instance_fk FOREIGN KEY (diagram_id) REFERENCES public.aggregate_overlay_diagram(id) ON DELETE CASCADE;


--
-- Name: aggregate_overlay_diagram_preset agg_overlay_diag_preset_diag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.aggregate_overlay_diagram_preset
    ADD CONSTRAINT agg_overlay_diag_preset_diag_id_fkey FOREIGN KEY (diagram_id) REFERENCES public.aggregate_overlay_diagram(id) ON DELETE CASCADE;


--
-- Name: allocation_scheme alloc_scheme_measurable_cat_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.allocation_scheme
    ADD CONSTRAINT alloc_scheme_measurable_cat_fk FOREIGN KEY (measurable_category_id) REFERENCES public.measurable_category(id);


--
-- Name: allocation allocation_allocation_scheme_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.allocation
    ADD CONSTRAINT allocation_allocation_scheme_fk FOREIGN KEY (allocation_scheme_id) REFERENCES public.allocation_scheme(id) ON DELETE CASCADE;


--
-- Name: allocation allocation_measurable_rating_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.allocation
    ADD CONSTRAINT allocation_measurable_rating_fk FOREIGN KEY (entity_id, entity_kind, measurable_id) REFERENCES public.measurable_rating(entity_id, entity_kind, measurable_id) ON DELETE CASCADE;


--
-- Name: application_group_ou_entry app_grp_ou_entry_grp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.application_group_ou_entry
    ADD CONSTRAINT app_grp_ou_entry_grp_id_fkey FOREIGN KEY (group_id) REFERENCES public.application_group(id) ON DELETE CASCADE;


--
-- Name: application_group_entry application_group_entry_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.application_group_entry
    ADD CONSTRAINT application_group_entry_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.application_group(id) ON DELETE CASCADE;


--
-- Name: application_group_member application_group_member_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.application_group_member
    ADD CONSTRAINT application_group_member_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.application_group(id) ON DELETE CASCADE;


--
-- Name: assessment_definition assessment_defn_rating_schm_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.assessment_definition
    ADD CONSTRAINT assessment_defn_rating_schm_fk FOREIGN KEY (rating_scheme_id) REFERENCES public.rating_scheme(id);


--
-- Name: assessment_rating assessment_rating_rating_scheme_item_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.assessment_rating
    ADD CONSTRAINT assessment_rating_rating_scheme_item_fk FOREIGN KEY (rating_id) REFERENCES public.rating_scheme_item(id);


--
-- Name: assessment_rating assessment_rating_to_definition_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.assessment_rating
    ADD CONSTRAINT assessment_rating_to_definition_fk FOREIGN KEY (assessment_definition_id) REFERENCES public.assessment_definition(id) ON DELETE CASCADE;


--
-- Name: attestation_instance attestation_instance_run_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.attestation_instance
    ADD CONSTRAINT attestation_instance_run_fk FOREIGN KEY (attestation_run_id) REFERENCES public.attestation_run(id);


--
-- Name: complexity complexity_to_complexity_kind_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.complexity
    ADD CONSTRAINT complexity_to_complexity_kind_id_fk FOREIGN KEY (complexity_kind_id) REFERENCES public.complexity_kind(id) ON DELETE CASCADE;


--
-- Name: cost cost_to_cost_kind_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.cost
    ADD CONSTRAINT cost_to_cost_kind_id_fk FOREIGN KEY (cost_kind_id) REFERENCES public.cost_kind(id) ON DELETE CASCADE;


--
-- Name: custom_environment_usage custom_env_usage_to_custom_env_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.custom_environment_usage
    ADD CONSTRAINT custom_env_usage_to_custom_env_fk FOREIGN KEY (custom_environment_id) REFERENCES public.custom_environment(id) ON DELETE CASCADE;


--
-- Name: database_usage database_usage_database_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.database_usage
    ADD CONSTRAINT database_usage_database_id_fk FOREIGN KEY (database_id) REFERENCES public.database_information(id) ON DELETE CASCADE;


--
-- Name: report_grid_derived_column_definition derived_column_grid_column_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.report_grid_derived_column_definition
    ADD CONSTRAINT derived_column_grid_column_id_fk FOREIGN KEY (grid_column_id) REFERENCES public.report_grid_column_definition(id) ON DELETE CASCADE;


--
-- Name: entity_relationship entity_rel_to_rel_kind_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.entity_relationship
    ADD CONSTRAINT entity_rel_to_rel_kind_fkey FOREIGN KEY (kind_a, kind_b, relationship) REFERENCES public.relationship_kind(kind_a, kind_b, code) ON DELETE CASCADE;


--
-- Name: enum_value_alias enum_value_alias_type_key_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.enum_value_alias
    ADD CONSTRAINT enum_value_alias_type_key_fkey FOREIGN KEY (enum_type, enum_key) REFERENCES public.enum_value(type, key) ON DELETE CASCADE;


--
-- Name: flow_diagram_overlay_group_entry fd_overlay_group_entry_fd_overlay_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_diagram_overlay_group_entry
    ADD CONSTRAINT fd_overlay_group_entry_fd_overlay_group_id_fk FOREIGN KEY (overlay_group_id) REFERENCES public.flow_diagram_overlay_group(id) ON DELETE CASCADE;


--
-- Name: flow_diagram_overlay_group fd_overlay_group_flow_diagram_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_diagram_overlay_group
    ADD CONSTRAINT fd_overlay_group_flow_diagram_id_fk FOREIGN KEY (flow_diagram_id) REFERENCES public.flow_diagram(id) ON DELETE CASCADE;


--
-- Name: report_grid_fixed_column_definition fixed_column_grid_column_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.report_grid_fixed_column_definition
    ADD CONSTRAINT fixed_column_grid_column_id_fk FOREIGN KEY (grid_column_id) REFERENCES public.report_grid_column_definition(id) ON DELETE CASCADE;


--
-- Name: flow_classification_rule flow_classification_rule_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_classification_rule
    ADD CONSTRAINT flow_classification_rule_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.application(id) ON DELETE CASCADE;


--
-- Name: flow_classification_rule flow_classification_rule_classification_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_classification_rule
    ADD CONSTRAINT flow_classification_rule_classification_id_fkey FOREIGN KEY (flow_classification_id) REFERENCES public.flow_classification(id) ON DELETE CASCADE;


--
-- Name: flow_classification_rule flow_classification_rule_data_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.flow_classification_rule
    ADD CONSTRAINT flow_classification_rule_data_type_id_fkey FOREIGN KEY (data_type_id) REFERENCES public.data_type(id) ON DELETE CASCADE;


--
-- Name: involvement inv_kind_to_inv_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.involvement
    ADD CONSTRAINT inv_kind_to_inv_fk FOREIGN KEY (kind_id) REFERENCES public.involvement_kind(id);


--
-- Name: involvement inv_to_person_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.involvement
    ADD CONSTRAINT inv_to_person_fk FOREIGN KEY (employee_id) REFERENCES public.person(employee_id);


--
-- Name: involvement_group_entry involvement_group_entry_group_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.involvement_group_entry
    ADD CONSTRAINT involvement_group_entry_group_fk FOREIGN KEY (involvement_group_id) REFERENCES public.involvement_group(id);


--
-- Name: involvement_group_entry involvement_group_entry_inv_kind_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.involvement_group_entry
    ADD CONSTRAINT involvement_group_entry_inv_kind_fk FOREIGN KEY (involvement_kind_id) REFERENCES public.involvement_kind(id);


--
-- Name: key_involvement_kind key_inv_kind_to_inv_kind_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.key_involvement_kind
    ADD CONSTRAINT key_inv_kind_to_inv_kind_fk FOREIGN KEY (involvement_kind_id) REFERENCES public.involvement_kind(id);


--
-- Name: logical_flow_decorator lfd_flow_classification_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.logical_flow_decorator
    ADD CONSTRAINT lfd_flow_classification_rule_id_fkey FOREIGN KEY (flow_classification_rule_id) REFERENCES public.flow_classification_rule(id) ON DELETE SET NULL;


--
-- Name: measurable_category measurable_category_assessment_def_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable_category
    ADD CONSTRAINT measurable_category_assessment_def_fk FOREIGN KEY (constraining_assessment_definition_id) REFERENCES public.assessment_definition(id);


--
-- Name: measurable_category measurable_category_rating_scheme_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable_category
    ADD CONSTRAINT measurable_category_rating_scheme_fk FOREIGN KEY (rating_scheme_id) REFERENCES public.rating_scheme(id);


--
-- Name: measurable measurable_measurable_ctgry_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable
    ADD CONSTRAINT measurable_measurable_ctgry_fk FOREIGN KEY (measurable_category_id) REFERENCES public.measurable_category(id);


--
-- Name: measurable measurable_measurable_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable
    ADD CONSTRAINT measurable_measurable_parent_fk FOREIGN KEY (parent_id) REFERENCES public.measurable(id);


--
-- Name: measurable_rating_planned_decommission measurable_rating_planned_decommission_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable_rating_planned_decommission
    ADD CONSTRAINT measurable_rating_planned_decommission_fk FOREIGN KEY (entity_id, entity_kind, measurable_id) REFERENCES public.measurable_rating(entity_id, entity_kind, measurable_id) ON DELETE CASCADE;


--
-- Name: measurable_rating_replacement measurable_rating_replacement_application_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable_rating_replacement
    ADD CONSTRAINT measurable_rating_replacement_application_fk FOREIGN KEY (entity_id) REFERENCES public.application(id) ON DELETE CASCADE;


--
-- Name: measurable_rating_replacement measurable_rating_replacement_planned_decommission_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.measurable_rating_replacement
    ADD CONSTRAINT measurable_rating_replacement_planned_decommission_fk FOREIGN KEY (decommission_id) REFERENCES public.measurable_rating_planned_decommission(id) ON DELETE CASCADE;


--
-- Name: permission_group_entry permission_group_entry_application_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.permission_group_entry
    ADD CONSTRAINT permission_group_entry_application_id_fk FOREIGN KEY (entity_id) REFERENCES public.application(id);


--
-- Name: permission_group_entry permission_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.permission_group_entry
    ADD CONSTRAINT permission_group_id_fk FOREIGN KEY (permission_group_id) REFERENCES public.permission_group(id);


--
-- Name: permission_group_involvement permission_involvement_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.permission_group_involvement
    ADD CONSTRAINT permission_involvement_group_id_fk FOREIGN KEY (involvement_group_id) REFERENCES public.involvement_group(id);


--
-- Name: rating_scheme_item rating_scheme_item_rating_scheme_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.rating_scheme_item
    ADD CONSTRAINT rating_scheme_item_rating_scheme_fk FOREIGN KEY (scheme_id) REFERENCES public.rating_scheme(id);


--
-- Name: report_grid_member report_grid_to_grid_member_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.report_grid_member
    ADD CONSTRAINT report_grid_to_grid_member_fk FOREIGN KEY (grid_id) REFERENCES public.report_grid(id) ON DELETE CASCADE;


--
-- Name: report_grid_column_definition rgcd_report_grid_id_rg_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.report_grid_column_definition
    ADD CONSTRAINT rgcd_report_grid_id_rg_id_fk FOREIGN KEY (report_grid_id) REFERENCES public.report_grid(id) ON DELETE CASCADE;


--
-- Name: roadmap roadmap_rating_scheme_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.roadmap
    ADD CONSTRAINT roadmap_rating_scheme_fk FOREIGN KEY (rating_scheme_id) REFERENCES public.rating_scheme(id);


--
-- Name: server_usage server_usage_server_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.server_usage
    ADD CONSTRAINT server_usage_server_id_fk FOREIGN KEY (server_id) REFERENCES public.server_information(id) ON DELETE CASCADE;


--
-- Name: software_usage soft_usage_version_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.software_usage
    ADD CONSTRAINT soft_usage_version_fk FOREIGN KEY (software_version_id) REFERENCES public.software_version(id);


--
-- Name: software_version soft_version_package_spid_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.software_version
    ADD CONSTRAINT soft_version_package_spid_fk FOREIGN KEY (software_package_id) REFERENCES public.software_package(id);


--
-- Name: survey_instance_owner survey_instance_owner_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_instance_owner
    ADD CONSTRAINT survey_instance_owner_instance_id_fkey FOREIGN KEY (survey_instance_id) REFERENCES public.survey_instance(id) ON DELETE CASCADE;


--
-- Name: survey_instance_owner survey_instance_owner_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_instance_owner
    ADD CONSTRAINT survey_instance_owner_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: survey_question_list_response survey_q_list_resp_survey_q_resp_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_question_list_response
    ADD CONSTRAINT survey_q_list_resp_survey_q_resp_fk FOREIGN KEY (survey_instance_id, question_id) REFERENCES public.survey_question_response(survey_instance_id, question_id) ON DELETE CASCADE;


--
-- Name: survey_question_response survey_q_resp_survey_inst_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_question_response
    ADD CONSTRAINT survey_q_resp_survey_inst_fk FOREIGN KEY (survey_instance_id) REFERENCES public.survey_instance(id);


--
-- Name: survey_question_response survey_q_resp_survey_q_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_question_response
    ADD CONSTRAINT survey_q_resp_survey_q_fk FOREIGN KEY (question_id) REFERENCES public.survey_question(id);


--
-- Name: survey_question survey_question_template_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.survey_question
    ADD CONSTRAINT survey_question_template_fk FOREIGN KEY (survey_template_id) REFERENCES public.survey_template(id);


--
-- Name: software_version_licence svl_licence_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.software_version_licence
    ADD CONSTRAINT svl_licence_fk FOREIGN KEY (licence_id) REFERENCES public.licence(id);


--
-- Name: software_version_licence svl_version_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.software_version_licence
    ADD CONSTRAINT svl_version_fk FOREIGN KEY (software_version_id) REFERENCES public.software_version(id);


--
-- Name: tag_usage tag_usage_tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.tag_usage
    ADD CONSTRAINT tag_usage_tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tag(id) ON DELETE CASCADE;


--
-- Name: user_role user_role_role_key_fk; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_role_key_fk FOREIGN KEY (role) REFERENCES public.role(key) ON DELETE CASCADE;


--
-- Name: user_role user_role_user_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: waltz
--

ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_user_name_fkey FOREIGN KEY (user_name) REFERENCES public."user"(user_name) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

