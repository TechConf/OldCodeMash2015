Rem
Rem crecomptbl.sql
Rem
Rem Copyright (c) 2012, Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      crecomptbl.sql - SQL script to create ShadowTable schema. 
Rem
Rem    DESCRIPTION
Rem    This file creates the database schema for ShadowTable. 
Rem
Rem    NOTES
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    znazib     10/25/12 - Creation
Rem

drop table COMPONENT_SCHEMA_INFO;

CREATE TABLE "COMPONENT_SCHEMA_INFO"
(
  "SCHEMA_USER"     VARCHAR2(50) NOT NULL,
  "SCHEMA_PASSWORD" BLOB ,
  "COMP_ID" VARCHAR2(50) NOT NULL,
  "PREFIX_NAME"     VARCHAR2(50) ,
  "DB_HOSTNAME"     VARCHAR2(50) ,
  "DB_SERVICE"      VARCHAR2(50) ,
  "DB_PORTNUMBER"   VARCHAR2(10),
  "DATABASE_NAME"   VARCHAR2(50),
  "STATUS"          VARCHAR2(20)
);


CREATE INDEX COMPONENT_SCHEMA_INFO_IDX ON COMPONENT_SCHEMA_INFO(SCHEMA_USER);


                                      