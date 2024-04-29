# Ansible Cloud App Deployment

#### Objective

In this project we will be automating the creation of VM in the cloud to deploy a more traditionnal Java Application inside a web server. 

The purpose of this demo is to show that Ansible and Terraform aren't competitor but ally. Using them together we will hightlight how easily you can automate your cloud infrastructure on the different cloud provider with minimal change to your automation code.


#### Infrastructure
For the complete demo we wil be using 3 of the major cloud provider. The demo is build so you can elect to select only the cloud infrastructure you want.

* [AWS](https://aws.amazon.com/)
* [Microsoft Azure](https://azure.microsoft.com/en-ca)
* [Google Cloud Platform](https://cloud.google.com/)

#### Technologies
A knowledge of different technologies is required a part from the cloud infrastucture.

* [Ansible Automation Platform](https://www.redhat.com/en/technologies/management/ansible)
* [Ansible](https://www.ansible.com/)
* [Terraform](https://www.terraform.io/)
* [Github](https://github.com/)
* [Red Hat JBoss]()
* _Optional_ [ServiceNow](https://www.servicenow.com/)

---
#### Demo

Using Ansible and Terraform we will be deploying VM that contains a Web Application on different cloud provider. Here what the complete scenario would look like. You need to select which cloud provider you will use to implement the Load Balancer on. This is choosen by defining the given variable.

###### Prerequisite
1. Github 
1. Ansible Automation Platform access
1. Fork of the [Web Application Repository]()
1. Python 3.x for local development of Ansible
1. Ansible core 2.16.x for local development
1. At least one of the 3:
    1. _Optional_ An Azure subscription 
    1. _Optional_ A GCP subscription 
    1. _Optional_ An AWS subscription 
1. Terraform
1. _Optional_ ServiceNow 
1. :warning: The required variable need to be set in order to create the load balancer in the proper cloud.[Set variable here]().

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