extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var speed = 50
var player_pos = Vector2(50,80)

var level_navigation: Navigation2D = null

var velocity = Vector2.ZERO
var path : Array = []

var dist_passed = 0;
var last_pos = self.global_position

onready var line2d = $Line2D

var main_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		level_navigation = tree.get_nodes_in_group("LevelNavigation")[0]
		
	if tree.has_group("MainNode"):
		main_node = tree.get_nodes_in_group("MainNode")[0]


func generate_path():
	if level_navigation != null:
		path = level_navigation.get_simple_path(global_position,player_pos, false)
		line2d.points = path
	
func navigate():
	if path.size() > 0:
#		var distance_to_path = enemy_last_jump.distance_to(path[1]) 
#		var current_distance = global_position.distance_to(path[1]) 
#		var path_completed = clamp((current_distance - 0) / (distance_to_path - 0), 0, 1)
#		var speed_to_path = lerp(10 , speed, path_completed)
#		if (current_distance < 5):
#			speed_to_path = lerp(0.1 , speed, path_completed)
#
#		if (current_distance < 1):
#			speed_to_path = 01
		

#		velocity = global_position.direction_to(path[1]).normalized() * speed_to_path * 5
		velocity = global_position.direction_to(path[1]) * speed
		if path[1].distance_to(global_position) > 1:
			var dist = last_pos.distance_to(global_position)
			dist_passed += dist
			last_pos = global_position
			print(dist_passed)
			
		if dist_passed < 80:
			speed = 200
		if dist_passed > 80:
			speed = 15
		if dist_passed > 85:
			dist_passed = 0
		
		if global_position == path[0]:
			path.pop_front()
	
#		if path_completed < 0.05:
#			enemy_last_jump = global_position
#			print(global_position)
#			path.pop_front()

func _input(event):
   # Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		player_pos = main_node.get_global_mouse_position()

func _physics_process(delta):
	line2d.global_position = Vector2.ZERO
	
	if level_navigation:
		generate_path()
		navigate()
	
	move_and_slide(velocity)
	
	#print(dist)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	#$Navigation2D.position = Vector2.ZERO
#	#$Navigation2D/NavigationPolygonInstance.position = Vector2.ZERO
#
#	if (player_pos != player_last_pos):
#		var start_pos = self.position
#		var end_pos = $Navigation2D.get_closest_point(player_pos)
#		print(end_pos)
#
#		var distance_to_path = start_pos.distance_to(end_pos) 
#		var current_distance = self.position.distance_to(end_pos) 
#		var path_completed = (current_distance - 0) / (distance_to_path - 0)
#		var speed_to_path = start_pos.linear_interpolate(end_pos, path_completed) * ( end_pos - self.position ).normalized()
#
#		if (path_completed < 0.05):
#			player_last_pos = player_pos
#
#
#		move_and_slide(speed_to_path)

		
	
