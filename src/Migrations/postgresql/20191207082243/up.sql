--
-- PostgreSQL database dump
--

-- Dumped from database version 10.11 (Ubuntu 10.11-1.pgdg18.04+1)
-- Dumped by pg_dump version 10.11 (Ubuntu 10.11-1.pgdg18.04+1)

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
SET search_path = 'public';

--
-- Name: project_list_percentage(integer); Type: FUNCTION; Schema: public; Owner: tmsneek
--

CREATE FUNCTION public.project_list_percentage(project_list_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN

WITH atl AS (
		SELECT COUNT(ptl.id) AS count FROM public.task_list ptl
		INNER JOIN public.status ps ON ptl.status = ps.id
		WHERE ptl.project_list = project_list_id
	), ctl AS (
		SELECT COUNT(ptl.id) AS count FROM public.task_list ptl
		INNER JOIN public.status ps ON ptl.status = ps.id
		WHERE ptl.project_list = project_list_id AND ps.name='Zamknięte'
	)
UPDATE public.project_list ppl SET percentage=(SELECT(((SELECT ctl.count FROM ctl)::float4/(SELECT CASE WHEN atl.count > 0 THEN atl.count ELSE 1 END FROM atl)::float4)*100)::int) WHERE ppl.id=project_list_id;
return project_list_id;
END
$$;


ALTER FUNCTION public.project_list_percentage(project_list_id integer) OWNER TO tmsneek;

--
-- Name: task_list_trigger(); Type: FUNCTION; Schema: public; Owner: tmsneek
--

CREATE FUNCTION public.task_list_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

IF TG_OP='INSERT' THEN
	PERFORM project_list_percentage(new.project_list);
return new;
ELSIF TG_OP='UPDATE' THEN
	PERFORM project_list_percentage(new.project_list);
return new;
ELSIF TG_OP='DELETE' THEN
	PERFORM project_list_percentage(old.project_list);
return old;
ELSE	
	RAISE EXCEPTION 'UNKNOWN TR_OP';
END IF;
END;
$$;


ALTER FUNCTION public.task_list_trigger() OWNER TO tmsneek;

--
-- Name: customer_id_seq; Type: SEQUENCE; Schema: public; Owner: tmsneek
--

CREATE SEQUENCE public.customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_id_seq OWNER TO tmsneek;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: tmsneek
--

CREATE TABLE public.customer (
    id integer DEFAULT nextval('public.customer_id_seq'::regclass) NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.customer OWNER TO tmsneek;

--
-- Name: TABLE customer; Type: COMMENT; Schema: public; Owner: tmsneek
--

COMMENT ON TABLE public.customer IS 'Klienci';


--
-- Name: employee_id_seq; Type: SEQUENCE; Schema: public; Owner: tmsneek
--

CREATE SEQUENCE public.employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_id_seq OWNER TO tmsneek;

--
-- Name: employee; Type: TABLE; Schema: public; Owner: tmsneek
--

CREATE TABLE public.employee (
    id integer DEFAULT nextval('public.employee_id_seq'::regclass) NOT NULL,
    name character varying(64) NOT NULL,
    surname character varying(64) NOT NULL,
    email character varying(64) NOT NULL
);


ALTER TABLE public.employee OWNER TO tmsneek;

--
-- Name: project_list_id_seq; Type: SEQUENCE; Schema: public; Owner: tmsneek
--

CREATE SEQUENCE public.project_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_list_id_seq OWNER TO tmsneek;

--
-- Name: project_list; Type: TABLE; Schema: public; Owner: tmsneek
--

CREATE TABLE public.project_list (
    id integer DEFAULT nextval('public.project_list_id_seq'::regclass) NOT NULL,
    customer integer NOT NULL,
    project_name character varying(32) NOT NULL,
    percentage smallint
);


ALTER TABLE public.project_list OWNER TO tmsneek;

--
-- Name: status_id_seq; Type: SEQUENCE; Schema: public; Owner: tmsneek
--

CREATE SEQUENCE public.status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.status_id_seq OWNER TO tmsneek;

--
-- Name: status; Type: TABLE; Schema: public; Owner: tmsneek
--

CREATE TABLE public.status (
    id integer DEFAULT nextval('public.status_id_seq'::regclass) NOT NULL,
    name character varying(32) NOT NULL,
    priority smallint NOT NULL
);


ALTER TABLE public.status OWNER TO tmsneek;

--
-- Name: task_details_id_seq; Type: SEQUENCE; Schema: public; Owner: tmsneek
--

CREATE SEQUENCE public.task_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_details_id_seq OWNER TO tmsneek;

--
-- Name: task_details; Type: TABLE; Schema: public; Owner: tmsneek
--

CREATE TABLE public.task_details (
    id integer DEFAULT nextval('public.task_details_id_seq'::regclass) NOT NULL,
    task_list integer NOT NULL,
    employee integer NOT NULL,
    name character varying(32) NOT NULL,
    creation_date timestamp without time zone NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.task_details OWNER TO tmsneek;

--
-- Name: task_list_id_seq; Type: SEQUENCE; Schema: public; Owner: tmsneek
--

CREATE SEQUENCE public.task_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_list_id_seq OWNER TO tmsneek;

--
-- Name: task_list; Type: TABLE; Schema: public; Owner: tmsneek
--

CREATE TABLE public.task_list (
    id integer DEFAULT nextval('public.task_list_id_seq'::regclass) NOT NULL,
    project_list integer NOT NULL,
    status integer NOT NULL,
    name character varying(32) NOT NULL,
    creation_date timestamp without time zone NOT NULL,
    priority smallint NOT NULL
);


ALTER TABLE public.task_list OWNER TO tmsneek;

--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: tmsneek
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: tmsneek
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- Name: project_list project_list_pkey; Type: CONSTRAINT; Schema: public; Owner: tmsneek
--

ALTER TABLE ONLY public.project_list
    ADD CONSTRAINT project_list_pkey PRIMARY KEY (id);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: public; Owner: tmsneek
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (id);


--
-- Name: task_details task_details_pkey; Type: CONSTRAINT; Schema: public; Owner: tmsneek
--

ALTER TABLE ONLY public.task_details
    ADD CONSTRAINT task_details_pkey PRIMARY KEY (id);


--
-- Name: task_list task_list_pkey; Type: CONSTRAINT; Schema: public; Owner: tmsneek
--

ALTER TABLE ONLY public.task_list
    ADD CONSTRAINT task_list_pkey PRIMARY KEY (id);


--
-- Name: customer_name_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX customer_name_index ON public.customer USING btree (name);


--
-- Name: employee_email_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX employee_email_index ON public.employee USING btree (email);


--
-- Name: employee_name_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX employee_name_index ON public.employee USING btree (name);


--
-- Name: employee_surname_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX employee_surname_index ON public.employee USING btree (surname);


--
-- Name: project_list_customer_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX project_list_customer_index ON public.project_list USING btree (customer);


--
-- Name: project_list_project_name_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX project_list_project_name_index ON public.project_list USING btree (project_name);


--
-- Name: status_name_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX status_name_index ON public.status USING btree (name);


--
-- Name: task_details_employee_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX task_details_employee_index ON public.task_details USING btree (employee);


--
-- Name: task_details_name_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX task_details_name_index ON public.task_details USING btree (name);


--
-- Name: task_details_task_list_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX task_details_task_list_index ON public.task_details USING btree (task_list);


--
-- Name: task_list_name_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX task_list_name_index ON public.task_list USING btree (name);


--
-- Name: task_list_project_list_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX task_list_project_list_index ON public.task_list USING btree (project_list);


--
-- Name: task_list_status_index; Type: INDEX; Schema: public; Owner: tmsneek
--

CREATE INDEX task_list_status_index ON public.task_list USING btree (status);


--
-- Name: task_list task_list_trigger; Type: TRIGGER; Schema: public; Owner: tmsneek
--

CREATE TRIGGER task_list_trigger AFTER INSERT OR DELETE OR UPDATE ON public.task_list FOR EACH ROW EXECUTE PROCEDURE public.task_list_trigger();


--
-- Name: project_list project_list_customer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmsneek
--

ALTER TABLE ONLY public.project_list
    ADD CONSTRAINT project_list_customer_fkey FOREIGN KEY (customer) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- Name: task_details task_details_employee_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmsneek
--

ALTER TABLE ONLY public.task_details
    ADD CONSTRAINT task_details_employee_fkey FOREIGN KEY (employee) REFERENCES public.employee(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- Name: task_details task_details_task_list_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmsneek
--

ALTER TABLE ONLY public.task_details
    ADD CONSTRAINT task_details_task_list_fkey FOREIGN KEY (task_list) REFERENCES public.task_list(id) NOT VALID;


--
-- Name: task_list task_list_project_list_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmsneek
--

ALTER TABLE ONLY public.task_list
    ADD CONSTRAINT task_list_project_list_fkey FOREIGN KEY (project_list) REFERENCES public.project_list(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- Name: task_list task_list_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmsneek
--

ALTER TABLE ONLY public.task_list
    ADD CONSTRAINT task_list_status_fkey FOREIGN KEY (status) REFERENCES public.status(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: tmsneek
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

SELECT 'PostgreSQL is happy :)';