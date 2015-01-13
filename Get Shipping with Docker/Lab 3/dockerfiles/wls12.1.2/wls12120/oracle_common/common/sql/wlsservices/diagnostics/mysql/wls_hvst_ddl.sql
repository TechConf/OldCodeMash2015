DROP PROCEDURE if exists create_alter_wls_hvst
/

CREATE PROCEDURE create_alter_wls_hvst() 
language sql
BEGIN
  CREATE TABLE IF NOT EXISTS WLS_HVST
  (
    RECORDID BIGINT AUTO_INCREMENT PRIMARY KEY,
    TIMESTAMP BIGINT NOT NULL,
    DOMAIN VARCHAR(250) default NULL,
    SERVER VARCHAR(250) default NULL,
    TYPE VARCHAR(250) default NULL,
    NAME VARCHAR(250) default NULL,
    SCOPE VARCHAR(250) default NULL,
    ATTRNAME VARCHAR(250) default NULL,
    ATTRTYPE INT default NULL,
    ATTRVALUE VARCHAR(4000) default NULL,
    WLDFMODULE VARCHAR(250) default NULL,
    INDEX(TIMESTAMP)
  );

  IF NOT EXISTS(
    SELECT * FROM `information_schema`.`COLUMNS`
      WHERE COLUMN_NAME='WLDFMODULE' AND TABLE_NAME='WLS_HVST') THEN 
      ALTER TABLE `WLS_HVST` ADD `WLDFMODULE` varchar(250) default NULL;
  END IF;

END
/

CALL create_alter_wls_hvst()
/

DROP PROCEDURE if exists create_alter_wls_hvst
/

