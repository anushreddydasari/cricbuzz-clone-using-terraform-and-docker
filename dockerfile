# Use a lightweight Nginx image as the base
FROM nginx:alpine

# Copy the static files to the Nginx container's default directory
COPY . /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx as the default process
CMD ["nginx", "-g", "daemon off;"]