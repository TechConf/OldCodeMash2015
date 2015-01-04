-- Copyright (c) 2006, 2011, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--
-- crelstbs.sql - create leasing tables
-- 
-- NOTES
--    Any changes made to this script should be replicated to the same file
--    under the oracle_ebr folder for creating the EBR-enabled schema tables.
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
  SELECT COUNT(*) INTO CNT FROM USER_TABLES WHERE TABLE_NAME = 'ACTIVE';

  IF (CNT > 0) THEN
    EXECUTE IMMEDIATE 'drop table ACTIVE';
  END IF;

END;
/

CREATE TABLE ACTIVE (
  SERVER VARCHAR2(150) NOT NULL,
  INSTANCE VARCHAR2(100) NOT NULL,
  DOMAINNAME VARCHAR2(50) NOT NULL,
  CLUSTERNAME VARCHAR2(50) NOT NULL,
  TIMEOUT DATE,
  PRIMARY KEY (SERVER, DOMAINNAME, CLUSTERNAME)
);



