ALTER SESSION SET CURRENT_SCHEMA=&&1;

-- Authorization and Authentication DB

-- Account
CREATE TABLE account (
	id INT NOT NULL,
	-- This is the name used for authentication. It is the same value as the Private Identity.
	username VARCHAR2(100) NOT NULL UNIQUE,
    -- Whether the account is active or not (0 or 1).
	active number(4) NOT NULL,
	-- The time when the account was created.
	createtime TIMESTAMP NOT NULL,
	-- The time for the last change of the account.
	changetime TIMESTAMP NOT NULL,
	-- A textual description of the account.
	description VARCHAR2(100),
	-- The total numner of failed login attempts since the account was created.
	total_failed_logins int NOT NULL,
	-- ??
	current_failed_logins int NOT NULL,
	-- If the account is locked, for how long is it locked.
	lock_duration int,
	-- If the account is locked, when does the lock expire.
	lock_expires_at TIMESTAMP,
	-- When does the account expire, if it is a temporary account.
	account_expires_at TIMESTAMP,
        constraint pk_account PRIMARY KEY (id)
);

CREATE SEQUENCE account_seq;

-- Role
CREATE TABLE role (
	id INT NOT NULL,
	name VARCHAR2(30) NOT NULL UNIQUE,
	description VARCHAR2(100),
	constraint pk_role PRIMARY KEY (id)
);

CREATE SEQUENCE role_seq;

-- Mapping table between User and Role
CREATE TABLE user_role (
	account_id INT NOT NULL,
	role_id INT NOT NULL,
        constraint pk_user_role PRIMARY KEY (account_id,role_id),
        constraint fk_user_role_account FOREIGN KEY (account_id) REFERENCES account(id),
 	constraint fk_user_role_role FOREIGN KEY (role_id) REFERENCES role(id)
);

-- Realm, used in the credentials.
CREATE TABLE realm (
	id INT NOT NULL,
	name VARCHAR2(111) NOT NULL UNIQUE,
        constraint pk_realm PRIMARY KEY (id)
);

CREATE SEQUENCE realm_seq;

-- Credentials
CREATE TABLE credentials (
    id INT NOT NULL,
	account_id INT NOT NULL,
	realm_id INT NOT NULL,
	-- An md5 digest in hex form (always 32 chars) of "username:realm:password".
	md5_digest VARCHAR2(32) NOT NULL,
	constraint pk_credentials PRIMARY KEY (id),
	constraint fk_credentials_realm FOREIGN KEY (realm_id) REFERENCES realm(id)
);

CREATE SEQUENCE credentials_seq;
CREATE UNIQUE INDEX account_realm_ix ON credentials(account_id, realm_id);

INSERT INTO role (id, name, description) VALUES (role_seq.NEXTVAL, 'Location Service', 'Location Service');
COMMIT;

