extends Area2D

var is_lit = false
var is_in_cp = false
const LIGHT_SPEED = 2
const TEXTURE_SCALE_MAX = 3
const RED_LIGHT_TEXTURE_SCALE_MAX = 0.70
@onready var light : PointLight2D = $PointLight2D
@onready var lightred : PointLight2D = $PointLightRed
@onready var light_area : Area2D = $Light_area
@onready var sprite : Sprite2D = $Sprite2D
@onready var particles = $Particles

var ghostArray : Array[Area2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	light.texture_scale = 0
	lightred.texture_scale = 0
	particles.visible = false

func _physics_process(delta):
	if is_lit && light.texture_scale < TEXTURE_SCALE_MAX:
		light.texture_scale += delta * LIGHT_SPEED
	if is_lit && lightred.texture_scale < RED_LIGHT_TEXTURE_SCALE_MAX:
		lightred.texture_scale += delta
	checkGhost()

func lit_lamp():
	if !is_lit:
		GameManager.playSfx(GameManager.sfxLamp)
		if !self.get_parent().is_in_group("CheckPoint"):
			particles.visible = true
		is_lit = true


func _on_light_area_area_entered(area):
	if area.is_in_group("GhostLight") or area.is_in_group("GhostDark"):
		ghostArray.append(area)


func _on_light_area_area_exited(area):
	if area.is_in_group("GhostLight") or area.is_in_group("GhostDark"):
		area.start_moving()
		ghostArray.erase(area)

func checkGhost():
	for ghost in ghostArray:
		if(ghost != null):
			if ghost.is_in_group("GhostLight"):
					ghost.stop_moving()
			if ghost.is_in_group("GhostDark"):
					ghost.start_moving_to_lamp()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		lit_lamp() # Replace with function body.

func get_global_pos():
	return to_global(position)
