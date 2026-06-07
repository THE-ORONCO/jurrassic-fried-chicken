extends Node2D

@onready var burner: Burner = %Burner
# Called when the node enters the scene tree for the first time.

func turn_off() -> void:
	await burner.turn_off()

	
