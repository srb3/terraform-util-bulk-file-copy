# Overview
This terraform module wraps the file and local exec provisioners. It creates a tidy way to upload the contents of directories to linux based systems. 
Windows support might be added at a later point in time. 

### Supported platform families:
 * Debian
 * SLES
 * RHEL

## Usage
#### Example: Basic usage
The following example will copy files from the local system in the `/home/user/certs/` directory to the default location on the remote system (192.0.2.1). The default remote location is `/var/tmp/bulk_file_copy/files`.
```hcl

module "file_upload" {
  source               = "srb3/bulk-file-copy/util" 
  ip                   = "192.0.2.1"
  user_name            = "centos"
  ssh_user_private_key = "/home/user/.ssh/id_rsa"
  local_path           = "/home/user/certs/"
}
```
If you set the `working_path` variable to something other than `bulk_file_copy` then the remote location will be updated to reflect this. e.g. 
```
working_path = "app_files"
```
Then files will be copied to `/var/tmp/app_files/files` on the remote system.
If you want to change the base of the remote path then override the `tmp_path` variable, this is defaulted to `/var/tmp`.

#### Example: copy to remote then move to privileged location
The following example will copy files to the remote system and then move them to a privileged location. This is needed when you want to upload files to a path that the user initiating the connection does not the rights to access. However it does require that the user initiating the connection has sudo.
```
module "upload_app_keys" {
  source                 = "srb3/bulk-file-copy/util" 
  ip                     = "192.0.2.1" 
  user_name              = "centos"
  ssh_user_private_key   = "/home/user/.ssh/id_rsa"
  local_path             = "app_data"
  remote_privileged_path = "/opt/app1/keys"
  file_pattern           = "*.pem"
  working_path           = "app_keys"
} 

```
The above code will copy files from the `app_data` folder in the current path. However the `file_pattern` is also applied so only files ending in *.pem are transferred to the remote system. On the remote system the files are staged in the `/var/tmp/app_keys/files` path. Then a script executes using sudo to move the files from `/var/tmp/app_keys/files` to the `remote_privileged_path` which is `/opt/app1/keys` 

#### Example: Copy files to remote location and execute custom script

The following example copies files from local to remote and then executes a custom script.
```
locals {
  tmp_path = "/home/centos"
  working_path = "nginx_data"
  file_pattern = "*.conf"
}

module "hab_pkg_upload" {
  source                 = "srb3/bulk-file-copy/util" 
  ip                     = "192.0.2.1" 
  user_name              = "centos"
  ssh_user_private_key   = "/home/user/.ssh/id_rsa"
  local_path             = "app_data"
  file_pattern           = local.file_pattern
  script                 = "sudo cp ${local.tmp_path}/${local.working_path}/files/${local.file_pattern} /etc/nginx/conf.d/ && sudo systemctl reload nginx"
  working_path           = local.working_path
  tmp_path               = local.tmp_path
}  
```
