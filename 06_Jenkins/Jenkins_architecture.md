## Master–slave architecture

The Jenkins master–slave architecture more commonly called controller–agent architecture.
It is a distributed build system design used to improve scalability, performance, and flexibility.

Instead of running all jobs on a single machine, Jenkins splits responsibilities between:
   - Master (Controller)
   - Slaves (Agents)
   
   
	Architecture diagram
   
			+-------------------+
			|   Jenkins Master  |
			| (Controller)      |
			+--------+----------+
					|
		----------------------------
		|            |            |
	+---------+  +---------+  +---------+
	| Agent 1 |  | Agent 2 |  | Agent 3 |
	| Linux   |  | Windows |  | Docker  |
	+---------+  +---------+  +---------+
   
### 1. Jenkins Master (Controller) : The master node is the brain of the system.
Responsibilities:
	- Manages the Jenkins UI and web interface
	- Schedules and assigns jobs to agents
	- Maintains job configurations
	- Stores build history and logs
	- Monitors agent health
	Think of it as a manager that delegates work but doesn’t do heavy tasks itself.

### 2. Jenkins Slaves (Agents) : The slave/agent nodes are worker machines.
Responsibilities:
	- Execute build jobs assigned by the master
	- Run scripts, tests, deployments
	- Provide different environments (Linux, Windows, Docker, etc.)

   These can be:
	- Physical machines
	- Virtual machines
	- Containers (e.g., Docker agents)

### 3. Communication Between Master & Agents
Agents connect to the master using:
	- SSH
	- JNLP (Java Web Start / inbound agent)
	- WebSocket (modern setups)
	
### 4. Why Use Master–Slave Architecture?
	Scalability : Add more agents to handle more jobs
	Load distribution : Heavy builds don’t overload master
	Platform diversity : Run jobs on different OS environments
	Isolation : Safer and cleaner execution

### 5. How It Works (Workflow)	
	Step 1: Developer commits code (e.g., via Git)
	Step 2: Jenkins master detects change or receives trigger
	Step 3: Master schedules a job
	Step 4: Master assigns job to an appropriate agent
	Step 5: Agent executes the job
	Step 6: Results are sent back to the master
	Step 7:	Master displays results in UI