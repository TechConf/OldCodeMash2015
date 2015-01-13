-- Copyright (c) 2006, 2011, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--
-- create-user.sql - Create login, db user and schema for Weblogic
--                   Services  on MySQL 
--
--
-- MODIFIED    (MM/DD/YY)
-- alai         01/13/12   - Creation
--

set @schema_user='$SCHEMA_NAME';

set @schema_password='$SCHEMA_PASSWORD';

-- Default to mysql database
use mysql
/

drop procedure if exists wlssrv_execute_sql;

create procedure wlssrv_execute_sql(sqlStmt varchar(256) character set utf8mb4)
language sql
begin
    SET @sql = sqlStmt;

    PREPARE stmt FROM @sql; 

    EXECUTE stmt;

    DEALLOCATE PREPARE stmt;
end
/

drop procedure if exists wlssrv_create_user
/

create procedure wlssrv_create_user(schema_user     varchar(16) character set utf8mb4, 
                                    schema_password varchar(64) character set utf8mb4)
language sql
begin

  set @schema=null, @charset=null,@collate=null;

  IF ( @schema IS NULL ) THEN
    -- create create schema 
    SET @sql = CONCAT('create schema ', schema_user); 

    call wlssrv_execute_sql(@sql);
  END IF;

  set @count=0;

  -- Create a user who can access to db locally.
  SET @sql = CONCAT('grant all on ', schema_user, '.*', 
           ' to ', schema_user, '@''localhost'' identified by ''', schema_password, '''');

  call wlssrv_execute_sql(@sql);

  SET @sql = CONCAT('grant process on *.*', ' to ', schema_user, '@''localhost''');

  call wlssrv_execute_sql(@sql);

  SET @sql = CONCAT('grant all on ', schema_user, '.*', 
           ' to ', schema_user, '@''%'' identified by ''', schema_password, '''');

  call wlssrv_execute_sql(@sql);

  SET @sql = CONCAT('grant process on *.*', ' to ', schema_user, '@''%''');

  call wlssrv_execute_sql(@sql);

END
/


call wlssrv_create_user(@schema_user, @schema_password)
/

drop procedure if exists wlssrv_create_user
/

drop procedure if exists wlssrv_execute_sql
/
