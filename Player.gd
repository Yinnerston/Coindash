extends Area2D

signal pickup
signal hurt

@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start():
	set_process(true)	# What does this do?
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"
	
func die():
	# Called when the player hits an obstacle or runs out of time
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)	# Stop calling _process after this is executed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	# Change animations
	if velocity.length() > 0:
		# $ notation is relative to the node running the script
		# relative to the player node in this script
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	if velocity.x != 0:	# Flip depending on horizontal direction
		$AnimatedSprite2D.flip_h = velocity.x < 0	 


func _on_area_entered(area):
	# When we hit an object, decide what to do
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit()
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
