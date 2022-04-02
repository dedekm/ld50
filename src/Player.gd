extends KinematicBody2D

var speed := 200
var jump_force := 200
var gravity := 800
var velocity := Vector2()
var grounded := false

func _ready():
  pass

func _physics_process(delta):
  velocity.x = 0

  if Input.is_action_pressed("ui_left"):
    velocity.x -= speed
  if Input.is_action_pressed("ui_right"):
    velocity.x += speed
    
  velocity = move_and_slide(velocity, Vector2.UP)

  velocity.y += gravity * delta

  if Input.is_action_pressed("ui_up") and is_on_floor():
    velocity.y -= jump_force
