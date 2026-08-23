#!/usr/bin/env bash
# 호스트 진입점.
#   ./lab.sh build   이미지 빌드
#   ./lab.sh         컨테이너 셸 진입 (나가면 실습 결과는 사라진다 — lab start 로 언제든 재현)
#   ./lab.sh clean   컨테이너·이미지 제거
set -euo pipefail
cd "$(dirname "$0")"
COMPOSE="docker compose -f build/docker-compose.yaml"
case "${1:-shell}" in
  build) $COMPOSE build ;;
  shell) $COMPOSE run --rm lab ;;
  clean) $COMPOSE down --remove-orphans --rmi local ;;
  *) echo "usage: $0 [build|shell|clean]" >&2; exit 1 ;;
esac
