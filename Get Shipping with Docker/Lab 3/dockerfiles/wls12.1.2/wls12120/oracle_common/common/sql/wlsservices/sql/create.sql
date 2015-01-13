Rem
Rem
Rem create.sql
Rem
Rem Copyright (c) 2011, Oracle and/or its affiliates. 
Rem All rights reserved. 
Rem
Rem    NAME
Rem      create.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem    This file creates the database schema for the repository.
Rem
Rem    NOTES
Rem    The database user must have grant to create sequence in order to
Rem    successfully use the weblogic services features.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    alai        06/07/11 - Created from cremds.sql
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

Rem Creating the tables and views
@@crejstbs
@@crelstbs
@@../diagnostics/oracle/wls_events_ddl.sql
@@../diagnostics/oracle/wls_hvst_ddl.sql

EXIT;
