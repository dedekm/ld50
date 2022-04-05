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
var actionable : Node2D
var using: Node2D

onready var level := get_node("/root/Level")
onready var dialog_canvas := level.get_node("DialogCanvas")
onready var action_area := $ActionArea
onready var action_icon := level.get_node("ActionIcon")
onready var action_area_shape := $ActionArea/CollisionShape2D
onready var body_sprite := $BodySprite
onready var attack_sprite := $ActionArea/AttackSprite

func _ready():
  if !level.platformer:
    change_gamestyle()

func _process(delta):
  if movement_disabled:
    if using:
      if Input.is_action_just_pressed("action"):
        _stop_using()

    return

  if Input.is_action_just_pressed("action"):
    if !action_disabled:
      if platformer:
        action_disabled = true
        attack_sprite.visible = true
        body_sprite.play("attack")

        if actionable:
          actionable.queue_free()
          actionable = null

        yield(get_tree().create_timer(0.15), "timeout")

        attack_sprite.visible = false

        yield(get_tree().create_timer(0.20), "timeout")

        body_sprite.play("idle")
        action_disabled = false
      elif actionable:
        if actionable.is_in_group("characters"):
          _talk_to(actionable)
        elif actionable.is_in_group("things"):
          _use(actionable)

func _physics_process(delta):
  if movement_disabled:
    return

  if platformer and position.y > level.killzone:
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

  if body_sprite.animation != "attack":
    if velocity.x != 0 || velocity.y != 0:
      body_sprite_play_move()
    else:
      body_sprite_play_idle()

  if velocity.x > 0:
    body_sprite.flip_h = false
  elif velocity.x < 0:
    body_sprite.flip_h = true

func _talk_to(npc: Character):
  body_sprite_play_idle()
  action_icon.visible = false
  dialog_canvas.start_dialog(self, npc)

func _use(thing: Thing):
  thing.use(self)
  using = thing
  body_sprite.visible = false
  movement_disabled = true
  action_icon.visible = false

func _stop_using():
  using.use_stopped(self)
  using = null
  body_sprite.visible = true
  movement_disabled = false
  action_icon.visible = true

func start_monolog():
  body_sprite.play("idle")
  dialog_canvas.start_monolog(self, 1)

func stop_monolog():
  change_gamestyle()
  movement_disabled = false

func change_gamestyle():
  platformer = !platformer

  body_sprite_play_idle()

  if !platformer:
    if level.camera:
      level.camera.limit_bottom = level.four_way_camera_limit_bottom
    action_area_shape.shape.extents = Vector2(SIZE * 0.75, SIZE)
    action_area.position.x = SIZE * 0.75
  else:
    if level.camera:
      level.camera.limit_bottom = level.platformer_camera_limit_bottom
    action_area_shape.shape.extents = Vector2(SIZE / 2, SIZE / 2)
    action_area.position.x = SIZE

func die():
  if platformer:
    alive = false
    body_sprite.modulate = Color("a45a5a")
    $CollisionShape2D.set_deferred("disabled", true)

func body_sprite_play_idle():
  if platformer:
    body_sprite.play("idle")
  else:
    body_sprite.play("idle_without")

func body_sprite_play_move():
  if platformer:
    body_sprite.play("move")
  else:
    body_sprite.play("move_without")

func _on_ActionArea_area_entered(area):
  actionable = area.get_parent()

  if !actionable.is_in_group("characters") and !actionable.is_in_group("things"):
    actionable = null
    return

  if !platformer:
    action_icon.position = actionable.position

    if "moving" in actionable:
      actionable.stop()

    if "height" in actionable:
      action_icon.position.y -= int(actionable.height * 2)
    else:
      action_icon.position.y -= 24

    action_icon.visible = true

func _on_ActionArea_area_exited(area):
  if !actionable or !actionable.is_in_group("characters") and !actionable.is_in_group("things"):
    return

  if !platformer:
    action_icon.visible = false

    if "moving" in actionable:
      actionable.move()

  actionable = null
