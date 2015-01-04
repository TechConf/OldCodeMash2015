--
--
-- create-rcu.sql
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
--
--    MODIFIED   (MM/DD/YY)
--    erwang     10/04/12 - Created
--

-- We know that the current schema is the schema that will be used for SVCTBL.

-- create svctbl table and shadowtable and indexes

source cresvctbl.sql

source crecomptbl.sql


