FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    TERM=xterm-256color

RUN apt-get update && apt-get install -y --no-install-recommends \
        git git-filter-repo tig vim less tree bash-completion ca-certificates python3 \
    && rm -rf /var/lib/apt/lists/*

# 실습용 고정 신원 — 커밋 해시가 재현되도록 날짜도 시나리오 스크립트에서 고정한다
RUN git config --system user.name  "git-lab" \
 && git config --system user.email "lab@example.com" \
 && git config --system init.defaultBranch main \
 && git config --system core.pager "less -FRX" \
 && git config --system alias.lg "log --oneline --graph --decorate --all" \
 && git config --system rerere.enabled false \
 && git config --system pull.rebase false

COPY build/bashrc /root/.bashrc
COPY build/lab /usr/local/bin/lab
RUN chmod +x /usr/local/bin/lab

WORKDIR /work
CMD ["bash"]
