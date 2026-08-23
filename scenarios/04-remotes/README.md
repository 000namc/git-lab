# 원격 기본: bare repo 로 clone/fetch/pull/push, tracking branch

## 상황
`origin.git`(bare) 을 `alice/` 와 `bob/` 이 clone 했다. alice 는 `v2` 를 push 했고 bob 은 아직 `v1` 까지만 안다.

## 과제 (bob/ 에서 시작)
1. `git remote -v`, `git branch -vv`, `cat .git/config` — origin 과 tracking branch 가 어디에 적혀 있나.
2. `git log --oneline --all` 로 `origin/main` 이 어디를 가리키는지 보고 `git fetch` 후 다시 보라. `main` 은 움직였나? 작업트리는?
3. `git status` 가 "behind 1" 이라고 하는 근거가 무엇인지(`main` 과 `origin/main` 의 차이). `git merge origin/main` (= pull 의 나머지 절반).
4. bob 에서 `app.txt` 를 `v3-bob` 으로 바꿔 커밋·push. 그 다음 `alice/` 로 가서 `app.txt` 를 `v3-alice` 로 바꿔 커밋하고 push — 거부된다. 메시지를 읽고 왜인지 설명. `git fetch` 후 `git log --oneline --graph --all`.
5. alice 에서 해결: `git pull` (merge) 또는 `git pull --rebase` 중 하나를 고르고 결과 그래프를 비교. 충돌이 나면 해결.
6. bob 에서 새 브랜치 `feature/x` 를 만들어 `git push -u origin feature/x`. `git branch -vv` 와 `.git/config` 가 어떻게 바뀌었나.

## 생각해볼 것
- `origin/main` 은 원격의 상태인가, 마지막으로 fetch 한 시점의 복사본인가.
- pull = fetch + ? 인데 왜 fetch 를 따로 치는 습관이 도움이 되나.
