# Ansible Cloud App Deployment

## Objective

The purpose of this project is to show that Ansible and Terraform aren't competitor but ally. Using them together we will hightlight how easily you can automate your cloud infrastructure on the different cloud provider with minimal change to your automation code.

## Ansible & Terraform 

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
![architecture](./docs/images/ansible-terraform.png)

---
## Demo

Using Ansible and Terraform we will be deploying VM(s) in the cloud in order to deploy a Web Application inside a Web Server. The demo contains a load balancer to sent traffic to the different VM and a interfacing with ServiceNow to act as the client portal to order the different VM. We could implement other element in serviceNow such as incident management and Inventory.


### Infrastructure
For the complete demo we wil be using 2 cloud providers. The demo is build so you can elect to select only the cloud infrastructure you want.

* [AWS](https://aws.amazon.com/)
* [Microsoft Azure](https://azure.microsoft.com/en-ca)

### Prerequisite
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
:warning: The serviceNow entry point is optional. All can be run from Ansible Automation Platform.

![architecture diagram](./docs/images/infra.png)

---

### General Steps

* Create a project that point to the source control. Once this is done you are now ready to create the different templates needed.

![aap-project](./docs/images/aap-project.png)

* Create a credential of type source countrol to access the project in Github since the project is Private.
![source-control](./docs/images/source-control.png)

* Create and empty inventory to call the cloud provider.
![empty-inventory](./docs/images/empty-inventory.png)

---

### Setting up the desired cloud provider.

- [AWS](./docs/aws.md)
- [Azure](./docs/azure.md)

---

### Config the Sent Notification

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

  ![gmail_credential_type](./docs/images/gmail_account_type.png)

* Create the gmail Credential
  ![gmail_account](./docs/images/gmail_account.png)

* Create the require template to sent email.
  * Variables
    * recipient
    * subject
    * body

  ![sentnotification-template](./docs/images/sentnotification-sucess.png)

