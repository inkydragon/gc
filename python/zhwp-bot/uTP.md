MySQL

CREATE USER 'mwiki'@'localhost' IDENTIFIED BY 'mw-mariyadb@mysql';
update mysql.user set authentication_string=password('mw-mariyadb@mysql') where user='mwiki'and Host = 'localhost';
mwiki
mw-mariyadb@mysql

debian-sys-maint
kXyjnujueB2f3xWf
