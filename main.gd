extends Node

@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var obstacle_scene : PackedScene
@export var playTime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()	


func spawn_coins():
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	$LevelSound.play()
	
func spawn_obstacles():
	# Get radius of the player

	var i = 0
	while i < min(level, 5):
		var o = obstacle_scene.instantiate()
		add_child(o)
		o.screensize = screensize
		o.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		# TODO: Check if positions overlap
		while $Player.position.distance_to(o.position) < 5:
			o.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		i += 1
		
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playTime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

func game_over():
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")	# Remove all notes in group "coins"
#	get_tree().call_group("obstacles", "queue_free")	# Remove all notes in group "coins"
#	get_tree().call_group("powerups", "queue_free")	# Remove all notes in group "coins"
	$HUD.show_game_over()
	$Player.die()
	$EndSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		# Delete all obstacles
		var obstacles = get_tree().get_nodes_in_group("obstacles")
		for obstacle in obstacles:
			obstacle.queue_free()
		level += 1
		time_left += 5
		spawn_obstacles()
		spawn_coins()
		$PowerupTimer.wait_time = 2
		$PowerupTimer.start()

func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


func _on_hud_start_game():
	new_game()


func _on_player_pickup(type):
	match type:
		"coin":
			score += 1
			$HUD.update_score(score)
			$CoinSound.play()
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)


func _on_player_hurt():
	game_over()


func _on_powerup_timer_timeout():
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
