# Create an admin scoped user

A user with an admin scope is required to access the API that rewards the transactions with points from the transactions microservice \(from the **microservices lab**\). You can create one from the App ID dashboard

## 1. Create a user

In this example, you can create a user with a username of `admintest` and a password of `password`. If you choose a different one, take note of it for later use.

![Creating a user using the App ID dashboard](https://github.com/IBM/example-bank/raw/main/images/loyalty-user-test.png)

## 2. Add the role to the user

To add a role, go to the section `Cloud Directory` &gt; `Users` and click on the + sign beside the "No roles assigned to user". Then choose the **admin.**

![Adding a role to the user you just created](https://github.com/IBM/example-bank/raw/main/images/loyalty-user-role.png)

![Choose admin role and save](https://github.com/IBM/example-bank/raw/main/images/loyalty-user-role-added.png)

## 3. Create a secret for the user with the admin scope

```
$ oc create secret generic bank-oidc-adminuser-workshop --from-literal=APP_ID_ADMIN_USER=<your-username> --from-literal=APP_ID_ADMIN_PASSWORD=<your-password>
```



