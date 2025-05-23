extends Tabs
class_name TabsPanel


# Set up
func _ready():
	drag_to_rearrange_enabled = false

	self.connect("tab_changed", self, "check_tabs")
	self.connect("tab_close", self, "check_tabs")



# Make sure there are more tabs so user is able to drag tabs
func check_tabs(arg):
	if (get_tab_count() > 1): 
		drag_to_rearrange_enabled = true
		return

	drag_to_rearrange_enabled = false
