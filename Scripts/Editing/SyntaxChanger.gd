extends Node
class_name SyntaxChanger
tool


# Signals
signal new_syntax_set(syntax)


# List of all syntaxes
export (Resource) var default_syntax: Resource = load("res://Resources/Languages/Default/Default.tres")
export (Array, Resource) var syntaxes: Array setget set_syntaxes, get_syntaxes


func set_syntaxes(new_list: Array):
	for syntax in new_list:
		if (syntax is EditorLanguageSupport) == false and syntax != null:
			return

	syntaxes = new_list

func get_syntaxes() -> Array: return syntaxes

# Objects
# - Using text edit, since we do not need full TextEditor functionality
export (NodePath) var text_edit_path: NodePath
onready var text_edit: TextEdit = get_node(text_edit_path)



# Setup
func _ready():
	reset_syntax()

func reset_syntax():
	load_syntax_based_on_extension(".gd") # Standard opening language



# Loading syntax
# - Load syntax from list based on extension on path
func load_syntax_based_on_path(path: String):
	var path_members = path.split("/")
	var extension = "." + ((path_members[path_members.size() - 1].split("."))[-1])
	load_syntax_based_on_extension(extension)

# - Load syntax with extension
func load_syntax_based_on_extension(extension: String):
	var used_syntax: EditorLanguageSupport = default_syntax

	if extension != "":
		for syntax in syntaxes:
			if syntax is EditorLanguageSupport and syntax.language_extension == extension:
				used_syntax = syntax

	apply_syntax(used_syntax)
	emit_signal("new_syntax_set", used_syntax)



# Apply syntax
func apply_syntax(syntax: EditorLanguageSupport):
	text_edit.clear_colors()

	# Add keywords
	# - Keywords
	for keyword in syntax.keywords:
		text_edit.add_keyword_color(keyword, text_edit.get_color("keyword_color", text_edit.theme_type_variation))

	# - Built in classes
	for _class in syntax.built_in_classes:
		text_edit.add_keyword_color(_class, text_edit.get_color("built_in_class", text_edit.theme_type_variation))

	# - Value prefixes
	for value_prefix in syntax.value_prefixes:
		text_edit.add_color_region(value_prefix, value_prefix, text_edit.get_color("prefix_value_color", text_edit.theme_type_variation))

	# - comments
	for comment_prefix in syntax.comments:
		text_edit.add_color_region(comment_prefix, "", text_edit.get_color("comment_color", text_edit.theme_type_variation), true)

	# - Split comments
	for split_comment_prefix in syntax.split_comments:
		var prefixes: Array = split_comment_prefix.split(".", true, 1)
		text_edit.add_color_region(prefixes[0], prefixes[1], text_edit.get_color("comment_color", text_edit.theme_type_variation), false)














