extends KinematicBody2D

const GRAVITY = 800
const SPEED = 200
const JUMP = 300

var velocity := Vector2()
var alive := true

onready var level := get_node("/root/Level")

func _ready():
  pass

func _physics_process(delta):
  if !alive && position.y > get_viewport().size.y + 100:
    get_tree().reload_current_scene()

  velocity.x = 0

  if alive:
    if Input.is_action_pressed("ui_left"):
      velocity.x -= 1
    if Input.is_action_pressed("ui_right"):
      velocity.x += 1

  if level.platformer:
    velocity.x *= SPEED
    velocity.y += GRAVITY * delta

    if Input.is_action_pressed("ui_up") and is_on_floor() and alive:
      velocity.y -= JUMP
  else:
    velocity.y = 0

    if alive:
      if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
      if Input.is_action_pressed("ui_down"):
        velocity.y += 1

    velocity = velocity.normalized() * SPEED

  velocity = move_and_slide(velocity, Vector2.UP)

func die():
  alive = false
  $CollisionShape2D.set_deferred("disabled", true)
