extends TextureButton

var menuType = 0 #Selects type of menu
enum menus {DRILL, DRONE}
var menuIcon = 0 #Selects icon
const DRILL_ICONS = ["res://UI/DrillBase/New Drone.png","res://UI/DrillBase/Upgrade and Repair.png","res://UI/DrillBase/Next Level.png","res://UI/DrillBase/Spawn Breaker.png","res://UI/DrillBase/Spawn Carrier.png","res://UI/DrillBase/Spawn Killer.png"]
const DRILL_TEXT = ["Spawn Drone", "Upgrade/Repair", "Next Level", "Spawn Breaker", "Spawn Carrier", "Spawn Killer"]
const DRILL_DIS_TEXT = ["Drone Cap Reached", "", "Next Level Not Reached", "", "", ""]
const DRONE_ICONS = ["res://UI/Drones/Autopath.png","res://UI/Drones/Self-Destruct.png"]
const DRONE_TEXT = ["", "Self-Destruct"]
var radPos # [Top, Lower Left, Lower Right]

const DISABLED_COLOR = Color(0.7,0.7,0.7)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	
	match menuType:
		menus.DRILL:
			texture_normal = load(DRILL_ICONS[menuIcon])
			for i in get_children():
				if disabled:
					i.text = DRILL_DIS_TEXT[menuIcon]
				else:
					i.text = DRILL_TEXT[menuIcon]
		menus.DRONE:
			texture_normal = load(DRONE_ICONS[menuIcon])
			for i in get_children():
				i.text = DRONE_TEXT[menuIcon]
	if radPos != null and Global.options.showButtonLabels:
		get_children()[radPos].show()
	
	
	
	if disabled:
		modulate = DISABLED_COLOR
	else:
		modulate = Color(1,1,1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RadialMenuButton_pressed():
	match menuType:
		0:
			get_parent().get_parent().rad_menu_button(menuIcon)
		1:
			get_parent().get_parent().get_parent().rad_menu_button(menuIcon)
	pass # Replace with function body.
