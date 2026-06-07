extends Node2D

@onready var burner: Burner = %Burner
@onready var cleaver_attack_l: CleaverAttack = %CleaverAttackL
@onready var cleaver_attack_r: CleaverAttack = %CleaverAttackR
@onready var hammer_attack_r: HammerAttack = %HammerAttackR
@onready var hammer_attack_l: HammerAttack = %HammerAttackL
@onready var pepper_attack_l: Pepper = %PepperAttackL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(1).timeout.connect(burner.turn_on)

	get_tree().create_timer(5).timeout.connect(turn_off)
	
	get_tree().create_timer(1).timeout.connect(pepper_attack_l.attack)

	get_tree().create_timer(1).timeout.connect(hammer_attack_l.attack)

func turn_off() -> void:
	await burner.turn_off()

	
