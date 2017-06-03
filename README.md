## aws cicd pipeline with docker and jenkins

## create an aws account

### configure aws-cli:

create an `~/.aws/credentials` file with the following:

***WARNING THIS FILE CONTAINS SENSITIVE INFORMATION**
please ensure permissions are secure
avoid the use of shared accounts, passwords
strong encryption and complex passwords should be used
for more inforamtion on how to protect your privacy:
****************************************************

```
# [default]
# aws_access_key_id = <aws_access_key_id>
# aws_secret_access_key = <aws_access_key>

[aws-docker-cicd-admin]
aws_access_key_id =  <aws_access_key_id>
aws_secret_access_key = <aws_access_key>
```

create a github account: [https://github.com/join]
create a repository for the project: 

## provice read write access to the repository

## generating a public/private keypair
```
ssh-keygen -t rsa -b 2048 ~/.ssh/<github_project>-private-key.pem

```


### configure ssh
Host github-aws-cicd-pipeline
  HostName github.com
  User git
  IdentityFile ~/.ssh/<github_project>-private-key.pem

Host aws_codecommit
  HostName git-codecommit.*.amazonaws.com
  User <aws_access_key_id>
  IdentityFile ~/.ssh/<aws_project>-private_key.pem

