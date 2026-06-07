extends Area2D

@export var shake_amount := .6

func _ready() -> void:
	self.area_entered.connect(_damage_player)
	self.body_entered.connect(_damage_player)
	
func _damage_player(entity:Node2D) -> void:
	if entity.has_method("take_damage"):
		entity.take_damage(shake_amount)
	
