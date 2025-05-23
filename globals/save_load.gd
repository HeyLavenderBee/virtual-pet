extends Node

#https://www.youtube.com/watch?v=xG2GGniUa5o
var save_path = "user://save_godot.json"
var save_content: Dictionary = {
	"n": 0,
	"new_data": false,
}

var todo_list: Dictionary = {
	0: "heyy",
	1: "gay",
}

func _ready() -> void:
	load_save()

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(save_content.duplicate())
	for i in todo_list:
		file.store_line(str(todo_list.keys()[i],":",todo_list.values()[i],"\r").replace(" ", ""))
	file.close()

func load_save():
	if FileAccess.file_exists(save_path):
		print("save exists")
		var file = FileAccess.open(save_path, FileAccess.READ)
		#var data = file.get_var()
		var content = {}
		print(file.get_as_text().count(":"))
		for i in file.get_as_text().count(":"):
			
			var line = file.get_line()
			var key = line.split(":")[0]
			var value = line.split(":")[1]
			if value.is_valid_integer():
				value = int(value)
			elif value.is_valid_float():
				value = float(value)
			#elif value.begins_with("["):
				#value = value.trim_prefix("[")
				#value = value.trim_suffix("]")
				#value = value.split(",")
			content[key] = value
		
		file.close()
		return content
		print(content)
		#print(data)
		#var save_data = data.duplicate()
		#save_content.n = save_data.n
		#todo_list[0] = save_data.todo_list[0]
		
