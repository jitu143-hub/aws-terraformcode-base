#command to get the initial password of argocd
1. kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

2. login to argocd
3. User name as admin and password is output of step 1.
4. once logged in go to settings and add repositories
5. click new app > edit as yaml
6. add content from argo-app > techapp-argo.yaml file and save.
7. application will be added. Please sync to deploy the application techapp.
8. Browse the application endpoint and check.