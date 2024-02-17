# hetzner-tf

"As a developer, I want to quickly stand up and tear down a Linux server with some sane defaults so I can have a reasonably secure sandbox to play around in and get on with my projects."

Deploy a [Hetzner](https://www.hetzner.com/) server (Linux VM) with some basic security using terraform and cloud-init.

This will create a VM with a public IPv4 IP and a network firewall with an ssh inbound rule tied to your local public IP.  The VM will also have a passwordless sudo user, and the following will be disabled:
- password auth
- root login
- x11 forwarding

The default SSH port is also changed, and the OS packages should be fully up to date. Everything is variable-ized so feel free to change anything you want.  The `cloud-init.sh` file can be expanded quite a lot (for example, add as many packages as you want in the `apt install` line).

Note: this assumes you're going to run an Ubuntu VM. If you want to run a different distro, further changes may be needed in `cloud-init.sh` and you'll need to change the `server_image` var in `variables.tf`

I intentionally chose the cheapest server type as a starting point, feel free to change it to whatever you want (see Helpful Stuff at the bottom).

## Prereqs
1. Create a [Hetzner account](https://accounts.hetzner.com/signUp)
2. Create a read/write [API token](https://docs.hetzner.com/cloud/api/getting-started/generating-api-token/) and store it somewhere safe
3. Create a local ssh key pair (defaults are fine): `ssh-keygen`
4. Install [terraform](https://www.terraform.io/downloads) and make sure it's in your `$PATH`

## How to Deploy

1. Clone repo, and go into directory `cd hetzner-tf`
2. Change variables as needed in `variables.tf` and `cloud-init.sh`
3. Set a local environment variable for your API token (optional) `export TF_VAR_hcloud_toke=<PASTE TOKEN HERE>`
4. Initialize terraform `terraform init`
5. Run the plan `terraform plan`
6. Create all resources `terraform apply # enter yes to confirm`
7. Log into the [Hetzner web console](https://console.hetzner.cloud), and copy the public IP of your server
8. Connect to the instance (change values as needed)
```
ssh -p <SSH PORT> <USERNAME>@<PUBLIC IP>

# e.g. given the defaults in the scripts:
ssh -p 55022 yoloadmin@<PUBLIC IP>
```
Note: It might take a couple minutes for everything to be provisioned and cloud-init to complete all its tasks before you can ssh in.

9. Once connected, check if cloud-init completed successfully: `cloud-init status`.  You can also check the cloud-init logs with `less /var/log/cloud-init-output.log`

## How to Tear Everything Down

`terraform destroy # enter yes to confirm`

## Helpful Stuff

#### SSH Config
On your local machine, create a new file in this location: `~/.ssh/config`

And paste the following (change values as needed):
```
Host hetzner-testvm1
  HostName <PUBLIC IP>
  User <USERNAME>
  Port <SSH PORT>
  IdentityFile /path/to/private/ssh/key
```
Then you can run this to connect to your server: `ssh hetzner-testvm1`

#### How to get a list of server types/images/regions

1. Install [hcloud cli](https://community.hetzner.com/tutorials/howto-hcloud-cli)
2. Authenticate with your API token: `hcloud context create default`
3. To get server types: `hcloud server-type list`
4. To get server images: `hcloud image list`
5. To get server regions: `hcloud location list`
