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

--
-- Name: sync_tags(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sync_tags() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          IF (TG_OP = 'TRUNCATE') THEN
            DELETE FROM tags WHERE entity_name = TG_TABLE_NAME;
            RETURN NULL;
          ELSIF (TG_OP = 'DELETE') THEN
            DELETE FROM tags WHERE entity_id = OLD.id;
            RETURN OLD;
          ELSE

          -- Triggered by INSERT/UPDATE
          -- Do an upsert on the tags table
          -- So we don't need to migrate pre 1.1 entities
          INSERT INTO tags VALUES (NEW.id, TG_TABLE_NAME, NEW.tags)
          ON CONFLICT (entity_id) DO UPDATE
                  SET tags=EXCLUDED.tags;
          END IF;
          RETURN NEW;
        END;
      $$;


ALTER FUNCTION public.sync_tags() OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: acls; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acls (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    consumer_id uuid,
    "group" text,
    cache_key text,
    tags text[]
);


ALTER TABLE public.acls OWNER TO postgres;

--
-- Name: acme_storage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acme_storage (
    id uuid NOT NULL,
    key text,
    value text,
    created_at timestamp with time zone,
    ttl timestamp with time zone
);


ALTER TABLE public.acme_storage OWNER TO postgres;

--
-- Name: basicauth_credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.basicauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    consumer_id uuid,
    username text,
    password text,
    tags text[]
);


ALTER TABLE public.basicauth_credentials OWNER TO postgres;

--
-- Name: ca_certificates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ca_certificates (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    cert text NOT NULL,
    tags text[]
);


ALTER TABLE public.ca_certificates OWNER TO postgres;

--
-- Name: certificates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.certificates (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    cert text,
    key text,
    tags text[]
);


ALTER TABLE public.certificates OWNER TO postgres;

--
-- Name: cluster_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cluster_events (
    id uuid NOT NULL,
    node_id uuid NOT NULL,
    at timestamp with time zone NOT NULL,
    nbf timestamp with time zone,
    expire_at timestamp with time zone NOT NULL,
    channel text,
    data text
);


ALTER TABLE public.cluster_events OWNER TO postgres;

--
-- Name: consumers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consumers (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    username text,
    custom_id text,
    tags text[]
);


ALTER TABLE public.consumers OWNER TO postgres;

--
-- Name: hmacauth_credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hmacauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    consumer_id uuid,
    username text,
    secret text,
    tags text[]
);


ALTER TABLE public.hmacauth_credentials OWNER TO postgres;

--
-- Name: jwt_secrets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jwt_secrets (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    consumer_id uuid,
    key text,
    secret text,
    algorithm text,
    rsa_public_key text,
    tags text[]
);


ALTER TABLE public.jwt_secrets OWNER TO postgres;

--
-- Name: keyauth_credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keyauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    consumer_id uuid,
    key text,
    tags text[],
    ttl timestamp with time zone
);


ALTER TABLE public.keyauth_credentials OWNER TO postgres;

--
-- Name: locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locks (
    key text NOT NULL,
    owner text,
    ttl timestamp with time zone
);


ALTER TABLE public.locks OWNER TO postgres;

--
-- Name: oauth2_authorization_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth2_authorization_codes (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    credential_id uuid,
    service_id uuid,
    code text,
    authenticated_userid text,
    scope text,
    ttl timestamp with time zone
);


ALTER TABLE public.oauth2_authorization_codes OWNER TO postgres;

--
-- Name: oauth2_credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth2_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    name text,
    consumer_id uuid,
    client_id text,
    client_secret text,
    redirect_uris text[],
    tags text[]
);


ALTER TABLE public.oauth2_credentials OWNER TO postgres;

--
-- Name: oauth2_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth2_tokens (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    credential_id uuid,
    service_id uuid,
    access_token text,
    refresh_token text,
    token_type text,
    expires_in integer,
    authenticated_userid text,
    scope text,
    ttl timestamp with time zone
);


ALTER TABLE public.oauth2_tokens OWNER TO postgres;

--
-- Name: plugins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plugins (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    name text NOT NULL,
    consumer_id uuid,
    service_id uuid,
    route_id uuid,
    config jsonb NOT NULL,
    enabled boolean NOT NULL,
    cache_key text,
    protocols text[],
    tags text[]
);


ALTER TABLE public.plugins OWNER TO postgres;

--
-- Name: ratelimiting_metrics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ratelimiting_metrics (
    identifier text NOT NULL,
    period text NOT NULL,
    period_date timestamp with time zone NOT NULL,
    service_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    route_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    value integer
);


ALTER TABLE public.ratelimiting_metrics OWNER TO postgres;

--
-- Name: response_ratelimiting_metrics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.response_ratelimiting_metrics (
    identifier text NOT NULL,
    period text NOT NULL,
    period_date timestamp with time zone NOT NULL,
    service_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    route_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    value integer
);


ALTER TABLE public.response_ratelimiting_metrics OWNER TO postgres;

--
-- Name: routes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.routes (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    service_id uuid,
    protocols text[],
    methods text[],
    hosts text[],
    paths text[],
    snis text[],
    sources jsonb[],
    destinations jsonb[],
    regex_priority bigint,
    strip_path boolean,
    preserve_host boolean,
    tags text[],
    https_redirect_status_code integer,
    headers jsonb,
    path_handling text DEFAULT 'v0'::text
);


ALTER TABLE public.routes OWNER TO postgres;

--
-- Name: schema_meta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_meta (
    key text NOT NULL,
    subsystem text NOT NULL,
    last_executed text,
    executed text[],
    pending text[]
);


ALTER TABLE public.schema_meta OWNER TO postgres;

--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    retries bigint,
    protocol text,
    host text,
    port bigint,
    path text,
    connect_timeout bigint,
    write_timeout bigint,
    read_timeout bigint,
    tags text[],
    client_certificate_id uuid
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id uuid NOT NULL,
    session_id text,
    expires integer,
    data text,
    created_at timestamp with time zone,
    ttl timestamp with time zone
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: snis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.snis (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(0)),
    name text NOT NULL,
    certificate_id uuid,
    tags text[]
);


ALTER TABLE public.snis OWNER TO postgres;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    entity_id uuid NOT NULL,
    entity_name text,
    tags text[]
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: targets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.targets (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(3)),
    upstream_id uuid,
    target text NOT NULL,
    weight integer NOT NULL,
    tags text[]
);


ALTER TABLE public.targets OWNER TO postgres;

--
-- Name: ttls; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ttls (
    primary_key_value text NOT NULL,
    primary_uuid_value uuid,
    table_name text NOT NULL,
    primary_key_name text NOT NULL,
    expire_at timestamp without time zone NOT NULL
);


ALTER TABLE public.ttls OWNER TO postgres;

--
-- Name: upstreams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.upstreams (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, CURRENT_TIMESTAMP(3)),
    name text,
    hash_on text,
    hash_fallback text,
    hash_on_header text,
    hash_fallback_header text,
    hash_on_cookie text,
    hash_on_cookie_path text,
    slots integer NOT NULL,
    healthchecks jsonb,
    tags text[],
    algorithm text,
    host_header text
);


ALTER TABLE public.upstreams OWNER TO postgres;

--
-- Data for Name: acls; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.acls (id, created_at, consumer_id, "group", cache_key, tags) FROM stdin;
\.


--
-- Data for Name: acme_storage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.acme_storage (id, key, value, created_at, ttl) FROM stdin;
\.


--
-- Data for Name: basicauth_credentials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.basicauth_credentials (id, created_at, consumer_id, username, password, tags) FROM stdin;
\.


--
-- Data for Name: ca_certificates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ca_certificates (id, created_at, cert, tags) FROM stdin;
\.


--
-- Data for Name: certificates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.certificates (id, created_at, cert, key, tags) FROM stdin;
\.


--
-- Data for Name: cluster_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) FROM stdin;
\.


--
-- Data for Name: consumers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consumers (id, created_at, username, custom_id, tags) FROM stdin;
\.


--
-- Data for Name: hmacauth_credentials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hmacauth_credentials (id, created_at, consumer_id, username, secret, tags) FROM stdin;
\.


--
-- Data for Name: jwt_secrets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jwt_secrets (id, created_at, consumer_id, key, secret, algorithm, rsa_public_key, tags) FROM stdin;
\.


--
-- Data for Name: keyauth_credentials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keyauth_credentials (id, created_at, consumer_id, key, tags, ttl) FROM stdin;
\.


--
-- Data for Name: locks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locks (key, owner, ttl) FROM stdin;
\.


--
-- Data for Name: oauth2_authorization_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oauth2_authorization_codes (id, created_at, credential_id, service_id, code, authenticated_userid, scope, ttl) FROM stdin;
\.


--
-- Data for Name: oauth2_credentials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oauth2_credentials (id, created_at, name, consumer_id, client_id, client_secret, redirect_uris, tags) FROM stdin;
\.


--
-- Data for Name: oauth2_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oauth2_tokens (id, created_at, credential_id, service_id, access_token, refresh_token, token_type, expires_in, authenticated_userid, scope, ttl) FROM stdin;
\.


--
-- Data for Name: plugins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plugins (id, created_at, name, consumer_id, service_id, route_id, config, enabled, cache_key, protocols, tags) FROM stdin;
b34e5fb2-eb14-43d3-a79d-39658130032e	2021-03-06 10:42:08+00	key-auth	\N	\N	5a41151c-e291-41aa-a7a7-f805a003d797	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:5a41151c-e291-41aa-a7a7-f805a003d797:::	{grpc,grpcs,http,https}	\N
053071fe-258c-4100-aa08-3d63c6efa6ed	2021-03-06 10:42:21+00	key-auth	\N	\N	9437e3d2-800b-4f2c-a9f0-4d6adf02d770	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:9437e3d2-800b-4f2c-a9f0-4d6adf02d770:::	{grpc,grpcs,http,https}	\N
f6def5ad-c6f9-4564-a569-3117932ee238	2021-03-06 10:46:08+00	key-auth	\N	\N	005bf2cc-2f0e-4ee2-bc7e-6f46af5c12bc	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:005bf2cc-2f0e-4ee2-bc7e-6f46af5c12bc:::	{grpc,grpcs,http,https}	\N
67461b9c-ae70-41a8-8bd9-73f802970e84	2021-03-06 10:46:18+00	key-auth	\N	\N	bedb2b5c-c56a-41a8-8a99-99f163715771	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:bedb2b5c-c56a-41a8-8a99-99f163715771:::	{grpc,grpcs,http,https}	\N
b23e2bf4-b802-4824-bd53-dac5cd261330	2021-03-06 10:47:59+00	key-auth	\N	\N	49877431-4cbe-4ad5-bc79-94eaf6cbc4a1	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:49877431-4cbe-4ad5-bc79-94eaf6cbc4a1:::	{grpc,grpcs,http,https}	\N
4436ced5-8b0a-4264-8153-65f28892d3fc	2021-03-06 10:48:08+00	key-auth	\N	\N	147d4143-f710-4a81-8624-f8cbc5ce9981	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:147d4143-f710-4a81-8624-f8cbc5ce9981:::	{grpc,grpcs,http,https}	\N
f014b0fd-6861-4597-8242-40a0ec6aa407	2021-03-06 10:48:15+00	key-auth	\N	\N	08df3e0a-7123-4b9b-8277-4f78759b85c0	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:08df3e0a-7123-4b9b-8277-4f78759b85c0:::	{grpc,grpcs,http,https}	\N
f8de5541-046c-431d-a6eb-32005f4e126f	2021-03-06 10:48:26+00	key-auth	\N	\N	334b4e04-b58f-44bd-b022-17090ab766e8	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:334b4e04-b58f-44bd-b022-17090ab766e8:::	{grpc,grpcs,http,https}	\N
29bcad9e-cd70-412b-a3a3-bdfb027826ed	2021-03-06 10:48:32+00	key-auth	\N	\N	38e89493-7448-49e0-8d08-1c2ee333f61c	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:38e89493-7448-49e0-8d08-1c2ee333f61c:::	{grpc,grpcs,http,https}	\N
dfbeee4e-4a97-42c0-bb09-bbe302ced383	2021-03-06 10:48:38+00	key-auth	\N	\N	85f7f517-4278-4287-b5d1-f95084b73d27	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:85f7f517-4278-4287-b5d1-f95084b73d27:::	{grpc,grpcs,http,https}	\N
eeede7a2-8af0-4620-be48-3c8e9e0e5724	2021-03-06 10:48:54+00	key-auth	\N	\N	0d433130-99ad-4f89-9e4f-ba50d5fe8b55	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:0d433130-99ad-4f89-9e4f-ba50d5fe8b55:::	{grpc,grpcs,http,https}	\N
dc89f9e4-f346-4fcd-9bd7-a196044b267d	2021-03-06 10:49:02+00	key-auth	\N	\N	79ae2040-876f-44b7-ab60-5cfb16acf29a	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:79ae2040-876f-44b7-ab60-5cfb16acf29a:::	{grpc,grpcs,http,https}	\N
91d6821e-c7e7-4989-88b3-51120599ad5c	2021-03-06 10:49:11+00	key-auth	\N	\N	ba13f6e8-0a4f-44de-b9e2-29e75a041462	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:ba13f6e8-0a4f-44de-b9e2-29e75a041462:::	{grpc,grpcs,http,https}	\N
c1a87854-f0f1-46bc-a730-2fa57dfda62a	2021-03-06 10:49:18+00	key-auth	\N	\N	a9719902-358a-4735-9297-a07476386086	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:a9719902-358a-4735-9297-a07476386086:::	{grpc,grpcs,http,https}	\N
756942d0-2d9b-4e8f-b095-db1198df37aa	2021-03-06 10:49:25+00	key-auth	\N	\N	b34e560c-16b5-4c65-b17e-1ddb344361c3	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:b34e560c-16b5-4c65-b17e-1ddb344361c3:::	{grpc,grpcs,http,https}	\N
beab641f-8cad-48c8-9c21-bec52cf6cb8d	2021-03-06 10:49:54+00	key-auth	\N	\N	fd0e00de-49c5-4786-9479-39e2855a7a0f	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:fd0e00de-49c5-4786-9479-39e2855a7a0f:::	{grpc,grpcs,http,https}	\N
8dc2c9d9-166b-449b-b94e-36619805c030	2021-03-06 10:50:04+00	key-auth	\N	\N	a3b85b92-4808-4fd8-bed5-fc8754ba8b08	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:a3b85b92-4808-4fd8-bed5-fc8754ba8b08:::	{grpc,grpcs,http,https}	\N
5175240b-821b-4914-ad79-40e746fa9d11	2021-03-06 10:50:11+00	key-auth	\N	\N	8c2972d0-5e6a-44cb-a01b-c1c6d63f5823	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:8c2972d0-5e6a-44cb-a01b-c1c6d63f5823:::	{grpc,grpcs,http,https}	\N
770c7d2e-1262-4248-9108-d5fbbb04038d	2021-03-06 10:50:28+00	key-auth	\N	\N	a33e4f58-c4c7-413f-8c0e-ccd2c7ad35a7	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:a33e4f58-c4c7-413f-8c0e-ccd2c7ad35a7:::	{grpc,grpcs,http,https}	\N
ca146202-8669-46ed-ba80-430edc369740	2021-03-06 10:50:53+00	key-auth	\N	\N	07ff7564-2c40-4c01-9dad-d7a31a889a1e	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:07ff7564-2c40-4c01-9dad-d7a31a889a1e:::	{grpc,grpcs,http,https}	\N
f3b4f782-766a-47d9-9609-cef1dca811b9	2021-03-06 10:51:10+00	key-auth	\N	\N	e5e222cb-b0be-4f1f-8b8a-6814b030a582	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:e5e222cb-b0be-4f1f-8b8a-6814b030a582:::	{grpc,grpcs,http,https}	\N
39f7472c-08d1-4584-aedc-0eed01abfa56	2021-03-06 10:51:17+00	key-auth	\N	\N	9e7bd1df-753c-4707-8219-d8b02005cc57	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:9e7bd1df-753c-4707-8219-d8b02005cc57:::	{grpc,grpcs,http,https}	\N
b7c792a5-3f20-46a4-bc9f-4503cd3b9bdd	2021-03-06 10:51:42+00	key-auth	\N	\N	e342c705-0fcf-45f8-a307-6d5e4a2a0d71	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:e342c705-0fcf-45f8-a307-6d5e4a2a0d71:::	{grpc,grpcs,http,https}	\N
1c959e3c-6490-4318-9bff-da0d483f5e1b	2021-03-06 10:40:50+00	key-auth	\N	\N	d40e4990-7c0f-47f7-9bb7-ba0d06d781c6	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:d40e4990-7c0f-47f7-9bb7-ba0d06d781c6:::	{grpc,grpcs,http,https}	\N
ae57e6cc-7f7c-4723-b3fe-2b961cf2e32b	2021-03-06 10:51:57+00	key-auth	\N	\N	37394b46-5ae4-4e91-9461-761a7d4a3565	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:37394b46-5ae4-4e91-9461-761a7d4a3565:::	{grpc,grpcs,http,https}	\N
61d1bbd8-98f6-4a12-a59b-248bbcd20986	2021-03-06 10:52:28+00	key-auth	\N	\N	736a564c-2018-4e95-b924-68272043b6e8	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:736a564c-2018-4e95-b924-68272043b6e8:::	{grpc,grpcs,http,https}	\N
f5b9ca6e-93a1-47a8-bf6a-675ff4a1e130	2021-03-06 10:52:37+00	key-auth	\N	\N	c29756d6-3add-415c-9594-33e2a0198420	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:c29756d6-3add-415c-9594-33e2a0198420:::	{grpc,grpcs,http,https}	\N
420dcf51-b036-456d-86ad-969c1243c446	2021-03-15 09:54:37+00	key-auth	\N	\N	5df59105-b98b-46ef-8a43-1c5b9113ed43	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:5df59105-b98b-46ef-8a43-1c5b9113ed43:::	{grpc,grpcs,http,https}	\N
305045f7-853c-4eda-a772-d811027523ed	2021-03-15 09:51:37+00	key-auth	\N	\N	d1f3fc29-5bac-4b3c-86f7-e6c418c035c4	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:d1f3fc29-5bac-4b3c-86f7-e6c418c035c4:::	{grpc,grpcs,http,https}	\N
48e0ca0c-6951-4369-8c02-a3e16f40de03	2021-03-15 09:44:17+00	key-auth	\N	\N	6a100bd3-4eb3-4558-9782-72ddf534086a	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:6a100bd3-4eb3-4558-9782-72ddf534086a:::	{grpc,grpcs,http,https}	\N
605e0b95-5767-4024-b5de-dab9f650c0c2	2021-03-15 09:42:35+00	key-auth	\N	\N	fc5748fe-080f-4d8b-8390-b0ecece0719b	{"anonymous": null, "key_names": ["ApiKey"], "key_in_body": false, "hide_credentials": false, "run_on_preflight": true}	f	plugins:key-auth:fc5748fe-080f-4d8b-8390-b0ecece0719b:::	{grpc,grpcs,http,https}	\N
\.


--
-- Data for Name: ratelimiting_metrics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ratelimiting_metrics (identifier, period, period_date, service_id, route_id, value) FROM stdin;
\.


--
-- Data for Name: response_ratelimiting_metrics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.response_ratelimiting_metrics (identifier, period, period_date, service_id, route_id, value) FROM stdin;
\.


--
-- Data for Name: routes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.routes (id, created_at, updated_at, name, service_id, protocols, methods, hosts, paths, snis, sources, destinations, regex_priority, strip_path, preserve_host, tags, https_redirect_status_code, headers, path_handling) FROM stdin;
87730998-5e40-4243-b89c-fc5f471c93c8	2020-06-29 06:40:41+00	2020-06-29 06:40:41+00	registerUserAccountPost	35b290b9-b6f0-4d4e-b9a6-ff9f3c487ef7	{http,https}	{POST}	\N	{/register}	\N	\N	\N	0	t	f	\N	426	\N	v0
1961d491-3011-47c6-a6e5-1170fd821cc9	2020-06-29 07:00:52+00	2020-06-29 07:00:52+00	registerUserAccountWithOtpPost	a46ff74a-475d-42e8-b579-27a3573bc63b	{http,https}	{POST}	\N	{/register/otp}	\N	\N	\N	0	t	f	\N	426	\N	v0
bfaf9fc9-4f85-4202-b88e-2bcc14caa16b	2020-06-29 07:55:16+00	2020-06-29 07:55:16+00	changePasswordPost	5b98fe86-d73e-4d67-adc5-ed3b6878fbc9	{http,https}	{POST}	\N	{/user/changePassword}	\N	\N	\N	0	t	f	\N	426	\N	v0
d305cc7f-d115-4ed4-8542-5f197d7c7576	2020-06-29 07:59:43+00	2020-06-29 07:59:43+00	forgotPasswordPost	c7a60493-e77c-46ae-b248-e1bd01fda129	{http,https}	{POST}	\N	{/user/forgotPassword}	\N	\N	\N	0	t	f	\N	426	\N	v0
bbb4090f-1ed9-40cb-9a8e-a8d0549967ad	2020-06-29 08:04:48+00	2020-06-29 08:04:48+00	forgotPasswordOTPPost	276eda03-9455-47aa-875d-477bf8a0ff4a	{http,https}	{POST}	\N	{/user/forgotPassword/otp}	\N	\N	\N	0	t	f	\N	426	\N	v0
59482112-21ca-436f-b379-db9764a2e6b5	2020-06-29 08:07:28+00	2020-06-29 08:07:28+00	resetPasswordPost	d1e11db8-0fd0-4f54-8155-d2e122cdbdd9	{http,https}	{POST}	\N	{/user/resetPassword}	\N	\N	\N	0	t	f	\N	426	\N	v0
f0d1c3a7-a3b7-4830-91cd-b361dbb09f74	2020-06-29 08:10:50+00	2020-06-29 08:10:50+00	resetPasswordOtpPost	77a84e63-5da2-422b-8e3e-9d2d6e30bddb	{http,https}	{POST}	\N	{/user/resetPassword/otp}	\N	\N	\N	0	t	f	\N	426	\N	v0
cb297aff-1244-42b2-a883-16f507108043	2020-06-29 08:14:34+00	2020-06-29 08:14:34+00	uploadImagePost	12ed6475-f4d5-43f9-b9e6-6787e1b8488a	{http,https}	{POST}	\N	{/user/image}	\N	\N	\N	0	t	f	\N	426	\N	v0
81fd852a-f0cd-4f41-98e0-251a43dd72c6	2020-06-29 08:17:02+00	2020-06-29 08:17:02+00	uploadPhotoPost	9d65cf76-ae03-45d4-92d6-b46404165fea	{http,https}	{POST}	\N	{/user/photo}	\N	\N	\N	0	t	f	\N	426	\N	v0
ed3f7120-3418-4891-a7a4-b7efe2a244a6	2020-06-29 11:14:28+00	2020-06-29 11:14:28+00	confirmRegistrationGet	56b1ba46-331d-4acc-a973-a84bed5fe69e	{http,https}	{GET}	\N	{/registrationConfirm}	\N	\N	\N	0	t	f	\N	426	\N	v0
17fd7354-0562-4eed-ad90-447733a0a737	2020-06-29 11:31:14+00	2020-06-29 11:31:14+00	resendRegistrationConfirmationEmailOtpGet	2aba53d6-e9c2-4eae-9f54-94dae4cd4e12	{http,https}	{GET}	\N	{/resendRegistrationConfirmationEmail/otp}	\N	\N	\N	0	t	f	\N	426	\N	v0
ae4c53cc-b62a-4a7a-a03d-8f15110a5f24	2020-06-29 11:42:00+00	2020-06-29 11:42:00+00	resendRegistrationTokenGet	91a24a04-a26c-45a3-8052-fba7ff27a50d	{http,https}	{GET}	\N	{/resendRegistrationToken}	\N	\N	\N	0	t	f	\N	426	\N	v0
386b5f4d-c1d4-4c11-b109-964abda01891	2020-06-29 11:47:33+00	2020-06-29 11:47:33+00	emailExistsGet	99382b87-19f7-44ed-a4b9-e21575eb8814	{http,https}	{GET}	\N	{/user/exists}	\N	\N	\N	0	t	f	\N	426	\N	v0
cdae5238-2b64-4e78-a39a-1311ab3a263f	2020-06-29 11:51:55+00	2020-06-29 11:51:55+00	mobileExistsGet	65971dc3-5794-4050-bab6-222688d87315	{http,https}	{GET}	\N	{/user/mobile/exists}	\N	\N	\N	0	t	f	\N	426	\N	v0
d5dbd2d4-2a45-48e2-80e7-e1eed81f1e26	2020-06-29 12:12:34+00	2020-06-29 12:12:34+00	getUserProfileGet	37308d10-9349-40cf-a286-4eed655b01fc	{http,https}	{GET}	\N	{/user/profile}	\N	\N	\N	0	t	f	\N	426	\N	v0
3a236f22-d30b-4cb5-8ebb-b3a5cb3afac4	2020-06-29 12:17:05+00	2020-06-29 12:17:05+00	updatePut	6fc56953-210b-44bf-b7f4-19eb9e7072f3	{http,https}	{PUT}	\N	{/user/update}	\N	\N	\N	0	t	f	\N	426	\N	v0
693e3d10-60ea-4887-aa5d-b374b88c1912	2020-06-29 12:19:50+00	2020-06-29 12:19:50+00	getRolesGet	f497c4cb-b60f-424b-8aad-415e6d662f75	{http,https}	{GET}	\N	{/role}	\N	\N	\N	0	t	f	\N	426	\N	v0
f9bfd948-ff08-4085-8236-553c8f442b15	2020-06-29 12:22:41+00	2020-06-29 12:22:41+00	getUsersGet	1dbc16ea-7ff5-47e5-b41c-84b863f52727	{http,https}	{GET}	\N	{/admin/user/list}	\N	\N	\N	0	t	f	\N	426	\N	v0
c512a9d7-f457-450e-8d3a-f431b88a9bcf	2020-06-29 12:25:07+00	2020-06-29 12:25:07+00	validateGet	f5714c20-044c-4267-a04b-741bf08f830f	{http,https}	{GET}	\N	{/oauth/validate}	\N	\N	\N	0	t	f	\N	426	\N	v0
e7ea0f99-225a-4d30-a1b7-b55c46e12e3c	2020-06-29 12:26:59+00	2020-06-29 12:26:59+00	validateTokenGet	be78db07-50c3-4242-9e30-2df5cb6eac94	{http,https}	{GET}	\N	{/oauth/validateToken}	\N	\N	\N	0	t	f	\N	426	\N	v0
73700b3e-f99c-48cf-922d-5f48569a5302	2020-06-29 12:31:05+00	2020-06-29 12:31:05+00	verifyGet	b20e5e9e-09a8-4e2e-a62a-12c977e56330	{http,https}	{GET}	\N	{/oauth/verify}	\N	\N	\N	0	t	f	\N	426	\N	v0
fd6bce66-b762-4cfd-94ae-e5c62d304fec	2020-06-30 05:48:32+00	2020-06-30 05:48:32+00	reloadCacheGet	b85130a9-9a70-4192-a776-680bdbb2d67e	{http,https}	{GET}	\N	{/admin/cache/reload}	\N	\N	\N	0	t	f	\N	426	\N	v0
cdabbba8-e1bf-47f4-a3fc-3e63dd37b0a1	2020-06-30 05:52:42+00	2020-06-30 05:52:42+00	getUserProductsGet	c5684b61-8d17-44c6-9723-d2973ee6ef62	{http,https}	{GET}	\N	{/admin/user/products}	\N	\N	\N	0	t	f	\N	426	\N	v0
1a654b87-ae72-411c-aea9-d91bde01e88c	2020-06-30 06:04:04+00	2020-06-30 06:04:04+00	getNotificationsByUserGet	706b5485-1d72-4c67-85c1-8ef216f0e47e	{http,https}	{GET}	\N	{/notification}	\N	\N	\N	0	t	f	\N	426	\N	v0
741eb6a0-4bf5-4b7e-b645-35f0aed20ed9	2020-06-30 06:06:35+00	2020-06-30 06:06:35+00	findAllGet	8a1d27af-0310-4178-9782-65244aa6010c	{http,https}	{GET}	\N	{/plan}	\N	\N	\N	0	t	f	\N	426	\N	v0
02eff922-a350-44aa-8e91-60ff370bbabf	2020-06-30 06:10:02+00	2020-06-30 06:10:02+00	savePost	96a86d74-19c4-49a9-a959-bd3742ffbf81	{http,https}	{POST}	\N	{/plan}	\N	\N	\N	0	t	f	\N	426	\N	v0
967aec9d-d53a-4d76-9c16-f406f57bf246	2020-06-30 07:00:00+00	2020-06-30 07:00:00+00	activatePlanPost	8d203cfa-3768-49d9-b918-2079d01b6f59	{http,https}	{POST}	\N	{/plan/activate}	\N	\N	\N	0	t	f	\N	426	\N	v0
cc63dc5b-9756-42d7-8174-ff9b3f7d53e6	2020-06-30 07:02:51+00	2020-06-30 07:02:51+00	countGet	4f2bdb58-f34a-49a4-a34c-cc5c4b901041	{http,https}	{GET}	\N	{/plan/count}	\N	\N	\N	0	t	f	\N	426	\N	v0
c5a4b003-e3ae-416a-a54c-d425483f66c2	2020-06-30 07:05:29+00	2020-06-30 07:05:29+00	deactivatePlanPost	a7eee3f0-d3ab-4061-9657-16423c56bbcc	{http,https}	{POST}	\N	{/plan/deactivate}	\N	\N	\N	0	t	f	\N	426	\N	v0
29334c94-8e5d-47fc-927c-7f1cec0dd167	2020-06-30 07:14:32+00	2020-06-30 07:14:32+00	getPlanGet	55945d5b-a70c-4070-aca9-2a2108e7d724	{http,https}	{GET}	\N	{/plan/info}	\N	\N	\N	0	t	f	\N	426	\N	v0
74c01170-60ae-4b27-80d2-ea8cfa72da6b	2020-06-30 07:16:22+00	2020-06-30 07:16:22+00	listAllGet	542210c8-9501-4012-8c93-e7a27dc0ec86	{http,https}	{GET}	\N	{/plan/list}	\N	\N	\N	0	t	f	\N	426	\N	v0
351ef242-5a7c-4af1-b977-4483ce26c715	2020-07-14 12:01:19+00	2020-07-14 12:01:19+00	listJobGet	6b14fbf7-6119-4bfe-a338-eeb16a9420fc	{http,https}	{GET}	\N	{/job/list}	\N	\N	\N	0	t	f	\N	426	\N	v0
e3962c1a-516d-4e9f-8502-58367553316c	2020-06-30 07:20:02+00	2020-06-30 07:20:02+00	consumeObjectGet	bc2707ae-8e43-4ad0-b141-13f0bc0561c0	{http,https}	{GET}	\N	{/plan/object/consume}	\N	\N	\N	0	t	f	\N	426	\N	v0
ed654bc1-029c-4038-a6a6-0960e1904167	2020-06-30 07:22:17+00	2020-06-30 07:22:17+00	renewPlanPost	87bd6183-a978-4c74-91e9-edf789d2f8fa	{http,https}	{POST}	\N	{/plan/renew}	\N	\N	\N	0	t	f	\N	426	\N	v0
3befaaf1-d164-45a8-b558-03a26b3e62d3	2020-06-30 07:24:19+00	2020-06-30 07:24:19+00	setupProductPlanPost	c098e258-3d5e-4ee7-83aa-46d99d893fde	{http,https}	{POST}	\N	{/plan/setup}	\N	\N	\N	0	t	f	\N	426	\N	v0
b82d8791-fd99-48bf-a981-855c54f85882	2020-06-30 07:27:46+00	2020-06-30 07:27:46+00	upgradePlanPost	1ea2c568-0418-4b43-aadb-30dcc6bb37dd	{http,https}	{POST}	\N	{/plan/upgrade}	\N	\N	\N	0	t	f	\N	426	\N	v0
cf3a0062-da2a-4d0b-81ea-4fd5ab253db3	2020-06-30 07:38:51+00	2020-06-30 07:38:51+00	getUserPlanGet	a553dbda-5861-4657-a758-87aa1b7a3605	{http,https}	{GET}	\N	{/plan/userplan}	\N	\N	\N	0	t	f	\N	426	\N	v0
feb2f3c3-c60d-432d-93a9-0417618af531	2020-06-30 08:03:34+00	2020-06-30 08:03:34+00	addMemberPost	16047cda-e795-4693-9549-e7ec1e9ff693	{http,https}	{POST}	\N	{/user/addmember}	\N	\N	\N	0	t	f	\N	426	\N	v0
d1bad831-d89f-4992-b3d1-f47f39ec28f7	2020-06-30 08:06:45+00	2020-06-30 08:06:45+00	findOnePost	71bf3dce-d03c-4016-bc17-e57f13525816	{http,https}	{POST}	\N	{/user/findOne}	\N	\N	\N	0	t	f	\N	426	\N	v0
057bd030-a114-47ba-9bdd-bdff62545b58	2020-06-30 08:09:27+00	2020-06-30 08:09:27+00	getUserIdGet	837b9c78-e39d-436a-8474-282fb15d2692	{http,https}	{GET}	\N	{/user/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
63cdbe88-5621-4e71-9fa9-ce9b5603b691	2020-06-30 08:56:24+00	2020-06-30 08:56:24+00	initializePost	2e6ac026-a5a4-4a44-987f-200ae45197dd	{http,https}	{POST}	\N	{/user/initialize}	\N	\N	\N	0	t	f	\N	426	\N	v0
a62e7b20-0112-436c-8881-42d0ccd38a3c	2020-06-30 09:03:30+00	2020-06-30 09:03:30+00	registerPost	8dbbd9bd-0a38-4980-8838-e65f21e8c566	{http,https}	{POST}	\N	{/user/open/register}	\N	\N	\N	0	t	f	\N	426	\N	v0
65d74d14-095b-493d-9cb5-d06d1ffd9273	2020-06-30 09:07:01+00	2020-06-30 09:07:01+00	toggleRedirectPost	0e639aae-6c8a-49a6-a837-0e8b8a10cf6a	{http,https}	{POST}	\N	{/user/redirect/toggle}	\N	\N	\N	0	t	f	\N	426	\N	v0
122aadc7-3394-484b-b41c-b15f0b1f6446	2020-06-30 09:10:30+00	2020-06-30 09:10:30+00	consumeStoragePost	de08c75a-a7fe-4e25-aa72-060b4ab9f6bd	{http,https}	{POST}	\N	{/user/storage/consume}	\N	\N	\N	0	t	f	\N	426	\N	v0
9546ea29-91f9-4e2e-9b2c-ba5a5b04dde6	2020-07-01 10:33:34+00	2020-07-01 10:33:34+00	existsGet	3d7aa31d-3bd3-4a88-9a94-46e7c0fa0e11	{http,https}	{GET}	\N	{/plan/exists}	\N	\N	\N	0	t	f	\N	426	\N	v0
e5077917-ba51-423e-b49b-eacb0e90a059	2020-07-01 10:37:24+00	2020-07-01 10:37:24+00	plansByTypeGet	822dee51-c819-4862-9bc7-d34c0ba9cae3	{http,https}	{GET}	\N	{/plan/type}	\N	\N	\N	0	t	f	\N	426	\N	v0
441a496b-749b-41d6-9ca1-287a5aef2e60	2020-07-01 12:04:33+00	2020-07-01 12:04:33+00	findOnePlanGet	8d3c09cf-c960-46cd-bd2b-9990eac60e07	{http,https}	{GET}	\N	{/plan/multiple}	\N	\N	\N	0	t	f	\N	426	\N	v0
61231e8c-08fa-4cf5-a245-08f07294c91d	2020-07-01 12:15:08+00	2020-07-01 12:15:08+00	countUserGet	37439dd0-021e-48b9-a7b9-401dcace2cb1	{http,https}	{GET}	\N	{/user/count}	\N	\N	\N	0	t	f	\N	426	\N	v0
afc1e4e7-e275-4def-9670-191eca0bc3d3	2020-07-01 12:16:50+00	2020-07-01 12:16:50+00	existsUserGet	86ac5a6e-c7a9-456f-bccf-03ed8f866789	{http,https}	{GET}	\N	{/user/exists}	\N	\N	\N	0	t	f	\N	426	\N	v0
b8a95315-e510-471a-ac32-6432577c9b07	2020-07-01 12:18:32+00	2020-07-01 12:18:32+00	findOneUserGet	453b260a-ffe4-4b1b-ae20-fd8e510cddf9	{http,https}	{GET}	\N	{/user}	\N	\N	\N	0	t	f	\N	426	\N	v0
a2822658-ef93-446b-805c-6e905c2f5446	2020-07-01 12:19:53+00	2020-07-01 12:19:53+00	saveUserPost	9874c200-060c-4f2d-9691-c3058f9ecf38	{http,https}	{POST}	\N	{/user}	\N	\N	\N	0	t	f	\N	426	\N	v0
3278b5e8-9053-4963-bd52-88d573424287	2020-07-01 12:21:24+00	2020-07-01 12:21:24+00	findAllUserPost	cece5a89-51d4-434d-936b-f97bd6456971	{http,https}	{POST}	\N	{/user/search}	\N	\N	\N	0	t	f	\N	426	\N	v0
47852b35-3e95-4eba-8feb-21c55ac7e517	2020-07-01 12:22:49+00	2020-07-01 12:22:49+00	updateUserPut	aeeabdfd-2493-4767-a0fb-f10eed9e74a3	{http,https}	{PUT}	\N	{/user}	\N	\N	\N	0	t	f	\N	426	\N	v0
60f06c90-35a3-4d3e-b160-6fe7b199be84	2020-07-05 13:22:13+00	2020-07-05 13:22:13+00	loginPost	8b5ea1ac-9856-432f-8b8d-627c52993b25	{http,https}	{POST}	\N	{/oauth/login}	\N	\N	\N	0	t	f	\N	426	\N	v0
6c8984c8-f75a-4e7b-8fb6-0365d666c77f	2020-07-12 09:43:14+00	2020-07-12 09:43:14+00	getUserInfoGet	f199e1be-616b-4380-b119-9c24c4a66c36	{http,https}	{GET}	\N	{/user/info}	\N	\N	\N	0	t	f	\N	426	\N	v0
afb2540a-96d9-4977-b16e-541b2b323b39	2020-07-13 12:21:20+00	2020-07-13 12:21:20+00	resendRegistrationConfirmationEmailGet	b22199da-23b2-4673-84a8-b617a3faa256	{http,https}	{GET}	\N	{/resendRegistrationConfirmationEmail}	\N	\N	\N	0	t	f	\N	426	\N	v0
d40e4990-7c0f-47f7-9bb7-ba0d06d781c6	2020-07-14 10:50:03+00	2020-07-14 10:50:03+00	listByServicePost	588774bf-717a-4dca-bb19-597def4b91f3	{http,https}	{POST}	\N	{/job/list}	\N	\N	\N	0	t	f	\N	426	\N	v0
392bcebd-b148-4c22-b62e-667edd71a334	2020-07-13 12:35:37+00	2020-07-13 12:35:37+00	logoutGet	4b1ac0a2-77a8-4071-8639-2bc4997d22f9	{http,https}	{GET}	\N	{/oauth/logout}	\N	\N	\N	0	t	f	\N	426	\N	v0
ab26bfb3-8135-4264-8219-ef3cd79827d1	2020-07-14 10:41:03+00	2020-07-14 10:41:03+00	searchPost	dbc1debe-af7e-4ca7-a835-97179f401f7b	{http,https}	{POST}	\N	{/algorithm/search}	\N	\N	\N	0	t	f	\N	426	\N	v0
5a41151c-e291-41aa-a7a7-f805a003d797	2020-07-14 10:46:48+00	2020-07-14 10:46:48+00	restartPost	64cdb7aa-52f4-4b3e-b4bc-016a362c64fd	{http,https}	{POST}	\N	{/job/restart}	\N	\N	\N	0	t	f	\N	426	\N	v0
9437e3d2-800b-4f2c-a9f0-4d6adf02d770	2020-07-14 10:52:59+00	2020-07-14 10:52:59+00	outputPost	ee85e4f4-97bf-416b-87bf-2c8b9b774cfc	{http,https}	{POST}	\N	{/job/output}	\N	\N	\N	0	t	f	\N	426	\N	v0
a92a4540-1bf2-480f-ac33-e128eb3a4f27	2020-07-14 11:11:12+00	2020-07-14 11:11:12+00	generatePost	983870dd-f101-4939-9355-d13613237b99	{http,https}	{POST}	\N	{/code/generate}	\N	\N	\N	0	t	f	\N	426	\N	v0
84ce69fe-b381-49ac-a272-4d313be05bc4	2020-07-14 11:14:35+00	2020-07-14 11:14:35+00	streamPost	9a35d03c-ac39-4dcd-89c8-9cd078e0a3a2	{http,https}	{POST}	\N	{/stream}	\N	\N	\N	0	t	f	\N	426	\N	v0
2b6478c5-1e7d-4f82-9a9a-0e2ecf0d8981	2020-07-14 11:41:23+00	2020-07-14 11:41:23+00	findOneAlgGet	453e1704-5ec0-4c8b-b395-1f18c5bb81f5	{http,https}	{GET}	\N	{/algorithm/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
02ea84ec-d17f-4aa8-84d6-e62228b7b9ae	2020-07-14 11:46:40+00	2020-07-14 11:46:40+00	findOneAlgorithmPost	7223d19b-2ccf-42a9-825b-aeba8c1ca423	{http,https}	{POST}	\N	{/algorithm/findOne}	\N	\N	\N	0	t	f	\N	426	\N	v0
b33e198b-0414-4863-afa6-5806135fe5b6	2020-07-14 11:49:24+00	2020-07-14 11:49:24+00	findAllAlgorithmsGet	917a2e8a-6d13-4bb7-95b6-c54c8310f4c4	{http,https}	{GET}	\N	{/algorithm}	\N	\N	\N	0	t	f	\N	426	\N	v0
005bf2cc-2f0e-4ee2-bc7e-6f46af5c12bc	2020-07-14 12:03:06+00	2020-07-14 12:03:06+00	jobGet	42a1d77d-25bd-4687-a394-b47fb0924b07	{http,https}	{GET}	\N	{/job}	\N	\N	\N	0	t	f	\N	426	\N	v0
bedb2b5c-c56a-41a8-8a99-99f163715771	2020-07-14 12:05:45+00	2020-07-14 12:05:45+00	deleteDelete	f658da27-245c-400a-b010-77cff5e09d07	{http,https}	{DELETE}	\N	{/job/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
795565c4-1f6a-4ef3-a50c-6e3790c754e1	2020-07-14 12:11:57+00	2020-07-14 12:11:57+00	findOneLibGet	32c9cae8-7cdf-409c-a796-63ef4b041cc7	{http,https}	{GET}	\N	{/library/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
07784385-bba1-40c2-8ccb-9d61eace6a34	2020-07-14 12:13:38+00	2020-07-14 12:13:38+00	findOneLibraryPost	a1e39de1-02dc-4329-84b0-e3b147e00fb1	{http,https}	{POST}	\N	{/library/findOne}	\N	\N	\N	0	t	f	\N	426	\N	v0
04df1f37-1ddd-4ace-a36b-d24eedf2ba42	2020-07-14 12:15:25+00	2020-07-14 12:15:25+00	findAllLibrariesGet	dcbe4be7-9314-4d3a-8d4f-eeb1ed793fd5	{http,https}	{GET}	\N	{/library}	\N	\N	\N	0	t	f	\N	426	\N	v0
38a2b9ee-d711-41ca-9e23-8a239ec6edcf	2020-07-14 12:26:47+00	2020-07-14 12:26:47+00	listStreamGet	e0aa07fd-017e-4d51-bdc1-fc3c50d94266	{http,https}	{GET}	\N	{/stream/list}	\N	\N	\N	0	t	f	\N	426	\N	v0
9b274922-4917-4b04-a347-73182e171e0f	2020-07-14 12:28:44+00	2020-07-14 12:28:44+00	saveOutputPost	c4f046ec-a14f-4ad0-9a19-253b4454eac9	{http,https}	{POST}	\N	{/output}	\N	\N	\N	0	t	f	\N	426	\N	v0
03f3458e-6148-4284-a96b-7a95cf1f7cca	2020-07-14 13:54:52+00	2020-07-14 13:54:52+00	createAppPost	9e19c63e-c898-4978-9351-d5e1626c6ddb	{http,https}	{POST}	\N	{/app/create/}	\N	\N	\N	0	t	f	\N	426	\N	v0
8ae90a7e-382f-4e06-adf6-39d7b0b4f479	2020-07-14 13:56:43+00	2020-07-14 13:56:43+00	getAppByUserGet	74076f2a-353d-4559-88e8-54de7fc83913	{http,https}	{GET}	\N	{/app/search/}	\N	\N	\N	0	t	f	\N	426	\N	v0
a7498c97-e10d-4279-b11a-af4123fa0906	2020-07-14 13:58:55+00	2020-07-14 13:58:55+00	generateApiKeyPut	3357319e-93f0-4214-a061-4ad975ace856	{http,https}	{PUT}	\N	{/app/generateApiKey/}	\N	\N	\N	0	t	f	\N	426	\N	v0
9afd54d4-ee71-48d0-8b63-7ab949f47d4c	2020-07-14 14:00:40+00	2020-07-14 14:00:40+00	appInfoGet	59a267b3-bbf8-48ee-ae7e-d54ed7d0482e	{http,https}	{GET}	\N	{/app/appInfo/}	\N	\N	\N	0	t	f	\N	426	\N	v0
5a145216-ae7d-4a9b-9f55-e5c31d17e499	2020-07-14 14:03:39+00	2020-07-14 14:03:39+00	getAppGet	4408b784-2f48-4deb-a5ab-448e8567706f	{http,https}	{GET}	\N	{/app/appId/}	\N	\N	\N	0	t	f	\N	426	\N	v0
1659f4ac-07c3-4f81-a036-c1466e43da27	2020-07-14 15:39:08+00	2020-07-14 15:39:08+00	fetchLabelsGet	aebe5bf2-a10c-4515-b8a8-18824fc0761b	{http,https}	{GET}	\N	{/stream/fetch}	\N	\N	\N	0	t	f	\N	426	\N	v0
7ac21ee3-58f2-4a46-bbe0-967409c1cec0	2020-07-14 15:42:21+00	2020-07-14 15:42:21+00	stopStreamPost	6016663d-1d02-495d-8c35-34b52d67bed1	{http,https}	{POST}	\N	{/stream/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
32fd9bf1-e682-4484-9f51-4939b7257a9b	2020-07-14 17:58:38+00	2020-07-14 17:58:38+00	uploadPublicFilePost	d44cea9f-dd83-45c4-8042-e64dcf7e6116	{http,https}	{POST}	\N	{/s3/file/public}	\N	\N	\N	0	t	f	\N	426	\N	v0
f8cd840e-e7e8-4673-835e-50596a3303c9	2020-07-14 17:59:58+00	2020-07-14 17:59:58+00	uploadFilePost	156fae24-1427-4928-8173-a10e75b93560	{http,https}	{POST}	\N	{/s3/file}	\N	\N	\N	0	t	f	\N	426	\N	v0
9d8bc293-1222-4b0f-9155-5ff415595833	2020-07-14 18:01:23+00	2020-07-14 18:01:23+00	uploadFolderPost	081dc620-4fc1-429f-a085-e93f95f51ff1	{http,https}	{POST}	\N	{/s3/folder}	\N	\N	\N	0	t	f	\N	426	\N	v0
7e0498d5-32e0-4bd1-a6a5-15afb823f4d2	2020-07-14 18:04:25+00	2020-07-14 18:04:25+00	replaceFilePut	a52b19ba-f012-4086-b021-487ac539d8b1	{http,https}	{PUT}	\N	{/s3/file}	\N	\N	\N	0	t	f	\N	426	\N	v0
986a7a04-dfd6-4440-b0e2-54e34ad6283d	2020-07-14 18:06:20+00	2020-07-14 18:06:20+00	createBucketPost	e6bd078d-a4d8-4403-98fa-16f705b5caec	{http,https}	{POST}	\N	{/s3/bucket}	\N	\N	\N	0	t	f	\N	426	\N	v0
0bc4d144-aa1d-455d-ae22-c4a61ea053f3	2020-07-14 18:07:47+00	2020-07-14 18:07:47+00	deletePublicFileDelete	56dcf814-d8d4-4e9f-9d99-beba9531c73c	{http,https}	{DELETE}	\N	{/s3/file/public/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
0a50929a-afff-4cfd-841e-ee3cafb9bb76	2020-07-14 18:14:08+00	2020-07-14 18:14:08+00	deleteFileByIdDelete	db5dc0f6-7d1e-44c7-b98b-27a56a31be29	{http,https}	{DELETE}	\N	{/s3/file/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
5e2afce0-e599-41c4-a2e7-f924846d2a3f	2020-07-14 18:15:13+00	2020-07-14 18:15:13+00	deleteFileDelete	7fba6d72-6a14-40cb-a1f7-eba78ce7a21e	{http,https}	{DELETE}	\N	{/s3/file}	\N	\N	\N	0	t	f	\N	426	\N	v0
e04dd491-224c-4799-96be-1d0e3076ea42	2020-07-14 18:16:37+00	2020-07-14 18:16:37+00	deleteBucketDelete	7e99a7f8-032d-49fb-bae7-c1ff126fe591	{http,https}	{DELETE}	\N	{/s3/bucket}	\N	\N	\N	0	t	f	\N	426	\N	v0
5e031a6f-3854-4bc2-bc4d-6f430d3ffa72	2020-07-14 18:18:38+00	2020-07-14 18:18:38+00	listFilesGet	4a36094a-48b3-46ce-82b6-87d0b90ee90a	{http,https}	{GET}	\N	{/s3/list}	\N	\N	\N	0	t	f	\N	426	\N	v0
b3b4b26f-a881-4845-86bd-9107a4aa5aef	2020-07-14 18:21:29+00	2020-07-14 18:21:29+00	downloadFileGet	88094b35-4203-4895-a6f0-b31d015c7b7b	{http,https}	{GET}	\N	{/s3/file/download}	\N	\N	\N	0	t	f	\N	426	\N	v0
c1763e07-fbdc-48ee-ab4d-8c5b92b7171c	2020-07-14 18:23:11+00	2020-07-14 18:23:11+00	downloadFileByIdGet	5931713d-58fe-4dbb-a2a7-a3b8f5dbb354	{http,https}	{GET}	\N	{/s3/file/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
525e20ba-df0d-4dd2-887d-00813b4793cb	2020-07-14 18:24:35+00	2020-07-14 18:24:35+00	findByIdGet	5594c8ff-ed54-4b3a-8c32-8fb29d8258d1	{http,https}	{GET}	\N	{/s3/find/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
0683e2a3-f1c2-4ed7-ae6b-517504519ad2	2020-07-14 18:25:43+00	2020-07-14 18:25:43+00	findGet	48aa4a23-c0e1-4b0b-a4c3-ab6befcaa136	{http,https}	{GET}	\N	{/s3/find}	\N	\N	\N	0	t	f	\N	426	\N	v0
49877431-4cbe-4ad5-bc79-94eaf6cbc4a1	2020-07-16 09:51:51+00	2020-07-16 09:51:51+00	machineClassificationTrainPost	8d777dca-d6b0-469c-b7dd-222559a97fb2	{http,https}	{POST}	\N	{/machine/classification/train}	\N	\N	\N	0	t	f	\N	426	\N	v0
147d4143-f710-4a81-8624-f8cbc5ce9981	2020-07-16 09:54:31+00	2020-07-16 09:54:31+00	machineRegressionTrainPost	e9023de7-0ead-4871-821a-e30dc1054f3f	{http,https}	{POST}	\N	{/machine/regression/train}	\N	\N	\N	0	t	f	\N	426	\N	v0
08df3e0a-7123-4b9b-8277-4f78759b85c0	2020-07-16 10:01:32+00	2020-07-16 10:01:32+00	machineRegressionPredictPost	d276334c-fd0f-4223-9ff3-064be25dcec6	{http,https}	{POST}	\N	{/machine/regression/predict}	\N	\N	\N	0	t	f	\N	426	\N	v0
334b4e04-b58f-44bd-b022-17090ab766e8	2020-07-15 16:09:58+00	2020-07-15 16:09:58+00	coreNerPost	2cbd5d01-0046-47c9-b211-29c378d59a9b	{http,https}	{POST}	\N	{/core/nlp/ner}	\N	\N	\N	0	t	f	\N	426	\N	v0
38e89493-7448-49e0-8d08-1c2ee333f61c	2020-07-15 16:10:28+00	2020-07-15 16:10:28+00	corePosPost	24862641-5f35-4a4d-8fe3-c3574fd36a87	{http,https}	{POST}	\N	{/core/nlp/pos}	\N	\N	\N	0	t	f	\N	426	\N	v0
0d433130-99ad-4f89-9e4f-ba50d5fe8b55	2020-07-15 16:15:10+00	2020-07-15 16:15:10+00	coreSentimentPost	d86f0a45-7d15-444c-8cff-d76c2493436e	{http,https}	{POST}	\N	{/core/nlp/sentiment/}	\N	\N	\N	0	t	f	\N	426	\N	v0
79ae2040-876f-44b7-ab60-5cfb16acf29a	2020-07-15 16:16:21+00	2020-07-15 16:16:21+00	coreTagsPost	005fc05f-ba9d-4c18-9232-ca78ef46ffc1	{http,https}	{POST}	\N	{/core/nlp/tags/}	\N	\N	\N	0	t	f	\N	426	\N	v0
ba13f6e8-0a4f-44de-b9e2-29e75a041462	2020-07-16 10:04:16+00	2020-07-16 10:04:16+00	machineRegressionFeedbackPost	74eb02de-d987-4e45-8e69-2d4e31bbe5c0	{http,https}	{POST}	\N	{/machine/regression/feedback}	\N	\N	\N	0	t	f	\N	426	\N	v0
a9719902-358a-4735-9297-a07476386086	2020-07-16 10:07:20+00	2020-07-16 10:07:20+00	machineClassificationFeedbackPost	57192cb1-aa11-4c7f-8329-fe381159e1ff	{http,https}	{POST}	\N	{/machine/classification/feedback}	\N	\N	\N	0	t	f	\N	426	\N	v0
b34e560c-16b5-4c65-b17e-1ddb344361c3	2020-07-16 10:08:46+00	2020-07-16 10:08:46+00	machineClassificationPredictPost	96b3ff76-85da-47f8-8d9a-2e53f4bdde82	{http,https}	{POST}	\N	{/machine/classification/predict}	\N	\N	\N	0	t	f	\N	426	\N	v0
e7894d9f-a24e-493c-aa30-ddd667c818d9	2020-07-16 10:30:56+00	2020-07-16 10:30:56+00	machineFindByJobIdGet	8cebc9ed-a48c-413a-bcad-84aaecb06d47	{http,https}	{GET}	\N	{/machine/output/findBy}	\N	\N	\N	0	t	f	\N	426	\N	v0
58456fe3-3368-4ed9-80c6-dabeca36f115	2020-07-16 10:31:20+00	2020-07-16 10:31:20+00	machineOutputJobGet	6ffae089-4485-4497-bf31-18d4490823f8	{http,https}	{GET}	\N	{/machine/job/status}	\N	\N	\N	0	t	f	\N	426	\N	v0
fd0e00de-49c5-4786-9479-39e2855a7a0f	2020-07-17 09:52:20+00	2020-07-17 09:52:20+00	machineClusterPost	62a25b04-9768-40c5-a77f-d9e6ecabeae5	{http,https}	{POST}	\N	{/machine/cluster}	\N	\N	\N	0	t	f	\N	426	\N	v0
a3b85b92-4808-4fd8-bed5-fc8754ba8b08	2020-08-05 07:18:33+00	2020-08-05 07:18:33+00	coreSarcasmDetectionPost	b4a37250-3786-414c-a1b6-7c2686f840f0	{http,https}	{POST}	\N	{/nlp/sarcasm_detection/}	\N	\N	\N	0	t	f	\N	426	\N	v0
8c2972d0-5e6a-44cb-a01b-c1c6d63f5823	2020-08-05 07:19:02+00	2020-08-05 07:19:02+00	coreTagsRecommenderPost	3e46662e-e69a-4ada-9a02-3743a569f378	{http,https}	{POST}	\N	{/nlp/tags_recommender/}	\N	\N	\N	0	t	f	\N	426	\N	v0
02bca5be-184f-4ee2-9e6f-87bc4b1d6077	2020-10-04 13:52:49+00	2020-10-04 13:52:49+00	findAllCategoryGet	d5e18fe6-06c7-4cfd-b982-2ccf9c7ea541	{http,https}	{GET}	\N	{/category}	\N	\N	\N	0	t	f	\N	426	\N	v0
e6369528-c51c-460d-b727-fec687e64aa8	2020-10-04 13:54:02+00	2020-10-04 13:54:02+00	countCategoryGet	78c26cf4-6e69-4a84-baea-31a16e8c7615	{http,https}	{GET}	\N	{/category/count}	\N	\N	\N	0	t	f	\N	426	\N	v0
6bbeadf1-5a3f-46c8-aa76-b3d032f837fd	2020-10-04 13:59:48+00	2020-10-04 13:59:48+00	categoryFindOnePost	5bad9e58-836f-43e0-9f62-1727e6f47175	{http,https}	{POST}	\N	{/category/findOne}	\N	\N	\N	0	t	f	\N	426	\N	v0
0982e095-65ae-4287-9591-ac35dc6f15fa	2020-10-04 14:00:57+00	2020-10-04 14:00:57+00	categoryFindAllPost	45c1b1bb-2c8b-4948-9021-cf875caab983	{http,https}	{POST}	\N	{/category/search}	\N	\N	\N	0	t	f	\N	426	\N	v0
4803e414-98b4-458d-8fe0-ff8ad53ea90a	2020-10-04 14:29:34+00	2020-10-04 14:29:34+00	findAllProductGet	59e52edd-9edd-4670-a829-146355019f78	{http,https}	{GET}	\N	{/product}	\N	\N	\N	0	t	f	\N	426	\N	v0
904b5bbf-cdfa-4e9e-b49c-d22ee3d018f9	2020-10-04 14:30:36+00	2020-10-04 14:30:36+00	countProductGet	e7072395-184f-41fe-96d6-1adf31af26a0	{http,https}	{GET}	\N	{/product/count}	\N	\N	\N	0	t	f	\N	426	\N	v0
c9ad7b54-af23-4f48-ac31-4d9eff03a75f	2020-10-04 14:49:08+00	2020-10-04 14:49:08+00	subscribePost	fc30cce7-d4a7-4b99-ae48-6f7560f1e381	{http,https}	{POST}	\N	{/subscribe}	\N	\N	\N	0	t	f	\N	426	\N	v0
e4b139d5-9de4-44e5-8dcd-0bd086c34116	2020-10-04 14:55:21+00	2020-10-04 14:55:21+00	initializeUserPost	7a89e5d4-4deb-40b3-81d1-a51010a7704a	{http,https}	{POST}	\N	{/user/profile/initialize}	\N	\N	\N	0	t	f	\N	426	\N	v0
1b037f6c-dd5e-45f5-bebe-6135a4fecec4	2020-10-04 14:59:03+00	2020-10-04 14:59:03+00	findAllSubscribeGet	3feb0a4a-84bf-4533-b06f-024913b74967	{http,https}	{GET}	\N	{/subscribe}	\N	\N	\N	0	t	f	\N	426	\N	v0
b48fa915-7c45-418b-b912-d8f570742df5	2020-10-04 14:59:58+00	2020-10-04 14:59:58+00	countSubscribeGet	7b9f52fe-3a25-4e5e-9456-d324f5bb166e	{http,https}	{GET}	\N	{/subscribe/count}	\N	\N	\N	0	t	f	\N	426	\N	v0
86499542-d847-4306-b71c-675a1e7018b9	2020-10-04 15:03:49+00	2020-10-04 15:03:49+00	userGetUserProfileGet	ea6c26a9-d857-4487-85fa-4624c067ba7b	{http,https}	{GET}	\N	{/user/profile/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
2d0e5ac0-3ef1-452a-9b94-ab228fb421ee	2020-10-04 15:04:59+00	2020-10-04 15:04:59+00	userDeleteUserProfileGet	6083eea3-6152-4cc3-b740-56ccc669426d	{http,https}	{GET}	\N	{/user/profile/remove}	\N	\N	\N	0	t	f	\N	426	\N	v0
7c114bd8-c398-4065-9429-1fecb6711a02	2020-10-05 05:14:22+00	2020-10-05 05:14:22+00	existsCategoryGet	23c34501-c25c-47dc-a550-56ef8657f9ae	{http,https}	{GET}	\N	{/category/exists/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
7e2fe9af-58ca-438f-b207-48f28898a715	2020-10-05 05:15:45+00	2020-10-05 05:15:45+00	findOneCategoryGet	734b4e70-df97-41ee-b708-a4af837d5bb8	{http,https}	{GET}	\N	{/category/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
316fc6f2-18bc-465f-b1d7-e40cf45e79eb	2020-10-05 05:27:18+00	2020-10-05 05:27:18+00	existsProductGet	99bfead2-7174-4414-82fb-39f88eda6d76	{http,https}	{GET}	\N	{/product/exists/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
6c4bb74a-9da1-4d19-8bbe-d53955e3b401	2020-10-05 05:29:01+00	2020-10-05 05:29:01+00	findOneByNameProductGet	348bcc07-7be8-455e-b7cf-6a2414b290b1	{http,https}	{GET}	\N	{/product/name}	\N	\N	\N	0	t	f	\N	426	\N	v0
a1107b97-3064-4d04-93c6-e64fd6cb6de8	2020-10-05 05:32:06+00	2020-10-05 05:32:06+00	findOneProductGet	3bb02ec3-b945-47d7-b2c9-845298a1519b	{http,https}	{GET}	\N	{/product/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
3218bc95-0859-499c-b602-bc1321b49a26	2020-10-05 05:36:39+00	2020-10-05 05:36:39+00	existsSubscribeGet	a155b3bc-0f89-4083-8a9c-79f9d8b5f518	{http,https}	{GET}	\N	{/subscribe/exists/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
eaf39de7-68bd-4c07-92c7-713d46797e88	2020-10-05 05:37:52+00	2020-10-05 05:37:52+00	findOneSubscribeGet	6d642b09-2d72-49e2-a28d-9e2bb41be40c	{http,https}	{GET}	\N	{/subscribe/id}	\N	\N	\N	0	t	f	\N	426	\N	v0
a33e4f58-c4c7-413f-8c0e-ccd2c7ad35a7	2020-10-20 12:52:42+00	2020-10-20 12:52:42+00	topicModelingPost	4b01c784-f169-4d02-b981-6fdf39d4d54e	{http,https}	{POST}	\N	{/core/nlp/topic_modeling/}	\N	\N	\N	0	t	f	\N	426	\N	v0
376d34f5-14c0-4099-b84d-8a8100fd862d	2020-11-19 12:41:38+00	2020-11-19 12:41:38+00	getDataSourcequeriesPost	733c3d90-57fb-451a-8725-61f756a1ed85	{http,https}	{POST}	\N	{/datasource/queries}	\N	\N	\N	0	t	f	\N	426	\N	v0
cb8a87a4-93b6-4462-9317-4f4e167572d0	2020-11-19 12:43:29+00	2020-11-19 12:43:29+00	getDataSourcequeryColumnsPost	e9f68e8c-64d6-47f8-9c6c-fceae1a8fd4f	{http,https}	{POST}	\N	{/datasource/query/columns}	\N	\N	\N	0	t	f	\N	426	\N	v0
a55e968e-a9f3-44a3-be81-766ea1ef091f	2020-11-19 12:45:26+00	2020-11-19 12:45:26+00	addDatabasePost	618051d1-d8f1-4ae4-9bbf-8150b3655dec	{http,https}	{POST}	\N	{/datasource/add}	\N	\N	\N	0	t	f	\N	426	\N	v0
0a3fc261-1a18-437b-8587-bce5843fa943	2020-11-19 12:47:15+00	2020-11-19 12:47:15+00	getDatabasesPaginatedPost	eaa3efd9-b93c-476a-b402-b469d73809bb	{http,https}	{GET}	\N	{/datasource/page}	\N	\N	\N	0	t	f	\N	426	\N	v0
49e404dd-79f0-4d15-a34d-4386b38c3154	2020-11-19 12:48:13+00	2020-11-19 12:48:13+00	deleteDatabase	d489e4fb-3757-41c9-bbee-4a9c4b90d776	{http,https}	{DELETE}	\N	{/datasource}	\N	\N	\N	0	t	f	\N	426	\N	v0
07ff7564-2c40-4c01-9dad-d7a31a889a1e	2020-12-08 18:11:22+00	2020-12-08 18:11:22+00	getPredictionWebhookGet	0a366b5d-fa66-449b-99a0-d691c20ad49e	{http,https}	{GET}	\N	{/machine/datasource/webhook}	\N	\N	\N	0	t	f	\N	426	\N	v0
92c51093-b8c1-4dbc-9174-1d3677e6c54b	2020-12-11 16:35:22+00	2020-12-11 16:35:22+00	updateOrganizationPost	5207ca60-304d-4d4e-9372-013b216e92ae	{http,https}	{POST}	\N	{/user/organization}	\N	\N	\N	0	t	f	\N	426	\N	v0
135409c8-6bd5-4daf-8699-73fd1689efd4	2020-12-11 16:37:21+00	2020-12-11 16:37:21+00	updateEducationPost	8a5c4ca0-72f9-4626-8400-8951ce461e1d	{http,https}	{POST}	\N	{/user/education}	\N	\N	\N	0	t	f	\N	426	\N	v0
8b87ebb8-4a2b-4666-b416-e79fb123a508	2020-12-18 11:54:55+00	2020-12-18 11:54:55+00	appAnalyticsGet	6155a856-6b2a-407e-b4e1-92475f99b0b5	{http,https}	{GET}	\N	{/user/analytics}	\N	\N	\N	0	t	f	\N	426	\N	v0
1d3315d0-1704-4d6b-9168-8bbb8d86d16b	2020-12-23 08:31:01+00	2020-12-23 08:31:01+00	predictWebhookByModelGet	dc6c0afb-0b20-4f36-8d87-fe77c3015016	{http,https}	{GET}	\N	{/machine/datasource/webhookbymodel}	\N	\N	\N	0	t	f	\N	426	\N	v0
e5e222cb-b0be-4f1f-8b8a-6814b030a582	2020-12-31 08:22:19+00	2020-12-31 08:22:19+00	postTimeseriesPost	339fd24f-e6a4-4dea-807b-f0c9d81ca4bd	{http,https}	{POST}	\N	{/machine/timeseries/train}	\N	\N	\N	0	t	f	\N	426	\N	v0
9e7bd1df-753c-4707-8219-d8b02005cc57	2021-01-05 10:30:56+00	2021-01-05 10:30:56+00	postTimeseriesPredictPost	6d65b1e0-4979-4294-ac69-7df102e9f3c2	{http,https}	{POST}	\N	{/machine/timeseries/predict}	\N	\N	\N	0	t	f	\N	426	\N	v0
e342c705-0fcf-45f8-a307-6d5e4a2a0d71	2021-01-18 06:08:31+00	2021-01-18 06:08:31+00	cv2ObjectDetectionPost	988f7599-12c7-47d5-a8a4-ced457f34de3	{http,https}	{POST}	\N	{/computer_vision/object_detection/}	\N	\N	\N	0	t	f	\N	426	\N	v0
ac3208d8-844a-478b-83e3-795bf4a024d8	2021-01-18 06:17:02+00	2021-01-18 06:17:02+00	cv2TaskStatusGet	a3b38a13-6711-46b9-b690-7fe2cb677410	{http,https}	{GET}	\N	{/computer_vision/task}	\N	\N	\N	0	t	f	\N	426	\N	v0
37394b46-5ae4-4e91-9461-761a7d4a3565	2021-01-18 05:56:51+00	2021-01-18 05:56:51+00	cv2ImageClassificationPost	d4613397-2acd-42b6-ab06-2ca7c133424f	{http,https}	{POST}	\N	{/computer_vision/image_classification}	\N	\N	\N	0	t	f	\N	426	\N	v0
140af34f-e788-432b-9524-5b633b323527	2021-01-19 07:52:17+00	2021-01-19 07:52:17+00	getFilesListByPaginationGet	a9fc09a8-e358-4da8-b8b7-ff025e74c2d2	{http,https}	{GET}	\N	{/s3/list/page}	\N	\N	\N	0	t	f	\N	426	\N	v0
873f7ce0-b333-40d2-88bb-6b310dce758b	2021-01-19 07:54:35+00	2021-01-19 07:54:35+00	getFilesByNameGet	a5a78b6b-f7e9-4666-ae00-6d8df5835965	{http,https}	{GET}	\N	{/s3/search}	\N	\N	\N	0	t	f	\N	426	\N	v0
9c356039-7fd9-4697-ab52-2b7e9c60f8ff	2021-01-21 06:42:43+00	2021-01-21 06:42:43+00	coreuploadFilesPost	1c47c499-15e1-48ca-ba17-124557c29a49	{http,https}	{POST}	\N	{/s3/file/public/multiple}	\N	\N	\N	0	t	f	\N	426	\N	v0
df00fb9c-f89f-465d-ad02-dde7aa2bfc0a	2021-01-21 13:12:14+00	2021-01-21 13:12:14+00	getFilesCountForUserGet	1205f552-2df6-463d-a8a6-87f6af488bbb	{http,https}	{GET}	\N	{/s3/file/count}	\N	\N	\N	0	t	f	\N	426	\N	v0
a0e19bae-3197-4948-a009-bcd8d6842785	2021-01-22 08:01:32+00	2021-01-22 08:01:32+00	automatePredictJobPost	51785cf2-7ea9-401a-9c87-d9d9e3b9bcd6	{http,https}	{POST}	\N	{/machine/automate/job/predict/start}	\N	\N	\N	0	t	f	\N	426	\N	v0
a285237e-274a-45f5-964c-93f35414de5a	2021-01-22 08:03:56+00	2021-01-22 08:03:56+00	getAutomatePredictJobsGet	ba230d72-83d5-4a08-bdc6-d65f641f8564	{http,https}	{GET}	\N	{/machine/automate/job/predict/list}	\N	\N	\N	0	t	f	\N	426	\N	v0
8d7810d7-fe86-4ab5-88fc-d6203ae97e32	2021-01-22 08:06:00+00	2021-01-22 08:06:00+00	stopAutomatePredictJobPost	17153a5e-9192-4636-a21e-3ac658e41833	{http,https}	{POST}	\N	{/machine/automate/job/predict/stop}	\N	\N	\N	0	t	f	\N	426	\N	v0
25a130da-2189-4e6b-9e5e-74d756c07546	2021-01-22 08:08:10+00	2021-01-22 08:08:10+00	restartAutomatePredictJobPost	63d7c874-40c0-47ba-99f5-b7b2133380e4	{http,https}	{POST}	\N	{/machine/automate/job/predict/restart}	\N	\N	\N	0	t	f	\N	426	\N	v0
de529809-1466-4ebb-bc70-36113ceae7a9	2021-01-22 08:09:43+00	2021-01-22 08:09:43+00	deleteAutomatePredictJobDelete	8000ccd8-5222-406f-b8bd-43c8811bbd85	{http,https}	{DELETE}	\N	{/machine/automate/job/predict/delete}	\N	\N	\N	0	t	f	\N	426	\N	v0
e1768a05-df74-4a2b-8839-3e5192c2a91d	2021-01-22 08:11:08+00	2021-01-22 08:11:08+00	webhookAutomatePredictJobGet	06cc2105-b4fa-4ea5-b2fc-645f6028bb6c	{http,https}	{GET}	\N	{/machine/automate/job/predict/webhook}	\N	\N	\N	0	t	f	\N	426	\N	v0
736a564c-2018-4e95-b924-68272043b6e8	2021-01-28 10:52:35+00	2021-01-28 10:52:35+00	cv2FaceAnalyticsPost	507fad51-b02b-4b17-8bdc-e7a2ca00f356	{http,https}	{POST}	\N	{/computer_vision/face_analytics/}	\N	\N	\N	0	t	f	\N	426	\N	v0
c29756d6-3add-415c-9594-33e2a0198420	2021-01-28 10:53:11+00	2021-01-28 10:53:11+00	cv2GetTaskGet	30399845-676b-468a-8288-60ef730305cd	{http,https}	{GET}	\N	{/computer_vision/task/}	\N	\N	\N	0	t	f	\N	426	\N	v0
0d03d838-cf0d-4835-bfe7-4706ad4201f7	2021-02-11 11:52:25+00	2021-02-11 11:52:25+00	getMarketPlaceAppGet	256169d1-8c25-4cad-856c-b2d67f93126f	{http,https}	{GET}	\N	{/app/mpApp}	\N	\N	\N	0	t	f	\N	426	\N	v0
fc5748fe-080f-4d8b-8390-b0ecece0719b	2021-03-15 09:40:40+00	2021-03-15 09:40:40+00	posWithoutComparePost	16c478ee-3fbe-4160-b8c5-8b9a148bcec9	{http,https}	{POST}	\N	{/core/nlp/pos/compare}	\N	\N	\N	0	t	f	\N	426	\N	v0
6a100bd3-4eb3-4558-9782-72ddf534086a	2021-03-15 09:44:02+00	2021-03-15 09:44:02+00	nerWithoutComparePost	7026cdfe-1b78-47c4-8df2-15fabab122b0	{http,https}	{POST}	\N	{/core/nlp/ner/compare}	\N	\N	\N	0	t	f	\N	426	\N	v0
85f7f517-4278-4287-b5d1-f95084b73d27	2020-07-15 16:11:32+00	2020-07-15 16:11:32+00	coreDependencyParserPost	46767707-a19e-472d-a799-cc5287096f3d	{http,https}	{POST}	\N	{/core/nlp/dependency-parser/}	\N	\N	\N	0	t	f	\N	426	\N	v0
d1f3fc29-5bac-4b3c-86f7-e6c418c035c4	2021-03-15 09:51:23+00	2021-03-15 09:51:23+00	sentimentWithoutComparePost	36f7c31e-cfb2-4ac9-a1d5-8586b0b5fdac	{http,https}	{POST}	\N	{/core/nlp/sentiment/compare}	\N	\N	\N	0	t	f	\N	426	\N	v0
5df59105-b98b-46ef-8a43-1c5b9113ed43	2021-03-15 09:54:24+00	2021-03-15 09:54:24+00	tagsWithoutComparePost	fcf23856-9041-4fd9-a6df-f41cdff3103d	{http,https}	{POST}	\N	{/core/nlp/tags/compare}	\N	\N	\N	0	t	f	\N	426	\N	v0
\.


--
-- Data for Name: schema_meta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_meta (key, subsystem, last_executed, executed, pending) FROM stdin;
schema_meta	core	008_150_to_200	{000_base,003_100_to_110,004_110_to_120,005_120_to_130,006_130_to_140,007_140_to_150,008_150_to_200}	{}
schema_meta	hmac-auth	002_130_to_140	{000_base_hmac_auth,002_130_to_140}	\N
schema_meta	oauth2	003_130_to_140	{000_base_oauth2,003_130_to_140}	\N
schema_meta	jwt	002_130_to_140	{000_base_jwt,002_130_to_140}	\N
schema_meta	basic-auth	002_130_to_140	{000_base_basic_auth,002_130_to_140}	\N
schema_meta	key-auth	002_130_to_140	{000_base_key_auth,002_130_to_140}	\N
schema_meta	rate-limiting	003_10_to_112	{000_base_rate_limiting,003_10_to_112}	\N
schema_meta	acl	002_130_to_140	{000_base_acl,002_130_to_140}	\N
schema_meta	acme	000_base_acme	{000_base_acme}	\N
schema_meta	response-ratelimiting	000_base_response_rate_limiting	{000_base_response_rate_limiting}	\N
schema_meta	session	000_base_session	{000_base_session}	\N
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (id, created_at, updated_at, name, retries, protocol, host, port, path, connect_timeout, write_timeout, read_timeout, tags, client_certificate_id) FROM stdin;
9874c200-060c-4f2d-9691-c3058f9ecf38	2020-07-01 12:19:22+00	2020-07-01 12:19:22+00	saveUser	5	http	dltk-solution-service	8093	/base/uzer	60000	60000	60000	\N	\N
24862641-5f35-4a4d-8fe3-c3574fd36a87	2020-07-15 16:10:20+00	2020-07-15 16:10:20+00	corePos	5	http	dltk-solution-service	8093	/base/language-service/dltk-language/nlp/pos/	60000	60000	60000	\N	\N
6d642b09-2d72-49e2-a28d-9e2bb41be40c	2020-10-05 05:37:18+00	2020-10-05 05:37:18+00	findOneSubscribe	5	http	dltk-solution-service	8093	/base/subscribe/id	60000	60000	60000	\N	\N
a46ff74a-475d-42e8-b579-27a3573bc63b	2020-06-29 06:51:21+00	2020-06-29 06:51:21+00	registerUserAccountWithOtp	5	http	dltk-solution-service	8093	/base/register/otp	60000	60000	60000	\N	\N
5b98fe86-d73e-4d67-adc5-ed3b6878fbc9	2020-06-29 07:51:08+00	2020-06-29 07:51:08+00	changePassword	5	http	dltk-solution-service	8093	/base/user/changePassword	60000	60000	60000	\N	\N
c7a60493-e77c-46ae-b248-e1bd01fda129	2020-06-29 07:58:25+00	2020-06-29 07:58:25+00	forgotPassword	5	http	dltk-solution-service	8093	/base/user/forgotPassword	60000	60000	60000	\N	\N
4b1ac0a2-77a8-4071-8639-2bc4997d22f9	2020-07-13 12:35:04+00	2020-07-13 12:35:04+00	logout	5	http	dltk-solution-service	8093	/base/oauth/logout	60000	60000	60000	\N	\N
57192cb1-aa11-4c7f-8329-fe381159e1ff	2020-07-16 10:05:13+00	2020-07-16 10:05:13+00	machineClassificationFeedback	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/classification/feedback	60000	60000	60000	\N	\N
96b3ff76-85da-47f8-8d9a-2e53f4bdde82	2020-07-16 10:07:58+00	2020-07-16 10:07:58+00	machineClassificationPredict	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/classification/predict	60000	60000	60000	\N	\N
6ffae089-4485-4497-bf31-18d4490823f8	2020-07-16 10:18:25+00	2020-07-16 10:18:25+00	machineOutputJob	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/job/status	60000	60000	60000	\N	\N
8d777dca-d6b0-469c-b7dd-222559a97fb2	2020-07-16 09:51:03+00	2020-07-16 09:51:03+00	machineClassificationTrain	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/classification/train	60000	60000	60000	\N	\N
e9023de7-0ead-4871-821a-e30dc1054f3f	2020-07-16 09:53:33+00	2020-07-16 09:53:33+00	machineRegressionTrain	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/regression/train	60000	60000	60000	\N	\N
d276334c-fd0f-4223-9ff3-064be25dcec6	2020-07-16 10:00:30+00	2020-07-16 10:00:30+00	machineRegressionPredict	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/regression/predict	60000	60000	60000	\N	\N
f658da27-245c-400a-b010-77cff5e09d07	2020-07-14 12:04:30+00	2020-07-14 12:04:30+00	delete	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/job/id	60000	60000	60000	\N	\N
35b290b9-b6f0-4d4e-b9a6-ff9f3c487ef7	2020-06-29 06:36:59+00	2020-06-29 06:36:59+00	registerUserAccount	5	http	dltk-solution-service	8093	/base/register	60000	60000	60000	\N	\N
0a366b5d-fa66-449b-99a0-d691c20ad49e	2020-12-08 18:10:28+00	2020-12-08 18:10:28+00	getPredictionWebhook	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/datasource/webhook	60000	60000	60000	\N	\N
17153a5e-9192-4636-a21e-3ac658e41833	2021-01-22 08:05:15+00	2021-01-22 08:05:15+00	stopAutomatePredictJob	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/automate/job/predict/stop	60000	60000	60000	\N	\N
5207ca60-304d-4d4e-9372-013b216e92ae	2020-12-11 16:32:55+00	2020-12-11 16:32:55+00	updateOrganization	5	http	dltk-solution-service	8093	/base/uzer/organization	60000	60000	60000	\N	\N
339fd24f-e6a4-4dea-807b-f0c9d81ca4bd	2020-12-31 08:21:51+00	2020-12-31 08:21:51+00	postTimeseriesTrain	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/timeseries/train	60000	60000	60000	\N	\N
6d65b1e0-4979-4294-ac69-7df102e9f3c2	2021-01-05 10:30:22+00	2021-01-05 10:30:22+00	postTimeseriesPredict	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/timeseries/predict/	60000	60000	60000	\N	\N
06cc2105-b4fa-4ea5-b2fc-645f6028bb6c	2021-01-22 08:10:15+00	2021-01-22 08:10:15+00	webhookAutomatePredictJob	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/automate/job/predict/webhook	60000	60000	60000	\N	\N
8000ccd8-5222-406f-b8bd-43c8811bbd85	2021-01-22 08:08:52+00	2021-01-22 08:08:52+00	deleteAutomatePredictJob	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/automate/job/predict/delete	60000	60000	60000	\N	\N
ba230d72-83d5-4a08-bdc6-d65f641f8564	2021-01-22 08:03:01+00	2021-01-22 08:03:01+00	getAutomatePredictJobs	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/automate/job/predict/list	60000	60000	60000	\N	\N
51785cf2-7ea9-401a-9c87-d9d9e3b9bcd6	2021-01-22 07:59:48+00	2021-01-22 07:59:48+00	automatePredictJob	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/automate/job/predict/start	60000	60000	60000	\N	\N
f5714c20-044c-4267-a04b-741bf08f830f	2020-06-29 12:23:58+00	2020-06-29 12:23:58+00	validate	5	http	dltk-solution-service	8093	/base/oauth/validate	60000	60000	60000	\N	\N
be78db07-50c3-4242-9e30-2df5cb6eac94	2020-06-29 12:25:45+00	2020-06-29 12:25:45+00	validateToken	5	http	dltk-solution-service	8093	/base/oauth/validateToken	60000	60000	60000	\N	\N
b20e5e9e-09a8-4e2e-a62a-12c977e56330	2020-06-29 12:29:11+00	2020-06-29 12:29:11+00	verify	5	http	dltk-solution-service	8093	/base/oauth/verify	60000	60000	60000	\N	\N
2cbd5d01-0046-47c9-b211-29c378d59a9b	2020-07-15 16:09:50+00	2020-07-15 16:09:50+00	coreNer	5	http	dltk-solution-service	8093	/base/language-service/dltk-language/nlp/ner/	60000	60000	60000	\N	\N
3e46662e-e69a-4ada-9a02-3743a569f378	2020-08-05 07:18:56+00	2020-08-05 07:18:56+00	coreTagsRecommender	5	http	dltk-solution-service	8093	/base/language-service/dltk-language/nlp/tags_recommender/	60000	60000	60000	\N	\N
b4a37250-3786-414c-a1b6-7c2686f840f0	2020-08-05 07:18:21+00	2020-08-05 07:18:21+00	coreSarcasmDetection	5	http	dltk-solution-service	8093	/base/language-service/dltk-language/nlp/sarcasm_detection/	60000	60000	60000	\N	\N
db5dc0f6-7d1e-44c7-b98b-27a56a31be29	2020-07-14 18:08:38+00	2020-07-14 18:08:38+00	deleteFileById	5	http	dltk-solution-service	8093	/base/s3/file/id	60000	60000	60000	\N	\N
7fba6d72-6a14-40cb-a1f7-eba78ce7a21e	2020-07-14 18:14:43+00	2020-07-14 18:14:43+00	deleteFile	5	http	dltk-solution-service	8093	/base/s3/file	60000	60000	60000	\N	\N
7e99a7f8-032d-49fb-bae7-c1ff126fe591	2020-07-14 18:15:54+00	2020-07-14 18:15:54+00	deleteBucket	5	http	dltk-solution-service	8093	/base/s3/bucket	60000	60000	60000	\N	\N
16047cda-e795-4693-9549-e7ec1e9ff693	2020-06-30 08:02:46+00	2020-06-30 08:02:46+00	addMember	5	http	dltk-solution-service	8093	/base/uzer/addmember	60000	60000	60000	\N	\N
1ea2c568-0418-4b43-aadb-30dcc6bb37dd	2020-06-30 07:26:27+00	2020-06-30 07:26:27+00	upgradePlan	5	http	dltk-solution-service	8093	/base/plan/upgrade	60000	60000	60000	\N	\N
30399845-676b-468a-8288-60ef730305cd	2021-01-28 10:53:01+00	2021-01-28 10:53:01+00	cv2GetTask	5	http	dltk-solution-service	8093	/base/dltk-computer-vision-service/computer_vision/task/	60000	60000	60000	\N	\N
542210c8-9501-4012-8c93-e7a27dc0ec86	2020-06-30 07:15:40+00	2020-06-30 07:15:40+00	listAll	5	http	dltk-solution-service	8093	/base/plan/list	60000	60000	60000	\N	\N
1205f552-2df6-463d-a8a6-87f6af488bbb	2021-01-21 13:12:00+00	2021-01-21 13:12:00+00	getFilesCountForUser	5	http	dltk-solution-service	8093	/base/s3/file/count	60000	60000	60000	\N	\N
706b5485-1d72-4c67-85c1-8ef216f0e47e	2020-06-30 06:02:27+00	2020-06-30 06:02:27+00	getNotificationsByUser	5	http	dltk-solution-service	8093	/base/notification	60000	60000	60000	\N	\N
276eda03-9455-47aa-875d-477bf8a0ff4a	2020-06-29 08:02:42+00	2020-06-29 08:02:42+00	forgotPasswordOTP	5	http	dltk-solution-service	8093	/base/user/forgotPassword/otp	60000	60000	60000	\N	\N
d1e11db8-0fd0-4f54-8155-d2e122cdbdd9	2020-06-29 08:06:14+00	2020-06-29 08:06:14+00	resetPassword	5	http	dltk-solution-service	8093	/base/user/resetPassword	60000	60000	60000	\N	\N
77a84e63-5da2-422b-8e3e-9d2d6e30bddb	2020-06-29 08:09:12+00	2020-06-29 08:09:12+00	resetPasswordOtp	5	http	dltk-solution-service	8093	/base/user/resetPassword/otp	60000	60000	60000	\N	\N
12ed6475-f4d5-43f9-b9e6-6787e1b8488a	2020-06-29 08:13:03+00	2020-06-29 08:13:03+00	uploadImage	5	http	dltk-solution-service	8093	/base/user/image	60000	60000	60000	\N	\N
9d65cf76-ae03-45d4-92d6-b46404165fea	2020-06-29 08:15:46+00	2020-06-29 08:15:46+00	uploadPhoto	5	http	dltk-solution-service	8093	/base/user/photo	60000	60000	60000	\N	\N
e6bd078d-a4d8-4403-98fa-16f705b5caec	2020-07-14 18:05:10+00	2020-07-14 18:05:10+00	createBucket	5	http	dltk-solution-service	8093	/base/s3/bucket	60000	60000	60000	\N	\N
56dcf814-d8d4-4e9f-9d99-beba9531c73c	2020-07-14 18:07:01+00	2020-07-14 18:07:01+00	deletePublicFile	5	http	dltk-solution-service	8093	/base/s3/file/public/id	60000	60000	60000	\N	\N
4f2bdb58-f34a-49a4-a34c-cc5c4b901041	2020-06-30 07:01:29+00	2020-06-30 07:01:29+00	count	5	http	dltk-solution-service	8093	/base/plan/count	60000	60000	60000	\N	\N
71bf3dce-d03c-4016-bc17-e57f13525816	2020-06-30 08:05:53+00	2020-06-30 08:05:53+00	findOne	5	http	dltk-solution-service	8093	/base/uzer/findOne	60000	60000	60000	\N	\N
87bd6183-a978-4c74-91e9-edf789d2f8fa	2020-06-30 07:21:09+00	2020-06-30 07:21:09+00	renewPlan	5	http	dltk-solution-service	8093	/base/plan/renew	60000	60000	60000	\N	\N
8a1d27af-0310-4178-9782-65244aa6010c	2020-06-30 06:05:49+00	2020-06-30 06:05:49+00	findAll	5	http	dltk-solution-service	8093	/base/plan	60000	60000	60000	\N	\N
8d203cfa-3768-49d9-b918-2079d01b6f59	2020-06-30 06:13:48+00	2020-06-30 06:13:48+00	activatePlan	5	http	dltk-solution-service	8093	/base/plan/activate	60000	60000	60000	\N	\N
96a86d74-19c4-49a9-a959-bd3742ffbf81	2020-06-30 06:07:28+00	2020-06-30 06:07:28+00	save	5	http	dltk-solution-service	8093	/base/plan	60000	60000	60000	\N	\N
a553dbda-5861-4657-a758-87aa1b7a3605	2020-06-30 07:35:11+00	2020-06-30 07:35:11+00	getUserPlan	5	http	dltk-solution-service	8093	/base/plan/userplan	60000	60000	60000	\N	\N
a7eee3f0-d3ab-4061-9657-16423c56bbcc	2020-06-30 07:04:04+00	2020-06-30 07:04:04+00	deactivatePlan	5	http	dltk-solution-service	8093	/base/plan/deactivate	60000	60000	60000	\N	\N
b85130a9-9a70-4192-a776-680bdbb2d67e	2020-06-30 05:45:42+00	2020-06-30 05:45:42+00	reloadCache	5	http	dltk-solution-service	8093	/base/admin/cache/reload	60000	60000	60000	\N	\N
bc2707ae-8e43-4ad0-b141-13f0bc0561c0	2020-06-30 07:17:30+00	2020-06-30 07:17:30+00	consumeObject	5	http	dltk-solution-service	8093	/base/plan/object/consume	60000	60000	60000	\N	\N
c098e258-3d5e-4ee7-83aa-46d99d893fde	2020-06-30 07:23:03+00	2020-06-30 07:23:03+00	setupProductPlan	5	http	dltk-solution-service	8093	/base/plan/setup	60000	60000	60000	\N	\N
c5684b61-8d17-44c6-9723-d2973ee6ef62	2020-06-30 05:51:06+00	2020-06-30 05:51:06+00	getUserProducts	5	http	dltk-solution-service	8093	/base/admin/user/products	60000	60000	60000	\N	\N
0e639aae-6c8a-49a6-a837-0e8b8a10cf6a	2020-06-30 09:05:10+00	2020-06-30 09:05:10+00	toggleRedirect	5	http	dltk-solution-service	8093	/base/uzer/redirect/toggle	60000	60000	60000	\N	\N
2e6ac026-a5a4-4a44-987f-200ae45197dd	2020-06-30 08:55:19+00	2020-06-30 08:55:19+00	initialize	5	http	dltk-solution-service	8093	/base/uzer/initialize	60000	60000	60000	\N	\N
37439dd0-021e-48b9-a7b9-401dcace2cb1	2020-07-01 12:12:28+00	2020-07-01 12:12:28+00	countUser	5	http	dltk-solution-service	8093	/base/uzer/count	60000	60000	60000	\N	\N
8dbbd9bd-0a38-4980-8838-e65f21e8c566	2020-06-30 09:02:40+00	2020-06-30 09:02:40+00	register	5	http	dltk-solution-service	8093	/base/uzer/open/register	60000	60000	60000	\N	\N
46767707-a19e-472d-a799-cc5287096f3d	2020-07-15 16:11:00+00	2020-07-15 16:11:00+00	coreDependencyParser	5	http	dltk-solution-service	8093	/base/language-service/dltk-language/nlp/dependency-parser/	60000	60000	60000	\N	\N
d86f0a45-7d15-444c-8cff-d76c2493436e	2020-07-15 16:14:14+00	2020-07-15 16:14:14+00	coreSentiment	5	http	dltk-solution-service	8093	/base/language-service/dltk-language/nlp/sentiment/	60000	60000	60000	\N	\N
005fc05f-ba9d-4c18-9232-ca78ef46ffc1	2020-07-15 16:15:31+00	2020-07-15 16:15:31+00	coreTags	5	http	dltk-solution-service	8093	/base/language-service/dltk-language/nlp/tags/	60000	60000	60000	\N	\N
4a36094a-48b3-46ce-82b6-87d0b90ee90a	2020-07-14 18:17:39+00	2020-07-14 18:17:39+00	listFiles	5	http	dltk-solution-service	8093	/base/s3/list	60000	60000	60000	\N	\N
88094b35-4203-4895-a6f0-b31d015c7b7b	2020-07-14 18:19:18+00	2020-07-14 18:19:18+00	downloadFile	5	http	dltk-solution-service	8093	/base/s3/file/download	60000	60000	60000	\N	\N
5931713d-58fe-4dbb-a2a7-a3b8f5dbb354	2020-07-14 18:22:28+00	2020-07-14 18:22:28+00	downloadFileById	5	http	dltk-solution-service	8093	/base/s3/file/id	60000	60000	60000	\N	\N
5594c8ff-ed54-4b3a-8c32-8fb29d8258d1	2020-07-14 18:24:07+00	2020-07-14 18:24:07+00	findById	5	http	dltk-solution-service	8093	/base/s3/find/id	60000	60000	60000	\N	\N
48aa4a23-c0e1-4b0b-a4c3-ab6befcaa136	2020-07-14 18:25:02+00	2020-07-14 18:25:02+00	find	5	http	dltk-solution-service	8093	/base/s3/find	60000	60000	60000	\N	\N
a5a78b6b-f7e9-4666-ae00-6d8df5835965	2021-01-19 07:54:23+00	2021-01-19 07:54:23+00	getFilesByName	5	http	dltk-solution-service	8093	/base/s3/search	60000	60000	60000	\N	\N
1c47c499-15e1-48ca-ba17-124557c29a49	2021-01-21 06:42:25+00	2021-01-21 06:42:25+00	uploadFiles	5	http	dltk-solution-service	8093	/base/s3/file/public/multiple	60000	60000	60000	\N	\N
f199e1be-616b-4380-b119-9c24c4a66c36	2020-07-12 09:37:13+00	2020-07-12 09:37:13+00	getUserInfo	5	http	dltk-solution-service	8093	/base/user/info	60000	60000	60000	\N	\N
b22199da-23b2-4673-84a8-b617a3faa256	2020-07-13 12:19:48+00	2020-07-13 12:19:48+00	resendRegistrationConfirmationEmail	5	http	dltk-solution-service	8093	/base/resendRegistrationConfirmationEmail	60000	60000	60000	\N	\N
3d7aa31d-3bd3-4a88-9a94-46e7c0fa0e11	2020-07-01 10:32:18+00	2020-07-01 10:32:18+00	exists	5	http	dltk-solution-service	8093	/base/plan/exists	60000	60000	60000	\N	\N
453b260a-ffe4-4b1b-ae20-fd8e510cddf9	2020-07-01 12:17:45+00	2020-07-01 12:17:45+00	findOneUser	5	http	dltk-solution-service	8093	/base/uzer	60000	60000	60000	\N	\N
822dee51-c819-4862-9bc7-d34c0ba9cae3	2020-07-01 10:36:12+00	2020-07-01 10:36:12+00	plansByType	5	http	dltk-solution-service	8093	/base/plan/type	60000	60000	60000	\N	\N
837b9c78-e39d-436a-8474-282fb15d2692	2020-06-30 08:08:34+00	2020-06-30 08:08:34+00	getUserId	5	http	dltk-solution-service	8093	/base/uzer/id	60000	60000	60000	\N	\N
86ac5a6e-c7a9-456f-bccf-03ed8f866789	2020-07-01 12:16:12+00	2020-07-01 12:16:12+00	existsUser	5	http	dltk-solution-service	8093	/base/uzer/exists	60000	60000	60000	\N	\N
8d3c09cf-c960-46cd-bd2b-9990eac60e07	2020-07-01 12:03:27+00	2020-07-01 12:03:27+00	findOnePlan	5	http	dltk-solution-service	8093	/base/plan/multiple	60000	60000	60000	\N	\N
8b5ea1ac-9856-432f-8b8d-627c52993b25	2020-07-05 13:20:14+00	2020-07-05 13:20:14+00	login	5	http	dltk-solution-service	8093	/base/oauth/login	60000	60000	60000	\N	\N
32c9cae8-7cdf-409c-a796-63ef4b041cc7	2020-07-14 12:10:32+00	2020-07-14 12:10:32+00	findOneLib	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/library/id	60000	60000	60000	\N	\N
8cebc9ed-a48c-413a-bcad-84aaecb06d47	2020-07-16 10:21:05+00	2020-07-16 10:21:05+00	machineFindByJobId	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/output/findBy	60000	60000	60000	\N	\N
f497c4cb-b60f-424b-8aad-415e6d662f75	2020-06-29 12:18:43+00	2020-06-29 12:18:43+00	getRoles	5	http	dltk-solution-service	8093	/base/role	60000	60000	60000	\N	\N
1dbc16ea-7ff5-47e5-b41c-84b863f52727	2020-06-29 12:21:48+00	2020-06-29 12:21:48+00	getUsers	5	http	dltk-solution-service	8093	/base/admin/user/list	60000	60000	60000	\N	\N
aeeabdfd-2493-4767-a0fb-f10eed9e74a3	2020-07-01 12:22:05+00	2020-07-01 12:22:05+00	updateUser	5	http	dltk-solution-service	8093	/base/uzer	60000	60000	60000	\N	\N
cece5a89-51d4-434d-936b-f97bd6456971	2020-07-01 12:20:46+00	2020-07-01 12:20:46+00	findAllUser	5	http	dltk-solution-service	8093	/base/uzer/search	60000	60000	60000	\N	\N
de08c75a-a7fe-4e25-aa72-060b4ab9f6bd	2020-06-30 09:09:39+00	2020-06-30 09:09:39+00	consumeStorage	5	http	dltk-solution-service	8093	/base/uzer/storage/consume	60000	60000	60000	\N	\N
3357319e-93f0-4214-a061-4ad975ace856	2020-07-14 13:57:49+00	2020-07-14 13:57:49+00	generateApiKey	5	http	dltk-solution-service	8093	/base/app/generateApiKey	60000	60000	60000	\N	\N
4408b784-2f48-4deb-a5ab-448e8567706f	2020-07-14 14:03:03+00	2020-07-14 14:03:03+00	getApp	5	http	dltk-solution-service	8093	/base/app/appId	60000	60000	60000	\N	\N
59a267b3-bbf8-48ee-ae7e-d54ed7d0482e	2020-07-14 14:00:02+00	2020-07-14 14:00:02+00	appInfo	5	http	dltk-solution-service	8093	/base/app/appInfo	60000	60000	60000	\N	\N
74076f2a-353d-4559-88e8-54de7fc83913	2020-07-14 13:55:59+00	2020-07-14 13:55:59+00	getAppByUser	5	http	dltk-solution-service	8093	/base/app/search	60000	60000	60000	\N	\N
9e19c63e-c898-4978-9351-d5e1626c6ddb	2020-07-14 13:53:36+00	2020-07-14 13:53:36+00	createApp	5	http	dltk-solution-service	8093	/base/app/create	60000	60000	60000	\N	\N
62a25b04-9768-40c5-a77f-d9e6ecabeae5	2020-07-17 09:51:09+00	2020-07-17 09:51:09+00	machineCluster	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/cluster	60000	60000	60000	\N	\N
aebe5bf2-a10c-4515-b8a8-18824fc0761b	2020-07-14 15:37:59+00	2020-07-14 15:37:59+00	fetchLabels	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/stream/fetch	60000	60000	60000	\N	\N
c4f046ec-a14f-4ad0-9a19-253b4454eac9	2020-07-14 12:28:08+00	2020-07-14 12:28:08+00	saveOutput	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/output	60000	60000	60000	\N	\N
dbc1debe-af7e-4ca7-a835-97179f401f7b	2020-07-14 10:39:29+00	2020-07-14 10:39:29+00	search	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/algorithm/search	60000	60000	60000	\N	\N
dcbe4be7-9314-4d3a-8d4f-eeb1ed793fd5	2020-07-14 12:14:29+00	2020-07-14 12:14:29+00	findAllLibraries	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/library	60000	60000	60000	\N	\N
e0aa07fd-017e-4d51-bdc1-fc3c50d94266	2020-07-14 12:25:31+00	2020-07-14 12:25:31+00	listStream	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/stream/list	60000	60000	60000	\N	\N
ee85e4f4-97bf-416b-87bf-2c8b9b774cfc	2020-07-14 10:51:52+00	2020-07-14 10:51:52+00	output	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/job/output	60000	60000	60000	\N	\N
42a1d77d-25bd-4687-a394-b47fb0924b07	2020-07-14 12:02:18+00	2020-07-14 12:02:18+00	job	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/job	60000	60000	60000	\N	\N
453e1704-5ec0-4c8b-b395-1f18c5bb81f5	2020-07-14 11:39:53+00	2020-07-14 11:39:53+00	findOneAlg	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/algorithm/id	60000	60000	60000	\N	\N
64cdb7aa-52f4-4b3e-b4bc-016a362c64fd	2020-07-14 10:46:01+00	2020-07-14 10:46:01+00	restart	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/job/restart	60000	60000	60000	\N	\N
7223d19b-2ccf-42a9-825b-aeba8c1ca423	2020-07-14 11:45:09+00	2020-07-14 11:45:09+00	findOneAlgorithm	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/algorithm/findOne	60000	60000	60000	\N	\N
917a2e8a-6d13-4bb7-95b6-c54c8310f4c4	2020-07-14 11:47:40+00	2020-07-14 11:47:40+00	findAllAlgorithms	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/algorithm	60000	60000	60000	\N	\N
983870dd-f101-4939-9355-d13613237b99	2020-07-14 11:09:59+00	2020-07-14 11:09:59+00	generate	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/code/generate	60000	60000	60000	\N	\N
9a35d03c-ac39-4dcd-89c8-9cd078e0a3a2	2020-07-14 11:12:38+00	2020-07-14 11:12:38+00	stream	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/stream	60000	60000	60000	\N	\N
4b01c784-f169-4d02-b981-6fdf39d4d54e	2020-10-20 12:51:43+00	2020-10-20 12:51:43+00	topicModeling	5	http	dltk-solution-service	8093	/base/language-service/dltk-language/nlp/topic_modeling/	60000	60000	60000	\N	\N
d5e18fe6-06c7-4cfd-b982-2ccf9c7ea541	2020-10-04 13:52:12+00	2020-10-04 13:52:12+00	findAllCategory	5	http	dltk-solution-service	8093	/base/category	60000	60000	60000	\N	\N
78c26cf4-6e69-4a84-baea-31a16e8c7615	2020-10-04 13:53:21+00	2020-10-04 13:53:21+00	countCategory	5	http	dltk-solution-service	8093	/base/category/count	60000	60000	60000	\N	\N
6016663d-1d02-495d-8c35-34b52d67bed1	2020-07-14 15:41:16+00	2020-07-14 15:41:16+00	stopStream	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/stream/id	60000	60000	60000	\N	\N
733c3d90-57fb-451a-8725-61f756a1ed85	2020-11-19 12:39:54+00	2020-11-19 12:39:54+00	getDataSourcequeries	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/datasource/queries	60000	60000	60000	\N	\N
e9f68e8c-64d6-47f8-9c6c-fceae1a8fd4f	2020-11-19 12:42:44+00	2020-11-19 12:42:44+00	getDataSourcequeryColumns	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/datasource/query/columns	60000	60000	60000	\N	\N
618051d1-d8f1-4ae4-9bbf-8150b3655dec	2020-11-19 12:44:41+00	2020-11-19 12:44:41+00	addDatabase	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/datasource/add	60000	60000	60000	\N	\N
eaa3efd9-b93c-476a-b402-b469d73809bb	2020-11-19 12:46:37+00	2020-11-19 12:46:37+00	getDatabasesPaginated	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/datasource/page	60000	60000	60000	\N	\N
d489e4fb-3757-41c9-bbee-4a9c4b90d776	2020-11-19 12:47:33+00	2020-11-19 12:47:33+00	deleteDatabase	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/datasource	60000	60000	60000	\N	\N
a1e39de1-02dc-4329-84b0-e3b147e00fb1	2020-07-14 12:12:37+00	2020-07-14 12:12:37+00	findOneLibrary	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/library/findOne	60000	60000	60000	\N	\N
dc6c0afb-0b20-4f36-8d87-fe77c3015016	2020-12-23 08:29:57+00	2020-12-23 08:29:57+00	predictWebhookByModel	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/datasource/webhookbymodel	60000	60000	60000	\N	\N
56b1ba46-331d-4acc-a973-a84bed5fe69e	2020-06-29 11:07:24+00	2020-06-29 11:07:24+00	confirmRegistration	5	http	dltk-solution-service	8093	/base/registrationConfirm	60000	60000	60000	\N	\N
2aba53d6-e9c2-4eae-9f54-94dae4cd4e12	2020-06-29 11:28:37+00	2020-06-29 11:28:37+00	resendRegistrationConfirmationEmailOtp	5	http	dltk-solution-service	8093	/base/resendRegistrationConfirmationEmail/otp	60000	60000	60000	\N	\N
91a24a04-a26c-45a3-8052-fba7ff27a50d	2020-06-29 11:41:14+00	2020-06-29 11:41:14+00	resendRegistrationToken	5	http	dltk-solution-service	8093	/base/resendRegistrationToken	60000	60000	60000	\N	\N
99382b87-19f7-44ed-a4b9-e21575eb8814	2020-06-29 11:46:28+00	2020-06-29 11:46:28+00	emailExists	5	http	dltk-solution-service	8093	/base/user/exists	60000	60000	60000	\N	\N
63d7c874-40c0-47ba-99f5-b7b2133380e4	2021-01-22 08:07:18+00	2021-01-22 08:07:18+00	restartAutomatePredictJob	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/automate/job/predict/restart	60000	60000	60000	\N	\N
65971dc3-5794-4050-bab6-222688d87315	2020-06-29 11:49:48+00	2020-06-29 11:49:48+00	mobileExists	5	http	dltk-solution-service	8093	/base/user/mobile/exists	60000	60000	60000	\N	\N
37308d10-9349-40cf-a286-4eed655b01fc	2020-06-29 12:11:26+00	2020-06-29 12:11:26+00	getUserProfile	5	http	dltk-solution-service	8093	/base/user/profile	60000	60000	60000	\N	\N
6fc56953-210b-44bf-b7f4-19eb9e7072f3	2020-06-29 12:14:38+00	2020-06-29 12:14:38+00	update	5	http	dltk-solution-service	8093	/base/user/update	60000	60000	60000	\N	\N
6155a856-6b2a-407e-b4e1-92475f99b0b5	2020-12-18 11:53:53+00	2020-12-18 11:53:53+00	appAnalytics	5	http	dltk-solution-service	8093	/base/user/analytics	60000	60000	60000	\N	\N
a9fc09a8-e358-4da8-b8b7-ff025e74c2d2	2021-01-19 07:51:18+00	2021-01-19 07:51:18+00	getFilesListByPagination	5	http	dltk-solution-service	8093	/base/s3/list/page	60000	60000	60000	\N	\N
7a89e5d4-4deb-40b3-81d1-a51010a7704a	2020-10-04 14:54:30+00	2020-10-04 14:54:30+00	initializeUser	5	http	dltk-solution-service	8093	/base/uzer/profile/initialize	60000	60000	60000	\N	\N
348bcc07-7be8-455e-b7cf-6a2414b290b1	2020-10-05 05:28:18+00	2020-10-05 05:28:18+00	findOneByNameProduct	5	http	dltk-solution-service	8093	/base/product/name	60000	60000	60000	\N	\N
3bb02ec3-b945-47d7-b2c9-845298a1519b	2020-10-05 05:31:41+00	2020-10-05 05:31:41+00	findOneProduct	5	http	dltk-solution-service	8093	/base/product/id	60000	60000	60000	\N	\N
a155b3bc-0f89-4083-8a9c-79f9d8b5f518	2020-10-05 05:35:31+00	2020-10-05 05:35:31+00	existsSubscribe	5	http	dltk-solution-service	8093	/base/subscribe/exists/id	60000	60000	60000	\N	\N
6b14fbf7-6119-4bfe-a338-eeb16a9420fc	2020-07-14 12:00:14+00	2020-07-14 12:00:14+00	listJob	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/job/list	60000	60000	60000	\N	\N
d4613397-2acd-42b6-ab06-2ca7c133424f	2021-01-18 05:55:39+00	2021-01-18 05:55:39+00	cv2ImageClassification	5	http	dltk-solution-service	8093	/base/dltk-computer-vision-service/computer_vision/image_classification	60000	60000	60000	\N	\N
988f7599-12c7-47d5-a8a4-ced457f34de3	2021-01-18 06:07:47+00	2021-01-18 06:07:47+00	cv2ObjectDetection	5	http	dltk-solution-service	8093	/base/dltk-computer-vision-service/computer_vision/object_detection	60000	60000	60000	\N	\N
a3b38a13-6711-46b9-b690-7fe2cb677410	2021-01-18 06:16:09+00	2021-01-18 06:16:09+00	cv2TaskStatus	5	http	dltk-solution-service	8093	/base/dltk-computer-vision-service/computer_vision/task	60000	60000	60000	\N	\N
507fad51-b02b-4b17-8bdc-e7a2ca00f356	2021-01-28 10:52:22+00	2021-01-28 10:52:22+00	cv2FaceAnalytics	5	http	dltk-solution-service	8093	/base/dltk-computer-vision-service/computer_vision/face_analytics/	60000	60000	60000	\N	\N
59e52edd-9edd-4670-a829-146355019f78	2020-10-04 14:28:43+00	2020-10-04 14:28:43+00	findAllProduct	5	http	dltk-solution-service	8093	/base/product	60000	60000	60000	\N	\N
e7072395-184f-41fe-96d6-1adf31af26a0	2020-10-04 14:30:06+00	2020-10-04 14:30:06+00	countProduct	5	http	dltk-solution-service	8093	/base/product/count	60000	60000	60000	\N	\N
fc30cce7-d4a7-4b99-ae48-6f7560f1e381	2020-10-04 14:48:22+00	2020-10-04 14:48:22+00	subscribe	5	http	dltk-solution-service	8093	/base/subscribe	60000	60000	60000	\N	\N
8a5c4ca0-72f9-4626-8400-8951ce461e1d	2020-12-11 16:35:55+00	2020-12-11 16:35:55+00	updateEducation	5	http	dltk-solution-service	8093	/base/uzer/education	60000	60000	60000	\N	\N
d44cea9f-dd83-45c4-8042-e64dcf7e6116	2020-07-14 17:56:20+00	2020-07-14 17:56:20+00	uploadPublicFile	5	http	dltk-solution-service	8093	/base/s3/file/public	60000	60000	60000	\N	\N
156fae24-1427-4928-8173-a10e75b93560	2020-07-14 17:59:18+00	2020-07-14 17:59:18+00	uploadFile	5	http	dltk-solution-service	8093	/base/s3/file	60000	60000	60000	\N	\N
081dc620-4fc1-429f-a085-e93f95f51ff1	2020-07-14 18:00:27+00	2020-07-14 18:00:27+00	uploadFolder	5	http	dltk-solution-service	8093	/base/s3/folder	60000	60000	60000	\N	\N
a52b19ba-f012-4086-b021-487ac539d8b1	2020-07-14 18:03:35+00	2020-07-14 18:03:35+00	replaceFile	5	http	dltk-solution-service	8093	/base/s3/file	60000	60000	60000	\N	\N
256169d1-8c25-4cad-856c-b2d67f93126f	2021-02-11 11:52:25+00	2021-02-11 11:52:25+00	getMarketPlaceApp	5	http	dltk-solution-service	8093	/base/app/mpApp	60000	60000	60000	\N	\N
3feb0a4a-84bf-4533-b06f-024913b74967	2020-10-04 14:58:03+00	2020-10-04 14:58:03+00	findAllSubscribe	5	http	dltk-solution-service	8093	/base/subscribe	60000	60000	60000	\N	\N
7b9f52fe-3a25-4e5e-9456-d324f5bb166e	2020-10-04 14:59:29+00	2020-10-04 14:59:29+00	countSubscribe	5	http	dltk-solution-service	8093	/base/subscribe/count	60000	60000	60000	\N	\N
ea6c26a9-d857-4487-85fa-4624c067ba7b	2020-10-04 15:03:20+00	2020-10-04 15:03:20+00	userGetUserProfile	5	http	dltk-solution-service	8093	/base/uzer/profile/id	60000	60000	60000	\N	\N
6083eea3-6152-4cc3-b740-56ccc669426d	2020-10-04 15:04:24+00	2020-10-04 15:04:24+00	userDeleteUserProfile	5	http	dltk-solution-service	8093	/base/uzer/profile/remove	60000	60000	60000	\N	\N
23c34501-c25c-47dc-a550-56ef8657f9ae	2020-10-05 05:13:43+00	2020-10-05 05:13:43+00	existsCategory	5	http	dltk-solution-service	8093	/base/category/exists/id	60000	60000	60000	\N	\N
734b4e70-df97-41ee-b708-a4af837d5bb8	2020-10-05 05:15:05+00	2020-10-05 05:15:05+00	findOneCategory	5	http	dltk-solution-service	8093	/base/category/id	60000	60000	60000	\N	\N
99bfead2-7174-4414-82fb-39f88eda6d76	2020-10-05 05:26:33+00	2020-10-05 05:26:33+00	existsProduct	5	http	dltk-solution-service	8093	/base/product/exists/id	60000	60000	60000	\N	\N
74eb02de-d987-4e45-8e69-2d4e31bbe5c0	2020-07-16 10:03:00+00	2020-07-16 10:03:00+00	machineRegressionFeedback	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/regression/feedback	60000	60000	60000	\N	\N
55945d5b-a70c-4070-aca9-2a2108e7d724	2020-06-30 07:13:05+00	2020-06-30 07:13:05+00	getPlan	5	http	dltk-solution-service	8093	/base/plan/info	60000	60000	60000	\N	\N
5bad9e58-836f-43e0-9f62-1727e6f47175	2020-10-04 13:59:35+00	2020-10-04 13:59:35+00	categoryFindOne	5	http	dltk-solution-service	8093	/base/category/findOne	60000	60000	60000	\N	\N
45c1b1bb-2c8b-4948-9021-cf875caab983	2020-10-04 14:00:09+00	2020-10-04 14:00:09+00	categoryFindAll	5	http	dltk-solution-service	8093	/base/category/search	60000	60000	60000	\N	\N
588774bf-717a-4dca-bb19-597def4b91f3	2020-07-14 10:49:04+00	2020-07-14 10:49:04+00	listByService	5	http	dltk-solution-service	8093	/base/machinelearning-service/dltk-machinelearning/job/list	60000	60000	60000	\N	\N
16c478ee-3fbe-4160-b8c5-8b9a148bcec9	2021-03-15 09:38:37+00	2021-03-15 09:38:37+00	posWithoutCompare	5	http	dltk-solution-service	8093	/base/language-service/dltk-language/nlp/pos/	60000	60000	60000	\N	\N
7026cdfe-1b78-47c4-8df2-15fabab122b0	2021-03-15 09:43:17+00	2021-03-15 09:43:17+00	nerWithoutCompare	5	http	dltk-solution-service	8093	/base/language-service/dltk-language/nlp/ner/	60000	60000	60000	\N	\N
36f7c31e-cfb2-4ac9-a1d5-8586b0b5fdac	2021-03-15 09:48:45+00	2021-03-15 09:48:45+00	sentimentWithoutCompare	5	http	dltk-solution-service	8093	/base/language-service/dltk-language/nlp/sentiment/	60000	60000	60000	\N	\N
fcf23856-9041-4fd9-a6df-f41cdff3103d	2021-03-15 09:53:54+00	2021-03-15 09:53:54+00	tagsWithoutCompare	5	http	dltk-solution-service	8093	/base/language-service/dltk-language/nlp/tags/	60000	60000	60000	\N	\N
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, session_id, expires, data, created_at, ttl) FROM stdin;
\.


--
-- Data for Name: snis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.snis (id, created_at, name, certificate_id, tags) FROM stdin;
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (entity_id, entity_name, tags) FROM stdin;
35b290b9-b6f0-4d4e-b9a6-ff9f3c487ef7	services	\N
a46ff74a-475d-42e8-b579-27a3573bc63b	services	\N
5b98fe86-d73e-4d67-adc5-ed3b6878fbc9	services	\N
c7a60493-e77c-46ae-b248-e1bd01fda129	services	\N
276eda03-9455-47aa-875d-477bf8a0ff4a	services	\N
d1e11db8-0fd0-4f54-8155-d2e122cdbdd9	services	\N
77a84e63-5da2-422b-8e3e-9d2d6e30bddb	services	\N
12ed6475-f4d5-43f9-b9e6-6787e1b8488a	services	\N
9d65cf76-ae03-45d4-92d6-b46404165fea	services	\N
56b1ba46-331d-4acc-a973-a84bed5fe69e	services	\N
16047cda-e795-4693-9549-e7ec1e9ff693	services	\N
2aba53d6-e9c2-4eae-9f54-94dae4cd4e12	services	\N
91a24a04-a26c-45a3-8052-fba7ff27a50d	services	\N
99382b87-19f7-44ed-a4b9-e21575eb8814	services	\N
65971dc3-5794-4050-bab6-222688d87315	services	\N
37308d10-9349-40cf-a286-4eed655b01fc	services	\N
6fc56953-210b-44bf-b7f4-19eb9e7072f3	services	\N
f497c4cb-b60f-424b-8aad-415e6d662f75	services	\N
1dbc16ea-7ff5-47e5-b41c-84b863f52727	services	\N
f5714c20-044c-4267-a04b-741bf08f830f	services	\N
be78db07-50c3-4242-9e30-2df5cb6eac94	services	\N
b20e5e9e-09a8-4e2e-a62a-12c977e56330	services	\N
1ea2c568-0418-4b43-aadb-30dcc6bb37dd	services	\N
4f2bdb58-f34a-49a4-a34c-cc5c4b901041	services	\N
542210c8-9501-4012-8c93-e7a27dc0ec86	services	\N
55945d5b-a70c-4070-aca9-2a2108e7d724	services	\N
706b5485-1d72-4c67-85c1-8ef216f0e47e	services	\N
71bf3dce-d03c-4016-bc17-e57f13525816	services	\N
87bd6183-a978-4c74-91e9-edf789d2f8fa	services	\N
8a1d27af-0310-4178-9782-65244aa6010c	services	\N
8d203cfa-3768-49d9-b918-2079d01b6f59	services	\N
96a86d74-19c4-49a9-a959-bd3742ffbf81	services	\N
a553dbda-5861-4657-a758-87aa1b7a3605	services	\N
a7eee3f0-d3ab-4061-9657-16423c56bbcc	services	\N
b85130a9-9a70-4192-a776-680bdbb2d67e	services	\N
bc2707ae-8e43-4ad0-b141-13f0bc0561c0	services	\N
c098e258-3d5e-4ee7-83aa-46d99d893fde	services	\N
c5684b61-8d17-44c6-9723-d2973ee6ef62	services	\N
8b5ea1ac-9856-432f-8b8d-627c52993b25	services	\N
f199e1be-616b-4380-b119-9c24c4a66c36	services	\N
b22199da-23b2-4673-84a8-b617a3faa256	services	\N
4b1ac0a2-77a8-4071-8639-2bc4997d22f9	services	\N
0e639aae-6c8a-49a6-a837-0e8b8a10cf6a	services	\N
32c9cae8-7cdf-409c-a796-63ef4b041cc7	services	\N
2e6ac026-a5a4-4a44-987f-200ae45197dd	services	\N
37439dd0-021e-48b9-a7b9-401dcace2cb1	services	\N
3d7aa31d-3bd3-4a88-9a94-46e7c0fa0e11	services	\N
453b260a-ffe4-4b1b-ae20-fd8e510cddf9	services	\N
822dee51-c819-4862-9bc7-d34c0ba9cae3	services	\N
837b9c78-e39d-436a-8474-282fb15d2692	services	\N
86ac5a6e-c7a9-456f-bccf-03ed8f866789	services	\N
8d3c09cf-c960-46cd-bd2b-9990eac60e07	services	\N
8dbbd9bd-0a38-4980-8838-e65f21e8c566	services	\N
9874c200-060c-4f2d-9691-c3058f9ecf38	services	\N
aeeabdfd-2493-4767-a0fb-f10eed9e74a3	services	\N
cece5a89-51d4-434d-936b-f97bd6456971	services	\N
de08c75a-a7fe-4e25-aa72-060b4ab9f6bd	services	\N
42a1d77d-25bd-4687-a394-b47fb0924b07	services	\N
453e1704-5ec0-4c8b-b395-1f18c5bb81f5	services	\N
588774bf-717a-4dca-bb19-597def4b91f3	services	\N
64cdb7aa-52f4-4b3e-b4bc-016a362c64fd	services	\N
6b14fbf7-6119-4bfe-a338-eeb16a9420fc	services	\N
7223d19b-2ccf-42a9-825b-aeba8c1ca423	services	\N
917a2e8a-6d13-4bb7-95b6-c54c8310f4c4	services	\N
983870dd-f101-4939-9355-d13613237b99	services	\N
9a35d03c-ac39-4dcd-89c8-9cd078e0a3a2	services	\N
3357319e-93f0-4214-a061-4ad975ace856	services	\N
4408b784-2f48-4deb-a5ab-448e8567706f	services	\N
59a267b3-bbf8-48ee-ae7e-d54ed7d0482e	services	\N
74076f2a-353d-4559-88e8-54de7fc83913	services	\N
9e19c63e-c898-4978-9351-d5e1626c6ddb	services	\N
d44cea9f-dd83-45c4-8042-e64dcf7e6116	services	\N
156fae24-1427-4928-8173-a10e75b93560	services	\N
081dc620-4fc1-429f-a085-e93f95f51ff1	services	\N
a52b19ba-f012-4086-b021-487ac539d8b1	services	\N
e6bd078d-a4d8-4403-98fa-16f705b5caec	services	\N
56dcf814-d8d4-4e9f-9d99-beba9531c73c	services	\N
db5dc0f6-7d1e-44c7-b98b-27a56a31be29	services	\N
7fba6d72-6a14-40cb-a1f7-eba78ce7a21e	services	\N
7e99a7f8-032d-49fb-bae7-c1ff126fe591	services	\N
4a36094a-48b3-46ce-82b6-87d0b90ee90a	services	\N
88094b35-4203-4895-a6f0-b31d015c7b7b	services	\N
5931713d-58fe-4dbb-a2a7-a3b8f5dbb354	services	\N
5594c8ff-ed54-4b3a-8c32-8fb29d8258d1	services	\N
48aa4a23-c0e1-4b0b-a4c3-ab6befcaa136	services	\N
6016663d-1d02-495d-8c35-34b52d67bed1	services	\N
74eb02de-d987-4e45-8e69-2d4e31bbe5c0	services	\N
57192cb1-aa11-4c7f-8329-fe381159e1ff	services	\N
96b3ff76-85da-47f8-8d9a-2e53f4bdde82	services	\N
6ffae089-4485-4497-bf31-18d4490823f8	services	\N
8cebc9ed-a48c-413a-bcad-84aaecb06d47	services	\N
62a25b04-9768-40c5-a77f-d9e6ecabeae5	services	\N
2cbd5d01-0046-47c9-b211-29c378d59a9b	services	\N
24862641-5f35-4a4d-8fe3-c3574fd36a87	services	\N
46767707-a19e-472d-a799-cc5287096f3d	services	\N
d86f0a45-7d15-444c-8cff-d76c2493436e	services	\N
005fc05f-ba9d-4c18-9232-ca78ef46ffc1	services	\N
8d777dca-d6b0-469c-b7dd-222559a97fb2	services	\N
e9023de7-0ead-4871-821a-e30dc1054f3f	services	\N
d276334c-fd0f-4223-9ff3-064be25dcec6	services	\N
3e46662e-e69a-4ada-9a02-3743a569f378	services	\N
b4a37250-3786-414c-a1b6-7c2686f840f0	services	\N
d5e18fe6-06c7-4cfd-b982-2ccf9c7ea541	services	\N
78c26cf4-6e69-4a84-baea-31a16e8c7615	services	\N
5bad9e58-836f-43e0-9f62-1727e6f47175	services	\N
45c1b1bb-2c8b-4948-9021-cf875caab983	services	\N
59e52edd-9edd-4670-a829-146355019f78	services	\N
e7072395-184f-41fe-96d6-1adf31af26a0	services	\N
fc30cce7-d4a7-4b99-ae48-6f7560f1e381	services	\N
7a89e5d4-4deb-40b3-81d1-a51010a7704a	services	\N
3feb0a4a-84bf-4533-b06f-024913b74967	services	\N
7b9f52fe-3a25-4e5e-9456-d324f5bb166e	services	\N
ea6c26a9-d857-4487-85fa-4624c067ba7b	services	\N
6083eea3-6152-4cc3-b740-56ccc669426d	services	\N
23c34501-c25c-47dc-a550-56ef8657f9ae	services	\N
734b4e70-df97-41ee-b708-a4af837d5bb8	services	\N
99bfead2-7174-4414-82fb-39f88eda6d76	services	\N
348bcc07-7be8-455e-b7cf-6a2414b290b1	services	\N
3bb02ec3-b945-47d7-b2c9-845298a1519b	services	\N
a155b3bc-0f89-4083-8a9c-79f9d8b5f518	services	\N
6d642b09-2d72-49e2-a28d-9e2bb41be40c	services	\N
4b01c784-f169-4d02-b981-6fdf39d4d54e	services	\N
733c3d90-57fb-451a-8725-61f756a1ed85	services	\N
e9f68e8c-64d6-47f8-9c6c-fceae1a8fd4f	services	\N
618051d1-d8f1-4ae4-9bbf-8150b3655dec	services	\N
eaa3efd9-b93c-476a-b402-b469d73809bb	services	\N
d489e4fb-3757-41c9-bbee-4a9c4b90d776	services	\N
a1e39de1-02dc-4329-84b0-e3b147e00fb1	services	\N
aebe5bf2-a10c-4515-b8a8-18824fc0761b	services	\N
c4f046ec-a14f-4ad0-9a19-253b4454eac9	services	\N
dbc1debe-af7e-4ca7-a835-97179f401f7b	services	\N
dcbe4be7-9314-4d3a-8d4f-eeb1ed793fd5	services	\N
e0aa07fd-017e-4d51-bdc1-fc3c50d94266	services	\N
ee85e4f4-97bf-416b-87bf-2c8b9b774cfc	services	\N
f658da27-245c-400a-b010-77cff5e09d07	services	\N
0a366b5d-fa66-449b-99a0-d691c20ad49e	services	\N
5207ca60-304d-4d4e-9372-013b216e92ae	services	\N
8a5c4ca0-72f9-4626-8400-8951ce461e1d	services	\N
6155a856-6b2a-407e-b4e1-92475f99b0b5	services	\N
dc6c0afb-0b20-4f36-8d87-fe77c3015016	services	\N
63d7c874-40c0-47ba-99f5-b7b2133380e4	services	\N
17153a5e-9192-4636-a21e-3ac658e41833	services	\N
339fd24f-e6a4-4dea-807b-f0c9d81ca4bd	services	\N
6d65b1e0-4979-4294-ac69-7df102e9f3c2	services	\N
d4613397-2acd-42b6-ab06-2ca7c133424f	services	\N
988f7599-12c7-47d5-a8a4-ced457f34de3	services	\N
a3b38a13-6711-46b9-b690-7fe2cb677410	services	\N
a9fc09a8-e358-4da8-b8b7-ff025e74c2d2	services	\N
a5a78b6b-f7e9-4666-ae00-6d8df5835965	services	\N
1c47c499-15e1-48ca-ba17-124557c29a49	services	\N
1205f552-2df6-463d-a8a6-87f6af488bbb	services	\N
06cc2105-b4fa-4ea5-b2fc-645f6028bb6c	services	\N
8000ccd8-5222-406f-b8bd-43c8811bbd85	services	\N
ba230d72-83d5-4a08-bdc6-d65f641f8564	services	\N
51785cf2-7ea9-401a-9c87-d9d9e3b9bcd6	services	\N
507fad51-b02b-4b17-8bdc-e7a2ca00f356	services	\N
30399845-676b-468a-8288-60ef730305cd	services	\N
87730998-5e40-4243-b89c-fc5f471c93c8	routes	\N
1961d491-3011-47c6-a6e5-1170fd821cc9	routes	\N
bfaf9fc9-4f85-4202-b88e-2bcc14caa16b	routes	\N
d305cc7f-d115-4ed4-8542-5f197d7c7576	routes	\N
bbb4090f-1ed9-40cb-9a8e-a8d0549967ad	routes	\N
59482112-21ca-436f-b379-db9764a2e6b5	routes	\N
f0d1c3a7-a3b7-4830-91cd-b361dbb09f74	routes	\N
cb297aff-1244-42b2-a883-16f507108043	routes	\N
81fd852a-f0cd-4f41-98e0-251a43dd72c6	routes	\N
ed3f7120-3418-4891-a7a4-b7efe2a244a6	routes	\N
17fd7354-0562-4eed-ad90-447733a0a737	routes	\N
ae4c53cc-b62a-4a7a-a03d-8f15110a5f24	routes	\N
386b5f4d-c1d4-4c11-b109-964abda01891	routes	\N
cdae5238-2b64-4e78-a39a-1311ab3a263f	routes	\N
d5dbd2d4-2a45-48e2-80e7-e1eed81f1e26	routes	\N
3a236f22-d30b-4cb5-8ebb-b3a5cb3afac4	routes	\N
693e3d10-60ea-4887-aa5d-b374b88c1912	routes	\N
f9bfd948-ff08-4085-8236-553c8f442b15	routes	\N
c512a9d7-f457-450e-8d3a-f431b88a9bcf	routes	\N
e7ea0f99-225a-4d30-a1b7-b55c46e12e3c	routes	\N
73700b3e-f99c-48cf-922d-5f48569a5302	routes	\N
fd6bce66-b762-4cfd-94ae-e5c62d304fec	routes	\N
cdabbba8-e1bf-47f4-a3fc-3e63dd37b0a1	routes	\N
1a654b87-ae72-411c-aea9-d91bde01e88c	routes	\N
741eb6a0-4bf5-4b7e-b645-35f0aed20ed9	routes	\N
02eff922-a350-44aa-8e91-60ff370bbabf	routes	\N
967aec9d-d53a-4d76-9c16-f406f57bf246	routes	\N
cc63dc5b-9756-42d7-8174-ff9b3f7d53e6	routes	\N
c5a4b003-e3ae-416a-a54c-d425483f66c2	routes	\N
29334c94-8e5d-47fc-927c-7f1cec0dd167	routes	\N
74c01170-60ae-4b27-80d2-ea8cfa72da6b	routes	\N
e3962c1a-516d-4e9f-8502-58367553316c	routes	\N
ed654bc1-029c-4038-a6a6-0960e1904167	routes	\N
3befaaf1-d164-45a8-b558-03a26b3e62d3	routes	\N
b82d8791-fd99-48bf-a981-855c54f85882	routes	\N
cf3a0062-da2a-4d0b-81ea-4fd5ab253db3	routes	\N
feb2f3c3-c60d-432d-93a9-0417618af531	routes	\N
d1bad831-d89f-4992-b3d1-f47f39ec28f7	routes	\N
057bd030-a114-47ba-9bdd-bdff62545b58	routes	\N
63cdbe88-5621-4e71-9fa9-ce9b5603b691	routes	\N
a62e7b20-0112-436c-8881-42d0ccd38a3c	routes	\N
65d74d14-095b-493d-9cb5-d06d1ffd9273	routes	\N
122aadc7-3394-484b-b41c-b15f0b1f6446	routes	\N
9546ea29-91f9-4e2e-9b2c-ba5a5b04dde6	routes	\N
e5077917-ba51-423e-b49b-eacb0e90a059	routes	\N
441a496b-749b-41d6-9ca1-287a5aef2e60	routes	\N
61231e8c-08fa-4cf5-a245-08f07294c91d	routes	\N
afc1e4e7-e275-4def-9670-191eca0bc3d3	routes	\N
b8a95315-e510-471a-ac32-6432577c9b07	routes	\N
a2822658-ef93-446b-805c-6e905c2f5446	routes	\N
3278b5e8-9053-4963-bd52-88d573424287	routes	\N
47852b35-3e95-4eba-8feb-21c55ac7e517	routes	\N
60f06c90-35a3-4d3e-b160-6fe7b199be84	routes	\N
6c8984c8-f75a-4e7b-8fb6-0365d666c77f	routes	\N
afb2540a-96d9-4977-b16e-541b2b323b39	routes	\N
d40e4990-7c0f-47f7-9bb7-ba0d06d781c6	routes	\N
392bcebd-b148-4c22-b62e-667edd71a334	routes	\N
ab26bfb3-8135-4264-8219-ef3cd79827d1	routes	\N
5a41151c-e291-41aa-a7a7-f805a003d797	routes	\N
9437e3d2-800b-4f2c-a9f0-4d6adf02d770	routes	\N
a92a4540-1bf2-480f-ac33-e128eb3a4f27	routes	\N
84ce69fe-b381-49ac-a272-4d313be05bc4	routes	\N
2b6478c5-1e7d-4f82-9a9a-0e2ecf0d8981	routes	\N
02ea84ec-d17f-4aa8-84d6-e62228b7b9ae	routes	\N
b33e198b-0414-4863-afa6-5806135fe5b6	routes	\N
351ef242-5a7c-4af1-b977-4483ce26c715	routes	\N
005bf2cc-2f0e-4ee2-bc7e-6f46af5c12bc	routes	\N
bedb2b5c-c56a-41a8-8a99-99f163715771	routes	\N
795565c4-1f6a-4ef3-a50c-6e3790c754e1	routes	\N
07784385-bba1-40c2-8ccb-9d61eace6a34	routes	\N
04df1f37-1ddd-4ace-a36b-d24eedf2ba42	routes	\N
38a2b9ee-d711-41ca-9e23-8a239ec6edcf	routes	\N
9b274922-4917-4b04-a347-73182e171e0f	routes	\N
03f3458e-6148-4284-a96b-7a95cf1f7cca	routes	\N
8ae90a7e-382f-4e06-adf6-39d7b0b4f479	routes	\N
a7498c97-e10d-4279-b11a-af4123fa0906	routes	\N
9afd54d4-ee71-48d0-8b63-7ab949f47d4c	routes	\N
5a145216-ae7d-4a9b-9f55-e5c31d17e499	routes	\N
1659f4ac-07c3-4f81-a036-c1466e43da27	routes	\N
7ac21ee3-58f2-4a46-bbe0-967409c1cec0	routes	\N
32fd9bf1-e682-4484-9f51-4939b7257a9b	routes	\N
f8cd840e-e7e8-4673-835e-50596a3303c9	routes	\N
9d8bc293-1222-4b0f-9155-5ff415595833	routes	\N
7e0498d5-32e0-4bd1-a6a5-15afb823f4d2	routes	\N
986a7a04-dfd6-4440-b0e2-54e34ad6283d	routes	\N
0bc4d144-aa1d-455d-ae22-c4a61ea053f3	routes	\N
0a50929a-afff-4cfd-841e-ee3cafb9bb76	routes	\N
5e2afce0-e599-41c4-a2e7-f924846d2a3f	routes	\N
e04dd491-224c-4799-96be-1d0e3076ea42	routes	\N
5e031a6f-3854-4bc2-bc4d-6f430d3ffa72	routes	\N
b3b4b26f-a881-4845-86bd-9107a4aa5aef	routes	\N
c1763e07-fbdc-48ee-ab4d-8c5b92b7171c	routes	\N
525e20ba-df0d-4dd2-887d-00813b4793cb	routes	\N
0683e2a3-f1c2-4ed7-ae6b-517504519ad2	routes	\N
49877431-4cbe-4ad5-bc79-94eaf6cbc4a1	routes	\N
147d4143-f710-4a81-8624-f8cbc5ce9981	routes	\N
08df3e0a-7123-4b9b-8277-4f78759b85c0	routes	\N
334b4e04-b58f-44bd-b022-17090ab766e8	routes	\N
38e89493-7448-49e0-8d08-1c2ee333f61c	routes	\N
85f7f517-4278-4287-b5d1-f95084b73d27	routes	\N
0d433130-99ad-4f89-9e4f-ba50d5fe8b55	routes	\N
79ae2040-876f-44b7-ab60-5cfb16acf29a	routes	\N
ba13f6e8-0a4f-44de-b9e2-29e75a041462	routes	\N
a9719902-358a-4735-9297-a07476386086	routes	\N
b34e560c-16b5-4c65-b17e-1ddb344361c3	routes	\N
e7894d9f-a24e-493c-aa30-ddd667c818d9	routes	\N
58456fe3-3368-4ed9-80c6-dabeca36f115	routes	\N
fd0e00de-49c5-4786-9479-39e2855a7a0f	routes	\N
a3b85b92-4808-4fd8-bed5-fc8754ba8b08	routes	\N
8c2972d0-5e6a-44cb-a01b-c1c6d63f5823	routes	\N
02bca5be-184f-4ee2-9e6f-87bc4b1d6077	routes	\N
e6369528-c51c-460d-b727-fec687e64aa8	routes	\N
6bbeadf1-5a3f-46c8-aa76-b3d032f837fd	routes	\N
0982e095-65ae-4287-9591-ac35dc6f15fa	routes	\N
4803e414-98b4-458d-8fe0-ff8ad53ea90a	routes	\N
904b5bbf-cdfa-4e9e-b49c-d22ee3d018f9	routes	\N
c9ad7b54-af23-4f48-ac31-4d9eff03a75f	routes	\N
e4b139d5-9de4-44e5-8dcd-0bd086c34116	routes	\N
1b037f6c-dd5e-45f5-bebe-6135a4fecec4	routes	\N
b48fa915-7c45-418b-b912-d8f570742df5	routes	\N
86499542-d847-4306-b71c-675a1e7018b9	routes	\N
2d0e5ac0-3ef1-452a-9b94-ab228fb421ee	routes	\N
7c114bd8-c398-4065-9429-1fecb6711a02	routes	\N
7e2fe9af-58ca-438f-b207-48f28898a715	routes	\N
316fc6f2-18bc-465f-b1d7-e40cf45e79eb	routes	\N
6c4bb74a-9da1-4d19-8bbe-d53955e3b401	routes	\N
a1107b97-3064-4d04-93c6-e64fd6cb6de8	routes	\N
3218bc95-0859-499c-b602-bc1321b49a26	routes	\N
eaf39de7-68bd-4c07-92c7-713d46797e88	routes	\N
a33e4f58-c4c7-413f-8c0e-ccd2c7ad35a7	routes	\N
376d34f5-14c0-4099-b84d-8a8100fd862d	routes	\N
cb8a87a4-93b6-4462-9317-4f4e167572d0	routes	\N
a55e968e-a9f3-44a3-be81-766ea1ef091f	routes	\N
0a3fc261-1a18-437b-8587-bce5843fa943	routes	\N
49e404dd-79f0-4d15-a34d-4386b38c3154	routes	\N
07ff7564-2c40-4c01-9dad-d7a31a889a1e	routes	\N
92c51093-b8c1-4dbc-9174-1d3677e6c54b	routes	\N
135409c8-6bd5-4daf-8699-73fd1689efd4	routes	\N
8b87ebb8-4a2b-4666-b416-e79fb123a508	routes	\N
1d3315d0-1704-4d6b-9168-8bbb8d86d16b	routes	\N
e5e222cb-b0be-4f1f-8b8a-6814b030a582	routes	\N
9e7bd1df-753c-4707-8219-d8b02005cc57	routes	\N
e342c705-0fcf-45f8-a307-6d5e4a2a0d71	routes	\N
ac3208d8-844a-478b-83e3-795bf4a024d8	routes	\N
37394b46-5ae4-4e91-9461-761a7d4a3565	routes	\N
140af34f-e788-432b-9524-5b633b323527	routes	\N
873f7ce0-b333-40d2-88bb-6b310dce758b	routes	\N
9c356039-7fd9-4697-ab52-2b7e9c60f8ff	routes	\N
df00fb9c-f89f-465d-ad02-dde7aa2bfc0a	routes	\N
a0e19bae-3197-4948-a009-bcd8d6842785	routes	\N
a285237e-274a-45f5-964c-93f35414de5a	routes	\N
8d7810d7-fe86-4ab5-88fc-d6203ae97e32	routes	\N
25a130da-2189-4e6b-9e5e-74d756c07546	routes	\N
de529809-1466-4ebb-bc70-36113ceae7a9	routes	\N
e1768a05-df74-4a2b-8839-3e5192c2a91d	routes	\N
736a564c-2018-4e95-b924-68272043b6e8	routes	\N
c29756d6-3add-415c-9594-33e2a0198420	routes	\N
256169d1-8c25-4cad-856c-b2d67f93126f	services	\N
0d03d838-cf0d-4835-bfe7-4706ad4201f7	routes	\N
1c959e3c-6490-4318-9bff-da0d483f5e1b	plugins	\N
b34e5fb2-eb14-43d3-a79d-39658130032e	plugins	\N
053071fe-258c-4100-aa08-3d63c6efa6ed	plugins	\N
f6def5ad-c6f9-4564-a569-3117932ee238	plugins	\N
67461b9c-ae70-41a8-8bd9-73f802970e84	plugins	\N
b23e2bf4-b802-4824-bd53-dac5cd261330	plugins	\N
4436ced5-8b0a-4264-8153-65f28892d3fc	plugins	\N
f014b0fd-6861-4597-8242-40a0ec6aa407	plugins	\N
f8de5541-046c-431d-a6eb-32005f4e126f	plugins	\N
29bcad9e-cd70-412b-a3a3-bdfb027826ed	plugins	\N
dfbeee4e-4a97-42c0-bb09-bbe302ced383	plugins	\N
eeede7a2-8af0-4620-be48-3c8e9e0e5724	plugins	\N
dc89f9e4-f346-4fcd-9bd7-a196044b267d	plugins	\N
91d6821e-c7e7-4989-88b3-51120599ad5c	plugins	\N
c1a87854-f0f1-46bc-a730-2fa57dfda62a	plugins	\N
756942d0-2d9b-4e8f-b095-db1198df37aa	plugins	\N
beab641f-8cad-48c8-9c21-bec52cf6cb8d	plugins	\N
8dc2c9d9-166b-449b-b94e-36619805c030	plugins	\N
5175240b-821b-4914-ad79-40e746fa9d11	plugins	\N
770c7d2e-1262-4248-9108-d5fbbb04038d	plugins	\N
ca146202-8669-46ed-ba80-430edc369740	plugins	\N
f3b4f782-766a-47d9-9609-cef1dca811b9	plugins	\N
39f7472c-08d1-4584-aedc-0eed01abfa56	plugins	\N
b7c792a5-3f20-46a4-bc9f-4503cd3b9bdd	plugins	\N
ae57e6cc-7f7c-4723-b3fe-2b961cf2e32b	plugins	\N
61d1bbd8-98f6-4a12-a59b-248bbcd20986	plugins	\N
f5b9ca6e-93a1-47a8-bf6a-675ff4a1e130	plugins	\N
16c478ee-3fbe-4160-b8c5-8b9a148bcec9	services	\N
fc5748fe-080f-4d8b-8390-b0ecece0719b	routes	\N
605e0b95-5767-4024-b5de-dab9f650c0c2	plugins	\N
7026cdfe-1b78-47c4-8df2-15fabab122b0	services	\N
6a100bd3-4eb3-4558-9782-72ddf534086a	routes	\N
48e0ca0c-6951-4369-8c02-a3e16f40de03	plugins	\N
36f7c31e-cfb2-4ac9-a1d5-8586b0b5fdac	services	\N
d1f3fc29-5bac-4b3c-86f7-e6c418c035c4	routes	\N
305045f7-853c-4eda-a772-d811027523ed	plugins	\N
fcf23856-9041-4fd9-a6df-f41cdff3103d	services	\N
5df59105-b98b-46ef-8a43-1c5b9113ed43	routes	\N
420dcf51-b036-456d-86ad-969c1243c446	plugins	\N
\.


--
-- Data for Name: targets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.targets (id, created_at, upstream_id, target, weight, tags) FROM stdin;
\.


--
-- Data for Name: ttls; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ttls (primary_key_value, primary_uuid_value, table_name, primary_key_name, expire_at) FROM stdin;
\.


--
-- Data for Name: upstreams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.upstreams (id, created_at, name, hash_on, hash_fallback, hash_on_header, hash_fallback_header, hash_on_cookie, hash_on_cookie_path, slots, healthchecks, tags, algorithm, host_header) FROM stdin;
\.


--
-- Name: acls acls_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_cache_key_key UNIQUE (cache_key);


--
-- Name: acls acls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_pkey PRIMARY KEY (id);


--
-- Name: acme_storage acme_storage_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acme_storage
    ADD CONSTRAINT acme_storage_key_key UNIQUE (key);


--
-- Name: acme_storage acme_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acme_storage
    ADD CONSTRAINT acme_storage_pkey PRIMARY KEY (id);


--
-- Name: basicauth_credentials basicauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: basicauth_credentials basicauth_credentials_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_username_key UNIQUE (username);


--
-- Name: ca_certificates ca_certificates_cert_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ca_certificates
    ADD CONSTRAINT ca_certificates_cert_key UNIQUE (cert);


--
-- Name: ca_certificates ca_certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ca_certificates
    ADD CONSTRAINT ca_certificates_pkey PRIMARY KEY (id);


--
-- Name: certificates certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);


--
-- Name: cluster_events cluster_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cluster_events
    ADD CONSTRAINT cluster_events_pkey PRIMARY KEY (id);


--
-- Name: consumers consumers_custom_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_custom_id_key UNIQUE (custom_id);


--
-- Name: consumers consumers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_pkey PRIMARY KEY (id);


--
-- Name: consumers consumers_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_username_key UNIQUE (username);


--
-- Name: hmacauth_credentials hmacauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: hmacauth_credentials hmacauth_credentials_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_username_key UNIQUE (username);


--
-- Name: jwt_secrets jwt_secrets_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_key_key UNIQUE (key);


--
-- Name: jwt_secrets jwt_secrets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_pkey PRIMARY KEY (id);


--
-- Name: keyauth_credentials keyauth_credentials_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_key_key UNIQUE (key);


--
-- Name: keyauth_credentials keyauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: locks locks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locks
    ADD CONSTRAINT locks_pkey PRIMARY KEY (key);


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_code_key UNIQUE (code);


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_pkey PRIMARY KEY (id);


--
-- Name: oauth2_credentials oauth2_credentials_client_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_client_id_key UNIQUE (client_id);


--
-- Name: oauth2_credentials oauth2_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_pkey PRIMARY KEY (id);


--
-- Name: oauth2_tokens oauth2_tokens_access_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_access_token_key UNIQUE (access_token);


--
-- Name: oauth2_tokens oauth2_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth2_tokens oauth2_tokens_refresh_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_refresh_token_key UNIQUE (refresh_token);


--
-- Name: plugins plugins_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_cache_key_key UNIQUE (cache_key);


--
-- Name: plugins plugins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_pkey PRIMARY KEY (id);


--
-- Name: ratelimiting_metrics ratelimiting_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratelimiting_metrics
    ADD CONSTRAINT ratelimiting_metrics_pkey PRIMARY KEY (identifier, period, period_date, service_id, route_id);


--
-- Name: response_ratelimiting_metrics response_ratelimiting_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.response_ratelimiting_metrics
    ADD CONSTRAINT response_ratelimiting_metrics_pkey PRIMARY KEY (identifier, period, period_date, service_id, route_id);


--
-- Name: routes routes_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_name_key UNIQUE (name);


--
-- Name: routes routes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: schema_meta schema_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_meta
    ADD CONSTRAINT schema_meta_pkey PRIMARY KEY (key, subsystem);


--
-- Name: services services_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_name_key UNIQUE (name);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_session_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_session_id_key UNIQUE (session_id);


--
-- Name: snis snis_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_name_key UNIQUE (name);


--
-- Name: snis snis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (entity_id);


--
-- Name: targets targets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_pkey PRIMARY KEY (id);


--
-- Name: ttls ttls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ttls
    ADD CONSTRAINT ttls_pkey PRIMARY KEY (primary_key_value, table_name);


--
-- Name: upstreams upstreams_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_name_key UNIQUE (name);


--
-- Name: upstreams upstreams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_pkey PRIMARY KEY (id);


--
-- Name: acls_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX acls_consumer_id_idx ON public.acls USING btree (consumer_id);


--
-- Name: acls_group_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX acls_group_idx ON public.acls USING btree ("group");


--
-- Name: acls_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX acls_tags_idex_tags_idx ON public.acls USING gin (tags);


--
-- Name: basicauth_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX basicauth_consumer_id_idx ON public.basicauth_credentials USING btree (consumer_id);


--
-- Name: basicauth_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX basicauth_tags_idex_tags_idx ON public.basicauth_credentials USING gin (tags);


--
-- Name: certificates_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX certificates_tags_idx ON public.certificates USING gin (tags);


--
-- Name: cluster_events_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cluster_events_at_idx ON public.cluster_events USING btree (at);


--
-- Name: cluster_events_channel_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cluster_events_channel_idx ON public.cluster_events USING btree (channel);


--
-- Name: cluster_events_expire_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cluster_events_expire_at_idx ON public.cluster_events USING btree (expire_at);


--
-- Name: consumers_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX consumers_tags_idx ON public.consumers USING gin (tags);


--
-- Name: consumers_username_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX consumers_username_idx ON public.consumers USING btree (lower(username));


--
-- Name: hmacauth_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hmacauth_credentials_consumer_id_idx ON public.hmacauth_credentials USING btree (consumer_id);


--
-- Name: hmacauth_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hmacauth_tags_idex_tags_idx ON public.hmacauth_credentials USING gin (tags);


--
-- Name: jwt_secrets_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jwt_secrets_consumer_id_idx ON public.jwt_secrets USING btree (consumer_id);


--
-- Name: jwt_secrets_secret_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jwt_secrets_secret_idx ON public.jwt_secrets USING btree (secret);


--
-- Name: jwtsecrets_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jwtsecrets_tags_idex_tags_idx ON public.jwt_secrets USING gin (tags);


--
-- Name: keyauth_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX keyauth_credentials_consumer_id_idx ON public.keyauth_credentials USING btree (consumer_id);


--
-- Name: keyauth_credentials_ttl_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX keyauth_credentials_ttl_idx ON public.keyauth_credentials USING btree (ttl);


--
-- Name: keyauth_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX keyauth_tags_idex_tags_idx ON public.keyauth_credentials USING gin (tags);


--
-- Name: locks_ttl_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX locks_ttl_idx ON public.locks USING btree (ttl);


--
-- Name: oauth2_authorization_codes_authenticated_userid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_authorization_codes_authenticated_userid_idx ON public.oauth2_authorization_codes USING btree (authenticated_userid);


--
-- Name: oauth2_authorization_codes_ttl_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_authorization_codes_ttl_idx ON public.oauth2_authorization_codes USING btree (ttl);


--
-- Name: oauth2_authorization_credential_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_authorization_credential_id_idx ON public.oauth2_authorization_codes USING btree (credential_id);


--
-- Name: oauth2_authorization_service_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_authorization_service_id_idx ON public.oauth2_authorization_codes USING btree (service_id);


--
-- Name: oauth2_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_credentials_consumer_id_idx ON public.oauth2_credentials USING btree (consumer_id);


--
-- Name: oauth2_credentials_secret_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_credentials_secret_idx ON public.oauth2_credentials USING btree (client_secret);


--
-- Name: oauth2_credentials_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_credentials_tags_idex_tags_idx ON public.oauth2_credentials USING gin (tags);


--
-- Name: oauth2_tokens_authenticated_userid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_tokens_authenticated_userid_idx ON public.oauth2_tokens USING btree (authenticated_userid);


--
-- Name: oauth2_tokens_credential_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_tokens_credential_id_idx ON public.oauth2_tokens USING btree (credential_id);


--
-- Name: oauth2_tokens_service_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_tokens_service_id_idx ON public.oauth2_tokens USING btree (service_id);


--
-- Name: oauth2_tokens_ttl_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_tokens_ttl_idx ON public.oauth2_tokens USING btree (ttl);


--
-- Name: plugins_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX plugins_consumer_id_idx ON public.plugins USING btree (consumer_id);


--
-- Name: plugins_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX plugins_name_idx ON public.plugins USING btree (name);


--
-- Name: plugins_route_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX plugins_route_id_idx ON public.plugins USING btree (route_id);


--
-- Name: plugins_service_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX plugins_service_id_idx ON public.plugins USING btree (service_id);


--
-- Name: plugins_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX plugins_tags_idx ON public.plugins USING gin (tags);


--
-- Name: ratelimiting_metrics_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ratelimiting_metrics_idx ON public.ratelimiting_metrics USING btree (service_id, route_id, period_date, period);


--
-- Name: routes_service_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX routes_service_id_idx ON public.routes USING btree (service_id);


--
-- Name: routes_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX routes_tags_idx ON public.routes USING gin (tags);


--
-- Name: services_fkey_client_certificate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_fkey_client_certificate ON public.services USING btree (client_certificate_id);


--
-- Name: services_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_tags_idx ON public.services USING gin (tags);


--
-- Name: session_sessions_expires_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_sessions_expires_idx ON public.sessions USING btree (expires);


--
-- Name: snis_certificate_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX snis_certificate_id_idx ON public.snis USING btree (certificate_id);


--
-- Name: snis_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX snis_tags_idx ON public.snis USING gin (tags);


--
-- Name: tags_entity_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tags_entity_name_idx ON public.tags USING btree (entity_name);


--
-- Name: tags_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tags_tags_idx ON public.tags USING gin (tags);


--
-- Name: targets_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX targets_tags_idx ON public.targets USING gin (tags);


--
-- Name: targets_target_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX targets_target_idx ON public.targets USING btree (target);


--
-- Name: targets_upstream_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX targets_upstream_id_idx ON public.targets USING btree (upstream_id);


--
-- Name: ttls_primary_uuid_value_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ttls_primary_uuid_value_idx ON public.ttls USING btree (primary_uuid_value);


--
-- Name: upstreams_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX upstreams_tags_idx ON public.upstreams USING gin (tags);


--
-- Name: acls acls_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER acls_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.acls FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: basicauth_credentials basicauth_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER basicauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.basicauth_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: ca_certificates ca_certificates_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ca_certificates_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.ca_certificates FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: certificates certificates_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER certificates_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.certificates FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: consumers consumers_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consumers_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.consumers FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: hmacauth_credentials hmacauth_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER hmacauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.hmacauth_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: jwt_secrets jwtsecrets_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER jwtsecrets_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.jwt_secrets FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: keyauth_credentials keyauth_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER keyauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.keyauth_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: oauth2_credentials oauth2_credentials_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER oauth2_credentials_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.oauth2_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: plugins plugins_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER plugins_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.plugins FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: routes routes_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER routes_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.routes FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: services services_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER services_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.services FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: snis snis_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER snis_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.snis FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: targets targets_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER targets_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.targets FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: upstreams upstreams_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER upstreams_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.upstreams FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: acls acls_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: basicauth_credentials basicauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: hmacauth_credentials hmacauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: jwt_secrets jwt_secrets_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: keyauth_credentials keyauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_credential_id_fkey FOREIGN KEY (credential_id) REFERENCES public.oauth2_credentials(id) ON DELETE CASCADE;


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: oauth2_credentials oauth2_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: oauth2_tokens oauth2_tokens_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_credential_id_fkey FOREIGN KEY (credential_id) REFERENCES public.oauth2_credentials(id) ON DELETE CASCADE;


--
-- Name: oauth2_tokens oauth2_tokens_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: plugins plugins_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: plugins plugins_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id) ON DELETE CASCADE;


--
-- Name: plugins plugins_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: routes routes_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: services services_client_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_client_certificate_id_fkey FOREIGN KEY (client_certificate_id) REFERENCES public.certificates(id);


--
-- Name: snis snis_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_certificate_id_fkey FOREIGN KEY (certificate_id) REFERENCES public.certificates(id);


--
-- Name: targets targets_upstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_upstream_id_fkey FOREIGN KEY (upstream_id) REFERENCES public.upstreams(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

