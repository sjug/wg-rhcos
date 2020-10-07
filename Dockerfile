FROM registry.access.redhat.com/ubi8

COPY start.sh /usr/local/bin
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm

ENTRYPOINT ["start.sh"]
