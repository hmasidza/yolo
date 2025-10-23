# Yolo Backend API

A Node.js/Express backend API with MongoDB, containerized using Docker.

## Screenshots

### Client Images on DockerHub

![Alt text](hmi-yolo-client-image.png)

### Backend Images on DockerHub

![Alt text](hmi-yolo-backend-image.png)

### Added product (during test)

![Alt text](added-product.png)

---

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (version 20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 2.0+)

---

## Docker-Compose Quick Start

Clone the repository (if not already done)

Start - Stop the application

### Start all services

```bash
docker compose up
```

### Start in detached mode

```bash
docker compose up -d
```

### Stop all services

```bash
docker compose down
```

### Stop and remove volumes

```bash
docker compose down -v
```

### View running services

```bash
docker compose ps
```

## Manual commands to build and push images to DockerHub

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

---

## Ansible + Vagrant

Each VM runs a single service container: MongoDB, Backend and Frontend using Docker provisioned automatically with Ansible roles.
- Ansible common role installs Docker and required dependencies.
- DB role runs mongo container, exposing port 27017.
- Backend role runs hmasidza/hmi-yolo-backend container and connects to MongoDB using the DB VM’s private IP.
- Frontend role runs hmasidza/hmi-yolo-client container and communicates with the backend.
- Startup order is guaranteed by Ansible’s wait_for tasks:
- Backend waits until MongoDB is reachable.
- Frontend waits until backend is reachable.

### Overview

| VM Name        | Role / Service  | IP Address      | Host Port     | Description                                 |
|----------------|-----------------|-----------------|---------------|---------------------------------------------|
| `yolo-db`      | MongoDB         | 192.168.56.10   | 27017 → 27017 | Database container with persistent volume   |
| `yolo-backend` | API Backend     | 192.168.56.11   | 5000 → 5000   | Backend container linked to MongoDB         |
| `yolo-frontend`| React Frontend  | 192.168.56.12   | 3000 → 3000   | Client container connected to backend       |

Each role contains its own `tasks/main.yml` and `defaults/main.yml` for separation of concerns and reusability.

### Prerequisites

Before starting, install these on the host machine:

- **VirtualBox**
- **Vagrant**
- **Ansible**
- **Python 3 + pip**
- Internet access to pull Docker images

Check installations:

```bash
vagrant --version
ansible --version
```

### Start VMs

```bash
vagrant up
```

### Install required Ansible collection

```bash
ansible-galaxy install -r requirements.yml
```

### Run the playbook

```bash
ansible-playbook -i inventory.yml playbook.yml
```

The playbook executes in the following order:
- Common role: Installs Docker and Python Docker SDK on all VMs
- DB role: Runs MongoDB container with persistent storage
- Backend role: Deploys backend container and connects it to MongoDB
- Frontend role: Deploys frontend container and points it to backend API

### Access the Services

- Frontend: http://localhost:3000
- Backend: http://localhost:5000
- MongoDB: mongodb://localhost:27017

### Configuration

```yaml
mongo_image: "mongo:6.0"
backend_image: "hmasidza/hmi-yolo-backend:v1.0.1"
frontend_image: "hmasidza/hmi-yolo-client:v1.0.1"
mongo_port: "27017"
backend_port: "5000"
frontend_port: "3000"
tz: "Africa/Nairobi"
```

You can also adjust:
- Static VM IPs (must match Vagrantfile)
- Container environment variables
- Port mappings for host accessibility

### Useful Commands

| Command                                                         | Purpose                              |
| --------------------------------------------------------------- | ------------------------------------ |
| `vagrant up`                                                    | Start and provision all 3 VMs        |
| `vagrant halt`                                                  | Stop all VMs                         |
| `vagrant destroy -f`                                            | Remove all VMs                       |
| `vagrant ssh yolo-db`                                           | SSH into a specific VM               |
| `ansible-playbook -i inventory.yml playbook.yml`                | Apply provisioning manually          |
| `ansible-playbook -i inventory.yml playbook.yml --tags backend` | Run only a specific role (if tagged) |
| `docker ps` (inside VM)                                         | View running containers              |

### Re-Provisioning

To reapply changes after editing roles or vars:

```bash
ansible-playbook -i inventory.yml playbook.yml
```

or, from scratch:

```bash
vagrant destroy -f
vagrant up
```

### Troubleshooting

| Issue                    | Possible Fix                                               |
| ------------------------ | ---------------------------------------------------------- |
| VM creation fails        | Ensure VirtualBox + Vagrant are installed and updated      |
| SSH authentication error | Re-run `vagrant up` or check inventory paths               |
| Docker modules not found | Run `ansible-galaxy install -r requirements.yml`           |
| Containers not running   | SSH into VM → `sudo docker ps -a`                          |
| Port conflict            | Change host ports in `Vagrantfile` or `group_vars/all.yml` |