extends Node2D

@export var bullets_to_spawn := 10

@onready var timer: Timer = %Timer
@onready var bullet_spawner: BulletSpawner = %BulletSpawner

var start_pos: Vector2
var track := 0.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(turn_the_mill)
	start_pos = self.position
	

func turn_the_mill() -> void:
	for i in range(bullets_to_spawn):
		get_tree().create_timer(i * 0.03).timeout.connect(bullet_spawner.spawn)

func _physics_process(delta: float) -> void:
	track += delta
	self.position.x = start_pos.x + sin(track) * 300
