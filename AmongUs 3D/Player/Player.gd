extends CharacterBody3D

@export var velocidad_movimiento: float = 5.0
@export var sensibilidad_raton: float = 0.002
var gravity : float = 15.0 

var anim_idle: String = "Idle"
var anim_walk: String = "Esqueleto_acción"

var vel = Vector3()

@onready var animador: AnimationPlayer = $AnimationPlayer
var mouse_relativo: Vector2 = Vector2.ZERO

func _ready() -> void:

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if animador:
		animador.play(anim_idle)


func _input(event):
	if event is InputEventMouseMotion:
		mouse_relativo = event.relative

	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	vel.x = 0
	vel.z = 0
	
	var input = Vector3()

	if Input.is_action_pressed("CaminarHaciaAdelante"): input.z += 1
	if Input.is_action_pressed("CaminarHaciaAtras"): input.z -= 1
	if Input.is_action_pressed("CaminarHaciaIzquierda"): input.x += 1
	if Input.is_action_pressed("CaminarHaciaDerecha"): input.x -= 1
	
	input = input.normalized()
	
	var dir = (transform.basis.z * input.z + transform.basis.x * input.x)
	
	vel.x = dir.x * velocidad_movimiento
	vel.z = dir.z * velocidad_movimiento
	
	if animador:
		if dir.length_squared() > 0.01:
			if animador.current_animation == anim_idle:
				animador.stop()

			if animador.current_animation != anim_walk:
				animador.play(anim_walk)
				
		else: 
			if animador.current_animation == anim_walk:
				animador.stop()

			if animador.current_animation != anim_idle:
				animador.play(anim_idle)
	
	
	vel.y -= gravity * delta
	
	set_velocity(vel)
	set_up_direction(Vector3.UP)
	move_and_slide()
	vel = velocity
