# Use the official Node.js image as a base image
FROM node:21-alpine3.18

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire app to the container
COPY ./dist/ /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start the app
CMD ["nginx", "-g", "daemon off;"]
