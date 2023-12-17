extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -500.0
const LIFE = 100
const BRIGHTNESS_LOW = 0.25
const BRIGHTNESS_NORMAL = 1
const BRIGHTNESS_HIGH = 2.25
const BURNING_FACTOR_LOW = 0.25
const BURNING_FACTOR_NORMAL = 1
const BURNING_FACTOR_HIGH = 5
const LIGHT_SPEED = 4

const SCALE_NORMAL = 1
const SCALE_MINI = 0.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_scale = SCALE_NORMAL

var current_life = LIFE
var burning_factor = 1
var brightness = BRIGHTNESS_NORMAL
var is_burning = false
var is_hiding = false
var current_tile = null
var is_in_cp = false

#ghost

var ghostArray : Array[Area2D] = []



@onready var point_light : PointLight2D = $PointLight2D
@onready var point_light_burn : PointLight2D = $PointLightBurn
@onready var sprite = $Sprite2D
@onready var light_area : Area2D = $LightArea



func _ready():
	GameManager.player = self

func _process(delta):
	if current_life <= 0:
		death()

func _physics_process(delta):

	#scale
#	current_scale = current_life/200 + 0.5
#	if scale > Vector2(current_scale,current_scale):
#		scale -= Vector2(delta, delta)
#	if scale < Vector2(current_scale,current_scale):
#		scale += Vector2(delta, delta)
		

	current_tile = GameManager.get_tile_info(position + Vector2(25,0))
	if GameManager.is_tile_water(current_tile):
		GameManager.playSfx(GameManager.sfxWater)
		current_life = 0

	GameManager.sendLifeToUI(current_life)

	if !is_in_cp:
		current_life -= 1 * burning_factor * delta
	
	point_light.texture_scale = brightness
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_released("jump"):
		if velocity.y < -100:
			velocity.y = -100
		
	#Burn
	if Input.is_action_just_pressed("burn") :
		hide_release()
		burning_factor = BURNING_FACTOR_HIGH
		is_burning = true 
		point_light_burn.enabled = true

	
	if Input.is_action_just_released("burn"):
		burn_release()
	
	if Input.is_action_just_pressed("hide"):
		burn_release()
		burning_factor = BURNING_FACTOR_LOW
		is_hiding = true 

	
	if Input.is_action_just_released("hide") :
		hide_release()
	
	if is_burning && brightness < BRIGHTNESS_HIGH:
		brightness += delta * LIGHT_SPEED
		
	if !is_burning && !is_hiding && brightness > BRIGHTNESS_NORMAL:
		brightness -= delta * LIGHT_SPEED
		
	if is_hiding && brightness > BRIGHTNESS_LOW:
		brightness -= delta * LIGHT_SPEED
		
	if !is_hiding && !is_burning && brightness < BRIGHTNESS_NORMAL:
		brightness += delta * LIGHT_SPEED
		
	checkGhost()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")

	if direction:
		velocity.x = direction * SPEED
		if direction == 1:
			sprite.flip_h = false
		if direction == -1:
			sprite.flip_h = true
		#GameManager.playSfx(GameManager.sfxWalk)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func death():
	GameManager.respawn()
	current_life = LIFE


func _on_light_area_area_entered(area):
	if area.is_in_group("GhostLight") or area.is_in_group("GhostDark"):
		ghostArray.append(area)


func _on_light_area_area_exited(area):
	if area.is_in_group("GhostLight") or area.is_in_group("GhostDark"):
		ghostArray.erase(area)

func checkGhost():
	for ghost in ghostArray:
		if(ghost != null):
			if ghost.is_in_group("GhostLight"):
				if is_burning:
					ghost.stop_moving()
				if !is_burning:
					ghost.start_moving()
			if ghost.is_in_group("GhostDark"):
				if is_hiding:
					ghost.stop_moving()
				else:
					ghost.start_moving()


func burn_release():
	if !is_hiding:
		burning_factor = BURNING_FACTOR_NORMAL
	point_light_burn.enabled = false
	is_burning = false

func hide_release():
	if !is_burning:
		burning_factor = BURNING_FACTOR_NORMAL
	is_hiding = false
