# 협업 규칙: force-with-lease, 공유 브랜치 rebase 금지

## 상황
alice 가 `feature`(f1, wip) 를 push 했다. bob 은 그 브랜치를 받아 커밋 하나를 얹었고 아직 push 전이다.

## 과제
1. alice/ 에서 `git rebase -i main` 으로 `wip` 를 f1 에 squash. `git push` → 거부. 메시지와 `git status`("diverged") 를 읽는다. `git log --oneline --graph --all` 로 로컬과 `origin/feature` 가 갈라진 모양을 본다.
2. alice 가 `git push --force` 한다(하지 말라는 걸 해 본다). bob/ 으로 가서 `git fetch` 후 `git log --oneline --graph --all` — bob 의 커밋이 어떤 처지가 됐나. bob 이 `git pull` 하면 무슨 일이 생기나(해 보라).
3. `lab reset` 후 같은 상황에서 이번엔 bob 이 먼저 `git push` 한다. 그 다음 alice 가 squash 하고 `git push --force-with-lease` → 거부. 왜 `--force` 와 다른가. alice 는 이제 무엇을 해야 하나(`fetch` 하고 bob 커밋을 자기 위에 rebase 한 뒤 다시 lease push).
4. bob 이 alice 의 force push 를 받아들이는 올바른 절차. `git fetch` 후 `git rebase origin/feature` 를 먼저 해 보라 — squash 로 patch 가 달라져 alice 의 옛 커밋까지 같이 옮기려다 충돌한다. `git rebase --abort` 뒤 `git reflog show origin/feature` 로 옛 tip 을 찾아 `git rebase --onto origin/feature origin/feature@{1} feature` (자기 커밋만 새 기반 위로). 자기 커밋이 없다면 `git reset --hard origin/feature`.
5. 규칙을 문장으로 적어라: 어떤 브랜치는 rebase 해도 되고 어떤 브랜치는 안 되나. 기준은 "push 했나"가 아니라 무엇인가.

## 생각해볼 것
- `--force-with-lease` 가 막지 못하는 경우(`fetch` 만 하고 merge 안 한 상태에서 lease).
- PR 브랜치를 merge 전에 정리(rebase -i)하는 관행과 "공유 브랜치 rebase 금지"는 어떻게 양립하나.
