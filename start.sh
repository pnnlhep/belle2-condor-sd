#!/bin/bash -e

# Make sure the DIRAC master server has a nagent name
if [ "x$SiteDirectorName" = "x" ]; then
    echo You must specify SiteDirectorName
    exit -1
fi
echo "From docker env:" ${SiteDirectorName}
SITE_DIRECTOR_NAME=${SiteDirectorName}
#eval SITE_DIRECTOR_NAME=\$$SiteDirectorName
echo ${SITE_DIRECTOR_NAME}
DIRAC_BASE_PATH=/opt/dirac_belle2
mkdir -p ${DIRAC_BASE_PATH}
echo ${DIRAC_BASE_PATH}
mkdir -p ${DIRAC_BASE_PATH}/etc/grid-security
ln -s /etc/grid-security/certificates  ${DIRAC_BASE_PATH}/etc/grid-security/certificates
cp /etc/grid-security/hostcert.pem ${DIRAC_BASE_PATH}/etc/grid-security/hostcert.pem
cp /etc/grid-security/hostkey.pem ${DIRAC_BASE_PATH}/etc/grid-security/hostkey.pem
chown -R belle:belle ${DIRAC_BASE_PATH}
ls -lrt ${DIRAC_BASE_PATH}/etc/grid-security
openssl x509 -in ${DIRAC_BASE_PATH}/etc/grid-security/hostcert.pem -noout -subject
mkdir -p /srv/dirac
cd /srv/dirac
wget -np https://github.com/DIRACGrid/DIRAC/raw/integration/Core/scripts/install_site.sh --no-check-certificate
chmod +x install_site.sh
chown -R belle:belle /srv/dirac
echo "Starting DIRAC install_site.sh..."
su - belle -c /bin/bash -c "/srv/dirac/install_site.sh -ddd /srv/dirac/dirac_condor_sitedirector.cfg"
su - belle -c "source /opt/dirac_belle2/bashrc;dirac-install-agent WorkloadManagement '${SITE_DIRECTOR_NAME}' -c y " 
su - belle -c "source /opt/dirac_belle2/bashrc;dirac-install-agent WorkloadManagement CountPilotSubmission -c y"
su - belle -c "source /opt/dirac_belle2/bashrc;dirac-install-service RequestManagement ReqProxy -c -y"
rm -rf /srv/dirac/install_site.sh
# Setup CONDOR client
echo "Starting condor client..."
. /etc/sysconfig/condor
condor_master -f 

