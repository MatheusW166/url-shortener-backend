--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7 (Ubuntu 14.7-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.7 (Ubuntu 14.7-0ubuntu0.22.04.1)

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
-- Name: check_visit(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_visit(new_visit_count integer, row_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	previous_visit_count INTEGER;
BEGIN
	previous_visit_count:=(SELECT urls.visit_count FROM urls WHERE urls.id=row_id);
	RETURN new_visit_count = previous_visit_count + 1;
END;
$$;


--
-- Name: increment_visit_count(text); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.increment_visit_count(IN short text)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE urls SET visit_count=visit_count+1 WHERE urls.short_url=short;
	COMMIT;
	
	IF FOUND THEN
		RAISE NOTICE '1 rows affected';
	ELSE 
		RAISE EXCEPTION '0 rows affected';
	END IF;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    token text NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: urls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.urls (
    id integer NOT NULL,
    url text NOT NULL,
    short_url text NOT NULL,
    visit_count integer DEFAULT 0 NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT check_visit_count CHECK (public.check_visit(visit_count, id))
);


--
-- Name: urls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urls_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.urls_id_seq OWNED BY public.urls.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: urls id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urls ALTER COLUMN id SET DEFAULT nextval('public.urls_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sessions VALUES (1, '46f65f84-f47b-4607-b9a5-13828d353401', 15, '2023-05-17 17:36:28.521901');
INSERT INTO public.sessions VALUES (2, '3382131a-8c1c-4e66-8824-fc61a3a9cb0e', 15, '2023-05-17 17:36:45.823471');
INSERT INTO public.sessions VALUES (3, 'edfa6706-eba9-4111-acc8-fcc0a9fcd5e9', 15, '2023-05-17 17:37:23.658032');
INSERT INTO public.sessions VALUES (4, '5c1ff30e-1c63-4ebb-b938-96784b85cc2c', 15, '2023-05-17 17:39:09.474247');
INSERT INTO public.sessions VALUES (8, '29723fc5-0279-4d79-920e-16a626343a45', 15, '2023-05-17 17:47:10.235324');
INSERT INTO public.sessions VALUES (9, 'c02846d2-2f49-448a-82d4-5af29822943f', 15, '2023-05-17 17:48:48.375511');
INSERT INTO public.sessions VALUES (10, '4e16f327-9e98-40e4-82ed-802f9ac69f7e', 15, '2023-05-17 18:01:14.744441');
INSERT INTO public.sessions VALUES (11, '4f76aa96-ac1c-405c-a793-5ca84b8e3a6a', 15, '2023-05-17 18:01:38.684914');
INSERT INTO public.sessions VALUES (12, '6f325567-a239-4dd3-af65-ece00147b56d', 15, '2023-05-17 18:08:28.62604');
INSERT INTO public.sessions VALUES (13, 'c1c304d7-5873-453e-9bdb-a650fa14cec5', 15, '2023-05-17 18:08:45.357577');
INSERT INTO public.sessions VALUES (14, 'a4747b71-e9bf-4014-9354-908e87efcd0c', 15, '2023-05-17 18:51:53.599204');
INSERT INTO public.sessions VALUES (15, 'd029e524-dc1d-4ddf-81b5-b3ecfaf5d595', 15, '2023-05-17 18:52:43.704794');
INSERT INTO public.sessions VALUES (16, 'be365e09-eb26-4c2c-81ac-ead9db42e673', 15, '2023-05-17 18:53:17.95957');
INSERT INTO public.sessions VALUES (17, 'c8d940cb-75bb-44d4-8cc1-292b4b0e3472', 15, '2023-05-17 18:53:52.299579');
INSERT INTO public.sessions VALUES (18, 'bc15577f-c1ed-4742-8015-f46192d429ae', 15, '2023-05-17 18:54:00.108489');
INSERT INTO public.sessions VALUES (19, 'd83b704f-8720-42c3-a6c1-a00814082b69', 15, '2023-05-17 18:54:05.845442');
INSERT INTO public.sessions VALUES (20, '49317372-dc3d-4350-9afc-82be2502b277', 27, '2023-05-17 19:16:56.174546');
INSERT INTO public.sessions VALUES (21, '06373a43-6011-4e83-be86-7edd0e0089c5', 15, '2023-05-17 19:17:41.199178');
INSERT INTO public.sessions VALUES (22, '7da3d2cf-33ef-47df-a061-7385e65cebe8', 27, '2023-05-17 19:28:38.362546');


--
-- Data for Name: urls; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.urls VALUES (8, 'https://google.com', 'uoMEvEy1ok5axAgqbFpFO', 0, 15, '2023-05-17 18:48:56.151847');
INSERT INTO public.urls VALUES (11, 'https://google.com', 'I46Lrueda1FHuTPSe_1_6', 0, 15, '2023-05-17 18:55:18.723646');
INSERT INTO public.urls VALUES (14, 'https://google.com', 'UOtqCnUPRyFAE2uOuTTyK', 0, 15, '2023-05-17 18:55:40.59139');
INSERT INTO public.urls VALUES (7, 'https://google.com', 'oHkVgm2vS_g782PUbUXa3', 7, 15, '2023-05-17 18:46:33.548912');
INSERT INTO public.urls VALUES (13, 'https://google.com', 'UGFGyRSe9uKTOQcLnlMJn', 2, 15, '2023-05-17 18:55:38.438876');
INSERT INTO public.urls VALUES (16, 'https://google.com', 'EJr7ebSMAIme6jeq1e42R', 2, 27, '2023-05-17 19:28:47.098046');
INSERT INTO public.urls VALUES (17, 'https://google.com', 'J2m8EFKL7GvfK11eaJuPq', 1, 27, '2023-05-17 19:28:47.547341');
INSERT INTO public.urls VALUES (15, 'https://google.com', '2WPmdwLBivLjrXYzDOnAN', 6, 27, '2023-05-17 19:28:46.21458');
INSERT INTO public.urls VALUES (18, 'https://google.com', '7Nai8XJAA3QX0EsqpfDpD', 3, 27, '2023-05-17 19:28:47.918198');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES (15, 'Jorgim da Doze', 'jorge@teste.net', '$2b$10$elxTJfVNvBKt/V/iTWKhJeUMJD4ZDQ/AGr6TrAHoaVTPQJCs3LktW', '2023-05-17 17:35:54.280859');
INSERT INTO public.users VALUES (27, 'Matheus Wagner', 'math@teste.net', '$2b$10$te6CeRGoquvCLI5K/ojvyutcnNCUWywNnBysSmE457x3FaQyLsfka', '2023-05-17 18:52:33.892029');


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sessions_id_seq', 22, true);


--
-- Name: urls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.urls_id_seq', 18, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 28, true);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_token_key UNIQUE (token);


--
-- Name: urls urls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urls
    ADD CONSTRAINT urls_pkey PRIMARY KEY (id);


--
-- Name: urls urls_short_url_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urls
    ADD CONSTRAINT urls_short_url_key UNIQUE (short_url);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) NOT VALID;


--
-- Name: urls urls_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urls
    ADD CONSTRAINT urls_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) NOT VALID;


--
-- PostgreSQL database dump complete
--

