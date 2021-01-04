////###############################################
////# RESOURCE GROUPS
////###############################################
//module "resource-group-customers" {
//  source   = "../modules/resource group"
//  location = var.location
//  resource-group-name = "rg-hri-dev-eur-customers"
//}
//
//
////###############################################
////# SQL SERVERS AND SQL DATABASES
////###############################################
//
//module "sql-server-customers" {
//  source         = "../modules/Sql Server"
//  resource_group = module.resource-group-customers.resource-group-name
//  sql-server-name = "sql-hri-dev-eur-customers"
//  administrator-password = var.administrator-password-sql
//  administrator-login = var.administrator-login-sql
//  location = var.location
//}
//
//module "sql-database-customers" {
//  source          = "../modules/Sql Database"
//  resource_group  = module.resource-group-customers.resource-group-name
//  sql-server-name = module.sql-server-customers.sql-server-name
//  sql_database_name = "hri-dev-eur-customers-dbb"
//  location = var.location
//}
//
//
//module "app-service" {
//  source = "../modules/App Service"
//  app-service-name = "my-app-service-hamza"
//  app-service-plan-name = "my-app-service-plan"
//  location = var.location
//  resource-group = module.resource-group-customers.resource-group-name
//}




//module "elk" {
//  source              = "../modules/resource group"
//  location            = var.location
//  resource-group-name = "rg-hri-dev-eur-kibana"
//}

module "blazemeter" {
  source              = "../modules/resource group"
  location            = var.location
  resource-group-name = "rg-hri-dev-eur-blaze"
}

module "virtual-machine-taurus" {
  source               = "../modules/Taurus"
  internal-facing-name = "bzt-internal-facing"
  location             = var.location
  resource-group       = module.blazemeter.resource-group-name
  subnet-name          = "bzt-subnet"
  virtual-network-name = "my-virtual-network-bzt"
  blaze-connection-password = var.blaze-connection-password
  blaze-connection-username = var.blaze-connection-username
}

//module "virtual-machine-kibana" {
//  source               = "../modules/virtual machine Kibana"
//  internal-facing-name = "internal-kibana"
//  location             = var.location
//  resource-group       = module.elk.resource-group-name
//  subnet-name          = "kibana-subnet"
//  virtual-network-name = "kibana-virtual-net"
//  kibana-connection-password = var.kibana-connection-password
//  kibana-connection-username = var.kibana-connection-username
//}

