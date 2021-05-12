--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2 (Debian 11.2-1.pgdg90+1)
-- Dumped by pg_dump version 12.6 (Ubuntu 12.6-0ubuntu0.20.04.1)




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
-- Name: app; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app (
    id bigint NOT NULL,
    apikey character varying(255),
    appid bigint,
    appsecretkey jsonb,
    createddate timestamp without time zone NOT NULL,
    description character varying(255),
    iskit boolean,
    ismpcreated boolean DEFAULT false,
    kongid character varying(255),
    mpidentifier character varying(255),
    mpusecasestatus integer,
    name character varying(255) NOT NULL,
    productsenabled jsonb,
    ratelimitid character varying(255),
    updateddate timestamp without time zone NOT NULL,
    userid bigint NOT NULL
);


ALTER TABLE public.app OWNER TO postgres;

--
-- Name: app_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_id_generator OWNER TO postgres;

--
-- Name: auth_client_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_client_config (
    id bigint NOT NULL,
    client character varying(255) NOT NULL,
    createdat timestamp without time zone NOT NULL,
    initurl character varying(255) NOT NULL,
    updatedat timestamp without time zone NOT NULL
);


ALTER TABLE public.auth_client_config OWNER TO postgres;

--
-- Name: auth_client_config_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_client_config_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_client_config_id_generator OWNER TO postgres;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id bigint NOT NULL,
    description character varying(5000),
    isinternal boolean,
    name character varying(255) NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: category_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_id_generator OWNER TO postgres;


--
-- Name: data_source; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_source (
    id bigint NOT NULL,
    name character varying(255),
    subdatasources jsonb
);


ALTER TABLE public.data_source OWNER TO postgres;

--
-- Name: data_source_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.data_source_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.data_source_id_generator OWNER TO postgres;



--
-- Name: file; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.file (
    id bigint NOT NULL,
    cloudfronturl character varying(255),
    cloudfronturlsigned character varying(1000),
    createdat timestamp without time zone,
    filename character varying(255),
    filesize bigint,
    filesystem integer,
    fileurl character varying(255),
    ispublic boolean,
    label character varying(255),
    metadata jsonb,
    s3key character varying(255),
    s3url character varying(255),
    type integer,
    updatedat timestamp without time zone,
    userid bigint,
    username character varying(255)
);


ALTER TABLE public.file OWNER TO postgres;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hibernate_sequence OWNER TO postgres;


--
-- Name: metabase_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metabase_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_id_generator OWNER TO postgres;

--
-- Name: metabase_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metabase_tokens (
    id bigint NOT NULL,
    createddate timestamp without time zone,
    sessionid character varying(255),
    user_id bigint NOT NULL
);


ALTER TABLE public.metabase_tokens OWNER TO postgres;

--
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    id bigint NOT NULL,
    createddate timestamp without time zone NOT NULL,
    isread boolean,
    message character varying(255),
    updateddate timestamp without time zone NOT NULL,
    userid bigint
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- Name: notification_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_id_generator OWNER TO postgres;

--
-- Name: oauth_client_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth_client_details (
    client_id character varying(256) NOT NULL,
    resource_ids character varying(256),
    client_secret character varying(256),
    scope character varying(256),
    authorized_grant_types character varying(256),
    web_server_redirect_uri character varying(256),
    authorities character varying(256),
    access_token_validity integer,
    refresh_token_validity integer,
    additional_information character varying(4096),
    autoapprove character varying(256)
);


ALTER TABLE public.oauth_client_details OWNER TO postgres;

--
-- Name: org_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.org_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.org_id_generator OWNER TO postgres;

--
-- Name: organization; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization (
    id bigint NOT NULL,
    createdat timestamp without time zone NOT NULL,
    department character varying(255),
    mobile character varying(255),
    name character varying(255),
    ownerid bigint NOT NULL,
    teamsize integer,
    updatedat timestamp without time zone NOT NULL,
    website character varying(255)
);


ALTER TABLE public.organization OWNER TO postgres;

--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_tokens (
    id bigint NOT NULL,
    expirydate timestamp without time zone,
    token character varying(255),
    user_id bigint NOT NULL
);


ALTER TABLE public.password_reset_tokens OWNER TO postgres;

--
-- Name: plan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plan (
    id bigint NOT NULL,
    apicallslimit jsonb,
    cloudstorage double precision,
    createdat timestamp without time zone,
    discounts jsonb,
    enabled boolean,
    features character varying(5000) NOT NULL,
    globalprice double precision,
    ispublic boolean,
    maxapicalls integer,
    maxapps integer,
    name character varying(255) NOT NULL,
    paymenttype integer,
    plancategory integer,
    plantype integer NOT NULL,
    price double precision,
    scu double precision,
    storagelimit jsonb,
    tagline character varying(255),
    updatedat timestamp without time zone,
    validityindays integer
);


ALTER TABLE public.plan OWNER TO postgres;

--
-- Name: plan_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.plan_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plan_id_generator OWNER TO postgres;

--
-- Name: plan_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plan_product (
    mplan_id bigint NOT NULL,
    products_id bigint NOT NULL
);


ALTER TABLE public.plan_product OWNER TO postgres;

--
-- Name: plan_service_plan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plan_service_plan (
    mplan_id bigint NOT NULL,
    services_id bigint NOT NULL
);


ALTER TABLE public.plan_service_plan OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id bigint NOT NULL,
    complexity double precision,
    contextpath character varying(255),
    description character varying(5000) NOT NULL,
    imageurl character varying(255),
    isfeatured boolean,
    isinternal boolean,
    ispublic boolean,
    name character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    tagline character varying(255) NOT NULL,
    thumbnailurl character varying(255),
    videourl character varying(255),
    category_id bigint
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: product_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_id_generator OWNER TO postgres;

--
-- Name: req_uri_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.req_uri_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.req_uri_generator OWNER TO postgres;

--
-- Name: request_uri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.request_uri (
    id bigint NOT NULL,
    createdat timestamp without time zone,
    enabled boolean NOT NULL,
    methods jsonb NOT NULL,
    name character varying(255),
    postchecks jsonb,
    prechecks jsonb,
    product character varying(255),
    productid bigint,
    requesturi character varying(255) NOT NULL,
    roles jsonb,
    service character varying(255),
    servicecontext character varying(255) NOT NULL,
    serviceid bigint,
    updatedat timestamp without time zone
);


ALTER TABLE public.request_uri OWNER TO postgres;

--
-- Name: role_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_id_generator OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(255)
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: service; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service (
    id bigint NOT NULL,
    contextpath character varying(255),
    createdat timestamp without time zone,
    enabled boolean,
    name character varying(255) NOT NULL,
    updatedat timestamp without time zone,
    product_id bigint
);


ALTER TABLE public.service OWNER TO postgres;

--
-- Name: service_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_id_generator OWNER TO postgres;

--
-- Name: service_plan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_plan (
    id bigint NOT NULL,
    apicallslimit jsonb,
    createdat timestamp without time zone,
    enabled boolean,
    maxapicalls integer,
    maxobjects integer,
    storagelimit jsonb,
    updatedat timestamp without time zone,
    service_id bigint
);


ALTER TABLE public.service_plan OWNER TO postgres;

--
-- Name: serviceplan_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serviceplan_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.serviceplan_id_generator OWNER TO postgres;

--
-- Name: subscription; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscription (
    id bigint NOT NULL,
    createddate timestamp without time zone NOT NULL,
    emailid character varying(255),
    status character varying(255),
    updateddate timestamp without time zone NOT NULL
);


ALTER TABLE public.subscription OWNER TO postgres;

--
-- Name: subscription_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subscription_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_id_generator OWNER TO postgres;

--
-- Name: user_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_generator OWNER TO postgres;

--
-- Name: user_plan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_plan (
    id bigint NOT NULL,
    createdat timestamp without time zone,
    enabled boolean,
    expiry timestamp without time zone,
    numofapps integer,
    servicetraffic jsonb,
    traffic jsonb,
    updatedat timestamp without time zone,
    userid bigint,
    plan_id bigint
);


ALTER TABLE public.user_plan OWNER TO postgres;

--
-- Name: user_plan_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_plan_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_plan_id_generator OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    accesslevel character varying(255),
    active integer,
    address jsonb,
    attributes jsonb,
    clientids jsonb,
    createddate timestamp without time zone NOT NULL,
    dob timestamp without time zone,
    education jsonb,
    email character varying(100),
    emailverified boolean,
    firstname character varying(255) NOT NULL,
    firsttimelogin boolean,
    gender character varying(255),
    isteammember boolean DEFAULT false,
    lastname character varying(255) NOT NULL,
    metabaseid bigint,
    middlename character varying(255),
    mobile character varying(255),
    organizationtitle character varying(255),
    organizationtype integer,
    password character varying(255) NOT NULL,
    photo character varying(255),
    updateddate timestamp without time zone NOT NULL,
    username character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_roles (
    muser_id bigint NOT NULL,
    roles_id bigint NOT NULL
);


ALTER TABLE public.users_roles OWNER TO postgres;

--
-- Name: uzer_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.uzer_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uzer_id_generator OWNER TO postgres;

--
-- Name: uzers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uzers (
    id bigint NOT NULL,
    accounttype integer,
    authuserid bigint,
    availablescus integer,
    consumedcloudstorage double precision,
    createdat timestamp without time zone,
    email character varying(255),
    firstname character varying(255),
    isredirect boolean,
    lastname character varying(255),
    mobile character varying(255),
    organizationtitle character varying(255),
    organizationtype integer,
    ownerid bigint,
    photo character varying(255),
    role integer,
    scucouponsapplied jsonb,
    totalcloudstorage double precision,
    updatedat timestamp without time zone,
    userid bigint,
    userstatus integer,
    username character varying(255),
    organization_id bigint,
    plan_id bigint
);


ALTER TABLE public.uzers OWNER TO postgres;

--
-- Name: verification_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verification_tokens (
    id bigint NOT NULL,
    client character varying(255),
    expirydate timestamp without time zone,
    token character varying(255),
    user_id bigint NOT NULL
);


ALTER TABLE public.verification_tokens OWNER TO postgres;

--
-- Data for Name: app; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app (id, apikey, appid, appsecretkey, createddate, description, iskit, ismpcreated, kongid, mpidentifier, mpusecasestatus, name, productsenabled, ratelimitid, updateddate, userid) FROM stdin;
\.


--
-- Data for Name: auth_client_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_client_config (id, client, createdat, initurl, updatedat) FROM stdin;
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id, description, isinternal, name) FROM stdin;
1	Suite of AI platform and services	f	AI Suite
\.


--
-- Data for Name: data_source; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_source (id, name, subdatasources) FROM stdin;
1	Dapi	{"Sink": {"@type": "java.util.HashMap", "Hadoop": null, "InfluxDB": null, "Postgres": null}, "@type": "java.util.HashMap", "Ingester": {"@type": "java.util.HashMap", "Event": null, "Config": null, "CRON Expression": null}, "Transformer": null}
2	S3	{"@type": "java.util.HashMap"}
3	DataBase	{"H2": {"name": null, "@type": "java.util.HashMap", "isEnabled": false, "connection string": null}, "@type": "java.util.HashMap", "Druid": {"host": null, "name": null, "@type": "java.util.HashMap", "isEnabled": false, "Broker Node Port": null}, "MySQL": {"host": null, "name": "How you like to be called?", "port": 3306, "@type": "java.util.HashMap", "password": null, "username": "What user name do you use to login?", "isEnabled": true, "database name": "XYZ_birds"}, "Presto": {"host": null, "name": "How you like to be called?", "port": null, "@type": "java.util.HashMap", "password": null, "username": "What user name do you use to login?", "isEnabled": true, "database name": "XYZ_birds"}, "SQLite": {"host": null, "name": "How you like to be called?", "port": null, "@type": "java.util.HashMap", "password": null, "username": "What user name do you use to login?", "isEnabled": false, "database name": "XYZ_birds"}, "MongoDB": {"host": null, "name": null, "port": null, "@type": "java.util.HashMap", "password": null, "username": null, "isEnabled": true, "database name": null, "Authentication DataBase": null, "Additional Mongo connection string options": null}, "BigQuery": {"name": null, "@type": "java.util.HashMap", "isEnabled": true, "dataset id": null}, "Snowflake": {"name": null, "role": null, "@type": "java.util.HashMap", "schema": null, "account": null, "password": null, "username": null, "isEnabled": true, "region id": null, "warehouse": null, "database name (case sensitive)": null, "additional JDBC connection string options": null}, "Spark SQL": {"host": null, "name": "How you like to be called?", "port": 100000, "@type": "java.util.HashMap", "password": null, "username": "What user name do you use to login?", "isEnabled": false, "database name": "XYZ_birds"}, "PostgreSQL": {"host": null, "name": "How you like to be called?", "port": 5432, "@type": "java.util.HashMap", "password": null, "username": "What user name do you use to login?", "isEnabled": true, "database name": "XYZ_birds"}, "SQL Server": {"host": null, "name": "How you like to be called?", "port": 1433, "@type": "java.util.HashMap", "password": null, "username": "What user name do you use to login?", "isEnabled": false, "database name": "XYZ_birds"}, "Amazon Redshift": {"host": null, "name": "How you like to be called?", "port": 5439, "@type": "java.util.HashMap", "password": null, "username": "What user name do you use to login?", "isEnabled": true, "database name": "XYZ_birds"}, "Google Analytics": {"name": null, "@type": "java.util.HashMap", "Auth Code": null, "Client Id": null, "isEnabled": false, "Client Secret": null, "Google Analytics Account Id": null}}
\.



--
-- Data for Name: file; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.file (id, cloudfronturl, cloudfronturlsigned, createdat, filename, filesize, filesystem, fileurl, ispublic, label, metadata, s3key, s3url, type, updatedat, userid, username) FROM stdin;
\.


--
-- Data for Name: metabase_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metabase_tokens (id, createddate, sessionid, user_id) FROM stdin;
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification (id, createddate, isread, message, updateddate, userid) FROM stdin;
\.


--
-- Data for Name: oauth_client_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oauth_client_details (client_id, resource_ids, client_secret, scope, authorized_grant_types, web_server_redirect_uri, authorities, access_token_validity, refresh_token_validity, additional_information, autoapprove) FROM stdin;
dltk		$2a$04$sRqC9ip3JfhV3XPmNlfqP.HxF7BD5EwYISq6br4OTZs.dCUMs3Td.	user,read,write	password,refresh_token	\N	\N	36000	36000	\N	true
\.


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization (id, createdat, department, mobile, name, ownerid, teamsize, updatedat, website) FROM stdin;
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_tokens (id, expirydate, token, user_id) FROM stdin;
\.


--
-- Data for Name: plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plan (id, apicallslimit, cloudstorage, createdat, discounts, enabled, features, globalprice, ispublic, maxapicalls, maxapps, name, paymenttype, plancategory, plantype, price, scu, storagelimit, tagline, updatedat, validityindays) FROM stdin;
4	{"SEC": ["java.lang.Long", 500], "DAYS": ["java.lang.Long", 500], "HOUR": ["java.lang.Long", 500], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", 500], "MINUTE": ["java.lang.Long", 500], "MILLISEC": ["java.lang.Long", -1]}	107374182400	2019-06-18 11:41:15.101423	{"@type": "java.util.HashMap", "YEARLY_SUBSCRIPTION": 10, "MONTHLY_SUBSCRIPTION": 2}	t	1. DLTK ML  2. DLTK Language 3. DLTK Computer Vision	1	t	100000	100	MSMEs	0	2	0	1	\N	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", 3500], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", 100000], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	MSMEs	\N	30
\.


--
-- Data for Name: plan_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plan_product (mplan_id, products_id) FROM stdin;
4	1
4	2
4	3
\.


--
-- Data for Name: plan_service_plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plan_service_plan (mplan_id, services_id) FROM stdin;
4	1
4	2
4	3
4	4
4	5
4	6
4	7
4	8
4	9
4	10
4	11
4	12
4	13
4	14
4	15
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, complexity, contextpath, description, imageurl, isfeatured, isinternal, ispublic, name, owner, tagline, thumbnailurl, videourl, category_id) FROM stdin;
3	\N	dltk-language	Natural Language Processing helps to analyse text and extract meta-data from content such as sentiments, concepts, entities, etc. For example, you submit a review and service returns sentiment behind review like positive or negative. It can also do POS tagging. POS tags are useful for building parse trees, which are used in building NERs (most named entities are Nouns) and extracting relations between words.		\N	\N	t	Natural Language Processing	QubitAI Technologies	Natural Language Processing/Understanding on the cloud			1
1	\N	dltk-machinelearning	Machine Learning helps to give predictive capabilities to applications with ease. You can build classification and regression models. It can also do clustering and visualize different clusters. It supports multiple ML libraries like Weka, Scikit-Learn, H2O and Tensorflow. It includes around 22 different algorithms for building classification, regression and clustering models.		t	\N	t	Machine Learning	QubitAI Technologies	Build Custom ML models on the cloud			1
2	\N	computer_vision	Make sense of your visual content. Computer Vision service uses advanced deep learning algorithms to analyze images and videos for scenes, objects, faces, and other content. For example, you upload a photograph and service detects different objects in a photograph. You can use default model from DLTK or create your own custom classifier.		t	\N	t	Computer Vision	QubitAI Technologies	Analyse image/video content on the cloud			1
\.


--
-- Data for Name: request_uri; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.request_uri (id, createdat, enabled, methods, name, postchecks, prechecks, product, productid, requesturi, roles, service, servicecontext, serviceid, updatedat) FROM stdin;
12	2019-06-18 10:12:33.181393	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK ML Cluster	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK ML	1	/cluster/	\N	Cluster	machinelearning-service/dltk-machinelearning	3	\N
10	2019-06-18 10:14:09.310284	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"], ["java.lang.String", "DELETE"]]]	DLTK ML Classification	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK ML	1	/(classification|job|output|stream|automate)[/|\\w|\\W|\\d]+	\N	Classification	machinelearning-service/dltk-machinelearning	1	\N
40	2020-11-16 11:00:23.247854	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"], ["java.lang.String", "DELETE"]]]	DLTK ML DataSource	\N	["java.util.ArrayList", [["java.lang.String", "AUTH_CHECK"]]]	DLTK ML DataSource	1	/datasource/[/|\\w|\\W|\\d]*	\N	Wrapper	machinelearning-service/dltk-machinelearning	\N	\N
9	2019-06-14 09:15:23.247854	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK ML Public	\N	["java.util.ArrayList", [["java.lang.String", "PUBLIC"]]]	DLTK ML	1	/algorithm/[/|\\w|\\W|\\d]*	\N	Wrapper	machinelearning-service/dltk-machinelearning	\N	\N
11	2019-06-18 10:10:55.96441	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK ML Regression	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK ML	1	/regression/[\\w|\\W|\\d]+	\N	Regression	machinelearning-service/dltk-machinelearning	2	\N
19	2019-06-18 10:43:01.317305	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK Language POS	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK Language	3	/(nlp/pos)[/|\\w|\\W|\\d]*	\N	POS Tagger	language-service/dltk-language	5	\N
20	2019-06-18 10:44:38.35031	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK Language NER	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK Language	3	/(nlp/ner)[/|\\w|\\W|\\d]*	\N	NER	language-service/dltk-language	6	\N
42	2019-06-18 10:49:13.716451	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK ML Timeseries	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK ML	1	/timeseries/[\\w|\\W|\\d]+	\N	Timeseries	machinelearning-service/dltk-machinelearning	4	\N
21	2019-06-18 10:46:15.270839	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK Language Sentiment	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK Language	3	/(nlp/sentiment)[/|\\w|\\W|\\d]*	\N	Sentiment	language-service/dltk-language	7	\N
22	2019-06-18 10:47:21.688164	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK Language Dependency Parser	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK Language	3	/(nlp/dependency-parser)[/|\\w|\\W|\\d]*	\N	Dependency 	language-service/dltk-language	10	\N
23	2019-06-18 10:49:13.716451	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK Language Tags Extractor	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK Language	3	/(nlp/tags)[/|\\w|\\W|\\d]*	\N	Tags Extractor	language-service/dltk-language	8	\N
41	2019-06-18 10:49:13.716451	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK Language Topic Modelling	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK Language	3	/(nlp/topic_modeling)[/|\\w|\\W|\\d]*	\N	Topic Modelling	language-service/dltk-language	9	\N
46	2019-06-18 10:32:47.150229	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK Computer Vision Face Analytics	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK Computer Vision 	2	/face_analytics/	\N	Face Analytics 	dltk-computer-vision-service/computer_vision	13	\N
106	2019-06-18 10:32:47.150229	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK Computer Vision Image Classification	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK Computer Vision 	2	/image_classification/	\N	Image Classification 	dltk-computer-vision-service/computer_vision	15	\N
107	2019-06-18 10:32:47.150229	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK Computer Vision Object Detection	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK Computer Vision 	2	/object_detection/	\N	Object Detection 	dltk-computer-vision-service/computer_vision	14	\N
47	2019-06-14 08:19:28.335505	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"], ["java.lang.String", "DELETE"]]]	Base Service	\N	["java.util.ArrayList", [["java.lang.String", "ALL"]]]	Base	\N	/[/|\\w|\\W|\\d]*	\N	base	base	\N	\N
110	2019-06-18 10:49:13.716451	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK Language Sarcasm Detection	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK Language	3	/(nlp/sarcasm_detection)[/|\\w|\\W|\\d]*	\N	Sarcasm Detection	language-service/dltk-language	11	\N
111	2019-06-18 10:49:13.716451	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK Language Text Summarization	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK Language	3	/(nlp/sarcasm_detection)[/|\\w|\\W|\\d]*	\N	Text Summarization	language-service/dltk-language	12	\N
112	2019-06-18 10:49:13.716451	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	Helpdesk Service 	\N	["java.util.ArrayList", [["java.lang.String", "PUBLIC"]]]	Helpdesk	\N	/[\w|\W|\d]+	\N	Helpdesk	helpdesk-service/dltk-helpdesk	\N	\N
150	2019-06-18 10:32:47.150229	t	["java.util.HashSet", [["java.lang.String", "GET"], ["java.lang.String", "POST"], ["java.lang.String", "PUT"]]]	DLTK Computer Vision Task	\N	["java.util.ArrayList", [["java.lang.String", "API_KEY_CHECK"]]]	DLTK Computer Vision 	2	/task/	\N	CV Task 	dltk-computer-vision-service/computer_vision	\N	\N
\.




COPY public.request_uri (id, createdat, enabled, methods, name, postchecks, prechecks, product, productid, requesturi, roles, service, servicecontext, serviceid, updatedat) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name) FROM stdin;
84	ROLE_USER
1	ROLE_DLTK_USER
99999	ROLE_ADMIN
2	ROLE_SALES
\.


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service (id, contextpath, createdat, enabled, name, updatedat, product_id) FROM stdin;
1	/classification	2019-06-14 07:51:59.020243	t	Classification	\N	\N
2	/regression	2019-06-14 07:52:19.908256	t	Regression	\N	\N
3	/cluster	2019-06-14 07:52:47.41287	t	Cluster	\N	\N
4	/timeseries	2019-06-14 07:57:40.993848	t	Timeseries	\N	\N
5	/nlp/pos/	2019-06-14 07:55:51.659771	t	POS Tagger	\N	\N
6	/nlp/ner/	2019-06-14 07:56:14.463643	t	NER Tagger	\N	\N
7	/nlp/sentiment/	2019-06-14 07:56:47.426035	t	Sentiment Analysis	\N	\N
8	/nlp/tags/	2019-06-14 07:57:40.993848	t	Tags Extractor	\N	\N
9	/nlp/topic_modeling/	2019-06-14 07:57:40.993848	t	Topic Modelling	\N	\N
10	/nlp/dependency-parser/	2019-06-14 07:57:17.113163	t	Dependency Parser	\N	\N
11	/nlp/sarcasm_detection/	2019-06-14 07:57:40.993848	t	Sarcasm Detection	\N	\N
12	/nlp/text_summarization/	2019-06-14 07:57:40.993848	t	Text Summarization	\N	\N
13	/face_analytics/	2019-06-14 07:53:13.685175	t	Face Detection	\N	\N
14	/object_detection/	2019-06-14 07:53:36.730667	t	Object Detection	\N	\N
15	/image_classification	2019-06-14 07:54:10.455648	t	Image Classification	\N	\N
\.


--
-- Data for Name: service_plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_plan (id, apicallslimit, createdat, enabled, maxapicalls, maxobjects, storagelimit, updatedat, service_id) FROM stdin;
1	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	1
2	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	2
3	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	3
4	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	4
5	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	5
6	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	6
7	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	7
8	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	8
9	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	9
10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	10
11	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	11
12	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	12
13	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	13
14	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	14
15	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	2019-06-24 12:59:53.221828	t	100000	10	{"SEC": ["java.lang.Long", -1], "DAYS": ["java.lang.Long", -1], "HOUR": ["java.lang.Long", -1], "@type": "java.util.HashMap", "MONTH": ["java.lang.Long", -1], "MINUTE": ["java.lang.Long", -1], "MILLISEC": ["java.lang.Long", -1]}	\N	15
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription (id, createddate, emailid, status, updateddate) FROM stdin;
\.


--
-- Data for Name: user_plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_plan (id, createdat, enabled, expiry, numofapps, servicetraffic, traffic, updatedat, userid, plan_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, accesslevel, active, address, attributes, clientids, createddate, dob, education, email, emailverified, firstname, firsttimelogin, gender, isteammember, lastname, metabaseid, middlename, mobile, organizationtitle, organizationtype, password, photo, updateddate, username) FROM stdin;
\.


--
-- Data for Name: users_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_roles (muser_id, roles_id) FROM stdin;
\.


--
-- Data for Name: uzers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uzers (id, accounttype, authuserid, availablescus, consumedcloudstorage, createdat, email, firstname, isredirect, lastname, mobile, organizationtitle, organizationtype, ownerid, photo, role, scucouponsapplied, totalcloudstorage, updatedat, userid, userstatus, username, organization_id, plan_id) FROM stdin;
\.


--
-- Data for Name: verification_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verification_tokens (id, client, expirydate, token, user_id) FROM stdin;
\.


--
-- Name: app_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_id_generator', Max(id), true) from public.app;


--
-- Name: auth_client_config_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_client_config_id_generator', Max(id), true) from public.auth_client_config;


--
-- Name: category_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_id_generator', Max(id), true) from public.category;


--
-- Name: data_source_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.data_source_id_generator', 1, false);


--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hibernate_sequence', 1, true) ;


--
-- Name: metabase_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metabase_id_generator', Max(id), true) from public.metabase_tokens;


--
-- Name: notification_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_id_generator', Max(id), true) from public.notification;


--
-- Name: org_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.org_id_generator', Max(id), true) from public.organization;


--
-- Name: plan_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plan_id_generator', Max(id), true) from public.plan;


--
-- Name: product_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_id_generator', Max(id), true) from public.product;


--
-- Name: req_uri_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.req_uri_generator', Max(id), true) from public.request_uri;


--
-- Name: role_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_id_generator', Max(id), true) from public.roles;


--
-- Name: service_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_id_generator', Max(id), true) from public.service;


--
-- Name: serviceplan_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serviceplan_id_generator', Max(id), true) from public.service_plan;


--
-- Name: subscription_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subscription_id_generator', Max(id), true) from public.subscription;


--
-- Name: user_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_generator', Max(id), true) from public.users;


--
-- Name: user_plan_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_plan_id_generator', Max(id), true) from public.user_plan;


--
-- Name: uzer_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.uzer_id_generator', Max(id), true) from public.uzers;


--
-- Name: app app_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT app_pkey PRIMARY KEY (id);


--
-- Name: auth_client_config auth_client_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_client_config
    ADD CONSTRAINT auth_client_config_pkey PRIMARY KEY (id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: data_source data_source_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source
    ADD CONSTRAINT data_source_pkey PRIMARY KEY (id);


--
-- Name: file file_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file
    ADD CONSTRAINT file_pkey PRIMARY KEY (id);


--
-- Name: metabase_tokens metabase_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_tokens
    ADD CONSTRAINT metabase_tokens_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_details oauth_client_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_client_details
    ADD CONSTRAINT oauth_client_details_pkey PRIMARY KEY (client_id);


--
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--
-- Name: plan plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan
    ADD CONSTRAINT plan_pkey PRIMARY KEY (id);


--
-- Name: plan_product plan_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_product
    ADD CONSTRAINT plan_product_pkey PRIMARY KEY (mplan_id, products_id);


--
-- Name: plan_service_plan plan_service_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_service_plan
    ADD CONSTRAINT plan_service_plan_pkey PRIMARY KEY (mplan_id, services_id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: request_uri request_uri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_uri
    ADD CONSTRAINT request_uri_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: service service_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: service_plan service_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_plan
    ADD CONSTRAINT service_plan_pkey PRIMARY KEY (id);


--
-- Name: subscription subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (id);


--
-- Name: category uk_46ccwnsi9409t36lurvtyljak; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT uk_46ccwnsi9409t36lurvtyljak UNIQUE (name);


--
-- Name: users uk_6dotkott2kjsp8vw4d0m25fb7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk_6dotkott2kjsp8vw4d0m25fb7 UNIQUE (email);


--
-- Name: auth_client_config uk_99g5d13tp8et9toy867yw9n3l; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_client_config
    ADD CONSTRAINT uk_99g5d13tp8et9toy867yw9n3l UNIQUE (client);


--
-- Name: organization uk_ayeouo3hp1r6g93l68e1drh05; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT uk_ayeouo3hp1r6g93l68e1drh05 UNIQUE (ownerid);


--
-- Name: uzers uk_fdgifhfuyyw2vtnodemgf73xx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzers
    ADD CONSTRAINT uk_fdgifhfuyyw2vtnodemgf73xx UNIQUE (authuserid);


--
-- Name: uzers uk_hyusnevfmc04p8x6h5xvr5igu; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzers
    ADD CONSTRAINT uk_hyusnevfmc04p8x6h5xvr5igu UNIQUE (userid);


--
-- Name: product uk_jmivyxk9rmgysrmsqw15lqr5b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT uk_jmivyxk9rmgysrmsqw15lqr5b UNIQUE (name);


--
-- Name: request_uri uk_mk0thlqeippip2x1lq3uvcrnu; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_uri
    ADD CONSTRAINT uk_mk0thlqeippip2x1lq3uvcrnu UNIQUE (name);


--
-- Name: roles uk_ofx66keruapi6vyqpv6f2or37; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT uk_ofx66keruapi6vyqpv6f2or37 UNIQUE (name);


--
-- Name: app uki46dgbcvgwceqh8dihry8ui83; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT uki46dgbcvgwceqh8dihry8ui83 UNIQUE (userid, name);


--
-- Name: user_plan user_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_plan
    ADD CONSTRAINT user_plan_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_roles users_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT users_roles_pkey PRIMARY KEY (muser_id, roles_id);


--
-- Name: uzers uzers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzers
    ADD CONSTRAINT uzers_pkey PRIMARY KEY (id);


--
-- Name: verification_tokens verification_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_pkey PRIMARY KEY (id);


--
-- Name: product fk1mtsbur82frn64de7balymq9s; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk1mtsbur82frn64de7balymq9s FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- Name: service_plan fk20vmbecpvumi0kc93d6l2tq67; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_plan
    ADD CONSTRAINT fk20vmbecpvumi0kc93d6l2tq67 FOREIGN KEY (service_id) REFERENCES public.service(id);


--
-- Name: verification_tokens fk54y8mqsnq1rtyf581sfmrbp4f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT fk54y8mqsnq1rtyf581sfmrbp4f FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: plan_product fk8pbxj4t1lb59i2hnxqken9qv4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_product
    ADD CONSTRAINT fk8pbxj4t1lb59i2hnxqken9qv4 FOREIGN KEY (mplan_id) REFERENCES public.plan(id);


--
-- Name: uzers fk8vqbjdhr00nf6fq395wysyj5v; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzers
    ADD CONSTRAINT fk8vqbjdhr00nf6fq395wysyj5v FOREIGN KEY (plan_id) REFERENCES public.user_plan(id);


--
-- Name: plan_service_plan fk9f8d7rt0ae5ic7wo8m1kgn3yw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_service_plan
    ADD CONSTRAINT fk9f8d7rt0ae5ic7wo8m1kgn3yw FOREIGN KEY (services_id) REFERENCES public.service_plan(id);


--
-- Name: users_roles fka62j07k5mhgifpp955h37ponj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT fka62j07k5mhgifpp955h37ponj FOREIGN KEY (roles_id) REFERENCES public.roles(id);


--
-- Name: plan_product fkblhsk0nqqoyi0fdpl51snb6wp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_product
    ADD CONSTRAINT fkblhsk0nqqoyi0fdpl51snb6wp FOREIGN KEY (products_id) REFERENCES public.product(id);


--
-- Name: users_roles fke1q16fixxqk30l8mkw8nb59x9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT fke1q16fixxqk30l8mkw8nb59x9 FOREIGN KEY (muser_id) REFERENCES public.users(id);


--
-- Name: user_plan fkfgwof219hqbrb6am5awwan8r2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_plan
    ADD CONSTRAINT fkfgwof219hqbrb6am5awwan8r2 FOREIGN KEY (plan_id) REFERENCES public.plan(id);


--
-- Name: service fkheep7eafwbn7ip1fukx9ti1y3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT fkheep7eafwbn7ip1fukx9ti1y3 FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: password_reset_tokens fkk3ndxg5xp6v7wd4gjyusp15gq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT fkk3ndxg5xp6v7wd4gjyusp15gq FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: plan_service_plan fkkhxn8rh1edhrbnv926i8c2y2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_service_plan
    ADD CONSTRAINT fkkhxn8rh1edhrbnv926i8c2y2 FOREIGN KEY (mplan_id) REFERENCES public.plan(id);


--
-- Name: uzers fknhv5d9yobp3f4rkift6guguu4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzers
    ADD CONSTRAINT fknhv5d9yobp3f4rkift6guguu4 FOREIGN KEY (organization_id) REFERENCES public.organization(id);


--
-- Name: metabase_tokens fkrq7ik98ur7noxx48hj5mi4270; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_tokens
    ADD CONSTRAINT fkrq7ik98ur7noxx48hj5mi4270 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--
