# 환경 검증: 같은 그래프·같은 해시가 나오는지 확인

## 상황
`main`과 `feature`가 `b525ae4`에서 갈라진 작은 레포. 커밋 7개. 아무것도 바꾸지 않고 보기만 한다.

## 확인할 것
1. `git lg` — 아래와 **해시까지 똑같이** 나와야 한다. 다르면 신원/시각 고정이 깨진 것(`build/build.org` 구성 표 참고).
   ```
   * 0919841 (main) chore: config
   * 490030f docs: usage section
   | * f2038f1 (HEAD -> feature) feat(feature): helper
   | * 89a69f6 feat(feature): step 2
   | * 71f7516 feat(feature): step 1
   |/
   * b525ae4 feat: app skeleton
   * f38aaa1 init: README
   ```
2. `git merge-base main feature` → `b525ae4…`
3. `git status` 가 clean, `git branch` 에 `main`·`feature` 둘.
4. `lab reset 00-smoke` 후 `cd` 를 다시 하고 1을 반복 — 같은 결과.

여기까지 맞으면 환경은 끝. 이 그래프를 읽는 법은 3단계, 두 줄기를 합치는 방법은 5단계·7단계에서 배운다.
