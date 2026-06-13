extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GROUND_ACCEL = 10.0
const GROUND_FRICTION = 10.0
const AIR_ACCEL = 0.5
const AIR_FRICTION = 0.01
var sliding = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_pressed("slide"):
		sliding = true
	else:
		sliding = false

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("jump") and is_on_wall() and not is_on_floor():
		var wall_normal = get_wall_normal()
		velocity.x = wall_normal.x * SPEED
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("move_left", "move_right")

	if sliding:
		direction = 0

	if is_on_floor():
		if not sliding:
			velocity.x -= GROUND_FRICTION * velocity.x * delta
		velocity.x += GROUND_ACCEL * direction * SPEED * delta
	else:
		if not sliding:
			velocity.x -= AIR_FRICTION * velocity.x * delta
		velocity.x += AIR_ACCEL * direction * SPEED * delta

	move_and_slide()

func _draw():
	draw_line(Vector2.ZERO, velocity * 0.1, Color.GREEN, 2.0)

func _process(delta: float):
	queue_redraw()
