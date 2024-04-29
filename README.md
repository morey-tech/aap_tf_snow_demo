# Ansible Cloud App Deployment

#### Objective

The purpose of this project is to show that Ansible and Terraform aren't competitor but ally. Using them together we will hightlight how easily you can automate your cloud infrastructure on the different cloud provider with minimal change to your automation code.

#### Ansible & Terraform 

Ansible and Terraform are both great automation tools which have different ways of looking at automation. And ochestrationg them together make for a great solution in automations.

* [Terraform](https://www.terraform.io/)
  * Great at defining what the state of the infrstructure needs to be. The states get maintain in time.
  * Excels as a `cloud intrasctructure` provisioning tool
  * Define the entirety of the instrasctucture
* [Ansible](https://www.ansible.com/)
  * Task base oriented
    * easy way to get use to, since it translate to what we are doing on a day 2 day fashion
  * Great for orchestration multiple teams and technologies in to a single IT worksflow. ex: Window, Linux, Network, API ....
  * Cross-domain automation solution

![architecture](docs/images/ansible-terraform.png)

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
* [Ansible Automation Platform](https://www.redhat.com/en/technologies/management/ansible)
* Fork of the [Web Application Repository]()
* _Optional_ [ServiceNow](https://www.servicenow.com/)


:warning: The required variable need to be set in order to create the load balancer in the proper cloud.[Set variable here]().

Implementation diagram:

![architecture diagram](docs/images/infra.png)

---

#### Build the demo.

###### Steps


---

#### Appendix

Usefull command to test the Terraform provisioning locally.

* Initialized the current working directory
    ```
        terraform init
    ```
* Get a preview of what the code will do
    ```
    terraform plan -var-file="local.tfvars"
    ```
* Apply the desired changes
    ```
    terraform apply -var-file="local.tfvars" -auto-approve
    ```
* Destroy what you just created
    ```
    terraform destroy -var-file="local.tfvars" -auto-approve
    ```

---