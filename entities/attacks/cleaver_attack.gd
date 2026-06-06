extends Node2D

@onready var hitbox: Area2D = %Hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_shape: CollisionShape2D = %HitShape

func _ready() -> void:
	hitbox.body_entered.connect(handle_hit)

func attack(speed := 1) -> void:
	animation_player.speed_scale = speed
	animation_player.play("attack")

func handle_hit(thing: Node2D) -> void:
	if thing is CharacterBody2D:
		print("ouch")
		hit_shape.set_deferred("disabled",  true)
