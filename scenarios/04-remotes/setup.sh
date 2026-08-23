source /scenarios/_lib.sh
# bare 원격 하나, clone 둘 (alice, bob)
git init -q --bare origin.git
git clone -q origin.git alice
cd alice
w README.md '# shared project' "init: readme"
w app.txt 'v1' "feat: v1"
git push -q origin main
cd ..
git clone -q origin.git bob
# alice 가 한 발 앞서 나간다 (bob 은 아직 모름)
cd alice
w app.txt 'v2' "feat: v2"
git push -q origin main
cd ..
unfix
echo; echo "origin.git (bare) / alice / bob"; ls
echo; (cd bob && git log --oneline --all)
