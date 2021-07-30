extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var noise = OpenSimplexNoise.new()
var image
var fuzziness = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	noise.seed = randi()
	for i in 32:
		for j in 32:
			var tile
			if noise.get_noise_2d(i * fuzziness , j * fuzziness) > 0:
				tile = 1
			else:
				tile = 0
			$TileMap.set_cell(i, j, tile)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
