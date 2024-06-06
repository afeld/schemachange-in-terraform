locals {
  sql_root = "${path.module}/../sql"

  # use the basename of the file as the key (since "schemachange only pays attention to the filenames, not the paths"), the value as the full path
  # https://github.com/Snowflake-Labs/schemachange?tab=readme-ov-file#folder-structure

  repeatable_files = fileset(local.sql_root, "**/R__*.sql")
  repeatable_map   = { for filename in local.repeatable_files : basename(filename) => "${local.sql_root}/${filename}" }

  versioned_files = fileset(local.sql_root, "**/V*__*.sql")
  versioned_map   = { for filename in local.versioned_files : basename(filename) => "${local.sql_root}/${filename}" }

  always_files = fileset(local.sql_root, "**/A__*.sql")
  always_map   = { for filename in local.always_files : basename(filename) => "${local.sql_root}/${filename}" }
}


# in theory, the snowflake_unsafe_execute resource would have more direct, but it was giving me 400 errors
# https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/unsafe_execute

resource "null_resource" "versioned_sql" {
  for_each = local.versioned_map

  # no triggers, since once the resource is created, it shouldn't be executed again

  provisioner "local-exec" {
    command = "snow sql -f ${each.value}"
  }
}

resource "null_resource" "repeatable_sql" {
  for_each = local.repeatable_map

  triggers = {
    sql = file(each.value)
  }

  provisioner "local-exec" {
    command = "snow sql -f ${each.value}"
  }

  # repeatable scripts run after versioned ones
  depends_on = [null_resource.versioned_sql]
}

resource "null_resource" "always_sql" {
  for_each = local.always_map

  triggers = {
    sql = file(each.value)
    # hack to ensure it's always triggered
    # https://ilhicas.com/2019/08/17/Terraform-local-exec-run-always.html
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "snow sql -f ${each.value}"
  }

  # always scripts run after repeatable ones
  depends_on = [null_resource.repeatable_sql]
}
