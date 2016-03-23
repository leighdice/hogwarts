.PHONY: setup run

setup:
	bundle install --without test

run:
	bundle exec ruby -S rackup -w config.ru

setup-test:
	bundle install --with test

test: setup-test
	bundle exec rake test
