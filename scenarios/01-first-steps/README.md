# git 첫걸음: 레포를 만들고 커밋을 쌓고 읽는다

## 상황
`.git`이 없는 파이썬 프로젝트. `src/`, `README.md`, 그리고 올리면 안 되는 `build/`·`.env`.

## 과제
1. `git init` 하고 `ls -A .git` 으로 안에 뭐가 생겼는지 본다. `cat .git/HEAD`.
2. `git config --list --show-origin | grep user` — 이 컨테이너의 신원은 어느 층에 있나. `git config --local user.name "<이름>"` 으로 이 레포에만 다른 신원을 주고 다시 확인.
3. `git status` → `git add src README.md` → `git status` → `git commit -m "init: project skeleton"`. 커밋 후 `git log --stat`.
4. `src/app.py` 의 인사말을 바꾸고 `git diff`. 그 다음 `git commit -v` (에디터에 diff 가 같이 뜬다) — 제목 한 줄, 빈 줄, 본문.
5. `.gitignore` 에 `build/` 와 `.env` 를 넣고 `git status` 가 깨끗해지는지 확인. 커밋.
6. 실수로 추적 중인 파일 빼기: `echo 'x' > notes.txt && git add . && git commit -m "oops"`. 그 다음 `notes.txt` 를 `.gitignore` 에 넣어도 status 에 계속 뜨는 것을 확인하고 `git rm --cached notes.txt` 로 해결.
7. `git mv src/util.py src/text.py` 후 `git status` — git 이 rename 을 어떻게 보여주나. 커밋.
8. `git log --oneline`, `git show HEAD~2`, `git diff HEAD~3 HEAD -- src/` 로 지금까지를 읽는다.

## 생각해볼 것
- `git add .` 을 습관처럼 치면 6번 같은 일이 생긴다. 무엇을 올릴지 고르는 단계(add)가 왜 따로 있나.
- 커밋 하나에 "하나의 이유"만 담으라는 말은 8단계(interactive rebase)에서 왜 중요해지나.
