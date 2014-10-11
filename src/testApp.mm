#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){	
	ofBackground(225, 225, 225);
	ofSetCircleResolution(80);
    ofSetFrameRate(60);
    ofSetLogLevel(OF_LOG_SILENT);
    //ofSetLogLevel(OF_LOG)
    //ofSetLogLevel(OF_LOG_SILENT);
	
	// initialize the accelerometer
	//ofxAccelerometer.setup();
    
    bigFont.loadFont("Conduit ITC Light.otf", 70);
    smallFont.loadFont("Conduit ITC Light.otf", 36);
	
	//balls.assign(10, Ball());
	
    touches.assign(2,ofPoint(768,1500));
    //touches[0] = ofVec2f(500,500);
    //touches[1] = ofVec2f(600,600);
    
    wallLeft.assign(1, ofVec2f(200,0));
    wallRight.assign(1, ofVec2f(1050,0));
	
    score = 0;
    speed = 4;
    
    isOutside = false;
    
    wallLength = 550; //how many points in a wall
    waveHeight = 125;
    noiseHeight = 125;
    wallBetween = 1000;
    
    //enemySpeed = 0.8;
    
    circRadius = 75;
    
    scoreRange = 170;
    
    
    //enemy[0] = ofPoint(768,0);
    numEnemies = 5;

    for (int i=0; i<numEnemies; i++) {
        enemySpeed.push_back(ofRandom(0.4,1.8));
        enemy.push_back(ofPoint(768+ofRandom(-100,100),0));
    }
    
    shipHealth = 1000;
    
    neutral.set(127,100,255); //blue
    collision.set(255,50, 50); //red
    scoring.set(90, 255, 90); //green
    
    synth.loadSound("synth.caf");
    pop.loadSound("synth.caf");
    pop.setLoop(false);
    pop.setVolume(0.90);
    synth.setVolume(0.90);
    synth.setMultiPlay(true);
    pop.setMultiPlay(true);
    //synth.setLoop(true);
}


//--------------------------------------------------------------
void testApp::update() {
    
    ofSoundUpdate();
    levelChange(score); //level changer
    
    int wallBase = 250;
    
    //noise function to generate the lines
    
    float curTime;
    
    curTime = ofGetElapsedTimef();
    
    curTime = ofLerp(oldTime, curTime, 0.9);
    
    int curWallLeft = (waveHeight*sin((speed*0.14)*curTime))+wallBase+noiseHeight*ofSignedNoise((speed*0.2)*curTime);
    int curWallRight = (waveHeight*cos((speed*0.1)*curTime))+(wallBase+wallBetween)-noiseHeight*ofSignedNoise((-speed*0.1)*curTime);
    
    curWallRight = ofLerp(curWallRight, oldPointRight.x, 0.9);
    curWallLeft = ofLerp(curWallLeft, oldPointLeft.x, 0.9);
    
   // wallLeft.push_back(ofVec2f((waveHeight*sin((speed*0.14)*curTime))+wallBase+noiseHeight*ofSignedNoise((speed*0.2)*curTime), 0));
   // wallRight.push_back(ofVec2f((waveHeight*cos((speed*0.1)*curTime))+(wallBase+wallBetween)-noiseHeight*ofSignedNoise((-speed*0.1)*curTime), 0));
    
    wallLeft.push_back(ofVec2f(curWallLeft,0));
    wallRight.push_back(ofVec2f(curWallRight,0));
    
    oldPointLeft.x = curWallLeft;
    oldPointRight.x = curWallRight;
    
    //for(int i=1; i<walls.size(); i++){
       // walls[i].y = ofMap(i, 0, walls.size(), 0, ofGetWidth());
    //}
    
    for (int i =0; i<wallLeft.size(); i++) {
        wallLeft[i].y = wallLeft[i].y + speed;
        wallRight[i].y = wallRight[i].y + speed;
    }
    
    for (int i=0; i<enemy.size(); i++) {

        if (enemy[i].y>2048) {
            enemy[i].x = ofRandom (400,1100);
            enemy[i].y = 0;
            enemySpeed[i] = ofRandom(0.6, 3);
        }
        
            enemy[i].y = enemy[i].y +(speed*enemySpeed[i]);
    }
    

    

    
    if(wallLeft.size()>=wallLength){ //Keep wall short
        wallLeft.erase(wallLeft.begin(), wallLeft.begin()+1);
        wallRight.erase(wallRight.begin(), wallRight.begin()+1);
    }
    
    for (int j=0; j<wallLeft.size(); j++) { //check every spot in the array
        
        if (touches[0].x<touches[1].x) { //if the first touch is right
            
            if(int(wallLeft[j].y)<(touches[0].y)+10 && int(wallLeft[j].y)>(touches[0].y)-10){ //if the current X of the point is a match, then continue
                //cout << "Current mouse x: " +ofToString(ofGetMouseX())<<endl;
                //cout << "Current Wall x: " +ofToString(int(wallLeft[j].x))<<endl;
                
                if (touches[0].x>touches[1].x) { //if one is right, use it for right
                    touchLeftDist = (touches[1].x-circRadius)-wallLeft[j].x;
                    touchRightDist = wallRight[j].x -(touches[0].x+circRadius);
                    
                }
                else{ //otherwise, use it for left wall
                    touchLeftDist= (touches[0].x-circRadius)-wallLeft[j].x;
                    touchRightDist = wallRight[j].x - (touches[1].x+circRadius);
                    
                }
                
                if((touchLeftDist<0 || touchRightDist<0) ||touchNum!=2){
                    isOutside = true;
                    score=score-150;
                    shipHealth = shipHealth - 1;
                    //synth.setSpeed(1.3);
                    //synth.play();

                }
                else if(touchLeftDist<scoreRange && touchRightDist<scoreRange){
                    isOutside = false;
                    score = score+25;
                    isScoring = true;
                   // synth.setSpeed(1.8);
                   // synth.play();
                }
                else{
                    isOutside = false;
                    isScoring = false;
                   // synth.setSpeed(1.5);
                    //synth.play();
                }
            }
        }
        
        else {
            
            if(int(wallLeft[j].y)<(touches[1].y)+10 && int(wallLeft[j].y)>(touches[1].y-10)){ //if the current X of the point is a match, then continue
                //cout << "Current mouse x: " +ofToString(ofGetMouseX())<<endl;
                //cout << "Current Wall x: " +ofToString(int(wallLeft[j].x))<<endl;
                
                if (touches[0].x>touches[1].x) { //if one is right, use it for right
                    touchLeftDist = (touches[1].x+circRadius)-wallLeft[j].x;
                    touchRightDist = wallRight[j].x -(touches[0].x+circRadius);
                    
                }
                else{ //otherwise, use it for left wall
                    touchLeftDist= (touches[0].x+circRadius)-wallLeft[j].x;
                    touchRightDist = wallRight[j].x - (touches[1].x+circRadius);
                    
                }
                
                //touchLeftDist = (ofGetMouseY()+circRadius)-wallLeft[j].y;
                //touchRightDist = wallRight[j].y-(ofGetMouseY()-circRadius);
                
                //for (int i=0; i<wallLeft.size(); i++) {
                
                //if (ofGetMouseY()+ofMap(speed,5,12,60,30)<wallLeft[j].y || ofGetMouseY()-ofMap(speed,5,12,60,30)>wallRight[j].y) { //if the y-mouse value is lower than the top or higher than the bottom, it is outside
                
                
                if((touchLeftDist<0 && touchRightDist<0) || touchNum!=2 ){
                    isOutside = true;
                    score=score-150;
                    shipHealth = shipHealth - 1;
                   // synth.setSpeed(1.3);
                   // synth.play();
                    
                }
                else if(touchLeftDist<scoreRange || touchRightDist<scoreRange){
                    isOutside = false;
                    score = score+25;
                    isScoring = true;
                }
                else{
                    isOutside = false;
                    isScoring = false;
                    //synth.setSpeed(1.5);
                   // synth.play();
                }
            }
        }
    }
    

    touchBox = ofRectangle(touches[0], touches[1]); //box between fingers
    for (int i=0; i<enemy.size(); i++) {
        if(touchBox.inside(enemy[i])){
            shipHealth = shipHealth -10;
           // pop.setSpeed(-3.0);
            //pop.play();
        }
    }

    score = ofClamp(score, -1000, 30000000);

    //ofLog(OF_LOG_VERBOSE, "x = %f, y = %f", ofxAccelerometer.getForce().x, ofxAccelerometer.getForce().y);
}

//--------------------------------------------------------------
void testApp::draw() {
    
    //--Class breakdown--
    //Draw Background
    //Draw Walls
    //Draw Enemy
    //Draw Player
    //Draw Scoring
    
    //Develop level constraints level 1 = this speed, this size, this level of noise
    
    ofBackgroundGradient(backGroundColor, ofColor::gray);
	ofEnableAlphaBlending();

    //Draw Side Walls
    ofPolyline polyTop;
    ofPolyline polyBottom;

    ofSetLineWidth(4);
    for(int i=0; i<wallLeft.size(); i++){
        polyTop.addVertex(wallLeft[i]);
        polyBottom.addVertex(wallRight[i]);
        
            ofSetColor(200, 200, 200);
        if(i%20==0){
            ofLine(0, wallLeft[i].y, wallLeft[i].x, wallLeft[i].y);
        }
        
        if(i%22==0){
            ofLine(ofGetWidth(), wallRight[i].y, wallRight[i].x, wallRight[i].y);
        }
    }
    
    
    
    ofPushMatrix();
    ofSetColor(backGroundColor.r,backGroundColor.g+15,backGroundColor.b );
    polyTop.setClosed(false);
    polyBottom.setClosed(false);
    polyTop.draw();
    polyBottom.draw();
    ofPopMatrix();
    
    //Draw score range guides
    ofSetLineWidth(9);
    ofPushMatrix();
    ofTranslate(scoreRange, 0);
    ofSetColor(200, 200, 200);
    polyTop.draw();
    ofPopMatrix();
    
    ofPushMatrix();
    ofTranslate(-scoreRange, 0);
    ofSetColor(200, 200, 200);
    polyBottom.draw();
    ofPopMatrix();
    
    //ENEMY
    for (int i=0; i<enemy.size(); i++) {
        ofSetColor(255,100+75*sin(ofGetElapsedTimef()),100+75*sin(ofGetElapsedTimef()));
        ofPushMatrix();
        ofTranslate(enemy[i]);
        ofRotateZ(200*ofGetElapsedTimef());
        ofTranslate(-40-20*sin(2*ofGetElapsedTimef()),-40-20*sin(2*ofGetElapsedTimef()));
        ofRect(0,0, 80+20*sin(2*ofGetElapsedTimef()),80+20*sin(2*ofGetElapsedTimef()));
        ofPopMatrix();
    }
    
    //Player
    
    ofSetColor(100, 100, 100);
    
    if (touches[0].x<touches[1].x) { //if the first touch is right
        for(int i=0; i<wallLeft.size(); i++){
            if (int(wallLeft[i].y)<touches[0].y+10 && int(wallLeft[i].y)>touches[0].y-10) {
                ofLine(ofVec2f(touches[0].x, touches[0].y), wallLeft[i]);
            }
            if(int(wallLeft[i].y)<touches[1].y+10 && int(wallLeft[i].y)>touches[1].y-10){
                ofLine(ofVec2f(touches[1].x, touches[1].y), wallRight[i]);
            }
        }
    }
    
    else{
        for(int i=0; i<wallLeft.size(); i++){
            if (int(wallLeft[i].y)<touches[1].y+10 && int(wallLeft[i].y)>touches[1].y-10) {
                ofLine(ofVec2f(touches[1].x, touches[1].y), wallLeft[i]);
            }
            if(int(wallLeft[i].y)<touches[0].y+10 && int(wallLeft[i].y)>touches[0].y-10){
                ofLine(ofVec2f(touches[0].x, touches[0].y), wallRight[i]);
            }
        }
    }
    
    ofSetColor(neutral);
    
    if (isScoring) { //this needs to be re-done...the logic paths here could be simplified a lot
        ofSetColor(scoring);
    }
    if (isOutside) {
        ofSetColor(collision);
    }
    
    //draw player
    if(touches.size()>0){
        ofFill();
        ofLine(touches[0],touches[1]);
        ofCircle(touches[0], circRadius+ 10*sin(ofGetElapsedTimef()));
        ofCircle(touches[1], circRadius+ 10*sin(ofGetElapsedTimef()));
        //ofNoFill();
        //ofRect(touchBox);
    }
    
    
    
    //Draw info overlay
    ofRect(50,1700, 50, -ofMap(score%50000, 0, 50000, 0, 800));
    smallFont.drawString(ofToString(score), 50, ofMap(score%50000, 0, 50000, 1700, 900));

    smallFont.drawString("Score: " + ofToString(score), 20,100);
    smallFont.drawString("isOutside: " + ofToString(isOutside), 20,150);
    smallFont.drawString("Speed: " + ofToString(speed), 20,200);
    smallFont.drawString("Left Dist: " + ofToString(touchLeftDist), 20,250);
    smallFont.drawString("Right Dist: " + ofToString(touchRightDist), 20,300);
    smallFont.drawString("Level: " + ofToString(level), 20,350);
    smallFont.drawString("TouchNum: " + ofToString(touchNum), 20,400);
    bigFont.drawString("Ship health: " + ofToString(shipHealth), 20,450);
    smallFont.drawString("wallLength: " + ofToString(wallLeft.size()), 20,500);
    
    ofSetColor(255,0,0);
    if(shipHealth<0){
        bigFont.drawString("Game Over!", 700,450);
    }
    //bigFont.drawString("Touch One: " + ofToString(touches[0].x), 20,350);
    

}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    //ofLog(OF_LOG_VERBOSE, "touch %d up at (%d,%d)", touch.id, touch.x, touch.y);
    touchNum = 0;
    if (touch.id==0) {
        touches[0]=ofVec2f(touch.x, touch.y);
    }
    
    if (touch.id==1) {
        touches[1]=ofVec2f(touch.x, touch.y);
       
    }
      touchNum = touch.numTouches;
    
    if (touch.x>1400 && touch.y>1800) {
        resetGame();
    }
    
	//balls[touch.id].moveTo(touch.x, touch.y);
	//balls[touch.id].bDragged = true;
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
   // ofLog(OF_LOG_VERBOSE, "touch %d up at (%d,%d)", touch.id, touch.x, touch.y);
    if (touch.id==0) {
        touches[0]=ofVec2f(touch.x, touch.y);
    }
    
    if (touch.id==1) {
        touches[1]=ofVec2f(touch.x, touch.y);
    }
    
    touchNum = touch.numTouches;
    
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    //ofLog(OF_LOG_VERBOSE, "touch %d up at (%d,%d)", touch.id, touch.x, touch.y);
    if (touch.id==0) {
        touches[0]=ofVec2f(touch.x, touch.y);
    }
    
    if (touch.id==1) {
        touches[1]=ofVec2f(touch.x, touch.y);
    }
      touchNum = touch.numTouches;
    

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){
    ofLog(OF_LOG_VERBOSE, "touch %d double tap at (%d,%d)", touch.id, touch.x, touch.y);
}
//--------------------------------------------------------------
void testApp::resetGame(){
    
    ofResetElapsedTimeCounter();
    score = 0;
    wallLeft.clear();
    wallRight.clear();
    shipHealth = 1000;
    speed = 5;
    wallLeft.assign(1, ofPoint(200,0));
    wallRight.assign(1,ofVec2f(1050,0));
    
    ofColor color;
    
}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::levelChange(int score){
    if (score>0 && score<25000 ) { //Level 1
        level = 1;
        speed = 4;
        circRadius = 100;
        backGroundColor = ofColor::white;
        wallBetween = 1000;
        waveHeight = 120;
        scoreRange = 250;
        noiseHeight = 25;
    }
    
    else if (score>25000 && score <100000) { //Level 2
        level = 2;
        //SPEED
        speed = speed+0.1; //Ramp up speed on each level
        speed = ofClamp(speed, 0, 6); //give it a max
        //CIRC RADIUS
        circRadius = circRadius - 1;
        circRadius = ofClamp(circRadius, 75, 100);
        //COLORING
        backGroundColor.set(255, 240, 255);
        //SCORE ZONE
        scoreRange = 170;
        //WAVE SIZE
        wallBetween = 900;
        waveHeight = 50;
        //NOISE AMOUNT
        noiseHeight = 50;
    }
    
    else if (score>100000 && score<150000) { //Level 3
        level = 3;
        //SPEED
        speed = speed+0.1; //Ramp up speed on each level
        speed = ofClamp(speed, 0, 8); //give it a max
        //CIRC RADIUS
        circRadius = circRadius - 1;
        circRadius = ofClamp(circRadius, 65, 100);
        //COLORING
        backGroundColor.set(255, 225, 255);
        //SCORE ZONE
        scoreRange = 150;
        //WAVE SIZE
        wallBetween = 800;
        waveHeight = 100;
        //NOISE AMOUNT
        noiseHeight = 100;
    }
    else if (score>150000 && score<200000) { //Level 4
        level = 4;
        //SPEED
        speed = speed+0.1; //Ramp up speed on each level
        speed = ofClamp(speed, 0, 11); //give it a max
        //CIRC RADIUS
        circRadius = circRadius - 1;
        circRadius = ofClamp(circRadius, 60, 100);
        //COLORING
        backGroundColor.set(255, 210, 255);
        //SCORE ZONE
        scoreRange = 150;
        //WAVE SIZE
        wallBetween = 800;
        waveHeight = 200;
        //NOISE AMOUNT
        noiseHeight = 150;
    }
}

//--------------------------------------------------------------
void testApp::lostFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
    
}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){
	
}

