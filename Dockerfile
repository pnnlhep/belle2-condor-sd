FROM pnnlhep/osg-base
MAINTAINER Malachi Schram "malachi.schram@pnnl.gov"

RUN yum install -y osg-ca-certs osg-ce-condor

RUN groupadd -r belle -g 700
RUN useradd -r -g belle -u 700 -d /home/belle -s /sbin/nologin \
    -c "Owner of DIRAC Server" belle
ADD ./start.sh /etc/start.sh
RUN chmod +x /etc/start.sh

CMD ["/etc/start.sh"]
