# tektondemo

oc apply -f helloservlet-pipelines.yaml

create a secret that point to quay (avoid to include dots in the name!)

update the pipelines serviceaccount in order to include the secret just created in the 'secrets:' and 'imagePullSecrets:'

oc apply -f helloservlet-trigger.yaml

remember to allow pull policy from integration project:

oc project helloservlet
oc policy add-role-to-user system:image-puller system:serviceaccount:integration:default --namespace=helloservlet