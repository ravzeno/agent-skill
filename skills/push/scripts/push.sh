#!/usr/bin/env bash
# Push workflow helper for already-reviewed staged changes.
# --check is read-only; the default mode confirms, commits, then pushes.
# This script never stages files, amends commits, changes remotes, or force-pushes.

set -euo pipefail

fail() {
  printf 'Cannot continue: %s\n' "$1" >&2
  exit 1
}

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/push.sh --check
  bash scripts/push.sh --message "Commit message"
  bash scripts/push.sh  # prompt for a commit message

The interactive mode commits already-staged changes and pushes the current
branch to origin after the user chooses confirm. It never stages files.
USAGE
}

mode='push'
message=''
case "${1:-}" in
  --check)
    mode='check'
    shift
    ;;
  --help|-h)
    usage
    exit 0
    ;;
  --message)
    shift
    [[ $# -gt 0 ]] || fail 'provide a message after --message.'
    message="$*"
    ;;
  *)
    message="$*"
    ;;
esac

if [[ "$mode" == 'check' && $# -gt 0 ]]; then
  fail '--check does not accept additional arguments.'
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || fail 'run this inside a Git working tree.'
cd "$repo_root"

branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null)" || fail 'HEAD is detached; choose the intended branch before pushing.'

if ! git remote get-url origin >/dev/null 2>&1; then
  fail 'no origin remote is configured; confirm the intended remote before pushing.'
fi

origin_url_count="$(git remote get-url --all origin 2>/dev/null | awk 'END { print NR }')" || fail 'could not inspect origin configuration.'
[[ "$origin_url_count" == '1' ]] || fail "origin resolves to $origin_url_count URLs; confirm the intended remote before pushing."

if git diff --cached --quiet; then
  fail 'there are no staged changes to commit.'
fi

if ! git diff --cached --check; then
  fail 'the staged diff has whitespace errors; inspect and fix them before continuing.'
fi

printf 'Repository: %s\n' "$repo_root"
printf 'Branch: %s\n' "$branch"
printf 'Remote: origin (one URL configured; URL hidden)\n'
printf '\nStaged changes:\n'
git diff --cached --name-status
git diff --cached --stat

if ! git diff --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
  printf '\nNote: unstaged or untracked files exist; they will not be included.\n'
fi

if [[ "$mode" == 'check' ]]; then
  printf '\nPreflight passed. Inspect the full staged diff with: git diff --cached\n'
  exit 0
fi

[[ -t 0 && -t 1 ]] || fail 'an interactive terminal is required for commit-message confirmation.'

if [[ -z "$message" ]]; then
  printf '\nCommit message: '
  IFS= read -r message || fail 'could not read a commit message.'
fi
[[ -n "$message" ]] || fail 'the commit message cannot be empty.'

while true; do
  printf '\nCommit message:\n%s\n' "$message"
  printf '\n[1] ยืนยัน commit และ push\n[2] แก้ไขข้อความ commit\n[3] ยกเลิก\nเลือก [1-3]: '
  IFS= read -r choice || fail 'could not read a choice.'

  case "$choice" in
    1)
      break
      ;;
    2)
      printf 'ข้อความ commit ใหม่: '
      IFS= read -r edited_message || fail 'could not read the edited commit message.'
      if [[ -z "$edited_message" ]]; then
        printf 'ข้อความว่างไม่ได้เปลี่ยนข้อความเดิม\n' >&2
      else
        message="$edited_message"
      fi
      ;;
    3)
      printf 'ยกเลิกแล้ว: ไม่มีการ commit หรือ push\n'
      exit 0
      ;;
    *)
      printf 'กรุณาเลือก 1, 2 หรือ 3\n' >&2
      ;;
  esac
done

if ! git commit -m "$message"; then
  fail 'commit failed; nothing was pushed.'
fi

commit_hash="$(git rev-parse --short HEAD)"
if ! git push origin "$branch"; then
  printf 'Commit %s was created on %s, but pushing to origin failed. Inspect Git state before retrying.\n' "$commit_hash" "$branch" >&2
  exit 1
fi

printf 'Pushed commit %s from %s to origin.\n' "$commit_hash" "$branch"
