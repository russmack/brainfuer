# Travis falls back to using a Makefile if it doesn't find a rebar.config.

.PHONY: test
test:
	erlc brainfuer.erl
	ct_run -dir test -pa .

