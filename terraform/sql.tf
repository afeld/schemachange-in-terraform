locals {
  path = "${path.module}/../sql/R__setup.sql"
  sql  = file(local.path)
}

# in theory, the snowflake_unsafe_execute resource would have more direct, but it was giving me 400 errors
# https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/unsafe_execute
resource "null_resource" "sql" {
  triggers = {
    sql = local.sql
  }

  provisioner "local-exec" {
    command = "dotenv run -- snow sql --temporary-connection --authenticator Snowflake -f ${local.path}"
  }
}
