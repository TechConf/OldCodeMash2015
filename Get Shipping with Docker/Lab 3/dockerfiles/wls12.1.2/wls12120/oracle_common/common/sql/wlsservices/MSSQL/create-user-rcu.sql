--
--
-- create-user-rcu.sql
--
-- Copyright (c) 2006, 2009, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--    NAME
--     create-user-rcu.sql - Create login, db user and schema on SQL Server
--
--    DESCRIPTION
--    This file creates db user, login and schema on SQL server. To
--    be used only by RCU.
--
--    MODIFIED   (MM/DD/YY)
--    alai        06/07/11 - Created
--

go
SET NOCOUNT ON
go

-- Assign database name which is passed in as V1 to DATABASE_NAE
:SETVAR DATABASE_NAME  $(v1)
go

-- Assign user name which is passed in as V2 to SCHEMA_USER
:SETVAR SCHEMA_USER  $(v2)
go

-- Assign user name which is passed in as V3 to SCHEMA_PASSWORD
:SETVAR SCHEMA_PASSWORD  $(v3)
go


-- Invoke createuser.sql to create login, user and schema.
:r createuser.sql
go


