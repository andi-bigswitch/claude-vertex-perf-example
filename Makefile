.PHONY: build run clean

IMAGE_NAME := claude-perf-test
VERTEX_PROJECT_ID ?= avalabs-sec-app-env
SKIP_GCLOUD_AUTH_LOGIN ?=
SKIP_GCLOUD_CONFIG_SET_PROJECT ?=

build:
	docker build --build-arg VERTEX_PROJECT_ID=$(VERTEX_PROJECT_ID) -t $(IMAGE_NAME) .

run:
	docker run -it --cap-add=NET_RAW --cap-add=SYS_PTRACE \
		--env VERTEX_PROJECT_ID=$(VERTEX_PROJECT_ID) \
		$(if $(SKIP_GCLOUD_AUTH_LOGIN),--env SKIP_GCLOUD_AUTH_LOGIN=$(SKIP_GCLOUD_AUTH_LOGIN)) \
		$(if $(SKIP_GCLOUD_CONFIG_SET_PROJECT),--env SKIP_GCLOUD_CONFIG_SET_PROJECT=$(SKIP_GCLOUD_CONFIG_SET_PROJECT)) \
		$(IMAGE_NAME)

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
	@echo "  SKIP_GCLOUD_AUTH_LOGIN - Skip 'gcloud auth login' step (unset by default)"
	@echo "  SKIP_GCLOUD_CONFIG_SET_PROJECT - Skip 'gcloud config set project' step (unset by default)"
	@echo ""
	@echo "Usage examples:"
	@echo "  make build VERTEX_PROJECT_ID=your-project-id"
	@echo "  VERTEX_PROJECT_ID=your-project-id make build"
	@echo "  make run SKIP_GCLOUD_AUTH_LOGIN=1"
	@echo "  SKIP_GCLOUD_AUTH_LOGIN=1 SKIP_GCLOUD_CONFIG_SET_PROJECT=1 make run"
