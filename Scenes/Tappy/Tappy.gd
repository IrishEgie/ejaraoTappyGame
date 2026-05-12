extends CharacterBody2D
class_name Tappy

# Reference your new audio player
@onready var engine_sound: AudioStreamPlayer = $EngineSound
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity") 
const JUMP_VELOCITY: float = -400.0 

var is_alive: bool = true
var is_reacting: bool = false 

func _unhandled_input(event: InputEvent) -> void:
	if is_alive and event.is_action_pressed("ui_accept"):
		jump() 

func jump() -> void:
	velocity.y = JUMP_VELOCITY
	if animated_sprite_2d:
		animated_sprite_2d.play() 
	
	# --- ENGINE REV LOGIC ---
	# Create a tween to handle the pitch shift
	var tween = create_tween()
	
	# Immediately set pitch to 1.2x (the "rev" sound)
	engine_sound.pitch_scale = 1.2
	
	# Smoothly transition back to 1.0 (normal hum) over 0.4 seconds
	# This matches the "duration" of the physical jump upward
	tween.tween_property(engine_sound, "pitch_scale", 1.0, 0.4).set_trans(Tween.TRANS_SINE)

func _physics_process(delta: float) -> void:
	if is_reacting:
		velocity = Vector2.ZERO
		return 

	if not is_on_floor():
		velocity.y += gravity * delta 
	
	move_and_slide() 
	
	if is_alive:
		if is_on_floor() or is_on_ceiling():
			die() 
		rotation = lerp_angle(rotation, velocity.y * 0.002, 0.1) 
	elif is_on_floor() and not is_reacting:
		SignalHub.on_player_hit_ground.emit() 
	else:
		rotation = lerp_angle(rotation, PI/2, 0.1)

func die() -> void:
	if not is_alive: return
	is_alive = false
	is_reacting = true
	
	# Stop the engine sound immediately on death
	if engine_sound:
		engine_sound.stop()
	
	if animated_sprite_2d:
		animated_sprite_2d.stop() 
	
	SignalHub.on_player_died.emit() 
	
	var tween = create_tween()
	for i in range(4):
		tween.tween_property(self, "rotation", deg_to_rad(-20), 0.1)
		tween.tween_property(self, "rotation", deg_to_rad(20), 0.1) 
	
	tween.tween_callback(func(): is_reacting = false)
