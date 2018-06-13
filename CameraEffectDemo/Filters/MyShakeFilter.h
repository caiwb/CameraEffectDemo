//
//  MyShakeFilter.h
//  CameraEffectDemo
//
//  Created by caiwb on 2018/6/11.
//  Copyright © 2018年 caiwb. All rights reserved.
//

#import "GPUImage.h"

extern NSString *const kGPUImageMergeFragmentShaderString;

@interface MyShakeFilter : GPUImageFilterGroup

@property (nonatomic, strong) GPUImageTransformFilter *shakeFilter;

@property (nonatomic, strong) GPUImageTransformFilter *scaleFilter;

@property (nonatomic, assign) double time;

@end
