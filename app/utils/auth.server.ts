import { betterAuth } from "better-auth";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import { drizzle, type DrizzleD1Database } from "drizzle-orm/d1";
import * as schema from "../../database/schema";

const db_type: DrizzleD1Database<typeof schema>;
const db = drizzle(env.DB, { schema });

export const auth = betterAuth({
    database: drizzleAdapter(env.DB, {
        provider: "sqlite", // or "mysql", "sqlite", "pg"
    })
});