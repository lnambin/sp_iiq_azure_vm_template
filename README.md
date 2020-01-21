# sp_iiq_azure_vm_template
SailPoint IIQ Azure VM Template

# SailPoint IIQ Azure VM - Ubuntu, OpenJDK, Tomcat and Mysql

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fgithub.pwc.com%2Fraw%2Fnambi-narayanan%2Fsp_iiq_vm%2Fmaster%2Fazuredeploy.json%3Ftoken%3DAAABWLQCNHGLTHA3TXYVEYC6FLIWM" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>

This template allows you to create a Ubuntu VM with OpenJDK, Tomcat and Mysql. 

This template deploys a **Linux VM Ubuntu** using the latest patched version. This will deploy a Standard_B2s size VM and a 18.04-LTS Version as defaultValue in the resource group location and will return the admin user name, Virtual Network Name, Network Security Group Name and FQDN.

The custom script file is pulled temporarily from https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/openjdk-tomcat-ubuntu-vm/java-tomcat-mysql-install.sh

Once the VM is successfully provisioned, tomcat installation can be verified by accessing the link http://<FQDN name or public IP>:8080/
