# Building the example serverless application

## 1. Build the container image

To build the container image, you can use docker build

```text
$ export DOCKER_USERNAME=your-docker-hub-username
$ docker build -t $DOCKER_USERNAME/serverless-workshop-example:1.0 bank-knative-service
```

## 2. Push the container image

In this lab, you can use a Docker Hub to push your container image. Make sure you are also logged in your Docker Hub account when you push the image.

```text
$ docker login
$ docker push $DOCKER_USERNAME/serverless-workshop-example:1.0
```

