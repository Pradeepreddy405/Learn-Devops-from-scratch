# Module 2: Jenkins Installation & Configuration



# 🔹 1. Installation Methods (3 Ways)

##  Linux Package Installation (Most Important)

This is the **standard method used in companies**.

### Steps:

```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

### Check status:

```bash
sudo systemctl status jenkins
```

 Access Jenkins:

```
http://<your-server-ip>:8080
```

---

##  Docker Installation (High Demand Skill)

Run Jenkins in a container.

### Steps:

```bash
docker run -d \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
```

 Why important:

* Used in cloud (AWS, Kubernetes)
* Easy to move and scale

---

##  WAR File Installation (Manual Method)

### Steps:

```bash
java -jar jenkins.war
```

 Used for:

* Testing
* Custom setups

---

# 🔹 2. WAR vs Package Install (Simple Understanding)

| Point      | WAR          | Package         |
| ---------- | ------------ | --------------- |
| Difficulty | Hard         | Easy            |
| Usage      | Testing      | Real projects   |
| Control    | Full control | Limited control |
| Upgrade    | Manual       | Easy            |

👉 Remember:
**Companies prefer Package or Docker**

---

#  3. Ports & Environment Variables

## Default Ports:

* `8080` → Jenkins UI (browser access)
* `50000` → Communication with agents

---

## Change Port (Linux)

### Step 1: Open config file

```bash
sudo nano /etc/default/jenkins
```

### Step 2: Change port

```
HTTP_PORT=9090
```

### Step 3: Restart Jenkins

```bash
sudo systemctl restart jenkins
```

 Now access:

```
http://<ip>:9090
```

---

#  4. Jenkins Directory Structure

Main folder:

```
/var/lib/jenkins/
```

### Important inside it:

* `jobs/` → all pipelines/jobs
* `plugins/` → installed plugins
* `workspace/` → build files
* `config.xml` → main settings

 This folder is called:
**JENKINS_HOME (VERY IMPORTANT)**

---

#  5. Backup & Restore (Critical for Jobs)

## Backup Steps:

```bash
sudo systemctl stop jenkins
cp -r /var/lib/jenkins /backup/
```

## Restore Steps:

```bash
cp -r /backup/jenkins /var/lib/
sudo systemctl start jenkins
```

 Why important:

* Saves jobs, pipelines, credentials
* Used in real production failures

---

#  6. Upgrade Jenkins Safely

## Steps:

1. Take backup
2. Check plugin compatibility
3. Upgrade Jenkins

```bash
sudo apt update
sudo apt install jenkins -y
```

4. Restart:

```bash
sudo systemctl restart jenkins
```

---

##  Downgrade (If Something Breaks)

Steps:

* Stop Jenkins
* Restore old backup
* Install older version

👉 Used when upgrade fails

---

#  Hands-on Practice (Must Do)

✔ Install Jenkins on Linux
✔ Run Jenkins using Docker
✔ Access UI in browser
✔ Change port from 8080 → 9090
✔ Take backup of Jenkins
✔ Restore backup
✔ Upgrade Jenkins safely

---

#  Real Job Skills You Gain

* Install Jenkins in multiple ways
* Manage services using Linux
* Work with Docker containers
* Handle failures using backup
* Perform upgrades without breaking system

---

#  Simple Interview Answer

**Q: How do you install Jenkins?**

**Answer:**
I install Jenkins using Linux package or Docker, configure ports, manage JENKINS_HOME for backups, and perform safe upgrades with proper checks.

---

