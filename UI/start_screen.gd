extends Node2D

const INTRO = preload("uid://b8kwdm2btqsnl")




func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(INTRO)


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/credit_screen.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
