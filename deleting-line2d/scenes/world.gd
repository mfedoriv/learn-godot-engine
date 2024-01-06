extends Node2D

const CAMERA_MOVE_SPEED = 300

var is_drawing: bool = false
var line: Line2D
var line_joint_mode = 0

@onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input_axis := Input.get_vector("left", "right", "up", "down")
	draw()
	move_camera(input_axis, delta)
	change_line_joint_mode()


func draw():
	start_line()
	end_line()
	if line == null:
		return
	if not is_drawing:
		return
	line.add_point(get_global_mouse_position())

func start_line():
	if Input.is_action_just_pressed("draw"):
		print("Draw Start")
		line = Line2D.new()
		line.joint_mode = line_joint_mode
		line.antialiased = true
		line.width = 100
		add_child(line)
		is_drawing = true

func end_line():
	if Input.is_action_just_released("draw"):
		print("Draw End")
		attach_visible_on_screen_notifier(line, line.width)
		is_drawing = false

func change_line_joint_mode():
	if Input.is_action_just_pressed("line_joint_sharp"):
		print('Line Joint Sharp')
		line_joint_mode = Line2D.LINE_JOINT_SHARP
	elif Input.is_action_just_pressed("line_joint_bewel"):
		print('Line Joint Bewel')
		line_joint_mode = Line2D.LINE_JOINT_BEVEL
	elif Input.is_action_just_pressed("line_joint_round"):
		print('Line Joint Round')
		line_joint_mode = Line2D.LINE_JOINT_ROUND

func move_camera(input_axis: Vector2, delta: float):
	camera.offset += input_axis * CAMERA_MOVE_SPEED * delta


func attach_visible_on_screen_notifier(node: Node2D, margin: float = 0.0):
	var min_coords = Vector2.ZERO
	var max_coords = Vector2.ZERO
	var res = find_min_max_coords(line.points)
	min_coords = res[0]
	max_coords = res[1]
	print('Min coords: ', min_coords, ' Max coords: ', max_coords)
	
	# For debugging purpose
	draw_rectangle(min_coords, max_coords)
	draw_point(min_coords, max_coords)
	
	var width = abs(min_coords.x - max_coords.x)
	var height = abs(min_coords.y - max_coords.y)
	
	var notifier = VisibleOnScreenNotifier2D.new()
	# Center pivot of VisibleOnScreenNotifier is up left corner of rect. So it's coordinates is (0, 0)
	# Add margin to count line width.
	# Because margin added in 2 sides of both axises it's multiplied by 2
	notifier.rect = Rect2(0, 0, width + margin * 2, height + margin * 2)
	# Shift position by margin
	notifier.position = Vector2(min_coords.x - margin, min_coords.y - margin)
	print('Notifier Rect: ', notifier.rect)
	print('Notifier position: ', notifier.position)
	
	node.add_child(notifier)
	print('Notifier attached to node: ', node)
	notifier.screen_exited.connect(func():
		print('Delete Node ', node)
		node.queue_free()
	)
	

func find_min_max_coords(points):
	var min_coords: Vector2 = points[0]
	var max_coords: Vector2 = points[0]
	for point in line.points:
		if point.x < min_coords.x:
			min_coords.x = point.x
		if point.y < min_coords.y:
			min_coords.y = point.y
		if point.x > max_coords.x:
			max_coords.x = point.x
		if point.y > max_coords.y:
			max_coords.y = point.y
	return [min_coords, max_coords]


func draw_rectangle(min_coords, max_coords):
	var rect_line = Line2D.new()
	rect_line.add_point(Vector2(min_coords.x, max_coords.y))
	rect_line.add_point(Vector2(min_coords.x, min_coords.y))
	rect_line.add_point(Vector2(max_coords.x, min_coords.y))
	rect_line.add_point(Vector2(max_coords.x, max_coords.y))
	rect_line.closed = true
	rect_line.width = 3
	rect_line.default_color = Color.AQUA
	add_child(rect_line)


func draw_point(min_coords, max_coords): 
	var width = abs(min_coords.x - max_coords.x)
	var height = abs(min_coords.y - max_coords.y)
	var center_point = Line2D.new()
	center_point.add_point(Vector2(min_coords.x + width / 2, min_coords.y + height / 2))
	center_point.add_point(Vector2(min_coords.x + width / 2 + 5, min_coords.y + height / 2 + 5))
	center_point.width = 10
	center_point.default_color = Color.DARK_BLUE
	center_point.joint_mode = Line2D.LINE_JOINT_ROUND
	add_child(center_point)
