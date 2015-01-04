-- Copyright (c) 2006, 2011, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--
-- crelstbs.sql - create leasing tables for SQL Server
-- 
-- MODIFIED    (MM/DD/YY)
-- alai         01/12/12  -  Creation. 
--

go
set nocount on
-- begin transaction crelstbs
go

-- Create leasing table
if object_id(N'ACTIVE', N'U') IS NOT NULL
begin
    drop table ACTIVE
end
go


create table ACTIVE (
  SERVER VARCHAR(150) NOT NULL,
  INSTANCE VARCHAR(100) NOT NULL,
  DOMAINNAME VARCHAR(50) NOT NULL,
  CLUSTERNAME VARCHAR(50) NOT NULL,
  TIMEOUT DATETIME,
  PRIMARY KEY (SERVER, DOMAINNAME, CLUSTERNAME)
)
go

-- commit transaction crelstbs
go

