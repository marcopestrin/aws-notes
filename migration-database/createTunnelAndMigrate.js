import tunnel from 'tunnel-ssh';
import migrate from './migrate.js'
import getConfigFromEnv from './utils/getConfigFromEnv.js'

const { bastionHost, postgresServer, port, privateKey, ssh_username } = process.env

if ([bastionHost, postgresServer, port, privateKey].some(x => !Boolean(x))) {
  throw Error(`Required env variable for tunnel-ssh is not defined.`);
}

var tnlConfig = {
  username: ssh_username || 'ubuntu',
  privateKey,
  host: bastionHost,
  port: 22,
  dstHost: postgresServer,
  dstPort: 5432,
  localHost: '127.0.0.1',
  localPort: port,
  keepAlive: true
};

tunnel(tnlConfig, async (error, server) => {
  if (error) {
    console.error('error', error);
    throw error;
  };

  await migrate(getConfigFromEnv());
  console.log('migration done');

  setTimeout(() => {
    console.log('closing connection');
    server.close();
  }, 1000);
});
