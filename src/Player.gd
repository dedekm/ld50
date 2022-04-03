extends KinematicBody2D

const GRAVITY = 800
const SPEED = 200
const JUMP = 300
const SIZE = 24

var platformer := true
var velocity := Vector2()
var alive := true
var movement_disabled := false
var action_disabled := false

onready var level := get_node("/root/Level")
onready var dialog_canvas := level.get_node("DialogCanvas")
onready var action_area := $ActionArea
onready var action_area_shape : CollisionShape2D = action_area.get_node("CollisionShape2D")
onready var sprite := $AnimatedSprite

func _ready():
  if !level.platformer:
    change_gamestyle()

func _process(delta):
  if movement_disabled:
    return

  if Input.is_action_just_pressed("action"):
    if !action_disabled:
      action_disabled = true
      action_area_shape.set_deferred("disabled", false)
      yield(get_tree().create_timer(0.3), "timeout")
      action_disabled = false
      action_area_shape.set_deferred("disabled", true)

func _physics_process(delta):
  if movement_disabled:
    return

  if position.y > get_viewport().size.y + 100:
    get_tree().reload_current_scene()

  velocity.x = 0

  if alive:
    if Input.is_action_pressed("ui_left"):
      velocity.x -= 1
    if Input.is_action_pressed("ui_right"):
      velocity.x += 1

    if velocity.x != 0:
      if platformer:
        action_area.position.x = SIZE * velocity.x
      else:
        action_area.position.x = SIZE * 0.75 * velocity.x

  if platformer:
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

  if velocity.x != 0 || velocity.y != 0:
    sprite.play("move")
  else:
    sprite.play("idle")

  if velocity.x > 0:
    sprite.flip_h = false
  elif velocity.x < 0:
    sprite.flip_h = true

func _talk_to(npc):
  movement_disabled = true
  npc.speed = 0

  dialog_canvas.start_dialog(self, npc, "test")

func change_gamestyle():
  platformer = !platformer

  if !platformer:
    action_area_shape.shape.extents = Vector2(SIZE * 0.75, SIZE)
    action_area.position.x = SIZE * 0.75
  else:
    action_area_shape.shape.extents = Vector2(SIZE / 2, SIZE / 2)
    action_area.position.x = SIZE

func die():
  if platformer:
    alive = false
    $CollisionShape2D.set_deferred("disabled", true)

func _on_ActionArea_area_entered(area):
  if platformer:
    area.get_parent().queue_free()
  else:
    _talk_to(area.get_parent())
