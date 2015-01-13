-- Copyright (c) 2011, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--
-- createuser.sql - Create login, db user and schema on SQL Server
--
-- Note:
--   Create login, user and schema and default_database to the
--   database used by Weblogic core.  This script should be executed using
--   sqlcmd utlity.
--
--   Syntax: sqlcmd -S <server> -U <username> -P <password> -i createuser.sql
--                -v SCHEMA_USER="<new username>" SCHEMA_PASSWORD="<password>" DATABASE_NAME="<wlscore db>"
--
--   Examples: sqlcmd -S stada66 -U mds -P x -i createuser.sql -v SCHEMA_USER="john" SCHEMA_PASSWORD="x" DATABASE_NAME="wlscore"
--             sqlcmd -S iwinrea22,5561 -U sa -P x -i createuser.sql -v SCHEMA_USER="john" SCHEMA_PASSWORD="x" DATABASE_NAME="wlscore"
-- 
-- MODIFIED    (MM/DD/YY)
-- alai         06/07/11   - Creation. Adopted from cremduser.sql in MDS.
--
go
set nocount on
set implicit_transactions off
go

-- Try to drop all object first
-- :r dropuser.sql

use $(DATABASE_NAME)
go

declare @login  sysname

select @login = name from sys.server_principals where type = N'S' and name = N'$(SCHEMA_USER)'

IF ( @login IS NULL )
BEGIN
  -- create login
  create login $(SCHEMA_USER) with password = N'$(SCHEMA_PASSWORD)', 
         default_database = $(DATABASE_NAME),
         check_expiration = off, check_policy = off
END
ELSE
BEGIN
  -- change login
  alter login $(SCHEMA_USER) with
         default_database = $(DATABASE_NAME),
         check_expiration = off, check_policy = off
END

go


declare @user  int

select @user = principal_id from sys.database_principals where name = N'$(SCHEMA_USER)' and type = N'S'

IF ( @user IS NULL )
BEGIN
  -- create user
  create user $(SCHEMA_USER) for login $(SCHEMA_USER)
END
go

-- create schema
create schema $(SCHEMA_USER) authorization $(SCHEMA_USER)
go

-- alter db user to a new default_schema
alter user $(SCHEMA_USER) with default_schema = $(SCHEMA_USER)
go

GRANT create table, create view, create procedure, 
create function TO $(SCHEMA_USER)
go


-- Add XA user role
use master
go


-- Create a user mapping at master db.
declare @user  int

select @user = principal_id from sys.database_principals where name = N'$(SCHEMA_USER)' and type = N'S'

IF ( @user IS NULL )
BEGIN
  -- create user
  create user $(SCHEMA_USER) for login $(SCHEMA_USER)
END
go

-- alter db user to use dbo schema
alter user $(SCHEMA_USER) with default_schema = dbo
go

declare @pid   int

select @pid = principal_id from master.sys.database_principals 
where name = N'SqlJDBCXAUser' and type = N'R'

IF ( @pid IS NOT NULL )
BEGIN
    exec sp_addrolemember SqlJDBCXAUser, $(SCHEMA_USER)
END
go



