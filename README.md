# git-lab

git을 제대로 이해하고 싶은 사람을 위한 실습 과정. Docker 컨테이너 안에 시나리오별 레포를 만들어 두고,
문서를 따라 직접 명령을 치면서 `git init`부터 interactive rebase, reflog 복구, 협업 규칙까지 올라간다.
커밋 날짜와 신원을 고정해 두어 **누가 언제 돌려도 문서와 같은 해시**가 나온다.

## 시작하기

```
git clone https://github.com/000namc/git-lab.git && cd git-lab
./lab.sh build                    # 이미지 빌드 (Docker Desktop 필요, 1~2분)
./lab.sh                          # 컨테이너 셸
lab list                          # 시나리오 목록
lab start 00-smoke                # 환경 검증용 레포 생성
cd /work/00-smoke && git log --oneline --graph --all
```

`docs/00-environment.md`와 해시까지 같은 그래프가 나오면 준비 끝이다. 이후는 `docs/01-first-steps.md`부터 순서대로 읽으며
`lab start <시나리오>`로 따라간다. 망치면 `lab reset <시나리오>`(그 뒤 `cd`를 다시 할 것).

## 커리큘럼

단계 번호 = 시나리오 번호 = 문서 번호. 문서는 "무엇을 배우나 / 실습 순서(실제 출력 포함) / 정리"로 구성된다.

| # | 주제 | 시나리오 | 문서 |
|---|------|----------|------|
| 0 | 실습 환경 | `00-smoke` | [00-environment.md](docs/00-environment.md) |
| 1 | git 첫걸음: init/clone/config, add/commit, log/show/diff, .gitignore | `01-first-steps` | [01-first-steps.md](docs/01-first-steps.md) |
| 2 | 세 공간: 작업트리·인덱스·HEAD, reset soft/mixed/hard | `02-three-areas` | 준비 중 |
| 3 | 브랜치와 HEAD: 브랜치=포인터, switch, detached HEAD | `03-branches-and-head` | 준비 중 |
| 4 | 원격 기본: bare repo로 clone/fetch/pull/push, tracking branch | `04-remotes` | 준비 중 |
| 5 | merge 내부: fast-forward, 3-way, merge-base, 충돌 | `05-merge-internals` | 준비 중 |
| 6 | 객체 모델: blob/tree/commit, refs — cat-file로 확인 | `06-object-model` | 준비 중 |
| 7 | rebase 기초와 `--onto` | `07-rebase` | 준비 중 |
| 8 | interactive rebase: squash/fixup/reword/edit, autosquash | `08-interactive-rebase` | 준비 중 |
| 9 | reflog와 복구 | `09-reflog-recovery` | 준비 중 |
| 10 | 히스토리 수술: cherry-pick, revert, bisect, filter-repo | `10-history-surgery` | 준비 중 |
| 11 | 협업 규칙: force-with-lease, 공유 브랜치 rebase 금지 | `11-collaboration` | 준비 중 |
| 12 | 곁가지: worktree, rerere, stash, sparse-checkout | `12-odds-and-ends` | 준비 중 |

시나리오(`setup.sh`와 과제 `README.md`)는 12단계까지 전부 들어 있다. 문서는 검토가 끝나는 순서대로 올라온다.

## 구성

```
build/         실습 환경: Dockerfile, docker-compose.yaml, lab 런처, build.org(재현 명령)
scenarios/     NN-이름/setup.sh(상황 재현) + README.md(과제). 컨테이너 안 `lab start NN-이름`
docs/          단계별 문서 NN-이름.md
tools/         문서 내보내기 등 보조 스크립트
lab.sh         호스트 진입점 (build / shell / clean)
```

- 컨테이너: Debian bookworm, git 2.39, git-filter-repo, tig. 신원은 `git-lab <lab@example.com>`으로 고정.
- `/scenarios`는 읽기 전용 마운트, `/work`는 컨테이너 내부 임시 공간이다. 나가면 사라지고 `lab start`로 재현된다.
- `git lg`는 컨테이너 전용 alias(`log --oneline --graph --decorate --all`). 문서에는 항상 풀어 쓴 명령을 적는다.
- 시나리오를 추가하려면 `scenarios/NN-이름/`에 `setup.sh`(`source /scenarios/_lib.sh` 뒤 `c`/`w`/`cm` 헬퍼로 커밋)와 `README.md`(첫 줄 `# 제목`이 `lab list`에 뜬다)를 둔다.
