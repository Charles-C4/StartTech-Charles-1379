# 🛠 StartTech Operations Runbook

This guide provides procedures for monitoring, maintaining, and troubleshooting the StartTech 3-tier application.

---

## 🚦 System Health Check
Before troubleshooting, verify the status of the infrastructure:
* **Backend Health**: Run `./scripts/health-check.sh` to confirm the Load Balancer returns a `200 OK`.
* **Infrastructure State**: Check the **AWS CloudWatch Dashboard** for CPU spikes or unhealthy host counts.

---

## 🔍 Common Issues & Resolutions

### 1. 502 Bad Gateway (Backend Unreachable)
**Symptom:** The website loads but data doesn't appear, or the ALB URL returns a 502 error.
* **Possible Cause:** The Go application service has crashed or the Target Group health check is failing.
* **Resolution Steps:**
    1.  Navigate to **EC2 > Target Groups > starttech-backend-tg**.
    2.  Verify the "Health Status" of the instances. If "Unhealthy," check the health check path (should be `/`).
    3.  Check **Security Groups**: Ensure the Backend instances allow inbound traffic on the app port from the ALB.

### 2. 403 Forbidden (Frontend Unreachable)
**Symptom:** The CloudFront URL returns a "403 Forbidden" or "Access Denied" page.
* **Possible Cause:** CloudFront cache is stale or S3 permissions are incorrect.
* **Resolution Steps:**
    1.  Verify the S3 bucket policy allows CloudFront access.
    2.  Trigger a cache invalidation by running: 
        ```bash
        ./scripts/deploy-frontend.sh
        ```
    3.  Confirm the `dist/` folder was correctly uploaded to the bucket.

### 3. Pipeline Failure: "AccessDenied" on S3 Sync
**Symptom:** The GitHub Action fails at the "Deploy to S3" stage.
* **Possible Cause:** The IAM user `github-actions-deployer` is missing `s3:ListBucket` permissions.
* **Resolution Steps:**
    1.  Go to **IAM > Users > github-actions-deployer**.
    2.  Ensure the Inline Policy includes permission for both the bucket (`arn:aws:s3:::bucket-name`) and its contents (`arn:aws:s3:::bucket-name/*`).

---

## 🔄 Deployment & Recovery

### Manual Deployment
If the automatic GitHub trigger fails, you can manually push updates:
* **Backend**: `./scripts/deploy-backend.sh`.
* **Frontend**: `./scripts/deploy-frontend.sh`.

### Emergency Rollback
If a deployment causes production instability:
1.  Run the rollback script to trigger an **Auto Scaling Instance Refresh**:
    ```bash
    ./scripts/rollback.sh
    ```
2.  This will replace current instances with the last known stable configuration.

---

## 📈 Monitoring & Alerts
* **Alarms**: High CPU utilization (>80%) triggers a CloudWatch alarm.
* **Logs**: Application logs are centralized in **CloudWatch Log Groups** for debugging.