class_name PlayerHealth
extends Node2D

signal died
signal took_damage

@export_range(1, 5) var max_health := 3
@export var player: Player

@onready var bar: TextureProgressBar = %ProgressBar

func _ready() -> void:
	bar.value = max_health
	player.took_damage.connect(take_damage)

func take_damage(amount:= 1) -> void:
	if amount > 0:
		bar.value = clamp(bar.value - amount, 0, max_health)
		took_damage.emit()
		if bar.value <= 0:
			died.emit()
