extends CharacterBody2D

@export var speed: float = 400.0

var screen_size: Vector2


func _ready() -> void:
	screen_size = get_viewport_rect().size


func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()

	velocity = direction * speed
	move_and_slide()

	global_position.x = clamp(global_position.x, 0.0, screen_size.x)
	global_position.y = clamp(global_position.y, 0.0, screen_size.y)
