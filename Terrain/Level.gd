extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selectedDrone

var funds = 0 #Immediately available funds
var bankedTi = 0 #Titanium gathered this level

var mapPin = preload("res://UI/MapPin.tscn")

var cameraOrigin = null

var map_size = Vector2(100, 100)
var noise = OpenSimplexNoise.new()
var drillBaseTiles = [[6, 7, 9, 8],[7,14,14,9],[11,14,14,13],[10,11,13,12]] #Indexes of tile under a drill, top-down, left-right
# Called when the node enters the scene tree for the first time.
func _ready():
#	var drone = load("res://Drone/Drone.tscn")
#	for i in 3:
#		var droneS = drone.instance()
#
#		add_child(droneS)
#		droneS.position = Vector2(100, 100) * i 

	#generate map
	#Create tile map from noise
	randomize()
	noise.seed = randi()
	for i in map_size.x:
		for j in map_size.y:
			var tile
			if noise.get_noise_2d(i * 40, j * 40) > 0:
				tile = 4
			else:
				tile = 3
			$Navigation2D/TileMap.set_cell(i, j, tile)
	#Add indestructible border
	for i in map_size.x:
		$Navigation2D/TileMap.set_cell(i, -1, 5)
		$Navigation2D/TileMap.set_cell(i, map_size.y, 5)
	for j in map_size.y:
		$Navigation2D/TileMap.set_cell(-1, j, 5)
		$Navigation2D/TileMap.set_cell(map_size.x, j, 5)
	#Add drillbase
	for i in 4:
		for j in 4:
			$Navigation2D/TileMap.set_cell(j + round(map_size.x / 2), i + round(map_size.y / 2), drillBaseTiles[i][j])
	for i in 4:
		$Navigation2D/TileMap.set_cell(i+round(map_size.x / 2), round(map_size.y / 2 - 1), 1)
		$Navigation2D/TileMap.set_cell(i+round(map_size.x / 2), round(map_size.y / 2 + 4), 1)
	for i in 4:
		$Navigation2D/TileMap.set_cell(round(map_size.x / 2 - 1), i+round(map_size.y / 2), 1)
		$Navigation2D/TileMap.set_cell(round(map_size.x / 2 + 4), i+round(map_size.y / 2), 1)
	$DrillBase.position = Vector2(round(map_size.x / 2) * 32 + 64, round(map_size.y / 2) * 32 + 64)
	#Add ores
	for i in $Navigation2D/TileMap.get_used_cells_by_id(3):
		if randf() > 0.9:
			var newOre = load("res://Terrain/Ores/Ore.tscn").instance()
			newOre.type = randi() % 2
			newOre.tilePos = i
			newOre.hide()
			$Ores.add_child(newOre)
	$Camera2D.position = $DrillBase.position
	#Fog of war
	for i in 4:
		update_darkness(Vector2(i+round(map_size.x / 2), round(map_size.y / 2 - 1)))
		update_darkness(Vector2(i+round(map_size.x / 2), round(map_size.y / 2 + 4)))
	for i in 4:
		update_darkness(Vector2(round(map_size.x / 2 - 1), i+round(map_size.y / 2)))
		update_darkness(Vector2(round(map_size.x / 2 + 4), i+round(map_size.y / 2)))
	#Add enemies
	for i in $Navigation2D/TileMap.get_used_cells_by_id(4):
		if randf() > 0.99:
			var newEnemy = load("res://Enemies/Crawler/Crawler.tscn").instance()
			newEnemy.position = i * 32 + Vector2(16,16)
			newEnemy.hide()
			add_child(newEnemy)
	$Camera2D.position = $DrillBase.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cameraOrigin != null:
		
		$Camera2D.position += cameraOrigin - get_global_mouse_position()
	pass

func _input(event):
	if event.is_action_pressed("rclick"):
		selectedDrone.get_node("RadialMenu").hide()
		selectedDrone = null
	if event.is_action_pressed("scroll_click"):
		cameraOrigin = get_global_mouse_position()
	if event.is_action_released("scroll_click"):
		cameraOrigin = null
	if event.is_action_pressed("scroll_up"):
		$Camera2D.zoom *= 0.9
		if $Camera2D.zoom <= Vector2(0.1,0.1):
			$Camera2D.zoom = Vector2(0.1,0.1)
	if event.is_action_pressed("scroll_down"):
		$Camera2D.zoom *= 1.1
		if $Camera2D.zoom >= Vector2(5,5):
			$Camera2D.zoom = Vector2(5,5)

func navigate(userPos, targetPos):
	var path = $Navigation2D.get_simple_path(userPos, targetPos, true)
#	
	path.remove(0)
	return path 

func game_over():
	$GameOverText.show()

func show_drone_path():
	for i in $DronePath.get_children():
		i.queue_free()
	if selectedDrone != null:
		if selectedDrone.is_in_group("Drone"):
			for i in selectedDrone.path:
				var pinInst = mapPin.instance()
				pinInst.position = i
				
				$DronePath.add_child(pinInst)
			

func deselect_drone():
	selectedDrone = null


func _on_Pause_pressed():
	$UI/PauseMenu.show()
	get_tree().paused = true
	pass # Replace with function body.


func _on_DrillBaseSelect_pressed():
	$Camera2D.position = $DrillBase.position
	pass # Replace with function body.

func _on_DroneSelect_pressed(drone):
	if $DrillBase.activeDrones.size() >= drone + 1:
		if $DrillBase.activeDrones[drone] != null:
			$Camera2D.position = $DrillBase.activeDrones[drone].position
	pass

func update_drone_select(drone):
	
	if $DrillBase.activeDrones.size() >= drone + 1:
		if $DrillBase.activeDrones[drone] == null:
			get_node("UI/SideBarR/DroneSelect" + str(drone)).self_modulate = Color(0.3, 0.3, 0.3)
			get_node("UI/SideBarR/DroneSelect" + str(drone) + "/TextureProgress").value = 0
			get_node("UI/SideBarR/DroneSelect" + str(drone) + "/Sprite").self_modulate = Color(0.3, 0.3, 0.3)
		else:
			get_node("UI/SideBarR/DroneSelect" + str(drone)).self_modulate = $DrillBase.activeDrones[drone].DRONE_COLORS[$DrillBase.activeDrones[drone].type]
			get_node("UI/SideBarR/DroneSelect" + str(drone) + "/TextureProgress").value = $DrillBase.activeDrones[drone].health / Global.stats.dMaxHP
			get_node("UI/SideBarR/DroneSelect" + str(drone) + "/Sprite").self_modulate = $DrillBase.activeDrones[drone].DRONE_COLORS[$DrillBase.activeDrones[drone].type]
	pass

func update_darkness(coord): #Reveals darkened areas adjacent to revealed floor at coordinate
	for i in [Vector2(0,-1), Vector2(0,1), Vector2(-1,0), Vector2(1,0)]:
		match $Navigation2D/TileMap.get_cellv(coord + i):
			3: #Hidden breakable tile
				$Navigation2D/TileMap.set_cellv(coord + i, 0)
				for j in $Ores.get_children():
					if j.tilePos == coord + i:
						j.show()
			4: #Hidden floor tile
				$Navigation2D/TileMap.set_cellv(coord + i, 1)
				for j in get_children():
					if j.is_in_group("Enemy") and $Navigation2D/TileMap.world_to_map(j.global_position) == coord + i:
						j.show()
						j.get_node("TargetingTimer").start()
				update_darkness(coord + i)
			5: #Hidden unbreakable tile
				$Navigation2D/TileMap.set_cellv(coord + i, 2)
	pass
