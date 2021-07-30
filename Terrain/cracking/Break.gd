extends AnimatedSprite

var breakNum = [] #Array of breaker drones working on this block
const REPAIR_SPD = 2
var tilePos #Indexed coordinates of tile, set when instanced
var progress = 0 # 0 to 100, tile is broken when this hits 100

# Called when the node enters the scene tree for the first time.
func _ready():
#	breakpoint
	position = tilePos * 32
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BreakAdvTimer_timeout():
	if breakNum.size() > 0:
		if progress >= 100: #Block broken
			get_parent().get_parent().get_node("Navigation2D/TileMap").set_cellv(tilePos, 1)
			for i in get_parent().get_parent().get_node("Ores").get_children():
				if i.tilePos == tilePos:
					i.broken()
			get_parent().get_parent().update_darkness(tilePos)
			queue_free()
		else:
			progress += breakNum.size() * Global.stats.dBrkSpd
			update_sprite()
	else: #tiles slowly repair themselves if not being drilled
		if progress < 0:
			queue_free()
		else:
			progress -= REPAIR_SPD
			update_sprite()
#	breakpoint
	pass # Replace with function body.

func update_sprite():
	if progress > 75:
		frame = 3
	else: if progress > 50:
		frame = 2
	else: if progress > 25:
		frame = 1
	else:
		frame = 0
