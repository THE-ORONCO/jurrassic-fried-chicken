class_name Burner
extends Node2D

signal burner_off

@export var shake_amount := .6:
	set(val):
		if hit_box:
			shake_amount = val
			hit_box.shake_amount = shake_amount
			

@onready var fire: GPUParticles2D = %Fire
@onready var hit_box: Area2D = %HitBox
@onready var hit_shape: CollisionShape2D = $HitBox/HitShape
@onready var sparks: GPUParticles2D = %Spark
@onready var stove_click_sound: AudioStreamPlayer = %StoveClickSound
@onready var stove_flame_sound: AudioStreamPlayer = %StoveFlameSound

var burning := false

func _ready() -> void:
	fire.emitting = false
	hit_shape.disabled = true
	shake_amount = shake_amount
	
func turn_on(time_till_ignition := 2., burn_time = 5.) -> void:
	burning = true
	while time_till_ignition >= 0.:
		var random_wait := minf(time_till_ignition, randf_range(0.05, 0.5))
		time_till_ignition -= sparks.lifetime + random_wait

		await spark()
		stove_click_sound.pitch_scale = randf_range(0.97, 1.03)
		stove_click_sound.play()
		await get_tree().create_timer(random_wait).timeout
	
	hit_shape.disabled = false
	fire.emitting = true
	stove_flame_sound.pitch_scale = randf_range(0.97, 1.03)
	stove_flame_sound.play()
	get_tree().create_timer(burn_time).timeout.connect(turn_off)

func turn_off(off_t := .3) -> Signal:
	var tween := create_tween()
	tween.tween_property(fire, "amount_ratio", 0, off_t)
	tween.tween_callback(func():
		fire.emitting = false
		fire.amount_ratio = 1
		hit_shape.disabled = true
		burning = false
		stove_flame_sound.stop()
		burner_off.emit()
		)
	return tween.finished

func spark() -> Signal:
	sparks.restart()
	return sparks.finished
