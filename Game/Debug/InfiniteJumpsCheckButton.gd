extends CheckButton

@export var debug_overlay: DebugOverlay

func _physics_process(_delta):
	button_pressed = debug_overlay.player.infinite_jumps

func _on_toggled(toggled_on:bool):
	debug_overlay.player.infinite_jumps = toggled_on