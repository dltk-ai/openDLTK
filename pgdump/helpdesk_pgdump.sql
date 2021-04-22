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

SET default_tablespace = '';

--
-- Name: api_health; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_health (
    id bigint NOT NULL,
    apiname character varying(255),
    apitype integer,
    cronstartdate timestamp without time zone,
    library character varying(255),
    reason character varying(255),
    service character varying(255),
    status integer,
    "timestamp" timestamp without time zone
);


ALTER TABLE public.api_health OWNER TO postgres;

--
-- Name: api_health_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.api_health_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_health_id_generator OWNER TO postgres;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id bigint NOT NULL,
    createddate timestamp without time zone,
    description character varying(255),
    name character varying(255),
    updateddate timestamp without time zone
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
-- Name: email_team; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_team (
    id bigint NOT NULL,
    createdon timestamp without time zone,
    email character varying(255),
    isenabled boolean
);


ALTER TABLE public.email_team OWNER TO postgres;

--
-- Name: email_team_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_team_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_team_id_generator OWNER TO postgres;

--
-- Name: instance_health; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instance_health (
    id bigint NOT NULL,
    cronstartdate timestamp without time zone,
    name character varying(255),
    status integer,
    "timestamp" timestamp without time zone,
    instancetype integer
);


ALTER TABLE public.instance_health OWNER TO postgres;

--
-- Name: instance_health_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instance_health_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instance_health_id_generator OWNER TO postgres;

--
-- Name: instance_health_monitor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instance_health_monitor (
    id bigint NOT NULL,
    isenabled boolean,
    name character varying(255),
    instancetype integer
);


ALTER TABLE public.instance_health_monitor OWNER TO postgres;

--
-- Name: instance_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instance_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instance_id_generator OWNER TO postgres;

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
-- Name: ticket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ticket (
    id bigint NOT NULL,
    assignee character varying(255),
    assigneeid character varying(255),
    attachments jsonb,
    chat jsonb,
    createddate timestamp without time zone NOT NULL,
    description character varying(255),
    owner character varying(255),
    priority integer,
    status integer,
    ticketid character varying(255),
    title character varying(255),
    updateddate timestamp without time zone NOT NULL,
    userid character varying(255),
    category_id bigint
);


ALTER TABLE public.ticket OWNER TO postgres;

--
-- Name: ticket_id_generator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ticket_id_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ticket_id_generator OWNER TO postgres;

--
-- Data for Name: api_health; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_health (id, apiname, apitype, cronstartdate, library, reason, service, status, "timestamp") FROM stdin;
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id, createddate, description, name, updateddate) FROM stdin;
\.


--
-- Data for Name: email_team; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_team (id, createdon, email, isenabled) FROM stdin;
\.


--
-- Data for Name: instance_health; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instance_health (id, cronstartdate, name, status, "timestamp", instancetype) FROM stdin;
\.


--
-- Data for Name: instance_health_monitor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instance_health_monitor (id, isenabled, name, instancetype) FROM stdin;
1	t	MACHINELEARNING-SERVICE	0
2	t	MACHINELEARNING-WEKA-SERVICE	0
3	t	ML-H2O-SERVICE	0
4	t	ML-SCIKIT-SERVICE	0
6	t	LANGUAGE-SERVICE	1
5	t	DLTK-COMPUTER-VISION-SERVICE	2
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
17	K Means Clustering Algorithm	t	weka	KMeansClustering		Clustering
18	Linear Regression Algorithm	t	scikit	LinearRegression	Linear Regression support only numeric classes	Regression
19	Decision Trees Algorithm	t	scikit	DecisionTrees	DecisionTrees support only numeric classes	Regression
20	Bagging Algorithm	t	scikit	Bagging	Bagging support only numeric classes	Regression
21	RandomForest Algorithm	t	scikit	RandomForest	RandomForest support only numeric classes	Regression
22	Gradient Boosting Machines Algorithm	t	scikit	GradientBoostingMachines	GradientBoostingMachines support only numeric classes	Regression
23	X-Gradient Boosting Algorithm	t	scikit	XGradientBoosting	XGradientBoosting support only numeric classes	Regression
24	AdaBoost Algorithm	t	scikit	AdaBoost	AdaBoost support only numeric classes	Regression
25	ExtraTrees Algorithm	t	scikit	ExtraTrees	ExtraTrees support only numeric classes	Regression
26	Support Vector Machines Algorithm	t	scikit	SupportVectorMachines	SupportVectorMachines support only numeric classes	Regression
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
39	K-Means Clustering	t	scikit	KMeansClustering	KMeansClustering support only numeric classes	Clustering
40	DBScan Algorithm	f	scikit	DBScan	\N	Clustering
41	Mini-Batch-KMeans Algorithm	t	scikit	MiniBatchKMeans	 MiniBatchKMeans support only numeric classes	Clustering
42	Birch Algorithm	t	scikit	Birch	 Birch support only numeric classes	Clustering
43	Spectral Clustering	t	scikit	SpectralClustering	 SpectralClustering\t support only numeric classes	Clustering
44	LinearRegression	t	h2o	LinearRegression	 LinearRegression support only numeric classes	Regression
45	Gradient Boosting Machines Algorithm	t	h2o	GradientBoostingMachines	 GradientBoostingMachines support only numeric classes	Regression
46	RandomForest Algorithm	t	h2o	RandomForest	RandomForest support only numeric classes	Regression
47	Naive Bayes Binomial Classification	t	h2o	NaiveBayesBinomial	NaiveBayesBinomial,supports categorical and numeric classes and Target column must be categorical 	Classification
48	Logistic Regression	t	h2o	LogisticRegression	LogisticRegression support only numeric classes	Regression
49	Deep Learning Algorithm	t	h2o	DeepLearning	DeepLearning,supports numeric classes	Classification
50	K-Means Clustering	t	h2o	KMeansClustering	KMeansClustering support only numeric classes	Clustering
\.


--
-- Data for Name: ticket; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket (id, assignee, assigneeid, attachments, chat, createddate, description, owner, priority, status, ticketid, title, updateddate, userid, category_id) FROM stdin;
\.


--
-- Name: algorithm_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.algorithm_id_generator', Max(id), true) from malgorithm;


--
-- Name: api_health_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_health_id_generator', Max(id), true) from api_health;


--
-- Name: category_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_id_generator', Max(id), true) from category;


--
-- Name: email_team_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_team_id_generator', Max(id), true) from email_team;


--
-- Name: instance_health_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instance_health_id_generator', Max(id), true) from instance_health;


--
-- Name: instance_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instance_id_generator', Max(id), true) instance_health_monitor;


--
-- Name: ticket_id_generator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ticket_id_generator', Max(id), true) from ticket;


--
-- Name: api_health api_health_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_health
    ADD CONSTRAINT api_health_pkey PRIMARY KEY (id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: email_team email_team_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_team
    ADD CONSTRAINT email_team_pkey PRIMARY KEY (id);


--
-- Name: instance_health_monitor instance_health_monitor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instance_health_monitor
    ADD CONSTRAINT instance_health_monitor_pkey PRIMARY KEY (id);


--
-- Name: instance_health instance_health_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instance_health
    ADD CONSTRAINT instance_health_pkey PRIMARY KEY (id);


--
-- Name: malgorithm malgorithm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.malgorithm
    ADD CONSTRAINT malgorithm_pkey PRIMARY KEY (id);


--
-- Name: ticket ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (id);


--
-- Name: ticket fk3g2gmlm6p2o4hc5oggcvq51x3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk3g2gmlm6p2o4hc5oggcvq51x3 FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- PostgreSQL database dump complete
--

