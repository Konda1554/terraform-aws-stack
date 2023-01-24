resource "aws_elastic_beanstalk_environment" "pega-bean-prod" {
  name                = "pega-bean-prod"
  application         = aws_elastic_beanstalk_application.pega-prod.name
  solution_stack_name = "64bit Amazon Linux 2 v4.3.3 running Tomcat 8.5 Corretto 11"
  cname_prefix        = "pega-bean-prod-domain"

  setting {
    name      = "VPCID"
    namespace = "aws:ec2:vpc"
    value     = module.vpc.vpc_id
  }

  setting {
    name      = "AssociatePublicIpAddress"
    namespace = "aws:ec2:vpc"
    value     = "false"
  }

  setting {
    name      = "Subnets"
    namespace = "aws:ec2:vpc"
    value     = join(",", [module.vpc.private_subnets[0], module.vpc.private_subnets[1]])
  }

  setting {
    name      = "ELBSubnets"
    namespace = "aws:ec2:vpc"
    value     = join(",", [module.vpc.public_subnets[0], module.vpc.public_subnets[1]])
  }

  setting {
    name      = "InstanceType"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = "t2.micro"
  }

  setting {
    name      = "EC2KeyName"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = aws_key_pair.pegakey.key_name
  }
  setting {
    name      = "Availability Zones"
    namespace = "aws:autoscaling:asg"
    value     = "Any 2"
  }

  setting {
    name      = "MinSize"
    namespace = "aws:autoscaling:asg"
    value     = "2"
  }

  setting {
    name      = "MaxSize"
    namespace = "aws:autoscaling:asg"
    value     = "6"
  }

  setting {
    name      = "environment"
    namespace = "elasticbeanstalk:application:environment"
    value     = "prod"
  }

  setting {
    name      = "LOGGING_APPENDER"
    namespace = "elasticbeanstalk:application:environment"
    value     = "GRAYLOG"
  }

  setting {
    name      = "SystemType"
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    value     = "basic"
  }

  setting {
    name      = "RollingUpdateEnabled"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "true"
  }

  setting {
    name      = "RollingUpdateType"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "Health"
  }

  setting {
    name      = "MaxBatchSize"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "1"
  }

  setting {
    name      = "CrossZone"
    namespace = "aws:elb:loadbalancer"
    value     = "true"
  }

  setting {
    name      = "StickinessEnabled"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "true"
  }

  setting {
    name      = "BatchSizeType"
    namespace = "aws:elasticbeanstalk:command"
    value     = "Fixed"
  }

  setting {
    name      = "BatchSize"
    namespace = "aws:elasticbeanstalk:command"
    value     = "1"
  }

  setting {
    name      = "DeploymentPolicy"
    namespace = "aws:elasticbeanstalk:command"
    value     = "Rolling"
  }

  setting {
    name      = "SecurityGroups"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = aws_security_group.pega-prod-sg.id
  }

  setting {
    name      = "SecurityGroups"
    namespace = "aws:elbv2:loadbalancer"
    value     = aws_security_group.pega-bean-elb-sg.id
  }

  depends_on = [aws_security_group.pega-bean-elb-sg, aws_security_group.pega-prod-sg]
}