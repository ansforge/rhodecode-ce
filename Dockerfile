FROM sstruss/rhodecode-ce:4.22.0

#Update all packages then install packages apaches and dav_svn (version for ubuntu)
RUN apt update && \
    apt install -y apache2 \
                   libapache2-mod-svn \
                   subversion \
                   ssh \
                   net-tools

#Enable dav_svn
RUN a2enmod dav_svn && \
    a2enmod headers && \
    a2enmod authn_anon

#Change apache's port due conflict with nginx
RUN sed -i -e 's/Listen 80/Listen 8090/' /etc/apache2/ports.conf

#Rhodecode's configuration : Copy production.ini file to enable dav_svn
COPY rhodecode-enterprise-ce/production.ini /rhodecode-develop/rhodecode-enterprise-ce/configs/production.ini
COPY rhodecode-vcsserver/production.ini /rhodecode-develop/rhodecode-vcsserver/configs/production.ini
COPY custom_svn_conf.mako /root/custom_svn_conf.mako

#Hooks
COPY hooks.py /rhodecode-develop/rhodecode-enterprise-ce/rhodecode/config/rcextensions

#Add file rhodecode.conf to configure dav_mod_svn
COPY mod_dav_svn.conf /rhodecode-develop/rhodecode-enterprise-ce/configs/mod-dav/mod_dav_svn.conf
COPY default.conf /etc/apache2/sites-available/default.conf
RUN cd /etc/apache2/sites-enabled && \
    a2ensite default 

#Add apache's user in root's group
RUN adduser www-data root
RUN chmod 750 /root

#Start apache service
COPY start.sh /start.sh
RUN chmod +x /start.sh
