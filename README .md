
# 📝 Todo-List Node.js CI/CD Pipeline with Docker, Ansible, Terraform, and Argo CD

This project is a fork of the original repository by [Ankit6098](https://github.com/Ankit6098/Todo-List-nodejs), customized and extended to support a complete CI/CD pipeline using Docker, Ansible, Terraform, Kubernetes, and Argo CD.

---

## 🔁 Cloning the Original Repository

Start by cloning the original project:

```bash
git clone https://github.com/Ankit6098/Todo-List-nodejs
cd Todo-List-nodejs
```

---

## 🧪 Local Testing

Run the app locally to verify it works before containerizing it:

```bash
npm install
npm start
```

---

## 🐳 Dockerizing the App (Multi-Stage)

Created a **multi-stage Dockerfile** for efficient image building:

- Stage 1: Build the app
- Stage 2: Run the app with production dependencies only

The image is tagged and pushed to Docker Hub:

```bash
docker build -t your-dockerhub-username/todo-list-node:TAG .
docker push your-dockerhub-username/todo-list-node:TAG
```

---

## 🤖 CI/CD Pipeline (GitHub Actions)

Configured GitHub Actions to:

1. Build the Docker image
2. Push it to Docker Hub
3. Replace `{{TAG}}` in Kubernetes manifests
4. Argo CD watches for changes and syncs automatically

---

## ⚙️ Ansible Configuration

Used Ansible to automate the setup of:

- Docker
- Kubernetes (via kubeadm)
- Argo CD

Playbook executed against local/remote VM for environment setup.

---

## ☁️ Provisioning Infrastructure with Terraform

Provisioned an **AWS EC2 instance** using Terraform:

- Created a security group
- Used SSH key for access
- Passed the `public_ip` output to Ansible inventory dynamically

---

## ☸️ Kubernetes Setup

Installed Kubernetes manually using `kubeadm` on the EC2 instance:

- Installed container runtime (Docker)
- Initialized cluster
- Set up `kubectl` for root and non-root users

---

## 🚀 Argo CD

Installed Argo CD on the Kubernetes cluster:

- Exposed Argo CD via NodePort
- Logged in via CLI and Web UI
- Connected to this GitHub repo
- Configured app to sync automatically on image/tag changes

---

## 📦 Dynamic Deployments with Argo CD

- Argo CD watches the repository
- On new image pushed, CI updates the Kubernetes manifest
- Argo CD auto-syncs the new deployment

---

## ✅ Technologies Used

- Node.js
- Docker (Multi-stage)
- GitHub Actions
- Terraform (AWS)
- Ansible
- Kubernetes (kubeadm)
- Argo CD

---

## 🔒 Secrets & Configuration

Sensitive info like `MONGO_URI` is managed using Kubernetes `Secrets`.

---

## 📬 Contact

Made by **Sali Ibrahim**  
Docker Hub: [saliibrahem](https://hub.docker.com/u/saliibrahem)

---
