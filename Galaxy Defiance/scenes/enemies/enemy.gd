extends Node2D

@onready var move_component: MoveComponent = $MoveComponent
@onready var stats_component: StatsComponent = $StatsComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var destroyed_component: DestroyedComponent = $DestroyedComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
    hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
        scale_component.tween_scale()
        flash_component.flash()
        shake_component.tween_shake()
    )
    stats_component.no_health.connect(queue_free)
    hitbox_component.hit_hurtbox.connect(destroyed_component.destroy.unbind(1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass