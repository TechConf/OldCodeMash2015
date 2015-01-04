Rem
Rem $Header: jtmds/src/dbschema/oracleebr/cremds-rcu.sql /main/1 2011/05/10 16:05:30 jhsi Exp $
Rem
Rem create-rcu.sql
Rem
Rem Copyright (c) 2006, 2011, Oracle and/or its affiliates. 
Rem All rights reserved. 
Rem
Rem    NAME
Rem      create-rcu.sql - RCU SQL script to create EBR-enabled schema for
Rem                       Weblogic services. 
Rem
Rem    DESCRIPTION
Rem    This file creates the EBR-enabled database schema for Weblogic services.
Rem    To be used only by RCU.
Rem
Rem    NOTES
Rem    The first parameter is the schema user, the second parameter is 
Rem    the edition name.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    alai        06/07/11 - Created from cremds-rcu.sql in MDS.
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

ALTER SESSION SET CURRENT_SCHEMA=&&1;
Rem ALTER SESSION SET EDITION=&&2;

Rem Create Weblogic services database objects

Rem Creating the tables and views for EBR-enabled schema
Rem NOTE: Minimum Database version required - Oracle 11.2
@@crejstbs
@@crelstbs
@@../diagnostics/oracle/wls_events_ddl.sql
@@../diagnostics/oracle/wls_hvst_ddl.sql

Rem If there were any compilations problems this will spit out the 
Rem the errors. uncomment to get errors.
Rem show errors

EXIT;
