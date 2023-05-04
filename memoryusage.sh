#!/bin/bash

# Overall server memory usage
echo "Overall server memory usage:"
free -m | grep Mem | awk '{print $3 " MB used out of " $2 " MB total (" $3/$2*100 "%)"}'

# Top 10 memory usage processes
echo ""
echo "Top 10 memory usage processes:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 11

# Top 10 CPU usage processes
echo ""
echo "Top 10 CPU usage processes:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 11

# Sum of MySQL memory usage
echo ""
echo "Sum of MySQL memory usage:"
mysql_mem=$(ps -C mysql -O rss= | awk '{sum+=$2} END {print sum/1024 " MB"}')
echo $mysql_mem

# Sum of Apache HTTP Server (httpd) memory usage
echo ""
echo "Sum of httpd memory usage:"
httpd_mem=$(ps -C httpd -O rss= | awk '{sum+=$2} END {print sum/1024 " MB"}')
echo $httpd_mem

# Sum of PHP-FPM memory usage
echo ""
echo "Sum of php-fpm memory usage:"
php_fpm_mem=$(ps -C php-fpm -O rss= | awk '{sum+=$2} END {print sum/1024 " MB"}')
echo $php_fpm_mem

# Sum of nginx Server (nginx) memory usage
echo ""
echo "Sum of nginx memory usage:"
nginx_mem=$(ps -C nginx -O rss= | awk '{sum+=$2} END {print sum/1024 " MB"}')
echo $nginx_mem

# Sum of mariadb Server (mariadb) memory usage
echo ""
echo "Sum of mariadb memory usage:"
mariadb_mem=$(ps -C mariadb -O rss= | awk '{sum+=$2} END {print sum/1024 " MB"}')
echo $mariadb_mem

# Sum of apache2 HTTP Server (httpd) memory usage
echo ""
echo "Sum of apache2 memory usage:"
apache_mem=$(ps -C apache -O rss= | awk '{sum+=$2} END {print sum/1024 " MB"}')
echo $apache_mem

# Get the process IDs and virtual memory usage for all processes
ps -eo pid,vsz,args --sort -vsz | head

# Alternatively, you can use the following command to show the top 10 processes by virtual memory usage
# ps -eo pid,vsz,args --sort -vsz | head -n 11
