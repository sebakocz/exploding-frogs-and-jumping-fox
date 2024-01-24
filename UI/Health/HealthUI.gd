extends Node2D

var heart_icons = []


func _ready():
	for child in get_children():
		heart_icons.append(child)


func _on_player_health_changed(current_health):
	for i in range(0, heart_icons.size()):
		if i < current_health:
			heart_icons[i].set_visible(true)
		else:
			heart_icons[i].set_visible(false)
