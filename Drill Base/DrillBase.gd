extends Sprite

var activeDrones = [null, null]

var health = Global.curDrillBaseHP

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in $RadialMenu.get_children().size():
		$RadialMenu.get_children()[i].menuType = 0
		$RadialMenu.get_children()[i].radPos = i
		$RadialMenu.get_children()[i]._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#
#	pass


func _on_Button_pressed():
	get_parent().selectedDrone = self
	for i in $RadialMenu.get_children().size():
		$RadialMenu.get_children()[i].menuIcon = i
		$RadialMenu.get_children()[i]._ready()
	update_spawn_drone_button()
	$RadialMenu.show()
	for i in get_parent().get_children():
		if i.is_in_group("Player"):
			if i != self:
				i.otherClick()
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("lclick"):
		$RadialMenu.hide()

func otherClick(): #Another player-controlled node was clicked
	$RadialMenu.hide()

func rad_menu_button(button):
	if button < 3:
		match button:
			0: #New Drone
				for i in $RadialMenu.get_children().size():
					$RadialMenu.get_children()[i].menuIcon = i + 3
					$RadialMenu.get_children()[i]._ready()
			1: #Upgrade/Repair
				get_parent().get_node("UI/UpgradeMenu").show()
				$RadialMenu.hide()
				pass
			2: #Next Level
				pass
	else: #Spawn Drone
		if activeDrones.has(null):
			var newDrone = load("res://Drone/Drone.tscn").instance()
			newDrone.type = button - 2 #button 3 is breaker, which is index 1, etc
			newDrone.global_position = $SpawnLoc.get_children()[activeDrones.find(null)].global_position
			newDrone.droneIndex = activeDrones.find(null)
			
			activeDrones[activeDrones.find(null)] = newDrone
			
			get_parent().add_child(newDrone)
			for i in 4:
				get_parent().update_drone_select(i)
			$RadialMenu.hide()
	pass

func damage_taken(dmg):
	health -= dmg
	$Light2D/AnimationPlayer.play("DangerLight")
	$Light2D/AlertTimer.start()
	$RadialMenu.value = health / Global.stats.dbMaxHP
	get_parent().get_node("UI/SideBarR/DrillBaseSelect/TextureProgress").value = health / Global.stats.dbMaxHP
	get_parent().get_node("UI/UpgradeMenu/BG/CenterContainer/VBoxContainer/CenterContainer3/HBoxContainer/CenterContainer/Info/Health").text = "Drillbase Health: " + str(ceil((health / Global.stats.dbMaxHP) * 100)) + "%"
	if health <= 0:
		die()

func damage_repair(dmg):
	health += dmg
	if health > Global.stats.dbMaxHP:
		health = Global.stats.dbMaxHP
	$RadialMenu.value = health / Global.stats.dbMaxHP
	get_parent().get_node("UI/SideBarR/DrillBaseSelect/TextureProgress").value = health / Global.stats.dbMaxHP
	get_parent().get_node("UI/UpgradeMenu/BG/CenterContainer/VBoxContainer/CenterContainer3/HBoxContainer/CenterContainer/Info/Health").text = "Drillbase Health: " + str(ceil((health / Global.stats.dbMaxHP) * 100)) + "%"
	

func die():
	get_parent().game_over()
	pass


func _on_AlertTimer_timeout():
	$Light2D/AnimationPlayer.play("SpinLight")
	pass # Replace with function body.

func update_spawn_drone_button():
	if $RadialMenu/RadialMenuButton1.menuIcon == 0: #Button is "Spawn Drone"
		if !activeDrones.has(null): #No empty drone slots
			$RadialMenu/RadialMenuButton1.disabled = true
			$RadialMenu/RadialMenuButton1._ready()
		else:
			$RadialMenu/RadialMenuButton1.disabled = false
			$RadialMenu/RadialMenuButton1._ready()
