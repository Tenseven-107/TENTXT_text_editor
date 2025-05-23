extends FileDialog


# Signal
signal has_saved


# Options
export (bool) var click_off_save: bool = false


# Variables
var editor_bar
var editor
var save_text: String



# Set up
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			if click_off_save == true: save_file(editor_bar.current_path, editor.text)



# Open file dialog for user to select a file to open/ save/ create
func open_file_dialog(option: int = FileDialog.MODE_OPEN_FILE):
	show()
	invalidate()
	get_line_edit().grab_focus()

	if self.is_connected("file_selected", self, "save") == true:
		self.disconnect("file_selected", self, "save")

	mode = option # Uses the "Mode" option of the base FileDialog class



# Save file with given path
func save_file(saving_path: String, text: String, save_as: bool = false):
	if saving_path == "": return
	save_text = text

	# Check if file even exists, if so, just save it
	var file = File.new()
	var file_exists = file.file_exists(saving_path)
	file.close()

	if file_exists == true and save_as == false:
		save(saving_path)
		return

	# Otherwise we use the menu to save
	open_file_dialog(FileDialog.MODE_SAVE_FILE)
	self.connect("file_selected", self, "save")

	current_path = saving_path

# Save
func save(path: String):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(save_text)

	file.close()
	emit_signal("has_saved")



# Load file
func load_file():
	open_file_dialog(FileDialog.MODE_OPEN_FILE)



# Initialize references
func initialize(new_bar, new_editor):
	self.editor_bar = new_bar
	self.editor = new_editor



