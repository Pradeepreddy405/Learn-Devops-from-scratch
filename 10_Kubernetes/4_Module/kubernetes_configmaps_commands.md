# Kubernetes ConfigMaps – Zero to Hero

This is a complete **Kubernetes ConfigMap commands guide** from beginner to advanced, structured as a hands-on README for learning and reference.

---

## 1️⃣ Create ConfigMaps

### a) From literal values (key=value)
```bash
kubectl create configmap my-config --from-literal=APP_NAME=demo-app --from-literal=APP_ENV=dev
```

### b) From a file
```bash
kubectl create configmap my-config --from-file=config.properties
```
*Example `config.properties` content:*
```
APP_NAME=demo-app
APP_ENV=dev
```

### c) From multiple files or directory
```bash
kubectl create configmap my-config --from-file=./config-dir/
```

### d) From YAML file
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
  namespace: default
data:
  APP_NAME: demo-app
  APP_ENV: dev
```
```bash
kubectl apply -f configmap.yaml
```

---

## 2️⃣ View ConfigMaps

**List all ConfigMaps:**
```bash
kubectl get configmaps
```

**Describe a ConfigMap:**
```bash
kubectl describe configmap my-config
```

**Output in YAML/JSON:**
```bash
kubectl get configmap my-config -o yaml
kubectl get configmap my-config -o json
```

---

## 3️⃣ Use ConfigMaps in Pods

### a) As Environment Variables
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-pod
spec:
  containers:
  - name: demo-container
    image: nginx
    envFrom:
    - configMapRef:
        name: my-config
```

### b) As Command-line Arguments
```yaml
command: ["/bin/sh", "-c"]
args: ["echo APP_NAME=$APP_NAME && echo APP_ENV=$APP_ENV"]
envFrom:
- configMapRef:
    name: my-config
```

### c) Mounted as Files in Volume
```yaml
volumes:
- name: config-volume
  configMap:
    name: my-config
containers:
- name: demo-container
  image: nginx
  volumeMounts:
  - name: config-volume
    mountPath: /etc/config
```

---

## 4️⃣ Update ConfigMaps

**Edit ConfigMap:**
```bash
kubectl edit configmap my-config
```

**Apply new YAML:**
```bash
kubectl apply -f configmap.yaml
```

**Replace ConfigMap:**
```bash
kubectl replace -f configmap.yaml
```

**Immutable ConfigMap:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
immutable: true
data:
  APP_NAME: demo-app
```

---

## 5️⃣ Delete ConfigMaps
```bash
kubectl delete configmap my-config
```

---

## 6️⃣ Advanced / Helpful Commands

**Create YAML from existing ConfigMap:**
```bash
kubectl get configmap my-config -o yaml --export > my-config.yaml
```

**Check ConfigMap usage in Pods:**
```bash
kubectl describe pod <pod-name>
kubectl exec -it <pod-name> -- env | grep APP_NAME
```

**Apply ConfigMap to Deployment:**
```yaml
envFrom:
- configMapRef:
    name: my-config
```
- Updates ConfigMap + triggers rollout if configured with `kubectl rollout restart deployment <deployment-name>`

---

## ✅ Summary of Key Commands

| Action | Command |
|--------|---------|
| Create literal | `kubectl create configmap NAME --from-literal=KEY=VALUE` |
| Create from file | `kubectl create configmap NAME --from-file=FILE` |
| Create from directory | `kubectl create configmap NAME --from-file=DIR/` |
| Create from YAML | `kubectl apply -f configmap.yaml` |
| List | `kubectl get configmaps` |
| Describe | `kubectl describe configmap NAME` |
| Edit | `kubectl edit configmap NAME` |
| Update | `kubectl apply -f configmap.yaml` |
| Delete | `kubectl delete configmap NAME` |
| Use as env | `envFrom: configMapRef: name: NAME` |
| Use as volume | `volume: configMap: name: NAME` |
| Immutable | `immutable: true` |

---

*This README is ready to use as a learning and reference guide for Kubernetes ConfigMaps.*

