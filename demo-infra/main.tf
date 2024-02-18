#module "vpc" {
#  source           = "./vpc"
#  vpc_cidr         = var.vpc_cidr
#  instance_tenency = var.instance_tenency
#  vpc_tag          = var.vpc_tag
#}
module "subnet" {
  source              = "./subnet"
  myvpc               = var.vpc_id
  #myvpc               = module.vpc.vpc_id_out
  public_subnet_cidr  = var.public_subnet_cidr
  pub_aws_az          = var.pub_aws_az
  pri_aws_az          = var.pri_aws_az
  public_subnet_tag   = var.public_subnet_tag
  private_subnet_cidr = var.private_subnet_cidr
  private_subnet_tag  = var.private_subnet_tag
}
# module "igw" {
  # source  = "./igw"
  # myvpc   = var.vpc_id
  #myvpc   = module.vpc.vpc_id_out
  # igw_tag = var.igw_tag
# }

module "nat" {
  source         = "./nat"
  eip_nat        = module.nat.eip_out
  public_subnets = module.subnet.public_subnet_out
  nat_tag        = var.nat_tag
}
module "route_table" {
  source            = "./routetable"
  myvpc             = var.vpc_id
  #myvpc             = module.vpc.vpc_id_out
  cidr_blocks       = var.cidr_blocks
  #myigw             = module.igw.igw_out
  myigw = var.igw_id
  mynat             = module.nat.nat_out
  public_subnets    = module.subnet.public_subnet_out
  public_route_tag  = var.public_route_tag
  private_subnets   = module.subnet.private_subnet_out
  private_route_tag = var.private_route_tag
}

module "ami_image" {
  source              = "./ami"
  ami_image_flavor    = var.ami_image_flavor
  ami_image_virt_type = var.ami_image_virt_type
  ami_image_owner_id  = var.ami_image_owner_id
}
module "key_pair" {
  source           = "./key"
  public_key_pair  = var.public_key_pair
  private_key_name = var.private_key_name
  # default_public_key = file(var.default_public_key)
}

module "sec_groups" {
  source              = "./securitygroup"
  ha_sec_groups_name  = var.ha_sg_name
  myvpc               = var.vpc_id
  #myvpc               = module.vpc.vpc_id_out
  ha_ingress_ports    = var.ha_ingress_ports
  egress_ports        = var.egress_ports
  ingress_protocol    = var.ingress_protocol
  egress_protocol     = var.egress_protocol
  cidr_blocks         = [var.cidr_blocks]
  web_sec_groups_name = var.web_sg_name
  web_ingress_ports   = var.web_ingress_ports
  bastion_sec_groups_name = var.bastion_sec_groups_name
  bastion_ingress_ports = var.bastion_ingress_ports
}


module "instance_launch" {
  source                 = "./instance"
  ami_id                 = module.ami_image.ami_image_id_out
  instance_type          = var.instance_type
  public_subnet_id       = module.subnet.public_subnet_out
  private_subnet_id      = module.subnet.private_subnet_out
  key                    = var.public_key_pair
  public_instance_tag    = var.public_instance_tag
  haProxy_instance_tag   = var.ha_instance_tag
  webserver_instance_tag = var.web_instance_tag
  bastion_security_group = module.sec_groups.bastion_security_group_out
  ha_sec_groups          = module.sec_groups.ha_security_groups_out
  web_sec_groups         = module.sec_groups.web_security_groups_out
  tag_key                = var.instance_tag_key
  tag_values             = var.instance_tag_value
  web_instance_count     = var.web_instance_count
}
