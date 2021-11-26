# OpenShift Pipelines demo (tekton)

This is a demo project to show OpenShift Pipelines

Follow those steps:

0) create helloservlet project

oc new-project helloservlet

1) create integration project

oc new-project integration

2) use helloservlet project

oc project helloservlet

3) Grant pipeline edit role in integration project

 oc apply -f helloservlet-rolebinding-edit-from-pipeline.yaml

4) Grant integration project the permission to access helloservlet images

 oc apply -f helloservlet-rolebinding-allow-pull-from-integration.yaml

5) create a secret that points to quay (avoid to include dots in the name!)

oc create secret docker-registry <pull_secret_name> --docker-server=<registry_server> --docker-username=<user_name> --docker-password=<password>

6) update the pipelines serviceaccount in helloservlet in order to include the secret just created in the 'secrets:' and 'imagePullSecrets:'

7) Create pipelines

oc apply -f helloservlet-pipelines.yaml

8) Create trigger

oc apply -f helloservlet-trigger.yaml

9) Configure github webhook as 

payload url: 'http://el-listener-helloservlet.<OCP_DOMAIN>'

content type: application/json

secret: <secret_defined_in_helloservlet-trigger.yaml>

event: just push event

10) Enjoy!

Please note, the helloservlet configmap in helloservlet project can be customized to change internal image registry or public image registry.
