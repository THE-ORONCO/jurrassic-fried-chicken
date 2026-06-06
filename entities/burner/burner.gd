class_name Burner
extends Node2D

@onready var fire: GPUParticles2D = %Fire
@onready var hit_box: Area2D = %HitBox
@onready var hit_shape: CollisionShape2D = $HitBox/HitShape
@onready var sparks: GPUParticles2D = %Spark

func _ready() -> void:
	fire.emitting = false
	hit_shape.disabled = true
	
func turn_on(spark_number := 3, time_till_ignition := 2.) -> void:
	while time_till_ignition >= 0.:
		var random_wait := minf(time_till_ignition, randf_range(0.05, 0.5))
		time_till_ignition -= sparks.lifetime + random_wait

		await spark()
		await get_tree().create_timer(random_wait).timeout
		#await get_tree().create_timer(time_between_sparks).timeout
	fire.emitting = true
	get_tree().create_timer(.5).timeout.connect(func(): hit_shape.disabled = false)

func turn_off(off_t := .3) -> Signal:
	var tween := create_tween()
	tween.tween_property(fire, "amount_ratio", 0, off_t)
	tween.tween_callback(func():
		fire.emitting = false
		fire.amount_ratio = 1
		hit_shape.disabled = true
		)
	return tween.finished

func spark() -> Signal:
	sparks.restart()
	return sparks.finished
