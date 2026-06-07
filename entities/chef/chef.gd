class_name Chef
extends Node2D

@export var camera: ShakyCam

@export var left_attacks: Array[Attack] = []
@export var right_attacks: Array[Attack] = []
@export var attack_cooldown := 1.

@onready var l_cooldown: Timer = %LCooldown
@onready var r_cooldown: Timer = %RCooldown

var attack_r: Attack
var attack_l: Attack

var rage := 1.

var _do_attack := false

func _ready() -> void:
	randomize()
	l_cooldown.wait_time = attack_cooldown
	l_cooldown.timeout.connect(func(): attack_l = null)
	r_cooldown.wait_time = attack_cooldown
	r_cooldown.timeout.connect(func(): attack_r = null)
	get_tree().create_timer(1.).timeout.connect(func(): _do_attack = true)

func _physics_process(delta: float) -> void:
	if _do_attack:
		if !attack_l:
			attack_l = left_attacks.pick_random()
			attack_l.attack(rage * randf_range(.9, 1.1))
			attack_l.attack_finished.connect(l_cooldown.start, CONNECT_ONE_SHOT)
		if !attack_r:
			attack_r = right_attacks.pick_random()
			attack_r.attack(rage * randf_range(.9, 1.1))
			attack_r.attack_finished.connect(r_cooldown.start, CONNECT_ONE_SHOT)
