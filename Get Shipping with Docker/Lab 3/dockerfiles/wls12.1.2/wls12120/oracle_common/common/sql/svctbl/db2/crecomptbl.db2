--
-- crecomptbl.db2
--
-- Copyright (c) 2012, Oracle and/or its affiliates. All rights reserved. 
--
--    NAME
--      crecomptbl.db2 - SQL script to create ShadowTable schema. 
--
--    DESCRIPTION
--    This file creates the database schema for ShadowTable. 
--
--    NOTES
--
--    MODIFIED   (MM/DD/YY)
--    znazib     10/25/12 - Creation
--


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
$IN_TABLESPACE
@

CREATE INDEX COMPONENT_SCHEMA_INFO_IDX ON COMPONENT_SCHEMA_INFO(SCHEMA_USER)
@

