# 시나리오 공통 헬퍼. setup.sh 에서 `source /scenarios/_lib.sh` 로 불러온다.
# 커밋 날짜를 고정해 같은 시나리오면 항상 같은 해시가 나오게 한다.
_T=1700000000
tick() { _T=$((_T + 60)); export GIT_AUTHOR_DATE="@$_T +0000" GIT_COMMITTER_DATE="@$_T +0000"; }
# c <파일> <내용> <메시지> : 파일 쓰고 add + commit
c() { printf '%s\n' "$2" >> "$1"; git add "$1"; tick; git commit -q -m "$3"; echo "  + $3"; }
# 새 레포 시작
fresh() { git init -q; echo "repo: $(pwd)"; }
