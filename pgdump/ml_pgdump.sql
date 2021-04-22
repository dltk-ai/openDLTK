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
-- Name: algorithm_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.algorithm_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.algorithm_id_generator OWNER TO postgres;

--
-- Name: automate_job_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.automate_job_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.automate_job_id_generator OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: data_source; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_source (
    id bigint NOT NULL,
    auto_run_queries boolean,
    createddate timestamp without time zone NOT NULL,
    dbid bigint,
    details jsonb,
    engine integer,
    is_full_sync boolean,
    is_on_demand boolean,
    name character varying(255),
    schedules jsonb,
    userid bigint
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
-- Name: job_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.job_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.job_id_generator OWNER TO postgres;

--
-- Name: library_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.library_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_id_generator OWNER TO postgres;

--
-- Name: malgorithm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.malgorithm (
    id bigint NOT NULL,
    description character varying(255),
    enabled boolean,
    library character varying(255),
    name character varying(255),
    prerequisite character varying(255),
    service character varying(255)
);


ALTER TABLE public.malgorithm OWNER TO postgres;

--
-- Name: mautomatejob; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mautomatejob (
    id bigint NOT NULL,
    appid bigint,
    config jsonb,
    cronexpression character varying(255),
    datetimecolumn character varying(255),
    frequency character varying(255),
    jobstate integer,
    jobtype integer,
    library character varying(255),
    metadata jsonb,
    modelid bigint,
    queryid character varying(255),
    service integer,
    starttime timestamp without time zone,
    task integer,
    userid bigint
);


ALTER TABLE public.mautomatejob OWNER TO postgres;

--
-- Name: mjob; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mjob (
    jobid bigint NOT NULL,
    appid bigint,
    automatejobid bigint,
    endtime timestamp without time zone,
    isjobstopped boolean,
    isstreamjob boolean DEFAULT false,
    jobtype integer DEFAULT 0,
    library character varying(255),
    msg character varying(255),
    name character varying(255),
    queryid character varying(255),
    request jsonb,
    service integer,
    starttime timestamp without time zone,
    state integer,
    task integer,
    userid bigint
);


ALTER TABLE public.mjob OWNER TO postgres;

--
-- Name: mlibrary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mlibrary (
    id bigint NOT NULL,
    contextpath character varying(255),
    createddate timestamp without time zone NOT NULL,
    enabled boolean,
    name character varying(255),
    servicename character varying(255),
    updateddate timestamp without time zone NOT NULL
);


ALTER TABLE public.mlibrary OWNER TO postgres;

--
-- Name: moutput; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moutput (
    id bigint NOT NULL,
    jobid bigint,
    output jsonb
);


ALTER TABLE public.moutput OWNER TO postgres;

--
-- Name: msourcecode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.msourcecode (
    id bigint NOT NULL,
    code character varying(500),
    createddate timestamp without time zone NOT NULL,
    library character varying(255),
    name character varying(255),
    service integer,
    task integer,
    updateddate timestamp without time zone NOT NULL
);


ALTER TABLE public.msourcecode OWNER TO postgres;

--
-- Name: mwebhookjob; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mwebhookjob (
    id bigint NOT NULL,
    createdtime timestamp without time zone,
    modelid bigint,
    predictionid bigint
);


ALTER TABLE public.mwebhookjob OWNER TO postgres;

--
-- Name: response_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.response_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.response_id_generator OWNER TO postgres;

--
-- Name: source_code_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.source_code_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.source_code_id_generator OWNER TO postgres;

--
-- Name: webhook_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.webhook_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.webhook_id_generator OWNER TO postgres;

--
-- Data for Name: data_source; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_source (id, auto_run_queries, createddate, dbid, details, engine, is_full_sync, is_on_demand, name, schedules, userid) FROM stdin;
\.


--
-- Data for Name: malgorithm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.malgorithm (id, description, enabled, library, name, prerequisite, service) FROM stdin;
1	Logistic Classification Algorithm	t	weka	Logistic	Logistic classification do not support numeric classes. Please provide only non-numeric classes in the dataset.	Classification
2	MultilayerPerceptron Classification Algorithm	t	weka	MultilayerPerceptron	MultilayerPerceptron classification supports both numeric class & multi class datases.	Classification
3	NaiveBayesMultinomial Classification Algorithm	t	weka	NaiveBayesMultinomial	NaiveBayesMultinomial classification do not support nominal values in classes. Please provide only non-nominal classes in the dataset.	Classification
4	RandomForest Classification Algorithm	t	weka	RandomForest	RandomForest classification supports both numeric class & multi class datases	Classification
5	LibSVM Classification Algorithm	t	weka	LibSVM	LibSVM classification do not support numeric classes. Please provide only non-numeric classes in the dataset.	Classification
6	AdaBoostM1 Classification Algorithm	t	weka	AdaBoostM1	AdaBoostM1 classification do not support numeric classes. Please provide only non-numeric classes in the dataset.	Classification
7	AttributeSelectedClassifier Classification Algorithm	t	weka	AttributeSelectedClassifier	AttributeSelectedClassifier do not support numeric classes. Please provide only non-numeric classes in the dataset.	Classification
8	Bagging Classification Algorithm	t	weka	Bagging	Bagging classification supports both numeric class & multi class datases.	Classification
9	CostSensitiveClassifier Classification Algorithm	t	weka	CostSensitiveClassifier	CostSensitiveClassifier classification supports both numeric class & multi class datases.	Classification
10	DecisionTable Classification Algorithm	t	weka	DecisionTable	DecisionTable classification supports both numeric class & multi class datases.	Classification
11	GaussianProcesses Classification Algorithm	t	weka	GaussianProcesses	GaussianProcesses classification supports both numeric class & multi class datases.	Classification
12	IBk Classification Algorithm	t	weka	IBk	IBk classification supports both numeric class & multi class datases.	Classification
13	RandomTree Classification Algorithm	t	weka	RandomTree	RandomTree classification supports both numeric class & multi class datases.	Classification
14	SMO Classification Algorithm	t	weka	SMO	SMO classification do not support numeric classes. Please provide only non-numeric classes in the dataset.	Classification
15	LinearRegression Algorithm	t	weka	LinearRegression	LinearRegression supports discrete values in label field in the dataset.	Regression
16	AdditiveRegression Algorithm	t	weka	AdditiveRegression	AdditiveRegression supports discrete values in label field in the dataset.	Regression
19	Decision Trees Algorithm	t	scikit	DecisionTrees	DecisionTrees support only numeric classes	Regression
22	Gradient Boosting Machines Algorithm	t	scikit	GradientBoostingMachines	GradientBoostingMachines support only numeric classes	Regression
23	X-Gradient Boosting Algorithm	t	scikit	XGradientBoosting	XGradientBoosting support only numeric classes	Regression
24	AdaBoost Algorithm	t	scikit	AdaBoost	AdaBoost support only numeric classes	Regression
26	Support Vector Machines Algorithm	t	scikit	SupportVectorMachines	SupportVectorMachines support only numeric classes	Regression
50	K-Means Clustering	t	h2o	KMeansClustering	KMeansClustering support only numeric classes	Clustering
17	K Means Clustering Algorithm	t	weka	KMeansClustering		Clustering
25	ExtraTrees Algorithm	t	scikit	ExtraTrees	ExtraTrees support only numeric classes	Regression
40	DBScan Algorithm	f	scikit	DBScan	\N	Clustering
20	Bagging Algorithm	t	scikit	Bagging	Bagging support only numeric classes	Regression
21	RandomForest Algorithm	t	scikit	RandomForest	RandomForest support only numeric classes	Regression
18	Linear Regression Algorithm	t	scikit	LinearRegression	Linear Regression support only numeric classes	Regression
27	Naive Bayes Multinomial Algorithm	t	scikit	NaiveBayesMultinomial	NaiveBayesMultinomial support only numeric classes 	Classification
28	Logistic Regression Algorithm	t	scikit	LogisticRegression	LogisticRegression support only numeric classes	Classification
29	Decision Trees Algorithm	t	scikit	DecisionTrees	DecisionTrees support only numeric classes	Classification
30	Bagging Algorithm	t	scikit	Bagging	Bagging support only numeric classes	Classification
31	RandomForest Algorithm	t	scikit	RandomForest	RandomForest support only numeric classes	Classification
32	Gradient Boosting Machines Algorithm	t	scikit	GradientBoostingMachines	GradientBoostingMachines support only numeric classes	Classification
33	X-Gradient Boosting Algorithm	t	scikit	XGradientBoosting	XGradientBoosting support only numeric classes	Classification
34	AdaBoost Algorithm	t	scikit	AdaBoost	AdaBoost support only numeric classes	Classification
35	Extra Trees Algorithm	t	scikit	ExtraTrees	ExtraTrees support only numeric classes	Classification
36	Support Vector Machines Algorithm	t	scikit	SupportVectorMachines	SupportVectorMachines support only numeric classes	Classification
37	KNearestNeighbour Algorithm	t	scikit	KNearestNeighbour	KNearestNeighbour  support only numeric classes	Classification
38	Agglomerative Clustering	t	scikit	AgglomerativeClustering	 AgglomerativeClustering support only numeric classes	Clustering
41	Mini-Batch-KMeans Algorithm	t	scikit	MiniBatchKMeans	 MiniBatchKMeans support only numeric classes	Clustering
42	Birch Algorithm	t	scikit	Birch	 Birch support only numeric classes	Clustering
43	Spectral Clustering	t	scikit	SpectralClustering	 SpectralClustering\t support only numeric classes	Clustering
44	LinearRegression	t	h2o	LinearRegression	 LinearRegression support only numeric classes	Regression
46	RandomForest Algorithm	t	h2o	RandomForest	RandomForest support only numeric classes	Regression
39	K-Means Clustering	t	scikit	KMeansClustering	KMeansClustering support only numeric classes	Clustering
45	Gradient Boosting Machines Algorithm	t	h2o	GradientBoostingMachines	 GradientBoostingMachines support only numeric classes	Regression
48	Logistic Regression	t	h2o	LogisticRegression	LogisticRegression support only numeric classes	Regression
47	Naive Bayes Binomial Classification	t	h2o	NaiveBayesBinomial	NaiveBayesBinomial,supports categorical and numeric classes and Target column must be categorical 	Classification
49	Deep Learning Algorithm	t	h2o	DeepLearning	DeepLearning,supports numeric classes	Classification
\.


--
-- Data for Name: mautomatejob; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mautomatejob (id, appid, config, cronexpression, datetimecolumn, frequency, jobstate, jobtype, library, metadata, modelid, queryid, service, starttime, task, userid) FROM stdin;
\.


--
-- Data for Name: mjob; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mjob (jobid, appid, automatejobid, endtime, isjobstopped, isstreamjob, jobtype, library, msg, name, queryid, request, service, starttime, state, task, userid) FROM stdin;
\.


--
-- Data for Name: mlibrary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mlibrary (id, contextpath, createddate, enabled, name, servicename, updateddate) FROM stdin;
1	dltk-machinelearning/h2o	2019-02-20 15:24:37.672	t	h2o	ml-h2o-service	2019-02-20 15:24:37.672
2	dltk-machinelearning/scikit	2019-02-20 15:24:37.695	t	scikit	ml-scikit-service	2019-02-20 15:24:37.695
3	dltk-machinelearning/weka	2019-02-20 15:24:37.701	t	weka	machinelearning-weka-service	2019-02-20 15:24:37.701
4	dltk-machinelearning/weka	2019-02-20 15:24:37.706	t	dltk	machinelearning-weka-service	2019-02-20 15:24:37.706
5	dltk-timeseries-statsmodels	2019-02-20 15:24:37.706	f	statsmodels	ml-statsmodels-service	2019-02-20 15:24:37.706
\.


--
-- Data for Name: moutput; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moutput (id, jobid, output) FROM stdin;
\.


--
-- Data for Name: msourcecode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.msourcecode (id, code, createddate, library, name, service, task, updateddate) FROM stdin;
\.


--
-- Data for Name: mwebhookjob; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mwebhookjob (id, createdtime, modelid, predictionid) FROM stdin;
\.


--
-- Name: algorithm_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.algorithm_id_generator', Max(id), true) from malgorithm;


--
-- Name: automate_job_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.automate_job_id_generator', Max(id), true) from mautomatejob;


--
-- Name: data_source_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.data_source_id_generator', Max(id), true) from data_source;


--
-- Name: job_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_id_generator', Max(jobId), true) from mjob;


--
-- Name: library_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.library_id_generator', Max(id), true) from mlibrary;


--
-- Name: response_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.response_id_generator', Max(id), true) from moutput;


--
-- Name: source_code_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.source_code_id_generator', Max(id), true) from msourcecode;


--
-- Name: webhook_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.webhook_id_generator', Max(id), true) from mwebhookjob;


--
-- Name: data_source data_source_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source
    ADD CONSTRAINT data_source_pkey PRIMARY KEY (id);


--
-- Name: malgorithm malgorithm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.malgorithm
    ADD CONSTRAINT malgorithm_pkey PRIMARY KEY (id);


--
-- Name: mautomatejob mautomatejob_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mautomatejob
    ADD CONSTRAINT mautomatejob_pkey PRIMARY KEY (id);


--
-- Name: mjob mjob_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mjob
    ADD CONSTRAINT mjob_pkey PRIMARY KEY (jobid);


--
-- Name: mlibrary mlibrary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mlibrary
    ADD CONSTRAINT mlibrary_pkey PRIMARY KEY (id);


--
-- Name: moutput moutput_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moutput
    ADD CONSTRAINT moutput_pkey PRIMARY KEY (id);


--
-- Name: msourcecode msourcecode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msourcecode
    ADD CONSTRAINT msourcecode_pkey PRIMARY KEY (id);


--
-- Name: mwebhookjob mwebhookjob_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mwebhookjob
    ADD CONSTRAINT mwebhookjob_pkey PRIMARY KEY (id);


--
-- Name: moutput uk_c3e6jwjcm9s0itnafftjnidfd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moutput
    ADD CONSTRAINT uk_c3e6jwjcm9s0itnafftjnidfd UNIQUE (jobid);


--
-- Name: mwebhookjob uk_gmmr1bt1skfkys731su1ehf5w; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mwebhookjob
    ADD CONSTRAINT uk_gmmr1bt1skfkys731su1ehf5w UNIQUE (modelid);


--
-- PostgreSQL database dump complete
--

