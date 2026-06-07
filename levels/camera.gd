class_name ShakyCam
extends Camera2D

@export var decay := 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset := Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_trauma := .5
@export var max_roll := 0.1  # Maximum rotation in radians (use sparingly).
@export var target: Player  # Assign the node this camera will follow.

var trauma := 0.0  # Current shake strength.
var trauma_power := 2  # Trauma exponent. Use [2, 3].

func _ready():
	randomize()
	target.took_damage.connect(add_trauma)

func add_trauma(amount):
	trauma = min(trauma + amount, max_trauma)
	
func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
