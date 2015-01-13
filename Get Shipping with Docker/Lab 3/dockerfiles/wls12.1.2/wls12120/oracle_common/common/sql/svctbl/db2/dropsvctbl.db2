-- Copyright (c) 2006, 2012, Oracle and/or its affiliates. 
-- All rights reserved. 
--
-- dropsvctbl.db2 - SVCTBL metadata services Drop SVCTBL schema objects.
--
--
-- MODIFIED    (MM/DD/YY)
-- znazib       10/04/12 - Created

-- Drop all procedures and functions under current schemas
CREATE PROCEDURE dropSchemaRoutines()
LANGUAGE SQL
BEGIN ATOMIC
    
    DECLARE CNT INTEGER;
    
    DECLARE execStr     VARCHAR(1000);

    DECLARE rtnName     VARCHAR(128);
    DECLARE rtnType     CHAR(1);

    DECLARE retry       SMALLINT;
    DECLARE triedCount  SMALLINT DEFAULT 0; 

    DECLARE SQLSTATE    CHAR(5); 

    DECLARE c_schema_routines CURSOR FOR 
        SELECT SPECIFICNAME, ROUTINETYPE 
             FROM SYSCAT.ROUTINES 
               WHERE (ROUTINETYPE = 'F' OR ROUTINETYPE = 'P') AND 
                OWNERTYPE = 'U' AND
                ROUTINESCHEMA = CURRENT_SCHEMA AND
                LANGUAGE = 'SQL' and ROUTINENAME != 'dropSchemaRoutines'
        FOR READ ONLY;

    SET retry = 1;

    WHILE ( retry = 1 AND triedCount < 10 ) DO
       
        SET retry = 0;
        SET triedCount = triedCount + 1;

        OPEN c_schema_routines;

        delete_routines:
        WHILE (1=1) DO
            FETCH FROM c_schema_routines INTO rtnName, rtnType;

            IF ( SQLSTATE <> '00000' ) THEN
                CLOSE c_schema_routines;

                LEAVE delete_routines;
            END IF;

            BEGIN
                -- If we cannot delete current function due to 
                -- dependency, we will retry it.
                DECLARE CONTINUE HANDLER FOR SQLSTATE '42893'
                BEGIN
                    SET retry = 1;
                END;

                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                BEGIN                    
                END;

                IF ( rtnType = 'F' ) THEN
                    SET execStr = 'drop specific function ' || rtnName;
                ELSE
                    SET execStr = 'drop specific procedure ' || rtnName;
                END IF;

                EXECUTE IMMEDIATE execStr;
            END;
        END WHILE delete_routines;
    END WHILE;
END
@

call dropSchemaRoutines()
@

drop procedure dropSchemaRoutines()
@


-- Drop all types under current schemas for current owner
CREATE PROCEDURE dropSchemaTypes()
LANGUAGE SQL
BEGIN ATOMIC
    
    DECLARE CNT INTEGER;
    
    DECLARE execStr     VARCHAR(1000);

    DECLARE typName     VARCHAR(128);

    DECLARE SQLSTATE    CHAR(5);

    DECLARE c_schema_types CURSOR FOR
        SELECT TYPENAME
          FROM SYSCAT.DATATYPES
          WHERE OWNERTYPE = 'U' AND 
                TYPESCHEMA = CURRENT_SCHEMA
        FOR READ ONLY;

    OPEN c_schema_types;

    delete_loop:
    WHILE (1=1) DO
        FETCH FROM c_schema_types INTO typName;

        IF ( SQLSTATE <> '00000' ) THEN
            CLOSE c_schema_types;

            LEAVE delete_loop;
        END IF;

        SET execStr = 'drop TYPE ' || typName;

        EXECUTE IMMEDIATE execStr;
    END WHILE delete_loop;
END
@

call dropSchemaTypes()
@

drop procedure dropSchemaTypes()
@

-- Drop all trigger under current schemas for current owner
CREATE PROCEDURE dropSchemaTriggers()
LANGUAGE SQL
BEGIN ATOMIC
    
    DECLARE CNT INTEGER;
    
    DECLARE execStr     VARCHAR(1000);

    DECLARE trigName    VARCHAR(128);

    DECLARE SQLSTATE    CHAR(5);

    DECLARE c_schema_triggers CURSOR FOR
        SELECT TRIGNAME
          FROM SYSCAT.TRIGGERS
          WHERE OWNERTYPE = 'U' AND 
                TRIGSCHEMA = CURRENT_SCHEMA
        FOR READ ONLY;

    OPEN c_schema_triggers;

    delete_triggers:
    WHILE (1=1) DO
        FETCH FROM c_schema_triggers INTO trigName;

        IF ( SQLSTATE <> '00000' ) THEN
            CLOSE c_schema_triggers;

            LEAVE delete_triggers;
        END IF;

        SET execStr = 'drop trigger ' || trigName;

        EXECUTE IMMEDIATE execStr;
    END WHILE delete_triggers;
END
@

call dropSchemaTriggers()
@

drop procedure dropSchemaTriggers()
@


-- Drop all variables under current schemas for current owner
CREATE PROCEDURE dropSchemaVariables()
LANGUAGE SQL
BEGIN ATOMIC
    
    DECLARE CNT INTEGER;
    
    DECLARE execStr     VARCHAR(1000);

    DECLARE varName     VARCHAR(128);

    DECLARE SQLSTATE    CHAR(5);

    DECLARE c_schema_variables CURSOR FOR
        SELECT VARNAME
          FROM SYSCAT.VARIABLES
          WHERE OWNERTYPE = 'U' AND 
                VARSCHEMA = CURRENT_SCHEMA
        FOR READ ONLY;

    OPEN c_schema_variables;

    delete_loop:
    WHILE (1=1) DO
        FETCH FROM c_schema_variables INTO varName;

        IF ( SQLSTATE <> '00000' ) THEN
            CLOSE c_schema_variables;

            LEAVE delete_loop;
        END IF;

        SET execStr = 'drop variable ' || varName;

        EXECUTE IMMEDIATE execStr;
    END WHILE delete_loop;
END
@

call dropSchemaVariables()
@

drop procedure dropSchemaVariables()
@

--commit
--@

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

