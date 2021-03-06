//
//  SRAudioKitUtils.h
//  SRAudioKit
//
//  Created by Heeseung Seo on 2015. 9. 21..
//  Copyright © 2015년 Seorenn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#if TARGET_OS_IPHONE
#import <CoreAudio/CoreAudioTypes.h>
#else
#import <CoreAudio/CoreAudio.h>
#endif

typedef NS_ENUM(UInt32, SRAudioFrameType) {
    SRAudioFrameTypeUnknown = 0,
    SRAudioFrameTypeFloat32Bit,
    SRAudioFrameTypeSignedInteger16Bit
};

NSString * _Nonnull OSStatusString(OSStatus status);

//AudioBufferList * _Nonnull SRAudioAllocateBufferList(UInt32 channelsPerFrame,
//                                                     UInt32 bytesPerFrame,
//                                                     BOOL interleaved,
//                                                     UInt32 capacityFrames);
AudioBufferList * _Nullable SRAudioAllocateBufferList(AudioStreamBasicDescription asbd, UInt32 capacityFrames);

void SRAudioCopyBufferList(AudioBufferList * _Nonnull src, AudioBufferList * _Nonnull dest);

void SRAudioFreeBufferList(AudioBufferList * _Nonnull bufferList);

#if TARGET_OS_IPHONE
#pragma mark - Utilities for iOS
OSStatus SRAudioFileSetAppleCodecManufacturer(ExtAudioFileRef _Nonnull audioFileRef, BOOL useHardwareCodec);

#else   // #if TARGET_OS_IPHONE

AudioObjectPropertyAddress SRAudioGetAOPADefault(AudioObjectPropertySelector inSelector);

NSString * _Nullable SRAudioGetDeviceName(AudioDeviceID deviceID);
NSString * _Nullable SRAudioGetDeviceUID(AudioDeviceID deviceID);
UInt32 SRAudioGetNumberOfDeviceInputChannels(AudioDeviceID deviceID);
UInt32 SRAudioGetNumberOfDeviceOutputChannels(AudioDeviceID deviceID);
NSArray<NSNumber *> * _Nullable SRAudioGetDevices();

#endif  // #if TARGET_OS_IPHONE #else

#pragma mark - Misc

void SRAudioCAShow(AUGraph _Nonnull graph);
