extends Node2D

func _physics_process(delta: float) -> void:
	if Global.is_window_moving:
		$"Emu-otori".hide()
		$"Emu-otori-holding".show()
	else:
		$"Emu-otori".show()
		$"Emu-otori-holding".hide()

func _on_food_area_area_entered(area: Area2D) -> void:
	if area.name == "food_area":
		print("food!")
