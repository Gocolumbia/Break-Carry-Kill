extends CenterContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func UG_button_press(button):
	print(button)
	pass


func _on_RerollButton_pressed():
	print("reroll")
	pass # Replace with function body.


func _on_RepairButton_pressed():
	var db = get_parent().get_parent().get_node("DrillBase")
#	print()
	if db.health < Global.stats.dbMaxHP and get_parent().get_parent().funds >= 10:
		db.damage_repair(Global.stats.dbMaxHP / 10)
		get_parent().get_parent().funds -= 10
		update_funds()
#	print("repair")
	pass # Replace with function body.


func _on_ExitMenu_pressed():
	hide()
	pass # Replace with function body.

func update_funds():
	$BG/CenterContainer/VBoxContainer/CenterContainer3/HBoxContainer/CenterContainer/Info/Funds.text = "Funds: $" + str(get_parent().get_parent().funds)
