all: up

up: build
	docker-compose -f ./docker-compose.yml up -d
	
build: create-volumes
	docker-compose -f ./docker-compose.yml build

# Create required volume directories
create-volumes:
	mkdir -p /home/simo/docker-volumes/mariadb
	mkdir -p /home/simo/docker-volumes/wordpress
	sudo chown -R 999:999 /home/simo/docker-volumes/mariadb
	sudo chmod -R 750 /home/simo/docker-volumes/mariadb

# Stop and remove containers, networks, and volumes
down:
	docker-compose -f ./docker-compose.yml down

# Stop only the containers
stop:
	docker-compose -f ./docker-compose.yml stop

# Start existing containers
start:
	docker-compose -f ./docker-compose.yml start
