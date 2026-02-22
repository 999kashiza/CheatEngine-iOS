#include <stdio.h>
#include <dlfcn.h>
#include <objc/runtime.h>
#include <objc/message.h>

// Constructor appelé au chargement
__attribute__((constructor))
void init() {
    NSLog(@"[CheatEngine] Dylib loaded successfully!");
    
    // Affiche un alert basique après 3 secondes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        id alert = objc_msgSend(objc_getClass("UIAlertController"), 
                               sel_registerName("alertControllerWithTitle:message:preferredStyle:"),
                               @"Cheat Engine", @"Dylib injected!", 1);
        
        id action = objc_msgSend(objc_getClass("UIAlertAction"),
                                sel_registerName("actionWithTitle:style:handler:"),
                                @"OK", 0, NULL);
        
        objc_msgSend(alert, sel_registerName("addAction:"), action);
        
        // Récupère la fenêtre root
        id app = objc_msgSend(objc_getClass("UIApplication"), sel_registerName("sharedApplication"));
        id window = objc_msgSend(app, sel_registerName("keyWindow"));
        id root = objc_msgSend(window, sel_registerName("rootViewController"));
        
        objc_msgSend(root, sel_registerName("presentViewController:animated:completion:"), alert, 1, NULL);
    });
}
