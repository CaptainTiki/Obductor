extends RigidBody3D

@export var thrust: float = 1000.0
@export var torque_thrust: float = 100.0

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
	pass

func _on_body_entered(body: Node) -> void:
	if "Safe" in body.get_groups():
		complete_level()
		pass
	
	if "Hazard" in body.get_groups():
		print("boom")
		crash_sequence()
		pass
	pass

func crash_sequence() -> void:
	get_tree().reload_current_scene()

func complete_level() -> void:
	print("Level Complete")
