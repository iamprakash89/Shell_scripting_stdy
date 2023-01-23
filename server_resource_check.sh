#/bin/bash

printf "loggedinuser:`whoami`\nhostname:`hostname` \ndate:`date`\n"
echo "disk space:" 
df -ThP| egrep -v 'tmpfs' | awk '{print $1,$5,$6,$7}'
echo "memory usage:"
free -g
