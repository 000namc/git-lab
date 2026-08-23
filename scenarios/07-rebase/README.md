# rebase 기초와 --onto

## 상황
`main` 이 두 커밋 전진한 사이 `feature` 가 세 커밋, 그 위에서 `topic` 이 두 커밋. `conflicting` 은 main 에서 app.py 같은 줄을 다르게 고쳤다.

## 과제
1. `git log --oneline --graph --all` 을 그리고(종이에), `git merge-base main feature` 를 확인.
2. `feature` 에서 `git rebase main`. 그래프가 어떻게 바뀌었나. feature 커밋 세 개의 해시가 전부 바뀐 이유를 commit 객체의 어느 필드로 설명할 수 있나(6단계).
3. `git reflog show feature` 로 rebase 전 끝 커밋을 찾아 `git branch feature-before <해시>`. 그래프에서 옛 줄기와 새 줄기가 나란히 보인다.
4. `topic` 은 아직 옛 feature 위에 있다. `git rebase --onto feature feature-before topic` 으로 새 feature 위로 옮겨라. `--onto A B C` 가 각각 무엇인지 말로 설명.
5. `git switch conflicting && git rebase feature` → 충돌. `git status` 를 읽고 `app.py` 를 고쳐 `git add` → `git rebase --continue`. 중간에 `git rebase --abort` 도 한 번 해 보라.
6. `lab reset` 후 `git rebase -i` 없이 `git rebase main feature` 를 `GIT_TRACE=1` 로 돌려(출력이 많다) 내부에서 무엇을 반복 호출하는지 훑어보라. 힌트: cherry-pick 에 해당하는 동작.

## 생각해볼 것
- rebase 후 `feature-before` 가 없다면 옛 커밋들은 언제 정말 사라지나.
- 이미 push 한 feature 를 rebase 하면 원격의 feature 와 어떤 관계가 되나(11단계).
