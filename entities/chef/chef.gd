class_name Chef
extends Node2D

@export var camera: ShakyCam

@export var left_attacks: Array[Attack] = []
@export var right_attacks: Array[Attack] = []

var attacking_r := false
var attacking_l := false

var rage := 1

func _physics_process(delta: float) -> void:
	if !attacking_l:
		var rand_attack: Attack = left_attacks.pick_random()
		rand_attack.attack(rage)
		attacking_l = true
		rand_attack.attack_finished.connect(func(): attacking_l = false, CONNECT_ONE_SHOT)
	if !attacking_r:
		var rand_attack: Attack = right_attacks.pick_random()
		rand_attack.attack(rage)
		attacking_r = true
		rand_attack.attack_finished.connect(func(): attacking_r = false, CONNECT_ONE_SHOT)
		
