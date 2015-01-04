-- Copyright (c) 2006, 2011, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--
-- crejstbs.sql - create job scheduler tables
-- 
-- NOTES
--    Any changes made to this script should be replicated to the same file
--    under the oracle_ebr folder for creating the EBR-enabled schema tables.
--
-- MODIFIED    (MM/DD/YY)
-- alai         06/07/11  -  Creation. 
--

SET VERIFY OFF


REM Create weblogic services tables for job scheduler

DECLARE
    CNT           NUMBER;
BEGIN

  CNT := 0;
  SELECT COUNT(*) INTO CNT FROM USER_TABLES WHERE TABLE_NAME = 'WEBLOGIC_TIMERS';

  IF (CNT > 0) THEN
    EXECUTE IMMEDIATE 'drop table WEBLOGIC_TIMERS';
  END IF;

END;
/

CREATE TABLE WEBLOGIC_TIMERS (
  TIMER_ID VARCHAR2(100) NOT NULL,
  LISTENER BLOB NOT NULL,
  START_TIME NUMBER NOT NULL,
  INTERVAL NUMBER NOT NULL,
  TIMER_MANAGER_NAME VARCHAR2(100) NOT NULL,
  DOMAIN_NAME VARCHAR2(100) NOT NULL,
  CLUSTER_NAME VARCHAR2(100) NOT NULL,
  PRIMARY KEY (TIMER_ID, CLUSTER_NAME, DOMAIN_NAME)
);



