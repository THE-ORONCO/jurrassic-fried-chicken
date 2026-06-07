extends Node2D

@onready var burner: Burner = %Burner
# Called when the node enters the scene tree for the first time.
@onready var win_timer: Timer = %WinTimer
@onready var player_health: PlayerHealth = %PlayerHealth
@onready var player: Player = %Player
@onready var respawn_position: Marker2D = %RespawnPosition
@onready var the_void: Area2D = %Void

const WIN_SCREEN = preload("uid://cjqf5x6tgp6c4")
const LOSE_SCREEN = preload("uid://byndqwuk4jutl")

func _ready() -> void:
	win_timer.timeout.connect(win)
	player_health.died.connect(loose)

func turn_off() -> void:
	await burner.turn_off()

func win() -> void:
	get_tree().change_scene_to_packed.call_deferred(WIN_SCREEN)

func loose() -> void:
	get_tree().change_scene_to_packed.call_deferred(LOSE_SCREEN)

func respand_player() -> void:
	player.take_damage(0.1)
	player.global_position = respawn_position.global_position
	
func _physics_process(delta: float) -> void:
	for thing in the_void.get_overlapping_bodies():
		if thing is Player:
			respand_player.call_deferred()
