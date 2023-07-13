
variable "ticket" {
  type        = string
  description = "Privide service now ticket number with starting with SCTASK"
  validation {
    condition     = can(regex("SCTASK", var.ticket))
    error_message = "Please provide valid ticket ID. It should start with SCTASK ?"
  }

}

variable "services" {
  type        = string
  description = "Provide AWS service name saparated by space in quatation. EG 'ec2 s3'"

}



variable "permrequired" {
  type        = string
  description = "Provide permission needed on services separated by space(if multiple) in quatation. EG 'read' "
  #  validation {
  #    condition     = contains(["read", "write", "list", "read write", "read list", "write list", "read write list"], var.permrequired)
  #    error_message = "You are not putting write permission. Possible values \"read\", \"write\", \"list\", \"read write\", \"read list\", \"write list\", \"read write list\"!."
  #  }

}

variable "resourcearn" {
  type        = string
  description = "Provide resource ARN separated by space(if Multiple)"
  default     = ""
}

variable "role_name" {
  type        = string
  description = "Provide IAM ROLE NAME"

  validation {
    condition     = substr(var.role_name, 0, 3) == "LZ-"
    error_message = "ROLE must start with LZ."
  }
}

variable "assume_service" {
  type        = string
  description = "Provide IAM ASSUME POLICY SERVICEi like ec2 lambda rds"
}
variable "managed_policy_arn" {
  description = "List of ARNs of AWS managed policies to attach"
  type        = list(string)
  default     = []
}
variable "condition" {
  description = "Flag to determine whether to execute the local script"
  type        = bool
  default     = false
}
