//
//  ToolPannel.m
//  CameraEffectDemo
//
//  Created by caiwb on 2018/6/8.
//  Copyright © 2018年 caiwb. All rights reserved.
//

#import "ToolPannel.h"
#import "UIView+FrameAdjust.h"

@interface ToolPannel ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL openBeautify;

@end

@implementation ToolPannel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            view.width = self.width;
            view.height = self.height * 0.4;
            view.y = self.height;
            view;
        });
        [self addSubview:self.contentView];
        
        self.scrollView = ({
            UIScrollView *view = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            view.showsVerticalScrollIndicator = YES;
            view.backgroundColor = [UIColor clearColor];
            view;
        });
        [self.contentView addSubview:self.scrollView];
        
        [self setupTools];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.bottom = self.height;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.y = self.height;
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGPoint point = [[event.allTouches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.contentView.frame, point)) {
        [self dismiss];
    }
}

#pragma mark - Tools

- (void)setupTools {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"退出" forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self.delegate action:@selector(exitCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btn];
    btn.origin = CGPointMake(15, 15);
    
    UIView *lastBottomView = btn;
    UIView *lastRightView = btn;
    
    //=================================================//
    
    btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"美颜" forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self.delegate action:@selector(switchBeautify) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btn];
    btn.origin = CGPointMake(15, lastBottomView.bottom + 15);
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, lastBottomView.bottom + 15);
}

- (void)switchBeautify {
    if ([self.delegate respondsToSelector:@selector(openBeautifyFilter:)]) {
        self.openBeautify = !self.openBeautify;
        [self.delegate openBeautifyFilter:self.openBeautify];
    }
}

@end
