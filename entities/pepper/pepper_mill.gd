class_name Pepper
extends Attack

@export var bullets_to_spawn := 10
@export var target: Player
@export var offset_speed := 300.
@export var max_offset := 300.
@export var spawn_container: Node2D

@onready var timer: Timer = %Timer
@onready var bullet_spawner: BulletSpawner = %BulletSpawner
@onready var state_chart: StateChart = %StateChart
@onready var pepper_arm: Node2D = %PepperArm
@onready var offset: Node2D = %Offset

var track := 0.
var start_pos := Vector2.ZERO

@onready var current_offset_speed := offset_speed


const OUTSIDE := 1100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(turn_the_mill)
	pepper_arm.position.x = OUTSIDE
	start_pos = offset.position
	bullet_spawner.spawn_container = spawn_container

	
func attack(speed := 1) -> void:
	state_chart.send_event("show")

func _flip_offset_direction() -> void:
	current_offset_speed = -current_offset_speed

func turn_the_mill() -> void:
	for i in range(bullets_to_spawn):
		get_tree().create_timer(i * 0.03).timeout.connect(bullet_spawner.spawn)



func _on_showing_state_entered() -> void:
	timer.start()
	
func _on_showing_state_physics_processing(delta: float) -> void:	
	if abs(pepper_arm.global_position.x - target.global_position.x) <= 20:
		state_chart.send_event("visible")

func _tracking_physics_process(delta:float) -> void:
	pepper_arm.global_position.x = move_toward(pepper_arm.global_position.x, target.global_position.x, 10)


func _on_attacking_state_entered() -> void:
	track = 0.

func _on_attacking_state_exited() -> void:
	timer.stop()

func _on_attacking_state_physics_processing(delta: float) -> void:
	offset.position.x += current_offset_speed * delta
	if offset.position.x > max_offset:
		current_offset_speed = -offset_speed
	
	if offset.position.x < -max_offset:
		current_offset_speed = offset_speed


func _on_hiding_state_physics_processing(delta: float) -> void:
	pepper_arm.position.x = move_toward(pepper_arm.position.x, OUTSIDE, 20)
	offset.position.x = move_toward(offset.position.x, 0, 10)
	
	if pepper_arm.position.x >= OUTSIDE:
		state_chart.send_event("hidden")


func _on_hidden_state_entered() -> void:
	attack_finished.emit()
