class_name BulletSpawner
extends Node

@export var spawn_container: Node2D
@export var bullet: PackedScene
@export var spawn_points: Array[Node2D]
@export var spawn_chance := 0.1

func spawn() -> void:
	for spawn_point in spawn_points:
		if randf_range(0., 1.) <= spawn_chance:
			var bullet: Node2D = bullet.instantiate()
			if spawn_container:
				spawn_container.add_child(bullet)
			else:	
				spawn_point.add_child(bullet)
			bullet.global_position = spawn_point.global_position
