.DEFAULT_GOAL := help

.PHONY: help setup check

help:
	@printf '%s\n' 'make setup  Configure repository Git hooks' 'make check  Validate hooks and OpenSpec'

setup:
	git config core.hooksPath .githooks

check:
	@sh -n .githooks/commit-msg
	@openspec validate --all --strict --no-interactive

