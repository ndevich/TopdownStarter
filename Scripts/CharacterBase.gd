extends CharacterBody2D
class_name CharacterBase

@export var sprite : AnimatedSprite2D
@export var healthbar : ProgressBar
@export var health : int = 100
@export var flipped_horizontal : bool
@export var hit_particles : GPUParticles2D

func _ready():
	init_character()
	
func _process(_delta):
	Turn()
	
func init_character():
	healthbar.max_value = health
	healthbar.value = health

func Turn():
	#This ternary lets us flip a sprite if its drawn the wrong way
	var direction = -1 if flipped_horizontal == true else 1
	
	if(velocity.x < 0):
		sprite.scale.x = -direction
	elif(velocity.x > 0):
		sprite.scale.x = direction
		
func damage_effects():
	AudioManager.play_sound(AudioManager.BLOODY_HIT, 0, -3)
	if(hit_particles):
		hit_particles.emitting = true
	
func _take_damage(amount):
	health -= amount
	healthbar.value = health;
	damage_effects()
	
	if(health <= 0):
		_die()
		await get_tree().create_timer(1.0).timeout
		 #Remove/destroy this character once it's able to do so unless its the player
		if is_instance_valid(self) and not is_in_group("Player"):
			queue_free()
	
func _die():
	pass #Called on inheriting subclasses
	
func ConnectForDamage(node : Node):
	#Make sure we are not already connected
	if(not node.is_connected("DealDamage", _take_damage)):
		node.DealDamage.connect(_take_damage)

