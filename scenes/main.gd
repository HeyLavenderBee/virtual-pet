extends Node2D

var n = 0
@export var start_pos := Vector2(42,110)
var dict_index: int
var todo_pos : Array = [Vector2(42,150), Vector2(42,170), Vector2(42,175), Vector2(42, 190)]

var session_time: int = 5

var todo_list: Dictionary

var mouse_in := false
var mouse_click := false
var pos_diff: Vector2
var x_button_diff
var y_button_diff
@onready var food_inst = preload("res://scenes/food.tscn")

func _ready() -> void:
	get_window().always_on_top = true
	$Book.hide()

func _physics_process(delta: float) -> void:
	#move_window()
	$timer_label.text = str(snapped($session_timer.time_left,1))
	pos_diff = Vector2(float(get_window().position.x),float(get_window().position.y))-Vector2(float(get_global_mouse_position().x), float(get_global_mouse_position().y))
	#print(get_global_mouse_position(), get_local_mouse_position(), get_window().position, pos_diff, $move_area.position, $move_area.position - Vector2(float(get_global_mouse_position().x), float(get_global_mouse_position().y)))
	

func _on_button_pressed() -> void:
	get_tree().quit()

func _on_food_button_pressed() -> void:
	var food = food_inst.instantiate()
	food.position = $food_button.position
	n += 1
	SaveLoad.save_content.n = n
	#print("save content: ",n)
	for i in SaveLoad.todo_list:
		dict_index = i + 1
		start_pos += Vector2(0,30)
		print(start_pos)
	SaveLoad.todo_list[dict_index] = "hi"
	print(SaveLoad.save_content)
	SaveLoad.save()
	add_child(food)

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse_in:
		mouse_click = true
		#get_window().set_position(Vector2(1000,200))
		x_button_diff = $move_area.position.x - float(get_global_mouse_position().x)
		y_button_diff = $move_area.position.y - float(get_global_mouse_position().y)
		get_window().position.x -= int(x_button_diff)
		get_window().position.y -= int(y_button_diff)
		Global.is_window_moving = true
	if event.is_action_released("left"):
		Global.is_window_moving = false
		#var old_mouse_position
		#old_mouse_position = get_local_mouse_position()
		#get_tree().create_timer(.04)
		#var drag_position = get_local_mouse_position() - old_mouse_position
		#get_window().set_position(get_global_mouse_position())
		#print(get_local_mouse_position())
		

func move_window():
	if mouse_click:
		get_window().set_position(get_local_mouse_position())
		print(get_local_mouse_position())

func _on_move_area_mouse_entered() -> void:
	mouse_in = true

func _on_move_area_mouse_exited() -> void:
	mouse_in = false

func _on_load_button_pressed() -> void:
	load_todo()

func load_todo():
	SaveLoad.load_save()
	todo_list = SaveLoad.save_content.todo_list
	print(SaveLoad.save_content)
	for i in todo_list:
		var todo_rect = ColorRect.new()
		var todo_label = Label.new()
		todo_label.position = start_pos
		todo_rect.position = start_pos - Vector2(20,-5)
		todo_rect.size = Vector2(15,15)
		todo_label.text = todo_list[i]
		add_child(todo_label)
		add_child(todo_rect)
		start_pos += Vector2(0,30)
		#print(todo_label.position)

func _on_todo_button_pressed() -> void:
	add_todo()

func add_todo():
	var next_dict_index
	for i in SaveLoad.save_content.todo_list:
		dict_index = i + 1
		start_pos += Vector2(0,30)
		print(i)
	SaveLoad.save_content.todo_list[dict_index] = $todo_text.text
	#print(SaveLoad.todo_list)
	
	var todo_rect = ColorRect.new()
	var todo_label = Label.new()
	#todo_label.position = todo_pos[dict_index] 
	#todo_rect.position = todo_pos[dict_index] - Vector2(20,-5)
	todo_label.position = start_pos
	todo_rect.position = start_pos - Vector2(20,-5)
	todo_rect.size = Vector2(15,15)
	todo_label.text = $todo_text.text
	add_child(todo_label)
	add_child(todo_rect)
	#print(todo_label.position)
	
	SaveLoad.save()

func _on_todo_text_text_changed() -> void:
	if Input.is_action_just_pressed("enter"):
		_on_todo_button_pressed()
		$todo_text.clear()


func _on_delete_button_pressed() -> void:
	SaveLoad.delete_save()

func _on_start_timer_button_pressed() -> void:
	var current_time_dict = Time.get_datetime_dict_from_system()
	var current_date_time = Time.get_date_dict_from_system()
	var date = str(current_date_time.day,"-",current_date_time.month,"-",current_date_time.year)
	print("Current date: ", date)
	print("Current Time: %02d:%02d:%02d" % [current_time_dict.hour, current_time_dict.minute, current_time_dict.second])
	
	var index
	for i in SaveLoad.save_content.sessions:
		index = i + 1
		print(index)
	if index == null:
		index = 0
	print("cur index: ",index)
	SaveLoad.save_content.sessions[index] = str("Session ",index,"\n- Current date and time: ",date, " --- ",current_time_dict.hour,"h", current_time_dict.minute,"m", current_time_dict.second,"s","\nSession total time: ",session_time," seconds")
	print(SaveLoad.save_content.sessions)
	SaveLoad.save()
	$session_timer.wait_time = session_time
	$session_timer.start()
	$Book.show()

func _on_timer_text_text_changed() -> void:
	session_time = int($timer_text.text)

func _on_session_timer_timeout() -> void:
	$Book.hide()
