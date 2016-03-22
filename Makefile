
setup:
	bundle install --without test

run:
	bundle exec ruby -S rackup -w config.ru

stop:
	kill `cat venue_app.pid`

restart:
	kill `cat venue_app.pid`
	sleep 3
	bundle exec ruby -S rackup -w config.ru

test:
	rm .bundle/config
	bundle exec rake test
