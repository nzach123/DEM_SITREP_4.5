class_name SessionContext
extends Resource
## SessionContext Resource
## Holds all ephemeral session data (scores, logs, stats).
## Enables easy reset via GameManager.start_new_session().

# Session Metrics
@export var current_score: int = 0
@export var correct_answers_count: int = 0
@export var total_population: int = 0
@export var citizens_saved: int = 0
@export var casualties_count: int = 0
@export var rescue_multiplier: float = 1.0

# Attempt log: { "question": "", "user_choice": "", "correct_answer": "", "is_correct": bool }
@export var session_log: Array[Dictionary] = []


func reset() -> void:
	current_score = 0
	correct_answers_count = 0
	citizens_saved = 0
	total_population = 0
	casualties_count = 0
	rescue_multiplier = 1.0
	session_log.clear()


func add_correct_answer() -> void:
	correct_answers_count += 1


func log_attempt(question_text: String, user_choice: String, correct_answer: String, is_correct: bool) -> void:
	session_log.append({
		"question": question_text,
		"user_choice": user_choice,
		"correct_answer": correct_answer,
		"is_correct": is_correct
	})


func to_dict() -> Dictionary:
	return {
		"current_score": current_score,
		"correct_answers_count": correct_answers_count,
		"total_population": total_population,
		"citizens_saved": citizens_saved,
		"casualties_count": casualties_count,
		"rescue_multiplier": rescue_multiplier,
		"session_log": session_log.duplicate(true)
	}


func from_dict(data: Dictionary) -> void:
	current_score = data.get("current_score", 0)
	correct_answers_count = data.get("correct_answers_count", 0)
	total_population = data.get("total_population", 0)
	citizens_saved = data.get("citizens_saved", 0)
	casualties_count = data.get("casualties_count", 0)
	rescue_multiplier = data.get("rescue_multiplier", 1.0)
	var log_data: Array = data.get("session_log", [])
	session_log.clear()
	for entry in log_data:
		if entry is Dictionary:
			session_log.append(entry)
