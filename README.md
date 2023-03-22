# GitHub Action: Run php check code with reviewdog

This action runs phpcs, phpmd with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
code review experience.


## Inputs

### `github_token`

**Required**. Must be in form of `github_token: ${{ secrets.github_token }}`'.

### `tool_name`

Optional. Tool name to use for reviewdog reporter. Useful when running multiple
actions with different config.


### `directory`

Optional. The subdirectory where your php code resides.

### `reporter`

Optional. Reporter of reviewdog command [github-pr-check,github-pr-review].
It's same as `-reporter` flag of reviewdog.

### `phpcs_args`

Optional. Arguments to pass to phpcs. 


### `phpmd_args`

Optional. Arguments to pass to phpmd. 


## Example usage

### Minimum Usage Example

```yml
name: php-check-code
on: [pull_request]
jobs:
  php-check-code:
    name: runner / php-check-code
    runs-on: ubuntu-latest
    steps:
      - name: Check out code into the workspace
        uses: actions/checkout@v2
      - name: Check Code
        uses: ducla5/laravel-app-reviewdog-action@v1
        with:
          github_token: ${{ secrets.github_token }}
```

