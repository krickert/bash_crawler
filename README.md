# bash_crawler
Simple bash script that crawls a text file of websites.

## WTF
I always end up in a situation when crawling sites to get a corpus of HTML pages together and rewrite it.

This ends today.

## How do I use it
You can set all the variables in the `variables.sh` file.

The following variables are available:
| Variable name		| Required?	| Default value		| Description								|Example					|
|-----------------------|---------------|-----------------------|-----------------------------------------------------------------------|-----------------------------------------------|
| WEBSITE_URL		| true		| None			| The full URL of the website to crawl.  Needs http vs. https prefix	| WEBSITE_URL=http://cnn.com			|
| SITEMAP_FILE		| false		| sitemap.txt		| The name of the sitemap file.  It's a list of relative URLs to crawl	| SITEMAP_FILE=examples/cnnsitemap		|
| PAD_TO_WIDTH		| false		| 4			| The number of spaces to pad a 0 with on the output html file		| PAD_TO_WIDTH=3				|
| LOG_FILE		| false		| crawler.log		| The name of the output log file to use.				| LOG_FILE=crawl.log				|
| OUTPUT_DIRECTORY	| false		| crawled_pages[DATE]	| will called the output directory crawled_pagesYYYYMMDDHHmm.txt 	| OUTPUT_DIRECTORY=html				|
| FILE_PREFIX		| false		| page			| The name of the HTML file prefix to save when doing the crawl		| FILE_PREFIX=cnn				|


Below is the default variables.sh file:
```bash
#!/bin/bash
WEBSITE_URL=http://krickert.photography
PAD_TO_WIDTH=4
LOG_FILE=krickert_site_crawl.log
SITEMAP_FILE=examples/krickertmap.txt
```

