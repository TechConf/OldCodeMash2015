define username = &1
define password = &2
define default_tablespace = &3
define temp_tablespace = &4

CREATE USER &&username IDENTIFIED BY &&password
    DEFAULT TABLESPACE &&default_tablespace
    TEMPORARY TABLESPACE &&temp_tablespace;

-- Figure out if we should grant quota on tablespace
ALTER USER &&username QUOTA UNLIMITED ON &&default_tablespace;

GRANT CREATE SESSION TO &&username;