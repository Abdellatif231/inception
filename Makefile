NAME            = inception
COMPOSE_FILE    = ./srcs/docker-compose.yml
ENV_FILE        = ./srcs/.env

all: up

up:
	@echo "Building and starting containers..."
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build
	@echo "Containers are up and running!"

down:
	@echo "Stopping containers..."
	docker compose -f $(COMPOSE_FILE) down
	@echo "Containers stopped."

fclean:
	@echo "Removing containers, images, and volumes..."
	docker compose -f $(COMPOSE_FILE) down -v --rmi all
	docker system prune -af --volumes
	@echo "Everything cleaned!"

re: fclean all

ps:
	docker compose -f $(COMPOSE_FILE) ps

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

bash:
	@if [ -z "$(service)" ]; then \
		echo "Usage: make bash service=<container_name>"; \
	else \
		docker exec -it $(service) bash; \
	fi

check:
	@echo "Volumes:"
	docker volume ls
	@echo "Networks:"
	docker network ls

.PHONY: all up down fclean re ps logs bash check
