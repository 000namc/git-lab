# 객체 모델: blob/tree/commit, refs — cat-file 로 확인

## 상황
커밋 3개, 태그 1개. `src/a.txt` 와 `src/b.txt` 의 내용이 같다.

## 과제
1. `git cat-file -t HEAD`, `git cat-file -p HEAD` — commit 객체의 네 줄(tree, parent, author, committer)을 읽는다.
2. 그 `tree` 해시로 `git cat-file -p <tree>` → `src` 가 또 tree. 따라 내려가 `a.txt` 의 blob 까지 `cat-file -p`.
3. `a.txt` 와 `b.txt` 의 blob 해시가 같은 이유. `find .git/objects -type f | wc -l` 로 객체 수를 세고 설명해 보라.
4. `echo alpha | git hash-object --stdin` 이 3의 해시와 같은지. `-w` 를 붙이면 무엇이 달라지나.
5. `git cat-file -p v1` — 태그 객체. `git cat-file -p HEAD~2` 의 parent 줄이 없는 이유.
6. 브랜치를 명령 없이 만들기: `git update-ref refs/heads/manual HEAD~1` → `git branch`. 다시 `cat .git/refs/heads/manual`.
7. `git gc` 후 `find .git/objects -type f` — loose 객체가 packfile 로 바뀐다. `git verify-pack -v .git/objects/pack/*.idx | head` 로 안을 본다.

## 생각해볼 것
- "커밋은 diff 가 아니라 스냅샷" 인데 저장 공간이 폭발하지 않는 이유 두 가지(blob 공유, packfile delta).
- rebase 가 커밋을 "옮길" 수 없는 이유를 commit 객체의 필드로 설명해 보라.
