//
//  SRAudioInput.h
//  SRAudioKitDemoForOSX
//
//  Created by Heeseung Seo on 2015. 3. 2..
//  Copyright (c) 2015년 Seorenn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SRAudioSampleRate.h"
#import "SRAudioBufferSize.h"

@class SRAudioDevice;
@class SRAudioInput;

@protocol SRAudioInputDelegate <NSObject>
@optional
- (void)audioInput:(SRAudioInput *)audioInput didTakeAudioBuffer:(NSData *)bufferData;
@end

@interface SRAudioInput : NSObject

@property (readonly) SRAudioDevice *device;
@property (readonly) Float64 sampleRate;
@property (readonly) SRAudioBufferSize bufferSize;

@property (nonatomic, weak) id<SRAudioInputDelegate> delegate;

- (id)initWithDevice:(SRAudioDevice *)device sampleRate:(Float64)sampleRate bufferSize:(SRAudioBufferSize)bufferSize;

- (void)startCapture;
- (void)stopCapture;

@end
