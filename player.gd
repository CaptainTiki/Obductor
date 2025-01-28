extends RigidBody3D

@export var thrust: float = 1000.0
@export var torque_thrust: float = 100.0

@export var default_level : String = "res://Level/level.tscn"

@onready var explosion_audio : AudioStreamPlayer = $AudioManager/ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $AudioManager/SuccessAudio
@onready var success_particles: GPUParticles3D = $ParticleEmitters/SuccessParticles
@onready var explosion_particles: GPUParticles3D = $ParticleEmitters/ExplosionParticles


var is_transitioning : bool = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
	
	
	pass

func _on_body_entered(body: Node) -> void:
	if (is_transitioning):
		return
		
	if "Safe" in body.get_groups():
		#do we care?
		pass
	
	if "Goal" in body.get_groups():
		if body.file_path:
			complete_level(body.file_path)
		else:
			complete_level(default_level)
		pass
	
	if "Hazard" in body.get_groups():
		crash_sequence()
		pass

func crash_sequence() -> void:
	print("Kaboom!")
	explosion_particles.emitting = true
	explosion_audio.play()
	is_transitioning = true
	set_process(false)
	var tween = create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(get_tree().reload_current_scene)

func complete_level(next_level_file : String) -> void:
	success_particles.emitting = true
	success_audio.play()
	is_transitioning = true
	set_process(false)
	var tween = create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))
	
