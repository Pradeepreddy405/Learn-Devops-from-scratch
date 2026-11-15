# 1. Introduction to Software Architecture

Before understanding **Single-Tier Architecture**, it is important to understand three fundamental concepts:

1. What is an Application?
2. What is Software Architecture?
3. What does Tier mean?

---

## 1.1 What is an Application?

An application is a software program designed to perform a particular task for users.

### Examples of Applications

| Application | Purpose |
|---|---|
| Calculator | Performs mathematical operations |
| Notepad | Allows users to write and save text |
| Banking Application | Manages bank accounts and transactions |
| E-commerce Application | Allows users to browse and purchase products |

Every application requires some combination of the following components:

**1. User Interface (UI)**
- The part of the application where users interact.
- Example: Buttons, forms, menus, and screens.

**2. Business Logic**
- Contains the rules and operations of the application.
- Example: Calculating totals, validating user input, and processing transactions.

**3. Data Storage**
- Stores application information for future use.
- Example: Files, databases, and customer records.

---

## 1.2 What is Software Architecture?

Software architecture describes how different components of an application are organized, structured, and communicate with each other.

Think about constructing a house.

A house contains:
- Foundation
- Bedrooms
- Kitchen
- Bathrooms
- Electrical systems

Each component has a specific purpose and contributes to the overall structure of the house.

Similarly, a software application contains different components that work together to perform specific operations.

**Software Architecture = Blueprint of a Software Application.**

It defines:
- How application components are organized.
- How different components communicate.
- Where application logic is executed.
- Where application data is stored.
- How the application is deployed.

---

## 1.3 What Does Tier Mean?

A Tier represents a logical or physical layer of an application architecture.

It describes how application components are separated and organized.

### Types of Application Tiers

| Architecture | Description |
|---|---|
| 1-Tier | All major application components are together. |
| 2-Tier | Application and database are separated. |
| 3-Tier | Presentation, application logic, and database are separated. |

### Understanding the Difference

**1-Tier Architecture**
- User Interface
- Business Logic
- Data Storage

All components are maintained within a single tier.

**2-Tier Architecture**
- Client Tier
- Database Tier

The application runs on the client side and communicates with a separate database tier.

**3-Tier Architecture**
- Presentation Tier
- Application Tier
- Database Tier

Each tier has a separate responsibility.

---

## 1.4 Important Concept: Tier vs Server

A Tier is not necessarily the same as a server, process, or physical machine.

A tier represents an architectural separation of application responsibilities.

A server represents an infrastructure resource that can host one or more application components.

For example:
- Multiple tiers can run on the same physical server.
- A single tier can be distributed across multiple servers.

Therefore, **logical separation and physical deployment are two different concepts.**

---

## 1.5 Summary

| Concept | Meaning |
|---|---|
| Application | Software designed to perform a particular task. |
| User Interface | Allows users to interact with the application. |
| Business Logic | Contains application rules and operations. |
| Data Storage | Stores application information. |
| Software Architecture | Defines the structure and organization of an application. |
| Tier | Represents a logical or physical architectural layer. |

### Key Takeaway

Before learning different application architectures, understand that every application has components, and software architecture defines how those components are organized and interact with each other.

**Next Topic:** Single-Tier Architecture – Architecture, Components, Working, Examples, Advantages, Disadvantages, and Real-World Use Cases.