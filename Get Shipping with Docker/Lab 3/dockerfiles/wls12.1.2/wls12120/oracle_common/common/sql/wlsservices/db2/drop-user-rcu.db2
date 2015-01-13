-- Copyright (c) 2012, Oracle and/or its affiliates. 
-- All rights reserved. 
--
-- drop-user-rcu.db2 - Drop Weblogic Services schema objects used by RCU
--
-- MODIFIED    (MM/DD/YY)
--    alai      01/17/12 - Created
--
-- Assign schema name which is passed in as $1 to SCHEMA_NAME
define SCHEMA_NAME     =  $1 
@

SET SCHEMA=$SCHEMA_NAME
@

SET PATH=SYSTEM PATH, $SCHEMA_NAME
@

-- drop schema objects
-- !dropmds.db2

-- drop tables
!droptabs.db2

-- Restore current schema
SET SCHEMA=USER
@

-- Restore current path 
SET PATH=SYSTEM PATH, USER
@
--commit
--@

