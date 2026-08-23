# 세 공간: 작업트리·인덱스·HEAD, reset soft/mixed/hard

## 상황
커밋 4개. `app.py` 는 HEAD(0.1) / 인덱스(0.2) / 작업트리(0.3 + `run!`) 가 전부 다르다. `notes.txt` 는 untracked.

## 과제
1. `git status` 의 두 구역("Changes to be committed" / "Changes not staged")이 각각 어느 두 공간의 차이인지 말해 보라.
2. `git diff` 와 `git diff --staged` 와 `git diff HEAD` 세 결과를 비교하라. 각각 무엇과 무엇의 차이인가.
3. `git add -p app.py` 로 `run!` 변경만 인덱스에 올리고 VERSION 0.3 은 남겨 두라. `git diff --staged` 로 확인.
4. `git restore --staged app.py` 와 `git restore app.py` 가 각각 어느 공간을 되돌리는지 해 보고 `git diff*` 로 확인. (망쳤으면 `lab reset`)
5. `git commit --amend` 로 마지막 커밋 메시지를 고쳐라. 해시가 바뀌는 이유는?
6. reset 세 모드. 매번 `lab reset 02-three-areas` 로 초기화한 뒤:
   - `git reset --soft HEAD~1` → `git status`, `git log --oneline`
   - `git reset HEAD~1` (mixed) → 동일하게 확인
   - `git reset --hard HEAD~1` → 동일하게 확인. 작업트리의 0.3 은 어디로 갔나.
   세 모드가 HEAD / 인덱스 / 작업트리 중 어디까지 움직이는지 표로 정리.

## 생각해볼 것
- `reset --hard` 로 날린 작업트리 변경은 돌아오나? (커밋된 것과 안 된 것의 차이 — 9단계 reflog)
- 인덱스가 없고 작업트리 → 커밋만 있었다면 `add -p` 같은 일이 가능했을까.
