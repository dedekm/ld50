extends Person

class_name Enemy

export var speed := 100
export var move_distance := 200
export var direction := Vector2(1, 0)

var moving := true
var start : Vector2
var target : Vector2

func _ready():
  var distance_to_target := direction * move_distance
  start = position
  target = position + distance_to_target

func _physics_process (delta):
  if !moving || speed == 0:
    return

  position = _move_to(position, target, speed * delta)

  if position == target:
    if target == start:
      target = position + move_distance * direction
    else:
      target = start

func _move_to(current: Vector2, to: Vector2, step_distance: float):
  var new := current
  var step := Vector2(step_distance * direction.x, step_distance * direction.y)

  if new < to:
    new += step
    if new > to:
      new = to
  else:
    new -= step
    if new < to:
      new = to

  return new

func stop():
  moving = false
  if has_node("AnimatedSprite"):
    $AnimatedSprite.play("idle")

func move():
  moving = true
  if has_node("AnimatedSprite"):
    $AnimatedSprite.play("move")

func _on_Hitbox_body_entered(body):
  if body.name == "Player":
    body.die()
