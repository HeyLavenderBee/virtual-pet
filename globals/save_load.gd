extends Node


#https://www.youtube.com/watch?v=xG2GGniUa5o
var save_path = "user://save_godot.json"
var save_content: Dictionary = {
	"todo_list": {
	},
	"sessions": {
		
	}
}

func _ready() -> void:
	load_save()

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(save_content)
	#for i in todo_list:
		#file.store_line(str(todo_list.keys()[i],":",todo_list.values()[i],"\r").replace(" ", ""))
	file.close()

func load_save():
	if FileAccess.file_exists(save_path):
		#print("save exists")
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var()
		file.close()
		var save_data = data.duplicate()
		#print("save: ",save_data)
		#save_content.n = save_data.n
		save_content.todo_list = save_data.todo_list
		if save_data.sessions:
			save_content.sessions = save_data.sessions
		for i in save_data:
			pass
			#print("aaaa")
			#print(save_data)
		#todo_list[0] = save_data.n
		#print(todo_list)
		#todo_list[0] = save_data.todo_list[0]

func delete_save():
	if FileAccess.file_exists(save_path):
		save_content.todo_list = {}
		save_content.sessions = {}
		print(save_content.todo_list)
		save()
