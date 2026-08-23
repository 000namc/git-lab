# 1. git 첫걸음

첫 단계는 빈 디렉터리에서 시작한다. 다른 시나리오와 달리 `setup.sh`가 커밋을 만들어 두지 않는다 — `.git`조차 없는 파이썬 프로젝트만 던져주고 `git init`부터 사람이 직접 친다. 레포가 어떻게 생겨나는지, 신원은 어디서 오는지, 파일이 어떤 경로로 커밋에 들어가는지를 한 번은 손으로 겪어야 2단계(세 공간)의 `status` 출력이 말이 된다. 여기서 심어 두는 "하나의 이유, 하나의 커밋"은 8단계(interactive rebase)에서 다시 꺼내 쓴다.

## 1. 무엇을 배우나

**왜 버전 관리인가.** 파일을 고치다 보면 "어제 그 버전"이 필요해지는 순간이 온다. `app_final.py`, `app_final2.py`, `app_진짜최종.py`로 버티는 방식은 두 군데서 무너진다. 어느 게 어느 건지 이름만으로는 알 수 없고 둘 이상이 같은 파일을 동시에 고치면 합칠 방법이 없다. 버전 관리 도구는 이 둘을 "언제, 누가, **왜** 이렇게 바꿨는가"라는 기록으로 해결한다. 커밋 메시지가 파일 이름 뒤에 붙이던 접미사 자리를 대신하는 셈이다.

**스냅샷인가 차이인가.** 많은 버전 관리 도구가 "이전 버전에서 무엇이 바뀌었나(차이, delta)"를 쌓아 올린다. git은 그렇지 않다. 커밋마다 그 시점 작업 디렉터리 전체의 **스냅샷**을 저장한다(안 바뀐 파일은 이전 것을 그대로 가리키므로 용량이 터지지는 않는다). 그런데 `git diff`나 `git show`를 치면 화면에는 `+`와 `-`가 붙은 차이가 나온다. 저장된 건 스냅샷이고 차이는 두 스냅샷을 비교해 **그때그때 계산해 보여주는 것**이다. 이 구분이 6단계(객체 모델)에서 커밋 객체를 직접 열어볼 때 눈으로 확인되고 7단계(rebase)에서 "커밋을 다른 데 다시 얹으면 왜 해시가 전부 바뀌나"의 답이 된다.

**레포는 `.git` 디렉터리 하나다.** `git init`이 하는 일은 현재 디렉터리에 `.git`을 만드는 것뿐이고 원본 파일은 손대지 않는다. 반대로 `.git`을 지우면 히스토리만 사라지고 작업 파일은 남는다. `clone`은 남의 `.git`을 통째로 복사해 와 그 내용을 작업 디렉터리에 펼치는 것이다 — 그래서 clone한 레포는 인터넷이 끊겨도 전체 히스토리가 그대로 있다.

**설정의 세 층.** git 설정은 세 파일에 나뉘어 있고 좁은 층이 넓은 층을 이긴다.

| 층 | 파일 | 옵션 | 쓰임 |
|---|---|---|---|
| system | `/etc/gitconfig` | `--system` | 머신 전체. 이 컨테이너는 여기에 신원을 박아 뒀다 |
| global | `~/.gitconfig` | `--global` | 사용자 기본값. 보통 여기에 이름·이메일을 넣는다 |
| local | `<레포>/.git/config` | `--local` | 이 레포만. 회사 계정과 개인 계정을 나눌 때 |

같은 키가 여러 층에 있을 때 어느 값이 어디서 왔는지는 `git config --list --show-origin`이 파일 경로까지 찍어 준다.

**add와 commit이 따로인 이유.** 파일을 고쳤다고 커밋에 들어가지 않는다. `add`로 "다음 커밋에 이걸 넣겠다"고 골라야 한다. 이 고르는 자리가 인덱스(스테이징 영역)고 2단계(세 공간)의 주제다. 지금은 고르는 단계가 따로 있다는 사실만 잡고 간다.

**커밋 메시지 규약.** 형식은 관례지만 도구들이 이 관례를 전제로 만들어져 있다. 첫 줄은 제목, 50자 안쪽, 마침표 없이. 둘째 줄은 **반드시 빈 줄** — `git log --oneline`은 첫 줄만 보여주는데 빈 줄이 없으면 본문이 제목에 딸려 붙는다. 셋째 줄부터 본문이고 무엇을 했는지보다 **왜 그렇게 했는지**를 적는다. 무엇을 했는지는 diff가 이미 말해 준다.

여기에 하나 더. **커밋 하나에는 이유 하나만 담는다.** 리팩터링과 버그 수정을 한 커밋에 섞으면 나중에 그중 하나만 되돌릴 수 없고(10단계, revert), 이진 탐색으로 범인을 찾을 때 범위가 뭉뚱그려진다(10단계, bisect). 8단계(interactive rebase)에서 커밋을 쪼개고 합치고 순서를 바꾸는 법을 배우는데, 애초에 이유 단위로 끊어 두면 그 수술이 훨씬 덜 필요하다.

**무시와 추적은 다른 얘기다.** `.gitignore`는 **아직 추적하지 않는** 파일에만 걸린다. 한 번이라도 커밋된 파일은 나중에 `.gitignore`에 적어도 계속 추적된다. 인덱스에서 빼는 `git rm --cached`가 필요한 이유다.

## 2. 실습 순서

```
lab start 01-first-steps && cd /work/01-first-steps
```

이 시나리오는 커밋을 하나도 만들어 두지 않는다. 아래 커밋은 전부 실습 중 직접 만드는 것이고 시각이 사람마다 다르므로 **해시는 다를 수 있다.**

### 1) `git init` — .git 안에 뭐가 생기나

```
$ git init
Initialized empty Git repository in /work/01-first-steps/.git/
$ ls -A .git
HEAD  branches  config  description  hooks  info  objects  refs
$ cat .git/HEAD
ref: refs/heads/main
```

`objects`가 앞으로 모든 스냅샷이 쌓일 창고고 `refs`는 브랜치·태그가 사는 곳, `config`가 이 레포의 local 층이다. `HEAD`는 `refs/heads/main`을 가리키는데 정작 그 파일은 아직 없다 — 커밋이 없으니 브랜치도 아직 존재하지 않는다.

`ref: refs/heads/main`이 무슨 뜻인지만 짚고 간다. `refs/heads/main`은 브랜치 `main`이고, 실체는 `.git/refs/heads/main`이라는 파일 하나다. 첫 커밋을 만들면 이 파일이 생기고 안에는 그 커밋의 해시 한 줄이 들어간다. `HEAD`는 "지금 어느 브랜치 위에 있나"를 적은 파일이라 해시가 아니라 브랜치 이름을 들고 있다. 그래서 커밋을 만들면 HEAD가 가리키는 브랜치(`main`)의 해시가 새 커밋으로 옮겨 간다. 나머지(브랜치를 바꾸면 HEAD가 어떻게 되나, detached HEAD)는 3단계(브랜치와 HEAD)에서 다룬다.

### 2) 신원은 어느 층에서 오나

```
$ git config --list --show-origin        # 갓 init 한 레포: system 과 local 두 층뿐
file:/etc/gitconfig	user.name=git-lab
file:/etc/gitconfig	user.email=lab@example.com
file:/etc/gitconfig	init.defaultbranch=main
...
file:.git/config	core.bare=false
$ git config --global user.email "me@example.com"     # 가운데 층을 만들어 보고
$ git config --local  user.name  "seonguk"            # 좁은 층도 채운다
$ git config --list --show-origin | grep user
file:/etc/gitconfig	user.name=git-lab
file:/etc/gitconfig	user.email=lab@example.com
file:/root/.gitconfig	user.email=me@example.com
file:.git/config	user.name=seonguk
$ git config user.name && git config user.email
seonguk
me@example.com
```

이 컨테이너는 재현 가능한 해시를 위해 신원을 system 층에 고정해 뒀다. 보통의 맥이라면 그 자리에 `file:/Users/…/.gitconfig`, 즉 global 층이 뜬다. `--list`는 세 층을 다 보여주지만 실제로 쓰이는 값은 하나다. 같은 키가 여러 줄 나오면 아래쪽(좁은 층)이 이긴다 — system < global < local. 승자만 보려면 키 이름 하나만 준다:

```
$ git config user.name     # 승자만 출력
seonguk
$ git config user.email
me@example.com
```

`user.name`은 local이, `user.email`은 global이 system을 눌렀다. `--show-origin`의 `file:` 경로가 층을 말해 준다: `/etc/gitconfig`=system, `~/.gitconfig`=global, `.git/config`=local. 확인했으면 `--global --unset user.email`과 `--local --unset user.name`으로 되돌린다. 이후 출력의 저자는 다시 `git-lab`이다.

### 3) 첫 커밋

```
$ git status --short
?? .env
?? README.md
?? build/
?? src/
$ git add src README.md
$ git status --short
A  README.md
A  src/app.py
A  src/util.py
?? .env
?? build/
$ git commit -m "init: project skeleton"
[main (root-commit) 3d79413] init: project skeleton
 3 files changed, 10 insertions(+)
$ git log --stat
commit 3d794137...   init: project skeleton
 README.md   | 3 +++
 src/app.py  | 5 +++++
 src/util.py | 2 ++
```

`add src`처럼 디렉터리를 주면 그 아래 파일이 개별로 들어간다 — git은 빈 디렉터리를 기록하지 않고 파일만 기록한다. `--short`의 왼쪽 칸이 인덱스, 오른쪽 칸이 작업 디렉터리다(`A`는 인덱스에 새로 추가됨, `??`는 추적 안 됨). 이 두 칸이 2단계의 전부다. `root-commit`은 부모가 없는 첫 커밋이라는 뜻이다.

### 4) 고치고, 보고, 메시지를 제대로 쓴다

`src/app.py`의 인사말을 바꾼다(에디터로 고쳐도 되고, 한 줄이면 `sed`로):

```
$ sed -i 's/hello, {name}/안녕, {name}/' src/app.py
$ git diff
diff --git a/src/app.py b/src/app.py
index 2dd5e33..5b3cdc5 100644
--- a/src/app.py
+++ b/src/app.py
@@ -1,5 +1,5 @@
 def greet(name):
-    return f"hello, {name}"
+    return f"안녕, {name}"
 
 if __name__ == "__main__":
     print(greet("git"))
```

`a/`가 이전, `b/`가 이후다. `@@ -1,5 +1,5 @@`는 양쪽 모두 1행부터 5행을 보여준다는 뜻이고 앞뒤 세 줄은 위치를 알려주는 문맥이다.

`git add -u` 뒤에 `git commit -v`를 치면 에디터(여기서는 vim)가 뜨는데, 메시지 아래에 이 diff가 함께 붙어 있다.

```
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# On branch main
# Changes to be committed:
#	modified:   src/app.py
#
# ------------------------ >8 ------------------------
# Do not modify or remove the line above.
# Everything below it will be ignored.
diff --git a/src/app.py b/src/app.py
...
```

`>8`(가위) 선 아래는 메시지에 들어가지 않는다. 무엇을 커밋하는지 눈으로 확인하면서 메시지를 쓰라고 붙여 주는 것이다. 제목 한 줄, 빈 줄, 본문으로 쓰면:

```
$ git log -1
commit 3384bdb...

    feat(app): 인사말을 한국어로

    영어 hello 를 한국어로 바꿨다.
    사용자 대상 문구를 우선 한국어로 통일하기로 해서 첫 대상으로 골랐다.
```

`git log --oneline`으로 보면 제목 한 줄만 남는다. 빈 줄을 빼먹으면 본문까지 제목에 딸려 붙어 이 목록이 지저분해진다.

### 5) `.gitignore`

```
$ git status --short          # 넣기 전
?? .env
?? build/
$ printf 'build/\n.env\n' > .gitignore
$ git status --short          # 넣은 뒤
?? .gitignore
$ git add .gitignore && git commit -m "chore: build/ 와 .env 를 무시"
```

둘이 사라지고 `.gitignore` 자신만 남는다. 무시 목록이지 숨는 파일이 아니므로 이건 커밋한다.

### 6) 이미 추적 중인 파일은 `.gitignore`로 안 빠진다

`git add .`을 습관처럼 쳐서 필요 없는 파일이 딸려 들어간 상황을 만든다. 그 뒤 `notes.txt`를 `.gitignore`에 넣고 파일을 고쳐 본다.

```
$ echo 'x' > notes.txt && git add . && git commit -m "oops"
$ printf 'build/\n.env\nnotes.txt\n' > .gitignore && echo 'y' >> notes.txt
$ git status --short
 M .gitignore
 M notes.txt
$ git ls-files
.gitignore
README.md
notes.txt
src/app.py
src/util.py
```

무시 목록에 적었는데도 수정이 잡히고 `ls-files`에도 그대로 있다. 추적 중인 파일에는 `.gitignore`가 적용되지 않기 때문이다. 인덱스에서 빼면 해결된다.

```
$ git rm --cached notes.txt
rm 'notes.txt'
$ git status --short
 M .gitignore
D  notes.txt
$ git add .gitignore && git commit -m "chore: notes.txt 는 추적하지 않는다"
$ git check-ignore -v --no-index notes.txt
.gitignore:3:notes.txt	notes.txt
```

`D`가 **왼쪽 칸**(인덱스)에 찍힌 게 핵심이다. 인덱스에서만 지웠고 디스크의 `notes.txt`는 그대로다. `--cached` 없이 `git rm`을 치면 파일까지 지워진다. 커밋하고 나면 추적이 끊기고 그제야 `.gitignore`가 먹는다. `check-ignore`는 어느 파일 몇 번째 줄의 어떤 패턴이 걸렸는지 알려주는데, 추적 중인 파일에는 기본적으로 답하지 않아서 `--no-index`를 붙였다.

이 사고의 원인은 `git add .`이었다. `add`에는 범위가 다른 세 형태가 있다.

| 명령 | 수정된 tracked | 삭제된 tracked | 새 untracked |
|---|---|---|---|
| `git add <경로>` | 그 경로만 | 그 경로만 | 그 경로만 |
| `git add -u` | O | O | X |
| `git add -A` (레포 루트의 `git add .`과 같음) | O | O | O |

`-u`(`--update`)는 이미 추적 중인 파일의 변경만 올린다. 고친 것만 올리고 새로 생긴 잡동사니는 빼고 싶을 때 쓰며, 여기서 `-u`였다면 `notes.txt`는 들어오지 않았다. 삭제도 스테이지하므로 셸에서 `rm`한 파일이 `status`에 계속 뜰 때 `git add -u`가 `git rm`을 대신한다.

### 7) `git mv`

```
$ git mv src/util.py src/text.py
$ git status --short
R  src/util.py -> src/text.py
$ git commit -m "refactor: util.py 를 text.py 로"
```

`R`은 rename이다. 다만 git은 rename을 따로 저장하지 않는다 — 스냅샷을 비교할 때 지워진 파일과 생긴 파일의 내용이 충분히 닮았으면 그때 rename이라고 **추정해서 보여주는** 것이다. 위의 스냅샷 얘기와 같은 원리다. `git mv`도 `mv` + `git rm` + `git add`를 한 번에 해주는 편의 명령일 뿐이다.

### 8) 지금까지를 읽는다

```
$ git log --oneline
e428739 refactor: util.py 를 text.py 로
d1c76bf chore: notes.txt 는 추적하지 않는다
9a17332 oops
7af4b39 chore: build/ 와 .env 를 무시
3384bdb feat(app): 인사말을 한국어로
3d79413 init: project skeleton

$ git show HEAD~2
commit 9a17332...   oops
diff --git a/notes.txt b/notes.txt
new file mode 100644
+x

$ git diff HEAD~3 HEAD -- src/
diff --git a/src/util.py b/src/text.py
similarity index 100%
rename from src/util.py
rename to src/text.py
```

`HEAD~2`는 "HEAD에서 부모를 두 번 따라간 커밋"이다. `show`는 커밋 하나(그 커밋과 부모의 차이)를 보여주고 `diff A B`는 **떨어진 두 지점** 사이 차이를 보여준다. `-- src/`로 경로를 좁히면 그 아래만 나온다 — `src/` 밖에서 벌어진 `.gitignore`·`notes.txt` 소동은 여기서 걸러진다. `similarity index 100%`는 내용이 한 글자도 안 바뀌었다는 rename 판정의 근거다.

## 3. 정리

- 레포는 `.git` 디렉터리 하나다. `init`은 그걸 만들 뿐이고 지우면 히스토리만 사라진다.
- git이 저장하는 건 스냅샷이고 `diff`가 보여주는 차이는 두 스냅샷을 비교해 그 자리에서 계산한 결과다. rename도 저장된 사실이 아니라 추정이다.
- 설정은 system → global → local 세 층이고 좁은 쪽이 이긴다. 헷갈리면 `git config --list --show-origin`.
- 파일이 커밋에 들어가려면 `add`로 골라야 한다. 고르는 단계가 따로 있다는 게 git의 설계고 `status --short`의 두 칸이 그 자국이다.
- 커밋 메시지는 제목 50자, 빈 줄, 본문. 커밋 하나에 이유 하나. 지금은 잔소리로 들리지만 8단계(interactive rebase)와 10단계(히스토리 수술)에서 값을 한다.

**흔한 실수**

- `git add .`을 반사적으로 친다. 의도하지 않은 파일이 커밋에 들어가고 한 번 들어가면 `.gitignore`로는 못 뺀다(`git rm --cached`).
- 커밋 메시지 제목 다음 빈 줄을 빼먹어 `git log --oneline`이 지저분해진다.
- `git rm`을 `--cached` 없이 쳐서 파일까지 날린다. 추적만 끊으려면 `--cached`가 반드시 붙는다.
- 신원을 local에만 넣어 두고 다른 레포에서 커밋한 뒤 저자가 다르다고 당황한다. 기본값은 global에 둔다.

## 4. 더 보기

- `git help config`, `git help gitignore`, `git help commit`, `git help revisions`(`HEAD~2` 같은 표기법이 전부 여기 있다)
- 다음은 2단계(세 공간)다. 여기서 "고르는 단계"라고만 부르고 넘어간 인덱스를 정면으로 다룬다. `status`의 두 구역, `add -p`, `restore`, `reset`의 soft/mixed/hard가 그 주제다.
