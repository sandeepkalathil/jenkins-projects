Step 2: Install Docker Plugin in Jenkins
Open Jenkins Web UI → Manage Jenkins → Manage Plugins.
In the Available tab, search for "Docker Pipeline" and install it.
Restart Jenkins.


Step 3: Manually Add the Node in Jenkins
If SSH works manually, try adding the node in Jenkins:

Go to Jenkins Dashboard → Manage Jenkins → Manage Nodes and Clouds → New Node.

Enter Details:

Node name: Docker-Agent
Type: Permanent Agent
Remote root directory: /home/ubuntu
Labels: docker
Launch method: Launch agent via SSH
Host: <WORKER_NODE_IP>
Credentials:
Click "Add" → "SSH Username with private key"
Username: ubuntu
Private Key: Select "Enter directly", then copy & paste the private key from /var/lib/jenkins/.ssh/id_rsa
Click "OK"
Click "Save and Launch".

If the agent comes online, everything is set up correctly!



Fix 1: Ensure Correct PAT Permissions
You need to regenerate your Personal Access Token (PAT) with the correct permissions.

1️⃣ Go to GitHub → Settings → Developer Settings → Personal Access Tokens
2️⃣ Click "Generate new token (classic)"
3️⃣ Select "repo" scope to grant access to private repositories:

✅ repo → Full control of private repositories
✅ workflow (if using GitHub Actions)
4️⃣ Click "Generate Token" and copy it immediately
5️⃣ Update Jenkins Credentials:
Go to Jenkins → Manage Jenkins → Credentials
Delete the old credential
Add a new "Username and Password" credential
Username: Your GitHub username
Password: Paste the newly generated PAT
6️⃣ Save and retry the job
