extends Node

var MAIN = preload("res://Scenes/Main/Main.tscn")
var GAME = preload("uid://cmvi8rt67bmrw")


func load_main_scene()->void:
	get_tree().change_scene_to_packed(MAIN)
	
func load_game_scene()->void:
	get_tree().change_scene_to_packed(GAME)
