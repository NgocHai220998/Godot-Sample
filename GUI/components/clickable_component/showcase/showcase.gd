extends CanvasLayer

func _on_normal_clicked() -> void:
	print("Click on: Normal Button")

func _on_loading_clicked(callback: Callable) -> void:
	print("Click on Loading Button")
	print("Loading ... Maybe it takes upto 2.0 Second ...")
	await get_tree().create_timer(2.0).timeout
	
	callback.call(true)
