# 发布指南

## 发布前检查
- 运行必要的冒烟或回归测试，确保核心功能正常。

## 环境准备
- 需要安装 `uv`，并配置 Python 3.12+。
- 设置环境变量 `PYPI_TOKEN`（PyPI API Token），可选 `PYPI_REPOSITORY=testpypi` 以发布到 TestPyPI。

## 发布流程
```bash
# 清理与构建
uv build

# 或使用脚本（推荐）
PYPI_TOKEN=xxx ./scripts/publish.sh          # 发布到 PyPI
PYPI_TOKEN=xxx PYPI_REPOSITORY=testpypi ./scripts/publish.sh  # 发布到 TestPyPI
```
- 脚本会先清理 `dist/`，然后构建并上传产物到指定仓库。
- 如需自定义仓库或额外参数，可在脚本中调整 `EXTRA_ARGS`。

## 发布后
- 在 PyPI/TestPyPI 页面检查版本与描述是否正确。
- 使用新版本安装验证：
```bash
uv venv .venv && source .venv/bin/activate
pip install moss-mop==<版本号>
python - <<'PY'
import mop
print(mop.__version__)
PY
```
