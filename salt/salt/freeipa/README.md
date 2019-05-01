# Freeipa formula

### Components

* docker formula # Requirenment
* freeipa-server image

### Server top.sls

```
freeipa.server
```

### Server pillar

```yaml
freeipa-server-pillar:
  domain: IPA DOMAN
  server: IPA SERVER
  serverip: SERVER IP
  realm: REALM
  admin-pass: SECRET
  ds-pass: SECRET
```

### Client pillar
```yaml
freeipa-client-pillar:
  domain: IPA DOMAN
  server: IPA SERVER
  realm: REALM
  user: USERNAME
  pass: PASSWORD
  ntp: NTP SERVER
  smart-refresh: SUDO REFRESH TIME PARTLY
  full-refresh: FULL SUDO REFRESH TIME
```