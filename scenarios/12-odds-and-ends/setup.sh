source /scenarios/_lib.sh
fresh
mkdir -p docs src/big
w README.md '# odds' "init: readme"
w src/app.py 'app' "feat: app"
for i in 1 2 3; do w src/big/part$i.txt "big $i" "feat: big part $i"; done
w docs/guide.md 'guide' "docs: guide"
# rerere 연습용: 같은 충돌이 두 번 날 구조
git switch -q -c topic
w src/app.py 'app (topic)' "feat(topic): app"
git switch -q main
w src/app.py 'app (main)' "feat(main): app"
# stash 연습용 미커밋 변경
echo 'dirty' >> README.md; echo 'new' > untracked.txt
unfix
echo; git log --oneline --graph --all; echo; git status --short
