# tektondemo

oc apply -f helloservlet-pipelines.yaml

create a secret that point to quay (avoid to include dots in the name!)

update the pipelines serviceaccount in order to include the secret just created in the 'secrets:' and 'imagePullSecrets:'