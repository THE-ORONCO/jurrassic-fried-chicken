class_name HammerAttack
extends Node2D

signal attack_finished

@export var cam: ShakyCam
@export var target: Player
@export var hit_trauma := 0.3
@onready var animation: AnimationPlayer = %Animation
@onready var state_chart: StateChart = %StateChart
@onready var hammer_hit_box: Area2D = %HammerHitBox


func _ready() -> void:
	animation.animation_finished.connect(func(anim):
		if anim == "hide":
			state_chart.send_event("hidden")
		)
	hammer_hit_box.area_entered.connect(do_damage)
	hammer_hit_box.body_entered.connect(do_damage)

func do_damage(thing: Node2D) -> void:
	if thing.has_method("take_damage"):
		thing.take_damage(hit_trauma)

func attack() -> void:
	state_chart.send_event("show")
	
func impact() -> void:
	cam.add_trauma(1)


func _on_tracking_state_entered() -> void:
	animation.play("show")


func _on_tracking_state_physics_processing(delta: float) -> void:
	global_position.x = move_toward(global_position.x, target.global_position.x, 10)



func _on_attacking_state_entered() -> void:
	animation.play("attack")
	


func _on_attacking_state_exited() -> void:
	attack_finished.emit()
