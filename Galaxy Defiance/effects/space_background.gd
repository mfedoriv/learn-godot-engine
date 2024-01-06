extends ParallaxBackground

@onready var space_layer: ParallaxLayer = %SpaceLayer
@onready var far_stars_layer: ParallaxLayer = %FarStarsLayer
@onready var close_stars_layer: ParallaxLayer = %CloseStarsLayer
@onready var move_component: MoveComponent = $MoveComponent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shift_stars_by_moving(delta)
	scroll_offset.y += 20 * delta
	#space_layer.motion_offset.y += 2 * delta
	#far_stars_layer.motion_offset.y += 5 * delta
	#close_stars_layer.motion_offset.y += 20 * delta

func shift_stars_by_moving(delta) -> void:
	if move_component.velocity.x < 0:
		close_stars_layer.motion_offset.x += 10 * delta
		far_stars_layer.motion_offset.x += 2 * delta
	elif move_component.velocity.x > 0:
		close_stars_layer.motion_offset.x -= 10 * delta
		far_stars_layer.motion_offset.x -= 2 * delta
