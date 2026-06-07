extends Node2D

@onready var burner: Burner = %Burner
# Called when the node enters the scene tree for the first time.
@onready var win_timer: Timer = %WinTimer
@onready var player_health: PlayerHealth = %PlayerHealth

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
