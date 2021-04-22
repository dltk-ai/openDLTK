keytool -genkeypair -alias jwttoken -keyalg RSA -keypass PASSWORD -keystore jwttoken.jks -storepass PASSWORD

keytool -importkeystore -srckeystore jwttoken.jks -destkeystore jwttoken.jks -deststoretype pkcs12

keytool -list -rfc --keystore jwttoken.jks | openssl x509 -inform pem -pubkey -noout > jwttoken.pub