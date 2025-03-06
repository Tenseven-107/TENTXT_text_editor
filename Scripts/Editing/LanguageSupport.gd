extends Resource
class_name EditorLanguageSupport




# Lists of different words
export (String) var language_extension: String = ".gd"
export (String) var language_name: String = "GDScript"

# - Keywords 
export (Array, String) var keywords: Array

# - Class
export (Array, String) var built_in_classes: Array

# - Value prefixes (strings)
export (Array, String) var value_prefixes: Array = ["\""]

# - Comments
export (Array, String) var comments: Array

# - Split Comments
# With split comments, fill in the start (like "/**") split with a . and then the end, like: "/**./"
export (Array, String) var split_comments: Array


# Other
# - Bookmark prefix
export (Array, String) var bookmark_prefixes: Array
