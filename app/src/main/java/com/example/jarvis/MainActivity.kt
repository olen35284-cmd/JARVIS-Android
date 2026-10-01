package com.example.jarvis

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.speech.tts.TextToSpeech
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.activity.ComponentActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import java.util.Locale

class MainActivity : ComponentActivity(), TextToSpeech.OnInitListener {
    private lateinit var chat: TextView
    private lateinit var status: TextView
    private lateinit var input: EditText
    private lateinit var tts: TextToSpeech
    private var speech: SpeechRecognizer? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        chat = findViewById(R.id.chat)
        status = findViewById(R.id.status)
        input = findViewById(R.id.input)
        tts = TextToSpeech(this, this)

        findViewById<Button>(R.id.send).setOnClickListener {
            process(input.text.toString())
            input.text.clear()
        }

        findViewById<Button>(R.id.mic).setOnClickListener {
            startVoice()
        }
    }

    private fun process(text: String) {
        if (text.isBlank()) return
        add("Вы: $text")
        val lower = text.lowercase(Locale("ru", "RU"))

        val answer = when {
            lower.contains("привет") -> "Здравствуйте, босс. JARVIS к вашим услугам."
            lower.contains("как дела") -> "Все системы в норме. Пока вы не продали мои серверы."
            lower.contains("который час") -> {
                java.text.SimpleDateFormat("HH:mm", Locale.getDefault()).format(java.util.Date())
                    .let { "Сейчас $it, босс." }
            }
            lower.contains("кто ты") -> "Я JARVIS — ваша первая версия персонального голосового помощника."
            lower.contains("спасибо") -> "Всегда пожалуйста, босс."
            else -> "Команда принята. В этой версии я пока работаю без подключения к внешней нейросети."
        }

        add("JARVIS: $answer")
        tts.speak(answer, TextToSpeech.QUEUE_FLUSH, null, "jarvis")
    }

    private fun add(line: String) {
        chat.append("$line\n")
        status.text = "Готов к следующей команде."
    }

    private fun startVoice() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
            != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.RECORD_AUDIO), 10)
            return
        }

        if (!SpeechRecognizer.isRecognitionAvailable(this)) {
            status.text = "Распознавание речи недоступно на устройстве."
            return
        }

        speech?.destroy()
        speech = SpeechRecognizer.createSpeechRecognizer(this)
        speech?.setRecognitionListener(object : android.speech.RecognitionListener {
            override fun onReadyForSpeech(params: Bundle?) { status.text = "Слушаю, босс..." }
            override fun onResults(results: Bundle?) {
                val values = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                input.setText(values?.firstOrNull() ?: "")
                if (!values.isNullOrEmpty()) process(values.first())
            }
            override fun onError(error: Int) { status.text = "Не удалось распознать речь." }
            override fun onBeginningOfSpeech() {}
            override fun onRmsChanged(rmsdB: Float) {}
            override fun onBufferReceived(buffer: ByteArray?) {}
            override fun onEndOfSpeech() {}
            override fun onPartialResults(partialResults: Bundle?) {}
            override fun onEvent(eventType: Int, params: Bundle?) {}
        })

        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, "ru-RU")
            putExtra(RecognizerIntent.EXTRA_PROMPT, "Слушаю, босс...")
        }
        speech?.startListening(intent)
    }

    override fun onInit(statusCode: Int) {
        if (statusCode == TextToSpeech.SUCCESS) {
            tts.language = Locale("ru", "RU")
            tts.setSpeechRate(0.95f)
        }
    }

    override fun onDestroy() {
        speech?.destroy()
        tts.shutdown()
        super.onDestroy()
    }
}
