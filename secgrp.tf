resource "aws_security_group" "pega-bean-elb-sg" {
  name = "pega-bean-elb-sg"
  description = "Secrgp for bean ELB"
  vpc_id = module.vpc.vpc_id
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "Secrgp for bastion host"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = [var.MYIP]
  }
}

resource "aws_security_group" "pega-prod-sg" {
  name        = "pega-prod-sg"
  description = "Secrgp for pega-prod"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = [aws_security_group.bastion-sg.id]
  }
}

resource "aws_security_group" "pega-backend-sg" {
  name        = "pega-backend-sg"
  description = "Secrgp for pega-backend  rds activemq cache"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = [aws_security_group.pega-prod-sg.id]
  }
}

resource "aws_security_group_rule" "sec_group_allow_itself" {
  from_port         = 0
  protocol          = "tcp"
  security_group_id = aws_security_group.pega-backend-sg.id
  to_port           = 65535
  type              = "ingress"
  source_security_group_id = aws_security_group.pega-backend-sg.id
}





