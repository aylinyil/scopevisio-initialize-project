--
-- PostgreSQL database dump
--

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

SET statement_timeout = 0
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.postcodes DROP CONSTRAINT postcodes_region_id_fkey;
ALTER TABLE ONLY public.application DROP CONSTRAINT fk_postcode;
ALTER TABLE ONLY public.yearly_mileage DROP CONSTRAINT yearly_mileage_pkey;
ALTER TABLE ONLY public.vehicle DROP CONSTRAINT vehicle_vehicle_type_key;
ALTER TABLE ONLY public.vehicle DROP CONSTRAINT vehicle_pkey;
ALTER TABLE ONLY public.regions DROP CONSTRAINT regions_region_key;
ALTER TABLE ONLY public.regions DROP CONSTRAINT regions_pkey;
ALTER TABLE ONLY public.postcodes DROP CONSTRAINT postcodes_postcode_key;
ALTER TABLE ONLY public.postcodes DROP CONSTRAINT postcodes_pkey;
ALTER TABLE ONLY public.application DROP CONSTRAINT application_pkey;
ALTER TABLE public.yearly_mileage ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.vehicle ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.regions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.postcodes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.application ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.yearly_mileage_id_seq;
DROP TABLE public.yearly_mileage;
DROP SEQUENCE public.vehicle_id_seq;
DROP TABLE public.vehicle;
DROP SEQUENCE public.regions_id_seq;
DROP TABLE public.regions;
DROP SEQUENCE public.postcodes_id_seq;
DROP TABLE public.postcodes;
DROP SEQUENCE public.application_id_seq;
DROP TABLE public.application;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: application; Type: TABLE; Schema: public; Owner: postgres_user
--

CREATE TABLE public.application (
    id integer NOT NULL,
    postcode character varying(5) NOT NULL,
    yearly_mileage integer NOT NULL,
    vehicle_type character varying(50) NOT NULL,
    calculated_premium numeric NOT NULL
);


ALTER TABLE public.application OWNER TO postgres_user;

--
-- Name: application_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres_user
--

CREATE SEQUENCE public.application_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.application_id_seq OWNER TO postgres_user;

--
-- Name: application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres_user
--

ALTER SEQUENCE public.application_id_seq OWNED BY public.application.id;

--
-- Name: postcodes; Type: TABLE; Schema: public; Owner: postgres_user
--

CREATE TABLE public.postcodes (
    id integer NOT NULL,
    postcode character varying(10) NOT NULL,
    region_id integer
);


ALTER TABLE public.postcodes OWNER TO postgres_user;

--
-- Name: postcodes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres_user
--

CREATE SEQUENCE public.postcodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.postcodes_id_seq OWNER TO postgres_user;

--
-- Name: postcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres_user
--

ALTER SEQUENCE public.postcodes_id_seq OWNED BY public.postcodes.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres_user
--

CREATE TABLE public.regions (
    id integer NOT NULL,
    region character varying(255) NOT NULL,
    region_factor numeric NOT NULL
);


ALTER TABLE public.regions OWNER TO postgres_user;

--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres_user
--

CREATE SEQUENCE public.regions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.regions_id_seq OWNER TO postgres_user;

--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres_user
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: vehicle; Type: TABLE; Schema: public; Owner: postgres_user
--

CREATE TABLE public.vehicle (
    id integer NOT NULL,
    vehicle_type text,
    vehicle_factor numeric
);


ALTER TABLE public.vehicle OWNER TO postgres_user;

--
-- Name: vehicle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres_user
--

CREATE SEQUENCE public.vehicle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vehicle_id_seq OWNER TO postgres_user;

--
-- Name: vehicle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres_user
--

ALTER SEQUENCE public.vehicle_id_seq OWNED BY public.vehicle.id;


--
-- Name: yearly_mileage; Type: TABLE; Schema: public; Owner: postgres_user
--

CREATE TABLE public.yearly_mileage (
    id integer NOT NULL,
    yearly_mileage_from integer NOT NULL,
    yearly_mileage_to numeric,
    yearly_mileage_factor real NOT NULL
);


ALTER TABLE public.yearly_mileage OWNER TO postgres_user;

--
-- Name: yearly_mileage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres_user
--

CREATE SEQUENCE public.yearly_mileage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.yearly_mileage_id_seq OWNER TO postgres_user;

--
-- Name: yearly_mileage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres_user
--

ALTER SEQUENCE public.yearly_mileage_id_seq OWNED BY public.yearly_mileage.id;


--
-- Name: application id; Type: DEFAULT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.application ALTER COLUMN id SET DEFAULT nextval('public.application_id_seq'::regclass);

--
-- Name: postcodes id; Type: DEFAULT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.postcodes ALTER COLUMN id SET DEFAULT nextval('public.postcodes_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: vehicle id; Type: DEFAULT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.vehicle ALTER COLUMN id SET DEFAULT nextval('public.vehicle_id_seq'::regclass);


--
-- Name: yearly_mileage id; Type: DEFAULT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.yearly_mileage ALTER COLUMN id SET DEFAULT nextval('public.yearly_mileage_id_seq'::regclass);


--
-- Data for Name: application; Type: TABLE DATA; Schema: public; Owner: postgres_user
--

COPY public.application (id, postcode, yearly_mileage, vehicle_type, calculated_premium) FROM stdin;
\.

--
-- Data for Name: postcodes; Type: TABLE DATA; Schema: public; Owner: postgres_user
--

COPY public.postcodes (id, postcode, region_id) FROM stdin;
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres_user
--

COPY public.regions (id, region, region_factor) FROM stdin;
\.


--
-- Data for Name: vehicle; Type: TABLE DATA; Schema: public; Owner: postgres_user
--

COPY public.vehicle (id, vehicle_type, vehicle_factor) FROM stdin;
\.


--
-- Data for Name: yearly_mileage; Type: TABLE DATA; Schema: public; Owner: postgres_user
--

COPY public.yearly_mileage (id, yearly_mileage_from, yearly_mileage_to, yearly_mileage_factor) FROM stdin;
\.


--
-- Name: application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres_user
--

SELECT pg_catalog.setval('public.application_id_seq', 1, false);

--
-- Name: postcodes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres_user
--

SELECT pg_catalog.setval('public.postcodes_id_seq', 1, false);


--
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres_user
--

SELECT pg_catalog.setval('public.regions_id_seq', 1, false);


--
-- Name: vehicle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres_user
--

SELECT pg_catalog.setval('public.vehicle_id_seq', 1, false);


--
-- Name: yearly_mileage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres_user
--

SELECT pg_catalog.setval('public.yearly_mileage_id_seq', 1, false);


--
-- Name: application application_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_pkey PRIMARY KEY (id);

-
-- Name: postcodes postcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.postcodes
    ADD CONSTRAINT postcodes_pkey PRIMARY KEY (id);


--
-- Name: postcodes postcodes_postcode_key; Type: CONSTRAINT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.postcodes
    ADD CONSTRAINT postcodes_postcode_key UNIQUE (postcode);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: regions regions_region_key; Type: CONSTRAINT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_region_key UNIQUE (region);


--
-- Name: vehicle vehicle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.vehicle
    ADD CONSTRAINT vehicle_pkey PRIMARY KEY (id);


--
-- Name: vehicle vehicle_vehicle_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.vehicle
    ADD CONSTRAINT vehicle_vehicle_type_key UNIQUE (vehicle_type);


--
-- Name: yearly_mileage yearly_mileage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.yearly_mileage
    ADD CONSTRAINT yearly_mileage_pkey PRIMARY KEY (id);

--
-- Name: postcodes postcodes_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres_user
--

ALTER TABLE ONLY public.postcodes
    ADD CONSTRAINT postcodes_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- PostgreSQL database dump complete
--


