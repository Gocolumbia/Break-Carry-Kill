extends Sprite

var tgt = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Bullet.modulate = Color(1, 1, 1, 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tgt == null:
		$AmmoBelt.stop()
#		$Bullet.hide()
		$FireRate.stop()
		if $LostTarget.is_stopped() and rotation != 0:
			
			$LostTarget.start()
	else:
		if $FireRate.is_stopped():
			$FireRate.start()
		$AmmoBelt.play()
#		$Arm.global_rotation = 0
#		$Arm.show()
		
		$Bullet.scale.x = tgt.global_position.distance_to(global_position) / 10
#		$Bullet.scale.x = 100
#		$Bullet.show()
	pass


func _on_FireRate_timeout():
	$Bullet/AnimationPlayer.play("shot")
	if tgt != null:
		tgt.damage_taken(Global.stats.dKilDmg)
	pass # Replace with function body.


func _on_LostTarget_timeout():
	rotation = 0
	pass # Replace with function body.
