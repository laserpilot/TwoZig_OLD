#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

class Actors : public ofxiPhoneApp{
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
    
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);
	
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);

};

class Player : public ofxiPhoneApp{
    
    public:
    ofPoint positionLeft;
    ofPoint positionRight;
    ofRect boundingBox;
    
};
