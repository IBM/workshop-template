Steps

    Install OpenShift Serverless Operator
    Install CouchDB Events Source
    Create a CouchDB and an Event Source
    Build the sample Node.js serverless application
    Deploy the serverless application
    Install the broker and triggers
    Make changes to the database

1. Install OpenShift Serverless Operator

You can install the OpenShift Serverless Operator by using the OperatorHub in your OpenShift dashboard. Use Update Channel version 4.5.

Screen capture of finding the Serverless Operator in the OperatorHub

Screen capture of the Create Operator Subscription panel

This tutorial is using Knative Serving and Eventing. You can run stateless serverless service with Knative Serving. To subscribe to event sources, you need Knative Eventing.

To install Knative Serving

$ oc create namespace knative-serving
$ oc apply -f knative-serving.yaml

Make sure that the status of Knative Serving is ready, which might take a few minutes.

$ oc get knativeserving.operator.knative.dev/knative-serving -n knative-serving --template='{{range .status.conditions}}{{printf "%s=%s\n" .type .status}}{{end}}'

DependenciesInstalled=True
DeploymentsAvailable=True
InstallSucceeded=True
Ready=True

Proceed to installing Knative Eventing.

$ oc create namespace knative-eventing
$ oc apply -f knative-eventing.yaml

Make sure that the status of Knative Eventing is ready, which might take a few minutes.

$ oc get knativeeventing.operator.knative.dev/knative-eventing \
  -n knative-eventing \
  --template='{{range .status.conditions}}{{printf "%s=%s\n" .type .status}}{{end}}'


InstallSucceeded=True
Ready=True

2. Install CouchDB Events Source

Install CouchDB Events Source to allow the serverless platform to listen for changes in a CouchDB database.

$ oc apply -f https://github.com/knative/eventing-contrib/releases/download/v0.15.1/couchdb.yaml

3. Create a CouchDB and an Event Source

Create a CouchDB deployment in your cluster by using the yaml file provided in the repo.

$ oc apply -f couchdb-deployment.yaml

Next, you create an example database in CouchDB. You must expose the database for this tutorial to access it in your environment.

$ oc expose svc/couchdb

$ oc get routes
NAME      HOST/PORT                   PATH   SERVICES   PORT   TERMINATION   WILDCARD
couchdb   couchdb-default.***.cloud          couchdb    5984                 None

Access your couchdb deployment in /_utils path of your route (for example, couchdb-default.***.cloud/_utils). Username and password are admin and password.

For this tutorial, create a database called users. Choose Non-partitioned for the partitioning option.

Screen capture of Create Database panel in CouchDB

You can now create a CouchDB event source with the users database. Create a secret for the credentials and create the source by using the provided yaml files.

$ oc apply -f couchdb-secret.yaml
$ oc apply -f couchdb-source.yaml

4. Build the sample Node.js serverless application

The repo provides the source code for the sample Node.js serverless application. You can choose to build it and push it to Docker Hub.

    You can also skip this step and use the image that is provided in serverless-app.yaml.

To build it, you can choose to build it using docker or podman.

$ docker build -t <image-name> .
$ docker push <image-name>

Then, change the image name with yours in serverless-app.yaml.

The application uses the CloudEvents SDK to read events from OpenShift serverless event sources. CloudEvents is a specification for describing event data in a common way to provide interoperability across services, platforms, and systems. The CloudEvents SDK for JavaScript is in the cloudevents/sdk-javascript GitHub repo.
5. Deploy the serverless application

You can now deploy the sample application. This is your Knative Serving Service (usually called Knative service).

$ oc apply -f serverless-app.yaml

You can check the deployment status by using the following commands. Check that the Ready state is True.

$ oc get ksvc
NAME                      URL                                                        LATESTCREATED                   LATESTREADY                     READY   REASON
process-deleted-user      http://process-deleted-user.default.svc.cluster.local      process-deleted-user-4sg8s      process-deleted-user-4sg8s      True    
process-registered-user   http://process-registered-user.default.svc.cluster.local   process-registered-user-j2b82   process-registered-user-j2b82   True    

There should be two Knative services that are deployed with the same application for demo purposes later in the tutorial.
6. Install the broker and triggers

The broker and triggers are both custom resources from OpenShift Serverless. The broker represents an event mesh where it can receive events from a source. The broker then sends the events to the subscribers, which are called triggers. Triggers are configured to subscribe to a broker.

To install the broker in OpenShift Serverless, you must create service accounts to make sure that the broker has sufficient permissions. Create the serviceaccount by using the following commands.

$ oc -n default create serviceaccount eventing-broker-ingress
$ oc -n default create serviceaccount eventing-broker-filter

Create the role bindings to the service accounts.

$ oc -n default create rolebinding eventing-broker-ingress \
  --clusterrole=eventing-broker-ingress \
  --serviceaccount=default:eventing-broker-ingress
$ oc -n default create rolebinding eventing-broker-filter \
  --clusterrole=eventing-broker-filter \
  --serviceaccount=default:eventing-broker-filter

Then, you can install the broker.

$ oc apply -f broker.yaml

Install the triggers.

$ oc apply -f triggers.yaml

If you look at the triggers.yaml file, the two triggers are filtered to subscribe to the specific CloudEvent types of org.apache.couchdb.document.update and org.apache.couchdb.document.delete. The first part of the yaml file sends the event to the process-registered-user Knative service when a document is added or updated. The second part sends the event to the process-deleted-user Knative service, which is deployed when a document is deleted.
7. Make changes to the database

Now you can check the status of your pods. Your serverless applications should have scaled down to zero by now. To watch the pods, you can use the following command.

$ oc get pods -w

Your serverless applications run whenever you make changes to the database as you configured in the previous step with triggers.yaml

Now go back to the CouchDB dashboard (couchdb-default.***.cloud/_utils) and add a document in users database with any JSON content.

Screen capture of adding a document in CouchDB

If you go back to the terminal where you executed the watch pods command, you see that your process-registered-user serverless app ran because of the update event in your serverless platform.

$ oc get pods -w
NAME                                                              READY   STATUS    RESTARTS   AGE
couchdb-7f88bf6d65-snfr4                                          1/1     Running   0          44h
couchdbsource-couchdb-tran-f95d5c21-5e67-47b5-adc4-65228d5cdbr8   1/1     Running   0          28s
default-broker-filter-b5967fd6c-k4tlw                             1/1     Running   0          4m29s
default-broker-ingress-558585dc6c-nbbtp                           1/1     Running   0          4m29s
process-registered-user-j2b82-deployment-78569d5444-hmp6h         0/2     Pending   0          0s
process-registered-user-j2b82-deployment-78569d5444-hmp6h         0/2     Pending   0          0s
process-registered-user-j2b82-deployment-78569d5444-hmp6h         0/2     ContainerCreating   0          0s
process-registered-user-j2b82-deployment-78569d5444-hmp6h         0/2     ContainerCreating   0          2s
process-registered-user-j2b82-deployment-78569d5444-hmp6h         0/2     ContainerCreating   0          2s
process-registered-user-j2b82-deployment-78569d5444-hmp6h         1/2     Running             0          4s
process-registered-user-j2b82-deployment-78569d5444-hmp6h         2/2     Running             0          4s

After a while, it should scale back down to zero. If you delete the document that you just created, you should see the other serverless app, process-deleted-user, ran.
