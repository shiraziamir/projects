# Salt formulas

### Install salt master
```
echo "deb http://reg.d.com/salt stretch main" > /etc/apt/sources.list.d/salt.list
wget -O - http://reg.d.com/keys/SALTSTACK-GPG-KEY.pub | apt-key add -
apt-get update 
apt-get install -y salt-master
```
#### Important configs:
```
# cat /etc/salt/master
user: gitlab-runner # user to run salt master
file_roots:
  base:
    - /srv/salt # path to salt formulas
pillar_roots:
  base:
    - /srv/labrat/pillar # path to pillar variables
```
### Install salt minion
```
echo "deb http://reg.d.com/salt stretch main" > /etc/apt/sources.list.d/salt.list
wget -O - http://reg.d.com/keys/SALTSTACK-GPG-KEY.pub | apt-key add -
apt-get update 
apt-get install -y salt-minion
echo "master: SALT_MASTER_HOST" > /etc/salt/minion
systemctl restart salt-minion
```
To approve salt minion key in salt master
```
salt-key
# Get minion id key
salt-key -a SALT_MINION_ID
```
To test the communication between salt master and salt minion
```
salt 'SALT_MIONION_ID' test.ping
# Should get true
```

Put these formulas into the file_roots base
