source /scenarios/_lib.sh
fresh
w a.txt '1' "feat: 1"
w a.txt '2' "feat: 2"
w a.txt '3' "feat: 3 (will be lost by reset)"
w a.txt '4' "feat: 4 (will be lost by reset)"
git switch -q -c experiment
w exp.txt 'x' "feat(exp): x (branch will be deleted)"
w exp.txt 'y' "feat(exp): y (branch will be deleted)"
git switch -q main
# 사고 1: reset --hard 로 두 커밋 날림
git reset -q --hard HEAD~2
# 사고 2: 브랜치 강제 삭제
git branch -q -D experiment
# 사고 3: detached 에서 커밋하고 떠남
git switch -q --detach HEAD~1
w orphan.txt 'o' "feat: orphan commit (dangling)"
git switch -q main
# 사고 4: 커밋 없이 스테이지만 했다가 reset --hard
echo 'staged but never committed' > lost.txt; git add lost.txt
git reset -q --hard
unfix
echo; git log --oneline --all; echo; echo "사고 4건이 일어난 뒤다. 무엇을 잃었는지 README 를 보라."
