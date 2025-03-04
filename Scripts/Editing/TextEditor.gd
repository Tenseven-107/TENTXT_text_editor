extends TextEdit
class_name TextEditor



# Set up
func _ready():
	# Colors
	set_editor_colors()
	add_prefix_colors()


# - Colors
# -- Set editor colors
func set_editor_colors():
	var bg_color: Color = get_stylebox("normal", theme_type_variation).bg_color

	VisualServer.set_default_clear_color(bg_color)

	# Set some colors to the same
	theme.set_color("caret_background_color", theme_type_variation, bg_color)


# -- Add prefix colors
func add_prefix_colors():
	# Values
	add_color_region("\"", "\"", get_color("string_value_color"), false)

	# Comments
	# NOTE: Update these depending on filetype later to avoid prefixes having the wrong color in other languages
	add_color_region("//", "", get_color("comment_color", theme_type_variation),true)
	add_color_region("#", "", get_color("comment_color", theme_type_variation), true)
