extends Node
class_name SyntaxChanger
tool



# List of all syntaxes
export (Array, Resource) var syntaxes: Array setget set_syntaxes, get_syntaxes


func set_syntaxes(new_list: Array):
	for syntax in new_list:
		if (syntax is EditorLanguageSupport) == false and syntax != null:
			return

	syntaxes = new_list

func get_syntaxes() -> Array: return syntaxes



# Objects
export (NodePath) var text_editor_path: NodePath
onready var text_editor: TextEditor = get_node(text_editor_path)



# Setup
func _ready():
	load_syntax_based_on_extension(".gd") # Standard openning language



# Load syntax with extension
func load_syntax_based_on_extension(extension: String):
	var used_syntax: EditorLanguageSupport

	for syntax in syntaxes:
		if syntax is EditorLanguageSupport and syntax.language_extension == extension:
			used_syntax = syntax

	if used_syntax == null: 
		text_editor.reset_syntax()
		return

	apply_syntax(used_syntax)
	text_editor.set_syntax(used_syntax)



# Load syntax from list based on extension on path
func load_syntax_based_on_path(path: String):
	pass



# Apply syntax
func apply_syntax(syntax: EditorLanguageSupport):
	text_editor.clear_colors()

	# Add keywords
	# - Keywords
	for keyword in syntax.keywords:
		text_editor.add_keyword_color(keyword, text_editor.get_color("keyword_color", text_editor.theme_type_variation))

	# - Built in classes
	for _class in syntax.built_in_classes:
		text_editor.add_keyword_color(_class, text_editor.get_color("built_in_class", text_editor.theme_type_variation))

	# - Value prefixes
	for value_prefix in syntax.value_prefixes:
		text_editor.add_color_region(value_prefix, value_prefix, text_editor.get_color("prefix_value_color", text_editor.theme_type_variation))

	# - comments
	for comment_prefix in syntax.comments:
		text_editor.add_color_region(comment_prefix, "", text_editor.get_color("comment_color", text_editor.theme_type_variation), true)

	# - Split comments
	for split_comment_prefix in syntax.split_comments:
		var prefixes: Array = split_comment_prefix.split(".", true, 1)
		text_editor.add_color_region(prefixes[0], prefixes[1], text_editor.get_color("comment_color", text_editor.theme_type_variation), false)














