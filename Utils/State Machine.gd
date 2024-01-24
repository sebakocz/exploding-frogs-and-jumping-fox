extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.Transitioned.connect(on_child_transitioned)

	if initial_state:
		current_state = initial_state
		current_state.Enter()


func _process(delta):
	if current_state:
		current_state.Update(delta)


func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)


func on_child_transitioned(state, new_state_name):
	if state != current_state:
		return

	var new_state = states[new_state_name]
	if !new_state:
		return

	if current_state:
		current_state.Exit()

	new_state.Enter()

	current_state = new_state
