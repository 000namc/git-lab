# 환경 검증: git log 그래프가 아래와 해시까지 같으면 끝

```
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

같으면 이미지·신원·시각 고정·마운트·런처가 전부 정상이다. 다르면 `build/build.org` 구성 표를 본다.
(`git lg`는 이 컨테이너에만 있는 alias로, 위 명령과 같다.)
