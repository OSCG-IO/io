rm -f server.key
openssl genrsa -des3 -out server.key 2048
openssl rsa -in server.key -out server.key
chmod 400 server.key
#sudo chown $USER:$USER server.key
openssl req -new -key server.key -days 365 -out server.crt -x509 -subj '/C=US/ST=Virginia/L=Alexandria/O=STelthy.io/CN=stelthy.io/emailAddress=info@stelthy.io'
cp server.crt root.crt
