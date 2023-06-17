SHELL                    := /bin/bash

.PHONY: pubget
pubget:
	dart pub get

.PHONY: pubupgrade
pubupgrade:
	dart pub upgrade

.PHONY: dependency_validator
dependency_validator:
	dart run dependency_validator

.PHONY: format
format:
	dart format -l 120 .

.PHONY: analyze
analyze:
	dart analyze

.PHONY: gen-fixtures
gen-fixtures:
	dart run ./tool/gen.dart

.PHONY: serve-remotes
serve-remotes: stop-serve-remotes
	dart run ./tool/serve_remotes.dart

.PHONY: stop-serve-remotes
stop-serve-remotes: 
	@if [ ! -z `lsof -t -i tcp:1234 -i tcp:4321` ]; then\
        kill -9 `lsof -t -i tcp:1234 -i tcp:4321`;\
    fi

.PHONY: test
test: 
	dart test

# test-with-serve-remotes recipe does the following:
# 0) kills any previously running HTTP fixture server
# 1) starts a dart process to server specification test remotes
# 2) stores the pid of the serve_remotes.dart process
# 3) waits 3 seconds to give the server time to start
# 4) runs the tests
# 5) stores the exit code of the tests
# 6) stops the server
# 7) exits the process with the return code from the tests
.PHONY: test-with-serve-remotes
test-with-serve-remotes: stop-serve-remotes
	{ dart run ./tool/serve_remotes.dart & }; \
	pid=$$!; \
	sleep 1; \
	dart test; \
	r=$$?; \
	kill $$pid; \
	exit $$r