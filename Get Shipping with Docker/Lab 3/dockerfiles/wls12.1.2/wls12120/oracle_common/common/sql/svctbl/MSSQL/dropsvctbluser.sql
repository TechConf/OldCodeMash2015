-- Copyright (c) 2006, 2012, Oracle. All rights reserved.  
--
--
-- DROPSVCTBLUSER.SQL - Drop SVCTBL User
--
-- Note:
--   Drop login, user and schema that were created for SVCTBL.
--   This script uses additional feature supported from Microsoft sqlcmd.exe.
--   It has to be run from an administrator account.
--
--   Syntax: sqlcmd -S <server> -U <username> -P <password> -i dropmduser.sql
--                -v SCHEMA_USER="<username>" DATABASE_NAME="<svctbl db>"
--
--   Examples: sqlcmd -S stada66 -U sa -P x -i dropsvctbluser.sql -v SCHEMA_USER="john" DATABASE_NAME="svctbl"
-- 
-- MODIFIED    (MM/DD/YY)
-- znazib       10/04/12   - Created
--
go
set nocount on
set implicit_transactions off
go

-- drop login
PRINT N'-- Drop login --'

declare @loginId   int

select @loginId = principal_id from sys.sql_logins where name = N'$(SCHEMA_USER)'

IF (@loginId is not null)
BEGIN
  drop login $(SCHEMA_USER) 
END
go

-- switch to database
use $(DATABASE_NAME)

-- drop schema
DECLARE @oName    NVARCHAR(257)
DECLARE @iName    NVARCHAR(128)
DECLARE @oType    NVARCHAR(10)
DECLARE @parmDef  NVARCHAR(500)

DECLARE @delSql   NVARCHAR(200)

DECLARE C1 CURSOR GLOBAL FORWARD_ONLY READ_ONLY FOR
  select i.name, s.name  + N'.' + o.name from sys.indexes as i, sys.objects as o , sys.schemas as s 
         where i.object_id = o.object_id and 
              o.schema_id = s.schema_id and 
              s.name = N'$(SCHEMA_USER)' and i.name is not null and
              i.is_unique_constraint = 0 and i.is_primary_key = 0

DECLARE C2 CURSOR GLOBAL FORWARD_ONLY READ_ONLY FOR 
   select s.name + N'.' + o.name, o.type from sys.objects as o , sys.schemas as s 
           where o.schema_id = s.schema_id and s.name = N'$(SCHEMA_USER)'

PRINT N'-- Drop Indexes --'

open C1

-- Delete indexes.


WHILE(1=1)
BEGIN
  FETCH NEXT FROM C1 INTO @iName, @oName
       
  IF (@@FETCH_STATUS <> 0)
  BEGIN
    CLOSE C1
    DEALLOCATE C1
    BREAK
  END

  set @delSql = N'drop index ' +  @iName + N' on ' +  @oName

  exec sp_executesql @delSql        
END

-- delete tables, stored procedures and functions.
PRINT N'-- Drop tables, stored procedures and functions --'

open C2

WHILE(1=1)
BEGIN
  FETCH NEXT FROM C2 INTO @oName, @oType
       
  IF (@@FETCH_STATUS <> 0)
  BEGIN
    CLOSE C2
    DEALLOCATE C2
    BREAK
  END
  
  IF ( @oType = N'U')
  BEGIN
    set @delSql = N'drop table ' + @oName
    exec sp_executesql @delSql
  END
  ELSE IF ( @oType = N'P' )
  BEGIN
    set @delSql = N'drop procedure ' + @oName
    exec sp_executesql @delSql
  END
  ELSE IF ( @oType = N'FN' )
  BEGIN
    set @delSql = N'drop function ' + @oName
    exec sp_executesql @delSql
  END
END
go

PRINT N'-- Drop Schema --'

DECLARE @sid    INT

select @sid = schema_id from sys.schemas where name = N'$(SCHEMA_USER)'

IF (@sid is not null)
BEGIN
    drop schema $(SCHEMA_USER) 
END
go

-- drop user
PRINT N'-- Drop db user --'

declare @userId   int

select @userId = principal_id from sys.database_principals
    where name = N'$(SCHEMA_USER)' and type = N'S'

IF (@userId is not null)
BEGIN
  drop user $(SCHEMA_USER)
END
go

-- drop user in master
use master
go

declare @userId   int

select @userId = principal_id from sys.database_principals
    where name = N'$(SCHEMA_USER)' and type = N'S'

IF (@userId is not null)
BEGIN
  drop user $(SCHEMA_USER)
END
go


PRINT N'Operation completed!'
go







