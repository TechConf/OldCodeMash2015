Rem
Rem $Header: jtmds/src/dbschema/oracle/mds_user.sql /main/6 2010/10/14 11:21:32 erwang Exp $
Rem
Rem create_user.sql
Rem
Rem Copyright (c) 2011, Oracle and/or its affiliates. 
Rem All rights reserved. 
Rem
Rem    NAME
Rem      create_user.sql - create database user
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    znazib      06/06/12 - Created
Rem

CREATE USER &&1 IDENTIFIED BY &&2 DEFAULT TABLESPACE &&3 TEMPORARY TABLESPACE &&4;
GRANT connect TO &&1;
GRANT create type TO &&1;
GRANT create procedure TO &&1;
GRANT create table TO &&1;
GRANT create sequence TO &&1;
GRANT create any index to &&1;
GRANT create any trigger to &&1;
GRANT select on schema_version_registry to &&1;

-- Grant the user unlimited quota to the tablespace.
ALTER USER &&1 QUOTA unlimited ON &&3;
