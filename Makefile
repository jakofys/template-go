CGO_ENABLED=0 


### Parameters
APP?=APP
GOOS?=linux
GOARCH?=amd64

### help: Print this help
.DEFAULT: help
help: #check build clean upload
	@echo 'Usage: make [target] ...'
	@awk ' \
		match($$0,/^###(@(\w+))? [Hh]elp: /,m) \
		{c=m[2];h=substr($$0,RLENGTH);next} \
		h&&/^[[:alpha:]][[:alnum:]_/-]+:/ \
		{help[c][idx[c]++]=sprintf("\033[36m%s\033[0m\t%s", substr($$1,1,index($$1,":")-1),h)} \
		1{c=0;h=0} \
		END{ \
			n=asorti(help, help_); \
			for (c = 1; c <= n; c++) { \
				if(help_[c]){indent="  ";printf "\n%s:\n", help_[c]}\
				asort(help[help_[c]]); \
				for(x in help[help_[c]]){print indent help[help_[c]][x]} \
			} \
		}' $(MAKEFILE_LIST) | column -s$$'\t' -tL


###@Lint Help: lint go code in entiere project
lint-go:
	go generate golangci-lint.go

###@Lint Help: lint OpenAPI specification schemas
lint-openapi:

###@Build Help: build APP in bin folder, using 'APP=...' to choose which cmd to build
build-app:
	@test -d cmd/$(APP) || (echo "Folder 'cmd/$(APP)' doesn't exists" && exit 1)
	go build -o bin/$(APP) -ldflags="-X main.Version=1.0.0" ./cmd/$(APP)/... 

###@Generate Help: generate http go server code
gen-http:
	@test -d cmd/$(APP) || (echo "Folder 'cmd/$(APP)' doesn't exists" && exit 1)
	go build -o bin/$(APP) -ldflags="-X main.Version=1.0.0" ./cmd/$(APP)/... 
