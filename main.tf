resource "aws_lambda_event_source_mapping" "trigger" {
  event_source_arn = var.source_arn
  function_name = var.function.arn
  maximum_retry_attempts = 0
  batch_size = 1
  starting_position = "LATEST"
}

data "aws_iam_policy_document" "dynamo" {
  statement {
    effect = Allow
    actions = [ "dynamodb:GetRecords" ]
    resources = [ var.source_arn ]
    // Resource": "arn:aws:dynamodb:us-west-2:123456789012:table/GameScores/stream/*"
  }
}

resource "aws_iam_policy" "dynamo" {
  policy = data.aws_iam_policy_document.dynamo.json
}

resource "aws_iam_role_policy_attachment" "dynamo" {
  policy_arn = aws_iam_policy.dynamo.arn
  role = var.function.role
}