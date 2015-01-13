-- Copyright (c) 2006, 2011, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--
-- crejstbs.sql - create job scheduler tables
-- 
-- NOTES
--    This script is replicated from the same file under oracle folder
--    for EBR support.
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
  SELECT COUNT(*) INTO CNT FROM USER_TABLES WHERE TABLE_NAME = 'WEBLOGIC_TIMERS_';

  IF (CNT > 0) THEN
    EXECUTE IMMEDIATE 'drop table WEBLOGIC_TIMERS_';
  END IF;

END;
/

CREATE TABLE WEBLOGIC_TIMERS_ (
  TIMER_ID VARCHAR2(100) NOT NULL,
  LISTENER BLOB NOT NULL,
  START_TIME NUMBER NOT NULL,
  INTERVAL NUMBER NOT NULL,
  TIMER_MANAGER_NAME VARCHAR2(100) NOT NULL,
  DOMAIN_NAME VARCHAR2(100) NOT NULL,
  CLUSTER_NAME VARCHAR2(100) NOT NULL,
  PRIMARY KEY (TIMER_ID, CLUSTER_NAME, DOMAIN_NAME)
);

create or replace editioning view WEBLOGIC_TIMERS as select
  TIMER_ID,
  LISTENER,
  START_TIME,
  INTERVAL,
  TIMER_MANAGER_NAME,
  DOMAIN_NAME,
  CLUSTER_NAME 
 from WEBLOGIC_TIMERS_;


