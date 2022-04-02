extends KinematicBody2D

const GRAVITY = 800
const SPEED = 200
const JUMP = 300

var velocity := Vector2()
var alive := true
var movement_disabled := false
var action_disabled := false

onready var level := get_node("/root/Level")
onready var dialog_canvas := level.get_node("DialogCanvas")
onready var action_area := $ActionArea

func _ready():
  pass

func _process(delta):
  if movement_disabled:
    return

  if Input.is_action_just_pressed("action"):
    if !action_disabled:
      action_disabled = true
      action_area.get_node("CollisionShape2D").set_deferred("disabled", false)
      yield(get_tree().create_timer(0.3), "timeout")
      action_disabled = false
      action_area.get_node("CollisionShape2D").set_deferred("disabled", true)

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

func _talk_to(npc):
  movement_disabled = true
  npc.speed = 0

  dialog_canvas.start_dialog(self, npc, "test")

func die():
  if level.platformer:
    alive = false
    $CollisionShape2D.set_deferred("disabled", true)

func _on_ActionArea_area_entered(area):
  if level.platformer:
    area.queue_free()
  else:
    _talk_to(area)
