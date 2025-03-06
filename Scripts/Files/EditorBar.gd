extends Control
class_name EditorBar


# Objects
onready var file_button: TextureButton = $HBoxContainer/Options/HBoxContainer/OpenFile
onready var options_button: TextureButton = $HBoxContainer/Options/HBoxContainer/Options

export (NodePath) var file_dialog_path: NodePath
onready var file_dialog: FileDialog = get_node(file_dialog_path)

export (NodePath) var text_editor_path: NodePath
var text_editor: TextEditor 

onready var tabs: Tabs = $HBoxContainer/Tabs

# Constants
const WINDOW_TITLE_PREFIX: String = "TENTXT, simple text editor // Editing: "
const TEXT_PATH_PREFIX: String = "*PATH*"

# Tabs
var current_path: String
var open_tab_paths: Array
var tab_texts: Array

# - Set in memory text to new text from editor
func change_current_text():
	var text_idx: int = 0
	for text in tab_texts:
		var split_text: PoolStringArray = text.split(TEXT_PATH_PREFIX, false, 1)

		if split_text[0] == current_path:
			var new_text = text_editor.text.insert(0, current_path+TEXT_PATH_PREFIX)
			tab_texts[text_idx] = new_text

			return

		text_idx += 1




# Set up
func _ready():
	# Set up signals
	file_button.connect("pressed", self, "open_file_dialog")

	file_dialog.connect("file_selected", self, "load_file")

	tabs.connect("tab_close", self, "close_tab")
	tabs.connect("tab_clicked", self, "open_tab")

	# - Set up text editor
	text_editor = get_node(text_editor_path)
	text_editor.connect("text_changed", self, "change_current_text")



# Open file dialog for user to select a file to open/ save/ create
func open_file_dialog():
	file_dialog.show()
	file_dialog.invalidate() #TODO: Add switch case for different actions like openning and saving

# -- Open the file
func load_file(path: String, plain_text: String = "", open_new_tab: bool = true):
	text_editor.load_file(path, plain_text)

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
	current_path = path

	# Create and select new tab
	tabs.add_tab(file_name)
	var current_tabs_open: int = tabs.get_tab_count()

	tabs.current_tab = current_tabs_open - 1

	# Save to current open tabs
	open_tab_paths.append(path)

	# Add file text of tab to array of held tabs
	var file = File.new()
	file.open(path, File.READ)

	var new_text: String = file.get_as_text().insert(0, path+TEXT_PATH_PREFIX)
	file.close()

	tab_texts.append(new_text)


# - Open created tab
func open_tab(tab_idx: int):
	for path in open_tab_paths:
		var split_path: PoolStringArray = path.split("/", false)
		var file_name: String = split_path[split_path.size() - 1]

		if tabs.get_tab_title(tab_idx) == file_name:
			# Get file text
			var used_text: String = ""
			for text in tab_texts:
				var split_text: PoolStringArray = text.split(TEXT_PATH_PREFIX, false, 1)

				if split_text[0] == path:
					used_text =  split_text[1]
					break

			# Load text
			current_path = path

			load_file(path, used_text, false)

			break


# - Close tab
func close_tab(tab_idx: int):
	# TODO: Add a saving popup asking if you want to save this file

	var current_tab: int = tabs.current_tab

	# Remove path from opened filepaths
	var path_idx: int = 0
	for path in open_tab_paths:
		var split_path: PoolStringArray = path.split("/", false)
		var file_name: String = split_path[split_path.size() - 1]

		if tabs.get_tab_title(tab_idx) == file_name:
			open_tab_paths.remove(path_idx)

			# Remove tab text
			var text_idx: int = 0
			for text in tab_texts:
				var split_text: PoolStringArray = text.split(TEXT_PATH_PREFIX, false, 1)

				if split_text[0] == path:
					tab_texts.remove(text_idx)
					break

				text_idx += 1

			break

		path_idx += 1

	# Remove tab
	tabs.remove_tab(tab_idx)

	# Clear all text if current opened file is closed
	if tab_idx == current_tab:
		if tab_idx == 0:
			if tabs.get_tab_count() >= 1:
				open_tab(0)
				return

			text_editor.wipe()

		else:
			open_tab(current_tab - 1)






































