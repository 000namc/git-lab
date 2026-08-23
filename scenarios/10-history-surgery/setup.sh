source /scenarios/_lib.sh
fresh
cat > test.sh <<'T'
#!/bin/sh
# 회귀 테스트: calc.py 가 4를 출력해야 통과
[ "$(python3 calc.py)" = "4" ]
T
chmod +x test.sh
w calc.py 'print(2+2)' "feat: calc"; git add test.sh; cm "test: add test.sh"
for i in $(seq 1 12); do
  w note$i.txt "note $i" "chore: note $i"
  if [ $i -eq 7 ]; then w calc.py 'print(2*3-1)' "refactor: simplify calc (introduces bug)"; fi
done
# 비밀 파일이 섞여 들어간 히스토리
w secrets.env 'API_KEY=hunter2' "chore: add env (oops)"
w note13.txt 'note 13' "chore: note 13"
git rm -q secrets.env; cm "chore: remove env"
# cherry-pick 대상: 다른 브랜치의 커밋 하나
git switch -q -c other
w fix.txt 'useful fix' "fix: useful fix on other"
w noise.txt 'noise' "chore: noise on other"
git switch -q main
# revert 대상: merge 커밋
git switch -q -c feature
w feat.txt 'feature' "feat: feature to be reverted"
git switch -q main
tick; git merge -q --no-ff -m "Merge branch 'feature'" feature
unfix
echo; git log --oneline | head -5; echo "..."; echo "커밋 $(git rev-list --count HEAD)개. ./test.sh 는 지금 실패한다 (exit $(./test.sh; echo $?))"
