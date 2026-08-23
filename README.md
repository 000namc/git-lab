# git-study

git 을 중급 이상 수준으로 다시 공부하는 기록. 객체 모델에서 시작해 rebase/interactive rebase,
reflog 복구, 히스토리 수술, 협업 규칙까지 다룬다. 공부 내용은 kata 이슈로 관리하고 `docs/kata/`에
문서로 정리한 뒤 블로그 글로 다듬는다.

## 구성

```
build/         실습 환경 빌드 정보 한자리: Dockerfile, docker-compose.yaml, bashrc, lab 런처, build.org(재현 명령)
scenarios/     시나리오별 setup.sh + README.md — 컨테이너 안에서 `lab start <이름>` 으로 재현
docs/kata/     kata 이슈별 정리 문서 (<short_id>-설명.md, 로컬 전용 — gitignore)
lab.sh         호스트 진입점 (build / shell / clean)
```

실습 결과물(`/work`)은 컨테이너 내부 임시 공간이라 나가면 사라진다. 시나리오가 결정적이라
`lab start`로 언제든 같은 상태를 다시 만들 수 있으므로 결과는 저장하지 않고, 남길 것은 문서에 붙인다.

## 실습 환경

```
./lab.sh build          # 이미지 빌드 (debian + git + git-filter-repo + tig) — 상세: build/build.org
./lab.sh                # 컨테이너 셸
lab list                # 시나리오 목록
lab start 01-rebase-vs-merge
cd /work/01-rebase-vs-merge && git lg
```

시나리오 스크립트는 커밋 날짜와 신원을 고정하므로 같은 시나리오는 항상 같은 해시를 만든다.
망치면 `lab reset <이름>` 으로 처음부터 (reset 뒤엔 `cd`를 다시 할 것).

## 커리큘럼

| # | 주제 | 시나리오 |
|---|------|----------|
| 0 | 실습 환경 구축 | 01(검증) |
| 1 | git 첫걸음: init/clone/config, add/commit, log/show, .gitignore | 02 |
| 2 | 세 공간: 작업트리·인덱스·HEAD, reset soft/mixed/hard | 03 |
| 3 | 브랜치와 HEAD: 브랜치=포인터, detached HEAD | 04 |
| 4 | 원격 기본: clone/fetch/pull/push, tracking branch | 05 |
| 5 | merge 내부: fast-forward, 3-way, merge-base, 충돌 | 06 |
| 6 | 객체 모델: blob/tree/commit, refs — cat-file 로 확인 | 07 |
| 7 | rebase 기초와 `--onto` | 01, 08 |
| 8 | interactive rebase: squash/fixup/reword/edit, autosquash | 09 |
| 9 | reflog 와 복구 | 10 |
| 10 | 히스토리 수술: cherry-pick, revert, bisect, filter-repo | 11 |
| 11 | 협업 규칙: force-with-lease, 공유 브랜치 rebase 금지 | 12 |
| 12 | 곁가지: worktree, rerere, stash, sparse-checkout | 13 |
| 13 | 블로그 시리즈 집필 | — |
