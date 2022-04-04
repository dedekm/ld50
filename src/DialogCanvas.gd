extends CanvasLayer

const FILE_NAME = "res://data/dialogs.json"

var active := false
var player : Node
var npc : Node
var player_talking := false
var dialog := []
var dialog_index := 0
var data : Dictionary

onready var player_text_rect : NinePatchRect = $PlayerTextRect
onready var player_text : RichTextLabel = player_text_rect.get_node("RichTextLabel")
onready var player_portrait : Sprite = player_text_rect.get_node("Portrait")

onready var npc_text_rect : NinePatchRect = $NPCTextRect
onready var npc_text: RichTextLabel = npc_text_rect.get_node("RichTextLabel")
onready var npc_portrait : Sprite = npc_text_rect.get_node("Portrait")

func _ready():
  player_text_rect.visible = false
  npc_text_rect.visible = false

  player_portrait.set_texture(load("res://assets/portraits/portrait.png"))

  var file = File.new()
  if file.file_exists(FILE_NAME):
    file.open(FILE_NAME, File.READ)
    var text = file.get_as_text()
    data = parse_json(text)
    file.close()

func start_dialog(actor_one: Node, actor_two: Node, dialog_key: String):
  active = true
  player = actor_one
  npc = actor_two

  player.movement_disabled = true
  npc.stop()

  dialog = data[dialog_key]
  dialog_index = 0

  _set_text_position(player, player_text_rect)
  _set_text_position(npc, npc_text_rect)
  npc_portrait.set_texture(npc.portrait)

  next_dialog_step()

func _process(delta):
  if !active:
    return

  if Input.is_action_just_pressed("action"):
    next_dialog_step()

func next_dialog_step():
  player_text_rect.visible = false
  npc_text_rect.visible = false

  if dialog.size() == dialog_index:
    stop_dialog()
    return

  if player_talking:
    npc_text_rect.visible = true
    npc_text.bbcode_text = "[center]" + dialog[dialog_index] + "[/center]"
  else:
    player_text_rect.visible = true
    player_text.bbcode_text = "[center]" + dialog[dialog_index] + "[/center]"

  dialog_index += 1
  player_talking = !player_talking

func stop_dialog():
  yield(get_tree().create_timer(0.25), "timeout")
  player.movement_disabled = false
  npc.move()
  active = false

func _set_text_position(actor: Node2D, rect: Control):
  var position := actor.get_global_transform_with_canvas().origin
  rect.rect_position = Vector2(position.x - rect.rect_size.x / 2, position.y - rect.rect_size.y * 2)
