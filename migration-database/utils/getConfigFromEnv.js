
const getConfigFromEnv = () => {
  const configKeys = ['host', 'port', 'database', 'user', 'password'];
  const config = configKeys.reduce((ac, k) => {
    const val = process.env[k];
    if (!val) throw Error(`Required env variable for postgrator"${k}" is not defined.`);
    return { ...ac, [k]: val }
  }, {});
  return config;
}

export default getConfigFromEnv;