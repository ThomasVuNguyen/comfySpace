package com.example.comfyssh

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.TextView
import com.jcraft.jsch.*
import java.io.ByteArrayOutputStream


class MainActivity : AppCompatActivity() {
    var responses : TextView? = null
    var oud :String? = "oik"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        responses = findViewById(R.id.textView)
        var oud = JschDemo.listFiles("tung.local","tung","tung",22, "ls")
        responses?.text=oud
        System.out.println(oud)

            /*var jsch = JSch()
            var session :Session= jsch.getSession("tung", "10.0.0.167",22)
            session.setPassword("tung")
            session.setConfig("StrictHostKeyChecking","no")
            System.out.println("Connecting")
            session.connect()
            System.out.println("Established session")*/


    }
    object JschDemo {
        @Throws(Exception::class)
        @JvmStatic
        fun main(args: Array<String>) {
            val host = "tung.local"
            val username = "tung"
            val password = "tung"
            val port = 22
            val command = "ls"
            listFiles(username, password, host, port, command)
        }
        @Throws(Exception::class)
        fun listFiles(
            host: String?, username: String?,
            password: String?, port: Int, command: String?
        ): String? {
            var session: Session? = null
            var channel: ChannelExec? = null
            var response: String? = null
            try {
                val jsch = JSch()
                session = jsch.getSession(username, host, port)
                session.setPassword(password)
                session.setConfig("StrictHostKeyChecking", "no")
                session.connect()
                channel = session.openChannel("exec") as ChannelExec
                channel.setCommand(command)
                val responseStream = ByteArrayOutputStream()
                val errorStream = ByteArrayOutputStream()
                channel!!.outputStream = responseStream
                channel.setErrStream(errorStream)
                channel.connect()
                while (channel.isConnected) {
                    Thread.sleep(10000)
                }
                response = String(responseStream.toByteArray())
                val errorResponse = String(errorStream.toByteArray())
                println(response)
                if (errorResponse.isNotEmpty()) {
                    throw Exception(errorResponse)
                }
            } finally {
                session?.disconnect()
                channel?.disconnect()
            }
            return response
        }
    }

}
