Example NGINX+Node.js application stack deployable with Docker, and to AWS ECS using Docker.  The stack is described using Docker Compose files.

The contents are:

* `app` - Extremely simple Node.js HTTP service that listens on port 3000
* `nginx` - Extremely simple NGINX server configured as an HTTP proxy to a back-end service on port 3000
* `local` - A Docker Compose file for launching the two services on the local machine
* `ecs-simple` - A simple deployment of the stack to AWS ECS using a `docker-compose.yml` and `ecs-params.yml`
    * `nginx-ecs-simple` - The version of the `nginx` service to be used in the `ecs-simple` scenario
* `ecs-service-discovery` - A two-service deployment to AWS ECS meant to explore how Service Discovery works
    * `backend` - An implementation of the `app` service as an ECS Service, defined using a Docker Compose file
    * `frontend` - An implementation of the `nginx` service as an ECS Service, defined using a Docker Compose file
    * `nginx-ecs-service-discovery` The version of the `nginx` service to be used on ECS

The `ecs-simple` case is a simple AWS ECS Fargate cluster containing the two services.

The `ecs-service-discovery` is an attempt to deploy `app` and `nginx` as two separate services on ECS, and to have `nginx` find `app` using Service Discovery.  Unfortunately this example does not yet work.

For tutorials on using these containers, see:

* [A simple multi-tier Node.js and Nginx deployment using Docker](https://techsparx.com/nodejs/docker/simple-node-docker-app.html)
* [Deploying a simple multi-tier Node.js and Nginx deployment to AWS ECS](https://techsparx.com/nodejs/docker/simple-node-deploy-aws-ecs.html)
