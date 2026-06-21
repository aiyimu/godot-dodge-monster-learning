extends Area2D

@export var speed: float = 150.0

var target: Node2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0] as Node2D


func _process(delta: float) -> void:
	if target:
		var direction: Vector2 = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
	else:
		global_position.y += speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().call_group("game", "game_over")
