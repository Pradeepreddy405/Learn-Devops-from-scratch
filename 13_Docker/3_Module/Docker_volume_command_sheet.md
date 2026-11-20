# Docker Volumes – Persistent Storage - command sheet


## Why Do We Need Volumes?
Containers are **ephemeral** by nature.
- Container data is stored in a **writable layer** on top of image layers
- When a container is **removed**, its writable layer is **lost**

To persist data beyond the container lifecycle, Docker provides **Volumes** and **Bind Mounts**.

---

## Volume Commands Overview
	
	docker volume create vol
	docker volume ls
	docker volume inspect vol
	docker volume rm vol
	docker volume prune
	docker run -v vol:/path image
	docker run -v /host:/path image


## 1. Create a Volume

docker volume create myvol

	- What happens?
	- Docker creates a managed storage location on the host
	
		Default path:
			> /var/lib/docker/volumes/myvol/_data
			> Volume exists independently of containers
		


## 2. List Volumes

docker volume ls

	Example output:
			DRIVER    VOLUME NAME
			======    ===========
			local     myvol
			local     db_data
	

## 3. Inspect a Volume

docker volume inspect myvol

	Example output:
		[
			{
				"Name": "myvol",
				"Driver": "local",
				"Mountpoint": "/var/lib/docker/volumes/myvol/_data",
				"Scope": "local"
			}
		]
		---------------------------------------------------------------
			Key Fields
			**Mountpoint** 	→ Actual host directory
			**Driver** 		→ Volume driver (`local` by default)
		---------------------------------------------------------------


## 4. Use a Volume in a Container
	
	command: docker run -v myvol:/path image
	
   	Example: Persist Nginx Website Data :
    -----------------------------------------
							docker run -d \
  								--name web1 \
  								-v myvol:/usr/share/nginx/html \
  							nginx
    ----------------------------------------
	Write data inside container:
	
		command : docker exec web1 sh -c "echo Hello > /usr/share/nginx/html/index.html"
	---------------------------------------	

	Remove container: 
					docker rm -f web1
	
	Run a new container with same volume :
	---------------------------------------
					docker run -d \
	  					--name web2 \
	  					-v myvol:/usr/share/nginx/html \
	  				nginx
	------------------------------------
	Data persists across containers

---

## 5. Bind Mounts (Host Directory Mapping)

```bash
docker run -v /host/path:/container/path image
```

### Example

```bash
mkdir /tmp/appdata
```

```bash
docker run -it \
  -v /tmp/appdata:/data \
  alpine sh
```

Inside container:
```sh
echo "Hello from container" > /data/file.txt
exit
```

On host:
```bash
cat /tmp/appdata/file.txt
```

Direct host access
Host dependent
Less portable

---

## Volume vs Bind Mount

| Feature | Volume | Bind Mount |
|------|------|------|
| Managed by Docker | Yes | No |
| Portable | Yes | No |
| Host dependent | No | Yes |
| Production ready | Yes | Limited |
| Kubernetes support | Yes | No |

**Best Practice:** Always prefer **Volumes** for production and Kubernetes workloads.

---

## 6. Remove a Volume

```bash
docker volume rm myvol
```

> Volume must not be used by any container.

---

## 7. Remove Unused Volumes
```
docker volume prune
```

- Removes **dangling (unused) volumes**
- Frees disk space
- Commonly used in CI/CD servers

---

## Real-World Use Cases

### Database Persistence
```
docker run -d \
  -v mysql_data:/var/lib/mysql \
  mysql:8
```

### Application Logs
```
docker run -d \
  -v app_logs:/var/log/app \
  myapp
```

### Shared Data Between Containers
```bash
docker run -d -v shared:/data app1
docker run -d -v shared:/data app2
```

---


## Summary
	- Containers are ephemeral
	- Volumes provide persistent storage
	- Volumes are **production-ready**	
	- Bind mounts are **host-dependent**



