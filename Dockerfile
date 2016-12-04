# Webserver container with CGI python script
# Using RHEL 7 base image and Apache Web server
# Version 1

# Pull the rhel image from the local repository
FROM rhel7:latest
USER root

MAINTAINER Ron Sengupta

# Fix per https://bugzilla.redhat.com/show_bug.cgi?id=1192200
RUN yum -y install deltarpm yum-utils --disablerepo=*-eus-* --disablerepo=*-htb-* \
    --disablerepo=*-ha-* --disablerepo=*-rt-* --disablerepo=*-lb-* --disablerepo=*-rs-* --disablerepo=*-sap-*

    RUN yum-config-manager --disable *-eus-* *-htb-* *-ha-* *-rt-* *-lb-* *-rs-* *-sap-* > /dev/null


# Update image
RUN yum update -y; yum install httpd mod_ssl openssl -y

# Add configuration file
RUN echo "The Web Server is Running" > /var/www/html/index.html
RUN echo "Listen 8080" >> /etc/httpd/conf/httpd.conf
COPY ssl.conf /etc/httpd/conf.d/ssl.conf
COPY ca.crt /etc/pki/tls/certs/ca-bundle.crt
COPY clisec.rhel-cdk.10.1.2.2.xip.io.crt /etc/pki/tls/certs/localhost.crt
COPY clisec.rhel-cdk.10.1.2.2.xip.io.key /etc/pki/tls/private/localhost.key

EXPOSE 8080
EXPOSE 8443

# Start the service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
