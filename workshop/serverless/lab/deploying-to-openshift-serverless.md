# Deploying to OpenShift Serverless

## 1. Deploy the serverless application

```text
$ oc apply -f bank-knative-service/deployment.yaml
```

## 2. Check status

```text
$ oc get kservice # or kn service list - if you have kn cli installed
# NAME                  URL                                                         LATEST                      AGE   CONDITIONS   READY   REASON
# process-transaction   http://process-transaction.example-bank.svc.cluster.local   process-transaction-9chv6   34d   3 OK / 3     True
```

{% hint style="info" %}
 The serverless application can be reached at `http://process-transaction.example-bank.svc.cluster.local` in the example above. If it doesn't match with the one you deployed in the previous **microservices lab**[,](https://github.com/IBM/example-bank#user-and-transaction-services) fix the `KNATIVE_SERVICE_URL` value in the `bank-app-backend/transaction-service/deployment.yaml` file and redeploy it again with `oc apply`
{% endhint %}



