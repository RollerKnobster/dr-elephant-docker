#!/bin/bash

db_url=dr-elephant-mysql
db_name=drelephant
db_user=root
db_password="drelephant"

until mysql -h "$db_url" -u$db_user -p$db_password -D$db_name -e'show tables;'; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

sed -i "s/fixJavaKerberos();/fixJavaKerberos();Logger.info(\"Fixed cerberos\");/g" dr-elephant/app/Global.java
sed -i "s/_drElephantThread = new Thread(DrElephant.getInstance());/_drElephantThread = new Thread(DrElephant.getInstance());Logger.info(\"Got instance.\");/g" dr-elephant/app/Global.java
sed -i "s/_drElephantThread.start();/_drElephantThread.start();Logger.info(\"Started.\");/g" dr-elephant/app/Global.java

#db.default.url="jdbc:mysql://localhost/playdb"
#db.default.username=playdbuser
#db.default.password="a strong password"



exec "$@"
