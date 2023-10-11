extends Area2D
# Coins are in the coins group
# Groups provide a tagging system to identify similar nodes

var screensize = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pickup():
	# Called by the player script
	queue_free()	# Remove node from tree safely

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
