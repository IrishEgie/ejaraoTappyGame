extends Control

var GAME = preload("uid://cmvi8rt67bmrw")

# Reference to the label that displays the numerical score value
@onready var high_score_lbl: Label = $MC/HighScoreLBL

func _ready() -> void:
	# Display the persistent high score when the menu loads
	high_score_lbl.text = "%04d" % ScoreManager.get_high_score()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		GameManager.load_game_scene()
