# Kubernetes Module 3 — Services & Networking

## Overview
This module focuses on **Kubernetes Services & Networking**, providing a solid understanding of how Pods communicate **internally and externally**, along with hands-on experience using different Service types. It also introduces **production-grade networking concepts** such as selectors, endpoints, headless services, traffic policies, and network security fundamentals.

This module builds a strong foundation for **real-world and interview-ready Kubernetes networking knowledge**.

---

## Table of Contents
1. Why Services are Needed  
2. Pod-to-Pod Communication  
3. Service Discovery: Labels, Selectors & Endpoints  
4. Kubernetes Service Types  
   - ClusterIP  
   - NodePort  
   - LoadBalancer  
   - Headless Services  
5. kube-proxy Basics  
6. Traffic Flow & Service Advanced Settings  
   - ExternalTrafficPolicy  
   - Session Affinity  
7. DNS in Kubernetes  
8. Network Policies (Intro)  
9. Ingress vs Services (High-Level)  
10. Hands-On Lab  
11. Best Practices  
12. Summary & Conclusion

---

## 1. Why Services are Needed

In Kubernetes, **Pods are ephemeral**. They can be created, destroyed, rescheduled, or scaled at any time. Each Pod receives its own IP address, but this IP is **temporary** and changes whenever the Pod restarts.

This creates several challenges:
- Pod-to-Pod communication becomes unreliable if Pod IPs are used directly
- External clients cannot consistently access Pods
- Load balancing and service discovery become difficult

  ### Solution: Kubernetes Services

A **Service** provides a stable, persistent abstraction over a group of Pods.

Services provide:
- **Stable network identity** (virtual IP + DNS name)
- **Built-in load balancing** across Pods
- **Loose coupling** between consumers and backend Pods

> Example: A frontend Pod communicates with a backend Service without knowing which backend Pod is serving the request.

---

## 2. Pod-to-Pod Communication

Pods are the smallest deployable units in Kubernetes. Applications built using microservices require reliable Pod-to-Pod communication, either within the same node or across nodes.

### a) IP-based Communication
Each Pod gets a unique IP address.
Kubernetes enforces a **flat network model**, meaning:
- Every Pod can communicate with every other Pod
- No NAT is required between Pods

```bash
curl http://10.244.0.5:80   # Pod IP
```

> ⚠️ Direct Pod IP usage is not recommended in production.

---

### b) Communication via Services

Since Pod IP's are temporary, Services act as stable access points and Kubernetes mainly exposes services in three modes (types)

   Common Service exposure patterns:
   1. **ClusterIP** – internal-only access
   2. **NodePort** – access via node IP
   3. **LoadBalancer** – external cloud access

---

### c) DNS-based Communication

Kubernetes includes built-in DNS (CoreDNS).
Instead of IPs, Pods communicate using **Service names**.

```bash
curl http://nginx-service.default.svc.cluster.local
```

This makes communication:
- Reliable
- Portable
- Environment-agnostic

---

### d) Pod Network Requirements

Kubernetes requires a flat networking model. This is implemented using **CNI plugins**, such as:
- Calico
- Flannel
- Weave

These plugins handle routing, IP allocation, and network policies.

Example:
```bash
kubectl run test-pod --image=busybox -it --rm -- sh
wget -qO- http://backend-service
```

---

## 3. Service Discovery: Labels, Selectors & Endpoints

Services do **not** automatically know which Pods to route traffic to.
They rely on **labels and selectors**.

### a) Labels & Selectors

Pods are labeled:
```yaml
labels:
  app: nginx
```

Services select Pods using these labels:
```yaml
selector:
  app: nginx
```

If labels do not match, the Service will have **no backend Pods**.

---

### b) Endpoints & EndpointSlices

Behind the scenes, Kubernetes creates:
- **Endpoints** (small clusters)
- **EndpointSlices** (large-scale clusters)

These objects store the actual Pod IPs backing a Service.

Debug command:
```bash
kubectl get endpoints nginx-service
```

---

## 4. Kubernetes Service Types

### 4.1 ClusterIP (Internal Access)
- Default Service type
- Accessible only inside the cluster
- Provides stable IP and DNS

```bash
kubectl expose deployment nginx-deploy --name=nginx-service --port=80 --target-port=80
kubectl get svc nginx-service
```

---

### 4.2 NodePort (External Access)
- Exposes Service on every node’s IP
- Port range: **30000–32767**
- Accessible via `NodeIP:NodePort`

```bash
kubectl expose deployment nginx-deploy --type=NodePort --name=nginx-nodeport --port=80
kubectl get svc nginx-nodeport
```

> Requires firewall / security group rules.

---

### 4.3 LoadBalancer (Cloud Managed)
- Used in cloud environments (AWS, GCP, Azure)
- Automatically provisions external IP

Traffic flow:
```
User → LoadBalancer → Service → Pods
```

```bash
kubectl expose deployment nginx-deploy --type=LoadBalancer --name=nginx-lb --port=80
```

---

### 4.4 Headless Services

Used when direct Pod discovery is required.

```yaml
clusterIP: None
```

Characteristics:
- No virtual IP
- DNS returns Pod IPs directly

Use cases:
- StatefulSets
- Databases
- Leader election

---

## 5. kube-proxy Basics

- Runs on every node
- Programs networking rules
- Routes traffic from Services to Pods
- Supports:
  - **iptables**
  - **IPVS** (high performance)

Without kube-proxy, Service networking breaks.

---

## 6. Traffic Flow & Service Advanced Settings

### a) ExternalTrafficPolicy

Controls how external traffic is routed.

```yaml
externalTrafficPolicy: Cluster | Local
```

- **Cluster (default)**: Load balances across all nodes
- **Local**: Preserves client IP

---

### b) Session Affinity (Sticky Sessions)

Ensures traffic from a client goes to the same Pod.

```yaml
sessionAffinity: ClientIP
```

Used for:
- Legacy apps
- Login-based systems

---

## 7. DNS in Kubernetes

- Powered by CoreDNS
- Automatic Service name resolution

DNS format:
```
<service-name>.<namespace>.svc.cluster.local
```

Simplified access:
```bash
curl http://nginx-service
```

---

## 8. Network Policies (Intro)

By default:
- All Pods can talk to each other

**NetworkPolicy** restricts traffic based on:
- Pod selectors
- Namespaces
- Ports

Used for:
- Security isolation
- Zero-trust networking

---

## 9. Ingress vs Services (High-Level)

Services expose applications.
Ingress manages **HTTP/HTTPS routing**.

Typical flow:
```
User → Ingress → Service → Pods
```

Ingress will be covered in a dedicated module.

---

## 10. Hands-On Lab

### 1. Deploy Nginx
```bash
kubectl create deployment nginx-deploy --image=nginx --replicas=3
kubectl get pods
```

### 2. ClusterIP Service
```bash
kubectl expose deployment nginx-deploy --name=nginx-service --port=80
kubectl get svc nginx-service
```

### 3. NodePort Service
```bash
kubectl expose deployment nginx-deploy --type=NodePort --name=nginx-nodeport --port=80
kubectl get svc nginx-nodeport
```

Access:
```bash
curl http://<EC2_PUBLIC_IP>:<NodePort>
```

### 4. LoadBalancer Service
```bash
kubectl expose deployment nginx-deploy --type=LoadBalancer --name=nginx-lb --port=80
kubectl get svc nginx-lb
```

---

## 11. Best Practices

- Use **ClusterIP** for internal services
- Use **NodePort** only for testing
- Use **LoadBalancer + Ingress** in production
- Prefer **DNS over IPs**
- Monitor **kube-proxy and endpoints**
- Apply **NetworkPolicies** for security

---

## 12. Summary & Conclusion

- Pods are ephemeral; Services provide stability
- Services rely on labels and selectors
- kube-proxy enables Service networking
- DNS enables service discovery
- NetworkPolicies secure traffic

By completing this module, you now have a **production-grade understanding of Kubernetes Services & Networking**, essential for real-world DevOps and platform engineering roles.

