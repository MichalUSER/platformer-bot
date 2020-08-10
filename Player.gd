extends KinematicBody2D

onready var label = get_node("../Label")

var velocity = Vector2()
var fallSpeed = 30
var jumpSpeed = 750
var moveSpeed = 200

var currentFitness = 0
var changeRate = 20
var maxNumber = 10
var lastNum = 0
var mutationPercentage = 15
var players = []

func rand_num(from, to):
	randomize()
	return rand_range(from, to)

func movePlayer(number):
	if number == 1 && is_on_floor():
		velocity.y -= jumpSpeed
	if number == 2:
		velocity.x -= moveSpeed
	if number == 3:
		velocity.x += moveSpeed

func bestPlayer():
	var bestFitness = -100
	var bestMaxNumber = 0
	var bestChangeRate = 0
	for i in range(players.size()):
		if players[i][0] > bestFitness:
			bestFitness = players[i][0]
			bestMaxNumber = players[i][1]
			bestChangeRate = players[i][2]
	return [bestMaxNumber, bestChangeRate]

func mutate(num):
	var mutatedNum = num
	var num1 = int(rand_num(1, 3))
	var part = mutatedNum * (float(mutationPercentage) / 100)
	if num1 == 1:
		mutatedNum += round(part)
	else:
		mutatedNum -= round(part)
	return mutatedNum

func _ready():
	maxNumber = int(rand_num(4, 30))
	lastNum = int(rand_num(1, maxNumber))
	changeRate = int(rand_num(0, 50))
	print("maxNumber: " + str(maxNumber))
	print("changeRate: " + str(changeRate))

func _physics_process(delta):
	velocity.x = lerp(velocity.x, 0, 0.3)
	
	if int(rand_range(1, changeRate + 1)) == changeRate:
		lastNum = int(rand_num(1, maxNumber))
	movePlayer(lastNum)
	
	if not(is_on_floor()):
		velocity.y += fallSpeed
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if Input.is_action_just_pressed("ui_a"):
		currentFitness += 1
		label.text = str(currentFitness)
	elif Input.is_action_just_pressed("ui_r"):
		currentFitness -= 1
		label.text = str(currentFitness)
	elif Input.is_action_just_pressed("ui_q"):
		players.append([currentFitness, maxNumber, changeRate])
		currentFitness = 0
		label.text = str(currentFitness)
		velocity = Vector2()
		position = Vector2(473, 285)
		var bp = bestPlayer()
		maxNumber = mutate(bp[0])
		changeRate = mutate(bp[1])
		print("------------------------------")
		print("maxNumber: " + str(maxNumber))
		print("changeRate: " + str(changeRate))
