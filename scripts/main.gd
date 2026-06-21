extends Node2D

const ENEMY_SCENE: PackedScene = preload("res://scenes/enemy/enemy.tscn")
const SCORE_LABEL_SCENE: PackedScene = preload("res://scenes/ui/score_label.tscn")
const GAME_OVER_PANEL_SCENE: PackedScene = preload("res://scenes/ui/game_over_panel.tscn")

var score: int = 0
var screen_size: Vector2
var is_game_over: bool = false

@onready var spawn_timer: Timer = $EnemySpawner/SpawnTimer

var survival_timer: Timer
var score_label: Label


func _ready() -> void:
	screen_size = get_viewport_rect().size
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	_create_score_label()
	_create_survival_timer()


func _create_score_label() -> void:
	score_label = SCORE_LABEL_SCENE.instantiate()
	score_label.text = "Score: 0"
	$UI.add_child(score_label)


func _create_survival_timer() -> void:
	survival_timer = Timer.new()
	survival_timer.wait_time = 1.0
	survival_timer.autostart = true
	survival_timer.timeout.connect(_on_survival_timer_timeout)
	add_child(survival_timer)


func _on_spawn_timer_timeout() -> void:
	if is_game_over:
		return
	var enemy: Area2D = ENEMY_SCENE.instantiate()
	var side: int = randi() % 4
	# 随机选择屏幕边缘位置生成怪物
	match side:
		0: enemy.position = Vector2(randf_range(0, screen_size.x), -20)
		1: enemy.position = Vector2(randf_range(0, screen_size.x), screen_size.y + 20)
		2: enemy.position = Vector2(-20, randf_range(0, screen_size.y))
		3: enemy.position = Vector2(screen_size.x + 20, randf_range(0, screen_size.y))
	add_child(enemy)


func _on_survival_timer_timeout() -> void:
	score += 1
	score_label.text = "Score: %d" % score


func game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	spawn_timer.stop()
	survival_timer.stop()

	var panel: Panel = GAME_OVER_PANEL_SCENE.instantiate()
	panel.size = Vector2(300, 200)
	panel.position = (screen_size - panel.size) / 2
	panel.set_score(score)
	$UI.add_child(panel)

