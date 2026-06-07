class_name CleaverAttack
extends Attack


@onready var hitbox: Area2D = %Hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_shape: CollisionShape2D = %HitShape

func _ready() -> void:
	hitbox.body_entered.connect(handle_hit)
	animation_player.animation_finished.connect(func(anim):
		if anim == "retract":
			attack_finished.emit()
		)

func attack(speed := 1) -> void:
	animation_player.speed_scale = speed
	animation_player.play("attack")

func handle_hit(thing: Node2D) -> void:
	if thing.has_method("take_damage"):
		thing.take_damage(shake_amount)
		hit_shape.set_deferred("disabled",  true)
