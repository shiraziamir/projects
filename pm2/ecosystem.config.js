module.exports = {
  apps: [{
    name: 'API',
    script: './build/api/server/index.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'staging',
    },
    env_production: {
      NODE_ENV: 'production',
    },
  }, {
      name: 'WORKER',
      script: './build/jobs/index.js',
      instances: 'max',
      exec_mode: 'cluster',
      env: {
          NODE_ENV: 'staging',
      },
      env_production: {
          NODE_ENV: 'production',
      },
  }],

  deploy: {
    production: {
      user: 'admin',
      host: ['server1', 'server2'],
      ref: 'origin/deployment',
      repo: 'admin@server2:/opt/git/production/backend.git',
      path: '/opt/git/production',
        // Commands to execute locally (on the same machine you deploy things)
        // Can be multiple commands separated by the character ";"
      'pre-deploy-local': "echo 'This is a local executed command'",
      'post-deploy': 'npm install && npm run build && pm2 startOrRestart ecosystem.config.js --env production',
      env: {
          NODE_ENV: 'production',
      },
    },
    staging: {
          user: 'admin',
          host: 'staging.server',
          ref: 'origin/deployment',
          repo: '/opt/git/production/backend.git',
          path: '/opt/git/production',
          'pre-deploy-local': "echo 'This is a local executed command, staging deploy'",
          'post-deploy': 'npm install && npm run build && pm2 delete API && pm2 delete WORKER && pm2 start ecosystem.config.js --env staging',
          env: {
              NODE_ENV: 'staging',
          },
      },
  },
};
