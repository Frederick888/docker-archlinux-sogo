# [SOGo](https://sogo.nu/) Docker images based on Arch Linux
The original author is [Frederick888](https://github.com/Frederick888/docker-archlinux-sogo)

### Usage


the http service is running under the tcp port 20001, apache does a reverse proxy to SOGo tcp 20000, the port 20000 is not needed to be opened.

```sh
docker run -d --name sogo --restart always \
    --publish 127.0.0.1:20000:20000 \
    --publish 127.0.0.1:20001:20001 \
    -v ./sogo.conf:/etc/sogo/sogo.conf:Z \
    -v ./SOGo.conf:/etc/httpd/conf/extra/SOGo.conf:Z \
    -v ./sogo:/etc/cron.d/sogo:Z \
    stephdl/sogo:latest
```

Alternatively,

```sh
docker run -d --name sogo --restart always --network host \
    -v /srv/sogo:/etc/sogo \
    stephdl/sogo:latest
```
...however it may raise some security concerns.

### Credits
https://aur.archlinux.org/packages/sogo/  
https://aur.archlinux.org/packages/sope/  


Example of configuration files

`/etc/sogo/sogo.conf`

```
{
  /* *********************  Main SOGo configuration file  **********************
   *                                                                           *
   * Since the content of this file is a dictionary in OpenStep plist format,  *
   * the curly braces enclosing the body of the configuration are mandatory.   *
   * See the Installation Guide for details on the format.                     *
   *                                                                           *
   * C and C++ style comments are supported.                                   *
   *                                                                           *
   * This example configuration contains only a subset of all available        *
   * configuration parameters. Please see the installation guide more details. *
   *                                                                           *
   * ~sogo/GNUstep/Defaults/.GNUstepDefaults has precedence over this file,    *
   * make sure to move it away to avoid unwanted parameter overrides.          *
   *                                                                           *
   * **************************************************************************/

  /* Database configuration (mysql://, postgresql:// or oracle://) */
  //SOGoProfileURL = "postgresql://sogo:sogo@localhost:5432/sogo/sogo_user_profile";
  //OCSFolderInfoURL = "postgresql://sogo:sogo@localhost:5432/sogo/sogo_folder_info";
  //OCSSessionsFolderURL = "postgresql://sogo:sogo@localhost:5432/sogo/sogo_sessions_folder";

  /* Mail */
  //SOGoDraftsFolderName = Drafts;
  //SOGoSentFolderName = Sent;
  //SOGoTrashFolderName = Trash;
  //SOGoJunkFolderName = Junk;
  //SOGoIMAPServer = "localhost";
  //SOGoSieveServer = "sieve://127.0.0.1:4190";
  //SOGoSMTPServer = "smtp://127.0.0.1";
  //SOGoMailDomain = acme.com;
  //SOGoMailingMechanism = smtp;
  //SOGoForceExternalLoginWithEmail = NO;
  //SOGoMailSpoolPath = /var/spool/sogo;
  //NGImap4AuthMechanism = "plain";
  //NGImap4ConnectionStringSeparator = "/";

  /* Notifications */
  //SOGoAppointmentSendEMailNotifications = NO;
  //SOGoACLsSendEMailNotifications = NO;
  //SOGoFoldersSendEMailNotifications = NO;

  /* Authentication */
  //SOGoPasswordChangeEnabled = YES;

  /* LDAP authentication example */
  //SOGoUserSources = (
  //  {
  //    type = ldap;
  //    CNFieldName = cn;
  //    UIDFieldName = uid;
  //    IDFieldName = uid; // first field of the DN for direct binds
  //    bindFields = (uid, mail); // array of fields to use for indirect binds
  //    baseDN = "ou=users,dc=acme,dc=com";
  //    bindDN = "uid=sogo,ou=users,dc=acme,dc=com";
  //    bindPassword = qwerty;
  //    canAuthenticate = YES;
  //    displayName = "Shared Addresses";
  //    hostname = "ldap://127.0.0.1:389";
  //    id = public;
  //    isAddressBook = YES;
  //  }
  //);

  /* LDAP AD/Samba4 example */
  //SOGoUserSources = (
  //  {
  //    type = ldap;
  //    CNFieldName = cn;
  //    UIDFieldName = sAMAccountName;
  //    baseDN = "CN=users,dc=domain,dc=tld";
  //    bindDN = "CN=sogo,CN=users,DC=domain,DC=tld";
  //    bindFields = (sAMAccountName, mail);
  //    bindPassword = password;
  //    canAuthenticate = YES;
  //    displayName = "Public";
  //    hostname = "ldap://127.0.0.1:389";
  //    filter = "mail = '*'";
  //    id = directory;
  //    isAddressBook = YES;
  //  }
  //);


  /* SQL authentication example */
  /*  These database columns MUST be present in the view/table:
   *    c_uid - will be used for authentication -  it's the username or username@domain.tld)
   *    c_name - which can be identical to c_uid -  will be used to uniquely identify entries
   *    c_password - password of the user, plain-text, md5 or sha encoded for now
   *    c_cn - the user's common name - such as "John Doe"
   *    mail - the user's mail address
   *  See the installation guide for more details
   */
  //SOGoUserSources =
  //  (
  //    {
  //      type = sql;
  //      id = directory;
  //      viewURL = "postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_view";
  //      canAuthenticate = YES;
  //      isAddressBook = YES;
  //      userPasswordAlgorithm = md5;
  //    }
  //  );

  /* Web Interface */
  //SOGoPageTitle = SOGo;
  //SOGoVacationEnabled = YES;
  //SOGoForwardEnabled = YES;
  //SOGoSieveScriptsEnabled = YES;
  //SOGoMailAuxiliaryUserAccountsEnabled = YES;
  //SOGoTrustProxyAuthentication = NO;
  //SOGoXSRFValidationEnabled = NO;

  /* General - SOGoTimeZone *MUST* be defined */
  //SOGoLanguage = English;
  //SOGoTimeZone = America/Montreal;
  //SOGoCalendarDefaultRoles = (
  //  PublicDAndTViewer,
  //  ConfidentialDAndTViewer
  //);
  //SOGoSuperUsernames = (sogo1, sogo2); // This is an array - keep the parens!
  //SxVMemLimit = 384;
  //WOPidFile = "/var/run/sogo/sogo.pid";
  //SOGoMemcachedHost = "/var/run/memcached.sock";
  
  /* Debug */
  //SOGoDebugRequests = YES;
  //SoDebugBaseURL = YES;
  //ImapDebugEnabled = YES;
  //LDAPDebugEnabled = YES;
  //PGDebugEnabled = YES;
  //MySQL4DebugEnabled = YES;
  //SOGoUIxDebugEnabled = YES;
  //WODontZipResponse = YES;
  //WOLogFile = /var/log/sogo/sogo.log;
}
```


`/etc/httpd/conf/extra/SOGo.conf`

```Alias /SOGo.woa/WebServerResources/ \
      /usr/lib/GNUstep/SOGo/WebServerResources/
Alias /SOGo/WebServerResources/ \
      /usr/lib/GNUstep/SOGo/WebServerResources/

<Directory /usr/lib/GNUstep/SOGo/>
    AllowOverride None

    <IfVersion < 2.4>
        Order deny,allow
        Allow from all
    </IfVersion>
    <IfVersion >= 2.4>
        Require all granted
    </IfVersion>

    # Explicitly allow caching of static content to avoid browser specific behavior.
    # A resource's URL MUST change in order to have the client load the new version.
    <IfModule expires_module>
      ExpiresActive On
      ExpiresDefault "access plus 1 year"
    </IfModule>
</Directory>

# Don't send the Referer header for cross-origin requests
Header always set Referrer-Policy "same-origin"

<Location /SOGo>
  # Don't cache dynamic content
  Header set Cache-Control "max-age=0, no-cache, no-store"
</Location>

## Uncomment the following to enable proxy-side authentication, you will then
## need to set the "SOGoTrustProxyAuthentication" SOGo user default to YES and
## adjust the "x-webobjects-remote-user" proxy header in the "Proxy" section
## below.
#
## For full proxy-side authentication:
#<Location /SOGo>
#  AuthType XXX
#  Require valid-user
#  SetEnv proxy-nokeepalive 1
#  Allow from all
#</Location>
#
## For proxy-side authentication only for CardDAV and GroupDAV from external
## clients:
#<Location /SOGo/dav>
#  AuthType XXX
#  Require valid-user
#  SetEnv proxy-nokeepalive 1
#  Allow from all
#</Location>

ProxyRequests Off
ProxyPreserveHost On
SetEnv proxy-nokeepalive 1

# Uncomment the following lines if you experience "Bad gateway" errors with mod_proxy
#SetEnv proxy-initial-not-pooled 1
#SetEnv force-proxy-request-1.0 1

# When using CAS, you should uncomment this and install cas-proxy-validate.py
# in /usr/lib/cgi-bin to reduce server overloading
#
# ProxyPass /SOGo/casProxy http://localhost/cgi-bin/cas-proxy-validate.py
# <Proxy http://localhost/app/cas-proxy-validate.py>
#   Order deny,allow
#   Allow from your-cas-host-addr
# </Proxy>

# Redirect / to /SOGo
#RedirectMatch ^/$ https://mail.yourdomain.com/SOGo

# Enable to use Microsoft ActiveSync support
# Note that you MUST have many sogod workers to use ActiveSync.
# See the SOGo Installation and Configuration guide for more details.
#
#ProxyPass /Microsoft-Server-ActiveSync \
# http://127.0.0.1:20000/SOGo/Microsoft-Server-ActiveSync \
# retry=60 connectiontimeout=5 timeout=360

ProxyPass /SOGo http://127.0.0.1:20000/SOGo retry=0 nocanon

<Proxy http://127.0.0.1:20000/SOGo>
## Adjust the following to your configuration
## and make sure to enable the headers module
  <IfModule headers_module>
    RequestHeader set "x-webobjects-server-port" "443"
    SetEnvIf Host (.*) HTTP_HOST=$1
    RequestHeader set "x-webobjects-server-name" "%{HTTP_HOST}e" env=HTTP_HOST
    RequestHeader set "x-webobjects-server-url" "https://%{HTTP_HOST}e" env=HTTP_HOST

## When using proxy-side autentication, you need to uncomment and
## adjust the following line:
    RequestHeader unset "x-webobjects-remote-user"
#    RequestHeader set "x-webobjects-remote-user" "%{REMOTE_USER}e" env=REMOTE_USER

    RequestHeader set "x-webobjects-server-protocol" "HTTP/1.0"
  </IfModule>

  AddDefaultCharset UTF-8

  Order allow,deny
  Allow from all
</Proxy>

# For Apple autoconfiguration
<IfModule rewrite_module>
  RewriteEngine On
  RewriteRule ^/.well-known/caldav/?$ /SOGo/dav [R=301]
  RewriteRule ^/.well-known/carddav/?$ /SOGo/dav [R=301]
</IfModule>
```

`/etc/cron.d/sogo`

```
# Sogod cronjobs

# Vacation messages expiration
# The credentials file should contain the sieve admin credentials (username:passwd)
0 0 * * *      sogo	/usr/sbin/sogo-tool update-autoreply -p /etc/sogo/sieve.creds

# Session cleanup - runs every minute
#   - Ajust the nbMinutes parameter to suit your needs
# Example: Sessions without activity since 60 minutes will be dropped:
* * * * *      sogo	/usr/sbin/sogo-tool expire-sessions 60

# Email alarms - runs every minutes
# If you need to use SMTP AUTH for outgoing mails, specify credentials to use
# with '-p /path/to/credentialsFile' (same format as the sieve credentials)
* * * * *      sogo	/usr/sbin/sogo-ealarms-notify > /dev/null 2>&1

# Daily backups
#   - writes to ~sogo/backups/ by default
#   - will keep 31 days worth of backups by default
#   - runs once a day by default, but can run more frequently
#   - make sure to set the path to sogo-backup.sh correctly
30 0 * * * sogo /usr/lib/sogo/scripts/sogo-backup.sh
```


### Build
```
docker build -t  stephdl/sogo:5.9.0 .
docker push  stephdl/sogo:5.9.0
```