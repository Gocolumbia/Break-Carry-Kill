extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selectedDrone

var funds = 0 #Immediately available funds
var bankedTi = 0 #Titanium gathered this level

# Called when the node enters the scene tree for the first time.
func _ready():
#	var drone = load("res://Drone/Drone.tscn")
#	for i in 3:
#		var droneS = drone.instance()
#
#		add_child(droneS)
#		droneS.position = Vector2(100, 100) * i
	for i in $Navigation2D/TileMap.get_used_cells_by_id(0):
		if randf() > 0.9:
			var newOre = load("res://Terrain/Ores/Ore.tscn").instance()
			newOre.type = randi() % 2
			newOre.tilePos = i
			$Ores.add_child(newOre)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func navigate(userPos, targetPos):
	var path = $Navigation2D.get_simple_path(userPos, targetPos, true)
#	print(userPos)
#	print(get_local_mouse_position())
#	print(path)
	$Line2D.points = path
	path.remove(0)
	return path 

func game_over():
	$GameOverText.show()
