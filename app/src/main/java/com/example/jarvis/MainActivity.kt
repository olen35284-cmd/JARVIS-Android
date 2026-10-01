package com.example.jarvis

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val tvLog = findViewById<TextView>(R.id.tvLog)
        val tvStatus = findViewById<TextView>(R.id.tvStatus)

        tvLog.text = "JARVIS: Система запущена.\n"
    }
}
