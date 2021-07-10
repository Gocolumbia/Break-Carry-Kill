extends Sprite

var carriedOres = []
var unloading = false
enum oreTypes {GOLD, TITANIUM}
const ORE_COLOR = [Color(1, 1, 0.3), Color(1, 0.5, 1)]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	unloading = false
	for i in get_parent().get_parent().get_children():
		
		if i.is_in_group("oreDrop") and carriedOres.size() < Global.stats.dCarCap:
			if i.pullingDrone == null and i.global_position.distance_to(global_position) < Global.stats.dCarRange:
				i.pullingDrone = self
		if i.is_in_group("DrillBase") and carriedOres.size() > 0:
			if i.global_position.distance_to(global_position) < Global.stats.dCarRange:
				unloading = true
				$CPUParticles2D.global_rotation = (i.global_position - global_position).angle()
				
				$CPUParticles2D.modulate = ORE_COLOR[carriedOres[0]]
				if $UnloadTimer.is_stopped():
					$UnloadTimer.start()
	$CPUParticles2D.emitting = unloading
	if !unloading:
		$UnloadTimer.stop()
	pass

func add_ore(oreType):
	carriedOres.append(oreType)
	var carriedOre = load("res://Drone/CarriedOre.tscn").instance()
	carriedOre.position = Vector2(rand_range(-50,-50), rand_range(-50,50))
	carriedOre.type = oreType
	$Ores.add_child(carriedOre)


func _on_UnloadTimer_timeout():
	match carriedOres[0]:
		0: #Gold
			get_parent().get_parent().funds += Global.GOLD_VALUE
		1: #Titanium
			get_parent().get_parent().bankedTi += 1
	for i in $Ores.get_children():
		if i.type == carriedOres[0]:
			i.queue_free()
			break
	carriedOres.remove(0)
	pass # Replace with function body.
