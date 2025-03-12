package com.example.zanis_data_communication

import android.os.Handler
import android.os.Looper
import org.json.JSONObject
import kotlin.random.Random

class DataCommunicationManager private constructor() {
    // Singleton instance
    companion object {
        @Volatile
        private var instance: DataCommunicationManager? = null

        fun getInstance(): DataCommunicationManager {
            return instance ?: synchronized(this) {
                instance ?: DataCommunicationManager().also { instance = it }
            }
        }
    }

    // Data callbacks
    private val dataCallbacks = mutableListOf<(ByteArray) -> Unit>()

    // Handler for data simulation
    private val handler = Handler(Looper.getMainLooper())
    private var dataSimulationRunnable: Runnable? = null
    private var isSimulationRunning = false

    // Initialize
    init {
        setupDataSimulation()
    }

    // Add a data listener
    fun addDataListener(callback: (ByteArray) -> Unit) {
        dataCallbacks.add(callback)
    }

    // Remove a data listener
    fun removeDataListener(callback: (ByteArray) -> Unit) {
        dataCallbacks.remove(callback)
    }

    // Start data simulation
    fun startDataSimulation() {
        if (isSimulationRunning) return

        isSimulationRunning = true
        dataSimulationRunnable?.let { handler.post(it) }
    }

    // Stop data simulation
    fun stopDataSimulation() {
        isSimulationRunning = false
        dataSimulationRunnable?.let { handler.removeCallbacks(it) }
    }

    // Setup data simulation
    private fun setupDataSimulation() {
        dataSimulationRunnable = object : Runnable {
            override fun run() {
                if (!isSimulationRunning) return

                // Generate mock data
                val mockData = generateMockData()

                // Notify listeners
                notifyDataListeners(mockData)

                // Schedule next run
                handler.postDelayed(this, 1000)
            }
        }
    }

    // Generate mock data
    private fun generateMockData(): ByteArray {
        // Create a JSON object with random data
        val jsonObject = JSONObject().apply {
            put("value", Random.nextInt(0, 1000))
            put("timestamp", System.currentTimeMillis() / 1000.0)
            put("dataType", "sensor")
            put("unit", "celsius")
        }

        return jsonObject.toString().toByteArray()
    }

    // Notify all listeners
    private fun notifyDataListeners(data: ByteArray) {
        for (callback in dataCallbacks) {
            callback(data)
        }
    }

    // Clean up
    fun cleanup() {
        stopDataSimulation()
        dataCallbacks.clear()
    }
}