extends CanvasLayer

const FILE_NAME = "res://data/dialogs.json"

var active := false
var player : Node
var npc : Node
var player_talking := false
var dialog := []
var dialog_index := 0
var data : Dictionary

onready var player_text : RichTextLabel = $PlayerText
onready var npc_text : RichTextLabel = $NPCText

func _ready():
  var file = File.new()
  print(FILE_NAME)
  if file.file_exists(FILE_NAME):
    file.open(FILE_NAME, File.READ)
    var text = file.get_as_text()
    data = parse_json(text)
    file.close()

func start_dialog(actor_one: Node, actor_two: Node, dialog_key: String):
  active = true
  player = actor_one
  npc = actor_two

  dialog = data[dialog_key]
  dialog_index = 0

  _set_text_position(player, player_text)
  _set_text_position(npc, npc_text)
  next_dialog_step()

func _process(delta):
  if !active:
    return

  if Input.is_action_just_pressed("action"):
    next_dialog_step()

func next_dialog_step():
  player_text.visible = false
  npc_text.visible = false

  if dialog.size() == dialog_index:
    stop_dialog()
    return

  if player_talking:
    npc_text.visible = true
    npc_text.bbcode_text = "[center]" + dialog[dialog_index] + "[/center]"
  else:
    player_text.visible = true
    player_text.bbcode_text = "[center]" + dialog[dialog_index] + "[/center]"

  dialog_index += 1
  player_talking = !player_talking

func stop_dialog():
  player.movement_disabled = false
  active = false

func _set_text_position(actor: Node, text: RichTextLabel):
  text.rect_position = Vector2(actor.position.x - text.rect_size.x / 2, actor.position.y - 48)
