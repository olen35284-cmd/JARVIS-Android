package com.example.jarvis

import android.animation.ObjectAnimator
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.util.AttributeSet
import android.view.View
import kotlin.math.min

class CircleVisualizer @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null
) : View(context, attrs) {

    private val outerPaint = Paint().apply {
        color = Color.parseColor("#00D9FF")
        style = Paint.Style.STROKE
        strokeWidth = 3f
        isAntiAlias = true
    }

    private val innerPaint = Paint().apply {
        color = Color.parseColor("#2200D9FF")
        style = Paint.Style.FILL
        isAntiAlias = true
    }

    private val dotPaint = Paint().apply {
        color = Color.parseColor("#00D9FF")
        style = Paint.Style.FILL
        isAntiAlias = true
    }

    private var pulseScale = 1f
    private var rot = 0f

    init {
        ObjectAnimator.ofFloat(this, "pulseScale", 1f, 1.15f).apply {
            duration = 1200
            repeatMode = ObjectAnimator.REVERSE
            repeatCount = ObjectAnimator.INFINITE
            start()
        }
        ObjectAnimator.ofFloat(this, "rot", 0f, 360f).apply {
            duration = 6000
            repeatCount = ObjectAnimator.INFINITE
            start()
        }
    }

    fun setPulseScale(value: Float) {
        pulseScale = value
        invalidate()
    }

    fun setRot(value: Float) {
        rot = value
        invalidate()
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        val cx = width / 2f
        val cy = height / 2f
        val maxR = min(cx, cy)

        canvas.drawCircle(cx, cy, maxR * 0.85f * pulseScale, innerPaint)
        canvas.drawCircle(cx, cy, maxR * 0.85f * pulseScale, outerPaint)
        canvas.drawCircle(cx, cy, maxR * 0.65f * pulseScale, outerPaint)

        val dotRadius = maxR * 0.92f * pulseScale
        for (i in 0 until 8) {
            val angle = Math.toRadians((rot + i * 45).toDouble())
            val x = cx + (dotRadius * Math.cos(angle)).toFloat()
            val y = cy + (dotRadius * Math.sin(angle)).toFloat()
            canvas.drawCircle(x, y, 5f, dotPaint)
        }

        canvas.drawCircle(cx, cy, 8f * pulseScale, dotPaint)
    }
}
