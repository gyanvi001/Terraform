# Terraform Code to Create AWS Infrastructure for Fraud Detection Pipeline

provider "aws" {
  region = "us-east-1"
}

# 1. Lambda Functions
resource "aws_lambda_function" "transaction_generator" {
  function_name = "SampleBankingTransactionGenerator"
  filename      = "lambda/transaction_generator.zip"
  handler       = "index.handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "flagged_account_generator" {
  function_name = "SampleFlaggedAccountGenerator"
  filename      = "lambda/flagged_account_generator.zip"
  handler       = "index.handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "trigger_flagged" {
  function_name = "TriggerFlaggedTransactions"
  filename      = "lambda/trigger_flagged.zip"
  handler       = "index.handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

# 2. IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 3. DynamoDB Table
resource "aws_dynamodb_table" "flagged_transactions" {
  name           = "FlaggedTransactions"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "transaction_id"

  attribute {
    name = "transaction_id"
    type = "S"
  }
}

# 4. MSK (Kafka) Clusters for Topics (simplified)
resource "aws_msk_cluster" "main" {
  cluster_name           = "fraud-detection-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3
  broker_node_group_info {
    instance_type = "kafka.m5.large"
    client_subnets = ["subnet-xxxxxx"]
    security_groups = ["sg-xxxxxx"]
  }
  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }
}

# 5. KDA Flink Application (placeholder)
resource "aws_kinesisanalyticsv2_application" "flink_filter" {
  name        = "FilterTransactionsOnFlaggedAccounts"
  runtime_environment = "FLINK-1_11"
  service_execution_role = aws_iam_role.lambda_exec.arn
  application_configuration {
    application_code_configuration {
      code_content {
        text_content = file("kda_app/flink_app_code.sql")
      }
      code_content_type = "PLAINTEXT"
    }
  }
}

# 6. CloudWatch Event Rule (Trigger Lambda)
resource "aws_cloudwatch_event_rule" "trigger" {
  name        = "SampleTriggerRule"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.trigger.name
  target_id = "SampleLambdaTarget"
  arn       = aws_lambda_function.transaction_generator.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transaction_generator.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.trigger.arn
}
