extends Area2D

@export var shake_amount:= .3

func _ready() -> void:
	self.body_entered.connect(_despawn)
	self.area_entered.connect(_despawn)

func _despawn(entity: Node2D) -> void:
	if entity.has_method("take_damage"):
		entity.take_damage(shake_amount)
	
	self.queue_free()
