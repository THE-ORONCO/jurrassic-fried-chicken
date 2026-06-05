extends Area2D

func _ready() -> void:
	self.body_entered.connect(_despawn)
	self.area_entered.connect(_despawn)

func _despawn(entity: Node2D) -> void:
	if entity.has_method("take_damage"):
		entity.take_damage()
	
	self.queue_free()
