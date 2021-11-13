ARG IMAGE=intersystemsdc/iris-community:2020.1.0.215.0-zpm
ARG IMAGE=intersystemsdc/iris-community:latest
FROM $IMAGE

USER root
COPY irissession.sh /

WORKDIR /opt/irisapp
COPY csp csp
RUN mkdir /ghostdb/ && mkdir /voldata/ && mkdir /voldata/irisdb
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /irissession.sh /opt/irisapp /opt/irisapp/csp /opt/irisapp/csp/* /ghostdb/ /voldata/ /voldata/irisdb/ \
  && chmod +x /irissession.sh

USER irisowner

COPY  Installer.cls .
COPY  src src
SHELL ["/irissession.sh"]

RUN \
  do $SYSTEM.OBJ.Load("Installer.cls", "ck") \
  set sc = ##class(App.Installer).ConfigIRIS()

# bringing the standard shell back
SHELL ["/bin/bash", "-c"]

HEALTHCHECK --interval=10s --timeout=3s --retries=2 CMD wget --timeout 1 --quiet http://localhost:52773/csp/user/cache_status.cxw -O - || exit 1

USER root
COPY vcopy.sh vcopy.sh
RUN rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ $ISC_PACKAGE_INSTALLDIR/mgr/journal/* && cp -Rpf /voldata/* /ghostdb/ && rm -fr /voldata/* \
  && chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp/vcopy.sh && chmod +x /opt/irisapp/vcopy.sh

# we need Write privilege for UnitTest
# RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp/src/UnitTest/* && chmod +w /opt/irisapp/src/UnitTest/*
