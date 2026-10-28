### Docker Engine & System
	docker version
	docker info
	docker system df
	docker system prune
	docker system prune -a --volumes
	
### Images
	docker images
	docker pull image:tag
	docker build -t image .
	docker build --no-cache -t image .
	docker rmi image
	docker image prune
	docker image prune -a
	docker inspect image
	docker history image
	
### Containers
	docker run image
	docker run -d image
	docker run -it image bash
	docker run --name name image
	docker run -p host:container image
	docker run -e KEY=VAL image
	docker ps
	docker ps -a
	docker start container
	docker stop container
	docker restart container
	docker rm container
	docker rm -f container
	docker exec -it container bash
	docker logs container
	docker logs -f container
	docker inspect container
	docker stats
	docker top container
	
### Volumes (Persistent Storage)
	docker volume create vol
	docker volume ls
	docker volume inspect vol
	docker volume rm vol
	docker volume prune
	docker run -v vol:/path image
	docker run -v /host:/path image
	
### Networks
	docker network ls
	docker network create net
	docker network inspect net
	docker network rm net
	docker network prune
	docker run --network net image
	
### Docker Compose
	docker-compose up
	docker-compose up -d
	docker-compose down
	docker-compose ps
	docker-compose logs
	docker-compose build
	docker-compose restart
	
### Registry & Images Transfer
	docker login
	docker logout
	docker tag image repo/image:tag
	docker push repo/image:tag
	docker save -o image.tar image
	docker load -i image.tar
	docker export container > file.tar
	docker import file.tar image
	
### File Operations
	docker cp file container:/path
	docker cp container:/path file
	
### Monitoring & Debug
	docker stats
	docker events
	docker diff container
	docker attach container
	docker pause container
	docker unpause container
	docker wait container
	docker rename old new
	docker update --cpus 1 --memory 512m container
	
### Cleanup (Ops Must-Know)
	docker rm $(docker ps -aq)
	docker rmi $(docker images -q)
	docker volume prune
	docker network prune
	docker system prune -a