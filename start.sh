#!/bin/bash -e

# Setup DIRAC SiteDirector for condor
#iptables -I INPUT -p tcp --dport 9130:9200 -j ACCEPT
#service iptables save

# Make sure the DIRAC master server has a nagent name
#if [ "x$SiteDirectorName" = "x" ]; then
#    echo You must specify SiteDirectorName
#    exit -1
#fi

DIRAC_BASE_PATH=/opt/dirac/
mkdir -p ${DIRAC_BASE_PATH}
echo ${DIRAC_BASE_PATH}
#mkdir -p ${DIRAC_BASE_PATH}/etc/grid-security
#ln -s /etc/grid-security/certificates  ${DIRAC_BASE_PATH}/etc/grid-security/certificates
#cp /etc/grid-security/hostcert.pem ${DIRAC_BASE_PATH}/etc/grid-security
#cp /etc/grid-security/hostkey.pem ${DIRAC_BASE_PATH}/etc/grid-security
chown -R belle:belle ${DIRAC_BASE_PATH}
ls -lrt /opt/dirac/etc/grid-security
openssl x509 -in ${DIRAC_BASE_PATH}/etc/grid-security/hostkey.pem -noout -subject
mkdir -p /srv/dirac
cd /srv/dirac
wget -np https://github.com/DIRACGrid/DIRAC/raw/integration/Core/scripts/install_site.sh --no-check-certificate
chmod +x install_site.sh
chown -R belle:belle /srv/dirac
echo "Starting DIRAC install_site.sh..."
ls /home/
id belle
su - belle -c /bin/bash -c "/srv/dirac/install_site.sh -ddd /srv/dirac/dirac_condor_sitedirector.cfg"
#eval SITE_DIRECTOR_NAME=\$$SiteDirectorName
#echo ${SITE_DIRECTOR_NAME}
#dirac-install-agent WorkloadManagement ${SITE_DIRECTOR_NAME} -ddd
rm -rf /srv/dirac/install_site.sh
# Setup CONDOR client
echo "Starting condor client..."
. /etc/sysconfig/condor
condor_master -f 

