extends KinematicBody2D

var path = []
var walkSpd = 50

var target
var tgtDist
var atkRange = 50
var atkRangeBonus = 0 #Added attack range when attacking larger targets 
const D_BASE_ATK_RNG_BONUS = 50 #Added attack range for Drill Base
var atkDmg = 20

var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target == null or path.size() == 0:
		$AnimationPlayer.play("stand")
	else: 
		if target.is_in_group("DrillBase"):
			atkRangeBonus = D_BASE_ATK_RNG_BONUS
		else:
			atkRangeBonus = 0
		if target.global_position.distance_to(global_position) > atkRange + atkRangeBonus:
			follow_path(walkSpd * delta)
			$AnimationPlayer.play("walk")
		else:
			rotation = (target.global_position - global_position).angle()
			$AnimationPlayer.play("attack")
	
	pass


func _on_TargetingTimer_timeout():
	
	if randf() > 0.1:
		for i in get_parent().get_children():
			if i.is_in_group("Player"):
				if target == null:
					target = i
					tgtDist = i.global_position.distance_to(global_position)
				else:
					if tgtDist >= i.global_position.distance_to(global_position):
						tgtDist = i.global_position.distance_to(global_position)
						target = i
		if target != null:
			path = get_parent().navigate(global_position, target.global_position)
	else:
		path = [Vector2(global_position.x + rand_range(-50, 50), global_position.y + rand_range(-50, 50))]
	pass # Replace with function body.

func follow_path(speed):
	if path.size():
		
		var movement = (path[0] - position).normalized() * speed
#		print(path[0])
		move_and_collide(movement)
#		move_and_slide((path[0] - position).normalized() * walkSpd)
		if (global_position - path[0]).length() < 1:
			path.remove(0)
		rotation = movement.angle()

func find_target():
	pass

func attack_hit():
	for i in get_parent().get_children():
		if i.is_in_group("Drone"):
			if $AttackArea.global_position.distance_to(i.global_position) <= atkRange:
				i.damage_taken(atkDmg)
		if i.is_in_group("DrillBase"):
			if $AttackArea.global_position.distance_to(i.global_position) <= atkRange + D_BASE_ATK_RNG_BONUS:
				i.damage_taken(atkDmg)
	pass

func damage_taken(dmg):
	health -= dmg
	if health <= 0:
		die()

func die():
	var deathCloud = load("res://General/DeathCloud.tscn").instance()
	deathCloud.position = global_position
	get_parent().add_child(deathCloud)
	queue_free()
