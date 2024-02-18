extends RigidBody3D
 
@onready var rays = get_tree().get_nodes_in_group("Raycasts")

var speed = 20000
var turn_speed = 2500
var reverse_speed = 10000
var hover_force = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				hover_force += 20
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				hover_force -= 20
			hover_force = clamp(hover_force, 0, 2200)
	
func _physics_process(delta):
	#loop thru the rays
	for ray in rays:
		ray.force_raycast_update()
		if ray.is_colliding():
			var collision_point = ray.get_collision_point()
			
			#calculate dist between floor and ray
			var dist = collision_point.distance_to(ray.global_transform.origin)
			
			#apply force based on dist
			apply_force(Vector3.UP * (1/dist) * hover_force * delta, ray.global_transform.origin - global_transform.origin)
			
	#apply force to move
	if Input.is_action_pressed("forward"):
		apply_central_force(global_transform.basis.x * speed * delta)
	if Input.is_action_pressed("back"):
		apply_central_force(-global_transform.basis.x * speed * delta)
	if Input.is_action_pressed("right"):
		apply_torque(-global_transform.basis.y * turn_speed * delta)
	if Input.is_action_pressed("left"):
		apply_torque(global_transform.basis.y * turn_speed * delta)

