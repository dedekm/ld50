extends KinematicBody2D

const GRAVITY = 800
const SPEED = 200
const JUMP = 300

var velocity := Vector2()

onready var level := get_node("/root/Level")

func _ready():
  pass

func _physics_process(delta):
  velocity.x = 0

  if Input.is_action_pressed("ui_left"):
    velocity.x -= 1
  if Input.is_action_pressed("ui_right"):
    velocity.x += 1

  if level.platformer:
    velocity.x *= SPEED
    velocity.y += GRAVITY * delta

    if Input.is_action_pressed("ui_up") and is_on_floor():
      velocity.y -= JUMP
  else:
    velocity.y = 0

    if Input.is_action_pressed("ui_up"):
      velocity.y -= 1
    if Input.is_action_pressed("ui_down"):
      velocity.y += 1

    velocity = velocity.normalized() * SPEED
  velocity = move_and_slide(velocity, Vector2.UP)
