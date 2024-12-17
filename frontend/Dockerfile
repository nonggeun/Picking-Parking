# Environment to install Flutter and build web
FROM debian:latest AS build-env

# Install all needed stuff
RUN apt-get update && \
    apt-get install -y curl git unzip xz-utils

# Define variables
ARG FLUTTER_SDK=/usr/local/flutter
ARG FLUTTER_VERSION=3.24.3
ARG APP=/app/

# Clone Flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_SDK
# Change directory to current Flutter folder and make a checkout to the specific version
RUN cd $FLUTTER_SDK && git fetch && git checkout $FLUTTER_VERSION

# Setup the Flutter path as an environmental variable
ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"

# Create a non-root user
RUN useradd -m flutteruser

# Change ownership of the Flutter directory to the new user
RUN chown -R flutteruser:flutteruser $FLUTTER_SDK

# Create the application directory as root
RUN mkdir $APP

# Change ownership of the application directory
RUN chown flutteruser:flutteruser $APP

# Switch to the non-root user
USER flutteruser

# Run Flutter doctor to see if all was installed ok
RUN flutter doctor -v

# Copy source code to folder
COPY --chown=flutteruser:flutteruser . $APP  

# Setup new folder as the working directory
WORKDIR $APP

# Run build: 1 - clean, 2 - pub get, 3 - build web
RUN flutter clean
RUN flutter pub get
RUN flutter build web

# Once here, the app will be compiled and ready to deploy

# Use Nginx to deploy
FROM nginx:1.25.2-alpine

# Copy the info of the built web app to Nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Expose and run Nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]