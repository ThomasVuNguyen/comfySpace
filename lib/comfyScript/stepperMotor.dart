String stepperMotor(String pin1, String pin2, String pin3, String pin4, String stepperState){
    return "python3 comfyScript/stepper/stepper.py $pin1 $pin2 $pin3 $pin4 $stepperState ";
}