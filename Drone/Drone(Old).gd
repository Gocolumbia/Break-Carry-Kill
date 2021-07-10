extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var footPos = [Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0)]

# Called when the node enters the scene tree for the first time.
func _ready():
#	$AnimationPlayer.play("Walk")
#	print(str($DroneLeg1/FootDownPos.global_position - global_position))
	for i in 4:
		footPos[i] = get_node("DroneLeg" + str(i + 1) + "/FootDownPos").global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(footPos)
	for i in 4:
		get_node("DroneLeg" + str(i + 1) + "/FootDownPos").global_position = footPos[i]
		var legFootRelPos = get_node("DroneLeg" + str(i + 1)).global_position - footPos[i]
#		print(tan(legFootRelPos.y / legFootRelPos.x))
		get_node("DroneLeg" + str(i + 1)).rotation = legFootRelPos.angle()
		
#	pass

func raise_leg(leg, up):
	
	if up:
		get_node("DroneLeg" + str(leg) + "/AnimationPlayer").play("LegRaise")
	else:
		get_node("DroneLeg" + str(leg) + "/AnimationPlayer").play_backwards("LegRaise")
