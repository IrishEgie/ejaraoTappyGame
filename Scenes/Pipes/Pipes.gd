extends Node2D
class_name Pipes

@onready var laser: Area2D = $Laser
@onready var upper: Area2D = $Upper
@onready var lower: Area2D = $Lower
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

const SCROLL_SPEED: float = 120.0

func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)
	
	# Connect collision signals for both pipes
	upper.body_entered.connect(_on_pipe_body_entered)
	lower.body_entered.connect(_on_pipe_body_entered)
	# Connect the exit signal for the scoring laser
	laser.body_exited.connect(_on_laser_body_exited)

func _process(delta: float) -> void:
	# Only move if the game isn't paused
	if not get_tree().paused:
		position.x -= SCROLL_SPEED * delta

func _on_pipe_body_entered(body: Node2D) -> void:
	if body is Tappy and body.is_alive:
		# Specifically identify which pipe was hit for the debugger
		var pipe_name = "Upper" if body.global_position.y < global_position.y else "Lower"
		print("Collision Detected with " + pipe_name + " Pipe!")
		
		# Just tell the plane it's dead; let the plane handle the falling logic
		body.die()

func _on_laser_body_exited(body: Node2D) -> void:
	# Only score if the plane passes through AND is still alive
	if body is Tappy and body.is_alive:
		print("DEBUG: [Signal Generated] - Laser Cleared! +1 Point")
		
		# Replace the old increment_score call with this:
		SignalHub.on_score_generated.emit()

func _on_screen_exited() -> void:
	queue_free()
