#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
//#include "Ball.h"

class testApp : public ofxiPhoneApp{
	
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
        void resetGame();
    
        void levelChange(int score);
	
        void gotMessage(ofMessage msg);
	
        ofImage arrow;
    
    float oldTime;
    ofVec2f oldPointLeft, oldPointRight;
        
        float speed;
        
        bool outOfBounds;
    
        ofColor neutral, collision, scoring;
        ofColor backGroundColor; //set by level
        ofColor wallColor, safeColor;
    
        vector <ofVec2f> wallLeft, wallRight;
        
        bool isOutside;
        bool isScoring;
        int colorFade;
        
        int score;
        
        float touchLeftDist;
        float touchRightDist;
        float circRadius;
    
        int scoreRange;
    
        //WALL ATTRIBUTES
        int waveHeight;
        int noiseHeight;
        int wallBetween;
        int level;
        
        int wallLength;
        int shipHealth;
        
        vector<ofPoint> touches;
        int touchNum;
        ofRectangle touchBox;
        
        ofPoint multiScale;
    
        ofTrueTypeFont bigFont;
        ofTrueTypeFont smallFont;
    
        //make these a struct
        vector <ofPoint> enemy;
    int numEnemies;
        vector<float> enemySpeed;
    
        ofSoundPlayer synth, pop;
};
