.PHONY: build run clean

IMAGE_NAME := claude-perf-test
VERTEX_PROJECT_ID ?= avalabs-sec-app-env

build:
	docker build --build-arg VERTEX_PROJECT_ID=$(VERTEX_PROJECT_ID) -t $(IMAGE_NAME) .

run:
	docker run -it --cap-add=NET_RAW --cap-add=SYS_PTRACE $(IMAGE_NAME)

clean:
	docker rmi $(IMAGE_NAME) 2>/dev/null || true

help:
	@echo "Available targets:"
	@echo "  build  - Build the Docker image"
	@echo "  run    - Run the container with debugging capabilities"
	@echo "  clean  - Remove the Docker image"
	@echo "  help   - Show this help message"
	@echo ""
	@echo "Customization:"
	@echo "  VERTEX_PROJECT_ID - Google Cloud project ID (default: $(VERTEX_PROJECT_ID))"
	@echo "  Usage: make build VERTEX_PROJECT_ID=your-project-id"
	@echo "     or: VERTEX_PROJECT_ID=your-project-id make build"