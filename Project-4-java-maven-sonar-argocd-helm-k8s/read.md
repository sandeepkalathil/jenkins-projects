# Jenkins and Docker Setup Guide

## Step 1: Set Up SSH Keyless Authentication

Once the resources are created using Terraform, run the script located in the path:

```
/tmp/ssh-password-less-Control-Node.sh
```

This script ensures that SSH keyless password authentication is set up between the Master and Worker Nodes.

Once completed, access the Jenkins URL and proceed with installing the recommended plugins.

---

## Step 2: Install Docker Plugin in Jenkins

1. Open **Jenkins Web UI** → **Manage Jenkins** → **Manage Plugins**.
2. In the **Available** tab, search for **"Docker Pipeline"** and install it.
3. Restart Jenkins.

---

## Step 3: Manually Add the Node in Jenkins

If SSH works manually, try adding the node in Jenkins:

1. Go to **Jenkins Dashboard** → **Manage Jenkins** → **Manage Nodes and Clouds** → **New Node**.
2. Enter the following details:
   - **Node name**: `Docker-Agent`
   - **Type**: Permanent Agent
   - **Remote root directory**: `/home/ubuntu`
   - **Labels**: `docker`
   - **Launch method**: Launch agent via SSH
   - **Host**: `<WORKER_NODE_IP>`
   - **Credentials**:
     - Click **"Add"** → **"SSH Username with private key"**
     - **Username**: `ubuntu`
     - **Private Key**: Select **"Enter directly"**, then copy & paste the private key from `/var/lib/jenkins/.ssh/id_rsa`
3. Click **OK**.
4. Click **Save and Launch**.

If the agent comes online, everything is set up correctly!

---

## Step 4: Add Credentials for a Private Repository

If you are using a private repository, you need to add the credentials by following these steps:

### **1️⃣ Generate a New Personal Access Token (PAT)**

1. Go to **GitHub** → **Settings** → **Developer Settings** → **Personal Access Tokens**.
2. Click **"Generate new token (classic)"**.
3. Select the **"repo"** scope to grant access to private repositories:
   - ✅ `repo` → Full control of private repositories
   - ✅ `workflow` (if using GitHub Actions)
4. Click **"Generate Token"** and copy it immediately.

### **2️⃣ Update Jenkins Credentials**

1. Go to **Jenkins** → **Manage Jenkins** → **Credentials**.
2. Delete the old credential (if any).
3. Add a new **"Username and Password"** credential:
   - **Username**: Your GitHub username
   - **Password**: Paste the newly generated **Personal Access Token (PAT)**
4. Save and retry the job.

---

✅ **Your Jenkins and Docker setup should now be complete!** 🎉

