# Default settings for MySQL
# The settings below are geared towards a local database.
# That means a database that is not running as a system service.
# I sometimes find it useful to work on a user-specific MySQL database that isn't a global service.
# Remember to perform this during a fresh installation (it replaces `mysql_secure_installation`):
#
# Execute: `mysql_install_db`.
# Execute: `{ mysqld & } && sleep 2 && mysql`
# Run:
# DELETE FROM mysql.user WHERE User='';
# DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
# DROP DATABASE test;
# DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
# FLUSH PRIVILEGES;
# Then you're in a local MySQL, enjoy!
# By the way, the above makes sure that root can only login on localhost.
# To do a remote login, just use SSH as a proxy first.
# Finish: mysqladmin shutdown

[client]
user=root
port=3306
socket="/tmp/mysql.sock"

[mysql]
pager="less --quit-if-one-screen --no-init --LONG-PROMPT --HILITE-UNREAD --status-column --chop-long-lines --shift .3"
prompt='Ｍ[\u@\h@\d] » '

[mysqld]
port=3306
socket="/tmp/mysql.sock"
datadir="PH_LOCALDATA/mysql"
tmpdir="/tmp"

# Use `\G` instead of `;` to produce vertical output.
