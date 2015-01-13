--
--
-- cremds-rcu.sql
--
-- Copyright (c) 2006, 2012, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--    NAME
--     create-rcu.sql - create SVCTBL repository.
--
--    DESCRIPTION
--    This file creates the database schema for the repository. To
--    be used only by RCU.
--
--    NOTES
--    All objects will be created under the schema that is associated with
--    the current login user.  Please make sure the login user is created
--    with correct authorities and associated with correct schema.  You 
--    can either use create-user.sql to create the user or refer the script
--    to create the user properly.
--
--
--    MODIFIED   (MM/DD/YY)
--    znazib       10/04/12 - Created
--

go
SET NOCOUNT ON
go

-- Assign database name which is passed in as V1 to DATABASE_NAE
:SETVAR DATABASE_NAME  $(v1)
go

-- Assign unicode prefix which is passed in as V2 to SVCTBL_VARCHAR
:SETVAR SVCTBL_VARCHAR  $(v2)
go

-- Switch to use the database
USE $(DATABASE_NAME)
go

-- Invoke cresvctbl.sql to create ServiceTable repositary objects.
:r cresvctbl.sql
go

-- Invoke crecomptbl.sql to create ShadowTable repositary objects.
:r crecomptbl.sql
go


