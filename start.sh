#!/bin/bash -e

# Setup DIRAC SiteDirector for condor
#iptables -I INPUT -p tcp --dport 9130:9200 -j ACCEPT
#service iptables save

# Make sure the DIRAC master server has a nagent name
if [ "x$SiteDirectorName" = "x" ]; then
    echo You must specify SiteDirectorName
    exit -1
fi

DIRAC_BASE_PATH=/opt/dirac/
mkdir -p ${DIRAC_BASE_PATH}/etc/grid-security/
ln -s /etc/grid-security/certificates  ${DIRAC_BASE_PATH}/etc/grid-security/certificates
cp /etc/grid-security/hostcert.pem ${DIRAC_BASE_PATH}/etc/grid-security
cp /etc/grid-security/hostkey.pem ${DIRAC_BASE_PATH}/etc/grid-security
chown -R belle:belle ${DIRAC_BASE_PATH}

mkdir -p /srv/dirac
cd /srv/dirac
wget -np https://github.com/DIRACGrid/DIRAC/raw/integration/Core/scripts/install_site.sh --no-check-certificate
chmod +x install_site.sh
chown -R belle:belle /srv/dirac
su belle /srv/dirac/install_site.sh /srv/dirac/pnnl_dirac.cfg
eval SITE_DIRECTOR_NAME=\$$SiteDirectorName
dirac-install-agent WorkloadManagement SITE_DIRECTOR_NAME -ddd

# Setup CONDOR client
. /etc/sysconfig/condor
condor_master -f 

