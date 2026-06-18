terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "shopstream"
      Environment = var.environment
      ManagedBy   = "terraform"
      Component   = "dbt-warehouse"
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "redshift" {
  name        = "shopstream-${var.environment}-redshift"
  description = "Allow Redshift Serverless connections"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Redshift port from anywhere (dev only)"
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "redshift_copy" {
  name = "shopstream-${var.environment}-redshift-copy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "redshift_copy_s3" {
  name = "s3-read-access"
  role = aws_iam_role.redshift_copy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadFromPublicDatasets"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          "arn:aws:s3:::awssampledbuswest2",
          "arn:aws:s3:::awssampledbuswest2/*"
        ]
      }
    ]
  })
}

resource "aws_redshiftserverless_namespace" "main" {
  namespace_name      = "shopstream-${var.environment}"
  db_name             = "shopstream"
  admin_username      = "admin"
  admin_user_password = var.redshift_admin_password

  iam_roles = [aws_iam_role.redshift_copy.arn]
}

resource "aws_redshiftserverless_workgroup" "main" {
  namespace_name      = aws_redshiftserverless_namespace.main.namespace_name
  workgroup_name      = "shopstream-${var.environment}-wg"
  base_capacity       = 8
  publicly_accessible = true
  subnet_ids          = slice(data.aws_subnets.default.ids, 0, 3)
  security_group_ids  = [aws_security_group.redshift.id]
}
