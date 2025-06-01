#! /bin/bash
# Make sure to run "chmod +x initialize_env.sh" so this script is executable by the current Unix user
# Run this script from a terminal in the project root so the environment variable files are created at
# the project root.
# 1. chmod +x scripts/initialize_env.sh
# 2. ./scripts/initialize_env.sh
# 3. Verify .env and .dev.vars files are in the project root. If not, they were likely created in the parent
#    directory or the /scripts directory.
# Stop execution immediately on a non-zero exit status. This is to better identify the location of errors
set -e

########## Random String Generation Functions ##########
RANDOM_STRING_CORPUS='A-Za-z0-9!%&*+,-./:;<>@^_|~'
# Note, the pwgen utility by the Jack the Ripper author is a more robust solution.
# however, it would require an install making this script less portable. It would also
# potentially include problematic special characters like quotes that will disrupt
# variable substitution in this script, docker compose substitution, and internal
# container logic prior to URL encoding taking place.
# Function to generate a STRING_LENGTH string of characters
rando_string() {
  env LC_ALL=C tr -dc "$RANDOM_STRING_CORPUS" </dev/urandom | head -c 32
}
string_url_encode() {
  echo -ne "$1" | hexdump -v -e '/1 "%02x"' | sed 's/\(..\)/%\1/g'
}
# Used for Minio Access and Secret keygen. Access key is min 3 max 20 chars. Secret is max 40
RANDOM_ALPHANUM_CORPUS="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
rando_minio_access_key() {
  env LC_ALL=C tr -dc "$RANDOM_ALPHANUM_CORPUS" </dev/urandom | head -c 20
}
rando_minio_secret_key() {
  env LC_ALL=C tr -dc "$RANDOM_ALPHANUM_CORPUS" </dev/urandom | head -c 40
}
# Used to control the initial password setup token for the Dask Jupyter server. Must be
# lowercase alphanumeric string of a default length of 48 characters
RANDOM_ALPHANUM_CORPUS_LOWER="0123456789abcdefghijklmnopqrstuvwxyz"
rando_jupyter_token() {
  env LC_ALL=C tr -dc "$RANDOM_ALPHANUM_CORPUS_LOWER" </dev/urandom | head -c 48
}

######### Variable Declarations #############
# Output filenames
ENV_FILE="./.env"
WRANGLER_ENV_FILE="./.dev.vars"

# Used to modify services logging level
LOG_LEVEL="info"

# Cloudflare Settings
CLOUDFLARE_ACCOUNT_ID="<replace-with-account-id>"
CLOUDFLARE_API_TOKEN="<replace-with-api-token>"
CLOUDFLARE_DATABASE_ID="<replace-with-database-id>"
CLOUDFLARE_DATABASE_NAME="<replace-with-database-name>"
CLOUDFLARE_EMAIL="<replace-with-cloudflare-account-email>"
WRANGLER_SEND_METRICS="true"
CLOUDFLARE_API_BASE_URL="https://api.cloudflare.com/client/v4"
WRANGLER_LOG="${LOG_LEVEL}"
WRANGLER_LOG_PATH="../wrangler-log-file.log"

# Better Auth Settings
BETTER_AUTH_SECRET="${BETTER_AUTH_SECRET:-$(rando_string)}"
BETTER_AUTH_URL="http://localhost:5173" #Base URL of your app

######### Output to ENV_FILE #############
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
YELLOW='\033[0;93m'
NO_COLOR='\033[0m'
# Check if .env file already exists
if [ -f $ENV_FILE ]; then
  echo -e "${YELLOW}$ENV_FILE file already exists${NO_COLOR}. To reset, remove it then \
re-run this script."
# If not, initialize it with new key:value pairs
else
  # Create the .env file
  touch $ENV_FILE

  # Write to the file
  {
    echo "# Valid log level values: 'critical', 'error', 'warning', 'info', 'debug'";
    echo "LOG_LEVEL=${LOG_LEVEL}";

    echo -e "\n# For drizzle.config.ts";
    echo "CLOUDFLARE_ACCOUNT_ID=${CLOUDFLARE_ACCOUNT_ID}";
    echo "CLOUDFLARE_API_TOKEN=${CLOUDFLARE_API_TOKEN}";
    echo "CLOUDFLARE_DATABASE_ID=${CLOUDFLARE_DATABASE_ID}";

    echo -e "\n# Additional Cloudflare Settings";
    echo "# Official example .env file at:";
    echo "# https://developers.cloudflare.com/workers/wrangler/system-environment-variables/#example-env-file";
    echo "CLOUDFLARE_DATABASE_NAME=${CLOUDFLARE_DATABASE_NAME}";
    echo "CLOUDFLARE_EMAIL=${CLOUDFLARE_EMAIL}";
    echo "WRANGLER_SEND_METRICS=${WRANGLER_SEND_METRICS}";
    echo "CLOUDFLARE_API_BASE_URL=${CLOUDFLARE_API_BASE_URL}";
    echo "WRANGLER_LOG=${WRANGLER_LOG}";
    echo "WRANGLER_LOG_PATH=${WRANGLER_LOG_PATH}";

    echo -e "\n# Better Auth Settings";
    echo "BETTER_AUTH_SECRET=${BETTER_AUTH_SECRET}";
    echo "BETTER_AUTH_URL=${BETTER_AUTH_URL}";
  } >> $ENV_FILE
fi

# Check if a Wrangler .dev.vars file already exists
if [ -f $WRANGLER_ENV_FILE ]; then
  echo -e "${YELLOW}$WRANGLER_ENV_FILE file already exists${NO_COLOR}. To reset, remove \
it then re-run this script."
# If not, initialize it with new key:value pairs
else
  # Create the .env file
  touch $WRANGLER_ENV_FILE

  # Write to the file
  {
    echo "# Valid log level values: 'critical', 'error', 'warning', 'info', 'debug'";
    echo "LOG_LEVEL=${LOG_LEVEL}";

    echo -e "\n# For drizzle.config.ts";
    echo "CLOUDFLARE_ACCOUNT_ID=${CLOUDFLARE_ACCOUNT_ID}";
    echo "CLOUDFLARE_API_TOKEN=${CLOUDFLARE_API_TOKEN}";
    echo "CLOUDFLARE_DATABASE_ID=${CLOUDFLARE_DATABASE_ID}";

    echo -e "\n# Additional Cloudflare Settings";
    echo "# Official example .env file at:";
    echo "# https://developers.cloudflare.com/workers/wrangler/system-environment-variables/#example-env-file";
    echo "CLOUDFLARE_DATABASE_NAME=${CLOUDFLARE_DATABASE_NAME}";
    echo "CLOUDFLARE_EMAIL=${CLOUDFLARE_EMAIL}";
    echo "WRANGLER_SEND_METRICS=${WRANGLER_SEND_METRICS}";
    echo "CLOUDFLARE_API_BASE_URL=${CLOUDFLARE_API_BASE_URL}";
    echo "WRANGLER_LOG=${WRANGLER_LOG}";
    echo "WRANGLER_LOG_PATH=${WRANGLER_LOG_PATH}";

    echo -e "\n# Better Auth Settings";
    echo "BETTER_AUTH_SECRET=${BETTER_AUTH_SECRET}";
    echo "BETTER_AUTH_URL=${BETTER_AUTH_URL}";
  } >> $WRANGLER_ENV_FILE
fi