resource "aws_db_subnet_group" "pega-rds-subgrp" {
  name       = "pega-rds-subgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  tags = {
    Name = "Subnet group for RDS"
  }
}
resource "aws_elasticache_subnet_group" "Elastic-cache-Subgrp" {
  name       = "Elastic-cache-subgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  tags = {
    Name = "Subnet group for Cache"
  }
}
resource "aws_db_instance" "pega-RDS" {
  instance_class         = "db.t2.micro"
  allocated_storage      = "15"
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7.34"
  db_name                = var.dbname
  password               = var.dbpass
  username               = var.dbuser
  parameter_group_name   = "default.mysql5.6"
  multi_az               = "false"
  skip_final_snapshot    = "true"
  publicly_accessible    = "false"
  db_subnet_group_name   = aws_db_subnet_group.pega-rds-subgrp.name
  vpc_security_group_ids = [aws_security_group.pega-backend-sg.id]
}

resource "aws_elasticache_cluster" "Elastic-cache" {
  cluster_id           = "pega-cache"
  node_type            = "cache.t2.micro"
  engine               = "memcached"
  num_cache_nodes      = "1"
  parameter_group_name = "default.memcached1.5.16"
  port                 = "11211"
  security_group_ids   = [aws_security_group.pega-backend-sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.Elastic-cache-Subgrp.name
}
resource "aws_mq_broker" "pega-rmq" {
  broker_name        = "pega-rmq"
  engine_type        = "ActiveMQ"
  engine_version     = "5.15.0"
  host_instance_type = "mq.t2.micro"
  security_groups    = [aws_security_group.pega-backend-sg.id]
  subnet_ids         = [module.vpc.private_subnets[0]]
  user {
    password = var.rmqpass
    username = var.rmquser
  }
}
