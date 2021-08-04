extends KinematicBody2D

var velocity = Vector2.ZERO;
var state = MOVE;
var dash_frames = 0;
var bullet_speed = 2000;
var bullet = preload("res://Scenes/Bullet.tscn");

const VEL = 500;
const MAX_SPD = 80;
const FRICC = 500;
const DASH_PWR = 1;
const MAX_CAMERA_DISTANCE := 50.0
const MAX_CAMERA_PERCENT := 0.1
const CAMERA_SPEED := 0.1

export (NodePath) onready var player = get_node(player)
export (NodePath) onready var camera = get_node(camera)

enum{
	MOVE,
	DASH
}

func _ready():
	$Sprite.rotation_degrees -= -90

func _physics_process(delta):
	look_at(get_global_mouse_position()) 
	match state:
		MOVE:
			move_process(delta);
		DASH:
			pass
	

func _process(_delta: float) -> void:
	var viewport = get_viewport()
	var viewport_center = viewport.size / 2.0
	var direction = viewport.get_mouse_position() - viewport_center
	var percent = (direction / viewport.size * 2.0).length()
	
	
	var camera_position = Vector2.ZERO;
	if percent < MAX_CAMERA_PERCENT:
		camera_position = player.global_position + direction.normalized() * MAX_CAMERA_DISTANCE * (percent / MAX_CAMERA_PERCENT)
	else:
		camera_position = player.global_position + direction.normalized() * MAX_CAMERA_DISTANCE
		camera.global_position = lerp(camera.global_position, camera_position, CAMERA_SPEED)

func move_process(delta):
	var vector = Vector2.ZERO;
	
	vector.x = Input.get_action_strength("d") - Input.get_action_strength("a")
	vector.y = Input.get_action_strength("s") - Input.get_action_strength("w")
	vector = vector.normalized();
	
	if vector != Vector2.ZERO:
		velocity = velocity.move_toward(vector * MAX_SPD, VEL * delta);
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICC * delta);
	
	if Input.is_action_just_pressed("LMB"):
		fire()
	
	move();
	

func move():
	velocity = move_and_slide(velocity)

func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed,0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)
	
