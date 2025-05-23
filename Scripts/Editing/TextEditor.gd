extends TextEdit
class_name TextEditor


# Settings
export (bool) var set_default_text: bool = true

# CONTSANTS
const READ_UPDATE_TIME: float = 0.5

# Default
var default_text: String

# Current syntax auto prefixes
var current_book_mark_prefixes: Array = []

# Objects
export (NodePath) var syntax_manager_path: NodePath
var syntax_manager: SyntaxChanger



# Set up
func _ready():
	# Base setup
	default_text = text
	if set_default_text == false: text = ""

	grab_focus()

	# Colors
	set_editor_colors()

	# Set up signals
	syntax_manager = get_node(syntax_manager_path)
	syntax_manager.connect("new_syntax_set", self, "set_syntax")

	# Base TIMED set up
	yield(get_tree().create_timer(READ_UPDATE_TIME), "timeout")

	check_text()

	# Set up more signals
	connect("text_changed", self, "check_text")


# - Colors
# -- Set editor colors
func set_editor_colors():
	var style_box: StyleBox = get_stylebox("normal", theme_type_variation)
	var bg_color: Color = style_box.bg_color

	VisualServer.set_default_clear_color(Color(bg_color.r, bg_color.g, bg_color.b))



# File management
# - Openning a file
func load_file(path: String, plain_text: String = ""):
	# Load new syntax
	syntax_manager.load_syntax_based_on_path(path)
	check_text()
	grab_focus()

	# Loaded text from memory if given
	if plain_text != "":
		text = plain_text
		clear_undo_history()

		return

	# Otherwise, load new file with text
	var file: File = File.new()
	if file.file_exists(path) == false: return

	file.open(path, File.READ)

	text = file.get_as_text()
	clear_undo_history()

	file.close()



# Syntax control
func set_syntax(used_syntax: EditorLanguageSupport):
	if used_syntax == null: return

	current_book_mark_prefixes = used_syntax.bookmark_prefixes


# Editing
# - Clear text
func wipe():
	if set_default_text == true: text = default_text

	syntax_manager.reset_syntax()
	check_text()


# - Checking text when text is updated
func check_text():
	check_for_editor_prefixes()


# - Check if a new editor prefix is added
func check_for_editor_prefixes():
	# Wait a couple frames
	yield(get_tree().create_timer(READ_UPDATE_TIME), "timeout")

	# Bookmarks
	for prefix in current_book_mark_prefixes: # OPTIMIZE LATER
		for line_number in get_line_count():
			if line_number == get_line_count(): break

			# Adding bookmarks
			if get_line(line_number).begins_with(prefix) == true:
				set_line_as_bookmark(line_number, true)

			# Removing bookmarks
			if is_line_set_as_bookmark(line_number) and get_line(line_number).begins_with(prefix) == false:
				set_line_as_bookmark(line_number, false)











