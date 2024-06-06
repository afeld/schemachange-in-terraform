locals {
  sql_root = "${path.module}/../sql"

  repeatable_files = fileset(local.sql_root, "**/R__*.sql")

  # doesn't strictly limit to digits, but close enough
  versioned_files = fileset(local.sql_root, "**/V*__*.sql")

  always_files = fileset(local.sql_root, "**/A__*.sql")
}

# in theory, the snowflake_unsafe_execute resource would have more direct, but it was giving me 400 errors
# https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/unsafe_execute


resource "null_resource" "versioned_sql" {
  for_each = local.versioned_files

  provisioner "local-exec" {
    command = "snow sql -f ${local.sql_root}/${each.key}"
  }
}

resource "null_resource" "repeatable_sql" {
  for_each = local.repeatable_files

  triggers = {
    sql = file("${local.sql_root}/${each.key}")
  }

  provisioner "local-exec" {
    command = "snow sql -f ${local.sql_root}/${each.key}"
  }

  depends_on = [null_resource.versioned_sql]
}

resource "null_resource" "always_sql" {
  for_each = local.always_files

  triggers = {
    sql = file("${local.sql_root}/${each.key}")
    # https://ilhicas.com/2019/08/17/Terraform-local-exec-run-always.html
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "snow sql -f ${local.sql_root}/${each.key}"
  }

  depends_on = [null_resource.repeatable_sql]
}
