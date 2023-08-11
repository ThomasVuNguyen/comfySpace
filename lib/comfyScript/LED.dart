String toggleLED(String pinOut, bool isToggled){
  if(isToggled == true){
    print("true");
    //return 'raspi-gpio set $pinOut op && raspi-gpio set $pinOut dh';
    return'python3 comfyScript/LED/led.py $pinOut 1';
  }
  else{
    //return 'raspi-gpio set $pinOut op && raspi-gpio set $pinOut dl';
    return'python3 comfyScript/LED/led.py $pinOut 0';
  }
}