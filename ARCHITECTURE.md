# 🏗 StartTech System Architecture

This document describes the cloud-native architecture for the StartTech 3-tier application, deployed on AWS using Terraform and GitHub Actions.

---

## 🌐 High-Level Architecture
The application follows a standard 3-tier architecture (Web, Application, and Data) to ensure scalability, security, and high availability.



---

## 🚀 Component Breakdown

### 1. Web Tier (Frontend)
* **Storage**: Static React files are hosted in an **Amazon S3 Bucket** (`starttech-frontend-charles-v2-2026`).
* **Content Delivery**: **Amazon CloudFront** acts as a CDN to cache content globally, reducing latency and protecting the S3 origin.
* **Security**: Public access to S3 is restricted, with CloudFront being the only authorized entry point.

### 2. Application Tier (Backend)
* **Compute**: The Go (Golang) API runs on **EC2 Instances** managed by an **Auto Scaling Group (ASG)**.
* **Load Balancing**: An **Application Load Balancer (ALB)** distributes incoming traffic across healthy instances in multiple Availability Zones.
* **Scaling**: The ASG automatically adds or removes instances based on CPU utilization metrics to maintain performance.

### 3. Data & Caching Tier
* **Caching**: **Amazon ElastiCache (Redis)** is used for session management and to reduce database load.
* **Database**: **MongoDB Atlas** serves as the primary data store for persistence.

---

## 🛠 CI/CD Workflow
We utilize two distinct pipelines to automate the lifecycle of the application:

1.  **Infrastructure Pipeline**: Deploys networking, compute, and storage using **Terraform**.
2.  **Application Pipeline**: 
    * **Frontend**: Builds the React production bundle and syncs it to S3.
    * **Backend**: Build a **Docker image**, pushes it to **Amazon ECR**, and triggers a rolling update (Instance Refresh) on the ASG.

---

## 🔒 Security Implementation
* **Network Segmentation**: Resources are placed in **Private Subnets**, with the ALB and NAT Gateway residing in **Public Subnets**.
* **Identity Management**: GitHub Actions deployments are managed via a dedicated **IAM User** following the Principle of Least Privilege.
* **Vulnerability Management**: Automated security scans (`npm audit` and Docker scanning) are integrated into the deployment process.