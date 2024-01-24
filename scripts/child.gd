extends CharacterBody3D


const MAX_SPEED = 4.0
const ACCEL = 2.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var speed = 0.0
var use_navmesh = false
var follow = false

var target

@onready var nav: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta):

	if not follow:
		return

	var direction = Vector3()
	
	speed = lerp(speed, MAX_SPEED, delta * ACCEL)
	
	direction = target.global_position - global_position
	if direction.length() < 1:
		direction = Vector3.ZERO
	direction = direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()
	
	if use_navmesh:
		nav.target_position = Global.player.global_position
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = direction * speed
		
		var closestPoint = NavigationServer3D.map_get_closest_point(nav.get_navigation_map(), position)
		
		if not nav.is_navigation_finished():
			move_and_slide()
			if (closestPoint - position).length() > 0.2:
				print((closestPoint - position).length())
				position = closestPoint
		else:
			speed = 0.0


func _on_area_3d_body_entered(body):
	if follow:
		return
	
	if body == Global.player:
		if Global.children.size() == 0:
			target = body
		else:
			target = Global.children[-1]
		Global.children.append(self)
		follow = true
		print(str(self) + "follow" + str(target))
