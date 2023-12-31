.PHONY: install
install:
	@# go get github.com/golang/lint/golint
	go get github.com/UnnoTed/fileb0x
	go get golang.org/x/lint
	go get github.com/gordonklaus/ineffassign
	go get github.com/client9/misspell/cmd/misspell

.PHONY: templates
templates:
	fileb0x b0x.yaml

.PHONY: test
test:
	ineffassign main.go ./pkg/server/
	golint -set_exit_status ./pkg/server/...
	gofmt -d -s -e main.go ./pkg/server/
	misspell -error README.md main.go ./pkg/server/*
	go test -v -race -coverprofile=coverage.txt -covermode=atomic ./pkg/server/

.PHONY: build-linux
build-linux:
	GOOS=linux GOARCH=amd64 go build -ldflags "-w -s" -o ./udp-web-logger ./main.go

.PHONY: docker
docker: templates build-linux
		docker build -t udp-web-logger:1 .
