Rem
Rem cresvctbl.sql
Rem
Rem Copyright (c) 2012, Oracle and/or its affiliates. All rights reserved. 
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

-- Define table parameters 
define tabparams="ENGINE=InnoDB DEFAULT CHARACTER SET=UTF8MB4 DEFAULT COLLATE=UTF8MB4_BIN ROW_FORMAT=DYNAMIC";

CREATE TABLE SERVICETABLE 
(
  ID VARCHAR(50) PRIMARY KEY, 
  STYPE VARCHAR(50) NOT NULL,
  ENDPOINT TEXT NOT NULL, 
  LASTUPDATED datetime NOT NULL, 
  PROMOTED BOOLEAN NOT NULL,
  VALID BOOLEAN NOT NULL 
)
$tabparams 
/

CREATE INDEX SERVICETABLE_IDX ON SERVICETABLE(STYPE)
/

