# Cost effecient hybrid-cloud full-stack AI-ready Software as a Service (SaaS) template using Python, TypeScript, and common services
Full-stack "simple and free" on-prem AI/ML Software as a Service (SaaS) deployment reference. The backend uses 
pure-python data & AI ecosystem tooling: FastAPI, Prefect, Dask, RAPIDS, SQLAlchemy. React Router 7, TailwindCSS, and 
BetterAuth frontend. Traefik proxy, Docker Compose, and Cloudflare Tunnels to connect self-hosted services with cloud 
infrastructure.

This project is primarily based on the official [React Router Templates](https://github.com/remix-run/react-router-templates/tree/main)
with some inspiration taken from four other template projects:

* [Forge 42 Base Stack](https://github.com/forge-42/base-stack)
* [The Epic Stack](https://github.com/epicweb-dev/epic-stack)
* [Create T3 App](https://create.t3.gg/)
* [Tanstack](https://tanstack.com/)

## Javascript Development Environment Setup

### Node Version Manager
[Node Version Manager](https://github.com/nvm-sh/nvm) (aka `nvm`) is recommended for managing Node.js and related 
development environment installations.

Once installed, run the following command to install the latest version of Node.js
```bash
nvm install --lts
nvm use node
nvm alias default node
```

Be sure to update your user profile as directed in the output terminal messages. Verify Node.js and 
[Node Package Manager](https://www.npmjs.com/) (aka `npm`) are installed and up to date:
```bash
nvm install-latest-npm
npm --version
nvm list
```

## Cloudflare Environment Setup
Deployment is done using the Wrangler CLI.

First, you need to create a d1 database in Cloudflare.
```bash
npx wrangler d1 create <name-of-your-database>
```

Be sure to update the wrangler.toml file with the correct database name and id.

You will also need to [update the](https://orm.drizzle.team/docs/guides/d1-http-with-drizzle-kit) drizzle.config.ts 
file, and then run the production migration:
```bash
npm run db:migrate-production
```

To test on Cloudflare's infrastructure to get a production-parity test, use 
[Wrangler's remote data mode](https://developers.cloudflare.com/workers/local-development/remote-data/)

```bash
npx wrangler dev --remote
```

To build and deploy directly to production:

```bash
npm run deploy
```

To deploy a preview URL:

```bash
npx wrangler versions upload
```

You can then promote a version to production after verification or roll it out progressively.

```bash
npx wrangler versions deploy
```