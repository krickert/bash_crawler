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

if [ -z "${MAPPING_FILE}" ]; then
	MAPPING_FILE=mappings
fi
echo "MAPPING_FILE set to ${MAPPING_FILE}"
MAPPING_FILE_FULL=${MAPPING_FILE}${DATE_TIME}.txt

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

for page in `cat ${SITEMAP_FILE}`; 
do 
	FULL_SITE=${WEBSITE_URL}${page}; 
	echo "Page ${FULL_SITE} Counter ${COUNTER}" >> ${OUTPUT_DIRECTORY}/${MAPPING_FILE}; 
	wget $FULL_SITE -O ${OUTPUT_DIRECTORY}/${FILE_PREFIX}${COUNTER_DISPLAY}.html; 
	STATUS=$?
	if [ ! ${STATUS} -eq 0 ]
	then
		echo "${FULL_SITE} with counter mapping of ${COUNTER_DISPLAY} returned exit code ${STATUS}" >> ${OUTPUT_DIRECTORY}/failures.txt
		rm ${OUTPUT_DIRECTORY}/${FILE_PREFIX}${COUNTER_DISPLAY}.html
	fi
	COUNTER=$((COUNTER + 1));
	COUNTER_DISPLAY=$(printf "%0*d\n" ${PAD_TO_WIDTH} ${COUNTER});
done;

echo "Zipping the directory.."
zip -r ${OUTPUT_DIRECTORY}.zip ${OUTPUT_DIRECTORY}
echo ${COUNTER} files were created and zipped into ${OUTPUT_DIRECTORY}.zip

