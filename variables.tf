variable "account_id" {
  type = string
  default = "your_account_id"
}
variable "bucket_name" {
  type = string
  default = "your_bucket_name"
}
variable "aws_linux_ami" {
  type = string
  default = "aws_ami_for_your_region"
}
variable "key-pair-name" {}

variable "my_ip" {
  type = string
  default = ["your.i.p.address"]
}