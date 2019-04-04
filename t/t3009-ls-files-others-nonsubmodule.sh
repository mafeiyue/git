#!/bin/sh

test_description='test git ls-files --others with non-submodule repositories

This test runs git ls-files --others with the following working tree:

    repo-bogus-no-files/
      directory with no files aside from a bogus .git file
    repo-bogus-untracked-file/
      directory with a bogus .git file and another untracked file
    repo-no-commit-no-files/
      git repository without a commit or a file
    repo-no-commit-untracked-file/
      git repository without a commit but with an untracked file
    repo-with-commit-no-files/
      git repository with a commit and no untracked files
    repo-with-commit-untracked-file/
      git repository with a commit and an untracked file
'

. ./test-lib.sh

test_expect_success 'setup: expected output' '
	cat >expected <<-EOF
	expected
	output
	repo-bogus-untracked-file/untracked
	repo-no-commit-no-files/
	repo-no-commit-untracked-file/
	repo-with-commit-no-files/
	repo-with-commit-untracked-file/
	EOF
'

test_expect_success 'setup: directories' '
	mkdir repo-bogus-no-files &&
	echo foo >repo-bogus-no-files/.git &&
	mkdir repo-bogus-untracked-file &&
	echo foo >repo-bogus-untracked-file/.git &&
	: >repo-bogus-untracked-file/untracked &&
	git init repo-no-commit-no-files &&
	git init repo-no-commit-untracked-file &&
	: >repo-no-commit-untracked-file/untracked &&
	git init repo-with-commit-no-files &&
	git -C repo-with-commit-no-files commit --allow-empty -mmsg &&
	git init repo-with-commit-untracked-file &&
	test_commit -C repo-with-commit-untracked-file msg &&
	: >repo-with-commit-untracked-file/untracked
'

test_expect_success 'ls-files --others handles non-submodule .git' '
	git ls-files -o >output &&
	test_cmp expected output
'

test_done
