# Variables
NAME            = inception
COMPOSE_FILE    = ./srcs/docker-compose.yml
ENV_FILE        = ./srcs/.env

# Colors for fun
GREEN           = \033[0;32m
YELLOW          = \033[1;33m
RED             = \033[0;31m
RESET           = \033[0m

# Default target
all: up

# Build and start the containers
up:
	@echo "$(YELLOW)🔧 Building and starting containers...$(RESET)"
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build
	@echo "$(GREEN)🚀 Containers are up and running!$(RESET)"

# Stop containers but keep data
down:
	@echo "$(YELLOW)🛑 Stopping containers...$(RESET)"
	docker compose -f $(COMPOSE_FILE) down
	@echo "$(RED)Containers stopped.$(RESET)"

# Stop and remove everything including volumes
fclean:
	@echo "$(RED)🔥 Removing containers, images, and volumes...$(RESET)"
	docker compose -f $(COMPOSE_FILE) down -v --rmi all
	docker system prune -af --volumes
	@echo "$(GREEN)✨ Everything cleaned!$(RESET)"

# Restart containers
re: fclean all

# Show container status
ps:
	docker compose -f $(COMPOSE_FILE) ps

# Show logs
logs:
	docker compose -f $(COMPOSE_FILE) logs -f

# Run bash inside a specific service (ex: make bash service=mariadb)
bash:
	@if [ -z "$(service)" ]; then \
		echo "$(RED)Usage: make bash service=<container_name>$(RESET)"; \
	else \
		docker exec -it $(service) bash; \
	fi

# Check volumes and network existence (for debugging)
check:
	@echo "$(YELLOW)📦 Volumes:$(RESET)"
	docker volume ls
	@echo "$(YELLOW)🌐 Networks:$(RESET)"
	docker network ls

.PHONY: all up down fclean re ps logs bash check
