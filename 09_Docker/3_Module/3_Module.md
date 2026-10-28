###	1)		Docker Engine

Docker Engine is the core runtime that builds, runs, and manages containers by interacting with the host OS kernel and system resources.
		
				Docker CLI  →  Docker REST API  →  Docker Daemon (dockerd)
														|
														├── containerd
														├── runc
														├── Storage Drivers
														├── Volume Drivers
															
	Workflow: Docker Engine receives container requests via the Docker CLI using the REST API, pulls required images from  a  registry, manages container lifecycle     through containerd, executes containers using runc, and enforces isolation and resource limits using Linux namespaces and cgroups.
		
		Component			Responsibility
		=========			===================================================
		Docker CLI			Tool where you type Docker commands like docker run
		Docker Daemon		Main service that listens to commands and manages Docker
		containerd			Starts, stops, and manages containers
		runc				Actually creates containers using Linux features
		Storage Driver		Manages container and image files
		Volume Driver		Stores data safely outside containers
		
### 2		)Docker Storage

Docker storage defines how container data is stored, shared, and persisted beyond the container's lifecycle. Since containers are ephemeral by nature, Docker provides mechanisms to manage application data and stateful data efficiently.

	1. Layered Filesystem
		Docker uses a layered filesystem
		Image layers	: Immutable and read-only and shared across the container for effective disk space
		Container layer	: Thin writable layer created on top of image layers. Stores runtime changes like.
						- Logs
						- Temporary files
						- Runtime configurations
						
		Note : This writable layer is lost when the container is removed, which is why persistent data should be managed using  volumes or bind mounts in                   production.
	
	2. 	Storage Drivers
		Storage drivers manage the image layers and the container writable layer.
		
			Common storage drivers include:
				- overlay2 (most common for Linux)
				- aufs (older Linux systems)
				- btrfs, zfs (advanced use cases)
				- windowsfilter (for Windows containers)
		
		They implement copy-on-write (CoW) to efficiently manage changes without duplicating the entire image.
	
	3. 	Volumes and Persistent Storage
		Since container layers are ephemeral, Docker provides volumes for persistent storage:
		Volumes			: Managed by Docker, can be shared across containers.
		Bind mounts		: Map host directories into containers, useful for development.
		tmpfs mounts	: Store data in RAM, data disappears when container stops.
	
	4.	Named Volumes
		Volumes can be named or anonymous. 
		Named volumes make it easier to reuse data across containers.

			Create a named volume			:	docker volume create mydata
			Use named volume in container	:   docker run -v mydata:/app/data myimage

		Default storage location on Linux: /var/lib/docker/volumes/

		Advantages:
			- Managed by Docker
			- Persistent even if container is removed
			- Can be shared across multiple containers
			- Independent of container lifecycle

	5. 	Inspecting Volumes
		List all volumes			:	docker volume ls
		Inspect a specific volume	:	docker volume inspect mydata
		Remove a volume	:	docker volume rm mydata
		

	