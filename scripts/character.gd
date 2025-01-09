class_name Character extends CharacterBody2D

@onready var sprites: Node2D = $Sprites
@onready var base_sprite: Sprite2D = $Sprites/Base
@onready var outfit_sprite: Sprite2D = $Sprites/Outfit
@onready var hair_sprite: Sprite2D = $Sprites/Hair
@onready var hat_sprite: Sprite2D = $Sprites/Hat

var is_preview: bool = false


func _ready() -> void:
	for sprite in [outfit_sprite, hair_sprite, hat_sprite]:
		sprite.hframes = 8
		sprite.vframes = 8
		sprite.frame = 0

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

	if data.selected_hat >= 0:
		hat_sprite.texture = CustomizationManager.hat_options[data.selected_hat].texture
		hat_sprite.modulate = data.hat_color
		hat_sprite.visible = true
	else:
		hat_sprite.visible = false

	if data.selected_hair >= 0:
		hair_sprite.texture = CustomizationManager.hair_options[data.selected_hair].texture
		hair_sprite.modulate = data.hair_color
		hair_sprite.visible = true
	else:
		hair_sprite.visible = false


func _on_customization_updated() -> void:
	_update_character()


func _draw() -> void:
	if OS.is_debug_build() and Engine.is_editor_hint():
		draw_rect(Rect2(-16, -16, 32, 32), Color.RED, false)
