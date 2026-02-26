# TASK-11: GitHub Actions Deployment Workflow (ECS + ECR + CodeDeploy)

## Overview

This task describes how to set up a **GitHub Actions deployment workflow** to automatically deploy a containerized application to AWS using **ECS Blue/Green deployments**.

The workflow performs the following:
- Pushes a Docker image to Amazon ECR with the GitHub commit SHA
- Updates the ECS Task Definition dynamically with the new image
- Triggers an AWS CodeDeploy deployment
- Optionally monitors deployment status and rolls back on failure

This setup enables **zero-downtime, production-grade deployments**.

---

## Workflow Trigger

The deployment workflow can be triggered by:
- Completion of a CI workflow that builds the Docker image
- Push to the `main` branch
- Manual trigger using `workflow_dispatch`

This ensures deployments only occur after a successful build.

---

## Deployment Process

### 1. Push Docker Image to Amazon ECR

- Authenticate GitHub Actions with AWS using IAM credentials
- Tag the Docker image with the **GitHub commit SHA**
- Push the image to the configured ECR repository

**Why commit SHA tags?**
- Ensures traceability
- Enables easy rollback
- Prevents image overwrites

---

### 2. Update ECS Task Definition

- Retrieve the current ECS Task Definition
- Replace the container image with the new ECR image tag
- Register a new Task Definition revision
- Store the new Task Definition ARN

This guarantees ECS always runs the exact image built from the repository.

---

### 3. Trigger CodeDeploy Deployment

- Create a new deployment using:
  - CodeDeploy application name
  - Deployment group name
  - AppSpec configuration
- The AppSpec file references the new ECS Task Definition ARN

CodeDeploy then:
- Launches the Green task set
- Performs health checks
- Shifts traffic from Blue to Green
- Terminates the old version after success

---

### 4. Monitor Deployment Status (Optional)

- Poll CodeDeploy for deployment status
- Display progress in GitHub Actions logs
- Detect success or failure automatically

---

### 5. Automatic Rollback on Failure (Optional)

If deployment fails:
- CodeDeploy routes traffic back to the Blue environment
- ECS continues running the last stable Task Definition
- The GitHub Actions workflow fails safely

This ensures **no user-facing downtime**.

---

## IAM & Security Requirements

The GitHub Actions runner must have permissions to:
- Push images to Amazon ECR
- Register ECS Task Definitions
- Create and monitor CodeDeploy deployments

Use least-privilege IAM roles and store credentials securely in GitHub Secrets.

---

## Result

After completing TASK-11:
- Deployments are fully automated
- ECS services run versioned, traceable images
- Blue/Green deployments ensure zero downtime
- Rollbacks occur automatically on failure

This workflow is suitable for **production-ready AWS container deployments**.
