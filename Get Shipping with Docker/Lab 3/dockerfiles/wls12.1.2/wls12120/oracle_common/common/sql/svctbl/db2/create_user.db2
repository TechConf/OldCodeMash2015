--
--
-- create_user.db2
--
-- Copyright (c) 2006, 2012, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--    NAME
--     create_user.db2 - Create schema for SVCTBL user on DB2. 
--
--    DESCRIPTION
--    This file creates db schema for SVCTBL on IBM db2. To
--    be used only by RCU.
--
--    MODIFIED   (MM/DD/YY)
--    znazib     10/04/12 - Created
--

-- Assign schema name which is passed in as $1 to SCHEMA_USER
define SCHEMA_NAME       = $1
@
define SCHEMA_USER       = $1     
@
define SVCTBL_TABLESPACE = $2
@
define TMP_TABLESPACE    = $3
@

grant use of tablespace $SVCTBL_TABLESPACE to user $SCHEMA_USER
@

grant use of tablespace $TMP_TABLESPACE to user $SCHEMA_USER
@

grant connect on database to user $SCHEMA_USER
@

begin
    declare cnt   smallint default 0;
    declare sql   varchar(256);

    set cnt = (select count(*) from syscat.schemata where schemaname = '$SCHEMA_NAME' and ownertype = 'U');

    if ( cnt > 0 ) then
        -- DB2 doesn't allow grant pri to user itself.
        set sql = 'grant alterin, createin, dropin on schema  $SCHEMA_NAME to $SCHEMA_USER with grant option';
        execute immediate sql;

--        set sql = 'transfer ownership of schema $SCHEMA_NAME to user $SCHEMA_USER preserve privileges';
--        execute immediate sql;
    else
        set sql = 'create schema $SCHEMA_NAME authorization $SCHEMA_USER';
        execute immediate sql;
    end if;
end
@


