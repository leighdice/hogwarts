.PHONY: setup run

setup:
	bundle install --without test

run:
	bundle exec ruby -S rackup -w config.ru

setup-test:
	rm -f .bundle/config
	bundle install

test: setup-test
	bundle exec rake test
