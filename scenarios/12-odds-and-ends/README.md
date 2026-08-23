# 곁가지: worktree, rerere, stash, sparse-checkout

## 상황
`main` 과 `topic` 이 `src/app.py` 에서 충돌할 구조. 작업트리에 미커밋 변경(README 수정, untracked 파일).

## 과제
1. stash: `git stash` 후 `git status` → untracked 는 남는다. `git stash -u` 로 다시. `git stash list`, `git stash show -p`, `git stash pop`. stash 가 실은 커밋이라는 것을 `git log --oneline --all` 또는 `git cat-file -p stash` 로 확인.
2. worktree: `git worktree add ../topic-wt topic` → 다른 디렉터리에서 `topic` 을 동시에 체크아웃. `git worktree list`. 같은 브랜치를 두 worktree 에서 체크아웃하려 하면? 정리는 `git worktree remove`.
3. rerere: `git config rerere.enabled true`. `git merge topic` → 충돌 → 해결·커밋. `git reset --hard HEAD~1` 로 merge 를 되돌리고 다시 `git merge topic` → 같은 충돌이 자동 해결되는 것을 확인(`git rerere diff`, `.git/rr-cache`).
4. sparse-checkout: `git clone --no-checkout . ../sparse && cd ../sparse && git sparse-checkout set src docs && git checkout main` → `ls`. `src/big` 을 빼려면 `git sparse-checkout set --no-cone src/app.py docs`.

## 생각해볼 것
- stash 보다 "임시 브랜치에 커밋" 이 나은 경우는.
- rerere 가 위험해질 수 있는 상황(잘못된 해결을 기억).
