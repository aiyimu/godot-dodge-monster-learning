extends Panel

var score: int = 0


func set_score(value: int) -> void:
	score = value
	$Label.text = "Game Over!\nScore: %d" % score


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
