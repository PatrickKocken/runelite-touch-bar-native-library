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
#include "JavaTouchBarJNI.h"

#include "JavaTouchBarBridge.h"

JNIEXPORT void JNICALL Java_dev_kocken_nativebridge_JavaTouchBarJNI_setTouchBar0(JNIEnv *env, jclass cls, jlong viewOrWindowPointerValue, jobject touchBar) {
    [JavaTouchBarBridge setTouchBar:env cls:cls viewOrWindowPointerValue:viewOrWindowPointerValue touchBar:touchBar];
}

JNIEXPORT void JNICALL Java_dev_kocken_nativebridge_JavaTouchBarJNI_updateTouchBarItem(JNIEnv *env, jclass cls, jlong itemPointer) {
    [JavaTouchBarBridge updateTouchBarItem:env cls:cls itemPointer:itemPointer];
}

JNIEXPORT void JNICALL Java_dev_kocken_nativebridge_JavaTouchBarJNI_callObjectSelector(JNIEnv *env, jclass cls, jlong objectPointer, jstring javaSelector, jboolean onMainThread) {
    [JavaTouchBarBridge callObjectSelector:env cls:cls objectPointer:objectPointer selector:javaSelector onMainThread:onMainThread];
}

JNIEXPORT int JNICALL Java_dev_kocken_nativebridge_JavaTouchBarJNI_callIntObjectSelector(JNIEnv *env, jclass cls, jlong objectPointer, jstring javaSelector) {
    return [JavaTouchBarBridge callIntObjectSelector:env cls:cls objectPointer:objectPointer selector:javaSelector];
}

JNIEXPORT jlong JNICALL Java_dev_kocken_nativebridge_JavaTouchBarJNI_getAWTViewPointer0(JNIEnv *env, jclass cls, jobject component) {
    return [JavaTouchBarBridge getAWTViewPointer:env cls:cls component:component];
}
