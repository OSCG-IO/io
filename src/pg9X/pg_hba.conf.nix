
# TYPE  DATABASE        USER            CIDR-ADDRESS            METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     md5
# IPv4 local & remote connections:
host    all             all             127.0.0.1/32            md5
host    all             all             0.0.0.0/0               md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
