extends Node3D

signal generation(size: int) # DEBUG
signal generation_3x3x3(size:int, new_seed:String) # DEBUG
signal display_3x3x3()
var ok: bool = true # DEBUG
@export var size: int = 7 # DEBUG

const Logger = preload("res://scripts/CSharp/Logger.cs")
var logger:Logger = Logger.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(logger)
	logger.Info("An informational message: " + self.to_string());
	logger.Debug("A Debug message: " + self.to_string());
	
	for line in logger.GetLines():
		print(line)
	print()
	
	generation_3x3x3.emit(3, "DEBUG", [-1, -1, 1])
	Maze.set_tag_for_collision_layer($"MainFloor/Debug Lab/Polyrinthe")
	display_3x3x3.emit()
	Maze.apply_collision_layer($"MainFloor/Debug Lab/Polyrinthe")
	
	var config = ConfigFile.new()
	var err = config.load("user://damageGrid.cfg")
	
	if err != OK:
		_save_grid_damage_type()
	else:
		_load_grid_damage_type(config, true)

func _save_grid_damage_type() -> void:
	var config = ConfigFile.new()
	config.set_value("NORMAL", "grid", [1, 0.5, 0.5, 0.5])
	config.set_value("FIRE", "grid", [1.5, 1, 2, 0.5])
	config.set_value("PLANT", "grid", [1.5, 0.5, 1, 2])
	config.set_value("ELEC", "grid", [1.5, 2, 0.5, 1])
	config.save("user://damageGrid.cfg")
	
	for damage_type in config.get_sections():
		print(damage_type)
		if (	!Enums.damage_type_grid.has(damage_type)) && \
				len(config.get_value(damage_type, "grid")) == len(config.get_sections()):
			Enums.damage_type_grid[damage_type] = config.get_value(damage_type, "grid")

func _load_grid_damage_type(config: ConfigFile, erase: bool = false) -> void:
	for damage_type in config.get_sections():
		if (	!Enums.damage_type_grid.has(damage_type)) && \
				len(config.get_value(damage_type, "grid")) == len(config.get_sections()):
			Enums.damage_type_grid[damage_type] = config.get_value(damage_type, "grid")
		else:
			push_error("Error while reading 'damageGrid.cfg'. damage_type_grid may not correctly be initialised. Please verify file content !")
			config.clear()
			if erase:
				_save_grid_damage_type()
			else:
				print("#TODO : close the application without erasing the file")
			break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("launch_generation") and ok:
		print("pressed")
		ok = false # DEBUG
		generation.emit(size)
		
		# DEBUG
		var timer = Timer.new()
		timer.one_shot = true
		add_child(timer)
		timer.timeout.connect(set_ok)
		timer.start(5)
		# DEBUG

# DEBUG
func set_ok():
	print("test")
	ok = true
