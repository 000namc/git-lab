# merge 내부: fast-forward, 3-way, merge-base, 충돌

## 상황
`main` 에서 세 브랜치가 갈라져 있다: `ff`(앞으로만 감), `threeway`(다른 파일 수정), `conflict`(같은 줄 수정).

## 과제
1. `git merge-base main ff`, `main threeway`, `main conflict` — 각각 어디인가. `git log --oneline --graph --all` 로 확인.
2. `git merge ff` 는 왜 ff 가 아닌가(힌트: main 이 그 사이 움직였다). `lab reset` 하고 `git switch -c tmp <merge-base>` 상태에서 `git merge ff` 하면? `--ff-only` 와 `--no-ff` 의 결과를 각각 `git log --oneline --graph` 로 비교.
3. `main` 에서 `git merge threeway` → merge 커밋이 생긴다. `git cat-file -p HEAD` 로 parent 가 둘인 것을 확인. `git log --first-parent --oneline` 과 그냥 `git log --oneline` 의 차이.
4. `git merge conflict` → 충돌. `git status`, `cat f.txt` 의 `<<<<<<< ======= >>>>>>>` 를 읽고 `git diff` 가 보여주는 것(3-way diff) 을 해석. `git merge --abort` 로 되돌린 뒤, 다시 merge 해서 직접 해결·`git add`·`git commit`.
5. `git log -1 -p` 로 merge 커밋의 diff 가 어떻게 보이는지(보통 비어 보인다). `git show --first-parent HEAD` 와 비교.

## 생각해볼 것
- 3-way 의 "3" 은 무엇 셋인가. base 가 없으면(관계없는 히스토리) 어떻게 되나(`--allow-unrelated-histories`).
- merge 커밋을 revert 하려면 왜 `-m` 이 필요한가(10단계).
