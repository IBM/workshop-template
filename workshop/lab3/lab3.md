
![Example Bank diagram](images/pattern-flow-diag.png)

The back end of Example Bank is what this tutorial deploys through a pipeline. It consists of several microservices, including two Java services to process transactions and users respectively, a Node.js front end, and a PostgreSQL instance to keep track of it all.

### 0.

Agenda:

1. Intro to OpenShift / microservices.
2. Demo Example Bank app 
3. Go over architecture of the app.
4. Set up OpenShift project and required services.
5. Build and deploy your own instance of Example Bank

Intro:
- Demo credit-card.ibmdeveloper.net. (2 min).
- architecture app id and back-end (2 min).

Mention these (not actually done during lab.)
1. Get cluster: Follow instructions.  (Common for all labs.)
2. Create Docker Hub profile for images. (Prereq.)
3. Get oc login token to log into cluster via CLI.

Start:
Log in into cognitiveclass.ai - and create shell.

1. IBM login for user account - for App Id.

- AppId: Run `createappid.sh`
  - save: App ID info:

  ```
        Management server: https://us-south.appid.cloud.ibm.com/management/v4/6f83b8fb-28e2-48e6-9dc4-dada122d99c7
        Api key:           fpYOiyM-48eR72LsKpmc3TL2WnrrntrOeLYfuCc9PjDI
    ```

In browser, go to your OpenShift cluster and get token.  Talk about how you don't need to switch logins in the CLI.
Login to cluster in your web terminal.

- Create `example-bank` project if not there. 
 .. show `oc new-project example-bank` or `oc project example-bank`.

- PostgresDB:  Run `deploy-db.sh`: deploys operator and database instance for Example Bank.

- Secrets: `createsecrets.sh`:
```
  koyfman@cloudshell:~/bank/example-bank/scripts$ sh ./createsecrets.sh https://us-south.appid.cloud.ibm.com/management/v4/6f83b8fb-28e2-48e6-9dc4-dada122d99c7 fpYOiyM-48eR72LsKpmc3TL2WnrrntrOeLYfuCc9PjDI
```
Deploy microservices:
1. Build docker images and push to your personal Docker Hub account.

```
   docker build -t ykoyfman/lab-ui-1 .
   cd data_model
   docker build -t ykoyfman/lab-data-1 .
   cd ../bank-app-backend/
   mvn -pl :user-service -am package
   docker build -t ykoyfman/lab-tx-1 transaction-service
   docker build -t ykoyfman/lab-user-1 user-service
   cd ../bank-user-cleanup-utility
   mvn package
   docker build -t ykoyfman/lab-cleanup-1 .
   docker login
   docker push <all images>
```
---- break here - handoff to second person ----

2. Update YAML deployment manifests to point at correct images - five files.

3. Run database schema job.
```
    cd data_model
    oc apply -f job.yaml
```

Output: 
```
theia@theiadocker-koyfman1:/home/project/example-bank/data_model$ oc get pods
NAME                                   READY   STATUS              RESTARTS   AGE
cc-schema-load-9tz6f                   0/1     ContainerCreating   0          5s
creditdb-77c6b6785d-vnxtv              1/1     Running             1          98m
postgresql-operator-58cb79c899-69qpn   1/1     Running             0          98m
theia@theiadocker-koyfman1:/home/project/example-bank/data_model$ oc get pods
NAME                                   READY   STATUS      RESTARTS   AGE
cc-schema-load-9tz6f                   0/1     Completed   0          42s
creditdb-77c6b6785d-vnxtv              1/1     Running     1          99m
postgresql-operator-58cb79c899-69qpn   1/1     Running     0          99m
theia@theiadocker-koyfman1:/home/project/example-bank/data_model$ oc logs cc-schema-load-9tz6f
CREATE EXTENSION
CREATE DATABASE
You are now connected to database "example" as user "postgres".
CREATE SCHEMA
SET
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
```
```
 oc apply -f deployment.yaml -f bank-app-backend/user-service/deployment.yaml -f bank-app-backend/transaction-service/deployment.yaml 
```

Find route to access simulator:

```
theia@theiadocker-koyfman1:/home/project/example-bank$ oc get routes
NAME                       HOST/PORT                                                                                                                          PATH   SERVICES                   PORT    TERMINATION   WILDCARD
mobile-simulator-service   mobile-simulator-service-example-bank.koyfman-os44-aug5-f2c6cdc6801be85fd188b09d006f13e3-0000.us-east.containers.appdomain.cloud 
```

## Summary

