source /scenarios/_lib.sh
fresh
mkdir -p src
w README.md '# objects' "init: readme"
w src/a.txt 'alpha' "feat: a"
w src/b.txt 'alpha' "feat: b (same content as a)"
git tag -a v1 -m "release v1" 2>/dev/null || git tag v1
unfix
echo; git log --oneline; echo; echo ".git/objects:"; find .git/objects -type f | sed 's#.git/objects/##' | sort
