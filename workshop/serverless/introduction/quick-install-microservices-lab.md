# Quick Install - Identity Management, Operator, Microservices Workshops

Clone the repo **example-bank** if you haven't yet

```text
$ git clone https://github.com/IBM/example-bank
$ cd example-bank/scripts
```

Log in your IBM Cloud account with the `ibmcloud` cli

```text
$ ibmcloud login -u YOUR_IBM_CLOUD_EMAIL
```

Create an App ID instance using the script.

```text
$ ./createappid.sh

App ID instance created and configured
Management server: https://**.appid.cloud.ibm.com/management/v4/**
Api key:           YOUR_API_KEY
Auto-generated
appid-example-bank-credentials
```

Then export the App ID instance's management server and the API key.

```text
$ export MGMTEP=https://**.appid.cloud.ibm.com/management/v4/**
$ export APIKEY=YOUR_API_KEY
```

Log in with the OpenShift cluster provided for you using the OpenShift console

![OpenShift Console](../../.gitbook/generic/image%20%283%29.png)

Create a project called example-bank

```text
$ oc new-project example-bank
```

Deploy a Postgres instance in your OpenShift cluster

```text
$ ./deploy-db.sh

clusterserviceversion.operators.coreos.com/postgresql-operator.v0.1.1 created
subscription.operators.coreos.com/postgresql-operator-dev4devs-com created
operatorgroup.operators.coreos.com/example-bank-rgc7j unchanged
deployment.apps/postgresql-operator created
database.postgresql.dev4devs.com/creditdb created
```

{% hint style="info" %}
Make sure the **database.postgresql.dev4devs.com/creditdb** was deployed. If not, deploy it manually using the yaml file

```text
$ oc apply -f creditdb.yaml
```
{% endhint %}

Create secrets using the script below. This creates the necessary secrets in your OpenShift cluster

```text
$ ./createsecrets.sh $MGMTEP $APIKEY
```

Deploy a job that sets the schema for your database.

```text
$ cd ..
$ oc apply -f data_model/job.yaml
```

Deploy components from previous labs with prebuilt container images

```text
$ oc apply -f deployment.yaml -f bank-app-backend/user-service/deployment.yaml -f bank-app-backend/transaction-service/deployment.yaml
```



