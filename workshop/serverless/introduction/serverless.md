# Serverless

Serverless is a model that allows you to build and run applications so when an event-trigger occurs, the application will automatically scale up based on incoming demand, or scale to zero after use.

OpenShift Serverless on OpenShift Container Platform enables stateless serverless workloads to all run on a single multi-cloud container platform with automated operations. Developers can use a single platform for hosting their microservices, legacy, and serverless applications.

OpenShift Serverless is based on the open source **Knative project**.

## Knative Serving

Knative Serving on OpenShift Container Platform enables developers to write [cloud-native applications](https://www.redhat.com/en/topics/cloud-native-apps) using [serverless architecture](https://www.redhat.com/en/topics/cloud-native-apps/what-is-serverless). These routine tasks are abstracted away by the platform, allowing developers to push code to production much faster than in traditional models.

The Knative Serving project provides middleware primitives that enable:

* Rapid deployment of serverless containers
* Automatic scaling up and down to zero
* Routing and network programming
* Point-in-time snapshots of deployed code and configurations

Knative Serving CRDs:

Service, Revision, Route, Configuration

![knative.dev/docs](../../.gitbook/generic/image%20%284%29.png)

## Knative Eventing

Knative Eventing on OpenShift Container Platform enables developers to use an [event-driven architecture](https://www.redhat.com/en/topics/integration/what-is-event-driven-architecture) with serverless applications. An event-driven architecture is based on the concept of decoupled relationships between event producers that create events, and event _sinks_, or consumers, that receive them.

Knative Eventing uses standard HTTP POST requests to send and receive events between event producers and consumers. These events conform to the [CloudEvents specifications](https://cloudevents.io/), which enables creating, parsing, sending, and receiving events in any programming language.





