# Description
- With VMProvisioner one can provision the desired amount of virtual machines, along with needed resources such as. virtual network, subnet, network security group, network interface cards and public ips in Azure.
- Written in Bicep. It uses modules and a parameter file, where one can customize some parameters such as names, VM count, VM size, Ubuntu version, VM authentication type and whether to create public ips or not.

This is how it looks like:

![vmprovisioner](https://github.com/Ollitie/azure-miniprojects/assets/124052727/05646bd7-9433-453e-9d09-9712b5f33cb3)

# Objectives
With this mini-project I wanted to get hands on experience on creating deployments with Bicep / infrastructure as code, and utilize the following:
- Use separate Bicep modules (on e.g. VMs and networking) and parameters file (so that deployments can be customized easily)
- Implement naming conventions using parameters and string formatting
- Use loops to deploy multiple VMs, NICs and PIPs at once. Ensure that VMs are provisioned within the Vnet/subnet created and have nsg security rules applied.
- Use generative AI as an assistant, to test how well it works in creating IaC.. In short: it produced both good and broken code, and was very helpful in problem solving.
