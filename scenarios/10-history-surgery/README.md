# 히스토리 수술: cherry-pick, revert, bisect, filter-repo

## 상황
커밋 20여 개. 어딘가에서 `calc.py` 가 망가져 `./test.sh` 가 실패한다. `secrets.env` 가 히스토리에 들어갔다 지워졌다. `other` 브랜치에 가져오고 싶은 커밋 하나, `main` 에 되돌리고 싶은 merge 커밋 하나.

## 과제
1. cherry-pick: `other` 의 `fix: useful fix` 만 main 으로. `git log --oneline other` 에서 해시를 찾아 `git cherry-pick <해시>`. 새 커밋의 해시·author·committer 를 원본과 비교(`git show --format=fuller`).
2. revert: 일반 커밋 하나를 `git revert <해시>` 해 보고, merge 커밋 `Merge branch 'feature'` 를 `git revert <해시>` → 실패 메시지 → `git revert -m 1 <해시>`. `-m 1` 의 뜻.
3. bisect: `git bisect start`, `git bisect bad HEAD`, `git bisect good <첫 커밋>`, 그리고 `git bisect run ./test.sh`. 찾은 커밋을 `git show`. `git bisect reset`. 몇 번 만에 찾았나(log2).
4. filter-repo: `git log --all --oneline -- secrets.env` 로 아직 히스토리에 있는지 확인. `git filter-repo --path secrets.env --invert-paths --force` 후 다시 확인. 모든 커밋 해시가 왜 바뀌었나. (`--force` 는 fresh clone 이 아닐 때 필요)
5. 4 이후 `git reflog` 와 `.git/filter-repo/` 를 보라. 원격이 있었다면 무엇을 해야 하나(force push + 모든 협업자 re-clone).

## 생각해볼 것
- revert 와 reset 의 차이를 "공유된 히스토리" 관점에서.
- bisect 가 동작하려면 커밋마다 무엇이 보장돼야 하나 — 8단계 "하나의 이유 하나의 커밋"과의 관계.
