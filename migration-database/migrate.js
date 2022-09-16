import Postgrator from "postgrator";
import pg from "pg";
import { dirname } from "path";
import { fileURLToPath } from "url";


async function migrate(config) {
  const __dirname = dirname(fileURLToPath(import.meta.url));
  const client = new pg.Client(config);

  try {
    await client.connect();
    const postgrator = new Postgrator({
      migrationPattern: __dirname + "/migrations/*",
      driver: "pg",
      database: config.database,
      schemaTable: "migration_versions",
      execQuery: (query) => client.query(query),
    });
    const appliedMigrations = await postgrator.migrate(process.env.migrationUpperLimit);
    console.log('appliedMigrations', appliedMigrations);

  } catch (error) {
    console.error(error.appliedMigrations);
  }

  await client.end();
}

export default migrate;