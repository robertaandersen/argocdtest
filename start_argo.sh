kubectl config set-context --current --namespace=argocd
kubectl create namespace argocd
yes | kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 5

kubectl port-forward svc/argocd-server -n argocd 8080:443 &
kubectl port-forward deployment/argocd-server 8091:8080 &

sleep 5

pass=$(argocd admin initial-password -n argocd | head -n 1)

argocd login localhost:8080 --password $pass --username admin
yes | argocd cluster add docker-desktop --name docker-dekstop --in-cluster

open http://localhost:8091/

echo "ArgoCD is running on http://localhost:8091/"
echo "ArgoCD username:admin password: $pass"

#argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
