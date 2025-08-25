
app?=app
GOOS=linux
GOARCH=amd64
CGO_ENABLED=0 
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


###@Lint Help: message for build_test_1
lint-go:
	go generate golangci-lint.go

###@Build Help: message for build_test_1
build-app:
	@test -d cmd/$(app) || (echo "Folder 'cmd/$(app)' doesn't exists" && exit 1)
	go build -o bin/$(app) -ldflags="-X main.Version=1.0.0" ./cmd/$(app)/... 

