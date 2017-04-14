FROM tomcat:8.5
MAINTAINER mall@gti.net.cn

WORKDIR /usr/local/tomcat/webapps

ADD target/mall.war ./ROOT.war

RUN rm -rf ./ROOT/* && mkdir -p ./ROOT

RUN /usr/bin/unzip -d ./ROOT/ ./ROOT.war

RUN rm -rf ./ROOT.war

CMD ["catalina.sh", "run"]
