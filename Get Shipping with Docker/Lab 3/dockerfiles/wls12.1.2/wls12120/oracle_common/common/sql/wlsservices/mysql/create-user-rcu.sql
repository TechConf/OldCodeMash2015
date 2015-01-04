--
--
-- create-user-rcu.sql
--
-- Copyright (c) 2011, Oracle and/or its affiliates. All rights reserved. 
--
--    NAME
--     create-user-rcu.sql - Create schema for Weblogic Services on MySQL. 
--
--    DESCRIPTION
--    This file creates db schema for Weblogic Services on MySQL. To
--    be used only by RCU.
--
--    MODIFIED   (MM/DD/YY)
--    alai        01/13/12 - Created
--

-- Assign schema name which is passed in as $1 to SCHEMA_USER
define SCHEMA_NAME=$1;

define SCHEMA_PASSWORD=$2;     

source create-user.sql

