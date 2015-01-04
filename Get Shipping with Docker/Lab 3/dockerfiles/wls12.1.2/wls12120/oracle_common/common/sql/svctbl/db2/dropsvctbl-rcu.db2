-- Copyright (c) 2006, 2012, Oracle and/or its affiliates. 
-- All rights reserved. 
--
-- DROPSVCTBL-RCU.DB2 - SVCTBL metadata services Drop SVCTBL schema objects used by RCU
--
-- MODIFIED    (MM/DD/YY)
--   znazib     10/04/12 - created.
--
-- Assign schema name which is passed in as $1 to SCHEMA_NAME
define SCHEMA_NAME     =  $1 
@

SET SCHEMA=$SCHEMA_NAME
@

SET PATH=SYSTEM PATH, $SCHEMA_NAME
@

!dropsvctbl.db2

-- Restore current schema
SET SCHEMA=USER
@

-- Restore current path 
SET PATH=SYSTEM PATH, USER
@
--commit
--@

