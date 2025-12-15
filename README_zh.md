# MoP

MoP 是一个轻量级的 Python 后端框架，基于 FastAPI 和 SQLAlchemy 构建，为构建现代 Web 应用程序提供核心功能模块。

## 特性

- **配置管理**：灵活的配置系统，易于使用的设置
- **数据库支持**：同时支持同步和异步数据库会话
- **实体框架**：用于一致数据建模的基础实体类
- **错误处理**：集中式错误处理，带有业务错误代码
- **日志记录**：使用 structlog 的结构化日志
- **响应格式化**：一致的 API 响应格式
- **CRUD 操作**：带有分页支持的通用 CRUD 操作
- **工具函数**：各种工具函数，用于日期、字符串、文件等
- **雪花 ID 生成**：分布式唯一 ID 生成

## 安装

```bash
pip install mop
```

或者使用 uv：

```bash
uv add mop
```

## 要求

- Python 3.12+
- FastAPI 0.124.4+
- SQLAlchemy 2.0.45+
- Pydantic 2.12.5+
- structlog 25.5.0+
- ascii-colors 0.11.6+

## 项目结构

```
mop/
├── conf/                # 配置管理
├── db/                  # 数据库连接
├── entity/              # 基础实体类
├── error/               # 错误处理
├── logging/             # 日志配置
├── response/            # 响应格式化
├── crud/                # CRUD 操作
├── util/                # 工具函数
└── snowflake.py         # 雪花 ID 生成
```

## 快速开始

### 1. 配置

```python
from mop.conf import settings

# 访问配置设置
print(settings.APP_NAME)
print(settings.DATABASE_URL)
```

### 2. 数据库设置

```python
from mop.db import session, async_session
from sqlalchemy import select
from your_model import User

# 同步会话
with session() as db:
    users = db.execute(select(User)).scalars().all()
    print(users)

# 异步会话
async with async_session() as db:
    users = await db.execute(select(User))
    users = users.scalars().all()
    print(users)
```

### 3. 创建模型

```python
from mop.entity import Entity
from sqlalchemy import Column, String


class User(Entity):
    __tablename__ = "users"

    username = Column(String(50), unique=True, index=True)
    email = Column(String(100), unique=True, index=True)
```

### 4. 错误处理

```python
from mop.error import BusinessError, ErrCode

# 抛出业务错误
raise BusinessError(ErrCode.USER_NOT_FOUND, "用户未找到")
```

### 5. 日志记录

```python
from mop.logging import logger

# 记录日志
logger.info("用户登录", user_id=123)
logger.error("处理请求失败", error="无效输入")
```

### 6. 响应格式化

```python
from mop.response import Response, PageResponse
from fastapi import FastAPI

app = FastAPI()


@app.get("/users")
async def get_users():
    users = [{"id": 1, "name": "张三"}, {"id": 2, "name": "李四"}]
    return Response(data=users, message="成功")


@app.get("/users/page")
async def get_users_page():
    users = [{"id": 1, "name": "张三"}, {"id": 2, "name": "李四"}]
    return PageResponse(data=users, total=100, page=1, page_size=20)
```

### 7. CRUD 操作

```python
from mop.crud import CRUDBase
from your_model import User, UserCreate, UserUpdate

# 创建 CRUD 实例
user_crud = CRUDBase(User)

# 创建用户
user = user_crud.create(db, obj_in=UserCreate(username="test", email="test@example.com"))

# 根据 ID 获取用户
user = user_crud.get(db, id=1)

# 更新用户
user = user_crud.update(db, db_obj=user, obj_in=UserUpdate(email="new@example.com"))

# 删除用户
user_crud.remove(db, id=1)

# 分页获取用户
users, total = user_crud.get_multi(db, page=1, page_size=10)
```

### 8. 雪花 ID 生成

```python
from mop.snowflake import SnowflakeGenerator

# 创建生成器实例
generator = SnowflakeGenerator(datacenter_id=1, worker_id=1)

# 生成唯一 ID
unique_id = generator.generate()
print(unique_id)
```

## 工具函数

### 日期工具

```python
from mop.util.dates import format_datetime, parse_datetime

# 格式化日期时间
formatted = format_datetime(datetime.now())
print(formatted)

# 解析日期时间
parsed = parse_datetime("2023-01-01 12:00:00")
print(parsed)
```

### 字符串工具

```python
from mop.util.strings import random_string, is_email_valid

# 生成随机字符串
rand_str = random_string(10)
print(rand_str)

# 检查邮箱是否有效
is_valid = is_email_valid("test@example.com")
print(is_valid)
```

### 文件工具

```python
from mop.util.files import read_file, write_file

# 读取文件
content = read_file("test.txt")
print(content)

# 写入文件
write_file("test.txt", "你好，世界！")
```

## 更新日志

### 版本 0.1.0 (2025-12-15)

#### 新增
- MoP 框架的初始版本发布
- 配置管理模块
- 支持同步和异步数据库会话
- 数据建模的基础实体类
- 集中式错误处理系统
- 结构化日志配置
- 一致的 API 响应格式
- 带分页的通用 CRUD 操作
- 日期、字符串、文件等工具函数
- 分布式系统的雪花 ID 生成

## 贡献

欢迎贡献！请随时提交 Pull Request。

## 许可证

MIT License

## 作者

- **puras** - [puras.he@gmail.com](mailto:puras.he@gmail.com)

## GitHub

[https://github.com/puras/mop](https://github.com/puras/mop)
