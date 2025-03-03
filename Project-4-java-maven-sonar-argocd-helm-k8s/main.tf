provider "aws" {
  region = "eu-north-1"
}

resource "aws_key_pair" "sand" {
  key_name   = "sandeep_pub"
  public_key = file("C:/Users/SANDEEP/.ssh/id_rsa.pub")
}

resource "aws_instance" "Jenkins" {
  ami                  = "ami-09a9858973b288bdd"
  instance_type        = "t3.large"
  key_name             = aws_key_pair.sand.key_name
  subnet_id            = "subnet-0db3301d81441e6d0"
  security_groups      = ["sg-0bf2dc323a4381c50"]
  user_data            = base64encode(file("userdata.sh"))
  iam_instance_profile = "MySessionManagerrole"

  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
  }

  connection {
    type        = "ssh"
    private_key = file("C:/Users/SANDEEP/.ssh/id_rsa")
    host        = self.public_ip
    user        = "ubuntu"
  }



  provisioner "remote-exec" {
    inline = ["echo 'The instance is accessible'",
      "sudo apt update",
      "sudo apt install openjdk-17-jre -y",
      "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
      "echo 'deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/' | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install jenkins -y"
   ]


  }

   provisioner "file" {
    source      = "ssh-password-less-Control-Node.sh"
    destination = "/tmp/ssh-password-less-Control-Node.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Adjust based on your AMI (ubuntu, ansadmin, etc.)
      private_key = file("C:/Users/SANDEEP/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
  
  tags = {
    Name = "Jenkins-Master"
  }
}



resource "aws_instance" "Jenkins-Docker" {
  ami                  = "ami-09a9858973b288bdd"
  instance_type        = "t3.large"
  key_name             = aws_key_pair.sand.key_name
  subnet_id            = "subnet-0db3301d81441e6d0"
  security_groups      = ["sg-0bf2dc323a4381c50"]
  user_data            = base64encode(file("userdata.sh"))
  iam_instance_profile = "MySessionManagerrole"

  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
  }

  connection {
    type        = "ssh"
    private_key = file("C:/Users/SANDEEP/.ssh/id_rsa")
    host        = self.public_ip
    user        = "ubuntu"
  }



  provisioner "remote-exec" {
    inline = ["echo 'The instance is accessible'",
      "sudo apt update",
      "sudo apt install -y unzip wget openjdk-17-jdk",

      # Create sonarqube user and setup directories
      "sudo adduser --system --no-create-home --group sonarqube",
      "sudo mkdir -p /home/sonarqube",
      "sudo chown -R sonarqube:sonarqube /home/sonarqube",

      # Switch to sonarqube user and install SonarQube
      "sudo su - sonarqube -c 'cd /home/sonarqube && wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip'",
      "sudo su - sonarqube -c 'cd /home/sonarqube && unzip sonarqube-9.4.0.54424.zip'",
      "sudo su - sonarqube -c 'chmod -R 755 /home/sonarqube/sonarqube-9.4.0.54424'",
      "sudo su - sonarqube -c 'chown -R sonarqube:sonarqube /home/sonarqube/sonarqube-9.4.0.54424'",

      # Start SonarQube
      "sudo su - sonarqube -c 'nohup /home/sonarqube/sonarqube-9.4.0.54424/bin/linux-x86-64/sonar.sh start &'"
      
    ]


  }

    
  tags = {
    Name = "docker-Jenkins"
  }
}
