extends Area2D
# Coins are in the coins group
# Groups provide a tagging system to identify similar nodes

var screensize = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pickup():
	# Called by the player script
	# Add tweening
	$CollisionShape2D.set_deferred("disabled", true) # Disable collisions
	# Run tweens at the same time on a quadratic curve
	var tw = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)	
	tw.tween_property(self, "scale", scale * 3, 0.3)	
	tw.tween_property(self, "modulate:a", 0.0, 0.3)
	await tw.finished
	queue_free()	# Remove node from tree safely

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_lifetime_timeout():
	# remove powerup on timeout
	queue_free()
