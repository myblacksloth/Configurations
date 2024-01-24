FROM mongo-express:latest
EXPOSE 8081
# utente
ENV ME_CONFIG_MONGODB_ADMINUSERNAME user
ENV ME_CONFIG_MONGODB_ADMINPASSWORD user

# per il dns interno a docker e' possibile inserire solo il nome del container
ENV ME_CONFIG_MONGODB_SERVER postgrestest_mongodb
# la porta del database e' defnita nel dockerfile
# ma siccome i container lavorano in una docker network non richiedo l'accesso dall'esterno della rete
#       quindi viene usata la porta di default esposta dal container nella rete interna
# ENV ME_CONFIG_MONGODB_PORT


ENV ME_CONFIG_BASICAUTH_USERNAME user
ENV ME_CONFIG_BASICAUTH_PASSWORD user
