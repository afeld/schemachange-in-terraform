# Schemachange in Terraform proof of concept

This is a proof of concept implementing [schemachange](https://github.com/Snowflake-Labs/schemachange) in [Terraform](https://www.terraform.io/). Having managed [Snowflake](https://www.snowflake.com/) using both, I thought it would be an interesting exercise to try and bring the two together. The meat of the implementation is in [`terraform/sql.tf`](terraform/sql.tf).

Not looking to spend a lot of time to match the functionality exactly. Do _not_ use this in production.

## Usage

1. Set up the [Snowflake CLI](https://docs.snowflake.com/en/developer-guide/snowflake-cli-v2/index).

   1. Create a [virtual environment](https://docs.python.org/3/library/venv.html).

      ```sh
      python -m venv .venv
      ```

   1. Activate the virtual environment.

      ```sh
      source ./.venv/bin/activate
      ```

   1. [Install the Snowflake CLI.](https://docs.snowflake.com/en/developer-guide/snowflake-cli-v2/installation/installation#how-to-install-sf-cli-using-pip-pypi)
   1. [Configure the Snowflake CLI.](https://docs.snowflake.com/en/developer-guide/snowflake-cli-v2/connecting/specify-credentials#how-to-add-credentials-using-a-sf-cli-connection-command) Call the connection `default`.

1. Run Terraform. (`-parallelism=1` is set to match schemachange's behavior of only running a single script at a time.)

   ```sh
   cd terraform
   terraform init
   terraform apply -parallelism=1
   ```

## Advantages over schemachange

- When files change, it shows a diff in the plan.
- You see the result of each query.
- It can be integrated with other Terraform resources.
- You could add dependencies between scripts/resources through [`depends_on`](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on).

## Disadvantages

- Known bugs around [versioned scripts](https://github.com/Snowflake-Labs/schemachange?tab=readme-ov-file#versioned-script-naming):
  - It will treat filenames of a `V` followed by anything as a versioned script, not just those with digit(s).
  - They aren't guaranteed to execute in order. [There isn't a great way to do so in Terraform.](https://discuss.hashicorp.com/t/for-each-depends-on-previous-item/14351)
- At time of writing, [the Snowflake CLI doesn't support MFA caching](https://github.com/snowflakedb/snowflake-cli/issues/1163).
