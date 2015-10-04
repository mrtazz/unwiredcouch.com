#
# blog housekeeping tasks
#

.PHONY: deploy css

deploy:
	rsync -chavzOP --no-perms --stats _site/ unwiredcouch.com:/usr/local/www/unwiredcouch/

css/style.min.css: css/style.css
	minify css/style.css css/style.min.css

css: css/style.min.css
