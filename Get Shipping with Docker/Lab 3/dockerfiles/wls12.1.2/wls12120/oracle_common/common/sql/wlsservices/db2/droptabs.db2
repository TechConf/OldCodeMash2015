-- Copyright (c) 2012, Oracle and/or its affiliates. 
-- All rights reserved. 
--
-- droptabs.db2 - Drop table objects.
--
-- NOTE: This is called during schema creation to drop all schema objects that hold
--      user-defined data: tables and sequences. This is not called during upgrades.
--
-- MODIFIED    (MM/DD/YY)
-- alai         01/17/12 - Created
--

-- Drop all sequences under current schema for current owner
CREATE PROCEDURE dropSchemaSequences()
LANGUAGE SQL
BEGIN ATOMIC
    
    DECLARE CNT INTEGER;
    
    DECLARE execStr     VARCHAR(1000);

    DECLARE seqName     VARCHAR(128);

    DECLARE SQLSTATE    CHAR(5);

    DECLARE c_schema_sequences CURSOR FOR
        SELECT SEQNAME
          FROM SYSCAT.SEQUENCES
          WHERE OWNERTYPE = 'U' AND 
                SEQTYPE = 'S' AND
                SEQSCHEMA = CURRENT_SCHEMA
        FOR READ ONLY;

    OPEN c_schema_sequences;

    delete_loop:
    WHILE (1=1) DO
        FETCH FROM c_schema_sequences INTO seqName;

        IF ( SQLSTATE <> '00000' ) THEN
            CLOSE c_schema_sequences;

            LEAVE delete_loop;
        END IF;

        SET execStr = 'drop SEQUENCE ' || seqName;

        EXECUTE IMMEDIATE execStr;
    END WHILE delete_loop;
END
@

call dropSchemaSequences()
@

drop procedure dropSchemaSequences()
@

-- Drop all tables under current schemas for current owner.
CREATE PROCEDURE dropSchemaTables()
LANGUAGE SQL
BEGIN ATOMIC
    
    DECLARE CNT INTEGER;
    
    DECLARE execStr     VARCHAR(1000);

    DECLARE tabName     VARCHAR(128);

    DECLARE SQLSTATE    CHAR(5);

    DECLARE c_schema_tables CURSOR FOR
        SELECT TABNAME
          FROM SYSCAT.TABLES
          WHERE TYPE = 'T' AND 
                OWNERTYPE = 'U' AND
                TABSCHEMA = CURRENT_SCHEMA
        FOR READ ONLY;

    OPEN c_schema_tables;

    delete_tables:
    WHILE (1=1) DO
        FETCH FROM c_schema_tables INTO tabName;

        IF ( SQLSTATE <> '00000' ) THEN
            CLOSE c_schema_tables;

            LEAVE delete_tables;
        END IF;

        SET execStr = 'drop table ' || tabName;

        EXECUTE IMMEDIATE execStr;
    END WHILE delete_tables;
END
@

call dropSchemaTables()
@

drop procedure dropSchemaTables()
@

