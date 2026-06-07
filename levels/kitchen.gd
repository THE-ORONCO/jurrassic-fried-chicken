extends Node2D

@onready var burner: Burner = %Burner
@onready var cleaver_attack_l: CleaverAttack = %CleaverAttackL
@onready var cleaver_attack_r: CleaverAttack = %CleaverAttackR

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(1).timeout.connect(burner.turn_on)

	get_tree().create_timer(5).timeout.connect(turn_off)
	
	cleaver_attack_l.attack()
	cleaver_attack_r.attack()

func turn_off() -> void:
	await burner.turn_off()
