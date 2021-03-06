variable "aws_instance_count" {
  description = "Instance Count (Usually 1)"
}

variable "aws_region" {
  description = "Provide the desired region (for example: us-west-2)"
}

variable "instance_type" {
  description = "Select instance type required (1 = Hot R.O.D. 2 = Sock Shop)"
}

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # This is the owner id of Canonical who owns the official aws ubuntu images

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
variable "instance_type_aws" {
  default = {
    "1" = "t2.small"
    "2" = "m5.xlarge"
  }
}

variable "instance_disk_aws" {
  default = {
    "1" = "8"
    "2" = "15"
  }
}

variable "signalFxApiAccessToken" {
  description = "SignalFx User API access token."
}

variable "signalFxRealm" {
  description = "SignalFx realm."
}

variable "signalFxAWSIntegrationName" {
  description = "Name of the AWS integration that shows up in SignalFx integrations UI."
}

variable "signalFxAWSIntegrationEnabled" {
  description = "Fake boolean to control rollout of AWS integration. Set to 0 to disable"
  default     = 1
}
