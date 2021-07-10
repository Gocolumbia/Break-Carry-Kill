extends Sprite

var type = 0
enum oreTypes {GOLD, TITANIUM}
const ORE_COLOR = [Color(1, 1, 0.3), Color(1, 0.5, 1)]

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = ORE_COLOR[type]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
