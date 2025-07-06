all: up

create-volumes:
	@mkdir -p /home/mal-mora/docker-volumes/mariadb
	@mkdir -p /home/mal-mora/docker-volumes/wordpress
	@sudo chown -R 1000:1000 /home/mal-mora/docker-volumes/mariadb
	@sudo chmod -R 750 /home/mal-mora/docker-volumes/mariadb

build: create-volumes
	docker-compose -f ./docker-compose.yml build

up: build
	docker-compose -f ./docker-compose.yml up -d

# Stop and remove containers, networks, and volumes
down:
	docker-compose -f ./docker-compose.yml down

# Stop only the containers
stop:
	docker-compose -f ./docker-compose.yml stop

# Start existing containers
start:
	docker-compose -f ./docker-compose.yml start
	
fclean: down
	@echo "Removing volume data..."
	@sudo rm -rf /home/mal-mora/docker-volumes/mariadb/*
	@sudo rm -rf /home/mal-mora/docker-volumes/wordpress/*
	@sudo chown -R 999:999 /home/mal-mora/docker-volumes/mariadb
	@sudo chmod -R 750 /home/mal-mora/docker-volumes/mariadb
	@echo "Pruning docker system..."
	@docker system prune -af


# A more powerful rebuild
re: fclean
	@$(MAKE) all
