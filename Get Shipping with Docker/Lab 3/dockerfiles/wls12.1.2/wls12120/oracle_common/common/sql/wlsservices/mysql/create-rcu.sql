--
--
-- create-rcu.sql
--
-- Copyright (c) 2011, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--    NAME
--     create-rcu.sql - create tables for weblogic core services.
--
--    DESCRIPTION
--    This file creates the database schema for the weblogic core services.
--
--    NOTES
--
--    MODIFIED   (MM/DD/YY)
--    alai       01/13/12 - Created
--

-- We know that the current schema is the schema that will be used.

-- create weblogic core tables and indexes
source crewlstbs.sql
source ../diagnostics/mysql/wls_events_ddl.sql
source ../diagnostics/mysql/wls_hvst_ddl.sql

-- create procedures

--commit
--/

