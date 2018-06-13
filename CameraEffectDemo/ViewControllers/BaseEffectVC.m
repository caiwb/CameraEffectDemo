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
#import "MyShakeFilter.h"
#import "CLRGPUImageFiler.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface BaseEffectVC () <GPUImageVideoCameraDelegate, ToolPannelProtocol>

@property (nonatomic, strong) GPUImageView *outputView;

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;

@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;

@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic, strong) ToolPannel *pannel;

@property (nonatomic, strong) NSMutableArray *outputChain;

@property (nonatomic, strong) GPUImageBeautifyFilter *beautifyFilter;

@property (nonatomic, strong) MyShakeFilter *shakeFilter;

@property (nonatomic, strong) CLRGPUImageFiler *clrFilter;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation BaseEffectVC

- (void)dealloc {
    [self stopRecording];
    [self.displayLink invalidate];
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
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshDisp:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
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
    if (self.isRecording) {
        [output addTarget:self.movieWriter];
    }
}

#pragma mark - ToolPannelProtocol

- (void)exitCamera {
    [self.displayLink invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startRecording {
    if (self.movieWriter.assetWriter.status == AVAssetWriterStatusUnknown && !self.isRecording) {
        self.isRecording = YES;
        [self remakeOutputChain];
        self.videoCamera.audioEncodingTarget = self.movieWriter;
        [self.movieWriter startRecording];
    }
}

- (void)stopRecording {
    self.isRecording = NO;
    [self.movieWriter finishRecording];
    self.videoCamera.audioEncodingTarget = nil;
    [self remakeOutputChain];
    
    if (self.movieWriter.completionBlock) {
        self.movieWriter.completionBlock();
    }
    self.movieWriter = nil;
}

- (void)openBeautifyFilter:(BOOL)on {
    if (on) {
        [self.outputChain addObject:self.beautifyFilter];
    }
    else {
        [self.outputChain removeObject:self.beautifyFilter];
        self.beautifyFilter = nil;
    }
    [self remakeOutputChain];
}

- (void)openShakeFilter:(BOOL)on {
    if (on) {
        self.shakeFilter.time = 0;
        [self.outputChain addObject:self.shakeFilter];
    }
    else {
        [self.outputChain removeObject:self.shakeFilter];
        self.shakeFilter = nil;
    }
    [self remakeOutputChain];
}

- (void)openCLRFilter:(BOOL)on {
    if (on) {
        self.clrFilter.time = 0;
        [self.outputChain addObject:self.clrFilter];
    }
    else {
        [self.outputChain removeObject:self.clrFilter];
        self.clrFilter = nil;
    }
    [self remakeOutputChain];
}

#pragma mark - Display Link

- (void)refreshDisp:(CADisplayLink *)displayLink {
    CFTimeInterval time = CACurrentMediaTime();
    
    if (_shakeFilter) {
        _shakeFilter.time = time;
    }
    if (_clrFilter) {
        _clrFilter.time = time;
    }
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

- (MyShakeFilter *)shakeFilter {
    if (!_shakeFilter) {
        _shakeFilter = [MyShakeFilter new];
    }
    return _shakeFilter;
}

- (CLRGPUImageFiler *)clrFilter {
    if (!_clrFilter) {
        _clrFilter = [CLRGPUImageFiler new];
    }
    return _clrFilter;
}

- (GPUImageMovieWriter *)movieWriter {
    if (!_movieWriter) {
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Movie%f.m4v", [[NSDate date] timeIntervalSince1970]]];
        unlink([pathToMovie UTF8String]);
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720, 1280)];
        _movieWriter.encodingLiveVideo = YES;
        _movieWriter.completionBlock = ^{
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:movieURL]) {
                [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"录像保存失败" message:nil
                                                                           delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alert show];
                        }
                        else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"录像保存成功" message:nil
                                                                           delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alert show];
                        }
                    });
                }];
            }
        };
    }
    return _movieWriter;
}

@end
