# Schemachange in Terraform proof of concept

To run:

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

1. Create a `terraform/.env` file.
1. Fill out the following:

   ```shell
   SNOWFLAKE_ACCOUNT=...
   SNOWFLAKE_USER=...
   SNOWFLAKE_PASSWORD=...
   SNOWFLAKE_ROLE=...
   ```

1. Go into the `terraform/` directory.

   ```sh
   cd terraform
   ```

1. Run Terraform.

   ```sh
   terraform init
   terraform apply
   ```
