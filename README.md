# 躲避怪物 (Dodge Monster)

Godot 2D 入门项目：玩家控制角色在场景中移动，躲避随机生成的怪物，尽可能存活更长时间以获得更高分数。

---

## 1. 项目概述

### 1.1 游戏玩法

- 玩家使用键盘方向键（或 WASD）控制角色在 2D 平面内移动
- 怪物从屏幕边缘随机位置生成，并向玩家方向移动
- 玩家需要躲避怪物，被怪物碰到则游戏结束
- 存活时间越长，分数越高
- 游戏结束后可重新开始

### 1.2 核心学习点

| 学习点 | 说明 |
|--------|------|
| **KinematicBody2D 角色移动** | 使用 `move_and_slide()` 实现平滑的物理移动，处理碰撞检测 |
| **敌人随机生成** | 使用 `Timer` 节点控制生成间隔，随机位置实例化怪物场景 |
| **存活时间计分** | 通过 `Timer` 累计存活时间，实时更新 UI 分数显示 |
| **游戏重启机制** | 使用 `get_tree().reload_current_scene()` 实现快速重启 |

### 1.3 技术栈

- **引擎**: Godot 4.6
- **语言**: GDScript
- **渲染**: Forward Plus (2D)
- **物理**: GodotPhysics2D (默认)

---

## 2. 项目结构

```
godot-dodge-monster-learning/
├── project.godot                  # 项目配置文件
├── README.md                      # 项目文档（本文件）
├── tasks.md                       # 任务拆分文档
├── project_rule.md                # 项目编码规范
├── scenes/                        # 场景文件
│   ├── main.tscn                  # 主场景
│   ├── player/                    # 玩家相关场景
│   │   └── player.tscn
│   ├── enemy/                     # 敌人相关场景
│   │   └── enemy.tscn
│   └── ui/                        # UI 场景
│       ├── score_label.tscn
│       └── game_over_panel.tscn
├── scripts/                       # 脚本文件
│   ├── main.gd                    # 主场景控制器
│   ├── player/                    # 玩家脚本
│   │   └── player.gd
│   ├── enemy/                     # 敌人脚本
│   │   └── enemy.gd
│   └── ui/                        # UI 脚本
│       └── game_over_panel.gd
├── assets/                        # 资源文件
│   └── textures/                  # 贴图资源
└── addons/                        # 插件（godot_mcp）
```

---

## 3. 核心架构

### 3.1 场景树结构

```
Main (Node2D)
├── Player (KinematicBody2D)
│   ├── CollisionShape2D
│   └── Sprite2D
├── EnemySpawner (Node2D)
│   └── SpawnTimer (Timer)
├── UI (CanvasLayer)
│   ├── ScoreLabel (Label)
│   └── GameOverPanel (Panel)
│       ├── GameOverLabel (Label)
│       └── RestartButton (Button)
```

### 3.2 数据流

```
[Player] --move--> [KinematicBody2D] --collision--> [Enemy] --> [Game Over]
[SurvivalTimer] --time--> [ScoreLabel] --display--> [UI]
[EnemySpawner] --spawn--> [Enemy] --seek--> [Player Position]
[RestartButton] --click--> [get_tree().reload_current_scene()]
```

### 3.3 信号连接

| 信号 | 发送者 | 接收者 | 用途 |
|------|--------|--------|------|
| `body_entered` | Enemy (Area2D) | Enemy 自身 | 检测与玩家碰撞 |
| `timeout` | SpawnTimer | EnemySpawner | 定时生成怪物 |
| `timeout` | SurvivalTimer | Main | 更新存活分数 |
| `pressed` | RestartButton | GameOverPanel | 重新开始游戏 |

---

## 4. 未来扩展方向

### 4.1 玩法扩展

- **难度递增**: 随时间推移，怪物生成速度越来越快，移动速度越来越快
- **多种怪物类型**: 引入不同行为的怪物（追踪型、直线型、随机型等）
- **道具系统**: 随机生成加速、无敌、清屏等道具
- **波次系统**: 以波次为单位组织怪物生成，提供喘息时间

### 4.2 系统扩展

- **音效与音乐**: 添加背景音乐、碰撞音效、UI 交互音效
- **粒子特效**: 怪物死亡/碰撞时的粒子效果
- **屏幕震动**: 碰撞时的屏幕震动反馈
- **排行榜**: 使用本地存储记录最高分
- **主菜单**: 独立的开始界面，包含开始游戏、最高分显示、设置等

### 4.3 高级功能

- **多平台适配**: 添加移动端虚拟摇杆，支持触屏操作
- **多人联机**: 使用 Godot 的高层网络 API 实现双人对战或合作模式
- **自定义皮肤**: 允许玩家选择角色外观
- **成就系统**: 定义一系列成就目标（如存活 30 秒、50 秒等）

---

## 5. 开发环境

- Godot 4.6
- GDScript
- 建议使用 VS Code 配合 godot-tools 插件进行外部编辑