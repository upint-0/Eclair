extends SpringArm3D

var player

const y_offset = 1.5

var vel_offset = Vector3.ZERO

func _ready():
	Global.camera = get_child(0)
	
	player = Global.player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	vel_offset = lerp(vel_offset, player.velocity.normalized() * 2.0, delta * 1.0)
	var targetPos = player.position - Vector3.DOWN * y_offset + vel_offset
	position = lerp(position, targetPos, delta * 10.0)
