class_name HammerAttack
extends Node2D

@export var cam: ShakyCam
@onready var animation: AnimationPlayer = %Animation

func attack() -> void:
	animation.play("attack")

func impact() -> void:
	cam.add_trauma(1)
