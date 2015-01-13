Rem
Rem
Rem Copyright (c) 2012, Oracle and/or its affiliates. All rights reserved. 
Rem
Rem    NAME
Rem      create_user.sql - Create user for EBR-enabled SVCTBL Repository
Rem
Rem    DESCRIPTION
Rem      The file is used to create EBR-enabled schema user for SVCTBL
Rem      Repository.  To be used only by RCU.
Rem
Rem    NOTES
Rem      The first 4 parameters are passed to the general create_user.sql for 
Rem      creating the user on Oracle database. The fifth parameter is the 
Rem      edition name which must already exist in the database.
Rem      Enables the edition after creating the schema user. 
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    znazib      10/04/12 - Created using create_user.sql
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

@@../sql/create_user.sql &&1 &&2 &&3 &&4

ALTER USER &&1 ENABLE EDITIONS;
GRANT USE ON EDITION &&5 TO &&1;
GRANT CREATE VIEW TO &&1;

EXIT;
