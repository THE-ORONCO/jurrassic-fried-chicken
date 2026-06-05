extends Node2D

@onready var fire: GPUParticles2D = %Fire
@onready var hit_box: Area2D = %HitBox
@onready var hit_shape: CollisionShape2D = $HitBox/HitShape

func _ready() -> void:
	fire.emitting = false
	hit_shape.disabled = true
	
	get_tree().create_timer(1).timeout.connect(turn_on)

func turn_on() -> void:
	fire.emitting = true
	
	get_tree().create_timer(.5).timeout.connect(func(): hit_shape.disabled = false)
	
