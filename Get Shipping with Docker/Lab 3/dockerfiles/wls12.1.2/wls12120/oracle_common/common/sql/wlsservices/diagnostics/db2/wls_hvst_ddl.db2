CREATE TABLE WLS_HVST ( 
  RECORDID DECIMAL(20,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  TIMESTAMP DECIMAL(20,0) DEFAULT NULL, 
  DOMAIN VARCHAR(250) DEFAULT NULL, 
  SERVER VARCHAR(250) DEFAULT NULL, 
  TYPE VARCHAR(250) DEFAULT NULL, 
  NAME VARCHAR(250) DEFAULT NULL, 
  ATTRNAME VARCHAR(250) DEFAULT NULL, 
  ATTRTYPE DECIMAL(10,0) DEFAULT NULL, 
  ATTRVALUE VARCHAR(4000) DEFAULT NULL, 
  WLDFMODULE VARCHAR(250) DEFAULT NULL
  )@

ALTER TABLE WLS_HVST ADD WLDFMODULE VARCHAR(250) DEFAULT NULL@

--BEGIN
--
--  DECLARE this_schema VARCHAR(250);
--
--  SET this_schema = VALUES CURRENT SCHEMA;
--  
--  BEGIN ATOMIC
--    IF NOT EXISTS(
--      SELECT * FROM SYSCAT.TABLES WHERE TABSCHEMA = this_schema AND TABNAME = 'WLS_HVST'
--      ) THEN
--CREATE TABLE WLS_HVST ( 
--  RECORDID DECIMAL(20,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--  TIMESTAMP DECIMAL(20,0) DEFAULT NULL, 
--  DOMAIN VARCHAR(250) DEFAULT NULL, 
--  SERVER VARCHAR(250) DEFAULT NULL, 
--  TYPE VARCHAR(250) DEFAULT NULL, 
--  NAME VARCHAR(250) DEFAULT NULL, 
--  ATTRNAME VARCHAR(250) DEFAULT NULL, 
--  ATTRTYPE DECIMAL(10,0) DEFAULT NULL, 
--  ATTRVALUE VARCHAR(4000) DEFAULT NULL, 
--  WLDFMODULE VARCHAR(250) DEFAULT NULL
--  );  
--    END IF;
--  END
--
--  BEGIN ATOMIC
--    IF NOT EXISTS(
--      SELECT * FROM SYSCAT.COLUMNS WHERE TABSCHEMA = this_schema AND TBNAME = 'WLS_HVST' AND NAME ='WLDFMODULE'
--      ) THEN
--        ALTER TABLE WLS_HVST ADD WLDFMODULE VARCHAR(250) DEFAULT NULL;
--    END IF;
--  END
--
--END