package com.example.jarvis

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.speech.tts.TextToSpeech
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import java.util.Locale

class MainActivity : AppCompatActivity() {

    private lateinit var tvLog: TextView
    private lateinit var tvStatus: TextView
    private lateinit var btnMic: Button
    private lateinit var tts: TextToSpeech
    private lateinit var speechRecognizer: SpeechRecognizer
    private var ttsReady = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        tvLog = findViewById(R.id.tvLog)
        tvStatus = findViewById(R.id.tvStatus)
        btnMic = findViewById(R.id.btnMic)

        tts = TextToSpeech(this) { status ->
            if (status == TextToSpeech.SUCCESS) {
                tts.language = Locale("ru", "RU")
                ttsReady = true
            }
        }

        speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this)
        speechRecognizer.setRecognitionListener(object : RecognitionListener {
            override fun onReadyForSpeech(params: Bundle?) { tvStatus.text = "JARVIS: СЛУШАЮ..." }
            override fun onBeginningOfSpeech() {}
            override fun onRmsChanged(rmsdB: Float) {}
            override fun onBufferReceived(buffer: ByteArray?) {}
            override fun onEndOfSpeech() { tvStatus.text = "JARVIS ONLINE" }
            override fun onError(error: Int) {
                tvStatus.text = "JARVIS ONLINE"
                appendLog("JARVIS: Не расслышал, повтори")
            }
            override fun onResults(results: Bundle?) {
                val text = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)?.firstOrNull() ?: return
                appendLog("Вы: $text")
                handleCommand(text.lowercase())
            }
            override fun onPartialResults(partialResults: Bundle?) {}
            override fun onEvent(eventType: Int, params: Bundle?) {}
        })

        btnMic.setOnClickListener {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.RECORD_AUDIO), 1)
            } else {
                startListening()
            }
        }

        appendLog("JARVIS: Система запущена.")
        speak("Система запущена")
    }

    private fun startListening() {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, "ru-RU")
        }
        speechRecognizer.startListening(intent)
    }

    private fun handleCommand(command: String) {
        when {
            command.contains("ютуб") -> { openApp("com.google.android.youtube", "https://youtube.com"); speak("Открываю YouTube") }
            command.contains("вк") -> { openApp("com.vkontakte.android", "https://vk.com"); speak("Открываю ВКонтакте") }
            command.contains("телеграм") -> { openApp("org.telegram.messenger", "https://t.me"); speak("Открываю Telegram") }
            command.contains("время") -> {
                val time = java.text.SimpleDateFormat("HH:mm", Locale.getDefault()).format(java.util.Date())
                speak("Сейчас $time"); appendLog("JARVIS: Сейчас $time")
            }
            command.contains("привет") -> { speak("Привет! Я JARVIS"); appendLog("JARVIS: Привет!") }
            command.contains("как дела") -> speak("Всё отлично, работаю в штатном режиме")
            command.contains("спасибо") -> speak("Всегда рад помочь")
            command.contains("пока") -> { speak("Отключаюсь"); finish() }
            else -> { appendLog("JARVIS: Команда не распознана"); speak("Не знаю такой команды") }
        }
    }

    private fun openApp(packageName: String, fallbackUrl: String) {
        val intent = packageManager.getLaunchIntentForPackage(packageName)
        if (intent != null) startActivity(intent)
        else startActivity(Intent(Intent.ACTION_VIEW, android.net.Uri.parse(fallbackUrl)))
    }

    private fun speak(text: String) { if (ttsReady) tts.speak(text, TextToSpeech.QUEUE_FLUSH, null, null) }
    private fun appendLog(text: String) { tvLog.append("$text\n") }

    override fun onDestroy() {
        super.onDestroy()
        tts.stop(); tts.shutdown(); speechRecognizer.destroy()
    }
}
