extends Node2D

var mouse_in := false

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse_in:
		position = get_global_mouse_position()

func _on_food_area_mouse_entered() -> void:
	mouse_in = true


func _on_food_area_mouse_exited() -> void:
	mouse_in = false
