#!/bin/sh

cd "$GITHUB_WORKSPACE/${INPUT_DIRECTORY}"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

/usr/local/bin/phpcs.phar \
    --report=summary \
    --report-checkstyle=/tmp/phpcs_result_checkstyle.xml \
    -p -s --colors -d memory_limit=1G --ignore=vendor --extensions=php \
    --standard=./phpcs.xml \
    ${INPUT_PHPCS_ARGS:-\.}

cat /tmp/phpcs_result_checkstyle.xml | reviewdog -f=checkstyle -name="phpcs" -reporter="${INPUT_REPORTER:-github-pr-check}" -level="${INPUT_LEVEL}"

EXIT_CODE1=$?

/usr/local/bin/phpmd.phar ${INPUT_PHPMD_ARGS:-\.} text ./phpmd.xml -dmemory_limit=-1 > /tmp/phpmd-report.text

cat /tmp/phpmd-report.xml | reviewdog -efm="%f:%l %m" -name="phpmd" -reporter="${INPUT_REPORTER:-github-pr-check}" -level="${INPUT_LEVEL}"

EXIT_CODE2=$?

/usr/local/bin/phpstan.phar \
    analyse \
    --error-format phpstan \
    ${INPUT_PHPSTAN_ARGS:-\.} \
    > /tmp/phpstan-report.xml

cat /tmp/phpstan-report.xml | reviewdog -f=phpstan -name="phpstan" -reporter="${INPUT_REPORTER:-github-pr-check}" -level="${INPUT_LEVEL}"

EXIT_CODE3=$?

if [ $EXIT_CODE1 != 0 ] || [ $EXIT_CODE2 != 0 ] || [ $EXIT_CODE3 != 0 ] ; then
  exit 1;
fi