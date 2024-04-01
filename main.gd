extends Node

var score = 0
@export var projectile_scene: PackedScene
@export var enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	$Player.start($StartingPosition.position)
	spawn_enemies(1, $EnemySpawnStart.position)


func game_over():
	print("Game over")

func _on_player_shoot():
	if get_tree().get_nodes_in_group("friendly_projectiles").size() == 0:
		var projectile = projectile_scene.instantiate()
	
		var projectile_spawn_location = Vector2.ZERO
	
		projectile.spawn_position($Player.position) 
		
		#print(projectile.name)
	
		add_child(projectile)
	
func spawn_enemies(rows, start_position):
	var enemy = enemy_scene.instantiate()
	
	enemy.spawn_enemy(start_position)
	#Connect signal from enemy
	enemy.destroyed.connect(_on_enemy_destroyed)
	
	add_child(enemy)
	
func _on_enemy_destroyed():
	score += 5
	print(score)
