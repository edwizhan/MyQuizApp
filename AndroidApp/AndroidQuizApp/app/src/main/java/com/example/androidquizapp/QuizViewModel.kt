package com.example.androidquizapp
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import android.util.Log



class QuizViewModel : ViewModel() {

    data class Question(
        val id: Int,
        val text: String,
        val choices: List<Choice>,
        val correctAnswer: String
    ) {
        data class Choice(
            val id: String,
            val text: String
        )
        companion object {
            fun fromFirestoreData(id: Int, data: Map<String, Any>): Question {
                val text = data["text"] as? String ?: ""
                val choicesData = data["choices"] as? List<Map<String, Any>> ?: emptyList()
                val choices = choicesData.map { choiceData ->
                    Choice(
                        id = choiceData["id"] as? String ?: "",
                        text = choiceData["text"] as? String ?: ""
                    )
                }
                val correctAnswer = data["correctAnswer"] as? String ?: ""
                return Question(id, text, choices, correctAnswer)
            }
        }
    }

    private val _currentQuestion = MutableLiveData<Question?>()
    val currentQuestion: LiveData<Question?> = _currentQuestion


    /*
    private val question1 = Question(
        id = 1,
        text = "What is the main programming language used for machine learning?",
        choices = listOf(
            Question.Choice(id = "a", text = "JavaScript"),
            Question.Choice(id = "b", text = "Python"),
            Question.Choice(id = "c", text = "Swift"),
            Question.Choice(id = "d", text = "Kotlin")
        ),
        correctAnswer = "b"
    )

    private val question2 = Question(
        id = 2,
        text = "Which term refers to the process of automatically installing and managing a project's dependencies?",
        choices = listOf(
            Question.Choice(id = "a", text = "dependency injection"),
            Question.Choice(id = "b", text = "package management"),
            Question.Choice(id = "c", text = "build automation"),
            Question.Choice(id = "d", text = "version control")
        ),
        correctAnswer = "b"
    )

    private val question3 = Question(
        id = 3,
        text = "Which term refers to a collection of pre-written code that can be used to perform common tasks?",
        choices = listOf(
            Question.Choice(id = "a", text = "library"),
            Question.Choice(id = "b", text = "variable"),
            Question.Choice(id = "c", text = "function"),
            Question.Choice(id = "d", text = "class")
        ),
        correctAnswer = "a"
    )

    private val question4 = Question(
        id = 4,
        text = "Which programming language uses 'func' for function?",
        choices = listOf(
            Question.Choice(id = "a", text = "JavaScript"),
            Question.Choice(id = "b", text = "Python"),
            Question.Choice(id = "c", text = "Swift"),
            Question.Choice(id = "d", text = "Kotlin")
        ),
        correctAnswer = "c"
    )
    private val questions: List<Question> = listOf(question1, question2, question3, question4)


     */

    private val questionsRepository = QuestionsRepository()
    private val _questions = MutableLiveData<List<Question>>()
    val questions: LiveData<List<Question>> = _questions

    init {
        questionsRepository.questions.observeForever { firestoreQuestions: List<Question> ->
            Log.d("QuizViewModel", "Fetched ${firestoreQuestions.size} questions from Firestore")
            _questions.value = firestoreQuestions
            if (firestoreQuestions.isEmpty()) {
                Log.e("QuizViewModel", "Question list is empty")
            }
            getCurrentQuestion()
        }
    }



    var currentQuestionIndex = 0
    val totalQuestions: Int
        get() = questions.value?.size ?: 0
    var score: Int = 0

    fun getCurrentQuestion(): Question {
        if (questions.value.isNullOrEmpty()) {
            throw IllegalStateException("Question list is empty")
        }
        return questions.value!![currentQuestionIndex]
    }

    fun moveToNextQuestion(): Boolean {
        return if (currentQuestionIndex < totalQuestions - 1) {
            currentQuestionIndex++
            true
        } else {
            false
        }
    }

    fun isAnswerCorrect(selectedAnswer: Int): Boolean {
        val correct = getCurrentQuestion().correctAnswer == getCurrentQuestion().choices[selectedAnswer].id
        if (correct) {
            score++
        }
        return correct
    }
}
