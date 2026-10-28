# Module 4: Jenkins Plugins


##  1. Plugin Architecture & Dependencies

* Jenkins works using plugins
* Plugins extend functionality
* Some plugins depend on others

**Example:**

* Git plugin depends on Git Client plugin

---

##  2. Essential Plugins

* **Git Plugin**			→ Connects to Git repositories
* **Pipeline Plugin**		→ Enables Jenkinsfile (CI/CD as code)
* **Credentials Plugin**	→ Securely stores secrets
* **Role Strategy Plugin**	→ Role-based access control

**Real Workflow Example:**
Developer → Git push → Jenkins Pipeline → Uses Credentials → Deploy

---

##  3. Install Plugins (Hands-on)

Steps:

1. Go to Manage Jenkins
2. Click Manage Plugins
3. Open Available Plugins
4. Install:

   * Git
   * Pipeline
   * Credentials
   * Role Strategy
5. Click Install without restart

---

##  4. Identify Dependencies

Steps:

1. Go to Manage Jenkins
2. Click Installed Plugins
3. Select any plugin

**Example:**
Pipeline plugin depends on workflow-related plugins

---

##  5. Plugin Upgrade (Safe Way)

Steps:

1. Go to Manage Jenkins
2. Click Manage Plugins → Updates
3. Select plugins
4. Install after restart

**Best Practices:**

* Test in staging environment
* Avoid auto-updates in production
* Check compatibility

---

##  6. Plugin Rollback

If plugin update breaks Jenkins:

Steps:

1. Navigate to:
   /var/lib/jenkins/plugins/
2. Replace plugin file (.hpi) with older version
3. Restart Jenkins

**Alternative:**

* Restore Jenkins backup

---

##  Real DevOps Scenario

* Plugin update breaks CI/CD pipeline
* Identify issue
* Rollback plugin
* Restore system quickly

---

##  Key Takeaways

* Plugins power Jenkins
* Always manage dependencies carefully
* Avoid risky updates in production
* Know rollback strategies

---

##  DevOps Job Tip

Mastering plugin management helps you:

* Prevent production failures
* Handle outages quickly
* Stand out in DevOps interviews

---
