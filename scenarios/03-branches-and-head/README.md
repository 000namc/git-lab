# 브랜치와 HEAD: 브랜치=포인터, switch, detached HEAD

## 상황
`main`, `feature/login`, `hotfix` 세 브랜치와 태그 `v0.1`.

## 과제
1. `cat .git/HEAD`, `ls .git/refs/heads`, `cat .git/refs/heads/main`, `git rev-parse main` — 브랜치가 파일 하나라는 걸 눈으로 확인. (`refs` 가 안 보이면 `cat .git/packed-refs`)
2. `git switch feature/login` 후 `cat .git/HEAD` 가 어떻게 바뀌었나. 작업트리의 파일 목록은?
3. `git switch --detach v0.1` → `git status` 첫 줄. 여기서 `echo x > x.txt && git add . && git commit -m "detached commit"`. `git log --oneline --graph --all` 에 이 커밋이 어떻게 보이나.
4. `git switch main` 하면 3의 커밋은 어디로 갔나. `git reflog` 에서 찾아 `git branch rescued <해시>` 로 살려라.
5. `git branch -d hotfix` 가 거부되는 이유를 읽고, `-D` 로 지운 뒤 `git reflog` 로 다시 살려라.
6. `git log --oneline --graph --all` 을 한 줄씩 읽어 보라: 각 `*` 는 커밋, 괄호는 그 커밋을 가리키는 ref, `|/` 는 갈라짐.

## 생각해볼 것
- "브랜치를 만든다"는 비용이 왜 0에 가깝나.
- detached HEAD 는 위험한가? 무엇이 유일한 위험인가.
