## Create an Execution Environement for Ansible Automation Platform

## Prerequisites

* Podman
* Login into registry.redhat.io registry 
    ```script 
    podman login registry.redhat.io
    ```
* A registry to push your execution environment image like for example quay.io. 
    ```script
    podman login quay.io
    ```
* Create an ansible.cfg file in `/execution-env` folder to give you Automation Hub Token (see next step)
---

## Build the execution environement 

1. Create the ansible.cfg file

    For ansible-build to be able to fetch collections from Red Hat Automation Hub, you will need to provide your Automation Hub token. This is done by editing the ansible.cfg file. Make sure this file won't be push into a public git repo since it will contain your personal Automation Hub token.

    ``` ini
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

    :warning: Save this file in /exectution-env/ansible.cfg

2. Build the execution image

    1. Navigate to the execution-environment folder.
    _~github/froberge/ansible_terraform_demo/ansible_terraform_cloud_vm_deployment/exec-environment_
    1. Move into the folder of the executaion environment you would like to build.
    1. Define the build version we want to start with in a variable.
        ```script
        buildVersion=[add version]
        ```
    1. Define the image name you want to build
        ```script
        imageName=[add name]
        ```
    1. Now let's build the image
        ```script
        ansible-builder build -v 3 -t ${imageName}:latest
        ```
    :information_desk_person: If you build on mac, to make sure you build for the right OS use this:
    ```script
        ansible-builder build --extra-build-cli-args="--platform linux/amd64" -v 3 -t ${imageName}:latest
    ```
    1. Let's tag the images, one tag with the version one with latest. ( in this command I use my quay registry, change for your location.)
        ```script
        podman tag ${imageName}:latest quay.io/froberge/${imageName}:latest
        ```

        ```script 
        podman tag ${imageName}:latest quay.io/froberge/${imageName}:${buildVersion}
        ```
    1. Now push the 2 images to the registry
        ```script
        podman push quay.io/froberge/${imageName}:latest
        ```

        ```script
        podman push quay.io/froberge/${imageName}:${buildVersion}
        ```
---

:information_desk_person: The already build image is available at this address [quay.io/froberge](https://quay.io/repository/froberge/ansible-terraform-all?tab=tags)

:information_desk_person: You can check a Execution Environment by running it with podman in ssh.
``` podman run -it --entrypoint sh [IMAGE_NAME] ```