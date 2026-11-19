# Kubernetes Module 4 — Configuration Management

## Overview
This module focuses on managing application configuration in Kubernetes without rebuilding container images. It covers ConfigMaps, Secrets, environment variables, and managing configuration files inside Pods.

---

## 1. Why Configuration Management is Needed

- Containers should be immutable.
- Configuration may vary between environments (dev, test, prod).
- Directly modifying images for config is bad practice.

**Benefits:**
- Decouples configuration from container images.
- Makes deployments portable and environment-agnostic.
- Enables secrets management securely.
- Simplifies configuration updates without restarting Pods.

---

## 2. ConfigMaps

**Definition:**
- Stores non-sensitive configuration data in key-value pairs.
- Can be used as environment variables, command-line args, or mounted files.

**Creating a ConfigMap:**
```bash
kubectl create configmap app-config --from-literal=APP_MODE=production --from-literal=LOG_LEVEL=info
kubectl create configmap app-config --from-file=app.properties
kubectl create configmap app-config --from-file=./config-dir/
```

**Viewing ConfigMaps:**
```bash
kubectl get configmaps
kubectl describe configmap app-config
```

**Using ConfigMap in a Pod:**
- As environment variables:
```yaml
envFrom:
- configMapRef:
    name: app-config
```
- As mounted files:
```yaml
volumeMounts:
- name: config-volume
  mountPath: /etc/config
volumes:
- name: config-volume
  configMap:
    name: app-config
```

---

## 3. Secrets

**Definition:**
- Stores sensitive information like passwords, tokens, or keys.
- Encoded in base64; encrypt at rest in production.

**Creating Secrets:**
```bash
kubectl create secret generic db-secret --from-literal=username=admin --from-literal=password='P@ssw0rd'
kubectl create secret generic db-secret --from-file=ssh-key=/path/to/id_rsa
```

**Viewing Secrets:**
```bash
kubectl get secrets
kubectl describe secret db-secret
kubectl get secret db-secret -o yaml
```

**Using Secrets in Pods:**
- As environment variables:
```yaml
env:
- name: DB_USER
  valueFrom:
    secretKeyRef:
      name: db-secret
      key: username
- name: DB_PASS
  valueFrom:
    secretKeyRef:
      name: db-secret
      key: password
```
- As mounted files:
```yaml
volumeMounts:
- name: secret-volume
  mountPath: /etc/secret
volumes:
- name: secret-volume
  secret:
    secretName: db-secret
```

---

## 4. Environment Variables in Pods

- ConfigMaps and Secrets can be injected as environment variables.
- Supports dynamic updates (mounted files refresh automatically, env vars need Pod restart).
```yaml
envFrom:
- configMapRef:
    name: app-config
- secretRef:
    name: db-secret
```

---

## 5. Configuration Files in Pods

- Mount ConfigMaps/Secrets as files for apps that read configuration files.
```yaml
volumeMounts:
- name: config-volume
  mountPath: /etc/config
volumes:
- name: config-volume
  configMap:
    name: app-config
```
- Secrets mount similarly for secure files.

---

## 6. Updating Configurations

**ConfigMap Update:**
```bash
kubectl edit configmap app-config
```
- Mounted volumes reflect updates immediately.
- Pods using environment variables need restart.

**Secret Update:**
```bash
kubectl edit secret db-secret
```
- Same behavior as ConfigMaps.

---

## 7. Best Practices

- Decouple config from images → use ConfigMaps/Secrets.
- Use Secrets only for sensitive data.
- Avoid hardcoding environment-specific values.
- Use volume mounts for apps expecting config files.
- Use `kubectl rollout restart deployment <name>` after ConfigMap env updates.
- Consider external secret managers for production.

---

## 8. Hands-On Commands Summary
```bash
# Create ConfigMap
kubectl create configmap app-config --from-literal=APP_MODE=production

# Create Secret
kubectl create secret generic db-secret --from-literal=password='P@ssw0rd'

# Expose ConfigMap as env in Pod
kubectl apply -f pod-configmap-env.yaml

# Expose Secret as file in Pod
kubectl apply -f pod-secret-file.yaml

# View ConfigMap & Secret
kubectl describe configmap app-config
kubectl describe secret db-secret

# Update ConfigMap
kubectl edit configmap app-config
```

---

## Summary
- **ConfigMaps** → Non-sensitive config.
- **Secrets** → Sensitive config.
- **Environment Variables** → Inject config into Pods.
- **Config Files** → Mount ConfigMaps/Secrets inside Pods.
- **Dynamic Updates** → Mounted volumes auto-refresh; env vars require restart.
- **Best Practice** → Keep images immutable; manage all config externally.

