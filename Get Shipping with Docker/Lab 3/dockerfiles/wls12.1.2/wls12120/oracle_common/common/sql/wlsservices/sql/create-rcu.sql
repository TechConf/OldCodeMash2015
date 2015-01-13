Rem
Rem $Header: cremds-rcu.sql 22-oct-2007.15:57:27 gnagaraj Exp $
Rem
Rem create-rcu.sql
Rem
Rem Copyright (c) 2011, Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      create-rcu.sql - RCU SQL script to create Weblogic Services schema. 
Rem
Rem    DESCRIPTION
Rem    This file creates the database schema for weblogic services. To
Rem    be used only by RCU.
Rem
Rem    NOTES
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    alai        06/07/11 - Created from cremds-rcu.sql in MDS
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

ALTER SESSION SET CURRENT_SCHEMA=&&1;

Rem Create Weblogic Services database objects
@@create.sql

Rem If there were any compilations problems this will spit out the 
Rem the errors. uncomment to get errors.
Rem show errors

EXIT;
