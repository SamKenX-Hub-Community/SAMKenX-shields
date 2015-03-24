all: website deploy

favicon:
	node gh-badge.js '' '' '#bada55' .png > favicon.png

website:
	cat try.html | sed "s,\(<img src='\)/,\1https://img.shields.io/," \
             | sed "s,<span id='imgUrlPrefix'>,&https://img.shields.io," \
             | sed "s,var origin = '';,var origin = 'https://img.shields.io';," \
	     | sed "s,<style>,<!-- WARNING: THIS FILE WAS GENERATED FROM try.html -->\n<style>," > index.html

deploy:
	git add -f Verdana.ttf
	git add -f secret.json
	git commit -m'MUST NOT BE ON GITHUB'
	git push -f heroku HEAD:master
	git reset HEAD~1
	(git checkout -B gh-pages && \
	git merge master && \
	git push -f origin gh-pages:gh-pages) || git checkout master
	git checkout master

setup:
	curl http://download.redis.io/releases/redis-2.8.8.tar.gz >redis.tar.gz \
	&& tar xf redis.tar.gz \
	&& rm redis.tar.gz \
	&& mv redis-2.8.8 redis \
	&& cd redis \
	&& make

redis:
	./redis/src/redis-server

test:
	npm test

.PHONY: all favicon website deploy setup redis test
