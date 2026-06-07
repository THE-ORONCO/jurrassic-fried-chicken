extends StaticBody2D

@export var burners: Array[Burner] = []
@export var burner_delay := 1
@onready var burner_cooldown: Timer = %BurnerCooldown

var max_burners := 2
var can_turn_on := true

func _ready() -> void:
	randomize()
	burner_cooldown.wait_time = burner_delay
	burner_cooldown.timeout.connect(func(): can_turn_on = true)

func _physics_process(delta: float) -> void:
	burners.shuffle()
	var current_burning := burners.filter(func(b: Burner): return b.burning)
	var not_burning := burners.filter(func(b: Burner): return !b.burning)
	
	if current_burning.size() < max_burners && can_turn_on:
		can_turn_on = false
		burner_cooldown.start()
		var burner: Burner = not_burning.pick_random()
		burner.turn_on(3. + randf_range(-1., 1.), 5. + randf_range(-1., 1.))
		burner.burner_off.connect(burner_cooldown.start, CONNECT_ONE_SHOT)
