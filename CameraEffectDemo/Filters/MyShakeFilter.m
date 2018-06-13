//
//  MyShakeFilter.m
//  CameraEffectDemo
//
//  Created by caiwb on 2018/6/11.
//  Copyright © 2018年 caiwb. All rights reserved.
//

#import "MyShakeFilter.h"

NSString *const kGPUImageMergeFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     gl_FragColor = base + overlay;
 }
);

@interface MyShakeFilter ()

@property (nonatomic, assign) float startTime;

@end

@implementation MyShakeFilter

- (instancetype)init {
    if (self = [super init]) {
        GPUImageFilter *originFilter = [[GPUImageFilter alloc] init];
        [self addFilter:originFilter];
        
        self.scaleFilter = [[GPUImageTransformFilter alloc] init];
        [self addFilter:self.scaleFilter];
        
        GPUImageTwoInputFilter *mergeFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:kGPUImageMergeFragmentShaderString];
        [self addFilter:mergeFilter];
        
        self.shakeFilter = [[GPUImageTransformFilter alloc] init];
        
        [originFilter addTarget:mergeFilter];
        [self.scaleFilter addTarget:mergeFilter];
        
        [mergeFilter addTarget:self.shakeFilter];
        
        self.initialFilters = @[originFilter, self.scaleFilter];
        self.terminalFilter = self.shakeFilter;
    }
    return self;
}

- (void)setTime:(double)time {
    if (!_time || !_startTime) {
        _startTime = time;
        time = time - _startTime + 0.000001;
    }
    else {
        time = time - _startTime;
    }
    _time = time;
    
    double durations[4] = {0.5, 0.35, 0.25, 0.5};
    double total = 0;
    double current = 0;
    
    for (int i = 0; i < 4; i ++) {
        total += durations[i];
    }
    current = time - total * (int)(time / total);
    
    self.shakeFilter.affineTransform = CGAffineTransformIdentity;
    self.scaleFilter.affineTransform = CGAffineTransformIdentity;
    
    if (current < durations[0]) {
        double angle = fabs(sin(current * 1 / durations[0] * M_PI)) * (M_PI / 180 * 5);
        self.shakeFilter.affineTransform = CGAffineTransformMakeRotation(angle);
    }
    else if (current < durations[0] + durations[1]) {
        current = current - durations[0];
        double scale = cos(current * 1 / durations[1] * M_PI / 2) * 1.5 + 1;
        self.scaleFilter.affineTransform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    }
    else if (current < durations[0] + durations[1] + durations[2]) {
        current = current - durations[0] - durations[1];
        double scale = sin(current * 1 / durations[2] * M_PI / 2) * 0.5 + 0.5;
        self.scaleFilter.affineTransform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    }
    else {
        
    }
}

@end
