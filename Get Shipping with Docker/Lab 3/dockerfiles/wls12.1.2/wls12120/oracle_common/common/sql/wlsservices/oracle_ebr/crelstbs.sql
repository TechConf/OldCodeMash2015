-- Copyright (c) 2006, 2011, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--
-- crelstbs.sql - create leasing tables
-- 
-- NOTES
--    This script is replicated from the same file under oracle folder
--    for EBR support.
--
-- MODIFIED    (MM/DD/YY)
-- alai         06/07/11  -  Creation. 
--

SET VERIFY OFF


REM Create weblogic services tables for cluster leasing feature

DECLARE
    CNT           NUMBER;
BEGIN

  CNT := 0;
  SELECT COUNT(*) INTO CNT FROM USER_TABLES WHERE TABLE_NAME = 'ACTIVE_';

  IF (CNT > 0) THEN
    EXECUTE IMMEDIATE 'drop table ACTIVE_';
  END IF;

END;
/

CREATE TABLE ACTIVE_ (
  SERVER VARCHAR2(150) NOT NULL,
  INSTANCE VARCHAR2(100) NOT NULL,
  DOMAINNAME VARCHAR2(50) NOT NULL,
  CLUSTERNAME VARCHAR2(50) NOT NULL,
  TIMEOUT DATE,
  PRIMARY KEY (SERVER, DOMAINNAME, CLUSTERNAME)
);

create or replace editioning view ACTIVE as select
  SERVER,
  INSTANCE,
  DOMAINNAME,
  CLUSTERNAME,
  TIMEOUT
 from ACTIVE_;



