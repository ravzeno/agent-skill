#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: inspect-release.sh <base-tag> <target-tag>

Prints commit and file-change evidence between two locally available Git tags.
The script does not fetch, check out, or modify repository files or refs.
USAGE
}

if [[ $# -ne 2 ]]; then
  usage >&2
  exit 2
fi

base_tag=$1
target_tag=$2

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  printf 'Error: run this script inside a Git working tree.\n' >&2
  exit 2
fi

resolve_tag() {
  local tag_name=$1
  local commit
  if ! commit=$(git rev-parse --verify --quiet "refs/tags/${tag_name}^{commit}"); then
    printf 'Error: local tag not found or does not resolve to a commit: %s\n' "$tag_name" >&2
    return 1
  fi
  printf '%s\n' "$commit"
}

if ! base_commit=$(resolve_tag "$base_tag"); then
  exit 1
fi
if ! target_commit=$(resolve_tag "$target_tag"); then
  exit 1
fi

printf 'Base tag:   %s (%s)\n' "$base_tag" "${base_commit:0:12}"
printf 'Target tag: %s (%s)\n' "$target_tag" "${target_commit:0:12}"

if git merge-base --is-ancestor "$base_commit" "$target_commit"; then
  printf 'Ancestry:   base is an ancestor of target\n'
else
  ancestry_status=$?
  if [[ $ancestry_status -eq 1 ]]; then
    printf 'Ancestry:   base is not an ancestor of target; review branch history carefully\n'
  else
    printf 'Error: unable to determine tag ancestry.\n' >&2
    exit "$ancestry_status"
  fi
fi

printf '\nCommits (base..target):\n'
git log --format='- %h %s' "$base_commit..$target_commit"

printf '\nFile changes (rename detection enabled):\n'
added=0
modified=0
deleted=0
renamed=0
copied=0
type_changed=0
other=0

while IFS= read -r -d '' status; do
  first_path=''
  second_path=''
  IFS= read -r -d '' first_path || {
    printf 'Error: incomplete NUL-delimited Git diff output.\n' >&2
    exit 1
  }

  case ${status:0:1} in
    R|C)
      IFS= read -r -d '' second_path || {
        printf 'Error: incomplete rename/copy entry in Git diff output.\n' >&2
        exit 1
      }
      ;;
  esac

  case ${status:0:1} in
    A) ((added += 1)) ;;
    M) ((modified += 1)) ;;
    D) ((deleted += 1)) ;;
    R) ((renamed += 1)) ;;
    C) ((copied += 1)) ;;
    T) ((type_changed += 1)) ;;
    *) ((other += 1)) ;;
  esac

  printf '  %s ' "$status"
  printf '%q' "$first_path"
  if [[ -n $second_path ]]; then
    printf ' -> '
    printf '%q' "$second_path"
  fi
  printf '\n'
done < <(git diff --name-status --find-renames --find-copies "$base_commit" "$target_commit" --)

printf '\nCounts: added=%d modified=%d deleted=%d renamed=%d copied=%d type_changed=%d other=%d\n' \
  "$added" "$modified" "$deleted" "$renamed" "$copied" "$type_changed" "$other"
