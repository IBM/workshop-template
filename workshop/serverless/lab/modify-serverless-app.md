# Modify Serverless App

## 1. Modify code

Modify the `function computeReward()` section in `bank-knative-service/index.js` file. Modify the code so that it returns different points rewarded based on a category.

```text
### index.js
function computeReward(category, amount) {
    if (category == "RIDE") {
        return 2 * amount
    }
    return amount;
}
```

## 2. Build and push container image

You can now build and push the container image with the updated code.

```text
$ docker build -t $DOCKER_USERNAME/serverless-workshop-example:2.0 bank-knative-service
$ docker push $DOCKER_USERNAME/serverless-workshop-example:2.0
```

## 3. Modify deployment file

Modify the deployment file in `bank-knative-service/deployment.yaml`.

Make sure the image name is the one you built in the previous step.

```text
      containers:
        - image: anthonyamanse/serverless-workshop-example:2.0
```

## 4. Deploy to OpenShift

You can now deploy the serverless app to openshift using `oc apply`

```text
$ oc apply -f bank-knative-service/deployment.yaml
```

Verify its status. **READY** should be **True**

```text
$ oc get ksvc
NAME                  URL                                                         LATESTCREATED               LATESTREADY                 READY   REASON
process-transaction   http://process-transaction.example-bank.svc.cluster.local   process-transaction-dh7kf   process-transaction-dh7kf   True    
```

## 5. Test using the simulator again

```text
$ oc get routes
NAME                       HOST/PORT             PATH   SERVICES                           PORT    TERMINATION   WILDCARD
mobile-simulator-service   ***.appdomain.cloud          mobile-simulator-service           <all>   edge          None
```



