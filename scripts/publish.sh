#!/usr/bin/env bash
set -euo pipefail

# 发布 moss-mop 到 PyPI 或 TestPyPI。
# 依赖：uv、twine（通过 uvx 获取），并已配置 PYPI_TOKEN。

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

REPO="${PYPI_REPOSITORY:-pypi}" # pypi 或 testpypi
TOKEN="${PYPI_TOKEN:-}"
if [[ -z "$TOKEN" ]]; then
  echo "缺少环境变量 PYPI_TOKEN" >&2
  exit 1
fi

rm -rf dist
uv build

if [[ "$REPO" == "testpypi" ]]; then
  EXTRA_ARGS="--repository-url https://test.pypi.org/legacy/"
else
  EXTRA_ARGS=""
fi

uvx --from twine twine upload ${EXTRA_ARGS} dist/* -u __token__ -p "$TOKEN"
