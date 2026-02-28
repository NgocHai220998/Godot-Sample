extends CanvasLayer

func _on_start_clicked() -> void:
	TutorialManager.start_tutorial([
		TutorialManager.StepID.STEP_01,
		TutorialManager.StepID.STEP_02,
		TutorialManager.StepID.STEP_03,
		TutorialManager.StepID.STEP_04,
	])

func _on_step1_clicked() -> void:
	pass

func _on_step2_clicked() -> void:
	pass

func _on_step3_clicked() -> void:
	pass

func _on_step4_clicked() -> void:
	pass
