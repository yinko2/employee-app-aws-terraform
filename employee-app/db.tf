resource "aws_dynamodb_table" "employee_db" {
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  name         = "Employees"
  table_class  = "STANDARD"

  attribute {
    name = "id"
    type = "S"
  }
}