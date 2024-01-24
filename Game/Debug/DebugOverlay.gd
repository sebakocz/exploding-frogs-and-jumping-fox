extends CanvasLayer
class_name DebugOverlay

@export var player : Player

@export var label_box : Control
	
var debug_actions = {
	"debug_toggle": self.toggle_visibility,
	"debug_reset": self.reset_scene,
	"debug_quit": self.quit,
	"debug_stop_time": self.stop_time,
}

var debug_tooltip = """
Y - Toggle debug overlay
X - Reset scene
C - Stop time
ESC - Quit
"""

var status_variables = {}

var status_labels = {}

func _ready():
	# visible only in debug mode
	if not OS.is_debug_build():
		hide()
		return

	update_variables()

	# Create labels
	for variable_name in status_variables.keys():
		var new_label = Label.new()
		new_label.name = "%sLabel" % variable_name
		new_label.label_settings = LabelSettings.new()
		new_label.label_settings.font_size = 32
		# new_label.label_settings.font_color = Color.BLACK
		label_box.add_child(new_label)
		status_labels[variable_name] = new_label

	# Create tooltip
	var tooltip_label = Label.new()
	tooltip_label.name = "TooltipLabel"
	tooltip_label.label_settings = LabelSettings.new()
	tooltip_label.label_settings.font_size = 32
	tooltip_label.text = debug_tooltip
	label_box.add_child(tooltip_label)

func _physics_process(_delta):
	if not OS.is_debug_build():
		return

	for action in debug_actions.keys():
		if Input.is_action_just_pressed(action):
			debug_actions[action].call()

	update_variables()
	update_labels()

func update_labels():
	for variable_name in status_variables.keys():
		status_labels[variable_name].text = "%s: %s" % [variable_name, str(status_variables[variable_name])]

func update_variables():
	status_variables["Position"] = player.position.round()
	status_variables["Velocity"] = player.velocity.round()


func toggle_visibility():
	visible = not visible

func reset_scene():
	get_tree().reload_current_scene()
	Engine.set_time_scale(1)

func quit():
	get_tree().quit()

func stop_time():
	get_tree().paused = not get_tree().paused

