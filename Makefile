# Makefile for build docker images
# default user name for docker hub
user = avolchkov
export USER_NAME=$(user)

monitoring_dir = monitoring
app_dir = src
logging = logging
monitoring_services = prometheus blackbox cloudprober alertmanager telegraf grafana trickster
logging_services = fluentd
app_services = ui comment post

#Main goal
.PHONY: all
all: build_all push_all

.PHONY: build_all build_mon build_app build_log $(monitoring_services) $(app_services) $(logging_services)
build_all: build_mon build_app build_log

build_mon: $(monitoring_services)
	@echo ================Building monitoring services done================

build_log: $(logging_services)
	@echo ================Building logging services done================

$(monitoring_services):
	@echo ================Start building: $@ ================
	docker build -t $(user)/$@ ./$(monitoring_dir)/$@

$(logging_services):
	@echo ================Start building: $@ ================
	docker build -t $(user)/$@ ./$(logging)/$@

build_app: $(app_services)
	@echo ================Building app services done================

$(app_services):
	@echo ================Start building: $@ ================
	echo `git show --format="%h" HEAD | head -1` > ./$(app_dir)/$@/build_info.txt
	echo `git rev-parse --abbrev-ref HEAD` >> ./$(app_dir)/$@/build_info.txt
	docker build --no-cache -t $(user)/$@ ./$(app_dir)/$@

.PHONY: push_all push_mon push_app push_log $(addprefix push_, $(monitoring_services)) $(addprefix push_, $(logging_services))
push_all: push_mon push_app push_log

push_mon: $(addprefix push_, $(monitoring_services))
	@echo ================Push monitoring services done================

$(addprefix push_, $(monitoring_services)):
	@echo ================Start pushing: $(patsubst push_%,%,$@) ================
	docker push $(user)/$(patsubst push_%,%,$@)

push_log: $(addprefix push_, $(logging_services))
	@echo ================Push logging services done================

$(addprefix push_, $(logging_services)):
	@echo ================Start pushing: $(patsubst push_%,%,$@) ================
	docker push $(user)/$(patsubst push_%,%,$@)

push_app: $(addprefix push_, $(app_services))
	@echo ================Push app services done================

$(addprefix push_, $(app_services)):
	@echo ================Start pushing: $(patsubst push_%,%,$@) ================
	docker push $(user)/$(patsubst push_%,%,$@)

.PHONY: Help

help:
	@echo Usage:
	@echo 'make - 	build all and push to docker hub'
	@echo 'make build_all/build_mon/build_app - 	building'
	@echo 'make push_all/push_mon/push_app - 	pushing'
