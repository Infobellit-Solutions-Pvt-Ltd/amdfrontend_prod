# Base image

FROM ubuntu:20.04
 
# Disable prompts

ENV DEBIAN_FRONTEND=noninteractive
 
# Update, install Nginx and sudo

RUN apt-get update && \

    apt-get install -y nginx sudo curl && \

    apt-get clean
 
# Create a new user and give sudo access (optional)

RUN useradd -ms /bin/bash webuser && \

    echo "webuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
 
# Switch to the new user (optional, remove these two lines if you want to run as root)

USER webuser

WORKDIR /home/webuser
 
# Copy static files to Nginx's default HTML directory

COPY ./build /var/www/html
 
# Copy your custom nginx config

USER root

COPY nginx.conf /etc/nginx/sites-available/default
 
# Fix permissions

RUN chown -R www-data:www-data /var/www/html
 
# Expose HTTPS port

EXPOSE 443
 
# Start Nginx

CMD ["nginx", "-g", "daemon off;"]
 