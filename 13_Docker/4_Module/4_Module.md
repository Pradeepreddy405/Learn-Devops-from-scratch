# Module 4: Docker Networking

Networking in Docker is the mechanism that enables containers to communicate with each other, the host system, and external networks. Since containers are **isolated by default**, networking plays a critical role in connecting microservices and ensuring smooth data flow across services.

---

## Why Containers Need to Communicate

Modern applications are rarely monolithic. They are typically composed of multiple services, each running in its own container. Effective communication between these containers is essential for application functionality, scaling, and reliability.

Key reasons containers need to communicate:

| Concept | Description |
|---------|-------------|
| **Isolation** | Each container runs in its own network namespace by default. |
| **Communication** | Microservices need to exchange data internally and externally. |
| **Port Mapping** | Expose container services to the host or external clients. |
| **Security** | Control traffic between containers, hosts, and external networks. |
| **Scalability** | Allows dynamic scaling of services while maintaining consistent connectivity. |

---

## Types of Docker Networks

Docker provides several built-in network drivers to facilitate container connectivity:

### 1. Bridge Network (Default)

- Default network for standalone containers.
- Containers on the same bridge network can communicate using **container names**.
- External access is achieved via **port mapping**: `-p hostPort:containerPort`.

**Example:**

```bash
docker network ls                 # List all networks
docker run -d --name web --network bridge nginx
docker run -d --name db --network bridge mysql
```

> Containers `web` and `db` can communicate using `db` as hostname if they are on the same bridge network.  
> For external access, use `docker run -p 8080:80 ...`.

---

### 2. Host Network

- Container shares the host machine’s network stack.
- Eliminates NAT → higher network performance.
- Useful for applications requiring **low latency or high throughput**.

**Example:**

```bash
docker run --network host nginx
```

> Container’s port 80 is exposed directly as host port 80.  
> ⚠️ **Caution:** Reduced isolation can be a security risk.

---

### 3. None Network

- Container has **no network connectivity**.
- Ideal for isolated or single-purpose containers.

**Example:**

```bash
docker run --network none busybox
```

---

### 4. Overlay Network

- Designed for **multi-host networking** in Docker Swarm or Kubernetes.
- Connects containers across multiple hosts.
- Supports **service discovery** and scalable microservices architectures.

**Example:**

```bash
docker network create -d overlay my-overlay
docker service create --name web --network my-overlay nginx
```

> Containers on different hosts can communicate using **service/container names** seamlessly.

---

## Hands-On Exercises

1. **Run Multiple Containers and Enable Communication**

```bash
docker network create my-bridge
docker run -d --name web --network my-bridge nginx
docker run -d --name db --network my-bridge mysql
```

Test communication:

```bash
docker exec -it web ping db
```

2. **Expose vs Publish Ports**

- **Expose**: Makes port available to linked containers (internal use).
- **Publish (`-p`)**: Maps container port to host port for external access.

```bash
docker run -d --name web -p 8080:80 nginx
```

3. **Link Containers Using Docker Network**

```bash
docker network create app-network
docker run -d --name app1 --network app-network myapp
docker run -d --name app2 --network app-network myapp
```

> Containers can communicate using **container names** within `app-network`.

---

This module equips you with foundational knowledge of Docker networking and hands-on skills to connect containers in **single-host and multi-host environments**, which is crucial for building scalable microservices architectures.

