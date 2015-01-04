Rem
Rem create-rcu.sql
Rem
Rem Copyright (c) 2011, 2012, Oracle and/or its affiliates. 
Rem All rights reserved. 
Rem
Rem    NAME
Rem      create-rcu.sql - RCU SQL script to create ServiceTable schema. 
Rem
Rem    DESCRIPTION
Rem    This file creates the database schema for ServiceTable. To
Rem    be used only by RCU.
Rem
Rem    NOTES
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    znazib     26/06/12 - Creation
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

ALTER SESSION SET CURRENT_SCHEMA=&&1;

Rem Create ServiceTable and ShadowTable database objects
@@cresvctbl.sql
@@crecomptbl.sql

Rem If there were any compilations problems this will spit out the 
Rem the errors. uncomment to get errors.
Rem show errors

EXIT;
