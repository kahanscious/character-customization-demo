class_name Character extends CharacterBody2D

@onready var base_sprite: Sprite2D = $Sprites/Base
@onready var sprites: Node2D = $Sprites

var is_preview: bool = false


func _ready() -> void:
	CustomizationManager.color_updated.connect(_on_color_updated)
	_update_color(CustomizationManager.character_data.skin_color)


func set_as_preview() -> void:
	is_preview = true
	set_physics_process(false)
	sprites.scale = Vector2(3, 3)


func _on_color_updated(color: Color) -> void:
	_update_color(color)


func _update_color(color: Color) -> void:
	base_sprite.modulate = color


func _draw() -> void:
	if OS.is_debug_build() and Engine.is_editor_hint():
		draw_rect(Rect2(-16, -16, 32, 32), Color.RED, false)
