extends Node


# Objects
export (NodePath) var file_dialog_path: NodePath
onready var file_dialog: FileDialog = get_node(file_dialog_path)

export (NodePath) var text_editor_path: NodePath
onready var text_editor: TextEditor = get_node(text_editor_path)

export (NodePath) var editor_bar_path: NodePath
onready var editor_bar: EditorBar = get_node(editor_bar_path)


# Input
func _unhandled_input(event: InputEvent):
	if event.is_pressed():
		saving(event)
		loading(event)
		#new_file()

		#editing()
		#configuring()

		menu(event)
		tabs(event)



# - Save/ load/ new
func saving(event: InputEvent):
	if event.is_action_pressed("files_save"): editor_bar.save_file()
	if event.is_action_pressed("files_save_as"): editor_bar.save_file_as()
	#if event.is_action_pressed("files_save_all"): editor_bar.save_files_all()

func loading(event: InputEvent):
	if event.is_action_pressed("files_load"): file_dialog.load_file()



# - Menu and UI
func menu(event):
	if event.is_action_pressed("ui_cancel"):
		text_editor.grab_focus()

		# Close menus
		if file_dialog.is_visible() == true: 
			file_dialog.hide()
			return

func tabs(event):
	if event.is_action_pressed("tabs_close"): editor_bar.close_tab(0, true)
	if event.is_action_pressed("tabs_close_all"): editor_bar.close_all_tabs()







