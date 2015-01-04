Rem
Rem $Header: jtmds/src/dbschema/oracleebr/mds_user.sql /main/1 2011/05/10 16:05:30 jhsi Exp $
Rem
Rem Copyright (c) 2011, Oracle and/or its affiliates. All rights reserved. 
Rem
Rem    NAME
Rem      create_user.sql - Create user for EBR-enabled WebLogic Services
Rem                        Repository
Rem
Rem    DESCRIPTION
Rem      The file is used to create EBR-enabled schema user for WebLogic 
Rem      Services Repository.  To be used only by RCU.
Rem
Rem    NOTES
Rem      The first 4 parameters are passed to the general create_user.sql for 
Rem      creating the user on Oracle database. The fifth parameter is the 
Rem      edition name which must already exist in the database.
Rem      Enables the edition after creating the schema user. 
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    alai        09/24/12 - bug 14613844 Grant create view privilege to user
Rem    alai        06/07/11 - Created from mds_user.sql in MDS.
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
GRANT CREATE VIEW to &&1;

EXIT;
