extends Node3D

signal generation(size: int) # DEBUG
var ok: bool = true # DEBUG
@export var size: int = 7 # DEBUG

const Logger = preload("res://scripts/CSharp/Logger.cs")
var logger:Logger = Logger.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	logger.Info("An informational message: " + self.to_string());
	logger.Debug("A Debug message: " + self.to_string());
	
	for line in logger.GetLines():
		print(line)
	print()


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
