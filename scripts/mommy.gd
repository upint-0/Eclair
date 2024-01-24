extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var model
var target_lookat : Vector3

func _ready():
	model = get_node("Body")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var cameraForward = Global.camera.get_global_transform().basis.z
	direction = direction.rotated(Vector3.UP, atan2(cameraForward.x, cameraForward.z))
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		model.global_rotation.y = lerp_angle(model.global_rotation.y, atan2(direction.x, direction.z), delta * 10.0) 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
