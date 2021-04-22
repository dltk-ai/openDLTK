-- Adminer 4.6.3 PostgreSQL dump

DROP TABLE IF EXISTS "oauth_client_details";
CREATE TABLE "public"."oauth_client_details" (
    "client_id" character varying(256) NOT NULL,
    "resource_ids" character varying(256),
    "client_secret" character varying(256),
    "scope" character varying(256),
    "authorized_grant_types" character varying(256),
    "web_server_redirect_uri" character varying(256),
    "authorities" character varying(256),
    "access_token_validity" integer,
    "refresh_token_validity" integer,
    "additional_information" character varying(4096),
    "autoapprove" character varying(256),
    CONSTRAINT "oauth_client_details_pkey" PRIMARY KEY ("client_id")
) WITH (oids = false);

INSERT INTO "oauth_client_details" ("client_id", "resource_ids", "client_secret", "scope", "authorized_grant_types", "web_server_redirect_uri", "authorities", "access_token_validity", "refresh_token_validity", "additional_information", "autoapprove") VALUES
('planck',	'',	'$2a$04$uxzfzfJJZv83cmMx0XNIJuZU3Km1bmy9SCuH.d21f1nRsQt3tYY1y',	'user,read,write',	'password,refresh_token',	NULL,	NULL,	36000,	36000,	NULL,	'true'),

DROP TABLE IF EXISTS "roles";
CREATE TABLE "public"."roles" (
    "role_id" bigint NOT NULL,
    "role" character varying(255),
    CONSTRAINT "roles_pkey" PRIMARY KEY ("role_id")
) WITH (oids = false);


DROP TABLE IF EXISTS "users";
CREATE TABLE "public"."users" (
    "user_id" bigint NOT NULL,
    "access_level" character varying(255),
    "active" integer,
    "created_at" bigint,
    "deleted_at" character varying(255),
    "email_id" character varying(100),
    "first_name" character varying(255),
    "last_name" character varying(255),
    "middle_name" character varying(255),
    "mobile" character varying(15) NOT NULL,
    "password" character varying(255) NOT NULL,
    "photo" character varying(255),
    "updated_at" bigint,
    "user_name" character varying(255),
    CONSTRAINT "uk_63cf888pmqtt5tipcne79xsbm" UNIQUE ("mobile"),
    CONSTRAINT "uk_pwrpg821nujmmnavoq7s420jn" UNIQUE ("email_id"),
    CONSTRAINT "users_pkey" PRIMARY KEY ("user_id")
) WITH (oids = false);


DROP TABLE IF EXISTS "users_roles";
CREATE TABLE "public"."users_roles" (
    "muser_user_id" bigint NOT NULL,
    "roles_role_id" bigint NOT NULL,
    CONSTRAINT "uk_l788kmq37iyb0eq3yffld1tbr" UNIQUE ("muser_user_id", "roles_role_id"),
    CONSTRAINT "fkmsuiw658qgus9b4ew6kehfx60" FOREIGN KEY (muser_user_id) REFERENCES users(user_id) NOT DEFERRABLE,
    CONSTRAINT "fktgou1kvdhyryu3fia6uu1fhoi" FOREIGN KEY (roles_role_id) REFERENCES roles(role_id) NOT DEFERRABLE
) WITH (oids = false);


-- 2018-09-27 08:38:44.650193+00