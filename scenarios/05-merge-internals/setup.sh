source /scenarios/_lib.sh
fresh
printf 'line1\nline2\nline3\nline4\nline5\n' > f.txt; git add f.txt; cm "init: f.txt"
w g.txt 'g' "feat: g.txt"
# ff 케이스: main 이 멈춰 있는 동안 앞으로만 간 브랜치
git switch -q -c ff
c g.txt 'g2' "feat(ff): g2"
git switch -q main
# 3-way 케이스: 서로 다른 파일 수정 → 충돌 없음
git switch -q -c threeway
w g.txt 'g changed on threeway' "feat(threeway): g"
git switch -q main
# 충돌 케이스: 같은 줄을 양쪽이 다르게
git switch -q -c conflict
sed -i 's/line3/line3-conflict/' f.txt; git add f.txt; cm "feat(conflict): line3"
git switch -q main
sed -i 's/line3/line3-main/' f.txt; git add f.txt; cm "feat(main): line3"
unfix
echo; git log --oneline --graph --all
