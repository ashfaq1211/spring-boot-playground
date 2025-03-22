# Spring Boot Playground

[![GitHub](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/ashfaq1211/spring-boot-playground/)
[![Java](https://img.shields.io/badge/Java-21-red)](https://openjdk.org/projects/jdk/21/)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.4.4-brightgreen)](https://spring.io/projects/spring-boot)
[![Maven](https://img.shields.io/badge/Maven-3.9.9-orange)](https://maven.apache.org/docs/3.9.9/release-notes.html)
[![Docker](https://img.shields.io/badge/Docker-28%2B-blue)](https://docs.docker.com/engine/release-notes/28/)


Spring Boot Playground is a project designed to explore various Spring Boot implementations through a multi-environment setup.
Use it as a sandbox environment for experimenting with Spring Boot features and other integrations, Docker containerization, and GitHub Container Registry deployments.

> **📌 Note:** Some configuration files (e.g., environment-specific `.yml` files) and directories (like the build output) are intentionally excluded from version control via `.gitignore` to keep sensitive data and machine-specific settings local. See the "Creating & Using Ignored Files" section below for more details.
> As an example, a Dev and a Prod setup has been included. You can add as many more environments as needed.

---

## 🧭 Table of Contents

1. [🌐 Project Overview](#-project-overview)
2. [⚙️ Prerequisites](#-prerequisites)
3. [🗂️ Folder Structure](#-folder-structure)
4. [🛠️ Configuration Files](#-configuration-files)
5. [🐳 Docker & Deployment Setup](#-docker--deployment-setup)
    - [🧪 Local Development](#-local-development)
    - [🚧 Development Deployment](#-development-deployment)
    - [🚀 Production Deployment](#-production-deployment)
6. [🤖 Automation Scripts](#-automation-scripts)
7. [📄 Creating & Using Ignored Files](#-creating--using-ignored-files)
8. [🚨 Troubleshooting](#-troubleshooting)
9. [🤝 Contributing](#-contributing)
10. [🔭 Further Exploration](#-further-exploration)

---

## 🌐 Project Overview

This project uses Spring Boot with Maven as the build tool. It is structured to support different deployments:
- **Local Development:** Rapid iterations with hot-reload.
- **Development (Dev):** An environment for integration testing.
- **Production (Prod):** A stable deployment with auto-restart features.

Docker is used to build and run the application, while images are pushed to the GitHub Container Registry for dev/production releases.

---

## ⚙️ Prerequisites

Before working on or deploying this project, make sure you have the following installed:

- Java 21 (as specified in the `pom.xml`)
- Maven (or use the Maven wrapper in the repo)
- Docker & Docker Compose
- Git

---

## 📁 Folder Structure

```
Spring-Boot-Playground/
├── .mvn/                       # Maven wrapper files
├── src/                        # Main application source code
│   └── main/
│       ├── java/
│       │   └── org/webstruct/...
│       └── resources/
│           ├── application.yml            # Base config (selects active profile)
│           ├── application-local.yml      # Local environment config
│           ├── application-dev.yml        # Dev environment config (ignored)
│           └── application-prod.yml       # Prod environment config (ignored)
├── target/                     # Compiled artifacts and build output (ignored)
├── Dockerfile                  # Multi-stage Docker build file
├── docker-compose.local.yml    # Docker Compose config for local development
├── docker-compose.dev.yml      # Docker Compose config for development deployment (ignored)
├── docker-compose.prod.yml     # Docker Compose config for production deployment (ignored)
├── BuildRunDockerLocal.sh      # Script to build and run image locally
├── BuildPushDockerDev.sh       # Script to build and push the dev image to GitHub Container Registry (ignored)
├── BuildPushDockerProd.sh      # Script to build and push the prod image to GitHub Container Registry (ignored)
└── pom.xml                     # Maven project and dependency management
```

---

## 🛠️ Configuration Files

This project uses several YAML files to configure different environments:  
(Only the **`local`** files are included, create **`dev`**, **`prod`** and/or any other environment as needed)

- **`application.yml`**  
  Sets the base configuration, such as the application name and the active profile (default: `local`).

- **`application-local.yml`**  
  Contains settings for local development—for example, setting the server port to 8080.

- **`application-dev.yml`**  
  Contains settings specific to the development environment.

- **`application-prod.yml`**  
  Contains production-specific settings.

*Some of these files are excluded from version control (via `.gitignore`) to prevent accidental commits of personal or sensitive configuration details.*

---

## 🐳 Docker & Deployment Setup

Docker is used to containerize the Spring Boot application, making it easier to manage deployments across different environments.  
(Only the **`local`** files are included, create **`dev`**, **`prod`** and/or any other environment as needed)

### 🧪 Local Development

- **Dockerfile Overview:**  

  The Dockerfile employs a multi-stage build:
    1. **Build Stage:**
        - Uses the Maven image (`maven:3.9.9-amazoncorretto-21`) to resolve dependencies and package the application.
    2. **Runtime Stage:**
        - Uses the Amazon Corretto runtime (`amazoncorretto:21.0.6-al2-generic`) to run the packaged JAR.


- **Local Docker Compose:**  
  `docker-compose.local.yml` configures local development, enabling hot-reload by volume-mounting the source code.


- **Local Script:**  
  `BuildRunDockerLocal.sh` automates:
    - Stopping and removing any existing container
    - Removing the previous local image
    - Rebuilding the image (`spring-boot-playground:local`)
    - Starting the container via Docker Compose


- **To only build the application locally, execute the following:**
  ```bash
    sh BuildDockerLocal.sh
  ```

- **To only run the application locally, use the following command:**
  ```bash
    docker-compose -f docker-compose.local.yml up
  ```

- **To both build and run the application together locally, execute the following:**
  ```bash
    sh BuildRunDockerLocal.sh
  ```

### 🚧 Development Deployment

- **Development Script:**

  - `BuildPushDockerDev.sh` ensures you are on the `dev` branch, pulls the latest code,  
  builds a Docker image tagged as `ghcr.io/<GitHub Username>/spring-boot-playground:dev`,  
  and pushes the image to GitHub Container Registry.
      ```bash
        sh BuildPushDockerDev.sh
      ```

- **Dev Docker Compose:**  
  
  - `docker-compose.dev.yml` runs the container with the `dev` profile activated.
    ```bash
      docker compose -f docker-compose.dev.yml up -d
    ```

### 🚀 Production Deployment

- **Production Script:**

  - `BuildPushDockerProd.sh` checks out the production branch (e.g., `master`),  
  pulls the latest code, builds a version-tagged Docker image (e.g., `v1.0.0`),  
  and pushes it to GitHub Container Registry.
    ```bash
      sh BuildPushDockerProd.sh
    ```

- **Prod Docker Compose:**
  - `docker-compose.prod.yml` configures the container for production, including an auto-restart policy.
    ```bash
      docker compose -f docker-compose.prod.yml up -d
    ```
---
> **Warning**  
> Always verify production images:  
> `docker scan ghcr.io/<GitHub Username>/spring-boot-playground:v1.0.0`
---

## 🤖 Automation Scripts

This repository includes several scripts to ease the development and deployment process:  
(Only the **`local`** files are included, create **`dev`**, **`prod`** and/or any other environment as needed)

1. **BuildDockerLocal.sh (Build)**  
   *Purpose:*
    - Automatically stops any existing container, removes outdated images, and rebuilds the local Docker image.

2. **BuildRunDockerLocal.sh (Build and Run)**  
   *Purpose:*
    - Automatically stops any existing container, removes outdated images, rebuilds the local Docker image, and runs the container with hot-reload enabled.

3. **BuildPushDockerDev.sh (Build and Push) [Dev]**  
   *Purpose:*
    - Checks out the `dev` branch, updates the repository, builds the Docker image for development, and pushes it to the GitHub Container Registry.

4. **BuildPushDockerProd.sh (Build and Push) [Prod]**  
   *Purpose:*
    - Checks out the production branch (e.g., `master`), pulls the latest changes, builds a version-tagged Docker image, and pushes it to the GitHub Container Registry.

---

## 📄️ Creating & Using Ignored Files

**Why are these files ignored?**  
Environment-specific configuration files often contain custom settings or sensitive data that should not be in the public repository.  
This allows each developer or environment (local, dev, prod) to maintain their own version.

**How to create them if they are missing:**

1. **Manual Creation:**
   Create `application-dev.yml`, `application-prod.yml`, `docker-compose.dev.yml`, `docker-compose.prod.yml`, `BuildPushDockerDev.sh`, and `BuildPushDockerProd.sh` with the sample content below:

   **Example for `application-dev.yml`:**
   ```yaml
   server:
     port: 8080
   ```

   **Example for `application-prod.yml`:**
   ```yaml
   server:
     port: 8080
   ```
   
   **Example for `docker-compose.dev.yml`:**
   ```yaml
   services:
     app:
     image: ghcr.io/<GitHub Username>/spring-boot-playground:dev # Use dev tag
     environment:
       - SPRING_PROFILES_ACTIVE=dev
     ports:
       - "8080:8080"
     ```
   
   **Example for `docker-compose.prod.yml`:**
   ```yaml
   services:
     app:
     image: ghcr.io/<GitHub Username>/spring-boot-playground:v1.0.0  # Use version tag
     environment:
       - SPRING_PROFILES_ACTIVE=prod
     ports:
       - "8080:8080"
     restart: always  # Auto-restart if the app crashes
   ```
   
    **Example for `BuildPushDockerDev.sh`:**
    ```bash
    #!/usr/bin/env bash
    
    GITHUB_USER="<GitHub Username>"
    IMAGE_NAME="ghcr.io/$GITHUB_USER/spring-boot-playground:dev"
    
    # Ensure you're on the dev branch (e.g., "dev")
    git checkout dev
    git pull origin dev
    
    # Build the Docker image
    echo "🔨 Building dev image..."
    docker build -t $IMAGE_NAME .
    
    # Push to GitHub Container Registry
    echo "📤 Pushing to GitHub Container Registry..."
    docker push $IMAGE_NAME
    
    echo "✅ Done! Dev image pushed: $IMAGE_NAME"
    ```

    **Example for `BuildPushDockerProd.sh`:**
    ```bash
    #!/usr/bin/env bash
    
    GITHUB_USER="<GitHub Username>"
    VERSION="v1.0.0"
    IMAGE_NAME="ghcr.io/$GITHUB_USER/spring-boot-playground:$VERSION"
    
    # Ensure you're on the prod branch (e.g., "master")
    git checkout master
    git pull origin master
    
    # Build the Docker image
    echo "🔨 Building prod image..."
    docker build -t $IMAGE_NAME .
    
    # Push to GitHub Container Registry
    echo "📤 Pushing to GitHub Container Registry..."
    docker push $IMAGE_NAME
    
    echo "✅ Done! Prod image pushed: $IMAGE_NAME"
    ``` 


2. **Customization & Security:**  
   Adjust these files as necessary for your environment and ensure any sensitive data is either injected via environment variables or managed securely.

---

## 🚨 Troubleshooting

| **Common Issues**        | **Solutions**                                      |
|--------------------------|----------------------------------------------------|
| Port 8080 in use         | `sudo lsof -i :8080 && sudo kill -9 <PID>`         |
| Docker permission denied | `sudo usermod -aG docker $USER && newgrp docker`   |
| GHCR auth failure        | docker login ghcr.io -u USERNAME --password-stdin` | 


---

## 🤝 Contributing

Contributions are welcome! Feel free to fork the repository and submit pull requests. When making contributions, be careful to maintain the separation of environment-specific configurations as per the `.gitignore` settings.
1. Create feature branch from `develop`
2. Test changes locally:
    ```bash
    sh BuildRunDockerLocal.sh
    ```
3. Submit PR to `develop` branch
4. Maintainers review and merge
5. Production releases only from `main` branch

---

## 🔭 Further Exploration

- **Advanced Docker Networking:** Experiment with multi-container deployments, Docker networking, and volume management.
- **CI/CD Pipelines:** Consider integrating CI/CD platforms like GitHub Actions to automate your build and deployment processes.
- **Enhanced Environment Management:** Look into secrets management or dynamic configuration injection for improved security and flexibility.

---

Happy coding and experimentation!