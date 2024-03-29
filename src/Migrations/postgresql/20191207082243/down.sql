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

ALTER TABLE ONLY public.task_list DROP CONSTRAINT task_list_status_fkey;
ALTER TABLE ONLY public.task_list DROP CONSTRAINT task_list_project_list_fkey;
ALTER TABLE ONLY public.task_details DROP CONSTRAINT task_details_task_list_fkey;
ALTER TABLE ONLY public.task_details DROP CONSTRAINT task_details_employee_fkey;
ALTER TABLE ONLY public.project_list DROP CONSTRAINT project_list_customer_fkey;
DROP TRIGGER task_list_trigger ON public.task_list;
DROP INDEX public.task_list_status_index;
DROP INDEX public.task_list_project_list_index;
DROP INDEX public.task_list_name_index;
DROP INDEX public.task_details_task_list_index;
DROP INDEX public.task_details_name_index;
DROP INDEX public.task_details_employee_index;
DROP INDEX public.status_name_index;
DROP INDEX public.project_list_project_name_index;
DROP INDEX public.project_list_customer_index;
DROP INDEX public.employee_surname_index;
DROP INDEX public.employee_name_index;
DROP INDEX public.employee_email_index;
DROP INDEX public.customer_name_index;
ALTER TABLE ONLY public.task_list DROP CONSTRAINT task_list_pkey;
ALTER TABLE ONLY public.task_details DROP CONSTRAINT task_details_pkey;
ALTER TABLE ONLY public.status DROP CONSTRAINT status_pkey;
ALTER TABLE ONLY public.project_list DROP CONSTRAINT project_list_pkey;
ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_pkey;
ALTER TABLE ONLY public.customer DROP CONSTRAINT customer_pkey;
DROP TABLE public.task_list;
DROP SEQUENCE public.task_list_id_seq;
DROP TABLE public.task_details;
DROP SEQUENCE public.task_details_id_seq;
DROP TABLE public.status;
DROP SEQUENCE public.status_id_seq;
DROP TABLE public.project_list;
DROP SEQUENCE public.project_list_id_seq;
DROP TABLE public.employee;
DROP SEQUENCE public.employee_id_seq;
DROP TABLE public.customer;
DROP SEQUENCE public.customer_id_seq;
DROP FUNCTION public.task_list_trigger();
DROP FUNCTION public.project_list_percentage(project_list_id integer);
SELECT 'PostgreSQL is happy :)';
