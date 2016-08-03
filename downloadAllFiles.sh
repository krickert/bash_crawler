#/bin/bash
source ./variables.sh
if [ ! $? -eq 0 ]; then
	echo "could not load variables.sh file.  Nothing to do.";
fi

##Initial variables set for the future - don't change please. k thx.
DATE_TIME="$(date "+%Y%m%d%H%M")"
COUNTER=1
COUNTER_DISPLAY=$(printf "%0*d\n" ${PAD_TO_WIDTH} ${COUNTER});

##validation of variables and set to defaults if they do not exist
if [ -z "$WEBSITE_URL" ]; then
	echo "variable WEBSITE_URL is unset or empty.  Please set it globally or in the variables.sh script";
fi
echo "WEBSITE_URL set to ${WEBSITE_URL}";

if [ -z "${SITEMAP_FILE}" ]; then
	SITEMAP_FILE=sitemap.txt
fi
echo "SITEMAP_FILE set to ${SITEMAP_FILE}";
if [ ! -e ${SITEMAP_FILE} ]; then
	echo "The sitemap file ${SITEMAP_FILE} does not exist.  Please create one or no soup for you."
	exit 1
fi

if [ -z "${PAD_TO_WIDTH}" ]; then
	PAD_TO_WIDTH=4
fi
echo "PATH_TO_WIDTH set to ${PAD_TO_WIDTH}"

if [ -z "${LOG_FILE}" ]; then
	LOG_FILE=crawler.log
fi
echo "LOG_FILE set to ${LOG_FILE}"
LOG_FILE_FULL=${LOG_FILE}${DATE_TIME}.txt

if [ -z "$OUTPUT_DIRECTORY" ]; then
	OUTPUT_DIRECTORY=crawled_pages${DATE_TIME}
fi
echo "OUTPUT_DIRECTORY set to ${OUTPUT_DIRECTORY}";

if [ -z "${FILE_PREFIX}" ]; then
	FILE_PREFIX=page
fi
echo "FILE_PREFIX set to ${FILE_PREFIX}"

#check that the output directory exists
if [ ! -d ${OUTPUT_DIRECTORY} ]; then
	mkdir $OUTPUT_DIRECTORY;
	if [ ! $? -eq 0 ]; then
		echo "Could not create the directory ${OUTPUT_DIRECTORY} please check your permissions."
		exit 1
	fi
fi

FULL_FAILURE_FILE=${OUTPUT_DIRECTORY}/failures.txt
FULL_LOG_FILE=${OUTPUT_DIRECTORY}/${LOG_FILE}

for page in `cat ${SITEMAP_FILE}`; 
do 
	FULL_SITE=${WEBSITE_URL}${page}; 
	echo "Page ${FULL_SITE} Counter ${COUNTER}" >> ${FULL_LOG_FILE}
	FILE_TO_SAVE=${OUTPUT_DIRECTORY}/${FILE_PREFIX}${COUNTER_DISPLAY}.html
	curl -s --fail "${FULL_SITE}" -o ${FILE_TO_SAVE}; 
	STATUS=$?
	if [ ! ${STATUS} -eq 0 ]
	then
		ERROR_MESSAGE="${FULL_SITE} with counter mapping of ${COUNTER_DISPLAY} returned exit code ${STATUS}";
		echo $ERROR_MESSAGE >> ${FULL_LOG_FILE}
		echo $ERROR_MESSAGE >> ${FULL_FAILURE_FILE}
		if [ -e ${FILE_TO_SAVE} ]; then rm ${FILE_TO_SAVE}; fi
	fi
	COUNTER=$((COUNTER + 1));
	COUNTER_DISPLAY=$(printf "%0*d\n" ${PAD_TO_WIDTH} ${COUNTER});
done;

if [ -e  ${OUTPUT_DIRECTORY}/failures.txt ]; then
	NUMBER_OF_ERRORS=$(wc -l < "${FULL_FAILURE_FILE}")
	echo "There were ${NUMBER_OF_ERRORS} errors in the file. Please see the cURL documentation and the failure text to see why it failed. see https://curl.haxx.se/libcurl/c/libcurl-errors.html for more details" >> ${FULL_LOG_FILE}
fi
echo "Zipping the directory.."
zip -r ${OUTPUT_DIRECTORY}.zip ${OUTPUT_DIRECTORY}
echo ${COUNTER} files were created and zipped into ${OUTPUT_DIRECTORY}.zip

