FROM mongo:6.0.13-jammy
EXPOSE 27017

# show dbs
#   -v data-vol:/data/db

# ARG MONGO_INITDB_ROOT_USERNAME
# ARG MONGO_INITDB_ROOT_PASSWORD
# ARG MONGO_INITDB_DATABASE

# # dichiaro tutto nel file .env per vedere come si usa ma non funziona perche' gli argomenti servono in fase di build
# # variabili d'ambiente per l'utente di default
# ENV MONGO_INITDB_ROOT_USERNAME user
# ENV MONGO_INITDB_ROOT_PASSWORD user
# # oppure in docker compose
# # environment:
# #             - MONGO_INITDB_ROOT_USERNAME=mongoadmin
# #             - MONGO_INITDB_ROOT_PASSWORD=bdung

# ENV MONGO_INITDB_DATABASE mydb


COPY ./init/init.sh /docker-entrypoint-initdb.d/init.sh
