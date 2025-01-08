class_name Character extends CharacterBody2D

@onready var sprites: Node2D = $Sprites
@onready var base_sprite: Sprite2D = $Sprites/Base
@onready var outfit_sprite: Sprite2D = $Sprites/Outfit

var is_preview: bool = false


func _ready() -> void:
	outfit_sprite.hframes = 8
	outfit_sprite.vframes = 8
	outfit_sprite.frame = 0

	CustomizationManager.color_updated.connect(_on_color_updated)
	CustomizationManager.customization_updated.connect(_on_customization_updated)

	_update_color(CustomizationManager.character_data.skin_color)
	_update_character()


func set_as_preview() -> void:
	is_preview = true
	set_physics_process(false)
	sprites.scale = Vector2(3, 3)


func _on_color_updated(color: Color) -> void:
	_update_color(color)


func _update_color(color: Color) -> void:
	base_sprite.modulate = color


func _update_character() -> void:
	var data := CustomizationManager.character_data

	base_sprite.modulate = data.skin_color

	if data.selected_outfit >= 0:
		outfit_sprite.texture = CustomizationManager.outfit_options[data.selected_outfit].texture
		outfit_sprite.modulate = data.outfit_color
		outfit_sprite.visible = true
	else:
		outfit_sprite.visible = false


func _on_customization_updated() -> void:
	_update_character()


func _draw() -> void:
	if OS.is_debug_build() and Engine.is_editor_hint():
		draw_rect(Rect2(-16, -16, 32, 32), Color.RED, false)
