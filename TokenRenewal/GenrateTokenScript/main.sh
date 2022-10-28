#Use bash to run this script for better view from your local machine
#Please run script from directory where you have all keys_* files available
K8s_CONTEXT=$(kubectl config current-context)
echo "current k8s conext: ${K8s_CONTEXT}"
echo "##Please make sure you are in correct ENV of k8s If not please change context## "
echo -n "Please Enter Namespace|Cluster Name: "; read CLUSTER
cat <<EOF >devops.yaml
apiVersion: v1
kind: Pod
metadata:
  name: devops
  namespace: $CLUSTER
spec:
  securityContext:
    runAsUser: 1000
  containers:
  - image: devops-general
    command:
      - /bin/sh
      - "-c"
      - "sleep 60m"
    imagePullPolicy: IfNotPresent
    name: debug
  restartPolicy: Always
EOF

kubectl apply -f devops.yaml
echo "Waiting for 100 second due to pod creation"
sleep 100
kubectl get pods -n=$CLUSTER | grep -i devops
for KEY_FILE in $(ls keys_*)
do
  kubectl cp $KEY_FILE optima/devops:/home/DevOps/$KEY_FILE
done
kubectl exec -it devops -n=${CLUSTER}  -- /bin/bash -c "bash /home/DevOps/generateTokenScript.sh"
kubectl delete pods devops -n=${CLUSTER}