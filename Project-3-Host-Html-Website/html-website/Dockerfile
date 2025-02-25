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
