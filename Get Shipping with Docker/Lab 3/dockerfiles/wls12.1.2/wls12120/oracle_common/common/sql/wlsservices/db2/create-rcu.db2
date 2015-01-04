--
--
-- create-rcu.db2
--
-- Copyright (c) 2012, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--    NAME
--     create-rcu.db2 - create repository for Weblogic Services.
--
--    DESCRIPTION
--    This file creates the database schema for the repository. To
--    be used only by RCU.
--
--    NOTES
--
--    MODIFIED   (MM/DD/YY)
--    alai        01/17/12 - Created
--

SET SCHEMA $1@

-- We know that the current schema is the schema that will be used for 
-- Weblogic Services.

-- create tables for Weblogic Services

CREATE TABLE ACTIVE (
  SERVER VARCHAR(150) NOT NULL,
  INSTANCE VARCHAR(100) NOT NULL,
  DOMAINNAME VARCHAR(50) NOT NULL,
  CLUSTERNAME VARCHAR(50) NOT NULL,
  TIMEOUT TIMESTAMP,
  PRIMARY KEY (SERVER, DOMAINNAME, CLUSTERNAME)
) IN $2@

CREATE TABLE WEBLOGIC_TIMERS (
  TIMER_ID VARCHAR(100) NOT NULL,
  LISTENER BLOB(32M) NOT NULL,
  START_TIME DOUBLE NOT NULL,
  INTERVAL DOUBLE NOT NULL,
  TIMER_MANAGER_NAME VARCHAR(100) NOT NULL,
  DOMAIN_NAME VARCHAR(100) NOT NULL,
  CLUSTER_NAME VARCHAR(100) NOT NULL,
  PRIMARY KEY (TIMER_ID, CLUSTER_NAME, DOMAIN_NAME)
) IN $2@

-- Set up the WLDF tables in the schema
--
!../diagnostics/db2/wldf_tables.db2

--commit
--@

