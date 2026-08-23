#!/usr/bin/env python3
"""docs/kata/<id>-*.md (작업 초안) → docs/<NN-name>.md (공개본).

- 제목·본문의 kata 이슈 키(예: "(s4w5)", "(6x52, `06-object-model`)")를 뗀다
- `## Review Log` 이후(검토 기록)를 버린다
  python3 tools/publish-doc.py docs/kata/s4w5-git첫걸음.md docs/01-first-steps.md
"""
import re, sys

IDS = r"(?:w59k|5xpt|s4w5|1yq6|1r2h|mb68|h75h|6x52|3ae7|zver|5xav|vz27|3ypn|2mj5|fy7j)"

def publish(text: str) -> str:
    text = text.split("\n## Review Log")[0].rstrip() + "\n"
    text = re.sub(r"\s*\(" + IDS + r"\)", "", text)                       # "(s4w5)"
    text = re.sub(r"\(" + IDS + r",\s*", "(", text)                        # "(6x52, `06-...`)" → "(`06-...`)"
    text = re.sub(r"\(" + IDS + r"(?:,\s*" + IDS + r")*(?:,\s*\.\.\.)?\)", "", text)  # "(6x52, h75h, ...)"
    text = re.sub(r"해당 이슈 문서\s*", "각 단계 문서", text)
    text = text.replace("`study/git-lab`의 실습 환경", "이 레포의 실습 환경")
    text = text.replace("커리큘럼은 w59k 계획 문서에 있다.", "커리큘럼은 README에 있다.")
    text = re.sub(r"\n- 원격: https://github\.com/\S+ \(push 완료\)\.", "", text)
    return text

if __name__ == "__main__":
    src, dst = sys.argv[1], sys.argv[2]
    out = publish(open(src, encoding="utf-8").read())
    open(dst, "w", encoding="utf-8").write(out)
    left = re.findall(IDS, out)
    print(f"{dst}: {out.count(chr(10))} lines; leftover ids: {left or 'none'}")
