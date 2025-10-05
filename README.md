# Yolo Backend API

A Node.js/Express backend API with MongoDB, containerized using Docker.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (version 20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 2.0+)

## Quick Start

### Clone the repository (if not already done)

### Start - Stop the application

#### Start all services

```bash
docker compose up
```

#### Start in detached mode

```bash
docker compose up -d
```

#### Stop all services

```bash
docker compose down
```

#### Stop and remove volumes

```bash
docker compose down -v
```

#### View running services

```bash
docker compose ps
```

### Screenshots

#### Client Images on DockerHub
![Alt text](hmi-yolo-client-image.png)

#### Backend Images on DockerHub
![Alt text](hmi-yolo-backend-image.png)

#### Added product (during test)
![Alt text](added-product.png)

### Manual commands to build and push images to DockerHub
To test functionality locally first

```bash
docker build -t hmasidza/hmi-yolo-client:v1.0.0 ./client
```

```bash
docker push hmasidza/hmi-yolo-client:v1.0.0
```

```bash
docker build -t hmasidza/hmi-yolo-backend:v1.0.0 ./backend
```

```bash
docker push hmasidza/hmi-yolo-backend:v1.0.0
```