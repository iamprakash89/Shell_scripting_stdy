#!/bin/bash

mkdir -p /etc/httpd/vhosts.d

# Prompt the user for the domain name
read -p "Enter the domain name: " domain

mkdir -p /var/www/vhosts/$domain/public_html


# Generate the private key
openssl genrsa -out $domain.key 2048

# Generate the certificate signing request (CSR)
openssl req -new -key $domain.key -out $domain.csr -subj "/CN=$domain"

# Generate the self-signed SSL certificate
openssl x509 -req -days 365 -in $domain.csr -signkey $domain.key -out $domain.crt

# Move the certificate and key files to the appropriate directory
mkdir -p /etc/pki/tls/certs
mkdir -p /etc/pki/tls/private
chmod 700 /etc/pki/tls/private
mv $domain.crt /etc/pki/tls/certs/
mv $domain.key /etc/pki/tls/private/

# Create the virtual host configuration file for port 80
cat << EOF > /etc/httpd/vhosts.d/$domain.conf
<VirtualHost *:80>
    ServerName $domain
    ServerAlias www.$domain

        # Force HTTPS when loading the page
    #RewriteEngine On
    #RewriteCond %{HTTPS} off
    #RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}
                
    DocumentRoot /var/www/vhosts/$domain/public_html
    ErrorLog /var/log/httpd/$domain-error.log
    CustomLog /var/log/httpd/$domain-access.log combined

    <Directory /var/www/vhosts/$domain/public_html>
        DirectoryIndex index.html
        Require all granted
    </Directory>
</VirtualHost>


<VirtualHost *:443>
    ServerName $domain
    ServerAlias www.$domain

    DocumentRoot /var/www/vhosts/$domain/public_html
    ErrorLog /var/log/httpd/$domain-ssl-error.log
    CustomLog /var/log/httpd/$domain-ssl-access.log combined

    <Directory /var/www/vhosts/$domain/public_html>
        DirectoryIndex index.html
        Require all granted
    </Directory>

    # SSL Configuration
    SSLEngine on
    SSLCertificateFile /etc/pki/tls/certs/$domain.crt
    SSLCertificateKeyFile /etc/pki/tls/private/$domain.key
    #SSLCertificateChainFile /etc/pki/tls/certs/$domain.ca-bundle

</VirtualHost>
EOF

echo "IncludeOptional vhosts.d/*.conf" >> /etc/httpd/conf/httpd.conf
touch /var/www/vhosts/$domain/public_html/index.html
echo "Test page for $domain" > /var/www/vhosts/$domain/public_html/index.html
curl -H "Host:  $domain" localhost/index.html

httpd -t
