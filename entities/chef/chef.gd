class_name Chef
extends Node2D

@export var camera: ShakyCam

@export var left_attacks: Array[Attack] = []
@export var right_attacks: Array[Attack] = []
@export var attack_cooldown := 1.

@onready var l_cooldown: Timer = %LCooldown
@onready var r_cooldown: Timer = %RCooldown

var attacking_r := false
var attacking_l := false

var rage := 1.

func _ready() -> void:
	randomize()
	l_cooldown.wait_time = attack_cooldown
	l_cooldown.timeout.connect(func(): attacking_l = false)
	r_cooldown.wait_time = attack_cooldown
	r_cooldown.timeout.connect(func(): attacking_r = false)

func _physics_process(delta: float) -> void:
	if !attacking_l:
		attacking_l = true
		var rand_attack: Attack = left_attacks.pick_random()
		rand_attack.attack(rage * randf_range(.9, 1.1))
		rand_attack.attack_finished.connect(l_cooldown.start, CONNECT_ONE_SHOT)
	if !attacking_r:
		attacking_r = true
		var rand_attack: Attack = right_attacks.pick_random()
		rand_attack.attack(rage * randf_range(.9, 1.1))
		rand_attack.attack_finished.connect(r_cooldown.start, CONNECT_ONE_SHOT)
