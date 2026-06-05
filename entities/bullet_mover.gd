@tool
class_name BulletMover
extends Node

@export var moved_entity: Node2D:
	set(val):
		moved_entity = val
		update_configuration_warnings()
@export var speed := 100
@export var direction := Vector2.DOWN

func _get_configuration_warnings() -> PackedStringArray:
	var warn: PackedStringArray = []
	if !moved_entity: warn.append("Needs an entity to move")
	return warn

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	moved_entity.position += direction * speed * delta
