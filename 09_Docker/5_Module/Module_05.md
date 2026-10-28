Module 5: Docker Compose

###	1) Introduction to Docker Compose
Docker Compose is a declarative orchestration tool used to define, configure, and run multi-container Docker     applications using a single YAML file. Instead of running multiple docker run commands,

			- Services
			- Networks
			- Volumes
			- Environment variables
			- Dependencies
			
			
			Problems before docker-compose	

				- Developers manually ran containers
				- Hard to track startup order
				- Networking was error-prone
				- Environment parity was poor	
				
			Docker Compose solves:
			
				- Service coordination
				- Consistent environments
				- Local production parity
				- Repeatable deployments	


		
###	2) docker-compose.yml structure
			'''
				version: "3.9"        # Compose file format version (optional in latest)
				services:             # All containers
				networks:             # Custom networks (optional)
				volumes:              # Persistent storage (optional)
				configs:              # Non-sensitive configs (Swarm)
				secrets:              # Sensitive data (Swarm)
			'''
			
###	3) Docker compose key components
			
			version, services, networks, volumes, ports, depends on, restart
			
			3.1 version
					Defines Compose file format
			3.2 services
					A service is a logical definition of a container in Docker Compose that specifies how a container is built,configured, networked, and run, and it can be scaled to multiple instances.
					
						- image			Pull image from registry
						- build			Build image from Dockerfile
						- ports			Host → Container mapping
						- environment	Runtime variables
						- depends_on	Startup order
						- restart		Fault tolerance
			3.3 networks 
					It define how services communicate with each other by providing an isolated virtual network where containers can discover and connect using service names
			3.5 depends on 
					It controls the startup order of services, ensuring that one service starts before another, but it does not wait for the dependency to be fully ready unless combined with a healthcheck.
			3.6 restart
					specifies the container restart policy, automatically restarting a service if it crashes, stops unexpectedly, or when Docker restarts.
			3.7 health-check
					healthcheck defines how Docker determines whether a service is healthy by periodically running a command and marking the container healthy or unhealthy based on its result.
			3.8 environment variables
					key-value pairs used to configure services at runtime without hard-coding values in the image, allowing flexible, secure, and environment-specific configuration.
