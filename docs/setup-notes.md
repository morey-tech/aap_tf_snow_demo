
Create the AAP project pointing to the Git repo.

![Image](./setup-images/1-aap-create-project.png)

https://aap-aap.apps.ocp-mgmt.rh-lab.morey.tech/execution/projects/create
---

Create the empty cloud provider inventory

https://aap-aap.apps.ocp-mgmt.rh-lab.morey.tech/execution/infrastructure/inventories/inventory/create

![Image](./setup-images/2-aap-cloud-provider-inventory.png)
---

Create the execution environment with TF in it.

https://aap-aap.apps.ocp-mgmt.rh-lab.morey.tech/execution/infrastructure/execution-environments/add

quay.io/froberge/ansible-terraform-demo:0.2

![Image](./setup-images/3-aap-create-ee.png)
---

Create AWS access credential

Provision environment on demo.redhat.com
https://catalog.demo.redhat.com/catalog/babylon-catalog-prod/order/sandboxes-gpte.sandbox-open.prod

https://aap-aap.apps.ocp-mgmt.rh-lab.morey.tech/execution/infrastructure/credentials/create

![Image](./setup-images/4-aap-create-aws-cred.png)
---

Create AWS SSH cred

https://us-east-2.console.aws.amazon.com/ec2/home?region=us-east-2#CreateKeyPair:

![Image](./setup-images/5-aws-create-key-pair.png)
![Image](./setup-images/5-aap-create-aws-machine-creds.png)
---

Create AWS dynamic inventory

1. Create blank inventory
2. Open inventory, goto sources.
   1. Select Source `Amazon EC2`
   2. Set Execution Environment to `Default ...`
   3. Set Credential to `AWS` (created earlier)
   4. Set source variables
      
      ```yaml
      ---
      regions: us-east-2
      keyed_groups:
      - key: tags.type
      prefix: tag
      ```

![Image](./setup-images/6-aap-aws-dynamic-inventory.png)
---

