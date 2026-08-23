# reflog 와 복구: detached HEAD, 잃은 커밋 되살리기

## 상황
setup 이 사고 4건을 저지른 뒤다. `git log --all` 에는 커밋 2개만 보인다.
1. `reset --hard HEAD~2` 로 `feat: 3`, `feat: 4` 가 사라짐
2. `branch -D experiment` 로 브랜치와 커밋 2개가 사라짐
3. detached HEAD 에서 커밋 하나 만들고 main 으로 돌아옴
4. 파일을 `add` 만 하고 `reset --hard`

## 과제
1. `git reflog` (= `reflog show HEAD`) 를 위에서 아래로 읽어라. 한 줄이 "HEAD 가 언제 어디를 가리켰나"다. `HEAD@{n}` 표기.
2. 사고 1 복구: reflog 에서 `feat: 4` 를 찾아 `git reset --hard <해시>` 또는 `git branch recovered-main <해시>`. `ORIG_HEAD` 도 확인(`git log -1 ORIG_HEAD`).
3. 사고 2 복구: 삭제된 브랜치는 자기 reflog 도 같이 지워진다. `git reflog` (HEAD 쪽) 에서 `feat(exp): y` 를 찾거나, `git fsck --lost-found` 의 dangling commit 에서 찾아 `git branch experiment <해시>`.
4. 사고 3 복구: 같은 방법. `git log --all` 에 안 보이는데 reflog 에는 있는 이유.
5. 사고 4: `git fsck --lost-found` 의 dangling blob 을 `git cat-file -p` 로 열어 내용을 구해 보라. 파일 이름은 왜 모르나.
6. `git reflog expire --expire=now --all && git gc --prune=now` 를 한 뒤 다시 찾아보라(정말 지워진다). 평소 기본 만료는 `gc.reflogExpire`(90일) / `gc.reflogExpireUnreachable`(30일).

## 생각해볼 것
- reflog 는 로컬 전용이다. clone 에는 없다. 그래서 "push 안 한 커밋을 잃는" 유일한 경로는?
- 9단계까지 배운 것으로 "rebase 는 안전하다"는 문장을 어디까지 방어할 수 있나.
