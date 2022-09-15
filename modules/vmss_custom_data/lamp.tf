locals {
  custom_data = <<CUSTOM_DATA
  #cloud-config
package_upgrade: true

write_files:
- path: /tmp/wp-config.php
  content: |
      <?php
      /**
      * The base configuration for WordPress
      *
      * The wp-config.php creation script uses this file during the installation.
      * You don't have to use the web site, you can copy this file to "wp-config.php"
      * and fill in the values.
      *
      * This file contains the following configurations:
      *
      * * Database settings
      * * Secret keys
      * * Database table prefix
      * * ABSPATH
      *
      * @link https://wordpress.org/support/article/editing-wp-config-php/
      *
      * @package WordPress
      */

      // ** Database settings - You can get this info from your web host ** //
      /** The name of the database for WordPress */
      define( 'DB_NAME', 'wordpressdb' );

      /** Database username */
      define( 'DB_USER', '${var.mysqlAdminLogin}' );

      /** Database password */
      define( 'DB_PASSWORD', '${var.mysqlAdminPassword}' );

      /** Database hostname */
      define( 'DB_HOST', '${var.mysqlServerName}.mysql.database.azure.com' );

      /** Database charset to use in creating database tables. */
      define( 'DB_CHARSET', 'utf8mb4' );

      /** The database collate type. Don't change this if in doubt. */
      define( 'DB_COLLATE', '' );

      /**#@+
      * Authentication unique keys and salts.
      *
      * Change these to different unique phrases! You can generate these using
      * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
      *
      * You can change these at any point in time to invalidate all existing cookies.
      * This will force all users to have to log in again.
      *
      * @since 2.6.0
      */
      define('AUTH_KEY',         'FQI#{BXS(nYD(X6OuPYNJO;]|;NR_Y{EJ6eOb&=Z{Abv6^|5*gS0f$0d-f:#=!d,');
      define('SECURE_AUTH_KEY',  'djRs:x$+UmPZas}uA+1rIU7N.AfmBQcNpD(fvs8YpMf>OAV/VZwG%4o%G:xhq]ms');
      define('LOGGED_IN_KEY',    '}>M2N*cW!QyjhouqI!l{RVt[bG|mb|`<UJUm7To[$Q.^{I~|FPoEJ {WQ;r.|lU$');
      define('NONCE_KEY',        'MY}>y<);FB>t6fME+L;N*N*}@GAM-=2<T6jQnNV&H_/S-NQU#FrSYUP&B ]ozBG}');
      define('AUTH_SALT',        '+{W!-LJqWY#~(VU--/0(Ep?lk!ynt7y=d@XIvq+o+b~fSP1j(ct0Jrpdzl&Lp@fr');
      define('SECURE_AUTH_SALT', 'L|HWlLXy%d0]#Mw)q|70~?dMRf#,GMvYvt,KIYf`fhQgZW:Ky@3k(pZ!W%-i`2t-');
      define('LOGGED_IN_SALT',   'Y}cHNTmY8Eg5i}U&mZ4g!QXvB!@Z6G|vB(t($1}tk!5LLEL8([+1j0Z~qn|K[`0K');
      define('NONCE_SALT',       'km<A*N[IjkL(mF^gYl6W_k[K|;VU>!-*$^zjk;#(0+?0&oa;1+A!bK0)OnU6h2B7');

      /**#@-*/

      /**
      * WordPress database table prefix.
      *
      * You can have multiple installations in one database if you give each
      * a unique prefix. Only numbers, letters, and underscores please!
      */
      $table_prefix = 'wp_';

      /**
      * For developers: WordPress debugging mode.
      *
      * Change this to true to enable the display of notices during development.
      * It is strongly recommended that plugin and theme developers use WP_DEBUG
      * in their development environments.
      *
      * For information on other constants that can be used for debugging,
      * visit the documentation.
      *
      * @link https://wordpress.org/support/article/debugging-in-wordpress/
      */
      define( 'WP_DEBUG', false );

      /* Add any custom values between this line and the "stop editing" line. */



      /* That's all, stop editing! Happy publishing. */

      /** Absolute path to the WordPress directory. */
      if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
      }

      /** Sets up WordPress vars and included files. */
      require_once ABSPATH . 'wp-settings.php';

runcmd: 
  - sudo apt-get update
  - sudo apt-get install apache2 php php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip php-fpm php-mysql libapache2-mod-php -y
  - sudo wget http://wordpress.org/latest.tar.gz -P /data/wordpress
  - tar xzvf /data/wordpress/latest.tar.gz -C /var/www/html/ --strip-components=1
  - cp /tmp/wp-config.php /var/www/html/wp-config.php
  - sudo rm -f /var/www/html/index.html
  - sudo service apache2 reload
  CUSTOM_DATA
}