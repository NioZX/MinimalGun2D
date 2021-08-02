extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player_pos = Vector2(50,80)
var can_jump = true
var speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (can_walk):
		var path = $Navigation2D.get_simple_path(player_pos, self.position)
		$Line2D.points = path
		var distance_to_walk = speed * delta
		
		position.direction_to(path[0]) * distance_to_walk
