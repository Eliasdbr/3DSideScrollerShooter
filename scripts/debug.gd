extends Node
 
var debug_data: Dictionary = {}
var debug_nodes: Dictionary = {}

func addValue(keyName: String, value) -> void:
	var debug_items: VBoxContainer = get_tree().get_first_node_in_group("DebugItems")
	
	debug_data[keyName] = value
	
	# Add its correspondent label
	var label = Label.new()
	label.text = "%s: %s" % [keyName, value]
	debug_nodes[keyName] = label
	debug_items.add_child(label)

func updateValue(keyName: String, newValue) -> void:
	if not debug_data.has(keyName): return
	
	var debug_items: VBoxContainer = get_tree().get_first_node_in_group("DebugItems")
	
	debug_data[keyName] = newValue
	# Add its correspondent label
	var label = debug_nodes[keyName]
	label.text = "%s: %s" % [keyName, newValue]

func removeValue(keyName: String) -> void:
	if not debug_data.has(keyName): return
	
	debug_data.erase(keyName)
	
	debug_nodes[keyName].queue_free()
	debug_nodes.erase(keyName)
