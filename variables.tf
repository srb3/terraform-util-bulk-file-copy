############ connection details #################

variable "ip" {
  description = "The ip address to copy the files to"
  type        = string
}

variable "user_name" {
  description = "The ssh user name used to access the ip address provided"
  type        = string
}

variable "ssh_user_private_key" {
  description = "The user key used to access the ip address"
  type        = string
}

########### file details ######################### 

variable "local_path" {
  description = "The local path to copy files from"
  type        = string
}

variable "file_pattern" {
  description = "A pattern to apply when select which files to copy"
  type        = string
  default     = "*"
}

variable "tmp_path" {
  description = "The location of a temp directory used as a base for the working_path"
  type        = string
  default     = "/var/tmp"
}

variable "working_path" {
  description = "A directory name that will hold the coppied files and any scripts that are used. The coppied files will be under a subdirectory called files"
  type        = string
  default     = "bulk_file_copy"
}

variable "remote_privileged_path" {
  description = "If the files being coppied need to end up in a location that needs elevated privileges, then use this variable to hold that location"
  type        = string
  default     = ""
}

variable "script" {
  description = "If you want to run a custom script after the files have been coppied to a remote system, then use this variable to hold the content of the remote script"
  type        = string
  default     = ""
}
