class_name CharacterData extends Resource

@export var skin_color: Color = Color(0.98, 0.84, 0.65, 1.0)
@export var outfit_color: Color = Color(1, 1, 1, 1)
@export var hair_color: Color = Color(0.35, 0.25, 0.15, 1.0)
@export var hat_color: Color = Color(1, 1, 1, 1)

@export var select_base: int = 0
@export var selected_outfit: int = -1
@export var selected_hair: int = -1
@export var selected_hat: int = -1

enum BodyPart { BASE, OUTFIT, HAIR, HAT }
