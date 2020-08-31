# Configure Deployment file

## Verify deployment file

Open **bank-knative-service/deployment.yaml** file

* Make sure the **image** name is correct. It's the one you built on the previous step, [Building the example serverless application](building-the-example-serverless-application.md)

```text
containers:
  - image: <YOUR_DOCKER_HUB>/serverless-workshop-example:1.0
```

The environment variables below does not need to change. The secret `bank-oidc-adminuser` that you created will be used by this serverless app. The secret `mobile-simulator-secrets` was created during the previous labs. The environment variable `TRANSACTION_SERVICE_URL` points to the transaction microservice from the previous lab as well.

```text
envFrom:
  - secretRef:
    name: bank-oidc-adminuser
  - secretRef:
    name: mobile-simulator-secrets
env:
  - name: TRANSACTION_SERVICE_URL
    value: "http://transaction-service:9080/bank/v1/transactions"
```



