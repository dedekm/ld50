extends Person

class_name Enemy

export var speed := 100
export var move_distance := 200
onready var start_x := position.x
onready var target_x := position.x + move_distance

func _physics_process (delta):
  position.x = move_to(position.x, target_x, speed * delta)

  if position.x == target_x:
    if target_x == start_x:
      target_x = position.x + move_distance
    else:
      target_x = start_x

func move_to(current, to, step):
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

func _on_Hitbox_body_entered(body):
  if body.name == "Player":
    body.die()
