/**
 * JTouchBar
 *
 * Copyright (c) 2018 - 2019 thizzer.com
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 *
 * @author  	M. ten Veldhuis
 */
#import "JavaPopoverTouchBarItem.h"

#import "JavaTouchBar.h"
#import "JNIContext.h"
#import "JavaTouchBarUtils.h"

@interface JavaPopoverTouchBarItem() {
    NSPopoverTouchBarItem *_touchBarItem;
    NSString *_collapsedRepresentationLabel;
    NSImage *_collapsedRepresentationImage;

    JavaTouchBar *_javaPopoverTouchBar;
    NSTouchBar *_popoverTouchBar;
    
    JavaTouchBar *_javaPressAndHoldTouchBar;
    NSTouchBar *_pressAndHoldTouchBar;
}

@end

@implementation JavaPopoverTouchBarItem

-(void) update {
    
}

-(NSTouchBarItem*) getTouchBarItem {
    if(self.javaRepr == NULL) {
        return nil;
    }
    
    if(_touchBarItem == nil) {
        JNIEnv *env; JNIContext context(&env);
        
        NSString *identifier = [super getIdentifier:env reload:TRUE];
        _touchBarItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:identifier];
        
        jobject popoverTouchBar = JNIContext::CallObjectMethod(env, self.javaRepr, "getPopoverTouchBar", "dev/kocken/nativebridge/JavaTouchBar");
        jobject pressAndHoldTouchBar = JNIContext::CallObjectMethod(env, self.javaRepr, "getPressAndHoldTouchBar", "dev/kocken/nativebridge/JavaTouchBar");
        
        jobject javaTouchBarView = JNIContext::CallObjectMethod(env, self.javaRepr, "getCollapsedRepresentation", "dev/kocken/nativebridge/item/view/TouchBarView");
        _touchBarItem.collapsedRepresentation = [self createOrUpdateView:_touchBarItem.collapsedRepresentation javaTouchBarView:javaTouchBarView];
        
        _touchBarItem.collapsedRepresentationLabel = [self getCollapsedRepresentationLabel:env reload:TRUE];
        _touchBarItem.collapsedRepresentationImage = [self getCollapsedRepresentationImage:env reload:TRUE];
        
        jobject showsCloseButton = JNIContext::CallBooleanObjectMethod(env, self.javaRepr, "isShowsCloseButton");
        if(showsCloseButton != nullptr) {
            _touchBarItem.showsCloseButton = JNIContext::CallBooleanMethod(env, showsCloseButton, "booleanValue");
        }
        
        if(popoverTouchBar != nullptr) {
            _javaPopoverTouchBar = [[JavaTouchBar alloc] init];
            [_javaPopoverTouchBar setJavaRepr:popoverTouchBar];
            
            _touchBarItem.popoverTouchBar = [_javaPopoverTouchBar createNSTouchBar];
            _touchBarItem.popoverTouchBar.delegate = self;
            
            env->DeleteLocalRef(popoverTouchBar);
        }
        
        if(pressAndHoldTouchBar != nullptr) {
            _javaPressAndHoldTouchBar = [[JavaTouchBar alloc] init];
            [_javaPressAndHoldTouchBar setJavaRepr:pressAndHoldTouchBar];
            
            _touchBarItem.pressAndHoldTouchBar = [_javaPressAndHoldTouchBar createNSTouchBar];
            _touchBarItem.pressAndHoldTouchBar.delegate = self;
            
            env->DeleteLocalRef(pressAndHoldTouchBar);
        }
        
        env->DeleteLocalRef(javaTouchBarView);
    }
    
    return _touchBarItem;
}

-(void) showPopover
{
    if(_touchBarItem == nil) {
        return;
    }
    
    [_touchBarItem showPopover:nil];
}

-(void) dismissPopover
{
    if(_touchBarItem == nil) {
        return;
    }
    
    [_touchBarItem dismissPopover:nil];
}

-(NSString*) getCollapsedRepresentationLabel:(JNIEnv*)env reload:(BOOL)reload {
    if(reload) {
        std::string collapsedRepresentationLabel = JNIContext::CallStringMethod(env, self.javaRepr, "getCollapsedRepresentationLabel");
        if(collapsedRepresentationLabel.empty()) {
            _collapsedRepresentationLabel = nil;
        }
        else {
            _collapsedRepresentationLabel = [NSString stringWithUTF8String:collapsedRepresentationLabel.c_str()];
        }
    }
    
    return _collapsedRepresentationLabel;
}

-(NSImage*) getCollapsedRepresentationImage:(JNIEnv*)env reload:(BOOL)reload {
    if(reload) {
        image_t image = JNIContext::CallImageMethod(env, self.javaRepr, "getCollapsedRepresentationImage");
        _collapsedRepresentationImage = [JavaTouchBarUtils getNSImage:image];
    }
    
    return _collapsedRepresentationImage;
}

-(NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    JavaTouchBar *javaTouchBar = ( [touchBar isEqual:_touchBarItem.popoverTouchBar] ) ? _javaPopoverTouchBar : _javaPressAndHoldTouchBar;
    return [JavaTouchBarUtils touchBar:touchBar makeItemForIdentifier:identifier usingJavaTouchBar:javaTouchBar];
}

@end
