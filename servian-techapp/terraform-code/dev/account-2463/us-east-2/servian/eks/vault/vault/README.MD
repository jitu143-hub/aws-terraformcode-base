# Vault Initial Configuration
## Run Below Commands

1. kubectl exec -it vault-0 /bin/sh -n vault

2. vault operator init
NOTE : Please copy Initial Root Token and Unseal Key 1 to 5

run below command 3 times and every time enter different unseal key 
3. vault operator unseal

4. Go to UI select method as "token" and token is Initial Root Token captured in step 2

5. After signin click on "Enable new Engine" > Select KV under generic > click "Next"

6. Enter path as "secret" > click on "Enable Engine"

7. Click on "Create secret" and Path for this secret as "techapp,dev"

8. Enter key as "dbusername" and "dbpassword" and provide values respectively.[Please note this user name and password as it is required during application creation to create secret]

9. Click save

10. run this command on terminal "export VAULT_TOKEN=<Initial Root Token from step 2>"