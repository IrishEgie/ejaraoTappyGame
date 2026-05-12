extends Control
class_name GameUI

@onready var score_lbl: Label = $MarginContainer/ScoreLBL
@onready var press_lbl: Label = $MarginContainer/PressLBL
@onready var game_over_lbl: Label = $MarginContainer/GameOverLBL
@onready var score_sound: AudioStreamPlayer = $ScoreSound
@onready var game_over_sound: AudioStreamPlayer = $GameOverSound
@onready var hit_sound: AudioStreamPlayer = $HitSound

func _ready() -> void:
	# 1. Initialize Visibility: Hide both status labels at the start 
	score_lbl.text = "0000" 
	game_over_lbl.hide() 
	press_lbl.hide() # Show "Press Space" at the very beginning 
	
	# Connect to the Global Signal Hub 
	SignalHub.on_score_updated.connect(_update_score) 
	SignalHub.on_game_over.connect(_show_game_over) 
	SignalHub.on_player_died.connect(_on_player_died) 
	# 2. Initial "Press Space" fade out (Start of Game) 
	var tween = create_tween() 
	tween.tween_interval(2.0) 
	tween.tween_property(press_lbl, "modulate:a", 0.0, 0.5) 
	tween.tween_callback(press_lbl.hide) 

func _update_score(new_score: int) -> void:
	score_lbl.text = "%04d" % new_score 
	score_sound.play() # Play every time the score changes
	
func _on_player_died() -> void:
	hit_sound.play()
	
func _show_game_over() -> void:
	# 3. Show "Game Over" immediately upon signal
	
	game_over_lbl.show()
	game_over_sound.play() # Play once when the player crashes 
	
	# 4. Create a sequence: Wait 2s -> Hide Game Over -> Show Press Space 
	var retry_tween = create_tween()
	retry_tween.tween_interval(2.0) # Wait for 2 seconds
	retry_tween.tween_callback(game_over_lbl.hide) # Hide "Game Over"
	retry_tween.tween_callback(press_lbl.show) # Show "Press Space" to prompt restart
	retry_tween.tween_property(press_lbl, "modulate:a", 1.0, 0.2) # Ensure it is visible
