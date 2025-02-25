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