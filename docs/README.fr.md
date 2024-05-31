# Déploiement d'applications cloud Ansible

Lisez ceci dans d'autres langues: :us:[ English/Anglais](README.md)

#### Objectif

Le but de ce projet est de montrer qu'Ansible et Terraform ne sont pas des concurrents mais des alliés. En les utilisant ensemble, nous mettrons en évidence la facilité avec laquelle vous pouvez automatiser votre infrastructure cloud sur les différents fournisseurs de cloud avec une modification minime de votre code d'automatisation.

#### Ansible et Terraform

Ansible et Terraform sont tous deux d'excellents outils d'automatisation qui ont différentes façons d'envisager l'automatisation. Les combiner ensemble constitue une excellente solution en matière d'automatisation.

-   [Terraforme](https://www.terraform.io/)
    -   Excellent pour définir quel doit être l’état de l’infrastructure. Les états se maintiennent dans le temps.
    -   Excelle en tant que`cloud intrasctructure`outil de provisionnement
    -   Définir l'intégralité de l'infrastructure
-   [Ansible](https://www.ansible.com/)
    -   Orienté base de tâches
        -   un moyen facile de s'y habituer, car cela se traduit par ce que nous faisons au quotidien
    -   Idéal pour orchestration de plusieurs équipes et technologies dans un seul flux de travail informatique. ex : Fenêtre, Linux, Réseau, API....
    -   Solution d'automatisation inter-domaines

A quoi ça ressemble ensemble :![architecture](images/ansible-terraform.png)

* * *

#### Démo

En utilisant Ansible et Terraform, nous déploierons des VM dans le cloud afin de déployer une application Web dans un serveur Web. La démo contient un équilibreur de charge pour envoyer le trafic vers les différentes VM et une interface avec ServiceNow pour agir comme portail client pour commander les différentes VM. Nous pourrions implémenter d'autres éléments dans serviceNow tels que la gestion des incidents et l'inventaire.

###### Infrastructure

Pour la démo complète, nous utiliserons 3 fournisseurs de cloud. La démo est conçue pour que vous puissiez choisir de sélectionner uniquement l'infrastructure cloud de votre choix.

-   [AWS](https://aws.amazon.com/)
-   [Microsoft Azure](https://azure.microsoft.com/en-ca)
-   [Plateforme Google Cloud](https://cloud.google.com/)

###### Prérequis

-   Pour le développement local
    -   _Ansible_noyau 2.16.x
    -   _Terraforme_
    -   Python 3.x
    -   [Chapeau rouge JBoss](<>)
-   [GitHub](https://github.com/)
-   Fork de ces 2 dépôts
    -   [Déploiement de VM Ansible Terraform Cloud](https://github.com/froberge/ansible_terraform_cloud_vm_deployment)
    -   [Configuration Terraform Ansible](https://github.com/froberge/ansible_terraform_config)
-   [Plateforme d'automatisation Ansible](https://www.redhat.com/en/technologies/management/ansible)
-   _Facultatif_[ServiceMaintenant](https://www.servicenow.com/)

:avertissement : La variable requise doit être définie afin de créer l'équilibreur de charge dans le cloud approprié.[Définir la variable ici](<>).

Schéma de mise en œuvre :

![architecture diagram](images/infra.png)

* * *

#### Créez la démo.

Pour la démo nous avons besoin d'un environnement d'exécution, vous pouvez trouver les informations sur la façon de [environnement de création et d'exécution ici](../exec-environment/README.fr.md). Vous pouvez également trouver une version déjà compilée [ici](https://quay.io/repository/froberge/ansible-terraform-demo).

##### Étapes générales

-   Dans`Ansible Automation Platform`créez de nouveaux types d'informations d'identification pour contenir votre jeton d'accès personnel Github. comme suit.![github new credential](images/aap-github-credential-type.png)Vous pouvez utiliser ces valeurs pour remplir les champs.
    -   configuration d'entrée (en yaml)
        ```script
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
    -   Configuration de l'injecteur (en yaml)
        ```script
        env:
        git_user: '{{ git_user }}'
        pah_pass: '{{ pah_pass }}'
        git_token: '{{ git_token }}'
        ```

-   Créer un`Personal Access tokens`sur votre compte GitHub. Vous pouvez créer un token sous votre compte_paramètres -> Paramètres du développeur_Ajoutez le jeton avec le nom que vous souhaitez, avec les informations d'identification suivantes et la date d'expiration que vous désirez.![github-token](images/github-token.png):avertissement: Copiez la clé générée, vous en aurez besoin dans une autre étape.

-   Créez le nouveau Credential à partir du nouveau type que vous venez de créer avec le`Personal Access tokens`![Github credential](images/aap_github-credential-of-new-type.png)


-   Créez un projet qui pointe vers le contrôle de source. Une fois cela fait, vous êtes maintenant prêt à créer les différents modèles nécessaires.![aap-project](images/aap-project.png)

##### Configuration de chaque fournisseur de cloud.

###### AWS

Le scénario AWS est créé à l'aide de Terraform et Ansible.

-   Créez un identifiant contenant vos identifiants AWS![AWS credential](images/AWS-credentials.png)

-   Ansible se connecte à l'instance EC2 à l'aide de SSH. Commençons par créer un nouveau [Paire de clés dans AWS](https://docs.aws.amazon.com/servicecatalog/latest/adminguide/getstarted-keypair.html).

    -   Créer une paire de clés, appeler`ansible_terraform_demo`dans votre compte AWS.![create-key-pair](images/create-key-pair.png):warning: si vous modifiez le nom, vous devez modifier le fichier principal de Terraform avec le nouveau nom.

    -   Créer un identifiant de`type machine in AAP`qui contient la clé SSH de l'utilisateur`ec2-user`![create_credential_ssh_aws](images/create-credential-ssh-aws.png)

-   1.  Configurer[Inventaire dynamique AWS](https://www.redhat.com/en/blog/configuring-an-aws-dynamic-inventory-with-automation-controller)


-   Créez les différents modèles nécessaires afin de créer le flux de travail requis.![aws workflow](images/aws-workflow.png)

![aws template list](images/aws-template-list.png)

Variables de provisionnement ou de déprovisionnement

```script
---
infra_state: [present / absent]
force_init: true
git_repo_url: https://{{ git_user }}:{{ git_token }}@github.com/froberge/ansible_terraform_config.git
git_work_dir: /tmp/terraform/aws
```

LoadBalancer, test de fumée et variables WS. (WS n'a besoin que de la deuxième variable)

```script
---
lb_group_name: tag_type_dev_lb
ws_group_name: tag_type_dev_web
```

###### Azur

Le scénario Azure est créé en utilisant uniquement Ansible.

* * *
