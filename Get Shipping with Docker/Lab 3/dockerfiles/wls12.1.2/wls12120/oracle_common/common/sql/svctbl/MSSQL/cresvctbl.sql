--
-- cresvctbl.sql
--
-- Copyright (c) 2012, Oracle and/or its affiliates. All rights reserved. 
--
--    NAME
--      cresvctbl.sql - SQL script to create ServiceTable schema. 
--
--    DESCRIPTION
--    This file creates the database schema for ServiceTable. 
--
--    NOTES
--
--    MODIFIED   (MM/DD/YY)
--    znazib     10/25/12 - Creation
--

if object_id(N'SERVICETABLE', N'U') IS NOT NULL
begin
    drop table SERVICETABLE
end
go

CREATE TABLE SERVICETABLE 
(
  ID VARCHAR(50) PRIMARY KEY, 
  STYPE VARCHAR(50) NOT NULL, 
  ENDPOINT VARCHAR(MAX) NOT NULL, 
  LASTUPDATED datetime NOT NULL, 
  PROMOTED bit NOT NULL,
  VALID bit NOT NULL
)
go


CREATE INDEX SERVICETABLE_IDX ON SERVICETABLE(STYPE);
go