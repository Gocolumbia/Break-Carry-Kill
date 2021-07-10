extends KinematicBody2D

var walkSpd = Global.stats.dWlkSpd
var path = []
var walking = false

var selected = false
var menuShown = false

enum dType {NULL, BREAK, CARRY, KILL}
var type = dType.CARRY

var target = null

var health = Global.stats.dMaxHP

const DRONE_COLORS = [Color(0, 0, 0), Color(1, 1, 0), Color(0, 0, 1), Color(1, 0, 0)]

func _ready():
	$Core.modulate = DRONE_COLORS[type]
	for i in 4:
		get_node("DroneLeg" + str(i+1) + "/Colored").modulate = DRONE_COLORS[type]
	match type:
		dType.BREAK:
			var bD = load("res://Drone/Breaker Drill/BreakerDrill.tscn").instance()
			add_child(bD)
			$TargetTimer.start()
		dType.CARRY:
			var cB = load("res://Drone/CarrierBasket.tscn").instance()
			add_child(cB)
		dType.KILL:
			var kT = load("res://Drone/Killer Turret/KillerTurret.tscn").instance()
			add_child(kT)
			$TargetTimer.start()
	for i in $RadialMenu/HP.get_children().size():
		$RadialMenu/HP.get_children()[i].menuType = 1
		$RadialMenu/HP.get_children()[i].radPos = i
		
		$RadialMenu/HP.get_children()[i].menuIcon = i
		$RadialMenu/HP.get_children()[i]._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	move_and_collide(Vector2(10, 0))
	if walking:
		follow_path(walkSpd * delta)
	match type:
		dType.BREAK:
			if target != null:
				var targetPos = get_parent().get_node("Navigation2D/TileMap").map_to_world(target) + Vector2(16, 16)
				$BreakerDrill.rotation = position.angle_to_point(targetPos) - rotation + PI
	#			$BreakerDrill.drillPosX = position.distance_to(targetPos)
				$BreakerDrill.drillPos = targetPos
				var breakExists = false
				for i in get_parent().get_node("Breaks").get_children():
					if i.tilePos == target:
						if !i.breakNum.has(self):
							i.breakNum.append(self)
						breakExists = true
						break
				if !breakExists and get_parent().get_node("Navigation2D/TileMap").get_cellv(target) == 0:
					var newBreak = load("res://Terrain/cracking/Break.tscn").instance()
					newBreak.tilePos = target
					newBreak.breakNum.append(self)
					get_parent().get_node("Breaks").add_child(newBreak)
	#				breakpoint
			else:
				$BreakerDrill.rotation = 0
	#			$BreakerDrill.drillPosX = 182
				$BreakerDrill.drillPos = null
		dType.CARRY:
			pass
		dType.KILL:
			if target != null:
				var targetPos = target.global_position
				$KillerTurret.rotation = position.angle_to_point(targetPos) - rotation + PI
				$KillerTurret.tgt = target
			else:
				
#				$KillerTurret.get_node("LostTarget").start()
				$KillerTurret.tgt = null
			pass
#	if get_parent().selectedDrone == self:
#		print("true")
#		$RadialMenu.show()
#	else:
#		$RadialMenu.hide()
	$RadialMenu.rotation = -rotation
	pass

func _unhandled_input(event):
	if event.is_action_pressed("lclick"):
		$RadialMenu.hide()
		if get_parent().selectedDrone == self:
			path = get_parent().navigate(global_position, get_global_mouse_position())
			walking = true
			get_parent().selectedDrone = null

func otherClick(): #Another player-controlled node was clicked
	$RadialMenu.hide()

func follow_path(speed):
	if path.size() > 0:
		
		var movement = (path[0] - position).normalized() * speed
#		print(path[0])
		move_and_collide(movement)
#		move_and_slide((path[0] - position).normalized() * walkSpd)
		if (global_position - path[0]).length() < 1:
			path.remove(0)
		rotation = movement.angle()
		$AnimationPlayer.play("WalkE")
#		print(str(path.size()) + str(self)) 
#		print("walk")
	else:
		$AnimationPlayer.play("Stand")
#		print(str(path.size()) + str(self))
		walking = false
#		print("Stood")


func _on_Button_pressed():
	if get_parent().selectedDrone != self or menuShown:
		menuShown = false
		$RadialMenu.scale = Vector2(1,1)
		for i in $RadialMenu/HP.get_children():
			i.hide()
		get_parent().selectedDrone = self
		$RadialMenu.show()
	else:
		menuShown = true
		$RadialMenu.scale = Vector2(3,3)
		for i in $RadialMenu/HP.get_children():
			i.show()
	for i in get_parent().get_children():
		if i.is_in_group("Player"):
			if i != self:
				i.otherClick()
	pass # Replace with function body.


func _on_TargetTimer_timeout():
	match type:
		dType.BREAK:
			var prevTarget = target
			var tileMap = get_parent().get_node("Navigation2D/TileMap")
			target = null
			for i in tileMap.get_used_cells_by_id(0):
				if tileMap.map_to_world(i).distance_to(global_position) < Global.stats.dBrkRange:
					if target == null:
						target = i
					else: if tileMap.map_to_world(i).distance_to(global_position) < tileMap.map_to_world(target).distance_to(global_position):
						target = i
			if prevTarget != target and prevTarget != null: #target block is no longer neing targeted
				for i in get_parent().get_node("Breaks").get_children():
					if i.tilePos == prevTarget:
						i.breakNum.erase(self)
		dType.KILL:
			target = null
			for i in get_parent().get_children():
				if i.is_in_group("Enemy"):
					if i.global_position.distance_to(global_position) < Global.stats.dKilRange:
						$RayCast2D.rotation = -rotation
						$Line2D.rotation = -rotation
						$RayCast2D.cast_to = (i.global_position - global_position) * 10
						$Line2D.points[1] = $RayCast2D.cast_to
						print($RayCast2D.get_collider())
						if $RayCast2D.get_collider() != null:
							if $RayCast2D.get_collider().is_in_group("Enemy"):
								if target == null:
									target = i
								else: if i.global_position.distance_to(global_position) < target.global_position.distance_to(global_position):
									target = i
	pass # Replace with function body.

func damage_taken(dmg):
	health -= dmg
	if health <= 0:
		die()

func die():
	var deathCloud = load("res://General/DeathCloud.tscn").instance()
	deathCloud.position = global_position
	get_parent().add_child(deathCloud)
	if type == dType.CARRY:
		for i in $CarrierBasket.carriedOres:
			var oreDrop = load("res://Terrain/Ores/ore drop/OreDrop.tscn").instance()
			oreDrop.global_position = Vector2(rand_range(-10, 10), rand_range(-10,10)) + global_position
			oreDrop.type = i
			get_parent().add_child(oreDrop)
	get_parent().get_node("DrillBase").activeDrones[get_parent().get_node("DrillBase").activeDrones.find(self)] = null
	get_parent().get_node("DrillBase").update_spawn_drone_button()
	queue_free()

func rad_menu_button(button):
	match button:
		0: #Autopath
			pass
		1: #Self-Destruct
			die()
	pass
