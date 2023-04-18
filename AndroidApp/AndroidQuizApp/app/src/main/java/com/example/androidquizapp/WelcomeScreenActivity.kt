package com.example.androidquizapp

import android.content.Intent
import android.view.View
import android.view.animation.AnimationUtils
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.app.AppCompatDelegate
import android.os.Bundle
import androidx.lifecycle.Observer
import com.example.androidquizapp.databinding.ActivityWelcomeScreenBinding
import com.google.firebase.FirebaseApp


class WelcomeScreenActivity : AppCompatActivity() {

    private lateinit var binding: ActivityWelcomeScreenBinding
    private val questionsRepository = QuestionsRepository()

    override fun onCreate(savedInstanceState: Bundle?) {
        FirebaseApp.initializeApp(this)
        super.onCreate(savedInstanceState)
        supportActionBar?.hide()
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
        binding = ActivityWelcomeScreenBinding.inflate(layoutInflater)
        setContentView(binding.root)

        questionsRepository.isLoading.observe(this, Observer { isLoading ->
            binding.startQuizButton.isClickable = !isLoading
            binding.progressBar.visibility = if (isLoading) View.VISIBLE else View.GONE
        })

        val buttonClickAnimation = AnimationUtils.loadAnimation(this, R.anim.button_alpha_animation)

        binding.startQuizButton.setOnClickListener {
            it.startAnimation(buttonClickAnimation)

            // Add a small delay before starting the new activity
            it.postDelayed({
                val intent = Intent(this, QuizQuestionActivity::class.java)
                startActivity(intent)
            }, buttonClickAnimation.duration)
        }
    }
}
