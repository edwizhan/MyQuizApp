package com.example.androidquizapp

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.example.androidquizapp.databinding.ActivityShowScoreBinding
import com.github.mikephil.charting.charts.PieChart
import com.github.mikephil.charting.components.Legend
import com.github.mikephil.charting.data.PieData
import com.github.mikephil.charting.data.PieDataSet
import com.github.mikephil.charting.data.PieEntry
import android.graphics.Color



class ShowScoreActivity : AppCompatActivity() {
    private lateinit var binding: ActivityShowScoreBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportActionBar?.hide()
        binding = ActivityShowScoreBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val score = intent.getIntExtra("score", 0)
        val totalQuestions = intent.getIntExtra("totalQuestions", 0)
        val percentage = (score.toFloat() / totalQuestions.toFloat()) * 100

        binding.scoreTextview.text = "${percentage.toInt()}%"

        binding.anotherQuizButton.setOnClickListener {
            val intent = Intent(this, WelcomeScreenActivity::class.java)
            startActivity(intent)
            finish()
        }

        // Retrieve the chart element by ID
        val chart = binding.chart



        fun PieChart.setupChart() {
            setUsePercentValues(true)
            description.isEnabled = false
            setDrawHoleEnabled(true)
            setHoleColor(Color.TRANSPARENT)
            setTransparentCircleColor(Color.TRANSPARENT)
            setTransparentCircleAlpha(0)
            setHoleRadius(70f)
            setTransparentCircleRadius(75f)
            setDrawCenterText(true)
            rotationAngle = 0f
            // enable rotation of the chart by touch
            isRotationEnabled = true
            isHighlightPerTapEnabled = true
            // add a selection listener
            setOnChartValueSelectedListener(null)
            animateY(1000)
            // set legend
            val l: Legend = legend
            l.isEnabled = false
        }

        // Set up the chart data and appearance
        chart.setupChart()
        chart.holeRadius = 80f
        chart.transparentCircleRadius = 85f
        chart.description.isEnabled = false
        chart.legend.isEnabled = false

        // Define the chart data
        val entries = listOf(
            PieEntry((totalQuestions - score).toFloat(), ""),
            PieEntry(score.toFloat(), "")
        )

        val dataSet = PieDataSet(entries, "Quiz Results")
        dataSet.colors = listOf(Color.parseColor("#cccccc"), Color.parseColor("#0077cc"))
        dataSet.setDrawValues(false)

        val data = PieData(dataSet)
        chart.data = data
        chart.invalidate()

    }
}
