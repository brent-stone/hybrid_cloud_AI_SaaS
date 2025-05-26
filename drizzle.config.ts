import type {Config} from "drizzle-kit";

export default {
  "dbCredentials": {
    "databaseId": process.env.CF_DATABASE_ID!,
    "accountId": process.env.CF_ACCOUNT_ID!,
    "token": process.env.CF_API_TOKEN!,
  },
  "dialect": "sqlite",
  "driver": "d1-http",
  "out": "./drizzle",
  "schema": "./database/schema.ts",
} satisfies Config;
