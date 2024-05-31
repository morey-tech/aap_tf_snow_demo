## Créez un environnement d'exécution pour Ansible Automation Platform qui vous permet d'utiliser Terraform.

## Conditions préalables

* Podman
* Connectez-vous au registre Registry.redhat.io
``` podman login registry.redhat.io ```
* Un registre pour pousser l'image de votre environnement d'exécution comme par exemple quay.io.
``` podman login quay.io ```
* Créez un fichier ansible.cfg dans`/execution-env`dossier pour vous donner le jeton Automation Hub (voir l'étape suivante)

---

## Build the execution environement

1.  Créez le fichier ansible.cfg

    Pour qu'ansible-build puisse récupérer des collections à partir de Red Hat Automation Hub, vous devrez fournir votre jeton Automation Hub. Cela se fait en éditant le fichier ansible.cfg. Assurez-vous que ce fichier ne sera pas transféré dans un dépôt git public car il contiendra votre jeton Automation Hub personnel.

    ```ini
    [defaults]
    ansible_nocows=True
    deprecation_warnings=False
    retry_files_enabled=False

    [inventory]
    enable_plugins = host_list, script, auto, yaml, ini, toml

    [galaxy]
    server_list = automation_hub

    [galaxy_server.automation_hub]
    url=https://console.redhat.com/api/automation-hub/content/published/
    auth_url=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token

    token=<my_ah_token>
    ```

    :warning: Enregistrez ce fichier dans /exectution-env/ansible.cfg

2.  Construire l’image d’exécution

    1. Accédez au dossier de l'environnement d'exécution._~github/froberge/ansible_terraform_demo/ansible_terraform_cloud_vm_deployment/exec-environment_
    1. Déplacez-vous dans le dossier de l’environnement d’exécution que vous souhaitez créer.
    1. Définissez la version de build avec laquelle nous voulons commencer dans une variable.
        ``` buildVersion=[add version]```
    1. Définissez le nom de l'image que vous souhaitez créer
        ```imageName=[add name]```
    1. Maintenant, construisons l'image
        ```ansible-builder build -v 3 -t ${imageName}:latest```
    1. Marquons les images, une balise avec la version et une avec la latest. (dans cette commande, j'utilise mon registre quay.io, changez votre emplacement.)
        > ```podman tag ${imageName}:latest quay.io/froberge/${imageName}:latest```

        > ```podman tag ${imageName}:latest quay.io/froberge/${imageName}:${buildVersion}```
    1. Maintenant, poussez les 2 images dans le registre
        > ```podman push quay.io/froberge/${imageName}:latest```

        > ```podman push quay.io/froberge/${imageName}:${buildVersion}```
---

:information_desk_person: L'image déja construite est disponible à cette adresse [quay.io/froberge](https://quay.io/repository/froberge/ansible-terraform-all?tab=tags)
