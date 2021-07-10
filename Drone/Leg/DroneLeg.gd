extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	$AnimationPlayer.play("LegRaise")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	$Leg.scale.y = $FootDownPos.position.y / -100
#	$Colored/Foot.position.y = $FootDownPos.position.y + 78
#	global_rotation = $FootDownPos.position.angle()
	pass

func leg_raise(up):
	if up:
		$Colored/Foot.scale.y = 1
#		$AnimationPlayer.play("LegRaise")
	else:
		$Colored/Foot.scale.y = 0.75
#		$AnimationPlayer.play_backwards("LegRaise")
