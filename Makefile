COMPOSE_FILE ?= docker-compose.ssh-dev.yml
SERVICE ?= franky-ssh-dev
BUILD_TYPE ?= Debug

.PHONY: dev-up dev-down dev-restart dev-shell dev-build dev-test dev-debug dev-logs

dev-up:
	docker compose -f $(COMPOSE_FILE) up -d --build $(SERVICE)

dev-down:
	docker compose -f $(COMPOSE_FILE) down

dev-restart: dev-down dev-up

dev-shell:
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) bash

dev-build:
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) bash -lc '\
	cmake -S . -B build -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -DBUILD_TESTS=ON && \
	cmake --build build -j"$$(nproc)"'

dev-test:
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) bash -lc '\
	ctest --test-dir build --output-on-failure'

dev-debug:
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) gdb --args build/linear

dev-logs:
	docker compose -f $(COMPOSE_FILE) logs -f $(SERVICE)
