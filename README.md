

## aws cicd pipeline with docker, jenkins and github repo

how to run a cicd pipeline in aws with docker and jenkins

1. ### quick setup

   1. clone repo and install awscli tools
      ```bash
      git clone https://github.com/e-noodle/aws-cicd-pipeline.git
      sudo /bin/bash scripts/setup_awscli.sh
      ```
     1. [setup a github repository](#github)
     2. [generate-keys-for-the-project](#generate-keys-for-the-project)
     3. [grant access to your github repository](#grant-access-to-your-github-repository)
     4. [configure git](#configure-git)
     5. [create a ssh profile](#create-a-ssh-profile)
     6. [testing your setup](#testing-your-setup)
     7. [connecting to aws](#connecting-to-aws)
 

1. ### requirements

  you will need:
   
   - [x] github account [signup for an account with github](https://help.github.com/articles/signing-up-for-a-new-github-account/))
   - [x] a unix account with sudo privileges
      -  sign up for a free webbased development platform based on ubuntu at https://c9.io
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
       
   1. **option 1 - run setup script** *(use at your own risk)*
   
      download and run [aws cli setup script](scripts/setup_awscli.sh) to configure aws-cli
      
      example:
      the following example will create a profile called **`cicd-admin-aws`**
      ```
      curl -sL https://github.com/e-noodle/aws-cicd-pipeline/raw/master/scripts/setup_awscli.sh | bash /dev/stdin profile_name=cicd-admin-aws
      ```
   
   1. **option 2 - manual**

       1. install awscli
         
         ```bash
         # configure epel repository
         rpm -ivH http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm

         # install awscli
         yum --enablerepo=epel -y install awscli
         ```
         
      1. create `~/.aws` directory
         ```
         mkdir -p ~/.aws
         ```
      1. create a `~/.aws/credentials` file with the following replacing `${PROFILE_NAME}` with the name of your project.
         ```bash
         # SECURITY WARNING: FILE CONTAINS SENSITIVE INFORMATION
         #  + ensure permissions are secure (not world read or write)
         #  + do not use shared accounts, names or passwords
         #  + always use strong encryption and complex passwords
         #  + regularly change passwords and store them securely
         #
         #
         # [default]
         # aws_access_key_id = <aws_access_key_id>
         # aws_secret_access_key = <aws_access_key>
         
         [${PROFILE_NAME}]
         aws_access_key_id =  <cid_aws_access_key_id>
         aws_secret_access_key = <cicd_aws_access_key>
         ``` 
      1. create `/.aws/config` with the following, replacing `${PROFILE_NAME}` with the name of your project.
         ```bash
         [default]
         region = us-east-1
         output = json
         [${PROFILE_NAME}]
         output = json
         region = us-east-1
         ```
      1. set permissions
         ```bash
         chmod 600 ~/.aws/{credentials,config} 
         chown $(whoami):$(whoami) ~/.aws/{credentials,config}
         ```
      1. populate <aws_access_key_id>  and <aws_access_key> in ~/.aws/credentials with the account credentials.
      1. confirm the region settings provided in ~/.aws/config



1. ### github

   1. [signup for an account with github](https://help.github.com/articles/signing-up-for-a-new-github-account/)<br>
   1. [create a repository to use for the repo](https://help.github.com/articles/create-a-repo/)<br>




1. ### generate keys for the project

   create a secure private key to grant acceess to your github repository

   1. export env variables to use with the commands below
      ```bash
      export github_profject=cicd-admin--docker-jenkins-aws
      ```
   1. generate a public/private keypair
      ```bash
      ssh-keygen -t rsa -b 2048 -f ~/.ssh/${github_project}-private-key -N ""
      ```
         - **warning** `-N ""` above will revent the passphrase prompt from appearing.
         - **tip** for added security, omit this and use a passphrase for added security.
         - **note** you will need to [add the key to your local agent](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

   1. ensure correct permissions
      ```bash
      chmod 600 ~/.ssh/${github_project}-private-key
      chown $(whoami):$(whoami) ~/.ssh/${github_project}-private-key
      ```




1. ### grant access to your github repository

      - [provide access to your github repository](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)
      - **note** free github account users will need to use a deployment key to grant permissions on a per repository basis.
         - add a deployment key for your repository at `https://github.com/<user-account>/<project>/settings/keys`
         - more inforamtion on deployment keys 
           <br>https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys
      - **optional** keys which are encrypted with a passphrase will need to [***add their private key to ssh-agent***](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)



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
