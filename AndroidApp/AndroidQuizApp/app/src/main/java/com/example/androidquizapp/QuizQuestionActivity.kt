package com.example.androidquizapp

import android.content.Intent
import android.view.View
import android.view.animation.AnimationUtils
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import android.os.Bundle
import android.widget.Toast
import android.widget.Button
import androidx.lifecycle.ViewModelProvider
import com.example.androidquizapp.QuizViewModel
import com.example.androidquizapp.databinding.ActivityQuizQuestionBinding

class QuizQuestionActivity : AppCompatActivity() {

    private lateinit var binding: ActivityQuizQuestionBinding
    private lateinit var viewModel: QuizViewModel
    private var buttons = mutableListOf<Button>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportActionBar?.hide()
        binding = ActivityQuizQuestionBinding.inflate(layoutInflater)
        setContentView(binding.root)

        viewModel = ViewModelProvider(this).get(QuizViewModel::class.java)

        viewModel.questions.observe(this, { questions ->
            if (questions.isNotEmpty()) {
                displayQuestion()
            }
        })

        // Add buttons to the list
        buttons.add(binding.option1Button)
        buttons.add(binding.option2Button)
        buttons.add(binding.option3Button)
        buttons.add(binding.option4Button)

        binding.submitAnswerButton.apply {
            isEnabled = false
            isSelected = false
        }

        // Set up button click listeners
        buttons.forEachIndexed { index, button ->
            button.setOnClickListener {
                onButtonClick(it)
                selectButton(index)
                binding.submitAnswerButton.apply {
                    isEnabled = true
                    isSelected = true
                }
            }
        }

        // Set all buttons to unselected state by default
        resetButtons()


        binding.submitAnswerButton.setOnClickListener {
            checkAnswerAndUpdateScore()
            if (viewModel.moveToNextQuestion()) {
                displayQuestion()
            } else {
                val intent = Intent(this, ShowScoreActivity::class.java)
                intent.putExtra("score", viewModel.score)
                intent.putExtra("totalQuestions", viewModel.totalQuestions)
                startActivity(intent)
                finish()
            }
        }
    }

    private fun displayQuestion() {
        val currentQuestion = viewModel.getCurrentQuestion()
        binding.questionTextview.text = currentQuestion.text
        // Set the options for the buttons here
        binding.option1Button.text = currentQuestion.choices[0].text
        binding.option2Button.text = currentQuestion.choices[1].text
        binding.option3Button.text = currentQuestion.choices[2].text
        binding.option4Button.text = currentQuestion.choices[3].text
        // Reset all buttons to unselected state
        resetButtons()
        // Update the progress bar
        val viewedQuestions = viewModel.currentQuestionIndex + 1
        val totalQuestions = viewModel.totalQuestions
        val progressPercent = (viewedQuestions.toFloat() / totalQuestions.toFloat()) * 100
        binding.progressBar.progress = progressPercent.toInt()
    }

    private fun checkAnswerAndUpdateScore() {
        val selectedAnswer = buttons.indexOfFirst { it.isSelected }
        if (selectedAnswer == -1) {
            // No option selected, disable the submit button
            binding.submitAnswerButton.apply {
                isEnabled = false
                isSelected = false
            }

            return
        }
        if (viewModel.isAnswerCorrect(selectedAnswer)) {
            // Update the score and show a correct answer message
            //Toast.makeText(this, "Correct!", Toast.LENGTH_SHORT).show()
        } else {
            // Show an Oops message
            //Toast.makeText(this, "Oops.", Toast.LENGTH_SHORT).show()
        }
    }

    private fun selectButton(index: Int) {
        // Reset all buttons to unselected state
        resetButtons()
        // Set the selected button to selected state
        buttons[index].isSelected = true
    }

    private fun resetButtons() {
        buttons.forEach { it.isSelected = false
        }
        binding.submitAnswerButton.apply {
            isEnabled = false
            isSelected = false
        }
    }

    fun onButtonClick(view: View) {
        val animation = AnimationUtils.loadAnimation(this, R.anim.button_alpha_animation)
        view.startAnimation(animation)
    }
}

