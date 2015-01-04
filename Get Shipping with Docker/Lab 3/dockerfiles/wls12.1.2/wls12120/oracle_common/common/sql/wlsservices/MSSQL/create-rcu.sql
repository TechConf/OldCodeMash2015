--
-- cremds.sql
--
-- Copyright (c) 2006, 2010, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--    NAME
--      create-rcu.sql - <one-line expansion of the name>
--
--    DESCRIPTION
--    This file creates the database schema for the repository.
--
--    The user should also have grant to create sequence in order to
--    successfully use the MDS Repository.
--
--    MODIFIED   (MM/DD/YY)
--    alai        01/12/12 - Created
--
--

go
SET NOCOUNT ON
set implicit_transactions off
-- begin transaction 
go

-- Creating the tables and views
:r crejstbs.sql
:r crelstbs.sql
:r ../diagnostics/sqlserver/wls_events_ddl.sql
:r ../diagnostics/sqlserver/wls_hvst_ddl.sql

-- Creating the indexes

-- Creating the package specs

go

-- commit transaction 
go

