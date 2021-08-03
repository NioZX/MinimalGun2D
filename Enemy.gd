extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player_last_pos
var player_pos = Vector2(50,80)
var can_jump = true
var speed = 50

var path_index = 0;

var current_path

# Called when the node enters the scene tree for the first time.
func _ready():
	get_path()


func get_path():
	current_path = $Navigation2D.get_simple_path(self.position,player_pos)
	$Line2D.points = current_path

func _input(event):
   # Mouse in viewport coordinates.
   if event is InputEventMouseMotion:
	   player_pos = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (player_pos != player_last_pos):
		var start_pos = current_path[0]
		var end_pos = current_path[1]
		
		var distance_to_path = start_pos.distance_to(end_pos) 
		var current_distance = self.position.distance_to(end_pos) 
		var path_completed = (current_distance - 0) / (distance_to_path - 0)
		var speed_to_path = start_pos.linear_interpolate(end_pos, path_completed)
		
		print(path_completed)
		if (path_completed < 0.05):
			get_path()
			player_last_pos = player_pos
		
		move_and_slide(speed_to_path)
		
	
