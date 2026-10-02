#!/bin/bash
echo "=== 1/6 Создаю папки ==="
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/drawable
mkdir -p app/src/main/res/mipmap-anydpi-v26
mkdir -p app/src/main/java/com/example/jarvis

echo "=== 2/6 Создаю colors.xml ==="
cat > app/src/main/res/values/colors.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#050810</color>
    <color name="jarvis_blue">#00D9FF</color>
</resources>
EOF

echo "=== 3/6 Создаю иконку ==="
cat > app/src/main/res/drawable/ic_launcher_foreground.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp" android:height="108dp"
    android:viewportWidth="108" android:viewportHeight="108">
    <path android:strokeColor="#00D9FF" android:strokeWidth="2" android:fillColor="#00000000" android:pathData="M54,22 A32,32 0 1,1 53.99,22 Z" />
    <path android:strokeColor="#00D9FF" android:strokeWidth="1.5" android:fillColor="#00000000" android:pathData="M54,30 A24,24 0 1,1 53.99,30 Z" />
    <path android:strokeColor="#00D9FF" android:strokeWidth="1" android:fillColor="#00000000" android:pathData="M54,38 A16,16 0 1,1 53.99,38 Z" />
    <path android:fillColor="#00D9FF" android:pathData="M54,50 A4,4 0 1,1 53.99,50 Z" />
    <path android:fillColor="#00D9FF" android:pathData="M54,18 A2,2 0 1,1 53.99,18 Z" />
    <path android:fillColor="#00D9FF" android:pathData="M90,54 A2,2 0 1,1 89.99,54 Z" />
    <path android:fillColor="#00D9FF" android:pathData="M54,90 A2,2 0 1,1 53.99,90 Z" />
    <path android:fillColor="#00D9FF" android:pathData="M18,54 A2,2 0 1,1 17.99,54 Z" />
</vector>
EOF

cat > app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
EOF

cp app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml

echo "=== 4/6 Создаю activity_main.xml ==="
cat > app/src/main/res/layout/activity_main.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="#050810">

    <TextView
        android:id="@+id/tvStatus"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginTop="40dp"
        android:text="JARVIS ONLINE"
        android:textColor="#00D9FF"
        android:textSize="16sp"
        android:fontFamily="monospace"
        android:textStyle="bold"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent" />

    <TextView
        android:id="@+id/tvCore"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="◉"
        android:textColor="#00D9FF"
        android:textSize="120sp"
        app:layout_constraintTop_toBottomOf="@id/tvStatus"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent" />

    <ScrollView
        android:id="@+id/scrollLog"
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:layout_marginStart="16dp"
        android:layout_marginEnd="16dp"
        android:layout_marginBottom="16dp"
        app:layout_constraintTop_toBottomOf="@id/tvCore"
        app:layout_constraintBottom_toTopOf="@id/btnMic"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent">

        <TextView
            android:id="@+id/tvLog"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:textColor="#8FE8FF"
            android:textSize="13sp"
            android:fontFamily="monospace"
            android:lineSpacingExtra="6dp" />
    </ScrollView>

    <Button
        android:id="@+id/btnMic"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginBottom="40dp"
        android:text="🎤 ГОВОРИТЬ"
        android:textColor="#00D9FF"
        android:backgroundTint="#001A2E"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
EOF

echo "=== 5/6 Создаю MainActivity.kt ==="
cat > app/src/main/java/com/example/jarvis/MainActivity.kt << 'EOF'
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
EOF

echo "=== 6/6 Проверяю AndroidManifest.xml ==="
MANIFEST="app/src/main/AndroidManifest.xml"
if ! grep -q "RECORD_AUDIO" "$MANIFEST"; then
    sed -i 's|<application|<uses-permission android:name="android.permission.RECORD_AUDIO" />\n    <uses-permission android:name="android.permission.INTERNET" />\n\n    <application|' "$MANIFEST"
    echo "Разрешения добавлены в манифест"
else
    echo "Разрешения уже есть в манифесте"
fi

echo ""
echo "=== ГОТОВО! Все файлы созданы ==="
ls -la app/src/main/res/mipmap-anydpi-v26/
ls -la app/src/main/res/drawable/ic_launcher_foreground.xml
ls -la app/src/main/java/com/example/jarvis/MainActivity.kt
echo "=== Теперь: git add . && git commit -m 'JARVIS v2' && git push origin main ==="
