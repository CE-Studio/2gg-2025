class_name Level
extends Node2D


#region Variables
var player:Player
var masks:Array[Mask] = []
#endregion


func _ready() -> void:
	# Scan all child nodes for player and masks
	for _node in find_all_children(self):
		if _node is Player:
			player = _node
		if _node is Mask:
			masks.append(_node)
	if player != null:
		player.state_changed.connect(update_masks)


func find_all_children(_node:Node) -> Array:
	var output:Array = [ _node ]
	for child in _node.get_children():
		output.append_array(find_all_children(child))
	return output


func update_masks(disable_type:int) -> void:
	for _mask in masks:
		if _mask.mask_type == disable_type and disable_type != 0:
			_mask.can_grab = false
		else:
			_mask.can_grab = true
