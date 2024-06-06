# Schemachange in Terraform proof of concept

This is a proof of concept implementing [schemachange](https://github.com/Snowflake-Labs/schemachange) in [Terraform](https://www.terraform.io/) as a way to manage resources in [Snowflake](https://www.snowflake.com/). The meat of the implementation is in [`terraform/sql.tf`](terraform/sql.tf).

## Usage

1. Create a [virtual environment](https://docs.python.org/3/library/venv.html).

   ```sh
   python -m venv .venv
   ```

1. Activate the virtual environment.

   ```sh
   source ./.venv/bin/activate
   ```

1. Install dependencies.

   ```sh
   pip install -r requirements.txt
   ```

1. [Configure the Snowflake CLI.](https://docs.snowflake.com/en/developer-guide/snowflake-cli-v2/connecting/specify-credentials#how-to-add-credentials-using-a-sf-cli-connection-command) Call the connection `default`.
1. Go into the `terraform/` directory.

   ```sh
   cd terraform
   ```

1. Run Terraform.

   ```sh
   terraform init
   terraform apply
   ```

## Advantages over schemachange

- When files change, it shows a diff in the plan.
- You see the result of each query.
- It can be integrated with other Terraform resources.
- You could add dependencies between scripts/resources through [`depends_on`](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on).

## Disadvantages

- At time of writing, [the Snowflake CLI doesn't support MFA caching](https://github.com/snowflakedb/snowflake-cli/issues/1163).
