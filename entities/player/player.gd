extends CharacterBody2D

signal landed_on_floor
signal left_floor
signal start_walk
signal stop_walk

const SPEED = 300.0
@export var jump_vel = -400.0
@onready var state_chart: StateChart = %StateChart
var _was_on_floor := false
var _moving := false
var _gravity_factor := 1.

func _ready() -> void:
	_was_on_floor = is_on_floor()
	landed_on_floor.connect(func(): state_chart.send_event("landed_on_floor"))
	left_floor.connect(func(): state_chart.send_event("left_floor"))
	start_walk.connect(func(): state_chart.send_event("start_walk"))
	stop_walk.connect(func(): state_chart.send_event("stop_walk"))

# TODO add a jumping state that increases upwards velocity while the player holds the jump button pressed $StateChart/Root/Jumping/Jumping
func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		# if we just touched the floor, notify the state chart
		if not _was_on_floor:
			_was_on_floor = true
			landed_on_floor.emit()
	else:
		velocity += get_gravity() * delta * _gravity_factor
		# if we just left the floor, notify the state chart
		if _was_on_floor:
			_was_on_floor = false
			left_floor.emit()

	# Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

		
	if velocity && !_moving:
		_moving = true
		start_walk.emit()
	elif !velocity && _moving:
		_moving = false
		stop_walk.emit()
		

	move_and_slide()

func move_horizontal(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 10)

## Called in states that allow jumping, we process jumps only in these.
func _on_jump_enabled_state_physics_processing(_delta:float) -> void:
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_vel
		state_chart.send_event("jump")

#region GROUND
func _on_ground_state_entered() -> void:
	velocity.y = 0

func _on_ground_state_physics_processing(delta: float) -> void:
	move_horizontal(delta)
#endregion

#region AIR

func _on_air_state_physics_processing(delta: float) -> void:
	#if Input.is_action_pressed("jump"):
		#state_chart.send_event("")
	move_horizontal(delta)

#endregion


#region GLIDE
func _on_gliding_state_entered() -> void:
	_gravity_factor = 0.1


func _on_gliding_state_exited() -> void:
	_gravity_factor = 1.

#endregion
