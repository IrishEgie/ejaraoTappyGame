extends Node

# Two paths: .tres is human-readable (text), .res is optimized (binary)
const SCORES_PATH_TEXT: String = "user://tappyscore.tres" 
const SCORES_PATH_BINARY: String = "user://tappyscore.res"

var _high_score: int = 0
var _current_run_score: int = 0

func _ready() -> void:
	# 1. Load saved data immediately on startup
	load_high_score()
	
	# Connect global signals 
	SignalHub.on_score_updated.connect(_on_score_updated)
	SignalHub.on_game_over.connect(_on_game_over)

func _on_score_updated(new_score: int) -> void:
	_current_run_score = new_score

func _on_game_over() -> void:
	# 2. Only update and save if the player beat the previous record 
	if _current_run_score > _high_score:
		_high_score = _current_run_score
		save_high_score()
	
	_current_run_score = 0

func get_high_score() -> int:
	return _high_score

func load_high_score() -> void:
	# Check for binary first (production), then text (debug fallback)
	var path = ""
	if ResourceLoader.exists(SCORES_PATH_BINARY):
		path = SCORES_PATH_BINARY
	elif ResourceLoader.exists(SCORES_PATH_TEXT):
		path = SCORES_PATH_TEXT
		
	if path != "":
		var hsr = ResourceLoader.load(path) as HighScoreResource
		if hsr:
			_high_score = hsr.high_score

func save_high_score() -> void:
	var hsr: HighScoreResource = HighScoreResource.new()
	hsr.high_score = _high_score
	
	# Godot automatically uses binary or text based on the file extension
	# Save .tres for easy debugging in the 'user://' folder
	
	# ResourceSaver.save(hsr, SCORES_PATH_TEXT) 
	
	# Save .res for a lighter, harder-to-edit production version
	ResourceSaver.save(hsr, SCORES_PATH_BINARY)
