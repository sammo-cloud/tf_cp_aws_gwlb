resource "aws_key_pair" "key_TPOT" {
  key_name   = "TPOT Key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvxxO1BotTtIhBBiuTbRGGrvwT/jSn3defnK+dqp0wwz92NjoFfXhmg7RgFkBmFlBY+SZRO6yrmgEulvX2FVi2/gUFTnITa7S0n4PfA0uVWV8ZuGcRGBmPtqiOtYg0MhVLRHAKcLuNiE9QCRXOad8jQTiYDMkSvG7ZkrEGknSfKfa0r/bRkiRvtoOhaINUfPecDpb0KA3n47lmSPznfMRKrCxOqjlfgQ8JIbCgYhMQ5zMtQbimNr28yERV8pvL2t9k8NK0haLEToj576Ppa6CIy3soNlyVSx0VPQsPl+XvVWiRa5PJxLY6rWMQx9cyNIXq2UbGdg6ZYPkHKRq//Z1zMu5681PyvVL9yEYxbGSrnX0gbbxsvamOO1N0AcP08WbYoSrLF40OC+Yahy7PekikqSLwuq4oofY6HMTBr1ouf0v47AI/QRfAgfxGGQB3Ty9XEvNReYcdsEgbpeFqgVTxR0NY0qeiDkPYDJHb8WmQwzm2R6FZ+LbbH5luDxrgPyJmmz2zZpkwOwV4wQsDPzNfk02Syp4+p38TCX46Wwj9jgJbd+nROUbY8OYLW5e/NyHm89x1L4dDxvRF78uzSk3SbNsInaOpBIs6xIC6yzxhteAnYOCHli2VPpabxhxijr0vBnHqq4IxAoYGu8EA5fIussCPK4y+T5BRKhQQ16lH7Q== your_email@example.com"
}

# Deploy CP Geo Cluster for TGW cloudformation template
# https://sc1.checkpoint.com/documents/IaaS/WebAdminGuides/EN/CP_CloudGuard_for_AWS_Transit_Gateway_High_Availability/Content/Topics/Terms.htm?tocpath=_____4
resource "aws_cloudformation_stack" "checkpoint_gwlb_cloudformation_stack" {
  name = "${var.project_name}-GWLB"

  parameters = {
AdminCIDR	 = "0.0.0.0/0"
AllowUploadDownload	= true	
AvailabilityZones	= "ap-east-1a,ap-east-1b"
ConfigurationTemplate	= "gwlb-ASG-configuration"
ControlGatewayOverPrivateOrPublicAddress	= "private"
GWLBName	 = "gwlb1"
GWLBeSubnet1CIDR	= "10.0.14.0/24"
GWLBeSubnet2CIDR	= "10.0.24.0/24"
GWLBeSubnet3CIDR	= "10.0.34.0/24"
GWLBeSubnet4CIDR	= "10.0.44.0/24"
    GatewayInstanceType     = var.geocluster_gateway_size
GatewayManagement	= "Locally managed"
    GatewayVersion          = "${var.cpversion}-BYOL"
GatewaysAddresses	= "0.0.0.0/0"
GatewaysMaxSize	= 10
GatewaysMinSize	= 2
GatewaysPolicy	= "Standard"
ManagementDeploy	= true
ManagementInstanceType	= "m5.large"
ManagementPasswordHash	= var.password_hash
ManagementServer	= "gwlb-management-server"
ManagementVersion	= "${var.cpversion}-BYOL"
NatGwSubnet1CIDR	= "10.0.13.0/24"
NatGwSubnet2CIDR	= "10.0.23.0/24"
NatGwSubnet3CIDR	= "10.0.33.0/24"
NatGwSubnet4CIDR	= "10.0.43.0/24"
NumberOfAZs	= 2
PublicSubnet1CIDR	= "10.0.10.0/24"
PublicSubnet2CIDR	= "10.0.20.0/24"
PublicSubnet3CIDR	= "10.0.30.0/24"
PublicSubnet4CIDR	= "10.0.40.0/24"
Shell	= "/bin/bash"
TargetGroupName	= "tg1"
TgwSubnet1CIDR	= "10.0.12.0/24"
TgwSubnet2CIDR	= "10.0.22.0/24"
TgwSubnet3CIDR	= "10.0.32.0/24"
TgwSubnet4CIDR	= "10.0.42.0/24"
VPCCIDR	= "10.0.0.0/16"
    KeyName                 = aws_key_pair.key_TPOT.key_name
    GatewayPasswordHash     = var.password_hash
    Shell                   = "/bin/bash"
    GatewayName	            = var.project_name
    GatewaySICKey	    = var.sickey
}

  template_url        = "https://cgi-cfts.s3.amazonaws.com/gwlb/tgw-gwlb-master.yaml"
  capabilities        = ["CAPABILITY_IAM"]
  disable_rollback    = true
  timeout_in_minutes  = 50
}
