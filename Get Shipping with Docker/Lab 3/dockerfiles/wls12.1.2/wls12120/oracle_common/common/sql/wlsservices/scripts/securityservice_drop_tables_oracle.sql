define username = &1

ALTER SESSION SET CURRENT_SCHEMA=&&username;

DROP INDEX account_realm_ix;

DROP SEQUENCE credentials_seq;
DROP SEQUENCE realm_seq;
DROP SEQUENCE account_seq;
DROP SEQUENCE role_seq;

DROP TABLE user_role;
DROP TABLE role;
DROP TABLE credentials;
DROP TABLE realm;
DROP TABLE account;
