#!/bin/bash

echo "Creating Databases"

PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -c "CREATE DATABASE kong"
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -c "CREATE DATABASE dltk_solution"
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -c "CREATE DATABASE dltk_machinelearning_wrapper"
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -c "CREATE DATABASE dltk_machinelearning_weka"
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -c "CREATE DATABASE dltkml_h2o"
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -c "CREATE DATABASE dltkml_scikit"
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -c "CREATE DATABASE dltk_web_db"
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -c "CREATE DATABASE dltk_helpdesk"
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -c "CREATE DATABASE metabase"


# Migrations
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -d kong < /var/pgdump/kong_pgdump.sql &&
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -d dltk_solution < /var/pgdump/base_pgdump.sql &&
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -d dltk_machinelearning_wrapper < /var/pgdump/ml_pgdump.sql &&
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -d dltk_machinelearning_weka < /var/pgdump/ml_weka_pgdump.sql &&
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -d dltk_helpdesk < /var/pgdump/helpdesk_pgdump.sql &&
PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -d metabase < /var/pgdump/metabase_pgdump.sql &&

echo "------AUTH mode -------"
echo "${AUTH_ENABLED}";

s2="true"

if [ "${AUTH_ENABLED}" == "true" ]; then
	PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -d kong < /var/pgdump/auth_enabled.sql
fi


if [ "${AUTH_ENABLED}" == "false" ]; then
	PGPASSWORD="${SQL_PASSWORD:-postgres}" psql -h "${SQL_HOST:-dltk-postgres}" -p "${SQL_PORT:-5432}" -U "${SQL_USER:-postgres}" -d kong < /var/pgdump/auth_disabled.sql
fi

echo "done"
