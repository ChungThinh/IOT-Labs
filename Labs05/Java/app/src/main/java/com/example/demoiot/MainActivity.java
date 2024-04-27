package com.example.demoiot;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import com.github.angads25.toggle.interfaces.OnToggledListener;
import com.github.angads25.toggle.model.ToggleableView;
import com.github.angads25.toggle.widget.LabeledSwitch;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallbackExtended;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import java.nio.charset.Charset;

public class MainActivity extends AppCompatActivity {
    MQTTHelper mqttHelper;
    TextView txtTemp, txtHum;
    LabeledSwitch btnLamp, btnPump;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        txtTemp = findViewById(R.id.txtTemperature);
        txtHum = findViewById(R.id.txtHumidity);
        btnLamp = findViewById(R.id.btnLamp);
        btnPump = findViewById(R.id.btnPump);

        btnLamp.setOnToggledListener(new OnToggledListener() {
            @Override
            public void onSwitched(ToggleableView toggleableView, boolean isOn) {
                if(isOn == true){
                    sendDataMQTT("Danny0943777525/feeds/labiot.lamp", "1");
                } else{
                    sendDataMQTT("Danny0943777525/feeds/labiot.lamp", "0");
                }
            }
        });

        btnPump.setOnToggledListener(new OnToggledListener() {
            @Override
            public void onSwitched(ToggleableView toggleableView, boolean isOn) {
                if(isOn == true){
                    sendDataMQTT("Danny0943777525/feeds/labiot.pump", "1");
                } else{
                    sendDataMQTT("Danny0943777525/feeds/labiot.pump", "0");
                }
            }
        });

        startMQTT();
    }

    public void startMQTT(){
        mqttHelper = new MQTTHelper(this);
        mqttHelper.setCallback(new MqttCallbackExtended() {
            @Override
            public void connectComplete(boolean reconnect, String serverURI) {

            }

            @Override
            public void connectionLost(Throwable cause) {

            }

            @Override
            public void messageArrived(String topic, MqttMessage message) throws Exception {
                Log.d("Test", topic + "***" + message.toString());
                if(topic.contains("temp")){
                    txtTemp.setText(message.toString() + "℃");
                } else if(topic.contains("humidity")){
                    txtHum.setText(message.toString() + "%");
                } else if(topic.contains("lamp")){
                    if(message.toString().equals("1")){
                        btnLamp.setOn(true);
                    } else{
                        btnLamp.setOn(false);
                    }
                } else if(topic.contains("pump")){
                    if(message.toString().equals("1")){
                        btnPump.setOn(true);
                    } else{
                        btnPump.setOn(false);
                    }
                }
            }

            @Override
            public void deliveryComplete(IMqttDeliveryToken token) {

            }
        });
    }

    public void sendDataMQTT(String topic, String value){
        MqttMessage msg = new MqttMessage();
        msg.setId(1234);
        msg.setQos(0);
        msg.setRetained(false);

        byte[] b = value.getBytes(Charset.forName("UTF-8"));
        msg.setPayload(b);

        try {
            mqttHelper.mqttAndroidClient.publish(topic, msg);
        }catch (MqttException e){
        }

    }
}