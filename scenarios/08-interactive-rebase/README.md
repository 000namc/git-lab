# interactive rebase: squash/fixup/reword/edit, autosquash

## 상황
`feature` 에 지저분한 커밋 7개: `wip`, 오타 메시지, `fixup!` 커밋, 두 개로 쪼개야 할 큰 커밋.

## 과제
1. `git rebase -i main` 으로 todo 목록을 열어 한 줄씩 의미를 읽는다(pick / reword / edit / squash / fixup / drop). 일단 아무것도 안 바꾸고 저장해 본다 — 무슨 일이 일어나나.
2. `wip` 를 앞 커밋에 `squash`(메시지 합침), `fxi typo` 를 `reword` 로 고치기. `git log --oneline` 으로 확인.
3. `fixup!` 커밋: `git rebase -i --autosquash main` 을 열면 todo 가 이미 정렬돼 있다. 그대로 저장. `git config rebase.autosquash true` 로 기본값으로 만들 수 있다.
4. 큰 커밋 쪼개기: 해당 줄을 `edit` 으로 바꿔 멈춘 뒤 `git reset HEAD~1` (mixed) → `git add -p big.py` 로 part A 만 → `git commit -m "feat: part A"` → 나머지 → `git commit -m "feat: part B"` → `git rebase --continue`.
5. 순서 바꾸기: `docs(api): docstring` 을 `feat(api): get endpoint` 바로 뒤로 옮겨 보라. 충돌이 나면 왜인지 생각하고 해결.
6. 에디터 없이 자동화: `GIT_SEQUENCE_EDITOR="sed -i 's/^pick \(.*\) wip$/squash \1 wip/'" git rebase -i main`. 스크립트에서 rebase -i 를 쓰는 방법이다.

## 생각해볼 것
- squash 와 fixup 의 차이는 메시지뿐인가.
- `fixup!` 커밋을 만드는 `git commit --fixup=<해시>` 는 언제 쓰면 좋은가(리뷰 반영 중).
- 이 작업을 push 한 브랜치에 했다면 무슨 일이 생기나(11단계).
