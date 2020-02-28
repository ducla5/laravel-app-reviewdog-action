#!/bin/sh

cd "$GITHUB_WORKSPACE/${INPUT_DIRECTORY}"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

/usr/local/bin/phpcs.phar \
    --report=summary \
    --report-checkstyle=/tmp/phpcs_result_checkstyle.xml \
    -p -s --colors -d memory_limit=1G --ignore=vendor --extensions=php \
    --standard=./phpcs.xml \
    --runtime-set ignore_errors_on_exit 1 \
    --runtime-set ignore_warnings_on_exit 1 \
    ${INPUT_PHPCS_ARGS:-\.}

EXIT_CODE=$?

cat /tmp/phpcs_result_checkstyle.xml

< /tmp/phpcs_result_checkstyle.xml | reviewdog -f=checkstyle -name="phpcs" -reporter="${INPUT_REPORTER:-github-pr-check}"

/usr/local/bin/phpmd.phar ${INPUT_PHPMD_ARGS:-\.} xml ./phpmd.xml -dmemory_limit=-1 > /tmp/phpmd-report.xml

EXIT_CODE=$?

cat /tmp/phpmd-report.xml

< /tmp/phpmd-report.xml | reviewdog -f=checkstyle -name="phpmd" -reporter="${INPUT_REPORTER:-github-pr-check}"

/usr/local/bin/phpstan.phar \
    analyse \
    vendor/bin/phpstan analyse --error-format checkstyle \
    ${INPUT_PHPSTAN_ARGS:-\.} \
    > /tmp/phpstan-report.xml

EXIT_CODE=$?

cat /tmp/phpstan-report.xml

< /tmp/phpstan-report.xml | reviewdog -f=checkstyle -name="phpstan" -reporter="${INPUT_REPORTER:-github-pr-check}"

exit $EXIT_CODE
