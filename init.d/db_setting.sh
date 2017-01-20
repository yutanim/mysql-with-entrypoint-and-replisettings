#! /bin/bash


if [ ${IS_SLAVE} -eq 1 ] ; then
    echo "Wait until ${MASTER_HOST} database is ready..."
    until mysqladmin ping -h ${MASTER_HOST} -usprsys -psprsys
    do
          echo "waiting..."
          sleep 1
    done
    mysql -uroot -proot -h ${MASTER_HOST} -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    
    mysql -uroot -proot -h ${MASTER_HOST} -e "GRANT ALL ON *.* TO '${MYSQL_USER}'@'%';"
    
    pos=`mysql -uroot -proot -h ${MASTER_HOST} -e "SHOW MASTER STATUS\G"  | awk '/Position/ {print $2}'`
    log_file=`mysql -uroot -p${MYSQL_ROOT_PASSWORD} -h ${MASTER_HOST}  -e "SHOW MASTER STATUS\G" |  awk '/File/ {print $2}'`
    
    # slaveの開始
    mysql -uroot -proot -e "CHANGE MASTER TO MASTER_HOST='${MASTER_HOST}', MASTER_USER='${MYSQL_USER}', MASTER_PASSWORD='${MYSQL_PASSWORD}', MASTER_LOG_FILE='${log_file}', MASTER_LOG_POS=${pos};"
    mysql -uroot -proot -e "start slave"
    echo "slave started"

fi
