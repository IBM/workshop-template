# Clone the repo

Clone the repo **example-bank** if you haven't yet

```
$ git clone https://github.com/IBM/example-bank
$ cd example-bank
```

The source code for this lab is under **bank-knative-service** folder



Create a project named **example-bank** for the resources you'll deploy.

{% hint style="info" %}
You can skip this step if you already have created one from the previous labs.
{% endhint %}

```text
$ oc new-project example-bank
```

Also, make sure you are using the **example-bank** project

```text
$ oc project example-bank
```

