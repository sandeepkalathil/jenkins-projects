# Create a Simple HTML Website

## 📌 Project Structure

Create the following files in a folder `.

```
Yourfolder/
│── Dockerfile
│── index.html
│── styles.css
│── server.js
│── package.json
```

## 2️⃣ Create `index.html` (Your Website)

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Website</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Welcome to My Website</h1>
    <p>This is a simple HTML page running in a Docker container.</p>
</body>
</html>
```

## 3️⃣ Create `styles.css` (Optional)

```css
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    text-align: center;
    padding: 50px;
}
h1 {
    color: #333;
}
```

## 4️⃣ Create `server.js` (Simple Node.js Server)

```javascript
const express = require('express');
const app = express();

app.use(express.static(__dirname));

const PORT = 8020;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
```

## 5️⃣ Create `package.json` (Node.js Dependencies)

```json
{
  "name": "html-website",
  "version": "1.0.0",
  "description": "A simple HTML website running in Docker",
  "main": "server.js",
  "dependencies": {
    "express": "^4.17.1"
  },
  "scripts": {
    "start": "node server.js"
  }
}
```

## 6️⃣ Create a `Dockerfile` (Build the Image)

```dockerfile
# Use official Node.js runtime as base image
FROM node:16-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json ./
RUN npm install

# Copy all files to container
COPY . .

# Expose port 8020
EXPOSE 8020

# Command to run the server
CMD ["npm", "start"]
```

## 7️⃣ Build and Run the Docker Container

```sh
# Build the Docker image
docker build -t my-html-website .

# Run the container
docker run -d -p 8020:8020 my-html-website
```
✅ Your website should now be running at [http://localhost:8020](http://localhost:8020).

## 8️⃣ Push the Image to Docker Hub

```sh
# Log in to Docker Hub
docker login

# Tag the image (Replace 'your-dockerhub-username')
docker tag my-html-website your-dockerhub-username/html-website

# Push the image
docker push your-dockerhub-username/html-website
```


## 🔟 Automate with Jenkins

Your Jenkinsfile can use the image:

```groovy
pipeline {
    agent none  // No execution on the master node

    environment {
        DOCKER_IMAGE = 'sandeepkalathil/html-website'
        CONTAINER_NAME = 'html-web-container'  // Name for the new container
        EXPOSED_PORT = '8020'  // Port to expose on the host
    }

    stages {

        stage('Login to Docker Hub') {
    agent { label 'Docker-Agent' }
    steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
        }
    }
}
        
        stage('Deploy New Container') {
    agent { label 'Docker-Agent' }
    steps {
        script {
            echo '🔹 Logging into Docker Hub...'
            withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
            }

            echo '🔹 Pulling latest image from Docker Hub...'
            sh "docker pull $DOCKER_IMAGE"

            echo '🔹 Stopping any existing container...'
            sh "docker stop $CONTAINER_NAME || true"
            sh "docker rm $CONTAINER_NAME || true"

            echo '🔹 Running a new container...'
            sh """
            docker run -d --name $CONTAINER_NAME -p $EXPOSED_PORT:8020 $DOCKER_IMAGE
            """
        }
    }
}
    }
}

```

## 🎯 Final Result

✅ Jenkins will:

1. Build the Docker image from your code.
2. Push it to Docker Hub.
3. Automate using Jenkins.



