-- Copyright (c) 2006, 2011, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--
-- crejstbs.sql - create job scheduler tables for SQL Server
-- 
-- MODIFIED    (MM/DD/YY)
-- alai         01/12/12  -  Creation. 
--

go
set nocount on
-- begin transaction crejstbs
go

-- Create job scheduler table
if object_id(N'WEBLOGIC_TIMERS', N'U') IS NOT NULL
begin
    drop table WEBLOGIC_TIMERS
end
go


create table WEBLOGIC_TIMERS (
  TIMER_ID VARCHAR(100) NOT NULL,
  LISTENER IMAGE NOT NULL,
  START_TIME NUMERIC(19) NOT NULL,
  INTERVAL NUMERIC(19) NOT NULL,
  TIMER_MANAGER_NAME VARCHAR(100) NOT NULL,
  DOMAIN_NAME VARCHAR(100) NOT NULL,
  CLUSTER_NAME VARCHAR(100) NOT NULL,
  PRIMARY KEY (TIMER_ID, CLUSTER_NAME, DOMAIN_NAME)
)
go

-- commit transaction crejstbs
go

