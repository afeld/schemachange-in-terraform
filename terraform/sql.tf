locals {
  sql_root         = "${path.module}/../sql"
  repeatable_files = fileset(local.sql_root, "**/R__*.sql")
}

# in theory, the snowflake_unsafe_execute resource would have more direct, but it was giving me 400 errors
# https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/unsafe_execute
resource "null_resource" "repeatable_sql" {
  for_each = local.repeatable_files

  triggers = {
    sql = file("${local.sql_root}/${each.key}")
  }

  provisioner "local-exec" {
    command = "dotenv run -- snow sql --temporary-connection --authenticator Snowflake -f ${local.sql_root}/${each.key}"
  }
}
