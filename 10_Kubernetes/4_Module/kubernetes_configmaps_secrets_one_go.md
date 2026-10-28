# Kubernetes ConfigMaps, Secrets, and Config Files in Pods

This guide covers **ConfigMaps, Secrets, and how to use them as configuration files inside Pods**. It is designed for zero-to-hero learning and hands-on practice.

---

## 1️⃣ ConfigMaps

### **Concept:**
- Store non-sensitive configuration data as key-value pairs.
- Decouple config from container images.

### **Create ConfigMap:**
**From literal values:**
```bash
kubectl create configmap my-config --from-literal=APP_NAME=demo-app --from-literal=APP_ENV=dev
```

**From file:**
```bash
kubectl create configmap my-config --from-file=app.properties
```

**From directory:**
```bash
kubectl create configmap my-config --from-file=./config-dir/
```

**From YAML:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  APP_NAME: demo-app
  APP_ENV: dev
```
```bash
kubectl apply -f configmap.yaml
```

### **View ConfigMaps:**
```bash
kubectl get configmaps
kubectl describe configmap my-config
kubectl get configmap my-config -o yaml
```

### **Use ConfigMap in Pods:**
**As environment variables:**
```yaml
envFrom:
- configMapRef:
    name: my-config
```

**As volume files:**
```yaml
volumes:
- name: config-volume
  configMap:
    name: my-config
```
---

## 2️⃣ Secrets

### **Concept:**
- Store sensitive data like passwords, API keys, and tokens.
- Base64 encoded in Kubernetes.
- Safer than storing secrets in ConfigMaps.

### **Create Secrets:**
**From literal values:**
```bash
kubectl create secret generic my-secret --from-literal=DB_PASSWORD=Pa$$w0rd
```

**From file:**
```bash
kubectl create secret generic my-secret --from-file=ssh-key=/path/to/key
```

**From YAML:**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
stringData:
  DB_PASSWORD: Pa$$w0rd
```
```bash
kubectl apply -f secret.yaml
```

### **View Secrets:**
```bash
kubectl get secrets
kubectl describe secret my-secret
kubectl get secret my-secret -o yaml
```
> Note: Avoid using `kubectl get secret -o yaml` in production, as it shows base64 encoded values.

### **Use Secret in Pods:**
**As environment variables:**
```yaml
env:
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: my-secret
      key: DB_PASSWORD
```

**As volume files:**
```yaml
volumes:
- name: secret-volume
  secret:
    secretName: my-secret
```
---

## 3️⃣ Config Files in Pods (ConfigMaps or Secrets)

### **Mount ConfigMap as file:**
```yaml
volumes:
- name: config-volume
  configMap:
    name: app-config
containers:
- name: app-container
  image: busybox
  command: ["sh", "-c", "cat /etc/config/app.properties && sleep 3600"]
  volumeMounts:
  - name: config-volume
    mountPath: /etc/config
```

**Verify in Pod:**
```bash
kubectl exec -it <pod-name> -- ls /etc/config
kubectl exec -it <pod-name> -- cat /etc/config/app.properties
```

### **Mount Secret as file:**
```yaml
volumes:
- name: secret-volume
  secret:
    secretName: my-secret
containers:
- name: app-container
  image: busybox
  volumeMounts:
  - name: secret-volume
    mountPath: /etc/secret
```

**Verify in Pod:**
```bash
kubectl exec -it <pod-name> -- ls /etc/secret
kubectl exec -it <pod-name> -- cat /etc/secret/DB_PASSWORD
```

### **Tips:**
- Use `immutable: true` for production ConfigMaps/Secrets to prevent accidental changes.
- For dynamic updates of ConfigMap files, you need to restart Pods or use sidecars that reload configs.
- Always use Secrets for sensitive data instead of ConfigMaps.

---

This README combines **ConfigMaps, Secrets, and Config files in Pods** as a full reference for learning and hands-on practice.

