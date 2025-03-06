extends Control
class_name EditorBar


# Objects
onready var file_button: TextureButton = $HBoxContainer/Options/HBoxContainer/OpenFile
onready var options_button: TextureButton = $HBoxContainer/Options/HBoxContainer/Options

export (NodePath) var file_dialog_path: NodePath
onready var file_dialog: FileDialog = get_node(file_dialog_path)

export (NodePath) var text_editor_path: NodePath
onready var text_editor: TextEditor = get_node(text_editor_path)

onready var tabs: Tabs = $HBoxContainer/Tabs



# Set up
func _ready():
	tabs.add_tab("TEST.gd")
	tabs.add_tab("TEST2.gd")
	tabs.add_tab("TEST3.gd")
	
	# Set up signals
	file_button.connect("pressed", self, "open_file_dialog")

	file_dialog.connect("file_selected", self, "load_file")

	tabs.connect("tab_close", self, "close_tab")



# Open file dialog for user to select a file to open
func open_file_dialog():
	file_dialog.show()
	file_dialog.invalidate()

# -- Open the file
func load_file(path: String):
	text_editor.load_file(path)



# Tab control
# - Close tab
func close_tab(tab_idx: int):
	# TODO: Add a saving popup asking if you want to save this file

	tabs.remove_tab(tab_idx)

































