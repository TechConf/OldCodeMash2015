ALTER SESSION SET CURRENT_SCHEMA=&&1;

-- This database mapps a Private Identity to one or more Public Identities.
-- It is used by for instance the Registrar to verify that a user is registering
-- it's own Public Identity (AOR).

-- Private Identity
CREATE TABLE private_identity (
	id INT NOT NULL,
	private_identity VARCHAR2(100) NOT NULL UNIQUE,
	constraint pk_private_identity PRIMARY KEY (id)
);

-- Public Identity
CREATE TABLE  public_identity (
	id INT NOT NULL,
	public_identity VARCHAR2 (100) NOT NULL UNIQUE,
	private_identity_id INT NOT NULL,
	constraint pk_public_identity PRIMARY KEY (id),
  	constraint fk_public_identity_private_id FOREIGN KEY (private_identity_id) REFERENCES private_identity(id)
);

CREATE INDEX private_identity_id_ix ON public_identity(private_identity_id);

CREATE SEQUENCE private_identity_seq;
CREATE SEQUENCE public_identity_seq;
