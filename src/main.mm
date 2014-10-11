#include "ofMain.h"
#include "testApp.h"

int main(){
    ofAppiPhoneWindow * iOSWindow = new ofAppiPhoneWindow;
    iOSWindow -> enableRetina();
	ofSetupOpenGL(iOSWindow,1536,2048, OF_FULLSCREEN);			// <-------- setup the GL context
	ofRunApp(new testApp);
}
