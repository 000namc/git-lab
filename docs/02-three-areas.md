# 2. 세 공간: 작업트리·인덱스·HEAD

1단계(git 첫걸음)에서 `add` 하고 `commit` 했다. 그때는 두 명령이 그냥 한 세트처럼 보였을 것이다. 이 단계는 그 사이에 낀 **인덱스**를 떼어내서 본다. git이 다루는 공간은 셋이고 `status`·`diff`·`restore`·`reset` 은 전부 "어느 공간에서 어느 공간으로"를 다르게 지정한 명령일 뿐이다. 이 지도가 머리에 있으면 뒤에 나오는 것들이 훨씬 편해진다. 5단계(merge 내부)의 충돌 해결은 결국 인덱스에 무엇을 넣느냐의 문제고, 7·8단계(rebase, interactive rebase)에서 멈춰 선 자리에서 하는 일도 대부분 인덱스 조작이다.

## 1. 무엇을 배우나

**세 공간.** 작업트리(working tree)는 에디터로 여는 그 파일이다. 인덱스(index, staging area, 캐시 — 다 같은 말이다)는 `.git/index` 파일 하나로, **다음 커밋에 들어갈 스냅샷**을 미리 조립해 두는 자리다. HEAD는 지금 브랜치가 가리키는 마지막 커밋, 즉 **직전 스냅샷**이다.

```
 작업트리(working tree)      인덱스(index)          HEAD(마지막 커밋)
 app.py                     :app.py                HEAD:app.py
 VERSION 0.3 / run!         VERSION 0.2 / run      VERSION 0.1 / run
 |                          |                      |
 |------- git add --------->|----- git commit ---->|
 |<------ git restore ------|<---- git restore ----|
 |        app.py            |      --staged app.py |
 |                          |                      |
 |<----- git diff --------->|<- git diff --staged ->|
 |<-------------- git diff HEAD ------------------>|
```

`:app.py` 와 `HEAD:app.py` 는 실제로 쓸 수 있는 표기다. `git show :app.py` 는 인덱스에 든 내용을, `git show HEAD:app.py` 는 마지막 커밋에 든 내용을 그대로 뱉는다. 이 시나리오는 셋을 일부러 다 다르게 만들어 두었다.

**`status` 의 두 구역.** "Changes to be committed" 는 HEAD와 인덱스의 차이고, "Changes not staged for commit" 은 인덱스와 작업트리의 차이다. 같은 파일이 두 구역에 동시에 뜰 수 있다 — 그게 이 시나리오의 `app.py` 다. `--short` 로 보면 두 글자가 나오는데, 앞 글자가 HEAD↔인덱스, 뒤 글자가 인덱스↔작업트리다. `MM` 은 양쪽 다 다르다는 뜻이다.

**`diff` 세 개.** 인자를 안 주면 기본값이 "인덱스"라는 걸 기억하면 된다. `--staged` 와 `--cached` 는 완전히 같은 옵션이다.

| 명령 | 무엇과 무엇 | 언제 쓰나 |
|---|---|---|
| `git diff` | 인덱스 ↔ 작업트리 | 아직 add 안 한 게 뭐지 |
| `git diff --staged` | HEAD ↔ 인덱스 | 이번에 커밋될 게 뭐지 |
| `git diff HEAD` | HEAD ↔ 작업트리 | 지난 커밋 이후 전부 뭐가 바뀌었지 |

**공간을 되돌리는 명령: `restore`.** `git restore --staged <파일>` 은 HEAD의 내용을 인덱스에 덮어쓴다(=unstage). `git restore <파일>` 은 인덱스의 내용을 작업트리에 덮어쓴다. 앞쪽은 안전하고 뒤쪽은 위험하다 — **작업트리의 변경은 어디에도 기록된 적이 없어서 덮어쓰면 끝이다.**

**HEAD를 움직이는 명령: `reset`.** `restore` 가 파일 하나를 손보는 도구라면 `reset` 은 브랜치 포인터를 통째로 옮기는 도구다. 어디까지 따라 움직일지를 모드로 고른다. `--soft` 는 HEAD만, 기본값(`--mixed`)은 HEAD와 인덱스, `--hard` 는 셋 다. 자세한 건 6번 과제에서 직접 확인한다.

**`commit --amend`.** 마지막 커밋을 지우고 같은 부모 위에 새로 만든다. 메시지만 고쳐도 커밋 시각(committer date)이 바뀌므로 해시가 달라진다. 그리고 이때 **인덱스에 올라와 있던 것도 같이 삼킨다** — 메시지만 고칠 생각이었다면 사고가 난다.

## 2. 실습 순서

`lab start 02-three-areas && cd /work/02-three-areas` 로 시작한다. `app.py` 는 HEAD·인덱스·작업트리가 전부 다르고 `notes.txt` 는 아직 추적되지 않는 상태로 준비돼 있다.

### 과제 1 — `status` 의 두 구역

```
$ git status
Changes to be committed:
	modified:   app.py
Changes not staged for commit:
	modified:   app.py
Untracked files:
	notes.txt

$ git status --short
MM app.py
?? notes.txt

$ git show HEAD:app.py   # HEAD
VERSION = "0.1"
$ git show :app.py       # 인덱스
VERSION = "0.2"
$ cat app.py             # 작업트리
VERSION = "0.3"
```

한 파일이 두 구역에 동시에 떴다. 위쪽은 HEAD와 인덱스가 다르다는 말이고 아래쪽은 인덱스와 작업트리가 다르다는 말이다. `notes.txt` 는 세 공간 중 작업트리에만 있어서 `??` 다.

### 과제 2 — `diff` 세 개를 나란히

```
$ git diff                       # 인덱스 ↔ 작업트리
-VERSION = "0.2"
-def run(): print("run")
+VERSION = "0.3"
+def run(): print("run!")

$ git diff --staged              # HEAD ↔ 인덱스
-VERSION = "0.1"
+VERSION = "0.2"

$ git diff HEAD                  # HEAD ↔ 작업트리
-VERSION = "0.1"
-def run(): print("run")
+VERSION = "0.3"
+def run(): print("run!")
```

세 번째는 앞의 둘을 합친 모양이다. `0.1 → 0.2` 와 `0.2 → 0.3` 이 이어져 `0.1 → 0.3` 으로 나온다. 중간 단계인 인덱스가 보이지 않는다는 게 `diff HEAD` 의 특징이다.

### 과제 3 — `add -p` 로 인덱스를 조각내기

작업트리의 변경은 두 가지가 섞여 있다. VERSION을 0.3으로 올린 것과 `run!` 로 고친 것. `run!` 만 인덱스에 올려 보자.

```
$ git add -p app.py
@@ -1,3 +1,3 @@
-VERSION = "0.2"
-def run(): print("run")
+VERSION = "0.3"
+def run(): print("run!")
(1/1) Stage this hunk [y,n,q,a,d,e,?]? s
Sorry, cannot split this hunk
```

`s`(split)가 거부당한다. 자동 분할은 hunk 사이에 문맥 줄이 끼어 있어야 되는데 두 변경이 맞붙어 있어 쪼갤 자리가 없다. 이럴 때 쓰는 게 `e`(edit)다. 에디터가 뜨면 hunk를 직접 손본다 — 스테이지하지 않을 `-` 줄은 맨 앞 글자를 공백으로 바꿔 문맥 줄로 만들고 스테이지하지 않을 `+` 줄은 통째로 지운다. 여기서는 `-VERSION = "0.2"` 를 공백으로 바꾸고 `+VERSION = "0.3"` 줄을 지우면 된다. 저장하고 나오면 이렇게 된다.

```
$ git diff --staged     # HEAD ↔ 인덱스: run! 만 올라갔다
-VERSION = "0.1"
-def run(): print("run")
+VERSION = "0.2"
+def run(): print("run!")

$ git diff              # 인덱스 ↔ 작업트리: VERSION 0.3 만 남았다
-VERSION = "0.2"
+VERSION = "0.3"
```

(이 문서의 출력은 `printf 'e\n' | GIT_EDITOR=<hunk 편집 스크립트> git add -p app.py` 처럼 비대화식으로 뽑았다. 실제로는 `add -p` 가 한 hunk씩 물어보고 `e` 를 고르면 에디터가 뜬다.)

### 과제 4 — `restore` 는 어느 공간을 되돌리나

`lab reset 02-three-areas` 로 초기 상태로 돌린 다음(`cd` 다시 하는 걸 잊지 말 것) 하나씩 해본다.

```
$ git restore --staged app.py
$ git status --short
 M app.py            # 앞 글자가 사라졌다 = HEAD와 인덱스가 같아짐
$ git diff --staged  # 비어 있다
$ cat app.py
VERSION = "0.3"      # 작업트리는 그대로

# ---- 여기서 다시 lab reset 후 반대쪽 ----
$ git restore app.py
$ git status --short
M  app.py            # 뒷 글자가 사라졌다 = 인덱스와 작업트리가 같아짐
$ git diff           # 비어 있다
$ cat app.py
VERSION = "0.2"      # 작업트리가 인덱스 내용으로 덮였다
```

앞쪽은 인덱스의 0.2가 HEAD의 0.1로 덮여 사라진 것이고 뒤쪽은 작업트리의 0.3과 `run!` 이 통째로 날아간 것이다. 뒤쪽은 어떤 커밋에도 들어간 적이 없으니 되살릴 방법도 없다.

### 과제 5 — `commit --amend`

```
$ git log --oneline -1
8af55d5 feat: stop()
$ git commit --amend -m "feat: stop() 추가"
$ git log --oneline -1
c10a143 feat: stop() 추가        # (해시는 다를 수 있음)
```

`git cat-file -p HEAD` 로 앞뒤를 비교하면 parent는 그대로인데 tree와 committer 시각이 둘 다 바뀌었다. 커밋 해시는 tree·부모·저자·커미터·메시지를 전부 넣고 돌린 값이라 어느 하나만 달라져도 다른 해시가 나온다(6단계에서 직접 열어본다).

tree까지 바뀐 게 중요하다. amend는 "메시지 수정"이 아니라 **인덱스로 커밋을 다시 만드는 것**이라 인덱스에 올라와 있던 VERSION 0.2가 같이 들어갔다. amend 뒤 `status` 를 보면 "Changes to be committed" 구역이 사라져 있다. `-m` 없이 실행하면 에디터가 떠서 기존 메시지를 고치게 해준다 — 여기서는 결과만 보이려고 `-m` 을 붙였다.

### 과제 6 — `reset` 세 모드

매번 `lab reset 02-three-areas` 후 `cd /work/02-three-areas` 로 같은 자리에서 출발한다. 셋 다 로그는 똑같이 커밋 하나가 줄어든다. 차이는 인덱스와 작업트리다.

```
$ git reset --soft HEAD~1
$ git log --oneline
06ee7d6 feat: run()             # HEAD가 한 칸 뒤로
$ git status --short
MM app.py                       # 인덱스도 작업트리도 그대로
$ git show :app.py
VERSION = "0.2"
```

되돌린 커밋의 내용이 인덱스에 그대로 얹혀 있다. "방금 커밋을 취소하고 다시 커밋" 할 때 쓰는 모드다.

```
$ git reset HEAD~1              # = --mixed, 기본값
Unstaged changes after reset:
M	app.py
$ git status --short
 M app.py                       # 인덱스가 새 HEAD로 초기화됨
$ git show :app.py
VERSION = "0.1"                 # 내가 add 해 둔 0.2도 같이 날아갔다
$ cat app.py
VERSION = "0.3"                 # 작업트리는 무사

# ---- 다시 lab reset 후 ----
$ git reset --hard HEAD~1
HEAD is now at 06ee7d6 feat: run()
$ git status --short
?? notes.txt                    # app.py 가 아예 목록에서 사라졌다
$ cat app.py
VERSION = "0.1"                 # 0.3 과 run! 이 사라졌다
```

`--hard` 는 셋을 전부 새 HEAD에 맞춘다. 다만 추적되지 않는 `notes.txt` 는 건드리지 않는다 — `--hard` 도 untracked 파일은 손대지 않고 그건 `git clean` 의 일이다.

| 모드 | HEAD | 인덱스 | 작업트리 | 쓰는 자리 |
|---|---|---|---|---|
| `--soft` | 이동 | 그대로 | 그대로 | 커밋만 취소, 내용은 스테이지된 채로 |
| `--mixed`(기본) | 이동 | HEAD로 맞춤 | 그대로 | 커밋과 add를 함께 취소 |
| `--hard` | 이동 | HEAD로 맞춤 | HEAD로 맞춤 | 전부 버리고 그 커밋 상태로 |

같은 표를 "내 손에 뭐가 남나" 쪽에서 다시 보면 이렇다. `--soft`는 인덱스를 전혀 건드리지 않아서 풀린 커밋의 내용이 스테이지된 것처럼 보이고(인덱스가 바뀐 게 아니라 비교 기준인 HEAD가 뒤로 간 것이다), `--mixed`는 인덱스를 HEAD에 맞추므로 풀린 커밋의 변경은 물론 미리 `add`해 둔 것까지 언스테이지로 내려온다. 파일 내용이 실제로 사라지는 건 `--hard`뿐이다.

| 모드 | 풀린 커밋의 변경 | reset 전에 add해 둔 것 | 작업트리 파일 |
|---|---|---|---|
| `--soft` | 스테이지됨 | 스테이지 유지 | 그대로 |
| `--mixed`(기본) | 언스테이지 | 언스테이지로 풀림 | 그대로 |
| `--hard` | 소멸 | 소멸 | HEAD로 덮어씀 |

`HEAD~n`은 HEAD에서 부모를 n번 따라간 커밋이다. `reset --soft HEAD~3`이면 최근 커밋 셋이 풀리고 그 변경이 합쳐져 스테이지에 남으니, 바로 `commit`하면 셋이 하나가 된다(가장 단순한 squash).

날아간 커밋은 `git reflog` 에 `8af55d5 HEAD@{1}: commit: feat: stop()` 으로 남아 있어 `git reset --hard 8af55d5` 로 되돌아갈 수 있다. 자세한 건 9단계(reflog 복구)에서 다룬다.

## 3. 정리

- git이 다루는 건 작업트리·인덱스·HEAD 셋이고 `status` 의 두 구역과 `diff` 의 세 형태는 그 사이 경계를 다르게 자른 것뿐이다.
- 인덱스는 커밋을 조립하는 작업대다. 손댄 것 전부가 아니라 한 가지 이유만 골라 커밋할 수 있는 게 이 작업대 덕이다.
- `restore` 는 파일 단위로 옆 공간의 내용을 덮어쓰고 `reset` 은 브랜치 포인터를 옮기면서 모드로 어디까지 따라올지 정한다. 커밋된 것은 reflog로 거의 다 되살아나지만 작업트리에만 있던 변경은 덮어쓰는 순간 끝이다. 위험한 건 `--hard` 자체가 아니라 아직 커밋 안 한 것이다.

흔한 함정 셋:

- `lab reset` 뒤에 `cd` 를 다시 안 하는 것. 디렉터리를 지우고 새로 만들기 때문에 셸이 사라진 자리를 붙들고 있어 엉뚱한 오류가 난다.
- 메시지만 고치려던 `commit --amend` 가 인덱스까지 삼키는 것. amend 전에 `git diff --staged` 로 인덱스가 비었는지 보는 습관이 안전하다.
- `git diff` 가 비었다고 변경이 없다고 판단하는 것. 전부 add 해 뒀으면 당연히 비어 있다. 그땐 `git diff --staged` 나 `git diff HEAD` 를 봐야 한다.

## 4. 더 보기

`git help status`, `git help diff`, `git help restore`, `git help reset` — 특히 `git help reset` 아래쪽의 "Examples" 절에 모드별 상황이 표로 정리돼 있다. `git help everyday` 도 한 번 훑을 만하다. 다음은 3단계(브랜치와 HEAD)다. 여기서 "HEAD = 마지막 커밋"이라고 뭉뚱그린 것을 "HEAD = 지금 어느 브랜치 위인가를 적은 파일"로 한 겹 더 벗겨낸다. `reset` 이 실제로 무엇을 고쳐 쓰는지도 그때 보인다.
