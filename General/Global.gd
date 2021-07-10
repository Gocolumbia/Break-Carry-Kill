extends Node

var stats = {
	#Drill Base stats
	dbMaxHP = 1000,
	#General Drone Stats
	dMaxHP = 100,
	dWlkSpd = 100,
	#Breaker Drones
	dBrkRange = 100,
	dBrkSpd = 5,
	#Carrier Drones
	dCarCap = 5,
	dCarRange = 100,
	#Killer Drones
	dKilDmg = 20, 
	dKilRange = 200
}

var options = {
	showButtonLabels = true #If true, radial menu buttons will include a brief descriptive text
}

const GOLD_VALUE = 10
const TITANIUM_VALUE = 20

var curDrillBaseHP = stats.dbMaxHP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
