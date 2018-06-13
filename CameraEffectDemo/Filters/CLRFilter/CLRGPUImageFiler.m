//
//  CLRGPUImageFiler.m
//  ImageEffect
//
//  Created by vk on 15/12/10.
//  Copyright © 2015年 clover. All rights reserved.
//

#import "CLRGPUImageFiler.h"
#import "CLRTwoInputImageFilter.h"

@interface CLRGPUImageFiler()

@property (nonatomic, assign) GLfloat inputData;
@property (nonatomic, assign) GLfloat upDown;

@property (nonatomic, strong) GPUImageCannyEdgeDetectionFilter *cannyFilter;
@property (nonatomic, strong) CLRTwoInputImageFilter *clrTwoFilter;
@property (nonatomic, strong) GPUImageDilationFilter *dilationFilter;

@end

@implementation CLRGPUImageFiler

- (id)init {
    if (self = [super init]) {
        _cannyFilter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
        [self addFilter:_cannyFilter];
        
        _dilationFilter = [[GPUImageDilationFilter alloc] initWithRadius:20];
        [_cannyFilter addTarget:_dilationFilter];
        
        _clrTwoFilter =  [[CLRTwoInputImageFilter alloc] init];
        [self addFilter:_clrTwoFilter];
        
        [_dilationFilter addTarget:_clrTwoFilter atTextureLocation:1];
        self.initialFilters = @[_cannyFilter, _clrTwoFilter];
        self.terminalFilter = _clrTwoFilter;
    }
    return self;
}

- (void)setTime:(double)time {
    _time = time;
    
    static float timeLast = 0;
    if (!time) {
        timeLast = 0;
        return;
    }
    time = sin(time);
    time = (((time + 1.0) / 2.0) * 1.5) - 0.5;
    if (time - timeLast > 0.0) {
        self.upDown = 0.6;
//        NSLog(@"down   %f, %f", time, timeLast);
    }
    else {
        self.upDown = 0.0;
//        NSLog(@"up   %f, %f", time, timeLast);
    }
    timeLast = time;
    self.inputData = time;
}

- (void)setInputData:(GLfloat)inputData {
    _inputData = inputData;
    _clrTwoFilter.inputData = _inputData;
}

- (void)setUpDown:(GLfloat)upDown {
    _upDown = upDown;
    _clrTwoFilter.updown = _upDown;
}

@end
