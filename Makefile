BPC_REPOSITORY = http://www.smalltalkhub.com/mc/UdoSchneider/BPC/main
QC_REPOSITORY = http://www.smalltalkhub.com/mc/DiegoLont/QCMagritte/main
PHARO_REPOSITORY = http://www.smalltalkhub.com/mc/Pharo/MetaRepoForPharo50/main
VM_REPOSITORY = files.pharo.org/vm/pharo-spur32/linux/armv6/latest.zip
SOURCES = http://files.pharo.org/sources/PharoV50.sources
VERSION = development
TEMPFILE := $(shell mktemp)
VM = ./pharo-ui -vm-display-null

default: install

clean:
	rm -fR *git*.zip crash.dmp image.*

cleanall: clean
	rm -fR pharo* *.image *.changes *.so

install: pharo-ui pharo-vm/PharoV50.sources BPC.image

start: install
	sudo ntpdate -u -b de.pool.ntp.org
	./pharo-ui --fullscreenDirect BPC.image st bpc-startup.st

stop:
	killall -9 pharo-ui

update: pharo-ui
	${VM} QCMongo.image save BPC
	${VM} BPC.image config "${BPC_REPOSITORY}" --install=${VERSION}

BPC.image: QCMongo.image pharo-ui
	${VM} $< save BPC
	${VM} $@ config "${BPC_REPOSITORY}" --install=${VERSION}

QCMongo.image: QC.image pharo-ui
	${VM} $< save QCMongo
	${VM} $@ config "${PHARO_REPOSITORY}" ConfigurationOfVoyageMongo --install=stable

QC.image: Pharo.image pharo-ui
	${VM} $< save QC
	${VM} $@ config "${QC_REPOSITORY}" --install=stable

Pharo.image:
	curl get.pharo.org/50 | bash

pharo-ui:
	# curl get.pharo.org/vm50 | bash	
	curl ${VM_REPOSITORY} > ${TEMPFILE} && unzip -o -d pharo-vm ${TEMPFILE}
	rm ${TEMPFILE}
	ln -s pharo-vm/pharo pharo-ui

pharo-vm/PharoV50.sources: pharo-ui
	curl ${SOURCES} > $@






