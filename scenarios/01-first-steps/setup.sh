# git 레포가 아닌 맨 프로젝트. 사용자가 init 부터 직접 한다.
mkdir -p src build
cat > src/app.py <<'PY'
def greet(name):
    return f"hello, {name}"

if __name__ == "__main__":
    print(greet("git"))
PY
cat > src/util.py <<'PY'
def slug(s):
    return s.lower().replace(" ", "-")
PY
printf '# first-steps\n\n작은 파이썬 프로젝트.\n' > README.md
printf 'compiled junk\n' > build/app.pyc
printf 'secret=1234\n' > .env
echo "프로젝트 파일만 있고 .git 은 없다:"; ls -A
