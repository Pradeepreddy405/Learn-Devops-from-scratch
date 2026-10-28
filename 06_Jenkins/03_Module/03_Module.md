# Module 3: Jenkins Jobs & Freestyle Projects (Step-by-Step Guide)



#  First Understand the Flow (Very Important)

 In real DevOps work, this is what happens:

1. Developer pushes code to Git
2. Jenkins detects the change
3. Jenkins pulls the code
4. Jenkins runs build commands
5. Jenkins generates output (artifact)
6. Jenkins stores logs and results

 Your job is to **configure Jenkins to do this automatically**

---

#  1. Create a Freestyle Job (Start Here)

### Steps:

1. Open Jenkins in browser

   ```
   http://localhost:8080
   ```

2. Click **New Item**

3. Enter name:

   ```
   my-first-job
   ```

4. Select:
    Freestyle Project

5. Click **OK**

 Now job configuration page opens

---

#  2. Connect Jenkins to Git (Code Source)

 Jenkins needs code to build

### Steps:

1. Scroll to **Source Code Management**

2. Select **Git**

3. Enter repository URL:

   ```
   https://github.com/user/repo.git
   ```

4. If private repo → add credentials

 Now Jenkins knows:
**“Where to get code from”**

---

#  3. Add Build Trigger (When should job run?)

 Decide how job starts

---

## Option 1: Manual (Beginner)

* Click **Build Now**

---

## Option 2: SCM Polling

 Jenkins checks Git regularly

Example:

```
H/5 * * * *
```

 Means: check every 5 minutes

---

## Option 3: Webhook (Real-world method)

 Git notifies Jenkins instantly

Flow:
Git → Webhook → Jenkins → Build starts

 Used in high-paying jobs

---

#  4. Add Build Step (What should Jenkins do?)

 This is the **main work**

### Steps:

1. Scroll to **Build**

2. Click **Add build step**

3. Select:
    Execute shell

4. Add command:

```bash
echo "Building project..."
```

 Example (Java project):

```bash
mvn clean install
```

 Now Jenkins knows:
**“What to do with the code”**

---

#  5. Add Parameters (Make Job Flexible)

 Sometimes you want input before build

### Steps:

1. Tick:
    This project is parameterized

2. Add parameter:

   * String Parameter

Example:

```
Name: ENV
Value: dev
```

 Now you can run job like:

* dev
* test
* prod

 Used in real projects

---

#  6. Add Post-Build Action (After Build Work)

👉 What happens after build?

### Steps:

1. Scroll to **Post-build Actions**

2. Click:
    Archive the artifacts

3. Add:

```
*.jar
```

 Jenkins will save output files

---

#  7. Save and Run Job

1. Click **Save**
2. Click **Build Now**

---

#  8. Check Output (Logs)

👉 Click build number → Console Output

You will see:

```
Building project...
```

👉 If error → debug using logs

---

#  9. Artifacts (Build Output)

👉 After build:

* Go to build → Artifacts section
* Download files

---

#  10. Build Retention (Cleanup Old Builds)

 Too many builds = storage problem

### Steps:

1. Open job → Configure

2. Tick:
    Discard old builds

3. Set:

```
Keep last 10 builds
```

---

#  Full Flow Summary (Important for Interviews)

 You should explain like this:

1. Create Freestyle job
2. Connect Git repo
3. Configure trigger (manual/webhook)
4. Add build step (shell command)
5. Add parameters if needed
6. Archive artifacts
7. Run build and check logs

---

#  Hands-on Tasks (Do This Exactly)

✅ Create Freestyle job
✅ Connect Git repo
✅ Add build step (`echo Hello`)
✅ Run build manually
✅ Add parameter (ENV=dev)
✅ Archive artifact (`*.txt`)
✅ Check logs

---

#  Real Job Skills You Gain

* Understand full CI/CD flow
* Configure Jenkins jobs from scratch
* Debug using logs
* Work with Git integration
* Handle real build outputs

---

#  Simple Interview Answer

**Q: How does a Jenkins Freestyle job work?**

**Answer:**
A Freestyle job pulls code from Git, runs build commands, and produces artifacts. It can be triggered manually, by polling, or using webhooks, and logs help debug failures.

---

Caution : If you practice this step-by-step once, you will understand **how real pipelines work**.
