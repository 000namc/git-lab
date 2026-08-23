# 환경 검증: rebase 와 merge 가 만드는 히스토리 비교 (7단계 rebase 에서 다시 씀)

## 상황
`main` 에 커밋이 두 개 더 쌓인 사이, `feature` 브랜치에서 커밋 세 개를 만들었다.
두 브랜치가 갈라져(diverged) 있다.

```
      A---B---C  main
     /
D---E---F---G---H  feature
```
(실제 모양은 `git lg` 로 확인)

## 과제
1. `git lg` 로 현재 그래프를 보고 merge-base 를 찾아라 (`git merge-base main feature`).
2. `feature` 를 `main` 위로 `rebase` 하라. 그래프가 어떻게 바뀌는지, 커밋 해시가 왜 전부 바뀌는지 설명하라.
3. `lab reset 00-smoke` 로 초기화한 뒤 이번엔 `main` 에서 `feature` 를 `merge` 하라. 두 결과를 비교하라.
4. `git reflog` 에서 rebase 전의 `feature` 끝 커밋을 찾아 `feature-before` 브랜치로 되살려라.

## 생각해볼 것
- rebase 후 "같은 변경"인데 해시가 다른 커밋이 왜 둘 다 존재하는가? 옛 커밋은 언제 사라지는가?
- 이미 push 한 브랜치를 rebase 하면 무슨 일이 생기는가?
