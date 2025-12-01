ARG IMAGE=containers.intersystems.com/intersystems/iris:latest-em
ARG TYPE=client
FROM $IMAGE

ARG TYPE

USER root   

COPY  ECP_iris.key /usr/irissys/mgr/iris.key

WORKDIR /opt/irisapp

RUN chmod 666 /usr/irissys/mgr/iris.key \
 && chown irisowner:irisowner /opt/irisapp \
 && rm /usr/irissys/mgr/messages.log        

USER irisowner

# Copy modules and code to include - iris-script will use it to load and compile
COPY ./zpm ./zpm
COPY ./ecpsetup ./ecpsetup
#Whatever ObjectScript code you copy below src will be loaded and compiled (check iris-sript.mac)
COPY ./src ./src

#Samples OPNEx-MMODEL (here you can add your own apps - if so, change iris-script accordingly)
COPY ./opnex-mmodel ./opnex-mmodel

COPY ./irissession.sh ./irissession.sh
COPY iris-script.mac iris-script.mac

RUN echo "TYPE = ${TYPE}"

# Execute irissession passing the ObjectScript commands... that way we can use docker ARG replacement, p.e. ${TYPE}
RUN ./irissession.sh \
  "Do \$system.OBJ.Load(\"/opt/irisapp/iris-script.mac\",\"ck\") set sc=\$\$^irisscript(\"${TYPE}\")"

# Just kept as reference. In code block below ${TYPE} is not replaced and ObjectScript code fails
#SHELL [ "./irissession.sh" ]
#ARG TYPE

#RUN \
#Do $system.OBJ.Load("/opt/irisapp/iris-script.mac","ck") \
#set sc = $$^irisscript(${TYPE})

