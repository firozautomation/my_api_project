function() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'qa106';
  }
  var config = {
    env: env,
    serverUrl: 'https://qa106.aconex.com',
    documentRelationshipBaseUrl: 'https://qa106.aconex.com/api/document-relationships'
  };

  if (env == 'qa108') {
    // customize
    // e.g. config.foo = 'bar';
      config.serverUrl: 'https://qa108.aconex.com';
      config.documentRelationshipBaseUrl: 'https://qa108.aconex.com/api/document-relationships';
  } else if (env == 'ops1') {

      // customize

      karate.configure('connectTimeout', 5000);
  }
  return config;
}