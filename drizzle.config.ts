import type { Config } from "drizzle-kit";

export default {
  "dbCredentials": {
    "databaseId": process.env.CLOUDFLARE_DATABASE_ID!,
    "accountId": process.env.CLOUDFLARE_ACCOUNT_ID!,
    "token": process.env.CLOUDFLARE_API_TOKEN!,
  },
  "dialect": "sqlite",
  "driver": "d1-http",
  "out": "./drizzle",
  "schema": "./database/schema.ts",
} satisfies Config;
