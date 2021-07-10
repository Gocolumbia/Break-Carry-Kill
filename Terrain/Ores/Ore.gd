extends AnimatedSprite

var type = 0
enum oreTypes {GOLD, TITANIUM}
const ORE_COLOR = [Color(1, 1, 0.3), Color(1, 0.5, 1)]

var tilePos

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = ORE_COLOR[type]
	position = tilePos * 32
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func broken():
	var oreDrop = load("res://Terrain/Ores/ore drop/OreDrop.tscn").instance()
	oreDrop.type = type
	oreDrop.position = global_position + Vector2(16,16)
	get_parent().get_parent().add_child(oreDrop)
	queue_free()
	pass
