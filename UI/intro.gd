extends Control

@onready var video_stream_player: VideoStreamPlayer = %VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	video_stream_player.finished.connect(start_game)

const KITCHEN = preload("uid://bvns7kooakilb")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func start_game() -> void:
	get_tree().change_scene_to_packed.call_deferred(KITCHEN)
