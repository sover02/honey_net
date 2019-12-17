# honey_net

To start, create your virtual environment, activate it, and then install necessary pip modules.

```
virtualenv ~/.venvs/github_honey_net
. ~/.venvs/github_honey_net/bin/activate
pip install -r requirements.txt
```

Make sure your AWS cli is configured.

```
aws login
```

Configure group_vars - set up the logstash host and ssh key info
```
cd ./ansible
vim group_vars/all
```

After that, you can run the ansible playbook.

```
cd ansible
ansible-playbook main.yml
```

This will deploy one honeypot server in each region, except us-east-1, which is commented out. To select which locations, comment out or uncomment blocks in ./terraform/honeypot_instances.tf

To tear down:
```
cd ./terraform
terraform destroy
```
