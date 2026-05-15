# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

BabyStudy 是一款面向3-6岁幼儿园儿童的Flutter教育应用，通过趣味游戏帮助小朋友学习成长。应用使用 Riverpod 进行状态管理，包含形状/颜色/大小识别、数数、加法、词汇、拼音、绘画等游戏。

## 常用命令

```bash
# 安装依赖
flutter pub get

# 运行应用
flutter run

# 运行测试
flutter test

# 运行指定测试文件
flutter test test/widget_test.dart

# 代码分析
flutter analyze
```

## 架构说明

### 目录结构

```
lib/
├── main.dart                 # 应用入口，包含 ProviderScope
├── core/
│   ├── router/               # 路由配置 (AppRouter.generateRoute)
│   ├── theme/                # 主题配置 (AppTheme.lightTheme)
│   └── constants/            # 常量定义（年龄段等）
├── models/                   # 数据模型 (GameRecord, UserProgress, GameItem)
├── providers/                # Riverpod 状态管理 (game_provider, progress_provider)
├── services/                 # 存储服务：StorageService(SharedPreferences)、DatabaseService(SQLite)、AudioService
├── screens/                  # 页面：SplashScreen、HomeScreen、GameListScreen、GameScreen
└── games/                    # 各年龄段游戏实现
```

### 导航系统

通过 `AppRouter.generateRoute` 管理路由：
- `/` - SplashScreen（启动页）
- `/home` - HomeScreen（年龄段选择）
- `/game-list` - GameListScreen（需要传入 ageGroup 参数）
- `/game` - GameScreen（需要传入 gameType 和 ageGroup 参数）

### 状态管理

- `game_provider.dart` - 当前游戏会话状态（分数、回合、星星）
- `progress_provider.dart` - 用户进度（总星星、解锁关卡）
- 所有 Provider 通过 main.dart 中的 `ProviderScope` 包装应用

### 游戏组织

游戏按年龄段划分，每个游戏为独立的 StatefulWidget：
- **小班**: animal_recognition、color_recognition、connect_dots、matching、shape_recognition、size_recognition
- **中班**: addition、counting、vocabulary
- **大班**: drawing、pinyin（包含 pinyin_game.dart 和 pinyin_challenge_game.dart）

### 数据持久化

- `StorageService` - SharedPreferences 存储设置和总星星数
- `DatabaseService` - SQLite 存储游戏记录（game_records 表）
- `AudioService` - 单例模式，管理背景音乐和音效（使用 audioplayers）

### 主题配置

儿童友好配色方案（定义在 `AppTheme`）：
- 主色：`#5B9BD5`（蓝色）
- 辅助色：`#FFFF9F43`（橙色）
- 强调色：`#2ECC71`（绿色）
- 背景色：`#FFFFF5F5`（浅粉色）
- 中文字体使用 SimSun

### 测试

`test/widget_test.dart` 中包含组件测试，测试各个游戏组件和页面渲染。

## 变更日志
新增变动提交，需同步更新CHANGELOG.md文档