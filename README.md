
## aws cicd pipeline with docker and jenkins
   
1. ### requirements

   For this project you will need:
   
   - [x] github account (setup details below)
   - [x] shell account to commit code
   - [x] aws account or [signup for a free usage tier account with aws](https://aws.amazon.com/free/)
   
1. ### create an aws account

   1. login to the account console
   1. create an account and generate an access key to provide jenkins management access
      1. how to create an account using aws
      1. how to create an access key
   1. obtain the account credientials
      1. `<aws_access_key_id>`
      1. `<aws_secret_access_key>`

1. ### configure aws-cli:

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
   
1. ### github

   1. [signup for an account with github](https://help.github.com/articles/signing-up-for-a-new-github-account/)<br>
   1. [create a repository to use for the repo](https://help.github.com/articles/create-a-repo/)<br>


1. ### create a secure private key and grant acceess to your repository

   1. export env variables to use with the commands below
      ```bash
      export github_profject=cicd-admin--docker-jenkins-aws
      ```
   1. generate a public/private keypair
      ```bash
      ssh-keygen -t rsa -b 2048 -f ~/.ssh/${github_project}-private-key -N ""
      ```
      - **note** the `-N ""` above will revent the passphrase prompt from appearing
   1. ensure correct permissions
      ```bash
      chmod 600 ~/.ssh/${github_project}-private-key
      chown $(whoami):$(whoami) ~/.ssh/${github_project}-private-key
      ```
   1. [provide access to your github repository](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)
   
      **Optional** [***adding your private key to your ssh-agent***](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)


1. ### configure git

   populate `~/.gitconfig`
   
   ```bash
   [credential]
           helper = !aws codecommit credential-helper $@
           UseHttpPath = true
   [user]
           email = <commit_user_email>
           name  = <commit_user>
   ```
   
1. ### create a ssh profile
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

1. ### testing your setup

   testing your connection to github
   ```bash
   ssh -T git@github.com
   ```
   more info visit: [testing your git connection](https://help.github.com/articles/testing-your-ssh-connection/)<br>
