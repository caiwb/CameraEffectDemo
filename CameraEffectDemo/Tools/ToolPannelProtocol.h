//
//  ToolPannelProtocol.h
//  CameraEffectDemo
//
//  Created by caiwb on 2018/6/8.
//  Copyright © 2018年 caiwb. All rights reserved.
//

#ifndef ToolPannelProtocol_h
#define ToolPannelProtocol_h

@protocol ToolPannelProtocol <NSObject>

- (void)exitCamera;

- (void)startRecording;

- (void)stopRecording;

- (void)openBeautifyFilter:(BOOL)on;

- (void)openShakeFilter:(BOOL)on;

- (void)openCLRFilter:(BOOL)on;

@end

#endif /* ToolPannelProtocol_h */
