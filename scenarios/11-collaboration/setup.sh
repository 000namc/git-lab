source /scenarios/_lib.sh
git init -q --bare origin.git
git clone -q origin.git alice; git clone -q origin.git bob
cd alice
w README.md '# team' "init: readme"
git push -q origin main
git switch -q -c feature
w f.txt 'f1' "feat: f1"
c f.txt 'f2 wip' "wip"
git push -q -u origin feature
cd ../bob
git fetch -q; git switch -q -c feature origin/feature
c f.txt 'bob addition' "feat: bob adds to feature"
cd ..
unfix
echo; echo "alice: feature 를 push 함 (f1, wip). bob: 그 feature 를 받아 커밋 하나 추가 (아직 push 안 함)"
