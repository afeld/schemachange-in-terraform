-- https://docs.snowflake.com/en/user-guide/security-mfa#using-mfa-token-caching-to-minimize-the-number-of-prompts-during-authentication-optional
ALTER ACCOUNT SET ALLOW_CLIENT_MFA_CACHING = TRUE;
