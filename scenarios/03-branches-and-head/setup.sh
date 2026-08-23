source /scenarios/_lib.sh
fresh
w main.txt 'v1' "feat: v1"
w main.txt 'v2' "feat: v2"
git tag v0.1
git switch -q -c feature/login
w login.txt 'login form' "feat(login): form"
w login.txt 'login form + validation' "feat(login): validation"
git switch -q main
w main.txt 'v3' "feat: v3"
git switch -q -c hotfix
w main.txt 'v3 hotfix' "fix: hotfix on v3"
git switch -q main
unfix
echo; git log --oneline --graph --all
