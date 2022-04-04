extends Person

class_name Enemy

export var speed := 100
export var move_distance := 200

var direction := Vector2(1, 0)
var moving := true
var start : Vector2
var target : Vector2

func _ready():
  if direction.x:
    direction.x *= pow(-1, randi() % 2)
  if direction.y:
    direction.y *= pow(-1, randi() % 2)

  var distance_to_target := direction * move_distance
  start = position - distance_to_target
  target = position + distance_to_target

func _physics_process (delta):
  if !moving || speed == 0:
    return

  position.x = _move_to(position.x, target.x, speed * delta)

  if position.x == target.x:
    if target.x == start.x:
      target.x = position.x + move_distance * 2 * direction.x
    else:
      target.x = start.x

func _move_to(current, to, step):
  var new = current

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
