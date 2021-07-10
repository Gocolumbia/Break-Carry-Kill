extends Sprite

var armLength = 0
const drillOffset = 182
var drillPosX = 182
var drillPos = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Arm.points = [Vector2(0,0), Vector2(0,0)]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	armLength = (drillPosX - drillOffset) * -10
#	$Arm.scale.x = armLength / 100
#	$Drill.position.x = armLength + drillOffset
	if drillPos == null:
		$Drill.position.x = 182
		$Drill.stop()
#		$Arm.hide()
#		$Arm.points[1] = Vector2(0,0)
		$ArmSprite.hide()
	else:
		$Drill.global_position = drillPos
		$Drill.play()
#		$Arm.points[1] = ($Drill/DrillBack.global_position - global_position)
#		$Arm.global_rotation = 0
#		$Arm.show()
		$ArmSprite.scale.x = (($Drill.position).length() - 125) / 100
		$ArmSprite.show()
	pass
