//
//  BaseEffectVC.m
//  CameraEffectDemo
//
//  Created by caiwb on 2018/6/8.
//  Copyright © 2018年 caiwb. All rights reserved.
//

#import "BaseEffectVC.h"
#import "GPUImage.h"
#import "ToolPannel.h"
#import "GPUImageBeautifyFilter.h"

@interface BaseEffectVC () <GPUImageVideoCameraDelegate, ToolPannelProtocol>

@property (nonatomic, strong) GPUImageView *outputView;

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;

@property (nonatomic, strong) ToolPannel *pannel;

@property (nonatomic, strong) NSMutableArray *outputChain;

@property (nonatomic, strong) GPUImageBeautifyFilter *beautifyFilter;

@end

@implementation BaseEffectVC

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.outputView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.outputView];
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    [self.videoCamera startCameraCapture];
    
    self.outputChain = @[].mutableCopy;
    
    self.pannel = [[ToolPannel alloc] initWithFrame:self.view.bounds];
    self.pannel.delegate = self;
    [self.view addSubview:self.pannel];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self.pannel action:@selector(show)];
    [self.view addGestureRecognizer:longPress];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)remakeOutputChain {
    GPUImageOutput *output = self.videoCamera;
    for (GPUImageOutput<GPUImageInput> *next in self.outputChain) {
        [output removeAllTargets];
        [output addTarget:next];
        output = next;
    }
    [output removeAllTargets];
    [output addTarget:self.outputView];
}

#pragma mark - ToolPannelProtocol

- (void)exitCamera {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startRecording {
    
}

- (void)stopRecording {
    
}

- (void)openBeautifyFilter:(BOOL)on {
    if (on) {
        [self.outputChain addObject:self.beautifyFilter];
    }
    else {
        [self.outputChain removeObject:self.beautifyFilter];
    }
    [self remakeOutputChain];
}

#pragma mark - Property Assoccors Overrided

- (void)setOutputChain:(NSMutableArray *)outputChain {
    _outputChain = outputChain;
    
    [self remakeOutputChain];
}

- (GPUImageBeautifyFilter *)beautifyFilter {
    if (!_beautifyFilter) {
        _beautifyFilter = [GPUImageBeautifyFilter new];
    }
    return _beautifyFilter;
}

@end
