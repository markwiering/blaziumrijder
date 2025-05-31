extends VehicleBody3D

var stuur = 0;
var motorkracht = 0;
var cwk = 5;
var draaivertraging = 0.5;

@export var turbo_constante = 5;
@export var max_rpm = 800;
@export var maximaleMotorkracht = 4000;
@export var maximaleOptreksnelheid = 1000;
@export var massa = 1200;

var verhoogdeMaximaleMotorkracht = maximaleMotorkracht * turbo_constante;
var verhoogdeMaximaleOptreksnelheid = maximaleOptreksnelheid * turbo_constante;

@export var rustlengte = 0.2;
@export var wielrolinvloed = 0.6;
@export var gripsterkteVoorwielen = 3.0;
@export var gripsterkteAchterwielen = 3.0;

@export var suspensie_travel = 0.5;
@export var suspensie_stijfheid = 30; #tussen 50 en 100
@export var suspensie_maximale_belasting = 50000;
@export var compressie = 3.0;
@export var ontspanning = 4.0;

@export var remkracht = 100;
@export var herstelVerhoging = 3;
@export var beweegDrager = Vector3.ZERO;

var beginpositie = Vector3(0,0,0);
var beginrotatie = Vector3(0,0,0);

var dicht = true;

func _ready():
	center_of_mass = Vector3(0, 0.2, 0)  # Lager zwaartepunt
	
	$AchterwielLinks.wheel_friction_slip = gripsterkteAchterwielen;
	$AchterwielRechts.wheel_friction_slip = gripsterkteAchterwielen;
	$VoorwielLinks.wheel_friction_slip = gripsterkteVoorwielen;
	$VoorwielRechts.wheel_friction_slip = gripsterkteVoorwielen;
	
	$AchterwielLinks.wheel_roll_influence = wielrolinvloed;
	$AchterwielRechts.wheel_roll_influence = wielrolinvloed;
	$VoorwielLinks.wheel_roll_influence = wielrolinvloed;
	$VoorwielRechts.wheel_roll_influence = wielrolinvloed;
	
	$AchterwielLinks.wheel_rest_length = rustlengte;
	$AchterwielRechts.wheel_rest_length = rustlengte;
	$VoorwielLinks.wheel_rest_length = rustlengte;
	$VoorwielRechts.wheel_rest_length = rustlengte;
	
	$AchterwielLinks.suspension_travel = suspensie_travel;
	$AchterwielRechts.suspension_travel = suspensie_travel;
	$VoorwielLinks.suspension_travel = suspensie_travel;
	$VoorwielRechts.suspension_travel = suspensie_travel;
	
	$AchterwielLinks.suspension_stiffness = suspensie_stijfheid;
	$AchterwielRechts.suspension_stiffness = suspensie_stijfheid;
	$VoorwielLinks.suspension_stiffness = suspensie_stijfheid;
	$VoorwielRechts.suspension_stiffness = suspensie_stijfheid;
	
	$AchterwielLinks.suspension_max_force = suspensie_maximale_belasting;
	$AchterwielRechts.suspension_max_force = suspensie_maximale_belasting;
	$VoorwielLinks.suspension_max_force = suspensie_maximale_belasting;
	$VoorwielRechts.suspension_max_force = suspensie_maximale_belasting;
	
	$AchterwielLinks.damping_compression = compressie;
	$AchterwielRechts.damping_compression = compressie;
	$VoorwielLinks.damping_compression = compressie;
	$VoorwielRechts.damping_compression = compressie;
	
	$AchterwielLinks.damping_relaxation = ontspanning;
	$AchterwielRechts.damping_relaxation = ontspanning;
	$VoorwielLinks.damping_relaxation = ontspanning;
	$VoorwielRechts.damping_relaxation = ontspanning;
	
	self.mass = massa;
	beginpositie = self.global_position;
	beginrotatie = self.global_rotation;
	
func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("ui_right", "ui_left") * 0.4, 5 * delta);
	
	engine_force = Input.get_axis("ui_down", "ui_up") * maximaleOptreksnelheid;
	var optreksnelheid = Input.get_axis("ui_down", "ui_up");
	var rpm = $AchterwielRechts.get_rpm();
	$AchterwielRechts.engine_force = optreksnelheid * maximaleMotorkracht * (1 - rpm / maximaleMotorkracht);
		
	rpm = $AchterwielLinks.get_rpm();
	$AchterwielLinks.engine_force = optreksnelheid * maximaleMotorkracht * (1 - rpm / maximaleMotorkracht);
	
	if(Input.is_action_pressed("a")):
		$Kamera.translate(Vector3(-cwk * delta, 0, 0));
	if(Input.is_action_pressed("d")):
		$Kamera.translate(Vector3(cwk * delta, 0, 0));
	if(Input.is_action_pressed("w")):
		$Kamera.translate(Vector3(0, 0, -cwk * delta));
	if(Input.is_action_pressed("s")):
		$Kamera.translate(Vector3(0, 0, cwk * delta));
	
	if(Input.is_action_pressed("q")):
		$Kamera.rotate_y(draaivertraging*cwk * delta);
	if(Input.is_action_pressed("e")):
		$Kamera.rotate_y(-draaivertraging*cwk * delta);
	if(Input.is_action_pressed("r")):
		$Kamera.rotate_object_local(Vector3(1,0,0), draaivertraging*cwk * delta);
	if(Input.is_action_pressed("f")):
		$Kamera.rotate_object_local(Vector3(1,0,0), -draaivertraging*cwk * delta);
		
	if(Input.is_action_just_released("h")):
		self.position = beginpositie;
		self.rotation = beginrotatie;
		self.linear_velocity = Vector3.ZERO
		self.angular_velocity = Vector3.ZERO

	if(Input.is_action_just_released("enter")):
		self.angular_velocity = Vector3.ZERO
		self.position.y += herstelVerhoging;
		self.rotation.x = beginrotatie.x;
		self.rotation.z = beginrotatie.z;
		
	if(Input.is_action_just_released("k") and not $AnimationPlayer.is_playing()):
		if dicht:
			$AnimationPlayer.play("AchterklepOpenen");
			$AchterklepOpen.play();
		else:
			$AnimationPlayer.play("AchterklepSluiten2");
			$AchterklepDicht.play();
		dicht = !dicht;
	
	
	if(Input.is_action_pressed("spatiebalk")):
		$AchterwielRechts.brake = remkracht;
		$AchterwielLinks.brake = remkracht;
		$VoorwielLinks.brake = remkracht;
		$VoorwielRechts.brake = remkracht;
	else:
		$AchterwielRechts.brake = 0;
		$AchterwielLinks.brake = 0;
		$VoorwielLinks.brake = 0;
		$VoorwielRechts.brake = 0;
