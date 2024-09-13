const pm2 = require('pm2');

pm2.connect(() => {
  pm2.start({
    script: 'C:\andon-jfa-project-finish\spring-boot-api-nodemcu-jwt-token\target\nodemcu-0.0.1-SNAPSHOT.jar',
    name: 'spring-boot-app',
    exec_mode: 'fork',
    max_memory_restart: '512M', 
  }, (err, apps) => {
    pm2.disconnect();
    if (err) throw err;
  });
});
