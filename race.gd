extends SceneTree

var classes: PackedStringArray
var go := Semaphore.new()
var mutex: Mutex

func work(offset: int) -> void:
	go.wait()
	for i in classes.size():
		var c := classes[(i + offset) % classes.size()]
		if mutex:
			mutex.lock()
		ClassDB.class_get_property_default_value(c, &"x")
		if mutex:
			mutex.unlock()

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	for c in ClassDB.get_class_list():
		if not ClassDB.can_instantiate(c) and not Engine.has_singleton(c):
			classes.append(c)
	if "mutex" in args:
		mutex = Mutex.new()
	if "warm" in args:
		go.post()
		work(0)
	var n := OS.get_processor_count()
	var threads: Array[Thread] = []
	for i in n:
		var t := Thread.new()
		t.start(work.bind(i * classes.size() / n))
		threads.append(t)
	go.post(n)
	for t in threads:
		t.wait_to_finish()
	print("ok ", classes.size())
	quit()
