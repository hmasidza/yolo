# Explanation

## Dockerfile directives and what they are doing

### FROM

Initializes a new build stage and sets the Base Image for subsequent instructions

### WORKDIR

Sets the working directory for all RUN, CMD, ENTRYPOINT, COPY, and ADD instructions in the current stage. It helps us remove the need to keep writing long absolute paths.

### COPY

Copies files from local directory into the image.

```COPY . .``` – copies the entire project into the image

```COPY package*.json ./``` – copies only dependency manifests which is good for cache

```COPY --from=build /usr/src/app /app``` – multi-stage: copies artifacts from the build stage

### RUN

Used to execute commands during the build process of a Docker image and these commands are used to install software, configure the environment, and perform other setup tasks required for the application to run.

### EXPOSE

Explicitly declares the ports that the application inside the container is designed to use for communication. This helps other developers or users understand how to interact with the containerized service.

For our case it is:
- Client: 3000
- Backend: 5000

### CMD

What to run when the container starts

```CMD ["node", "server.js"]``` instructs the Docker container to start a Node.js application by executing the ```server.js``` file with the Node.js runtime.

```CMD ["npm", "start"]``` tells Docker to run the ```npm start``` command when a container built from this Dockerfile starts

---

## How to achieve small images

```bash
FROM alpine:3.16.7
COPY --from=build /usr/src/app /app
```

Starts from a smaller Alpine base and copies only the output we need. Resulting in a smaller and a cleaner runtime image.

---

## Why the MongoDB URL needed to change in source code

When running the app locally, we used 
```bash 
mongodb://localhost:27017/yolo
```

However, once we start using Docker Compose, each service runs in its own container with its own isolated network namespace.
From the backend container’s perspective, ```localhost``` now points to itself, not to the MongoDB container.

That’s why the backend couldn’t connect when it still used ```mongodb://localhost:27017```
To fix that, we must use the service name defined in ```docker-compose.yml``` 
In our case ```mongodb``` because Docker Compose automatically sets up internal DNS records for all services in the same network.

Hence the change to
```bash
mongodb://mongodb:27017/yolo
```

---

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

## Ansible Overview

| Component           | Description                                                                                 |
|---------------------|---------------------------------------------------------------------------------------------|
| **Vagrant**         | Automates creation of 3 Ubuntu VMs: one for each microservice (MongoDB, Backend, Frontend). |
| **Ansible**         | Configures each VM using modular roles. Ensures idempotence and ordered provisioning.       |
| **Docker**          | Runs the actual application containers on each VM without docker-compose.                   |
| **Private Network** | Enables backend and frontend to communicate securely with MongoDB using static IPs.         |

### Flow

1. **Vagrant Up**
   - Spins up 3 VMs with fixed IPs (`192.168.56.10-12`) and forwards service ports (27017, 5000, 3000).
   - Provides SSH access for Ansible provisioning.

2. **Common Role**
   - Installs Docker, Python SDK, and dependencies on all VMs.
   - Starts and enables the Docker service.

3. **DB Role**
   - Runs a MongoDB container with a persistent volume.
   - Exposes port `27017` and waits until it becomes reachable.

4. **Backend Role**
   - Deploys the API container.
   - Injects environment variables pointing to MongoDB at `192.168.56.10`.
   - Publishes port `5000` and waits until API is healthy.

5. **Frontend Role**
   - Deploys the React UI container.
   - Configures environment variables for backend API at `192.168.56.11`.
   - Exposes port `3000` for host access.

6. **Access from Host**
   - Frontend - `http://localhost:3000`
   - Backend - `http://localhost:5000`
   - MongoDB - `mongodb://localhost:27017`

### Execution Order

1. `common` - Applies to all VMs.  
2. `db` - Must be ready before backend.  
3. `backend` - Depends on MongoDB(db).  
4. `frontend` - Depends on backend availability.

### Configuration Hierarchy

1. **`group_vars/all.yml`** - Global variables (ports, images, IPs, timezone).  
2. **`defaults/main.yml` in each role** – Role-specific defaults.

### Common Errors

This error shows up mostly when running ```vagrant up```

VirtualBox can't operate in VMX root mode.Please disable the KVM kernel extension, recompile your kernel and reboot.
(VERR_VMX_IN_VMX_ROOT_MODE).

If you are using an Intel CPU

```bash
sudo modprobe -r kvm_intel
```

If you are using an AMD CPU

```bash
sudo modprobe -r kvm_amd
```