--
--
-- dropmdusr-rcu.sql
--
-- Copyright (c) 2006, 2012, Oracle. All rights reserved.  
--
--    NAME
--    dropsvctbluser-rcu.SQL - Drop MDS Login, User and Schema
--
--    DESCRIPTION
--    Drop login, user and schema that were created for SVCTBL.
--    It has to be run from an administrator account.  This script is supposed
--    to be used by RCU only.
--
--    MODIFIED   (MM/DD/YY)
--    znazib      10/04/12   - Created
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

-- Invoke cremduser.sql to create MDS login, user and schema.
:r dropsvctbluser.sql
go


