## aws cicd pipeline with docker and jenkins

For this project you will need:

- [x] github account (setup details below)
- [x] shell account to commit code
- [x] aws account or [signup for a free usage tier account with aws](https://aws.amazon.com/free/)

1. ### create an aws account

   1. #### configure aws-cli:

create an `~/.aws/credentials` file:
```bash
# SECURITY WARNING: FILE CONTAINS SENSITIVE INFORMATION
#  + ensure permissions are secure (not world read or write)
#  + do not use shared accounts, names or passwords
#  + always use strong encryption and complex passwords
#  + regularly change passwords and store them securely

# [default]
# aws_access_key_id = <aws_access_key_id>
# aws_secret_access_key = <aws_access_key>

[aws-docker-cicd-admin]
aws_access_key_id =  <aws_access_key_id>
aws_secret_access_key = <aws_access_key>
```

### setting up ssh

### github

[signup for an account with github](https://help.github.com/articles/signing-up-for-a-new-github-account/)<br>
[create a repository to use for the repo](https://help.github.com/articles/create-a-repo/)<br>


***generate a public/private keypair***
```
ssh-keygen -t rsa -b 2048 ~/.ssh/<github_project>-private-key.pem
```

[generating new keys and adding to ssh-agent](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) (optional)

[***provice read write access to the github repository***](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)


### configure git

populate `~/.gitconfig`

```bash
[credential]
        helper = !aws codecommit credential-helper $@
        UseHttpPath = true
[user]
        email = <commit_user_email>
        name  = <commit_user>
```

setup ssh profiles usig `~/.ssh/config`:

```bash
Host github.com/<github_account>
  HostName github.com
  User git
  IdentityFile ~/.ssh/<github_project>-private-key.pem

Host git-codecommit.*.amazonaws.com
  User <aws_access_key_id>
  IdentityFile ~/.ssh/<aws_project>-private_key.pem
```

### testing your setup

testing your connection to github
```
ssh -T git@github.com
```

[testing your git connection](https://help.github.com/articles/testing-your-ssh-connection/)<br>
