--
--
-- create-rcu.db2
--
-- Copyright (c) 2006, 2012, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--    NAME
--     create-rcu.db2 - create SVCTBL repository.
--
--    DESCRIPTION
--    This file creates the database schema for the repository. To
--    be used only by RCU.
--
--    NOTES
--
--    MODIFIED   (MM/DD/YY)
--    znazib      10/04/12 - Created
--

-- Get DEFAULT_TABLESPACE which is passed in as $1
define  IN_TABLESPACE = "IN $1"
@

-- create ServiceTable and indexes
!cresvctbl.db2

-- create ShadowTable and indexes
!crecomptbl.db2

