extends Node
class_name Game

const PIPES = preload("uid://dms402y81minq")

# Using absolute paths or relative to the root Node
@onready var pipes_holder: Node = $PipesHolder
@onready var upper: Marker2D = $Upper
@onready var lower: Marker2D = $Lower
@onready var spawn_timer: Timer = $SpawnTimer
@onready var tappy: Tappy = $Tappy 

var score: int = 0
var game_over: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	spawn_timer.timeout.connect(spawn_pipes)
	spawn_timer.start()

	# Listen to Global Signal Hub instead of local nodes [cite: 14]
	SignalHub.on_player_died.connect(_on_player_died)
	SignalHub.on_player_hit_ground.connect(_on_player_hit_ground)
	SignalHub.on_score_generated.connect(_on_score_generated)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = false
		GameManager.load_main_scene()

func spawn_pipes() -> void:
	var new_pipe = PIPES.instantiate()
	
	# Randomize Y between markers [cite: 12, 13]
	var spawn_y = randf_range(upper.global_position.y, lower.global_position.y)
	
	# Set X off-screen based on viewport width [cite: 13]
	var spawn_x = get_viewport().get_visible_rect().size.x + 100.0
	
	new_pipe.position = Vector2(spawn_x, spawn_y)
	pipes_holder.add_child(new_pipe)

func _on_score_generated() -> void:
	score += 1
	# ONLY emit the update signal here
	SignalHub.on_score_updated.emit(score)

func _on_player_died() -> void:
	spawn_timer.stop() 

func _on_player_hit_ground() -> void:
	if not game_over:
		game_over = true
		get_tree().paused = true
		SignalHub.on_game_over.emit() 
