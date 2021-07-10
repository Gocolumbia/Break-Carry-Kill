extends AnimatedSprite

var type = 1
enum oreTypes {GOLD, TITANIUM}
const ORE_COLOR = [Color(1, 1, 0.3), Color(1, 0.5, 1)]

var pullingDrone
var pullSpd = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = ORE_COLOR[type]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pullingDrone != null:
		position += (pullingDrone.global_position - global_position).normalized() * pullSpd * delta
		if pullingDrone.global_position.distance_to(global_position) < 10:
			pullingDrone.add_ore(type)
			queue_free()
	pass
