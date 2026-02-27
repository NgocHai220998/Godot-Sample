extends CanvasLayer

func _on_normal_clicked(target_node: Node, _callback: Callable) -> void:
	print("Click on: ", target_node.name)

func _on_loading_clicked(target_node: Node, callback: Callable) -> void:
	print("Click on Loadin Button: ", target_node.name)
	print("Loading ... Maybe it takes upto 2.0 Second ...")
	await get_tree().create_timer(2.0).timeout
	
	callback.call(true)
