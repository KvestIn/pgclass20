--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hypopg; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hypopg WITH SCHEMA public;


--
-- Name: EXTENSION hypopg; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hypopg IS 'Hypothetical indexes for PostgreSQL';


--
-- Name: pg_buffercache; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_buffercache WITH SCHEMA public;


--
-- Name: EXTENSION pg_buffercache; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_buffercache IS 'examine the shared buffer cache';


--
-- Name: pg_prewarm; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_prewarm WITH SCHEMA public;


--
-- Name: EXTENSION pg_prewarm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_prewarm IS 'prewarm relation data';


--
-- Name: pgstattuple; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgstattuple WITH SCHEMA public;


--
-- Name: EXTENSION pgstattuple; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgstattuple IS 'show tuple-level statistics';


SET search_path = public, pg_catalog;

--
-- Name: mchar; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE mchar;


--
-- Name: mchar_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_in(cstring) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_in';


ALTER FUNCTION public.mchar_in(cstring) OWNER TO postgres;

--
-- Name: mchar_out(mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_out(mchar) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_out';


ALTER FUNCTION public.mchar_out(mchar) OWNER TO postgres;

--
-- Name: mchar_recv(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_recv(internal) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_recv';


ALTER FUNCTION public.mchar_recv(internal) OWNER TO postgres;

--
-- Name: mchar_send(mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_send(mchar) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_send';


ALTER FUNCTION public.mchar_send(mchar) OWNER TO postgres;

--
-- Name: mchartypmod_in(cstring[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchartypmod_in(cstring[]) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchartypmod_in';


ALTER FUNCTION public.mchartypmod_in(cstring[]) OWNER TO postgres;

--
-- Name: mchartypmod_out(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchartypmod_out(integer) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchartypmod_out';


ALTER FUNCTION public.mchartypmod_out(integer) OWNER TO postgres;

--
-- Name: mchar; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE mchar (
    INTERNALLENGTH = variable,
    INPUT = mchar_in,
    OUTPUT = mchar_out,
    RECEIVE = mchar_recv,
    SEND = mchar_send,
    TYPMOD_IN = mchartypmod_in,
    TYPMOD_OUT = mchartypmod_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


ALTER TYPE mchar OWNER TO postgres;

--
-- Name: mvarchar; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE mvarchar;


--
-- Name: mvarchar_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_in(cstring) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_in';


ALTER FUNCTION public.mvarchar_in(cstring) OWNER TO postgres;

--
-- Name: mvarchar_out(mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_out(mvarchar) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_out';


ALTER FUNCTION public.mvarchar_out(mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_recv(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_recv(internal) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_recv';


ALTER FUNCTION public.mvarchar_recv(internal) OWNER TO postgres;

--
-- Name: mvarchar_send(mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_send(mvarchar) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_send';


ALTER FUNCTION public.mvarchar_send(mvarchar) OWNER TO postgres;

--
-- Name: mvarchar; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE mvarchar (
    INTERNALLENGTH = variable,
    INPUT = mvarchar_in,
    OUTPUT = mvarchar_out,
    RECEIVE = mvarchar_recv,
    SEND = mvarchar_send,
    TYPMOD_IN = mchartypmod_in,
    TYPMOD_OUT = mchartypmod_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


ALTER TYPE mvarchar OWNER TO postgres;

--
-- Name: binrowver(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION binrowver(p1 integer) RETURNS bytea
    LANGUAGE plpgsql
    AS $$
 DECLARE
 bytearea BYTEA;
 BEGIN
 bytearea := SET_BYTE('\\000\\000\\000\\000\\000\\000\\000\\000'::bytea, 4, MOD(P1 / 16777216, 256));
 bytearea := SET_BYTE(bytearea, 5, MOD(P1 / 65536, 256));
 bytearea := SET_BYTE(bytearea, 6, MOD(P1 / 256, 256));
 bytearea := SET_BYTE(bytearea, 7, MOD(P1, 256));
 RETURN bytearea;
 END;$$;


ALTER FUNCTION public.binrowver(p1 integer) OWNER TO postgres;

--
-- Name: btrim(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btrim(bdata bytea, blen integer) RETURNS bytea
    LANGUAGE plpgsql
    AS $$
   DECLARE
       ln int;
       res bytea;
   BEGIN
       ln := length(bdata);
       if ln < blen then
          res := bdata;
          for i in ln .. blen - 1
          loop
               res := res || '\\000';
          end loop;
          return res;
       elsif ln > blen then
          return substring(bdata from 1 for blen);
       else
          return bdata;
       end if;
  END;$$;


ALTER FUNCTION public.btrim(bdata bytea, blen integer) OWNER TO postgres;

--
-- Name: datediff(character varying, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION datediff(character varying, timestamp without time zone, timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
    DECLARE
     arg_mode alias for $1;
     arg_d2 alias for $2;
     arg_d1 alias for $3;
    BEGIN
    if arg_mode = 'SECOND' then
     return date_part('epoch',arg_d1) - date_part('epoch',arg_d2) ;
    elsif arg_mode = 'MINUTE' then
     return floor((date_part('epoch',arg_d1) - date_part('epoch',arg_d2)) / 60);
    elsif arg_mode = 'HOUR' then
     return floor((date_part('epoch',arg_d1) - date_part('epoch',arg_d2)) /3600);
    elsif arg_mode = 'DAY' then
     return cast(arg_d1 as date) - cast(arg_d2 as date);
    elsif arg_mode = 'WEEK' then
            return floor( ( cast(arg_d1 as date) - cast(arg_d2 as date) ) / 7.0);
    elsif arg_mode = 'MONTH' then
     return 12 * (date_part('year',arg_d1) - date_part('year',arg_d2))
          + date_part('month',arg_d1) - date_part('month',arg_d2);
    elsif arg_mode = 'QUARTER' then
     return 4 * (date_part('year',arg_d1) - date_part('year',arg_d2))
          + date_part('quarter',arg_d1) - date_part('quarter',arg_d2);
    elsif arg_mode = 'YEAR' then
     return (date_part('year',arg_d1) - date_part('year',arg_d2));
   end if;
    END
    $_$;


ALTER FUNCTION public.datediff(character varying, timestamp without time zone, timestamp without time zone) OWNER TO postgres;

--
-- Name: fasttruncate(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fasttruncate(text) RETURNS void
    LANGUAGE c STRICT
    AS '$libdir/fasttrun', 'fasttruncate';


ALTER FUNCTION public.fasttruncate(text) OWNER TO postgres;

--
-- Name: fullhash_abstime(abstime); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_abstime(abstime) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_abstime';


ALTER FUNCTION public.fullhash_abstime(abstime) OWNER TO postgres;

--
-- Name: fullhash_bool(boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_bool(boolean) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_bool';


ALTER FUNCTION public.fullhash_bool(boolean) OWNER TO postgres;

--
-- Name: fullhash_bytea(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_bytea(bytea) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_bytea';


ALTER FUNCTION public.fullhash_bytea(bytea) OWNER TO postgres;

--
-- Name: fullhash_char(character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_char(character) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_char';


ALTER FUNCTION public.fullhash_char(character) OWNER TO postgres;

--
-- Name: fullhash_cid(cid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_cid(cid) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_cid';


ALTER FUNCTION public.fullhash_cid(cid) OWNER TO postgres;

--
-- Name: fullhash_cidr(cidr); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_cidr(cidr) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_cidr';


ALTER FUNCTION public.fullhash_cidr(cidr) OWNER TO postgres;

--
-- Name: fullhash_date(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_date(date) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_date';


ALTER FUNCTION public.fullhash_date(date) OWNER TO postgres;

--
-- Name: fullhash_float4(real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_float4(real) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_float4';


ALTER FUNCTION public.fullhash_float4(real) OWNER TO postgres;

--
-- Name: fullhash_float8(double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_float8(double precision) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_float8';


ALTER FUNCTION public.fullhash_float8(double precision) OWNER TO postgres;

--
-- Name: fullhash_inet(inet); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_inet(inet) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_inet';


ALTER FUNCTION public.fullhash_inet(inet) OWNER TO postgres;

--
-- Name: fullhash_int2(smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_int2(smallint) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_int2';


ALTER FUNCTION public.fullhash_int2(smallint) OWNER TO postgres;

--
-- Name: fullhash_int2vector(int2vector); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_int2vector(int2vector) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_int2vector';


ALTER FUNCTION public.fullhash_int2vector(int2vector) OWNER TO postgres;

--
-- Name: fullhash_int4(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_int4(integer) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_int4';


ALTER FUNCTION public.fullhash_int4(integer) OWNER TO postgres;

--
-- Name: fullhash_int8(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_int8(bigint) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_int8';


ALTER FUNCTION public.fullhash_int8(bigint) OWNER TO postgres;

--
-- Name: fullhash_interval(interval); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_interval(interval) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_interval';


ALTER FUNCTION public.fullhash_interval(interval) OWNER TO postgres;

--
-- Name: fullhash_macaddr(macaddr); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_macaddr(macaddr) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_macaddr';


ALTER FUNCTION public.fullhash_macaddr(macaddr) OWNER TO postgres;

--
-- Name: fullhash_mchar(mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_mchar(mchar) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/mchar', 'fullhash_mchar';


ALTER FUNCTION public.fullhash_mchar(mchar) OWNER TO postgres;

--
-- Name: fullhash_mvarchar(mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_mvarchar(mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/mchar', 'fullhash_mvarchar';


ALTER FUNCTION public.fullhash_mvarchar(mvarchar) OWNER TO postgres;

--
-- Name: fullhash_name(name); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_name(name) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_name';


ALTER FUNCTION public.fullhash_name(name) OWNER TO postgres;

--
-- Name: fullhash_oid(oid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_oid(oid) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_oid';


ALTER FUNCTION public.fullhash_oid(oid) OWNER TO postgres;

--
-- Name: fullhash_oidvector(oidvector); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_oidvector(oidvector) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_oidvector';


ALTER FUNCTION public.fullhash_oidvector(oidvector) OWNER TO postgres;

--
-- Name: fullhash_reltime(reltime); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_reltime(reltime) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_reltime';


ALTER FUNCTION public.fullhash_reltime(reltime) OWNER TO postgres;

--
-- Name: fullhash_text(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_text(text) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_text';


ALTER FUNCTION public.fullhash_text(text) OWNER TO postgres;

--
-- Name: fullhash_time(time without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_time(time without time zone) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_time';


ALTER FUNCTION public.fullhash_time(time without time zone) OWNER TO postgres;

--
-- Name: fullhash_timestamp(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_timestamp(timestamp without time zone) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_timestamp';


ALTER FUNCTION public.fullhash_timestamp(timestamp without time zone) OWNER TO postgres;

--
-- Name: fullhash_timestamptz(timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_timestamptz(timestamp with time zone) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_timestamptz';


ALTER FUNCTION public.fullhash_timestamptz(timestamp with time zone) OWNER TO postgres;

--
-- Name: fullhash_timetz(time with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_timetz(time with time zone) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_timetz';


ALTER FUNCTION public.fullhash_timetz(time with time zone) OWNER TO postgres;

--
-- Name: fullhash_varchar(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_varchar(character varying) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_varchar';


ALTER FUNCTION public.fullhash_varchar(character varying) OWNER TO postgres;

--
-- Name: fullhash_xid(xid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fullhash_xid(xid) RETURNS integer
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'fullhash_xid';


ALTER FUNCTION public.fullhash_xid(xid) OWNER TO postgres;

--
-- Name: isfulleq_abstime(abstime, abstime); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_abstime(abstime, abstime) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_abstime';


ALTER FUNCTION public.isfulleq_abstime(abstime, abstime) OWNER TO postgres;

--
-- Name: isfulleq_bool(boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_bool(boolean, boolean) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_bool';


ALTER FUNCTION public.isfulleq_bool(boolean, boolean) OWNER TO postgres;

--
-- Name: isfulleq_bytea(bytea, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_bytea(bytea, bytea) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_bytea';


ALTER FUNCTION public.isfulleq_bytea(bytea, bytea) OWNER TO postgres;

--
-- Name: isfulleq_char(character, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_char(character, character) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_char';


ALTER FUNCTION public.isfulleq_char(character, character) OWNER TO postgres;

--
-- Name: isfulleq_cid(cid, cid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_cid(cid, cid) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_cid';


ALTER FUNCTION public.isfulleq_cid(cid, cid) OWNER TO postgres;

--
-- Name: isfulleq_cidr(cidr, cidr); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_cidr(cidr, cidr) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_cidr';


ALTER FUNCTION public.isfulleq_cidr(cidr, cidr) OWNER TO postgres;

--
-- Name: isfulleq_date(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_date(date, date) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_date';


ALTER FUNCTION public.isfulleq_date(date, date) OWNER TO postgres;

--
-- Name: isfulleq_float4(real, real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_float4(real, real) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_float4';


ALTER FUNCTION public.isfulleq_float4(real, real) OWNER TO postgres;

--
-- Name: isfulleq_float8(double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_float8(double precision, double precision) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_float8';


ALTER FUNCTION public.isfulleq_float8(double precision, double precision) OWNER TO postgres;

--
-- Name: isfulleq_inet(inet, inet); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_inet(inet, inet) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_inet';


ALTER FUNCTION public.isfulleq_inet(inet, inet) OWNER TO postgres;

--
-- Name: isfulleq_int2(smallint, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_int2(smallint, smallint) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_int2';


ALTER FUNCTION public.isfulleq_int2(smallint, smallint) OWNER TO postgres;

--
-- Name: isfulleq_int2vector(int2vector, int2vector); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_int2vector(int2vector, int2vector) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_int2vector';


ALTER FUNCTION public.isfulleq_int2vector(int2vector, int2vector) OWNER TO postgres;

--
-- Name: isfulleq_int4(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_int4(integer, integer) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_int4';


ALTER FUNCTION public.isfulleq_int4(integer, integer) OWNER TO postgres;

--
-- Name: isfulleq_int8(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_int8(bigint, bigint) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_int8';


ALTER FUNCTION public.isfulleq_int8(bigint, bigint) OWNER TO postgres;

--
-- Name: isfulleq_interval(interval, interval); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_interval(interval, interval) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_interval';


ALTER FUNCTION public.isfulleq_interval(interval, interval) OWNER TO postgres;

--
-- Name: isfulleq_macaddr(macaddr, macaddr); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_macaddr(macaddr, macaddr) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_macaddr';


ALTER FUNCTION public.isfulleq_macaddr(macaddr, macaddr) OWNER TO postgres;

--
-- Name: isfulleq_mchar(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_mchar(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/mchar', 'isfulleq_mchar';


ALTER FUNCTION public.isfulleq_mchar(mchar, mchar) OWNER TO postgres;

--
-- Name: isfulleq_mvarchar(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_mvarchar(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/mchar', 'isfulleq_mvarchar';


ALTER FUNCTION public.isfulleq_mvarchar(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: isfulleq_name(name, name); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_name(name, name) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_name';


ALTER FUNCTION public.isfulleq_name(name, name) OWNER TO postgres;

--
-- Name: isfulleq_oid(oid, oid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_oid(oid, oid) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_oid';


ALTER FUNCTION public.isfulleq_oid(oid, oid) OWNER TO postgres;

--
-- Name: isfulleq_oidvector(oidvector, oidvector); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_oidvector(oidvector, oidvector) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_oidvector';


ALTER FUNCTION public.isfulleq_oidvector(oidvector, oidvector) OWNER TO postgres;

--
-- Name: isfulleq_reltime(reltime, reltime); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_reltime(reltime, reltime) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_reltime';


ALTER FUNCTION public.isfulleq_reltime(reltime, reltime) OWNER TO postgres;

--
-- Name: isfulleq_text(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_text(text, text) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_text';


ALTER FUNCTION public.isfulleq_text(text, text) OWNER TO postgres;

--
-- Name: isfulleq_time(time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_time(time without time zone, time without time zone) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_time';


ALTER FUNCTION public.isfulleq_time(time without time zone, time without time zone) OWNER TO postgres;

--
-- Name: isfulleq_timestamp(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_timestamp(timestamp without time zone, timestamp without time zone) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_timestamp';


ALTER FUNCTION public.isfulleq_timestamp(timestamp without time zone, timestamp without time zone) OWNER TO postgres;

--
-- Name: isfulleq_timestamptz(timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_timestamptz(timestamp with time zone, timestamp with time zone) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_timestamptz';


ALTER FUNCTION public.isfulleq_timestamptz(timestamp with time zone, timestamp with time zone) OWNER TO postgres;

--
-- Name: isfulleq_timetz(time with time zone, time with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_timetz(time with time zone, time with time zone) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_timetz';


ALTER FUNCTION public.isfulleq_timetz(time with time zone, time with time zone) OWNER TO postgres;

--
-- Name: isfulleq_varchar(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_varchar(character varying, character varying) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_varchar';


ALTER FUNCTION public.isfulleq_varchar(character varying, character varying) OWNER TO postgres;

--
-- Name: isfulleq_xid(xid, xid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isfulleq_xid(xid, xid) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/fulleq', 'isfulleq_xid';


ALTER FUNCTION public.isfulleq_xid(xid, xid) OWNER TO postgres;

--
-- Name: length(mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length(mchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_length';


ALTER FUNCTION public.length(mchar) OWNER TO postgres;

--
-- Name: length(mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length(mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_length';


ALTER FUNCTION public.length(mvarchar) OWNER TO postgres;

--
-- Name: like_escape(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION like_escape(mvarchar, mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_like_escape';


ALTER FUNCTION public.like_escape(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: lower(mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lower(mchar) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_lower';


ALTER FUNCTION public.lower(mchar) OWNER TO postgres;

--
-- Name: lower(mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lower(mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_lower';


ALTER FUNCTION public.lower(mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_case_cmp(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_case_cmp(mchar, mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_cmp';


ALTER FUNCTION public.mc_mv_case_cmp(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_case_eq(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_case_eq(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_eq';


ALTER FUNCTION public.mc_mv_case_eq(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_case_ge(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_case_ge(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_ge';


ALTER FUNCTION public.mc_mv_case_ge(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_case_gt(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_case_gt(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_gt';


ALTER FUNCTION public.mc_mv_case_gt(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_case_le(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_case_le(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_le';


ALTER FUNCTION public.mc_mv_case_le(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_case_lt(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_case_lt(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_lt';


ALTER FUNCTION public.mc_mv_case_lt(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_case_ne(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_case_ne(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_case_ne';


ALTER FUNCTION public.mc_mv_case_ne(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_icase_cmp(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_icase_cmp(mchar, mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_cmp';


ALTER FUNCTION public.mc_mv_icase_cmp(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_icase_eq(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_icase_eq(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_eq';


ALTER FUNCTION public.mc_mv_icase_eq(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_icase_ge(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_icase_ge(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_ge';


ALTER FUNCTION public.mc_mv_icase_ge(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_icase_gt(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_icase_gt(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_gt';


ALTER FUNCTION public.mc_mv_icase_gt(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_icase_le(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_icase_le(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_le';


ALTER FUNCTION public.mc_mv_icase_le(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_icase_lt(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_icase_lt(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_lt';


ALTER FUNCTION public.mc_mv_icase_lt(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mc_mv_icase_ne(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mc_mv_icase_ne(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mc_mv_icase_ne';


ALTER FUNCTION public.mc_mv_icase_ne(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mchar(mchar, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar(mchar, integer, boolean) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar';


ALTER FUNCTION public.mchar(mchar, integer, boolean) OWNER TO postgres;

--
-- Name: mchar_case_cmp(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_case_cmp(mchar, mchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_cmp';


ALTER FUNCTION public.mchar_case_cmp(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_case_eq(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_case_eq(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_eq';


ALTER FUNCTION public.mchar_case_eq(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_case_ge(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_case_ge(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_ge';


ALTER FUNCTION public.mchar_case_ge(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_case_gt(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_case_gt(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_gt';


ALTER FUNCTION public.mchar_case_gt(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_case_le(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_case_le(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_le';


ALTER FUNCTION public.mchar_case_le(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_case_lt(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_case_lt(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_lt';


ALTER FUNCTION public.mchar_case_lt(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_case_ne(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_case_ne(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_case_ne';


ALTER FUNCTION public.mchar_case_ne(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_concat(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_concat(mchar, mchar) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_concat';


ALTER FUNCTION public.mchar_concat(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_greaterstring(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_greaterstring(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_greaterstring';


ALTER FUNCTION public.mchar_greaterstring(internal) OWNER TO postgres;

--
-- Name: mchar_hash(mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_hash(mchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_hash';


ALTER FUNCTION public.mchar_hash(mchar) OWNER TO postgres;

--
-- Name: mchar_icase_cmp(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_icase_cmp(mchar, mchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_cmp';


ALTER FUNCTION public.mchar_icase_cmp(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_icase_eq(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_icase_eq(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_eq';


ALTER FUNCTION public.mchar_icase_eq(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_icase_ge(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_icase_ge(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_ge';


ALTER FUNCTION public.mchar_icase_ge(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_icase_gt(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_icase_gt(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_gt';


ALTER FUNCTION public.mchar_icase_gt(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_icase_le(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_icase_le(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_le';


ALTER FUNCTION public.mchar_icase_le(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_icase_lt(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_icase_lt(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_lt';


ALTER FUNCTION public.mchar_icase_lt(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_icase_ne(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_icase_ne(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_icase_ne';


ALTER FUNCTION public.mchar_icase_ne(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_larger(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_larger(mchar, mchar) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_larger';


ALTER FUNCTION public.mchar_larger(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_like(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_like(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_like';


ALTER FUNCTION public.mchar_like(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mchar_mvarchar(mchar, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_mvarchar(mchar, integer, boolean) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_mvarchar';


ALTER FUNCTION public.mchar_mvarchar(mchar, integer, boolean) OWNER TO postgres;

--
-- Name: mchar_mvarchar_concat(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_mvarchar_concat(mchar, mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_mvarchar_concat';


ALTER FUNCTION public.mchar_mvarchar_concat(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mchar_notlike(mchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_notlike(mchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_notlike';


ALTER FUNCTION public.mchar_notlike(mchar, mvarchar) OWNER TO postgres;

--
-- Name: mchar_pattern_fixed_prefix(internal, internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_pattern_fixed_prefix(internal, internal, internal, internal) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_pattern_fixed_prefix';


ALTER FUNCTION public.mchar_pattern_fixed_prefix(internal, internal, internal, internal) OWNER TO postgres;

--
-- Name: mchar_regexeq(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_regexeq(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_regexeq';


ALTER FUNCTION public.mchar_regexeq(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_regexne(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_regexne(mchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_regexne';


ALTER FUNCTION public.mchar_regexne(mchar, mchar) OWNER TO postgres;

--
-- Name: mchar_smaller(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mchar_smaller(mchar, mchar) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_smaller';


ALTER FUNCTION public.mchar_smaller(mchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_case_cmp(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_case_cmp(mvarchar, mchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_cmp';


ALTER FUNCTION public.mv_mc_case_cmp(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_case_eq(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_case_eq(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_eq';


ALTER FUNCTION public.mv_mc_case_eq(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_case_ge(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_case_ge(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_ge';


ALTER FUNCTION public.mv_mc_case_ge(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_case_gt(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_case_gt(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_gt';


ALTER FUNCTION public.mv_mc_case_gt(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_case_le(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_case_le(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_le';


ALTER FUNCTION public.mv_mc_case_le(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_case_lt(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_case_lt(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_lt';


ALTER FUNCTION public.mv_mc_case_lt(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_case_ne(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_case_ne(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_case_ne';


ALTER FUNCTION public.mv_mc_case_ne(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_icase_cmp(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_icase_cmp(mvarchar, mchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_cmp';


ALTER FUNCTION public.mv_mc_icase_cmp(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_icase_eq(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_icase_eq(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_eq';


ALTER FUNCTION public.mv_mc_icase_eq(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_icase_ge(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_icase_ge(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_ge';


ALTER FUNCTION public.mv_mc_icase_ge(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_icase_gt(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_icase_gt(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_gt';


ALTER FUNCTION public.mv_mc_icase_gt(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_icase_le(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_icase_le(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_le';


ALTER FUNCTION public.mv_mc_icase_le(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_icase_lt(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_icase_lt(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_lt';


ALTER FUNCTION public.mv_mc_icase_lt(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mv_mc_icase_ne(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mv_mc_icase_ne(mvarchar, mchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mv_mc_icase_ne';


ALTER FUNCTION public.mv_mc_icase_ne(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mvarchar(mvarchar, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar(mvarchar, integer, boolean) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar';


ALTER FUNCTION public.mvarchar(mvarchar, integer, boolean) OWNER TO postgres;

--
-- Name: mvarchar_case_cmp(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_case_cmp(mvarchar, mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_cmp';


ALTER FUNCTION public.mvarchar_case_cmp(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_case_eq(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_case_eq(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_eq';


ALTER FUNCTION public.mvarchar_case_eq(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_case_ge(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_case_ge(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_ge';


ALTER FUNCTION public.mvarchar_case_ge(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_case_gt(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_case_gt(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_gt';


ALTER FUNCTION public.mvarchar_case_gt(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_case_le(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_case_le(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_le';


ALTER FUNCTION public.mvarchar_case_le(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_case_lt(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_case_lt(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_lt';


ALTER FUNCTION public.mvarchar_case_lt(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_case_ne(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_case_ne(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_case_ne';


ALTER FUNCTION public.mvarchar_case_ne(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_concat(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_concat(mvarchar, mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_concat';


ALTER FUNCTION public.mvarchar_concat(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_hash(mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_hash(mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_hash';


ALTER FUNCTION public.mvarchar_hash(mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_icase_cmp(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_icase_cmp(mvarchar, mvarchar) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_cmp';


ALTER FUNCTION public.mvarchar_icase_cmp(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_icase_eq(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_icase_eq(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_eq';


ALTER FUNCTION public.mvarchar_icase_eq(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_icase_ge(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_icase_ge(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_ge';


ALTER FUNCTION public.mvarchar_icase_ge(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_icase_gt(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_icase_gt(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_gt';


ALTER FUNCTION public.mvarchar_icase_gt(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_icase_le(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_icase_le(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_le';


ALTER FUNCTION public.mvarchar_icase_le(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_icase_lt(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_icase_lt(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_lt';


ALTER FUNCTION public.mvarchar_icase_lt(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_icase_ne(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_icase_ne(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_icase_ne';


ALTER FUNCTION public.mvarchar_icase_ne(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_larger(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_larger(mvarchar, mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_larger';


ALTER FUNCTION public.mvarchar_larger(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_like(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_like(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_like';


ALTER FUNCTION public.mvarchar_like(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_mchar(mvarchar, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_mchar(mvarchar, integer, boolean) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_mchar';


ALTER FUNCTION public.mvarchar_mchar(mvarchar, integer, boolean) OWNER TO postgres;

--
-- Name: mvarchar_mchar_concat(mvarchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_mchar_concat(mvarchar, mchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_mchar_concat';


ALTER FUNCTION public.mvarchar_mchar_concat(mvarchar, mchar) OWNER TO postgres;

--
-- Name: mvarchar_notlike(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_notlike(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_notlike';


ALTER FUNCTION public.mvarchar_notlike(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_regexeq(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_regexeq(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_regexeq';


ALTER FUNCTION public.mvarchar_regexeq(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_regexne(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_regexne(mvarchar, mvarchar) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_regexne';


ALTER FUNCTION public.mvarchar_regexne(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: mvarchar_smaller(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mvarchar_smaller(mvarchar, mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_smaller';


ALTER FUNCTION public.mvarchar_smaller(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: plpgsql_call_handler(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION plpgsql_call_handler() RETURNS language_handler
    LANGUAGE c
    AS '$libdir/plpgsql', 'plpgsql_call_handler';


ALTER FUNCTION public.plpgsql_call_handler() OWNER TO postgres;

--
-- Name: similar_escape(mchar, mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION similar_escape(mchar, mchar) RETURNS mchar
    LANGUAGE c IMMUTABLE
    AS '$libdir/mchar', 'mchar_similar_escape';


ALTER FUNCTION public.similar_escape(mchar, mchar) OWNER TO postgres;

--
-- Name: similar_escape(mvarchar, mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION similar_escape(mvarchar, mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE
    AS '$libdir/mchar', 'mvarchar_similar_escape';


ALTER FUNCTION public.similar_escape(mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: state_max_bool(boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION state_max_bool(st boolean, inp boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    BEGIN
         if st is null or not st
         then
            return inp;
         else
            return true;
         end if;
    END;$$;


ALTER FUNCTION public.state_max_bool(st boolean, inp boolean) OWNER TO postgres;

--
-- Name: state_max_bytea(bytea, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION state_max_bytea(st bytea, inp bytea) RETURNS bytea
    LANGUAGE plpgsql
    AS $$
    BEGIN
         if st is null
         then
            return inp;
         elseif st<inp then
            return inp;
         else
            return st;
         end if;
    END;$$;


ALTER FUNCTION public.state_max_bytea(st bytea, inp bytea) OWNER TO postgres;

--
-- Name: state_min_bool(boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION state_min_bool(st boolean, inp boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    BEGIN
         if st is null or st
             then
            return inp;
         else
            return false;
            end if;
    END;$$;


ALTER FUNCTION public.state_min_bool(st boolean, inp boolean) OWNER TO postgres;

--
-- Name: state_min_bytea(bytea, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION state_min_bytea(st bytea, inp bytea) RETURNS bytea
    LANGUAGE plpgsql
    AS $$
    BEGIN
         if st is null
         then
            return inp;
         elseif st>inp then
            return inp;
         else
            return st;
         end if;
    END;$$;


ALTER FUNCTION public.state_min_bytea(st bytea, inp bytea) OWNER TO postgres;

--
-- Name: substr(mchar, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION substr(mchar, integer) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_substring_no_len';


ALTER FUNCTION public.substr(mchar, integer) OWNER TO postgres;

--
-- Name: substr(mvarchar, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION substr(mvarchar, integer) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_substring_no_len';


ALTER FUNCTION public.substr(mvarchar, integer) OWNER TO postgres;

--
-- Name: substr(mchar, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION substr(mchar, integer, integer) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_substring';


ALTER FUNCTION public.substr(mchar, integer, integer) OWNER TO postgres;

--
-- Name: substr(mvarchar, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION substr(mvarchar, integer, integer) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_substring';


ALTER FUNCTION public.substr(mvarchar, integer, integer) OWNER TO postgres;

--
-- Name: upper(mchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION upper(mchar) RETURNS mchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mchar_upper';


ALTER FUNCTION public.upper(mchar) OWNER TO postgres;

--
-- Name: upper(mvarchar); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION upper(mvarchar) RETURNS mvarchar
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/mchar', 'mvarchar_upper';


ALTER FUNCTION public.upper(mvarchar) OWNER TO postgres;

--
-- Name: vassn(boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION vassn(boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE bexpr alias for $1;
BEGIN
if bexpr
then return 0;
else return 2000000000;
end if;
END
$_$;


ALTER FUNCTION public.vassn(boolean) OWNER TO postgres;

--
-- Name: max(boolean); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE max(boolean) (
    SFUNC = state_max_bool,
    STYPE = boolean
);


ALTER AGGREGATE public.max(boolean) OWNER TO postgres;

--
-- Name: max(bytea); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE max(bytea) (
    SFUNC = state_max_bytea,
    STYPE = bytea
);


ALTER AGGREGATE public.max(bytea) OWNER TO postgres;

--
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = mchar_icase_gt,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (mchar, mchar) OWNER TO postgres;

--
-- Name: max(mchar); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE max(mchar) (
    SFUNC = mchar_larger,
    STYPE = mchar,
    SORTOP = >
);


ALTER AGGREGATE public.max(mchar) OWNER TO postgres;

--
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = mvarchar_icase_gt,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: max(mvarchar); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE max(mvarchar) (
    SFUNC = mvarchar_larger,
    STYPE = mvarchar,
    SORTOP = >
);


ALTER AGGREGATE public.max(mvarchar) OWNER TO postgres;

--
-- Name: min(boolean); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE min(boolean) (
    SFUNC = state_min_bool,
    STYPE = boolean
);


ALTER AGGREGATE public.min(boolean) OWNER TO postgres;

--
-- Name: min(bytea); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE min(bytea) (
    SFUNC = state_min_bytea,
    STYPE = bytea
);


ALTER AGGREGATE public.min(bytea) OWNER TO postgres;

--
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = mchar_icase_lt,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (mchar, mchar) OWNER TO postgres;

--
-- Name: min(mchar); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE min(mchar) (
    SFUNC = mchar_smaller,
    STYPE = mchar,
    SORTOP = <
);


ALTER AGGREGATE public.min(mchar) OWNER TO postgres;

--
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = mvarchar_icase_lt,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: min(mvarchar); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE min(mvarchar) (
    SFUNC = mvarchar_smaller,
    STYPE = mvarchar,
    SORTOP = <
);


ALTER AGGREGATE public.min(mvarchar) OWNER TO postgres;

--
-- Name: !~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR !~ (
    PROCEDURE = mchar_regexne,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    NEGATOR = ~,
    RESTRICT = regexnesel,
    JOIN = regexnejoinsel
);


ALTER OPERATOR public.!~ (mchar, mchar) OWNER TO postgres;

--
-- Name: !~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR !~ (
    PROCEDURE = mvarchar_regexne,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    NEGATOR = ~,
    RESTRICT = regexnesel,
    JOIN = regexnejoinsel
);


ALTER OPERATOR public.!~ (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: !~~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR !~~ (
    PROCEDURE = mchar_notlike,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    NEGATOR = ~~,
    RESTRICT = nlikesel,
    JOIN = nlikejoinsel
);


ALTER OPERATOR public.!~~ (mchar, mvarchar) OWNER TO postgres;

--
-- Name: !~~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR !~~ (
    PROCEDURE = mvarchar_notlike,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    NEGATOR = ~~,
    RESTRICT = nlikesel,
    JOIN = nlikejoinsel
);


ALTER OPERATOR public.!~~ (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: &<; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &< (
    PROCEDURE = mchar_case_lt,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = &>,
    NEGATOR = &>=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.&< (mchar, mchar) OWNER TO postgres;

--
-- Name: &<; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &< (
    PROCEDURE = mvarchar_case_lt,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &>,
    NEGATOR = &>=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.&< (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: &<; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &< (
    PROCEDURE = mc_mv_case_lt,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &>,
    NEGATOR = &>=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.&< (mchar, mvarchar) OWNER TO postgres;

--
-- Name: &<; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &< (
    PROCEDURE = mv_mc_case_lt,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = &>,
    NEGATOR = &>=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.&< (mvarchar, mchar) OWNER TO postgres;

--
-- Name: &<=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &<= (
    PROCEDURE = mchar_case_le,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = &>=,
    NEGATOR = &>,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.&<= (mchar, mchar) OWNER TO postgres;

--
-- Name: &<=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &<= (
    PROCEDURE = mvarchar_case_le,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &>=,
    NEGATOR = &>,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.&<= (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: &<=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &<= (
    PROCEDURE = mc_mv_case_le,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &>=,
    NEGATOR = &>,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.&<= (mchar, mvarchar) OWNER TO postgres;

--
-- Name: &<=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &<= (
    PROCEDURE = mv_mc_case_le,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = &>=,
    NEGATOR = &>,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.&<= (mvarchar, mchar) OWNER TO postgres;

--
-- Name: &<>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &<> (
    PROCEDURE = mchar_case_ne,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = &<>,
    NEGATOR = &=,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.&<> (mchar, mchar) OWNER TO postgres;

--
-- Name: &<>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &<> (
    PROCEDURE = mvarchar_case_ne,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &<>,
    NEGATOR = &=,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.&<> (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: &<>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &<> (
    PROCEDURE = mc_mv_case_ne,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &<>,
    NEGATOR = &=,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.&<> (mchar, mvarchar) OWNER TO postgres;

--
-- Name: &<>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &<> (
    PROCEDURE = mv_mc_case_ne,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = &<>,
    NEGATOR = &=,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.&<> (mvarchar, mchar) OWNER TO postgres;

--
-- Name: &=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &= (
    PROCEDURE = mchar_case_eq,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = &=,
    NEGATOR = &<>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.&= (mchar, mchar) OWNER TO postgres;

--
-- Name: &=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &= (
    PROCEDURE = mvarchar_case_eq,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &=,
    NEGATOR = &<>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.&= (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: &=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &= (
    PROCEDURE = mv_mc_case_eq,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = &=,
    NEGATOR = &<>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.&= (mvarchar, mchar) OWNER TO postgres;

--
-- Name: &=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &= (
    PROCEDURE = mc_mv_case_eq,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &=,
    NEGATOR = &<>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.&= (mchar, mvarchar) OWNER TO postgres;

--
-- Name: &>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &> (
    PROCEDURE = mchar_case_gt,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = &<,
    NEGATOR = &<=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.&> (mchar, mchar) OWNER TO postgres;

--
-- Name: &>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &> (
    PROCEDURE = mvarchar_case_gt,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &<,
    NEGATOR = &<=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.&> (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: &>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &> (
    PROCEDURE = mv_mc_case_gt,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = &<,
    NEGATOR = &<=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.&> (mvarchar, mchar) OWNER TO postgres;

--
-- Name: &>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &> (
    PROCEDURE = mc_mv_case_gt,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &<,
    NEGATOR = &<=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.&> (mchar, mvarchar) OWNER TO postgres;

--
-- Name: &>=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &>= (
    PROCEDURE = mchar_case_ge,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = &<=,
    NEGATOR = &<,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.&>= (mchar, mchar) OWNER TO postgres;

--
-- Name: &>=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &>= (
    PROCEDURE = mvarchar_case_ge,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &<=,
    NEGATOR = &<,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.&>= (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: &>=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &>= (
    PROCEDURE = mc_mv_case_ge,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = &<=,
    NEGATOR = &<,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.&>= (mchar, mvarchar) OWNER TO postgres;

--
-- Name: &>=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &>= (
    PROCEDURE = mv_mc_case_ge,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = &<=,
    NEGATOR = &<,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.&>= (mvarchar, mchar) OWNER TO postgres;

--
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = mc_mv_icase_lt,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (mchar, mvarchar) OWNER TO postgres;

--
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = mv_mc_icase_lt,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (mvarchar, mchar) OWNER TO postgres;

--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = mchar_icase_le,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (mchar, mchar) OWNER TO postgres;

--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = mvarchar_icase_le,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = mc_mv_icase_le,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (mchar, mvarchar) OWNER TO postgres;

--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = mv_mc_icase_le,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (mvarchar, mchar) OWNER TO postgres;

--
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = mchar_icase_ne,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (mchar, mchar) OWNER TO postgres;

--
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = mvarchar_icase_ne,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = mc_mv_icase_ne,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (mchar, mvarchar) OWNER TO postgres;

--
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = mv_mc_icase_ne,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (mvarchar, mchar) OWNER TO postgres;

--
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = mchar_icase_eq,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (mchar, mchar) OWNER TO postgres;

--
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = mvarchar_icase_eq,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = mv_mc_icase_eq,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (mvarchar, mchar) OWNER TO postgres;

--
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = mc_mv_icase_eq,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (mchar, mvarchar) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_bool,
    LEFTARG = boolean,
    RIGHTARG = boolean,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (boolean, boolean) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_bytea,
    LEFTARG = bytea,
    RIGHTARG = bytea,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (bytea, bytea) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_char,
    LEFTARG = character,
    RIGHTARG = character,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (character, character) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_name,
    LEFTARG = name,
    RIGHTARG = name,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (name, name) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_int8,
    LEFTARG = bigint,
    RIGHTARG = bigint,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (bigint, bigint) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_int2,
    LEFTARG = smallint,
    RIGHTARG = smallint,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (smallint, smallint) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_int2vector,
    LEFTARG = int2vector,
    RIGHTARG = int2vector,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (int2vector, int2vector) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_int4,
    LEFTARG = integer,
    RIGHTARG = integer,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (integer, integer) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_text,
    LEFTARG = text,
    RIGHTARG = text,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (text, text) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_oid,
    LEFTARG = oid,
    RIGHTARG = oid,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (oid, oid) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_xid,
    LEFTARG = xid,
    RIGHTARG = xid,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (xid, xid) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_cid,
    LEFTARG = cid,
    RIGHTARG = cid,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (cid, cid) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_oidvector,
    LEFTARG = oidvector,
    RIGHTARG = oidvector,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (oidvector, oidvector) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_float4,
    LEFTARG = real,
    RIGHTARG = real,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (real, real) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_float8,
    LEFTARG = double precision,
    RIGHTARG = double precision,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (double precision, double precision) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_abstime,
    LEFTARG = abstime,
    RIGHTARG = abstime,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (abstime, abstime) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_reltime,
    LEFTARG = reltime,
    RIGHTARG = reltime,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (reltime, reltime) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_macaddr,
    LEFTARG = macaddr,
    RIGHTARG = macaddr,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (macaddr, macaddr) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_inet,
    LEFTARG = inet,
    RIGHTARG = inet,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (inet, inet) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_cidr,
    LEFTARG = cidr,
    RIGHTARG = cidr,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (cidr, cidr) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_varchar,
    LEFTARG = character varying,
    RIGHTARG = character varying,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (character varying, character varying) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_date,
    LEFTARG = date,
    RIGHTARG = date,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (date, date) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_time,
    LEFTARG = time without time zone,
    RIGHTARG = time without time zone,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (time without time zone, time without time zone) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_timestamp,
    LEFTARG = timestamp without time zone,
    RIGHTARG = timestamp without time zone,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (timestamp without time zone, timestamp without time zone) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_timestamptz,
    LEFTARG = timestamp with time zone,
    RIGHTARG = timestamp with time zone,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (timestamp with time zone, timestamp with time zone) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_interval,
    LEFTARG = interval,
    RIGHTARG = interval,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (interval, interval) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_timetz,
    LEFTARG = time with time zone,
    RIGHTARG = time with time zone,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (time with time zone, time with time zone) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_mchar,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (mchar, mchar) OWNER TO postgres;

--
-- Name: ==; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR == (
    PROCEDURE = isfulleq_mvarchar,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = ==,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.== (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = mv_mc_icase_gt,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (mvarchar, mchar) OWNER TO postgres;

--
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = mc_mv_icase_gt,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (mchar, mvarchar) OWNER TO postgres;

--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = mchar_icase_ge,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (mchar, mchar) OWNER TO postgres;

--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = mvarchar_icase_ge,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = mc_mv_icase_ge,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (mchar, mvarchar) OWNER TO postgres;

--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = mv_mc_icase_ge,
    LEFTARG = mvarchar,
    RIGHTARG = mchar,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (mvarchar, mchar) OWNER TO postgres;

--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR || (
    PROCEDURE = mchar_concat,
    LEFTARG = mchar,
    RIGHTARG = mchar
);


ALTER OPERATOR public.|| (mchar, mchar) OWNER TO postgres;

--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR || (
    PROCEDURE = mvarchar_concat,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar
);


ALTER OPERATOR public.|| (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR || (
    PROCEDURE = mchar_mvarchar_concat,
    LEFTARG = mchar,
    RIGHTARG = mvarchar
);


ALTER OPERATOR public.|| (mchar, mvarchar) OWNER TO postgres;

--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR || (
    PROCEDURE = mvarchar_mchar_concat,
    LEFTARG = mvarchar,
    RIGHTARG = mchar
);


ALTER OPERATOR public.|| (mvarchar, mchar) OWNER TO postgres;

--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~ (
    PROCEDURE = mchar_regexeq,
    LEFTARG = mchar,
    RIGHTARG = mchar,
    NEGATOR = !~,
    RESTRICT = regexeqsel,
    JOIN = regexeqjoinsel
);


ALTER OPERATOR public.~ (mchar, mchar) OWNER TO postgres;

--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~ (
    PROCEDURE = mvarchar_regexeq,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    NEGATOR = !~,
    RESTRICT = regexeqsel,
    JOIN = regexeqjoinsel
);


ALTER OPERATOR public.~ (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: ~~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~~ (
    PROCEDURE = mchar_like,
    LEFTARG = mchar,
    RIGHTARG = mvarchar,
    NEGATOR = !~~,
    RESTRICT = likesel,
    JOIN = likejoinsel
);


ALTER OPERATOR public.~~ (mchar, mvarchar) OWNER TO postgres;

--
-- Name: ~~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~~ (
    PROCEDURE = mvarchar_like,
    LEFTARG = mvarchar,
    RIGHTARG = mvarchar,
    NEGATOR = !~~,
    RESTRICT = likesel,
    JOIN = likejoinsel
);


ALTER OPERATOR public.~~ (mvarchar, mvarchar) OWNER TO postgres;

--
-- Name: abstime_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY abstime_fill_ops USING hash;


ALTER OPERATOR FAMILY public.abstime_fill_ops USING hash OWNER TO postgres;

--
-- Name: abstime_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS abstime_fill_ops
    FOR TYPE abstime USING hash FAMILY abstime_fill_ops AS
    OPERATOR 1 ==(abstime,abstime) ,
    FUNCTION 1 (abstime, abstime) fullhash_abstime(abstime);


ALTER OPERATOR CLASS public.abstime_fill_ops USING hash OWNER TO postgres;

--
-- Name: bool_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY bool_fill_ops USING hash;


ALTER OPERATOR FAMILY public.bool_fill_ops USING hash OWNER TO postgres;

--
-- Name: bool_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS bool_fill_ops
    FOR TYPE boolean USING hash FAMILY bool_fill_ops AS
    OPERATOR 1 ==(boolean,boolean) ,
    FUNCTION 1 (boolean, boolean) fullhash_bool(boolean);


ALTER OPERATOR CLASS public.bool_fill_ops USING hash OWNER TO postgres;

--
-- Name: bytea_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY bytea_fill_ops USING hash;


ALTER OPERATOR FAMILY public.bytea_fill_ops USING hash OWNER TO postgres;

--
-- Name: bytea_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS bytea_fill_ops
    FOR TYPE bytea USING hash FAMILY bytea_fill_ops AS
    OPERATOR 1 ==(bytea,bytea) ,
    FUNCTION 1 (bytea, bytea) fullhash_bytea(bytea);


ALTER OPERATOR CLASS public.bytea_fill_ops USING hash OWNER TO postgres;

--
-- Name: case_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY case_ops USING btree;


ALTER OPERATOR FAMILY public.case_ops USING btree OWNER TO postgres;

--
-- Name: char_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY char_fill_ops USING hash;


ALTER OPERATOR FAMILY public.char_fill_ops USING hash OWNER TO postgres;

--
-- Name: char_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS char_fill_ops
    FOR TYPE character USING hash FAMILY char_fill_ops AS
    OPERATOR 1 ==(character,character) ,
    FUNCTION 1 (character, character) fullhash_char(character);


ALTER OPERATOR CLASS public.char_fill_ops USING hash OWNER TO postgres;

--
-- Name: cid_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY cid_fill_ops USING hash;


ALTER OPERATOR FAMILY public.cid_fill_ops USING hash OWNER TO postgres;

--
-- Name: cid_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS cid_fill_ops
    FOR TYPE cid USING hash FAMILY cid_fill_ops AS
    OPERATOR 1 ==(cid,cid) ,
    FUNCTION 1 (cid, cid) fullhash_cid(cid);


ALTER OPERATOR CLASS public.cid_fill_ops USING hash OWNER TO postgres;

--
-- Name: cidr_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY cidr_fill_ops USING hash;


ALTER OPERATOR FAMILY public.cidr_fill_ops USING hash OWNER TO postgres;

--
-- Name: cidr_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS cidr_fill_ops
    FOR TYPE cidr USING hash FAMILY cidr_fill_ops AS
    OPERATOR 1 ==(cidr,cidr) ,
    FUNCTION 1 (cidr, cidr) fullhash_cidr(cidr);


ALTER OPERATOR CLASS public.cidr_fill_ops USING hash OWNER TO postgres;

--
-- Name: date_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY date_fill_ops USING hash;


ALTER OPERATOR FAMILY public.date_fill_ops USING hash OWNER TO postgres;

--
-- Name: date_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS date_fill_ops
    FOR TYPE date USING hash FAMILY date_fill_ops AS
    OPERATOR 1 ==(date,date) ,
    FUNCTION 1 (date, date) fullhash_date(date);


ALTER OPERATOR CLASS public.date_fill_ops USING hash OWNER TO postgres;

--
-- Name: float4_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY float4_fill_ops USING hash;


ALTER OPERATOR FAMILY public.float4_fill_ops USING hash OWNER TO postgres;

--
-- Name: float4_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS float4_fill_ops
    FOR TYPE real USING hash FAMILY float4_fill_ops AS
    OPERATOR 1 ==(real,real) ,
    FUNCTION 1 (real, real) fullhash_float4(real);


ALTER OPERATOR CLASS public.float4_fill_ops USING hash OWNER TO postgres;

--
-- Name: float8_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY float8_fill_ops USING hash;


ALTER OPERATOR FAMILY public.float8_fill_ops USING hash OWNER TO postgres;

--
-- Name: float8_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS float8_fill_ops
    FOR TYPE double precision USING hash FAMILY float8_fill_ops AS
    OPERATOR 1 ==(double precision,double precision) ,
    FUNCTION 1 (double precision, double precision) fullhash_float8(double precision);


ALTER OPERATOR CLASS public.float8_fill_ops USING hash OWNER TO postgres;

--
-- Name: icase_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY icase_ops USING btree;


ALTER OPERATOR FAMILY public.icase_ops USING btree OWNER TO postgres;

--
-- Name: inet_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY inet_fill_ops USING hash;


ALTER OPERATOR FAMILY public.inet_fill_ops USING hash OWNER TO postgres;

--
-- Name: inet_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS inet_fill_ops
    FOR TYPE inet USING hash FAMILY inet_fill_ops AS
    OPERATOR 1 ==(inet,inet) ,
    FUNCTION 1 (inet, inet) fullhash_inet(inet);


ALTER OPERATOR CLASS public.inet_fill_ops USING hash OWNER TO postgres;

--
-- Name: int2_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY int2_fill_ops USING hash;


ALTER OPERATOR FAMILY public.int2_fill_ops USING hash OWNER TO postgres;

--
-- Name: int2_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS int2_fill_ops
    FOR TYPE smallint USING hash FAMILY int2_fill_ops AS
    OPERATOR 1 ==(smallint,smallint) ,
    FUNCTION 1 (smallint, smallint) fullhash_int2(smallint);


ALTER OPERATOR CLASS public.int2_fill_ops USING hash OWNER TO postgres;

--
-- Name: int2vector_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY int2vector_fill_ops USING hash;


ALTER OPERATOR FAMILY public.int2vector_fill_ops USING hash OWNER TO postgres;

--
-- Name: int2vector_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS int2vector_fill_ops
    FOR TYPE int2vector USING hash FAMILY int2vector_fill_ops AS
    OPERATOR 1 ==(int2vector,int2vector) ,
    FUNCTION 1 (int2vector, int2vector) fullhash_int2vector(int2vector);


ALTER OPERATOR CLASS public.int2vector_fill_ops USING hash OWNER TO postgres;

--
-- Name: int4_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY int4_fill_ops USING hash;


ALTER OPERATOR FAMILY public.int4_fill_ops USING hash OWNER TO postgres;

--
-- Name: int4_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS int4_fill_ops
    FOR TYPE integer USING hash FAMILY int4_fill_ops AS
    OPERATOR 1 ==(integer,integer) ,
    FUNCTION 1 (integer, integer) fullhash_int4(integer);


ALTER OPERATOR CLASS public.int4_fill_ops USING hash OWNER TO postgres;

--
-- Name: int8_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY int8_fill_ops USING hash;


ALTER OPERATOR FAMILY public.int8_fill_ops USING hash OWNER TO postgres;

--
-- Name: int8_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS int8_fill_ops
    FOR TYPE bigint USING hash FAMILY int8_fill_ops AS
    OPERATOR 1 ==(bigint,bigint) ,
    FUNCTION 1 (bigint, bigint) fullhash_int8(bigint);


ALTER OPERATOR CLASS public.int8_fill_ops USING hash OWNER TO postgres;

--
-- Name: interval_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY interval_fill_ops USING hash;


ALTER OPERATOR FAMILY public.interval_fill_ops USING hash OWNER TO postgres;

--
-- Name: interval_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS interval_fill_ops
    FOR TYPE interval USING hash FAMILY interval_fill_ops AS
    OPERATOR 1 ==(interval,interval) ,
    FUNCTION 1 (interval, interval) fullhash_interval(interval);


ALTER OPERATOR CLASS public.interval_fill_ops USING hash OWNER TO postgres;

--
-- Name: macaddr_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY macaddr_fill_ops USING hash;


ALTER OPERATOR FAMILY public.macaddr_fill_ops USING hash OWNER TO postgres;

--
-- Name: macaddr_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS macaddr_fill_ops
    FOR TYPE macaddr USING hash FAMILY macaddr_fill_ops AS
    OPERATOR 1 ==(macaddr,macaddr) ,
    FUNCTION 1 (macaddr, macaddr) fullhash_macaddr(macaddr);


ALTER OPERATOR CLASS public.macaddr_fill_ops USING hash OWNER TO postgres;

--
-- Name: mchar_case_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS mchar_case_ops
    FOR TYPE mchar USING btree FAMILY case_ops AS
    OPERATOR 1 &<(mchar,mvarchar) ,
    OPERATOR 1 &<(mchar,mchar) ,
    OPERATOR 2 &<=(mchar,mchar) ,
    OPERATOR 2 &<=(mchar,mvarchar) ,
    OPERATOR 3 &=(mchar,mvarchar) ,
    OPERATOR 3 &=(mchar,mchar) ,
    OPERATOR 4 &>=(mchar,mvarchar) ,
    OPERATOR 4 &>=(mchar,mchar) ,
    OPERATOR 5 &>(mchar,mchar) ,
    OPERATOR 5 &>(mchar,mvarchar) ,
    FUNCTION 1 (mchar, mvarchar) mc_mv_case_cmp(mchar,mvarchar) ,
    FUNCTION 1 (mchar, mchar) mchar_case_cmp(mchar,mchar);


ALTER OPERATOR CLASS public.mchar_case_ops USING btree OWNER TO postgres;

--
-- Name: mchar_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY mchar_fill_ops USING hash;


ALTER OPERATOR FAMILY public.mchar_fill_ops USING hash OWNER TO postgres;

--
-- Name: mchar_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS mchar_fill_ops
    FOR TYPE mchar USING hash FAMILY mchar_fill_ops AS
    OPERATOR 1 ==(mchar,mchar) ,
    FUNCTION 1 (mchar, mchar) fullhash_mchar(mchar);


ALTER OPERATOR CLASS public.mchar_fill_ops USING hash OWNER TO postgres;

--
-- Name: mchar_icase_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS mchar_icase_ops
    DEFAULT FOR TYPE mchar USING btree FAMILY icase_ops AS
    OPERATOR 1 <(mchar,mvarchar) ,
    OPERATOR 1 <(mchar,mchar) ,
    OPERATOR 2 <=(mchar,mchar) ,
    OPERATOR 2 <=(mchar,mvarchar) ,
    OPERATOR 3 =(mchar,mvarchar) ,
    OPERATOR 3 =(mchar,mchar) ,
    OPERATOR 4 >=(mchar,mvarchar) ,
    OPERATOR 4 >=(mchar,mchar) ,
    OPERATOR 5 >(mchar,mchar) ,
    OPERATOR 5 >(mchar,mvarchar) ,
    FUNCTION 1 (mchar, mvarchar) mc_mv_icase_cmp(mchar,mvarchar) ,
    FUNCTION 1 (mchar, mchar) mchar_icase_cmp(mchar,mchar);


ALTER OPERATOR CLASS public.mchar_icase_ops USING btree OWNER TO postgres;

--
-- Name: mchar_icase_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY mchar_icase_ops USING hash;


ALTER OPERATOR FAMILY public.mchar_icase_ops USING hash OWNER TO postgres;

--
-- Name: mchar_icase_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS mchar_icase_ops
    DEFAULT FOR TYPE mchar USING hash FAMILY mchar_icase_ops AS
    OPERATOR 1 =(mchar,mchar) ,
    FUNCTION 1 (mchar, mchar) mchar_hash(mchar);


ALTER OPERATOR CLASS public.mchar_icase_ops USING hash OWNER TO postgres;

--
-- Name: mvarchar_case_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS mvarchar_case_ops
    FOR TYPE mvarchar USING btree FAMILY case_ops AS
    OPERATOR 1 &<(mvarchar,mchar) ,
    OPERATOR 1 &<(mvarchar,mvarchar) ,
    OPERATOR 2 &<=(mvarchar,mvarchar) ,
    OPERATOR 2 &<=(mvarchar,mchar) ,
    OPERATOR 3 &=(mvarchar,mchar) ,
    OPERATOR 3 &=(mvarchar,mvarchar) ,
    OPERATOR 4 &>=(mvarchar,mchar) ,
    OPERATOR 4 &>=(mvarchar,mvarchar) ,
    OPERATOR 5 &>(mvarchar,mvarchar) ,
    OPERATOR 5 &>(mvarchar,mchar) ,
    FUNCTION 1 (mvarchar, mchar) mv_mc_case_cmp(mvarchar,mchar) ,
    FUNCTION 1 (mvarchar, mvarchar) mvarchar_case_cmp(mvarchar,mvarchar);


ALTER OPERATOR CLASS public.mvarchar_case_ops USING btree OWNER TO postgres;

--
-- Name: mvarchar_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY mvarchar_fill_ops USING hash;


ALTER OPERATOR FAMILY public.mvarchar_fill_ops USING hash OWNER TO postgres;

--
-- Name: mvarchar_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS mvarchar_fill_ops
    FOR TYPE mvarchar USING hash FAMILY mvarchar_fill_ops AS
    OPERATOR 1 ==(mvarchar,mvarchar) ,
    FUNCTION 1 (mvarchar, mvarchar) fullhash_mvarchar(mvarchar);


ALTER OPERATOR CLASS public.mvarchar_fill_ops USING hash OWNER TO postgres;

--
-- Name: mvarchar_icase_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS mvarchar_icase_ops
    DEFAULT FOR TYPE mvarchar USING btree FAMILY icase_ops AS
    OPERATOR 1 <(mvarchar,mchar) ,
    OPERATOR 1 <(mvarchar,mvarchar) ,
    OPERATOR 2 <=(mvarchar,mvarchar) ,
    OPERATOR 2 <=(mvarchar,mchar) ,
    OPERATOR 3 =(mvarchar,mchar) ,
    OPERATOR 3 =(mvarchar,mvarchar) ,
    OPERATOR 4 >=(mvarchar,mchar) ,
    OPERATOR 4 >=(mvarchar,mvarchar) ,
    OPERATOR 5 >(mvarchar,mvarchar) ,
    OPERATOR 5 >(mvarchar,mchar) ,
    FUNCTION 1 (mvarchar, mchar) mv_mc_icase_cmp(mvarchar,mchar) ,
    FUNCTION 1 (mvarchar, mvarchar) mvarchar_icase_cmp(mvarchar,mvarchar);


ALTER OPERATOR CLASS public.mvarchar_icase_ops USING btree OWNER TO postgres;

--
-- Name: mvarchar_icase_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY mvarchar_icase_ops USING hash;


ALTER OPERATOR FAMILY public.mvarchar_icase_ops USING hash OWNER TO postgres;

--
-- Name: mvarchar_icase_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS mvarchar_icase_ops
    DEFAULT FOR TYPE mvarchar USING hash FAMILY mvarchar_icase_ops AS
    OPERATOR 1 =(mvarchar,mvarchar) ,
    FUNCTION 1 (mvarchar, mvarchar) mvarchar_hash(mvarchar);


ALTER OPERATOR CLASS public.mvarchar_icase_ops USING hash OWNER TO postgres;

--
-- Name: name_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY name_fill_ops USING hash;


ALTER OPERATOR FAMILY public.name_fill_ops USING hash OWNER TO postgres;

--
-- Name: name_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS name_fill_ops
    FOR TYPE name USING hash FAMILY name_fill_ops AS
    OPERATOR 1 ==(name,name) ,
    FUNCTION 1 (name, name) fullhash_name(name);


ALTER OPERATOR CLASS public.name_fill_ops USING hash OWNER TO postgres;

--
-- Name: oid_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY oid_fill_ops USING hash;


ALTER OPERATOR FAMILY public.oid_fill_ops USING hash OWNER TO postgres;

--
-- Name: oid_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS oid_fill_ops
    FOR TYPE oid USING hash FAMILY oid_fill_ops AS
    OPERATOR 1 ==(oid,oid) ,
    FUNCTION 1 (oid, oid) fullhash_oid(oid);


ALTER OPERATOR CLASS public.oid_fill_ops USING hash OWNER TO postgres;

--
-- Name: oidvector_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY oidvector_fill_ops USING hash;


ALTER OPERATOR FAMILY public.oidvector_fill_ops USING hash OWNER TO postgres;

--
-- Name: oidvector_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS oidvector_fill_ops
    FOR TYPE oidvector USING hash FAMILY oidvector_fill_ops AS
    OPERATOR 1 ==(oidvector,oidvector) ,
    FUNCTION 1 (oidvector, oidvector) fullhash_oidvector(oidvector);


ALTER OPERATOR CLASS public.oidvector_fill_ops USING hash OWNER TO postgres;

--
-- Name: reltime_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY reltime_fill_ops USING hash;


ALTER OPERATOR FAMILY public.reltime_fill_ops USING hash OWNER TO postgres;

--
-- Name: reltime_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS reltime_fill_ops
    FOR TYPE reltime USING hash FAMILY reltime_fill_ops AS
    OPERATOR 1 ==(reltime,reltime) ,
    FUNCTION 1 (reltime, reltime) fullhash_reltime(reltime);


ALTER OPERATOR CLASS public.reltime_fill_ops USING hash OWNER TO postgres;

--
-- Name: text_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY text_fill_ops USING hash;


ALTER OPERATOR FAMILY public.text_fill_ops USING hash OWNER TO postgres;

--
-- Name: text_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS text_fill_ops
    FOR TYPE text USING hash FAMILY text_fill_ops AS
    OPERATOR 1 ==(text,text) ,
    FUNCTION 1 (text, text) fullhash_text(text);


ALTER OPERATOR CLASS public.text_fill_ops USING hash OWNER TO postgres;

--
-- Name: time_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY time_fill_ops USING hash;


ALTER OPERATOR FAMILY public.time_fill_ops USING hash OWNER TO postgres;

--
-- Name: time_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS time_fill_ops
    FOR TYPE time without time zone USING hash FAMILY time_fill_ops AS
    OPERATOR 1 ==(time without time zone,time without time zone) ,
    FUNCTION 1 (time without time zone, time without time zone) fullhash_time(time without time zone);


ALTER OPERATOR CLASS public.time_fill_ops USING hash OWNER TO postgres;

--
-- Name: timestamp_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY timestamp_fill_ops USING hash;


ALTER OPERATOR FAMILY public.timestamp_fill_ops USING hash OWNER TO postgres;

--
-- Name: timestamp_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS timestamp_fill_ops
    FOR TYPE timestamp without time zone USING hash FAMILY timestamp_fill_ops AS
    OPERATOR 1 ==(timestamp without time zone,timestamp without time zone) ,
    FUNCTION 1 (timestamp without time zone, timestamp without time zone) fullhash_timestamp(timestamp without time zone);


ALTER OPERATOR CLASS public.timestamp_fill_ops USING hash OWNER TO postgres;

--
-- Name: timestamptz_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY timestamptz_fill_ops USING hash;


ALTER OPERATOR FAMILY public.timestamptz_fill_ops USING hash OWNER TO postgres;

--
-- Name: timestamptz_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS timestamptz_fill_ops
    FOR TYPE timestamp with time zone USING hash FAMILY timestamptz_fill_ops AS
    OPERATOR 1 ==(timestamp with time zone,timestamp with time zone) ,
    FUNCTION 1 (timestamp with time zone, timestamp with time zone) fullhash_timestamptz(timestamp with time zone);


ALTER OPERATOR CLASS public.timestamptz_fill_ops USING hash OWNER TO postgres;

--
-- Name: timetz_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY timetz_fill_ops USING hash;


ALTER OPERATOR FAMILY public.timetz_fill_ops USING hash OWNER TO postgres;

--
-- Name: timetz_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS timetz_fill_ops
    FOR TYPE time with time zone USING hash FAMILY timetz_fill_ops AS
    OPERATOR 1 ==(time with time zone,time with time zone) ,
    FUNCTION 1 (time with time zone, time with time zone) fullhash_timetz(time with time zone);


ALTER OPERATOR CLASS public.timetz_fill_ops USING hash OWNER TO postgres;

--
-- Name: varchar_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY varchar_fill_ops USING hash;


ALTER OPERATOR FAMILY public.varchar_fill_ops USING hash OWNER TO postgres;

--
-- Name: varchar_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS varchar_fill_ops
    FOR TYPE character varying USING hash FAMILY varchar_fill_ops AS
    OPERATOR 1 ==(character varying,character varying) ,
    FUNCTION 1 (character varying, character varying) fullhash_varchar(character varying);


ALTER OPERATOR CLASS public.varchar_fill_ops USING hash OWNER TO postgres;

--
-- Name: xid_fill_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY xid_fill_ops USING hash;


ALTER OPERATOR FAMILY public.xid_fill_ops USING hash OWNER TO postgres;

--
-- Name: xid_fill_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS xid_fill_ops
    FOR TYPE xid USING hash FAMILY xid_fill_ops AS
    OPERATOR 1 ==(xid,xid) ,
    FUNCTION 1 (xid, xid) fullhash_xid(xid);


ALTER OPERATOR CLASS public.xid_fill_ops USING hash OWNER TO postgres;

SET search_path = pg_catalog;

--
-- Name: CAST (public.mchar AS public.mchar); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.mchar AS public.mchar) WITH FUNCTION public.mchar(public.mchar, integer, boolean) AS IMPLICIT;


--
-- Name: CAST (public.mchar AS public.mvarchar); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.mchar AS public.mvarchar) WITH FUNCTION public.mchar_mvarchar(public.mchar, integer, boolean) AS IMPLICIT;


--
-- Name: CAST (public.mvarchar AS public.mchar); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.mvarchar AS public.mchar) WITH FUNCTION public.mvarchar_mchar(public.mvarchar, integer, boolean) AS IMPLICIT;


--
-- Name: CAST (public.mvarchar AS public.mvarchar); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.mvarchar AS public.mvarchar) WITH FUNCTION public.mvarchar(public.mvarchar, integer, boolean) AS IMPLICIT;


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: _commonsettings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE _commonsettings (
    _userid mvarchar(64) NOT NULL,
    _objectkey mvarchar(256) NOT NULL,
    _settingskey mvarchar(256) NOT NULL,
    _version bytea NOT NULL,
    _settingspresentation mvarchar(256),
    _settingsdata bytea
);
ALTER TABLE ONLY _commonsettings ALTER COLUMN _version SET STORAGE PLAIN;


ALTER TABLE _commonsettings OWNER TO postgres;

--
-- Name: _dynlistsettings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE _dynlistsettings (
    _userid mvarchar(64) NOT NULL,
    _objectkey mvarchar(256) NOT NULL,
    _settingskey mvarchar(256) NOT NULL,
    _version bytea NOT NULL,
    _settingspresentation mvarchar(256),
    _settingsdata bytea
);
ALTER TABLE ONLY _dynlistsettings ALTER COLUMN _version SET STORAGE PLAIN;


ALTER TABLE _dynlistsettings OWNER TO postgres;

--
-- Name: _extensionsinfo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE _extensionsinfo (
    _idrref bytea NOT NULL,
    _configversion bytea NOT NULL,
    _extensionorder numeric(9,0) NOT NULL,
    _extname mvarchar(255) NOT NULL,
    _extsynonym mvarchar NOT NULL,
    _extversion mvarchar(255) NOT NULL,
    _safemode boolean NOT NULL,
    _securityprofilename mvarchar(255) NOT NULL,
    _updatetime timestamp without time zone NOT NULL,
    _extensionusepurpose numeric(2,0) NOT NULL,
    _version integer DEFAULT 0 NOT NULL
);
ALTER TABLE ONLY _extensionsinfo ALTER COLUMN _idrref SET STORAGE PLAIN;
ALTER TABLE ONLY _extensionsinfo ALTER COLUMN _configversion SET STORAGE PLAIN;


ALTER TABLE _extensionsinfo OWNER TO postgres;

--
-- Name: _frmdtsettings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE _frmdtsettings (
    _userid mvarchar(64) NOT NULL,
    _objectkey mvarchar(256) NOT NULL,
    _settingskey mvarchar(256) NOT NULL,
    _version bytea NOT NULL,
    _settingspresentation mvarchar(256),
    _settingsdata bytea
);
ALTER TABLE ONLY _frmdtsettings ALTER COLUMN _version SET STORAGE PLAIN;


ALTER TABLE _frmdtsettings OWNER TO postgres;

--
-- Name: _odatasettings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE _odatasettings (
    _metadataobjectuuid bytea NOT NULL
);
ALTER TABLE ONLY _odatasettings ALTER COLUMN _metadataobjectuuid SET STORAGE PLAIN;


ALTER TABLE _odatasettings OWNER TO postgres;

--
-- Name: _repsettings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE _repsettings (
    _userid mvarchar(64) NOT NULL,
    _objectkey mvarchar(256) NOT NULL,
    _settingskey mvarchar(256) NOT NULL,
    _version bytea NOT NULL,
    _settingspresentation mvarchar(256),
    _settingsdata bytea
);
ALTER TABLE ONLY _repsettings ALTER COLUMN _version SET STORAGE PLAIN;


ALTER TABLE _repsettings OWNER TO postgres;

--
-- Name: _repvarsettings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE _repvarsettings (
    _userid mvarchar(64) NOT NULL,
    _objectkey mvarchar(256) NOT NULL,
    _settingskey mvarchar(256) NOT NULL,
    _version bytea NOT NULL,
    _settingspresentation mvarchar(256),
    _settingsdata bytea
);
ALTER TABLE ONLY _repvarsettings ALTER COLUMN _version SET STORAGE PLAIN;


ALTER TABLE _repvarsettings OWNER TO postgres;

--
-- Name: _systemsettings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE _systemsettings (
    _userid mvarchar(64) NOT NULL,
    _objectkey mvarchar(256) NOT NULL,
    _settingskey mvarchar(256) NOT NULL,
    _version bytea NOT NULL,
    _settingspresentation mvarchar(256),
    _settingsdata bytea
);
ALTER TABLE ONLY _systemsettings ALTER COLUMN _version SET STORAGE PLAIN;


ALTER TABLE _systemsettings OWNER TO postgres;

--
-- Name: _usersworkhistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE _usersworkhistory (
    _id bytea NOT NULL,
    _userid bytea NOT NULL,
    _url mvarchar NOT NULL,
    _date timestamp without time zone NOT NULL,
    _urlhash numeric(10,0) NOT NULL
);
ALTER TABLE ONLY _usersworkhistory ALTER COLUMN _id SET STORAGE PLAIN;
ALTER TABLE ONLY _usersworkhistory ALTER COLUMN _userid SET STORAGE PLAIN;


ALTER TABLE _usersworkhistory OWNER TO postgres;

SET default_with_oids = true;

--
-- Name: _yearoffset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE _yearoffset (
    ofset integer NOT NULL
);


ALTER TABLE _yearoffset OWNER TO postgres;

--
-- Name: config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE config (
    filename mvarchar(128) NOT NULL,
    creation timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    attributes integer NOT NULL,
    datasize bigint NOT NULL,
    binarydata bytea NOT NULL,
    partno integer NOT NULL
);


ALTER TABLE config OWNER TO postgres;

--
-- Name: configcas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE configcas (
    filename mvarchar(128) NOT NULL,
    creation timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    attributes integer NOT NULL,
    datasize bigint NOT NULL,
    binarydata bytea NOT NULL,
    partno integer NOT NULL
);


ALTER TABLE configcas OWNER TO postgres;

--
-- Name: configcassave; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE configcassave (
    filename mvarchar(128) NOT NULL,
    creation timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    attributes integer NOT NULL,
    datasize bigint NOT NULL,
    binarydata bytea NOT NULL,
    partno integer NOT NULL
);


ALTER TABLE configcassave OWNER TO postgres;

--
-- Name: configsave; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE configsave (
    filename mvarchar(128) NOT NULL,
    creation timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    attributes integer NOT NULL,
    datasize bigint NOT NULL,
    binarydata bytea NOT NULL,
    partno integer NOT NULL
);


ALTER TABLE configsave OWNER TO postgres;

--
-- Name: dbschema; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE dbschema (
    serializeddata bytea NOT NULL
);


ALTER TABLE dbschema OWNER TO postgres;

--
-- Name: depotfiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE depotfiles (
    filename mvarchar(128) NOT NULL,
    creation timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    attributes integer NOT NULL,
    datasize bigint NOT NULL,
    binarydata bytea NOT NULL,
    partno integer NOT NULL
);


ALTER TABLE depotfiles OWNER TO postgres;

--
-- Name: files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE files (
    filename mvarchar(128) NOT NULL,
    creation timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    attributes integer NOT NULL,
    datasize bigint NOT NULL,
    binarydata bytea NOT NULL,
    partno integer NOT NULL
);


ALTER TABLE files OWNER TO postgres;

--
-- Name: ibversion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ibversion (
    ibversion integer NOT NULL,
    platformversionreq integer NOT NULL
);


ALTER TABLE ibversion OWNER TO postgres;

--
-- Name: params; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE params (
    filename mvarchar(128) NOT NULL,
    creation timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    attributes integer NOT NULL,
    datasize bigint NOT NULL,
    binarydata bytea NOT NULL,
    partno integer NOT NULL
);


ALTER TABLE params OWNER TO postgres;

SET default_with_oids = false;

--
-- Name: v8users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE v8users (
    id bytea NOT NULL,
    name mvarchar(64) NOT NULL,
    descr mvarchar(128) NOT NULL,
    osname mvarchar(128),
    changed timestamp without time zone NOT NULL,
    rolesid numeric(10,0) NOT NULL,
    show boolean NOT NULL,
    data bytea NOT NULL,
    eauth boolean,
    admrole boolean,
    ussprh numeric(10,0)
);
ALTER TABLE ONLY v8users ALTER COLUMN id SET STORAGE PLAIN;


ALTER TABLE v8users OWNER TO postgres;

--
-- Data for Name: _commonsettings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY _commonsettings (_userid, _objectkey, _settingskey, _version, _settingspresentation, _settingsdata) FROM stdin;
\.


--
-- Data for Name: _dynlistsettings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY _dynlistsettings (_userid, _objectkey, _settingskey, _version, _settingspresentation, _settingsdata) FROM stdin;
\.


--
-- Data for Name: _extensionsinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY _extensionsinfo (_idrref, _configversion, _extensionorder, _extname, _extsynonym, _extversion, _safemode, _securityprofilename, _updatetime, _extensionusepurpose, _version) FROM stdin;
\.


--
-- Data for Name: _frmdtsettings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY _frmdtsettings (_userid, _objectkey, _settingskey, _version, _settingspresentation, _settingsdata) FROM stdin;
\.


--
-- Data for Name: _odatasettings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY _odatasettings (_metadataobjectuuid) FROM stdin;
\.


--
-- Data for Name: _repsettings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY _repsettings (_userid, _objectkey, _settingskey, _version, _settingspresentation, _settingsdata) FROM stdin;
\.


--
-- Data for Name: _repvarsettings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY _repvarsettings (_userid, _objectkey, _settingskey, _version, _settingspresentation, _settingsdata) FROM stdin;
\.


--
-- Data for Name: _systemsettings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY _systemsettings (_userid, _objectkey, _settingskey, _version, _settingspresentation, _settingsdata) FROM stdin;
	ОсновноеОкно/Такси/НастройкиОкна		\\xb897aa831b202deb451347624bbe4df9		\\xffffff7f0002000001000000000000000d0a3030303030303063203030303030323030203766666666666666200d0a2f02000076020000ffffff7f76639540abab219e687b4ab050215ba849be2e9a0474657374818391a09c2e12c042020091b0c32e12c04202009a036c69639a07446566557365729a036c69638d18069a04323335369a053143563843958e4a9170b7e6454f905cfb6c50343e4d8795de286ede1455dd4cbc8688b49f856b07957b2ce5ee5bceb744b7bbe3722c6ec40f9a0272759a027275957b2ce5ee5bceb744b7bbe3722c6ec40f828b0bc18fc8a62c018b0bad7e1ac18f89a62c018d7e1aa1c2ad0801c18fc8a62c018d0801ab1fc18f99a62c018b1fab3dc18fa8a62c018b3dab0ec18f89a62c018b0ea1c2a1c2a18ddd21c18f99a62c018ddd21ad3e02c18f99a62c018d3e02afbb530400c18fc8a62c018fbb530400adeb0cc18fc8a62c018deb0cad4907c18fc8a62c018d490720a18b308d913d829a0b382e332e31302e3232353295a42315076f51ce4fba4b0d11ab7a18938781819169e627f45fd7cb428f01c3c3d784c1e19a0d4575726f70652f4d6f73636f77a18281818db0048f805101008181819a036c69638d18062020ab10818181818181818181818182cb2395969825b0fb9da14eb120c4dcb772ff4ac120a2cb239533dc5eba368912429ed2485e759203aa8b30a1818181a3ba8e6db7e05cc96e614a52b7d9489aaeb454c6926cbdf2f3ea936cebf7f75fcd8d8341bf3602992759da3248dd326a0d0a3030303030303238203030303030303238203766666666666666200d0ad0112f12c0420200d0112f12c0420200000000002400530074007200650061006d002400000000000d0a3030303030343530203030303030343530203766666666666666200d0aefbbbf7b2223222c36336132626435612d363765332d343064312d383664642d6335326133313230396461322c0d0a7b332c31342c2253657474696e677353706c69747461626c65466f726d53706c6974746572506f735f544449222c227b322c3465312c3465312c3465312c3465317d222c22546f704c6576656c4d2f5f544449222c227b342c312c3133372c38312c3939372c3630302c302c302c302c302c302c30303030303030302d303030302d303030302d303030302d3030303030303030303030302c302c4141414141414141414141414141414141414141414141414141413d2c307d222c225c36613538316539352d323938322d343933642d616637362d3639386634353635656466655c315f544449222c227b342c343239343936373239352c302c302c307d222c225c39393465306164372d373361352d346465302d613639322d6438346333366465393233665c31345f544449222c227b342c343239343936373239352c302c302c307d222c225c39393465306164372d373361352d346465302d613639322d6438346333366465393233665c31395f544449222c227b342c343239343936373239352c302c302c307d222c225c39393465306164372d373361352d346465302d613639322d6438346333366465393233665c375f544449222c227b342c343239343936373239352c302c302c307d222c225c39646435353738362d313964632d346139392d623432312d3233373639353164633033315c345f544449222c227b342c343239343936373239352c302c302c317d222c225c62373866326538302d656336382d313164342d396463662d3030353062616532626337395c31315f544449222c227b342c343239343936373239352c302c302c317d222c225c62373866326538302d656336382d313164342d396463662d3030353062616532626337395c31325f544449222c227b342c343239343936373239352c342c0d0a7b302c307d2c0d0a7b312c307d2c0d0a7b332c307d2c0d0a7b342c307d2c302c317d222c225c62373866326538302d656336382d313164342d396463662d3030353062616532626337395c355f544449222c227b342c343239343936373239352c302c302c307d222c225c62373866326538302d656336382d313164342d396463662d3030353062616532626337395c365f544449222c227b342c343239343936373239352c302c302c307d222c225c62373866326538302d656336382d313164342d396463662d3030353062616532626337395c37305f544449222c227b342c343239343936373239352c302c302c307d222c225c66666532366362332d333232622d313164352d623039362d3030383034386461303736355c31305f544449222c227b342c343239343936373239352c302c302c317d222c225c66666532366362332d333232622d313164352d623039362d3030383034386461303736355c345f544449222c227b342c343239343936373239352c302c302c307d227d0d0a7d
\.


--
-- Data for Name: _usersworkhistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY _usersworkhistory (_id, _userid, _url, _date, _urlhash) FROM stdin;
\.


--
-- Data for Name: _yearoffset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY _yearoffset (ofset) FROM stdin;
\.


--
-- Data for Name: config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY config (filename, creation, modified, attributes, datasize, binarydata, partno) FROM stdin;
\.


--
-- Data for Name: configcas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY configcas (filename, creation, modified, attributes, datasize, binarydata, partno) FROM stdin;
\.


--
-- Data for Name: configcassave; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY configcassave (filename, creation, modified, attributes, datasize, binarydata, partno) FROM stdin;
\.


--
-- Data for Name: configsave; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY configsave (filename, creation, modified, attributes, datasize, binarydata, partno) FROM stdin;
\.


--
-- Data for Name: dbschema; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY dbschema (serializeddata) FROM stdin;
\\xefbbbf7b392c0d0a7b392c0d0a7b224f4461746153657474696e6773222c224e222c312c22222c0d0a7b312c0d0a7b224d657461646174614f626a65637455554944222c302c0d0a7b312c0d0a7b2242222c31362c302c22222c307d0d0a7d2c22227d0d0a7d2c0d0a7b307d2c0d0a7b307d2c312c2253222c0d0a7b307d2c0d0a7b307d2c22222c307d2c0d0a7b22457874656e73696f6e73496e666f222c224e222c322c22222c0d0a7b31312c0d0a7b224944222c302c0d0a7b312c0d0a7b2252222c302c302c22457874656e73696f6e73496e666f222c327d0d0a7d2c22227d2c0d0a7b22436f6e66696756657273696f6e222c302c0d0a7b312c0d0a7b2242222c32302c302c22222c307d0d0a7d2c22227d2c0d0a7b22457874656e73696f6e4f72646572222c302c0d0a7b312c0d0a7b224e222c392c302c22222c307d0d0a7d2c22227d2c0d0a7b224578744e616d65222c302c0d0a7b312c0d0a7b2253222c323134373438333930332c302c22222c307d0d0a7d2c22227d2c0d0a7b2245787453796e6f6e796d222c302c0d0a7b312c0d0a7b2253222c323134373438333634382c302c22222c307d0d0a7d2c22227d2c0d0a7b2245787456657273696f6e222c302c0d0a7b312c0d0a7b2253222c323134373438333930332c302c22222c307d0d0a7d2c22227d2c0d0a7b22536166654d6f6465222c302c0d0a7b312c0d0a7b224c222c302c302c22222c307d0d0a7d2c22227d2c0d0a7b22536563757269747950726f66696c654e616d65222c302c0d0a7b312c0d0a7b2253222c323134373438333930332c302c22222c307d0d0a7d2c22227d2c0d0a7b2255706461746554696d65222c302c0d0a7b312c0d0a7b2254222c302c302c22222c307d0d0a7d2c22227d2c0d0a7b22457874656e73696f6e557365507572706f7365222c302c0d0a7b312c0d0a7b224e222c322c302c22222c307d0d0a7d2c22227d2c0d0a7b2256657273696f6e222c302c0d0a7b312c0d0a7b2256222c302c302c22222c307d0d0a7d2c22227d0d0a7d2c0d0a7b307d2c0d0a7b307d2c312c2252222c0d0a7b307d2c0d0a7b307d2c22222c307d2c0d0a7b2253797374656d53657474696e6773222c224e222c332c22222c0d0a7b362c0d0a7b22557365724964222c302c0d0a7b312c0d0a7b2253222c323134373438333731322c302c22222c307d0d0a7d2c22227d2c0d0a7b224f626a6563744b6579222c302c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e67734b6579222c302c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2256657273696f6e222c302c0d0a7b312c0d0a7b2242222c31362c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e677350726573656e746174696f6e222c312c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e677344617461222c312c0d0a7b312c0d0a7b2242222c323134373438333634382c302c22222c307d0d0a7d2c22227d0d0a7d2c0d0a7b307d2c0d0a7b312c0d0a7b2242794b6579222c302c0d0a7b332c22557365724964222c224f626a6563744b6579222c2253657474696e67734b6579227d2c312c307d0d0a7d2c312c2253222c0d0a7b307d2c0d0a7b307d2c22222c307d2c0d0a7b22436f6d6d6f6e53657474696e6773222c224e222c342c22222c0d0a7b362c0d0a7b22557365724964222c302c0d0a7b312c0d0a7b2253222c323134373438333731322c302c22222c307d0d0a7d2c22227d2c0d0a7b224f626a6563744b6579222c302c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e67734b6579222c302c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2256657273696f6e222c302c0d0a7b312c0d0a7b2242222c31362c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e677350726573656e746174696f6e222c312c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e677344617461222c312c0d0a7b312c0d0a7b2242222c323134373438333634382c302c22222c307d0d0a7d2c22227d0d0a7d2c0d0a7b307d2c0d0a7b312c0d0a7b2242794b6579222c302c0d0a7b332c22557365724964222c224f626a6563744b6579222c2253657474696e67734b6579227d2c312c307d0d0a7d2c312c2253222c0d0a7b307d2c0d0a7b307d2c22222c307d2c0d0a7b2252657053657474696e6773222c224e222c352c22222c0d0a7b362c0d0a7b22557365724964222c302c0d0a7b312c0d0a7b2253222c323134373438333731322c302c22222c307d0d0a7d2c22227d2c0d0a7b224f626a6563744b6579222c302c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e67734b6579222c302c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2256657273696f6e222c302c0d0a7b312c0d0a7b2242222c31362c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e677350726573656e746174696f6e222c312c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e677344617461222c312c0d0a7b312c0d0a7b2242222c323134373438333634382c302c22222c307d0d0a7d2c22227d0d0a7d2c0d0a7b307d2c0d0a7b312c0d0a7b2242794b6579222c302c0d0a7b332c22557365724964222c224f626a6563744b6579222c2253657474696e67734b6579227d2c312c307d0d0a7d2c312c2253222c0d0a7b307d2c0d0a7b307d2c22222c307d2c0d0a7b2252657056617253657474696e6773222c224e222c362c22222c0d0a7b362c0d0a7b22557365724964222c302c0d0a7b312c0d0a7b2253222c323134373438333731322c302c22222c307d0d0a7d2c22227d2c0d0a7b224f626a6563744b6579222c302c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e67734b6579222c302c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2256657273696f6e222c302c0d0a7b312c0d0a7b2242222c31362c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e677350726573656e746174696f6e222c312c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e677344617461222c312c0d0a7b312c0d0a7b2242222c323134373438333634382c302c22222c307d0d0a7d2c22227d0d0a7d2c0d0a7b307d2c0d0a7b312c0d0a7b2242794b6579222c302c0d0a7b332c22557365724964222c224f626a6563744b6579222c2253657474696e67734b6579227d2c312c307d0d0a7d2c312c2253222c0d0a7b307d2c0d0a7b307d2c22222c307d2c0d0a7b2246726d447453657474696e6773222c224e222c372c22222c0d0a7b362c0d0a7b22557365724964222c302c0d0a7b312c0d0a7b2253222c323134373438333731322c302c22222c307d0d0a7d2c22227d2c0d0a7b224f626a6563744b6579222c302c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e67734b6579222c302c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2256657273696f6e222c302c0d0a7b312c0d0a7b2242222c31362c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e677350726573656e746174696f6e222c312c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e677344617461222c312c0d0a7b312c0d0a7b2242222c323134373438333634382c302c22222c307d0d0a7d2c22227d0d0a7d2c0d0a7b307d2c0d0a7b312c0d0a7b2242794b6579222c302c0d0a7b332c22557365724964222c224f626a6563744b6579222c2253657474696e67734b6579227d2c312c307d0d0a7d2c312c2253222c0d0a7b307d2c0d0a7b307d2c22222c307d2c0d0a7b2244796e4c69737453657474696e6773222c224e222c382c22222c0d0a7b362c0d0a7b22557365724964222c302c0d0a7b312c0d0a7b2253222c323134373438333731322c302c22222c307d0d0a7d2c22227d2c0d0a7b224f626a6563744b6579222c302c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e67734b6579222c302c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2256657273696f6e222c302c0d0a7b312c0d0a7b2242222c31362c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e677350726573656e746174696f6e222c312c0d0a7b312c0d0a7b2253222c323134373438333930342c302c22222c307d0d0a7d2c22227d2c0d0a7b2253657474696e677344617461222c312c0d0a7b312c0d0a7b2242222c323134373438333634382c302c22222c307d0d0a7d2c22227d0d0a7d2c0d0a7b307d2c0d0a7b312c0d0a7b2242794b6579222c302c0d0a7b332c22557365724964222c224f626a6563744b6579222c2253657474696e67734b6579227d2c312c307d0d0a7d2c312c2253222c0d0a7b307d2c0d0a7b307d2c22222c307d2c0d0a7b225573657273576f726b486973746f7279222c224e222c392c22222c0d0a7b352c0d0a7b224944222c302c0d0a7b312c0d0a7b2242222c31362c302c22222c307d0d0a7d2c22227d2c0d0a7b22557365724944222c302c0d0a7b312c0d0a7b2242222c31362c302c22222c307d0d0a7d2c22227d2c0d0a7b2255524c222c302c0d0a7b312c0d0a7b2253222c323134373438333634382c302c22222c307d0d0a7d2c22227d2c0d0a7b2244617465222c302c0d0a7b312c0d0a7b2254222c302c302c22222c307d0d0a7d2c22227d2c0d0a7b2255524c48617368222c302c0d0a7b312c0d0a7b224e222c31302c302c22222c307d0d0a7d2c22227d0d0a7d2c0d0a7b307d2c0d0a7b332c0d0a7b2242794944222c312c0d0a7b312c224944227d2c302c307d2c0d0a7b2242795573657244617465222c302c0d0a7b322c22557365724944222c2244617465227d2c302c307d2c0d0a7b2242795573657255524c48617368222c302c0d0a7b332c22557365724944222c2255524c48617368222c2244617465227d2c312c307d0d0a7d2c312c2253222c0d0a7b307d2c0d0a7b307d2c22222c307d0d0a7d0d0a7d
\.


--
-- Data for Name: depotfiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY depotfiles (filename, creation, modified, attributes, datasize, binarydata, partno) FROM stdin;
\.


--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY files (filename, creation, modified, attributes, datasize, binarydata, partno) FROM stdin;
c01b78f6-1525-41b1-9cc1-69e3da58d2ac.pfl	2017-06-28 16:57:17	2017-06-28 16:57:17	0	128	\\x035a03d76ee9a7e292a8027ad539b45e9295481f6050961a6d547207076935d72d04447aec6ef01f43cdcb5115c9e09dcda9444ce203f93195d86243b78d408419ccd96d83d6b8d3292f3fce24a49657e2c6bb14fcdce44c3895c147e2638feb9560fba5b22d7efd179c69c8b250aca8eab1c86d4a97f61aa7d63ea0e35ff0f0	0
ib.pfl	2017-06-28 16:59:26	2017-06-28 16:59:26	0	95	\\xefbbbf7b0d0a7b22227d2c0d0a7b0d0a7b224c61756e6368222c0d0a7b22227d2c0d0a7b0d0a7b22227d0d0a7d0d0a7d2c0d0a7b226465627567222c0d0a7b22227d2c0d0a7b0d0a7b22227d0d0a7d0d0a7d2c0d0a7b22227d0d0a7d0d0a7d	0
071523a4-516f-4fce-ba4b-0d11ab7a1893.pfl	2017-06-28 16:59:26	2017-06-28 16:59:26	0	900	\\xefbbbf7b0d0a7b22507265646566696e65645265666572656e6365566965775f4f7264657250617468222c0d0a7b2255227d2c22507265646566696e65645265666572656e6365566965775f54756e696e6750617468222c0d0a7b2255227d2c22507265646566696e65644368617261637465726973746963566965775f4f7264657250617468222c0d0a7b2255227d2c22507265646566696e65644368617261637465726973746963566965775f54756e696e6750617468222c0d0a7b2255227d2c22416363756d52656741676772656761746573566965775f4f7264657250617468222c0d0a7b2255227d2c22416363756d52656741676772656761746573566965775f54756e696e6750617468222c0d0a7b2255227d2c22416363756d52656741676772656761746573566965774f7074696d616c5f4f7264657250617468222c0d0a7b2255227d2c22416363756d52656741676772656761746573566965774f7074696d616c5f54756e696e6750617468222c0d0a7b2255227d2c22507265646566696e65644163636f756e7473566965775f4f7264657250617468222c0d0a7b2255227d2c22507265646566696e65644163636f756e7473566965775f54756e696e6750617468222c0d0a7b2255227d2c22507265646566696e65644163636f756e747345646974446c675f4f7264657250617468222c0d0a7b2255227d2c22507265646566696e65644163636f756e747345646974446c675f54756e696e6750617468222c0d0a7b2255227d2c22507265646566696e65644163636f756e747345646974446c675f4f72646572506174685f726573222c0d0a7b2255227d2c22507265646566696e65644163636f756e747345646974446c675f54756e696e67506174685f726573222c0d0a7b2255227d2c22227d2c0d0a7b0d0a7b224c61756e6368222c0d0a7b2241757468656e7469636174696f6e547970654e6577222c0d0a7b224e222c307d2c22557365724e6577222c0d0a7b2253222c22227d2c22437573746f6d4e6577222c0d0a7b2253222c22227d2c2252756e416e64417474616368546f4465627567676572222c0d0a7b2242222c307d2c22227d2c0d0a7b0d0a7b22227d0d0a7d0d0a7d2c0d0a7b22436f6e666967222c0d0a7b22227d2c0d0a7b0d0a7b22227d0d0a7d0d0a7d2c0d0a7b226465627567222c0d0a7b22227d2c0d0a7b0d0a7b22227d0d0a7d0d0a7d2c0d0a7b22227d0d0a7d0d0a7d	0
\.


--
-- Data for Name: ibversion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ibversion (ibversion, platformversionreq) FROM stdin;
4	80310
\.


--
-- Data for Name: params; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY params (filename, creation, modified, attributes, datasize, binarydata, partno) FROM stdin;
locale.inf	2017-06-28 16:57:12	2017-06-28 16:57:12	0	112	\\xefbbbf7b2272755f5255222c302c302c22222c2d312c22222c22222c22222c22222c312c302c30303030303030302d303030302d303030302d303030302d3030303030303030303030302c30303030303030302d303030302d303030302d303030302d3030303030303030303030307d	0
log.inf	2017-06-28 16:57:12	2017-06-28 16:57:12	0	119	\\xefbbbf7b36323134393563662d663636632d343238332d616537652d6137356364666535643963622c302c352c30303030303030302d303030302d303030302d303030302d3030303030303030303030302c30303030303030302d303030302d303030302d303030302d3030303030303030303030307d	0
evlogparams.inf	2017-06-28 16:57:12	2017-06-28 16:57:12	0	6	\\xefbbbf7b307d	0
DBNames	2017-06-28 16:57:12	2017-06-28 16:57:12	0	143	\\x7bbf7b7fb5a50e2f17843080025d2c040ce828f9bb24962406a7969464e6a5172be918d612afd5b5a22435af38333fafd8332f2d5f49c78804bdc195c525a9b9087b8d49d0eb9c9f9b9b9f87d06b4282dea0d402844653d23486251621f49a91a0d7ad28d7a504a1d59c04ad2e95793e99c5489a2d48d01c5a9c5a541c9e5f94ed013422bfa85249c7b296970b8400	0
DBNamesVersion	2017-06-28 16:57:12	2017-06-28 16:57:12	0	43	\\xefbbbf7b302c38653165346563652d356365332d343532392d626331632d6462663662396666323062327d	0
\.


--
-- Data for Name: v8users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY v8users (id, name, descr, osname, changed, rolesid, show, data, eauth, admrole, ussprh) FROM stdin;
\.


--
-- Name: _extensionsinfo _extensionsinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY _extensionsinfo
    ADD CONSTRAINT _extensionsinfo_pkey PRIMARY KEY (_idrref);


--
-- Name: config config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY config
    ADD CONSTRAINT config_pkey PRIMARY KEY (filename, partno);


--
-- Name: configcas configcas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY configcas
    ADD CONSTRAINT configcas_pkey PRIMARY KEY (filename, partno);


--
-- Name: configcassave configcassave_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY configcassave
    ADD CONSTRAINT configcassave_pkey PRIMARY KEY (filename, partno);


--
-- Name: configsave configsave_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY configsave
    ADD CONSTRAINT configsave_pkey PRIMARY KEY (filename, partno);


--
-- Name: depotfiles depotfiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY depotfiles
    ADD CONSTRAINT depotfiles_pkey PRIMARY KEY (filename, partno);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY files
    ADD CONSTRAINT files_pkey PRIMARY KEY (filename, partno);


--
-- Name: params params_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY params
    ADD CONSTRAINT params_pkey PRIMARY KEY (filename, partno);


--
-- Name: v8users v8users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY v8users
    ADD CONSTRAINT v8users_pkey PRIMARY KEY (id);


--
-- Name: _commonsettin_bykey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _commonsettin_bykey ON _commonsettings USING btree (_userid, _objectkey, _settingskey);

ALTER TABLE _commonsettings CLUSTER ON _commonsettin_bykey;


--
-- Name: _dynlistsetti_bykey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _dynlistsetti_bykey ON _dynlistsettings USING btree (_userid, _objectkey, _settingskey);

ALTER TABLE _dynlistsettings CLUSTER ON _dynlistsetti_bykey;


--
-- Name: _frmdtsetting_bykey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _frmdtsetting_bykey ON _frmdtsettings USING btree (_userid, _objectkey, _settingskey);

ALTER TABLE _frmdtsettings CLUSTER ON _frmdtsetting_bykey;


--
-- Name: _repsettings_bykey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _repsettings_bykey ON _repsettings USING btree (_userid, _objectkey, _settingskey);

ALTER TABLE _repsettings CLUSTER ON _repsettings_bykey;


--
-- Name: _repvarsettin_bykey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _repvarsettin_bykey ON _repvarsettings USING btree (_userid, _objectkey, _settingskey);

ALTER TABLE _repvarsettings CLUSTER ON _repvarsettin_bykey;


--
-- Name: _systemsettin_bykey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _systemsettin_bykey ON _systemsettings USING btree (_userid, _objectkey, _settingskey);

ALTER TABLE _systemsettings CLUSTER ON _systemsettin_bykey;


--
-- Name: _usersworkhis_byid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX _usersworkhis_byid ON _usersworkhistory USING btree (_id);


--
-- Name: _usersworkhis_byuserdate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _usersworkhis_byuserdate ON _usersworkhistory USING btree (_userid, _date);


--
-- Name: _usersworkhis_byuserurlhash; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _usersworkhis_byuserurlhash ON _usersworkhistory USING btree (_userid, _urlhash, _date);

ALTER TABLE _usersworkhistory CLUSTER ON _usersworkhis_byuserurlhash;


--
-- Name: bydescr; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bydescr ON v8users USING btree (descr);


--
-- Name: byeauth; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX byeauth ON v8users USING btree (admrole, eauth);


--
-- Name: byname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX byname ON v8users USING btree (name);


--
-- Name: byosname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX byosname ON v8users USING btree (osname);


--
-- Name: byrolesid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX byrolesid ON v8users USING btree (rolesid);


--
-- Name: byshow; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX byshow ON v8users USING btree (show);


--
-- PostgreSQL database dump complete
--

