FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y mariadb-server netcat

COPY ./maria_conf.sh /maria_conf.sh

RUN chmod +x /maria_conf.sh

# RUN chmod -R 777 ./volumes/mariadb

# EXPOSE 3306

ENTRYPOINT ["./maria_conf.sh"]
