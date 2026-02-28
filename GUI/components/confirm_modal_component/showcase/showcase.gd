extends CanvasLayer

func _on_normal_clicked() -> void:
	print("Open Confirm Modal! ... Waiting user ...")
	
	var confirm_modal: ConfirmModalComponent = ConfirmModalComponent.release(
		get_tree().root
	)
	var confirmed: bool = await confirm_modal.confirmed
	
	if confirmed:
		print("Confirmed!")
	else:
		print("Not Confirmed")

func _on_custom_clicked() -> void:
	print("Open Custom Confirm Modal! ... Waiting user ...")
	
	var confirm_modal: ConfirmModalComponent = ConfirmModalComponent.release(
		get_tree().root, {
			"header": "Custom Header",
			"description": "Custom Description",
			"cancel": "Custome Cancel",
			"ok": "Custom OK"
		}
	)
	var confirmed: bool = await confirm_modal.confirmed
	
	if confirmed:
		print("Confirmed!")
	else:
		print("Not Confirmed")

func _on_custom_overlay_clicked() -> void:
	print("Open Custom Confirm Modal! ... Waiting user ...")
	
	var confirm_modal: ConfirmModalComponent = ConfirmModalComponent.release(
		get_tree().root, {
			"cancel_on_overlay_click": true
		}
	)
	var confirmed: bool = await confirm_modal.confirmed
	
	if confirmed:
		print("Confirmed!")
	else:
		print("Not Confirmed")
