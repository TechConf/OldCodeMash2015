Rem
Rem crecomptbl.sql
Rem
Rem Copyright (c) 2012, Oracle and/or its affiliates. All rights reserved. 
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

-- Define table parameters 
define tabparams="ENGINE=InnoDB DEFAULT CHARACTER SET=UTF8MB4 DEFAULT COLLATE=UTF8MB4_BIN ROW_FORMAT=DYNAMIC";


CREATE TABLE COMPONENT_SCHEMA_INFO
(
  SCHEMA_USER     VARCHAR(50) NOT NULL,
  SCHEMA_PASSWORD BLOB ,
  COMP_ID         VARCHAR(50) NOT NULL,
  PREFIX_NAME     VARCHAR(50) ,
  DB_HOSTNAME     VARCHAR(50) ,
  DB_SERVICE      VARCHAR(50) ,
  DB_PORTNUMBER   VARCHAR(10),
  DATABASE_NAME   VARCHAR(50),
  STATUS          VARCHAR(20)
)
$tabparams 
/

CREATE INDEX COMPONENT_SCHEMA_INFO_IDX ON COMPONENT_SCHEMA_INFO(SCHEMA_USER)
/

