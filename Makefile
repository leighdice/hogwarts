.PHONY setup run

setup:
	bundle install --without test

run:
	bundle exec ruby -S rackup -w config.ru

test:
	rm .bundle/config
	bundle exec rake test
