FROM mysql:latest

ENV MYSQL_RANDOM_ROOT_PASSWORD yes

ENV MYSQL_DATABASE validator

ENV MYSQL_USER vvadmin

ENV MYSQL_PASSWORD var1ant

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/openvar/VV_databases/blob/master/validator/validator_2020-10-01.sql.gz