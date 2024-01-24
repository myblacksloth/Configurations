FROM postgres:latest

# utente root di default
ENV POSTGRES_USER user
# password di default
ENV POSTGRES_PASSWORD user
# database di default
ENV POSTGRES_DB mydb

EXPOSE 5432

COPY ./init/init.sql /docker-entrypoint-initdb.d/
# non funziona:
# VOLUME ./init/init.sql /docker-entrypoint-initdb.d/
