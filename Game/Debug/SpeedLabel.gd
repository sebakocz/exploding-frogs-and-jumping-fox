extends Label


func _on_game_speed_slider_value_changed(value: float):
	print("Game speed changed to %s" % value)
	text = "Game Speed: " + str(value)
	Engine.set_time_scale(value)
