import migrate from './migrate.js'
import getConfigFromEnv from './utils/getConfigFromEnv.js'

async function main() {
  await migrate(getConfigFromEnv());
}
main();
