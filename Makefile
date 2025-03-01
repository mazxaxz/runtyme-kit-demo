.PHONY: init
init:
	$(eval $@_GITHUB_BASE_URL := git@github.com:)
ifeq ("$(SSH)","false")
	$(eval $@_GITHUB_BASE_URL = https://github.com/)
endif

	$(eval $@_CURRENT_DIR := $(basename $(shell pwd)))
	$(eval $@_RUNTYME_REMOTE_URL := $(shell git remote get-url origin))
	rm -rf ./.git
	git init
	git remote add runtyme-kit $($@_RUNTYME_REMOTE_URL)
	git remote add origin $($@_GITHUB_BASE_URL)$(GH_USERNAME)/$(GH_REPOSITORY_NAME).git
	git add . && git commit -a -m "runtyme-kit: Initialize repository"
	cd .. && mv $($@_CURRENT_DIR) ./$(GH_REPOSITORY_NAME) && cd ./$(GH_REPOSITORY_NAME)
