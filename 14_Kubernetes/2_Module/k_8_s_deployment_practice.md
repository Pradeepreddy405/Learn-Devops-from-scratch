# Kubernetes Deployment Exercises

This guide covers **creating, editing, scaling, and deleting Kubernetes Deployments** using YAML and `kubectl`.

---

## 1. Create a Deployment

Create a file called `deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp-container
        image: nginx:latest
        ports:
        - containerPort: 80
```

Apply the deployment  :

```bash
        kubectl apply -f deployment.yaml               -----> updates the resources in the YAML file, making the cluster match the desired state.

        kubectl get deployments                        -----> lists all deployments in the current namespace, showing their name, number of replicas, ready replicas, and age.

        kubectl get pods                               -----> lists all pods in the current namespace, showing their name, ready status, current status (Running, Pending, etc.), restarts, and age.
```

This creates **3 pods** running the `nginx` container.

---

## 2. Edit a Deployment

### 2.1. Edit YAML and re-apply

Change replicas to 5 in `deployment.yaml`:

```yaml
spec:
  replicas: 5
```

Apply changes:

```bash
kubectl apply -f deployment.yaml
```

### 2.2. Edit live using kubectl

```bash
kubectl edit deployment myapp-deployment
```

Update replicas or container image:

```yaml
spec:
  replicas: 2
  template:
    spec:
      containers:
      - name: myapp-container
        image: nginx:1.21
```

Kubernetes performs a **rolling update automatically**.

---

## 3. Delete a Deployment

Delete by name:

```bash
kubectl delete deployment myapp-deployment
```

Or delete using YAML:

```bash
kubectl delete -f deployment.yaml
```

This removes the deployment and all its pods.

---

## 4. Bonus Commands

```bash
# Check deployment details
kubectl describe deployment myapp-deployment

# Scale deployment without editing YAML
kubectl scale deployment myapp-deployment --replicas=4

# Rollback deployment to previous version
kubectl rollout undo deployment/myapp-deployment

# Check rollout status
kubectl rollout status deployment/myapp-deployment
```

