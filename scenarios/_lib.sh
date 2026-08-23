# 시나리오 공통 헬퍼. setup.sh 에서 `source /scenarios/_lib.sh` 로 불러온다.
# 커밋 날짜를 고정해 같은 시나리오면 항상 같은 해시가 나오게 한다.
_T=1700000000
tick() { _T=$((_T + 60)); export GIT_AUTHOR_DATE="@$_T +0000" GIT_COMMITTER_DATE="@$_T +0000"; }
# c <파일> <내용> <메시지> : 파일에 한 줄 덧붙이고 add + commit
c()  { printf '%s\n' "$2" >> "$1"; git add "$1"; tick; git commit -q -m "$3"; echo "  + $3"; }
# w <파일> <내용> <메시지> : 파일을 통째로 바꿔 쓰고 add + commit
w()  { printf '%s\n' "$2" > "$1"; git add "$1"; tick; git commit -q -m "$3"; echo "  + $3"; }
# cm <메시지> : 스테이지된 것을 커밋
cm() { tick; git commit -q -m "$1"; echo "  + $1"; }
# 새 레포 시작
fresh() { git init -q; echo "repo: $(pwd)"; }
# 사용자 커밋 시각 고정 해제 (실습 중 사용자가 만드는 커밋은 현재 시각)
unfix() { unset GIT_AUTHOR_DATE GIT_COMMITTER_DATE; }
