String toggleLED(String pinOut, bool isToggled){
  if(isToggled = true){
    return 'raspi-gpio set $pinOut op && raspi-gpio set $pinOut dh';
  }
  else{
    return 'raspi-gpio set $pinOut op && raspi-gpio set $pinOut dl';
  }
}