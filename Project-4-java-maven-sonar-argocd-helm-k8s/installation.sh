     #!/bin/bash
     
     sudo adduser  sonarqube
      
      # Switch to sonarqube user and install SonarQube
      sudo su - sonarqube -c 'cd /home/sonarqube && wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip'
      sudo su - sonarqube -c 'cd /home/sonarqube && unzip sonarqube-9.4.0.54424.zip'
      sudo su - sonarqube -c 'chmod -R 755 /home/sonarqube/sonarqube-9.4.0.54424'
      sudo su - sonarqube -c 'chown -R sonarqube:sonarqube /home/sonarqube/sonarqube-9.4.0.54424'

      # Start SonarQube
      sudo su - sonarqube -c 'nohup /home/sonarqube/sonarqube-9.4.0.54424/bin/linux-x86-64/sonar.sh start &'
     
      # Install kubectl
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
     curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl

      # Install Minikube
       
      sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
      sudo dpkg -i minikube_latest_amd64.deb
      minikube start --driver=docker
      minikube status
      kubectl get nodes

      # Install ArgoCD
      sudo curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.31.0/install.sh | bash -s v0.31.0
       kubectl create -f https://operatorhub.io/install/argocd-operator.yaml --validate=false
