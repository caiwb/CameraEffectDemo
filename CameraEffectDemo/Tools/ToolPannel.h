//
//  ToolPannel.h
//  CameraEffectDemo
//
//  Created by caiwb on 2018/6/8.
//  Copyright © 2018年 caiwb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolPannelProtocol.h"

@interface ToolPannel : UIView

@property (nonatomic, weak) id<ToolPannelProtocol> delegate;

- (void)show;

- (void)dismiss;

@end
