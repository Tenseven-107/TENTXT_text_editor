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

# Constants
const WINDOW_TITLE_PREFIX: String = "TENTXT, simple text editor // Editing: "

# Tabs
export (Array, String) var open_tab_paths: Array = []




# Set up
func _ready():
	# Set up signals
	file_button.connect("pressed", self, "open_file_dialog")

	file_dialog.connect("file_selected", self, "load_file")

	tabs.connect("tab_close", self, "close_tab")
	tabs.connect("tab_clicked", self, "open_tab")



# Open file dialog for user to select a file to open/ save/ create
func open_file_dialog():
	file_dialog.show()
	file_dialog.invalidate() #TODO: Add switch case for different actions like openning and saving

# -- Open the file
func load_file(path: String, open_new_tab: bool = true):
	text_editor.load_file(path)

	# Set window title
	OS.set_window_title(WINDOW_TITLE_PREFIX + path)

	# Open a new tab for file
	if open_new_tab == true: 
		var split_path: PoolStringArray = path.split("/", false)
		var file_name: String = split_path[split_path.size() - 1]

		create_tab(file_name, path)

		return



# Tab control
# - Create tab
func create_tab(file_name: String, path: String):
	# Create and select new tab
	tabs.add_tab(file_name)
	var current_tabs_open: int = tabs.get_tab_count()

	tabs.current_tab = current_tabs_open - 1

	# Save to current open tabs
	open_tab_paths.append(path)


# - Open created tab
func open_tab(tab_idx: int):
	for path in open_tab_paths:
		var split_path: PoolStringArray = path.split("/", false)
		var file_name: String = split_path[split_path.size() - 1]

		if tabs.get_tab_title(tab_idx) == file_name:
			load_file(path, false)

			break


# - Close tab
func close_tab(tab_idx: int):
	# TODO: Add a saving popup asking if you want to save this file

	var current_tab: int = tabs.current_tab

	# Remove tab
	tabs.remove_tab(tab_idx)

	# Clear all text if current opened file is closed
	if tab_idx == current_tab:
		if tab_idx == 0:
			text_editor.wipe()

		else:
			open_tab(current_tab - 1)






































