Rem
Rem cresvctbl.sql
Rem
Rem Copyright (c) 2012, Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      cresvctbl.sql - SQL script to create ServiceTable schema. 
Rem
Rem    DESCRIPTION
Rem    This file creates the database schema for ServiceTable. 
Rem
Rem    NOTES
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    znazib     10/25/12 - Creation
Rem

drop table SERVICETABLE;
  
CREATE TABLE "SERVICETABLE"
(
  "ID" VARCHAR2(50) PRIMARY KEY,
  "STYPE" VARCHAR2(50) NOT NULL,
  "ENDPOINT" CLOB NOT NULL,
  "LASTUPDATED" TIMESTAMP NOT NULL,
  "PROMOTED" CHAR(1) check (PROMOTED in ( 'Y', 'N' )) NOT NULL,
  "VALID" CHAR(1) check (VALID in ( 'Y', 'N' )) NOT NULL
);

CREATE INDEX SERVICETABLE_IDX ON SERVICETABLE(STYPE);
