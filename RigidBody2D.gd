extends RigidBody2D

var vector = Vector2.ZERO;

func _physics_process(delta):
	
	vector.x = Input.get_action_strength("d") - Input.get_action_strength("a");
	vector.y = Input.get_action_strength("s") - Input.get_action_strength("w");
	
	vector = vector.normalized() * 20;
	
	if vector.length() > 0:
		add_force(Vector2.ZERO, vector * delta);
