-- Copyright (c) 2006, 2012, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--
-- ccreate_user.sql - Create login, db user and schema for SVCTBL on SQL Server
--
-- Note:
--   Create login, user and schema and default_database to the
--   database used by SVCTBL.  This script should be executed using
--   sqlcmd utlity.
--
--   Syntax: sqlcmd -S <server> -U <username> -P <password> -i create_user.sql
--                -v SCHEMA_USER="<new username>" SCHEMA_PASSWORD="<password>" DATABASE_NAME="<svctbl db>"
--
--   Examples: sqlcmd -S stada66 -U mds -P x -i create_user.sql -v SCHEMA_USER="john" SCHEMA_PASSWORD="x" DATABASE_NAME="svctbl"
--             sqlcmd -S iwinrea22,5561 -U sa -P x -i create_user.sql -v SCHEMA_USER="john" SCHEMA_PASSWORD="x" DATABASE_NAME="svctbl"
-- 
-- MODIFIED    (MM/DD/YY)
-- znazib       10/04/12   - Creation a SVCTBL user
--


go
SET NOCOUNT ON
go

-- Assign database name which is passed in as V1 to DATABASE_NAE
:SETVAR DATABASE_NAME  $(v1)
go

-- Assign user name which is passed in as V2 to SCHEMA_USER
:SETVAR SCHEMA_USER  $(v2)
go

-- Assign user name which is passed in as V3 to SCHEMA_PASSWORD
:SETVAR SCHEMA_PASSWORD  $(v3)
go

go
set nocount on
set implicit_transactions off
go

-- Try to drop all object first
-- :r dropmduser.sql

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



