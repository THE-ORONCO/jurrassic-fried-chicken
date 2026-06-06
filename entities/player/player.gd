extends CharacterBody2D

signal landed_on_floor
signal left_floor
signal start_walk
signal stop_walk

@export_category("ground movement")
@export_range(1., 1000.) var move_speed := 300.0

@export_category("air movement")
@export_range(-1000, -1) var jump_vel := -300.0
@export var normal_gravity_factor := 1.
@export var glide_terminal_velocity := 50
@export_range(1., 1000.) var terminal_velocity := 700.

@export_category("dash")
@export_range(1, 2000) var dash_speed := 400.
@export_range(0.01, 1.) var dash_duration := .2:
	set(val):
		dash_duration = _update_chart_props(val)
@export_range(0.1, 100.) var velocity_damping := 40.

@onready var state_chart: StateChart = %StateChart
@onready var _gravity_factor := normal_gravity_factor


var _velocity_remainder := Vector2.ZERO
var _was_on_floor := false
var _moving := false
var _apply_gravity := true
var _jump_vel_left := 0.
var _jump_time := 0.
var _jump_progress := 0.
var _dash_dir := Vector2.UP
var _dash_vel := Vector2.ZERO

func _ready() -> void:
	_was_on_floor = is_on_floor()
	landed_on_floor.connect(func(): state_chart.send_event("landed_on_floor"))
	left_floor.connect(func(): state_chart.send_event("left_floor"))
	start_walk.connect(func(): state_chart.send_event("start_walk"))
	stop_walk.connect(func(): state_chart.send_event("stop_walk"))

	_update_chart_props()

func _update_chart_props(a: Variant = null) -> Variant:
	if state_chart:
		state_chart.set_expression_property("dash_duration", dash_duration)
	return a

# TODO add a jumping state that increases upwards velocity while the player holds the jump button pressed $StateChart/Root/Jumping/Jumping
func _physics_process(delta: float) -> void:
	_map_input_to_statechart()
	if is_on_floor():
		# if we just touched the floor, notify the state chart
		if not _was_on_floor:
			landed_on_floor.emit()
	else:
		# if we just left the floor, notify the state chart
		if _was_on_floor:
			left_floor.emit()

	if velocity && !_moving:
		_moving = true
		start_walk.emit()
	elif !velocity && _moving:
		_moving = false
		stop_walk.emit()
	
	var vel_factor := clampf(velocity.length() / terminal_velocity, 0., 1.) 
	velocity = velocity.limit_length(terminal_velocity) + _velocity_remainder
	_velocity_remainder = _velocity_remainder.move_toward(Vector2.ZERO, velocity_damping)
	
	move_and_slide()

func _map_input_to_statechart() -> void:
	state_chart.set_expression_property("jump_input", Input.is_action_pressed("jump"))
	state_chart.set_expression_property("is_on_floor", is_on_floor())

func _apply_gravity_physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta


func move_horizontal(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * move_speed 
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed / 10)


## Called in states that allow jumping, we process jumps only in these.
func _on_jump_enabled_state_physics_processing(_delta:float) -> void:
	if Input.is_action_just_pressed("jump"):
		state_chart.send_event("jump")

#region GROUND
func _on_ground_state_entered() -> void:
	_was_on_floor = true
func _on_ground_state_exited() -> void:
	_was_on_floor = false

#endregion


#region JUMPING
func _on_jumping_state_entered() -> void:
	_jump_vel_left = jump_vel
	_jump_time = %OnTimeout.delay_seconds
	_jump_progress = 0.

func _on_jumping_state_physics_processing(delta: float) -> void:	
	if Input.is_action_just_released("jump"):
		state_chart.send_event("stop_jump")
	_jump_vel_left = lerpf(jump_vel, 0., _jump_progress / _jump_time)
	_jump_progress += delta
	velocity.y =  _jump_vel_left
	
#endregion

#region AIR

func _on_airborne_state_physics_processing(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		state_chart.send_event("start_gliding") # TODO do not use gravity scale for gliding

#endregion


#region GLIDE
func _on_gliding_state_physics_processing(delta: float) -> void:
	velocity.y = clamp(velocity.y, -glide_terminal_velocity, glide_terminal_velocity)
	if Input.is_action_just_released("jump"):
		state_chart.send_event("stop_jump")
#endregion

#region CAN_DASH
func _on_can_dash_state_physics_processing(delta: float) -> void:
	if Input.is_action_just_pressed("dash"):
		state_chart.send_event("dash")
	


#endregion

#region DASHING
func _on_dashing_state_entered() -> void:
	_dash_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_dash_vel = _dash_dir * dash_speed

func _on_dashing_state_exited() -> void:
	_dash_vel = Vector2.ZERO
	state_chart.send_event("dash_finished")

func _on_dashing_state_physics_processing(delta: float) -> void:
	_velocity_remainder = _dash_vel
	velocity = _dash_vel
	if Input.is_action_just_released("dash"):
		state_chart.send_event("dash_release")
		
#endregion
