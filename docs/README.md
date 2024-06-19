# Ansible Cloud App Deployment
Read this in other languages: :fr:[ French/Français](README.fr.md)

#### Objective

The purpose of this project is to show that Ansible and Terraform aren't competitor but ally. Using them together we will hightlight how easily you can automate your cloud infrastructure on the different cloud provider with minimal change to your automation code.

#### Ansible & Terraform 

Ansible and Terraform are both great automation tools which have different ways of looking at automation. Ochestrating them together make for a great solution in automations.

* [Terraform](https://www.terraform.io/)
  * Great at defining what the state of the infrstructure needs to be. The states get maintain in time.
  * Excels as a `cloud intrasctructure` provisioning tool
  * Define the entirety of the instrasctucture
* [Ansible](https://www.ansible.com/)
  * Task base oriented
    * easy way to get use to, since it translate to what we are doing on a day 2 day fashion
  * Great for orchestration multiple teams and technologies in to a single IT workflow. ex: Window, Linux, Network, API ....
  * Cross-domain automation solution

What does it look like together:
![architecture](images/ansible-terraform.png)

---
#### Demo

Using Ansible and Terraform we will be deploying VM(s) in the cloud in order to deploy a Web Application inside a Web Server. The demo contains a load balancer to sent traffic to the different VM and a interfacing with ServiceNow to act as the client portal to order the different VM. We could implement other element in serviceNow such as incident management and Inventory.


###### Infrastructure
For the complete demo we wil be using 3 cloud providers. The demo is build so you can elect to select only the cloud infrastructure you want.

* [AWS](https://aws.amazon.com/)
* [Microsoft Azure](https://azure.microsoft.com/en-ca)
* [Google Cloud Platform](https://cloud.google.com/)

###### Prerequisite
* For local development
  * _Ansible_ core 2.16.x
  * _Terraform_
  * Python 3.x
  * [Red Hat JBoss]()
* [Github](https://github.com/) 
* Fork of these 2 repos
  * [Ansible Terraform Cloud VM Deployment](https://github.com/froberge/ansible_terraform_cloud_vm_deployment)
  * [Ansible Terraform Config](https://github.com/froberge/ansible_terraform_config)
* [Ansible Automation Platform](https://www.redhat.com/en/technologies/management/ansible)
* _Optional_ [ServiceNow](https://www.servicenow.com/)


:warning: The required variable need to be set in order to create the load balancer in the proper cloud.[Set variable here]().

Implementation diagram:

![architecture diagram](images/infra.png)

---

##### General Steps

* Create a project that point to the Source Control, Once this is done you are now ready to create the different templates needed.

![aap-project](images/aap-project.png)

* Create a credential of type source countrol to access the project in Github since the project is Private.
![source-control](images/source-control.png)

* Create and empty inventory to call the cloud provider.
![empty-inventory](images/empty-inventory.png)

---

##### Setting up each cloud provider.

###### AWS
The AWS scenario is created using Terraform and Ansible.

* Create the Execution environment and import it into AAP.

  * We need an execution environment in order to have the Terraform collection. You can find the info on how to [create and execution environment here](../exec-environment/README.md) You can also find an already compile version [here](https://quay.io/repository/froberge/ansible-terraform-demo).

  * In `Ansible Automation Platform`, add the newly created execution environment.
    *  In the platform under Execution environment click `Add`
    * Fill out the information.
    ![execution environment](images/execution-env.png)

* Create a new Crendital Type to contain Github Personal Access Token.
  *  In `Ansible Automation Platform` create e new Credential Types to contain you Github Personal Access token. as follow.
  ![github new credential](images/aap-github-credential-type.png)
  You can use these values to populate the fields.
      ```script
      input configuration ( in yaml)

      fields:
        - id: git_user
          type: string
          label: Username
        - id: git_token
          type: string
          label: Token
          secret: true
        - id: pah_pass
          type: string
          label: Vault Password
          secret: true
      required:
        - username
        - password
        - pah_pass
      ```

      ```script
      Injector configuration ( in yaml )

      env:
        git_user: '{{ git_user }}'
        pah_pass: '{{ pah_pass }}'
        git_token: '{{ git_token }}'
      ```

  * In `GitHub`, ceate a `Personal Access tokens` on your account. You can create a token under your account _settinggs -> Developer Settings_ Great the token with the name you want, with the following credential, and the expiration date you desire.
  ![github-token](images/github-token.png)
  :warning: Copy the generated key, you will need in another step.

  * In `Ansible Automation Platform` Create the new Credential from the new type you just created with the `Personal Access tokens`
  ![Github credential](images/aap_github-credential-of-new-type.png)


* Create a Credential which contains your AWS credentials
![AWS credential](images/AWS-credentials.png)

* Ansible connects to EC2 instance using SSH. Let's start by creation a new [Key pair in AWS](https://docs.aws.amazon.com/servicecatalog/latest/adminguide/getstarted-keypair.html). 

  * Create key pair, call `ansible_terraform_demo` in your AWS account.
  ![create-key-pair](images/create-key-pair.png)
  :warning: if you change the name you need to edit the terraform main  file with the new name.

  * Create a credential of `type machine in AAP` which contains the SSH key for the user `ec2-user`
  ![create_credential_ssh_aws](images/create-credential-ssh-aws.png)

* 1. Configure [AWS dynamic inventory](https://www.redhat.com/en/blog/configuring-an-aws-dynamic-inventory-with-automation-controller)


* Create the different templates needed in order to create the required workflow.
![aws workflow](images/aws-workflow.png)

![aws template list](images/aws-template-list.png)

Provisioning or Deprovisioning variables
```script
---
infra_state: [present / absent]
force_init: true
git_repo_url: https://{{ git_user }}:{{ git_token }}@github.com/froberge/ansible_terraform_config.git
git_work_dir: /tmp/terraform/aws
```

LoadBalancer, Smoke test & WS variables. ( WS only need the second variable)
```script
---
lb_group_name: tag_type_dev_lb
ws_group_name: tag_type_dev_web
```
---

###### Azure
The Azure scenario is created using only Ansible.

* Create a Credential which contains your Azure credentials
  * __Name:__ Choose a descriptive name for the credential.
  * __Subscription ID:__ Enter the subscription id where your resources created in Azure should be associated
  * __Client ID:__ Enter the appId value from the Service Principal creation.
  * __Client Secret:__ Enter the password from the Service Principal creation.
  * __Tenant ID:__ Enter the tenant from the Service Principal creation.

![Azure credential](images/azure-credential.png)


* Create the Execution environment and import it into AAP.

  * We need an execution environment in order to have the Azure collection. You can find the info on how to [create and execution environment here](../exec-environment/README.md). You can also find an already compile version [here](https://quay.io/repository/froberge/ansible_cloud_deploy).

* [Create an SSH Key](https://www.digitalocean.com/community/tutorials/how-to-create-ssh-keys-with-openssh-on-macos-or-linux). 

* Create a new Credential Type to contain the public key of you've just created.
  ```
  This is the value that needs to be part of the env.
  env:
    AZURE_VM_SSH_PUBLIC_KEY: '{{ }}'
  ```
  ![credential_type](images/credential_type.png)

*  Create a new credential from the credential type you've just created. Use the public key previously created as a value.

:raising_hand: Add the new credential to the job that required the SSH key to be added.

* Create a `Machine` credential type with containing the private key. Using the right username/password and private key.
![machine_ssh](images/az-machine-ssh.png)

:raising_hand: Add the new credential to the job that required to connect by ssh to the vms.

* Configure [Azure dynamic inventory](https://www.redhat.com/en/blog/configuring-an-aws-dynamic-inventory-with-automation-controller).

  ``` script
  source varibles to get groups from Cloud Providers.

  ---
  keyed_groups:
    - prefix: tag
      key: tags
  ```

* Create the different job template
  * Variable used in the different template.
    * project_name: "ansible-demo"
    * res_group: "ansible-demo"
    * instance_name_list: ['webserver1', 'webserver2']
    * instance_name_list: [loadbalancer]
    * instance_env: "dev"
    * vm_type: "webserver"
    * vm_type: "lb"
    * lb_group_name: "tag_type_dev_lb"
    * ws_group_name: "tag_type_dev_webserver"
  

  * Template that need to run in `Privilege Escalation`
    *  install_lb
    *  install_ws

---

###### Config the Sent Notification

To Send notification, we use gmail as the email sender. So you need a gmail account

* [Enable less secure application](https://knowledge.workspace.google.com/kb/how-to-enable-less-secure-application-access-000006971)

* Create a Crendential type that contain de required information to create the gmail credential.

  ```script
  ---
  fields:
    - id: email_username
      type: string
      label: Username
    - id: email_password
      type: string
      label: Password
      secret: true
  required:
    - Username
    - Password
  ```

  ``` script
  ---
  env:
    email_username: '{{ email_username }}'
    email_password: '{{ email_password }}'
  ```

  ![gmail_credential_type](images/gmail_account_type.png)

* Create the gmail Credential
  ![gmail_account](images/gmail_account.png)

* Create the require template to sent email.
  * Variables
    * recipient
    * subject
    * body

  ![sentnotification-template](images/sentnotification-sucess.png)

