## aws cicd pipeline with docker and jenkins

For this project you will need:

1. a github account (setup details below)
2. a shell account to commit code
3. a [free usage tier account with aws](https://aws.amazon.com/free/)

### create an aws account

#### configure aws-cli:

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

- [signup for an account with github](https://help.github.com/articles/signing-up-for-a-new-github-account/)
- [create a repository to use for the repo](https://help.github.com/articles/create-a-repo/)]


1. generate a public/private keypair
```
ssh-keygen -t rsa -b 2048 ~/.ssh/<github_project>-private-key.pem
```

[generating new keys and adding to ssh-agent](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

2. [provice read write access to the repository]


### configure git

1. populate `~/.gitconfig`
```bash
[credential]
        helper = !aws codecommit credential-helper $@
        UseHttpPath = true
[user]
        email = <commit_user_email>
        name  = <commit_user>
```

2. setup ssh profiles usig `~/.ssh/config`:
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

1. testing your connection to github
```
ssh -T git@github.com
```

[testing your git connection](https://help.github.com/articles/testing-your-ssh-connection/)<br>
