define username = &1

ALTER SESSION SET CURRENT_SCHEMA=&&username;

DROP INDEX private_identity_id_ix;
DROP TABLE public_identity;
DROP TABLE private_identity;

DROP SEQUENCE private_identity_seq;
DROP SEQUENCE public_identity_seq;
