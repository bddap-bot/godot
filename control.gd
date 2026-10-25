extends SceneTree
func _initialize() -> void:
	root.add_child(Camera3D.new())
	for i in 256:
		var p := AudioStreamPlayer3D.new()
		p.stream = AudioStreamGenerator.new()
		p.autoplay = true
		root.add_child(p)
func _process(_delta: float) -> bool:
	AudioServer.lock()
	AudioServer.unlock()
	return false
