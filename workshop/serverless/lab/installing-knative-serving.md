# Installing Knative Serving

To install Knative Serving, run the following commands

```text
## CREATE NAMESPACE
$ oc create namespace knative-serving

## CREATE KNATIVE SERVING RESOURCES
$ cat <<EOF | oc apply -f -
apiVersion: operator.knative.dev/v1alpha1
kind: KnativeServing
metadata:
    name: knative-serving
    namespace: knative-serving
EOF
```

Verify the installation is complete

```text
$ oc get knativeserving.operator.knative.dev/knative-serving -n knative-serving --template='{{range .status.conditions}}{{printf "%s=%s\n" .type .status}}{{end}}'

DependenciesInstalled=True
DeploymentsAvailable=True
InstallSucceeded=True
Ready=True
```



