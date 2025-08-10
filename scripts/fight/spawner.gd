extends Node3D

class_name Spawner

var id: int 
static var NBR_MOB_BY_SPAWNER: int = 3
var mob_dead: Array[int] = []
var maze: Maze
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var debug_id: int = 49

var possible_mobs: Array[PackedScene] = [
	preload("res://scenes/characters/zombie.tscn"),
	#TODO : add other mobs availlable
]
var current_mobs: Array
var spawned: bool = false

var entered_player: Player = null
@onready var player_ray_cast: RayCast3D = $PlayerRayCast
@onready var wall_ray_cast: RayCast3D = $wallRayCast

const SPHERE = preload("res://addons/polyrinthe/sphere.tscn") # DEBUG
# "updated_spawners":{"49":[138],"98":[252,253],"99":[66,67,68]}

func _process(_delta: float) -> void:
	if entered_player && not spawned:
		player_ray_cast.target_position = entered_player.position - position # position relative to world
		player_ray_cast.force_raycast_update()
		var dist_to_player = (player_ray_cast.get_collision_point() - position).length()
		
		wall_ray_cast.target_position = entered_player.position - position # position relative to world
		wall_ray_cast.force_raycast_update()
		
		var dist_to_wall = 10000000
		if wall_ray_cast.is_colliding():
			dist_to_wall = (wall_ray_cast.get_collision_point() - position).length()
		
		if dist_to_player < dist_to_wall:
			#print(dist_to_player, " ", dist_to_wall)
			
			spawned = true
			for mob in current_mobs:
				add_child(mob)
				var max_spawn_radius = (CubeCustom.distFromCenter/2) * maze.polyrinthe.room_scale
				mob.position = Vector3(randf_range(-1, 1) * max_spawn_radius, -max_spawn_radius*1.5, randf_range(-1, 1) * max_spawn_radius)
			$PlayerRayCast.queue_free()
			$wallRayCast.queue_free()
			$Area3D.queue_free()
			
			# DEBUG: hit collision marker
			#var sphere = SPHERE.instantiate() # DEBUG
			#sphere.position = wall_ray_cast.get_collision_point() # DEBUG
			#sphere.scale = Vector3(0.05, 0.05, 0.05) # DEBUG
			#get_parent().add_child(sphere) # DEBUG
			#
			#var sphere2 = SPHERE.instantiate() # DEBUG
			#sphere2.get_child(0).mesh.material.albedo_color = Color(0, 0, 0, 1) # DEBUG
			#sphere2.position = player_ray_cast.get_collision_point() # DEBUG
			#sphere2.scale = Vector3(0.05, 0.05, 0.05) # DEBUG
			#get_parent().add_child(sphere2) # DEBUG
			#
			#var sphere3 = SPHERE.instantiate() # DEBUG
			#sphere3.get_child(0).mesh.material.albedo_color = Color(0, 1, 0, 1) # DEBUG
			#sphere3.position = position # DEBUG
			#sphere3.scale = Vector3(0.05, 0.05, 0.05) # DEBUG
			#get_parent().add_child(sphere3) # DEBUG

func setMaze(maze_ref: Maze) -> void:
	maze = maze_ref


func initialise_mobs_list(human_seed: String, mob_id_to_avoid: Array[int]) -> void:
	mob_dead = mob_id_to_avoid
	if id == debug_id:
		print("Spawner::initialise_mobs_list::id: ", id, ", human_seed: ", human_seed, ", mob_id_to_avoid: ", mob_id_to_avoid, ", difficulty: ", maze.difficulty)
	
	var depth_ratio: float = float(maze.polyrinthe.cubeGraph.getDepth(id))/maze.polyrinthe.cubeGraph.get_deepest()
	for i in range(NBR_MOB_BY_SPAWNER):
		var new_id = Enemy.get_next_id()
		if id == debug_id:
			print("new_id: ", new_id)
		if new_id not in mob_dead:
			if id == debug_id:
				print("spawn mob with id: ", new_id)
			var new_human_seed = human_seed + "mob" + str(new_id)
			rng.seed = hash(new_human_seed)
			
			var new_mob = possible_mobs[rng.randi_range(0, len(possible_mobs) - 1)].instantiate()
			new_mob.id = new_id
			new_mob.is_dead.connect(_on_mob_death)
			current_mobs.append(new_mob)
			new_mob.set_mob_data(new_human_seed, maze.difficulty, depth_ratio)
		else:
			if id == debug_id:
				print("nothing to do, mob '", new_id, "' is dead")


func _on_mob_death(mob_id: int) -> void:
	if mob_id not in mob_dead:
		mob_dead.append(mob_id)
	maze.update_spawner(id, mob_dead)
	print("Spawner:: mobs_dead: ", mob_dead)
	
	if len(mob_dead) >= NBR_MOB_BY_SPAWNER: # no more mob available
		queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
	#print("Spawner::", self, "::_on_area_3d_area_entered::player entered : ", area.get_parent())
	entered_player = area.get_parent()
	if !wall_ray_cast:
		wall_ray_cast.enabled = true
	if !player_ray_cast:
		player_ray_cast.enabled = true


func _on_area_3d_area_exited(area: Area3D) -> void:
	#print("Spawner::", self, "::_on_area_3d_area_exited::player exited : ", area.get_parent())
	if area.get_parent() == entered_player:
		entered_player = null
		if wall_ray_cast:
			wall_ray_cast.enabled = false
		if player_ray_cast:
			player_ray_cast.enabled = false
