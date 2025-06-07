extends Node3D

const Logger = preload("res://scripts/CSharp/Logger.cs")
var logger:Logger = Logger.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	logger.Info("An informational message: " + self.to_string());
	logger.Debug("A Debug message: " + self.to_string());
	
	for line in logger.GetLines():
		print(line)
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
