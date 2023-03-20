extends Node3D

const SAVE_PATH = "user://save_config_file.ini"

@onready var username = $Title/CanvasLayer/Control/VBoxContainer/Username
@onready var address = $Title/CanvasLayer/Control/VBoxContainer/ServerMenu/Address
@onready var port = $Title/CanvasLayer/Control/VBoxContainer/ServerMenu/Port
@onready var thememenu = $Title/CanvasLayer/Control/VBoxContainer/Theme

func save():
	var config = ConfigFile.new()
	config.set_value("User", "themeindex", thememenu.selected)
	config.set_value("User", "name", username.text)
	config.set_value("User", "port", port.value)
	config.set_value("User", "address", address.text)
	config.save(SAVE_PATH)
func change_scene(path):
	var world = $World
	var scene = load(path).instantiate()
	world.add_child(scene)

func _on_Host_pressed():
	save()
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port.value)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	$Title.queue_free()
	change_scene("res://Scenes/World.tscn")
#	get_tree().change_scene_to_file("res://Scenes/World.tscn")

func _on_Join_pressed():
	save()
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(address.text, port.value)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	$Title.queue_free()
#	change_scene("res://Scenes/World.tscn")
#	get_tree().change_scene_to_file("res://Scenes/World.tscn")
	

func _on_Quit_pressed():
	save()
	get_tree().quit()

func _ready():
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	port.value = config.get_value("User", "port", 11987)
	address.text = config.get_value("User", "address", "")
	thememenu.add_item("Swift")
	thememenu.add_item("Clean")
	thememenu.selected = config.get_value("User", "themeindex", 0)
	$Title/CanvasLayer/Control.theme = load("res://Assets/Resources/"+thememenu.get_item_text(thememenu.selected)+".tres")
	username.text = config.get_value("User", "name", "")

func _on_Theme_item_selected(index):
	$Title/CanvasLayer/Control.theme = load("res://Assets/Resources/"+thememenu.get_item_text(index)+".tres")
	var config = ConfigFile.new()
	config.set_value("User", "themeindex", index)
	config.save(SAVE_PATH)

func _on_Username_text_entered(new_text):
	var config = ConfigFile.new()
	config.set_value("User", "name", new_text)
	config.save(SAVE_PATH)
