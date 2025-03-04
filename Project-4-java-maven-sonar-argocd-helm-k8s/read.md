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

### **Why Was ArgoCD Service Reverting to `ClusterIP`?**  

The reason your **ArgoCD server service (`example-argocd-server`) kept reverting to `ClusterIP`** is because ArgoCD is managed by an **Operator** (`argocd-operator`). The operator continuously reconciles the state of the ArgoCD resources based on its configuration.

#### **📌 Key Reasons It Didn't Change Initially:**
1. **ArgoCD Operator Enforces Defaults:**  
   - Your ArgoCD instance (`example-argocd`) is managed by the **`argocd-operator`**, which keeps the service type to its default (`ClusterIP`) unless explicitly changed in the ArgoCD custom resource (`argocd` CR).
  
2. **Direct `kubectl edit svc` Changes Are Overwritten:**  
   - If you manually changed the service type using `kubectl edit svc`, the operator **automatically reverted it** because its desired state was still `ClusterIP` in the `argocd` CR.
  
3. **Persistent Fix Required Editing the `argocd` CR:**  
   - The correct way to make the change persistent was to edit the `example-argocd` CR (`kubectl edit argocd example-argocd -n default`) and update:
     ```yaml
     spec:
       server:
         service:
           type: NodePort
     ```
   - This ensured that the **operator itself updated and maintained** the NodePort setting.

#### **🛠 How to Prevent This Issue in the Future**
- **Always check if an Operator manages the resource** (`kubectl get subscriptions -A`).
- **Edit the Custom Resource (CR) instead of directly modifying services**.
- **Verify with `kubectl get svc -n <namespace>` after editing the CR**.

Now, the change is persistent because the operator itself is enforcing `NodePort`. 🚀

Since your ArgoCD instance is in the default namespace, try the following:

1️⃣ Edit the ArgoCD Custom Resource
bash
Copy
Edit
kubectl edit argocd example-argocd -n default
This will open the YAML configuration in your default text editor.

2️⃣ Modify the server Service Type
Find the server section and change the service type to NodePort:

yaml
Copy
Edit
spec:
  server:
    service:
      type: NodePort
Save and exit the editor.

3️⃣ Restart ArgoCD to Apply Changes
bash
Copy
Edit
kubectl rollout restart deployment example-argocd-server -n default
4️⃣ Verify the Change
bash
Copy
Edit
kubectl get svc -n default
Ensure that example-argocd-server is now a NodePort service.

