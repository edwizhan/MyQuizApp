package com.example.androidquizapp

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.google.firebase.firestore.FirebaseFirestore
import com.example.androidquizapp.QuizViewModel.Question
import com.google.android.gms.tasks.Tasks
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.QuerySnapshot




class QuestionsRepository {
    private val db = FirebaseFirestore.getInstance()
    private val _questions = MutableLiveData<List<Question>>()
    val questions: LiveData<List<Question>> = _questions
    private val _isLoading = MutableLiveData<Boolean>()
    val isLoading: LiveData<Boolean> = _isLoading

    init {
        fetchQuestions()
    }

    private fun fetchQuestions() {
        _isLoading.value = true
        val infoRef = db.collection("Quiz").document("Coding_questions_info")
        infoRef.get().addOnSuccessListener { infoSnap ->
            val totalQuestions = infoSnap.getLong("totalQuestions")?.toInt() ?: 0
            Log.d("TotalQuestions", totalQuestions.toString()) // Log totalQuestions value
            val numQuestions = 10
            val randomIds = getRandomIds(numQuestions, totalQuestions)
            Log.d("RandomIds", randomIds.toString()) // Log the generated random IDs
            val fetchedQuestions = mutableListOf<QuizViewModel.Question>()

            if (randomIds.isNotEmpty()) {
                val fetchPromises = randomIds.map { id ->
                    db.collection("Quiz").document(id.toString()).collection("Coding_questions").get()
                }

                Tasks.whenAllSuccess<QuerySnapshot>(fetchPromises)
                    .addOnSuccessListener { querySnapshots ->
                        querySnapshots.forEach { querySnapshot ->
                            querySnapshot.documents.forEach { doc ->
                                val question = QuizViewModel.Question.fromFirestoreData(
                                    doc.getLong("id")?.toInt() ?: 0, doc.data as Map<String, Any>
                                )
                                fetchedQuestions.add(question)
                            }
                        }
                        Log.d("FetchedQuestions", fetchedQuestions.toString()) // Log the fetched questions
                        _questions.value = fetchedQuestions
                        _isLoading.value = false
                    }
                    .addOnFailureListener { error ->
                        Log.e("Error fetching questions", error.toString())
                        _isLoading.value = false
                    }
            } else {
                _isLoading.value = false
            }
        }
    }



    private fun getRandomIds(n: Int, totalQuestions: Int): List<String> {
        val randomIds = mutableSetOf<String>()
        while (randomIds.size < n) {
            val randomId = (1..totalQuestions).random()
            randomIds.add(randomId.toString())
        }
        return randomIds.toList()
    }

}
