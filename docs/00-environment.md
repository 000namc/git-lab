# 실습 환경 안내

이 문서는 이 레포의 실습 환경을 처음 여는 사람을 위한 안내다. 무엇이 준비돼 있고, 어떻게 들어가서 손을 움직이면 되고, 그 안에서 어떤 개념을 만나게 되는지를 적는다. 각 주제의 깊은 설명은 각 단계 문서에 따로 쓴다.

## 1. 어떤 환경인가

한 줄로: **Debian 컨테이너 안에 git만 깔아 두고 시나리오 스크립트가 매번 같은 모양의 레포를 만들어 준다.**

| 구성 | 내용 | 왜 이렇게 했나 |
|---|---|---|
| 이미지 | Debian bookworm + git 2.39.5 + git-filter-repo + tig + vim | 맥의 git 설정(alias, 훅, 크리덴셜)이 섞이지 않는 깨끗한 바닥 |
| 신원 | `git-lab <lab@example.com>` (이미지에 고정) | 커밋 해시에 저자가 들어가므로 고정해야 재현됨 |
| 시각 | `scenarios/_lib.sh`의 `tick`이 1700000000초부터 60초씩 올림 | 해시의 마지막 변수가 시각이다. 이것까지 고정하면 **같은 시나리오는 누가 언제 돌려도 같은 해시** |
| `/scenarios` | 레포 `scenarios/`를 읽기 전용 마운트 | 시나리오는 맥에서 편집, 컨테이너는 실행만 |
| `/work` | 컨테이너 내부 임시 공간 | 시나리오가 결정적이라 결과를 남길 이유가 없다. 나가면 사라지고 `lab start`로 재현 |
| alias | `git lg` = `log --oneline --graph --decorate --all` | 컨테이너 전용 편의 alias. 문서와 시나리오에는 항상 풀어 쓴 명령을 적는다 |

해시를 고정한 덕에 문서에 `b525ae4`라고 적어 두면 독자가 자기 컨테이너에서도 같은 해시를 보게 된다. 블로그 글에 그대로 붙일 수 있다.

## 2. 실습하는 법

```
./lab.sh build        # 최초 1회 (이미지 빌드, 1~2분)
./lab.sh              # 컨테이너 셸로 들어감
```

컨테이너 안:

```
lab list                       # 시나리오 목록
lab show  00-smoke   # 과제 읽기
lab start 00-smoke   # /work/00-smoke 에 레포 생성
cd /work/00-smoke
git log --oneline --graph --all   # 그래프부터 확인
```

망쳤으면 `lab reset 00-smoke`. 디렉터리를 지우고 다시 만드니까 **`cd`를 다시 해야 한다** — 같은 셸에 그대로 있으면 `fatal: unable to get current working directory`나 `stash failed` 같은 엉뚱한 오류가 난다. 나가려면 `exit`. 컨테이너는 `--rm`이라 나가면 `/work`까지 통째로 사라진다. 남길 게 있으면 문서에 붙인다.

시나리오 번호는 커리큘럼 단계 번호와 같다(`01-first-steps`가 1단계). `00-smoke`만 환경 검증용 예외다. 아직 `setup.sh`가 없는 시나리오는 `lab list`에 `(준비 중)`으로 뜨고 `lab start`가 거부한다 — 그 단계를 시작할 때 채운다.

시나리오를 새로 만들 때는 `scenarios/NN-이름/`에 두 파일을 둔다.

- `setup.sh`: `source /scenarios/_lib.sh` 뒤에 `fresh`, `c <파일> <내용> <메시지>`로 커밋을 쌓는다. `c`가 파일에 한 줄 붙이고 add·commit까지 한다.
- `README.md`: 첫 줄 `# 제목`이 `lab list`에 뜬다. 상황, 과제, 생각해볼 것.

## 3. 무엇을 공부하게 되나

커리큘럼은 README에 있다. 여기서는 각 단계에서 만나는 개념을 한 문단씩 미리 짚는다. 실습을 시작하기 전에 "이게 뭘 보려는 건지"를 알고 들어가면 훨씬 낫다.

**git 첫걸음 (`01-first-steps`)** — 레포는 `.git` 디렉터리 하나다. `init`과 `clone`, 신원 설정의 세 층(`--system/--global/--local`), `add`·`commit`과 메시지 규약, `log --stat`·`show`·`diff`로 커밋을 읽는 법, untracked→tracked와 `rm`/`mv`, `.gitignore`와 이미 추적 중인 파일을 빼는 `rm --cached`. 서두에 "왜 버전 관리인가, 스냅샷 vs 차이"를 짧게 둔다. "하나의 이유, 하나의 커밋"은 뒤의 interactive rebase의 복선이다.

**세 공간 (`02-three-areas`)** — 작업트리(파일), 인덱스(다음 커밋에 들어갈 것), HEAD(마지막 커밋). `status`가 보여주는 두 구역이 이 셋의 차이다. `add -p`로 인덱스를 조각내고, `restore`로 되돌리고, `reset`의 soft/mixed/hard가 각각 어느 공간까지 움직이는지 표로 정리한다. 이 감각이 없으면 뒤의 rebase 충돌 처리에서 헤맨다.

**브랜치와 HEAD (`03-branches-and-head`)** — 브랜치는 커밋 해시 하나를 적은 파일이고 HEAD는 "지금 어느 브랜치 위인가"다. `switch`가 실제로 바꾸는 것, detached HEAD가 왜 생기고 왜 위험하지 않은지, `log --graph`에서 포인터를 읽는 법. 지운 브랜치를 되살리는 것도 여기서 한 번 해본다.

**원격 기본 (`04-remotes`)** — bare 레포 하나와 clone 둘로 `fetch`와 `pull`의 차이, `origin/main`이 로컬에 있는 "원격의 복사 포인터"라는 것, tracking branch, fast-forward가 안 돼 거부되는 push를 본다. 협업 규칙의 바닥이다.

**merge 내부 (`05-merge-internals`)** — 두 브랜치가 갈라진 지점(merge-base)을 찾고 base·ours·theirs 세 버전을 비교해 합친다(3-way). 한쪽이 다른 쪽의 조상이면 합칠 게 없어서 포인터만 옮긴다(fast-forward). 충돌은 같은 줄을 양쪽이 다르게 고쳤을 때 git이 판단을 미루는 것이다.

**객체 모델 (`06-object-model`)** — git은 파일 내용(blob), 디렉터리(tree), 스냅샷+부모 포인터(commit) 세 종류 객체를 해시로 저장한다. 브랜치는 commit 해시를 적은 파일 하나(`refs/heads/main`)이고 HEAD는 "지금 어느 ref를 보고 있나"다. `git cat-file -p`로 이걸 직접 열어보면 뒤의 모든 명령이 "포인터를 옮기는 일"로 보이기 시작한다.

**rebase (`07-rebase` + `00-smoke`)** — "내 커밋들을 떼어 다른 지점 위에 다시 얹는다". 실제로는 커밋마다 diff를 뽑아 새 부모 위에 다시 커밋하는(cherry-pick) 반복이다. 부모가 바뀌니 **해시가 전부 바뀐다**. `--onto`는 얹을 지점과 떼어낼 범위를 따로 지정한다.

**interactive rebase (`08-interactive-rebase`)** — rebase가 커밋을 하나씩 다시 적용하는 과정이라면, 그 목록(todo)을 편집할 수 있다. 합치기(squash/fixup), 메시지 고치기(reword), 순서 바꾸기, 중간에 멈춰 쪼개기(edit). `fixup!` 커밋과 `--autosquash`를 쓰면 정리가 반자동이 된다.

**reflog (`09-reflog-recovery`)** — rebase·reset으로 "사라진" 커밋은 사실 객체 저장소에 남아 있다. 브랜치가 가리키던 해시의 이력(`git reflog`)에서 찾아 브랜치를 다시 붙이면 돌아온다. 이게 있어서 rebase를 겁내지 않아도 된다.

**히스토리 수술 (`10-history-surgery`)** — 커밋 하나만 가져오기(cherry-pick), 되돌리는 커밋 만들기(revert, merge 커밋은 `-m`), 이진 탐색으로 버그 커밋 찾기(bisect), 히스토리 전체에서 파일 지우기(filter-repo).

**협업 규칙 (`11-collaboration`)** — 이미 push한 브랜치를 rebase하면 원격과 히스토리가 갈라진다. 이때 `--force-with-lease`가 `--force`보다 안전한 이유, 공유 브랜치는 rebase하지 않는 이유를 bare 레포 + clone 두 개로 직접 재현한다.

**곁가지 (`12-odds-and-ends`)** — worktree(한 레포 여러 작업 디렉터리), rerere(충돌 해결 기억), stash, sparse-checkout.

## 4. 첫 실습: `00-smoke`로 환경 확인

```
$ lab start 00-smoke && cd /work/00-smoke
$ git log --oneline --graph --all
* 0919841 (main) chore: config
* 490030f docs: usage section
| * f2038f1 (HEAD -> feature) feat(feature): helper
| * 89a69f6 feat(feature): step 2
| * 71f7516 feat(feature): step 1
|/
* b525ae4 feat: app skeleton
* f38aaa1 init: README
```

해시까지 똑같이 나오면 끝이다. 이미지·신원·시각 고정·마운트·런처가 전부 정상이라는 뜻이다. 다르면 `build/build.org`의 구성 표와 비교한다. 그래프를 읽는 법은 3단계, 두 줄기를 합치는 방법은 5단계와 7단계에서 다룬다.

## 5. 알려진 제약

- git 2.39(bookworm). 커리큘럼에 필요한 기능은 다 된다. 더 새 기능이 필요해지면 이미지를 올린다.
- 실습 결과는 저장하지 않는다. 남길 것은 문서에 붙인다.
