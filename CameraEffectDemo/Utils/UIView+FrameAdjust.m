#import "UIView+FrameAdjust.h"

@implementation UIView (FrameAdjust)

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)point {
    if (isnan(point.x) || isnan(point.y)) {
        NSLog(@"%@(%@) - target point has NaN Value, it will cause unexpected crash!!!", self, NSStringFromClass([self class]));
#if defined(DEBUG) && DEBUG
        NSAssert(NO, @"target point has NaN Value, it will cause unexpected crash!!!");
#endif
        return;
    }
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    if (isnan(size.width) || isnan(size.height)) {
        NSLog(@"%@(%@) - target size has NaN Value, it will cause unexpected crash!!!", self, NSStringFromClass([self class]));
#if defined(DEBUG) && DEBUG
        NSAssert(NO, @"target size has NaN Value, it will cause unexpected crash!!!");
#endif
        return;
    }
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    if (isnan(x)) {
        NSLog(@"%@(%@) - target x is NaN, it will cause unexpected crash!!!", self, NSStringFromClass([self class]));
#if defined(DEBUG) && DEBUG
        NSAssert(NO, @"target x is NaN, it will cause unexpected crash!!!");
#endif
        return;
    }
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    if (isnan(y)) {
        NSLog(@"%@(%@) - target y is NaN, it will cause unexpected crash!!!", self, NSStringFromClass([self class]));
#if defined(DEBUG) && DEBUG
        NSAssert(NO, @"target y is NaN, it will cause unexpected crash!!!");
#endif
        return;
    }
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    if (isnan(height)) {
        NSLog(@"%@(%@) - target height is NaN, it will cause unexpected crash!!!", self, NSStringFromClass([self class]));
#if defined(DEBUG) && DEBUG
        NSAssert(NO, @"target height is NaN, it will cause unexpected crash!!!");
#endif
        return;
    }
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    if (isnan(width)) {
        NSLog(@"%@(%@) - target width is NaN, it will cause unexpected crash!!!", self, NSStringFromClass([self class]));
#if defined(DEBUG) && DEBUG
        NSAssert(NO, @"target width is NaN, it will cause unexpected crash!!!");
#endif
        return;
    }
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)tail {
    return self.y + self.height;
}

- (void)setTail:(CGFloat)tail {
    if (isnan(tail)) {
        NSLog(@"%@(%@) - target tail is NaN, it will cause unexpected crash!!!", self, NSStringFromClass([self class]));
#if defined(DEBUG) && DEBUG
        NSAssert(NO, @"target tail is NaN, it will cause unexpected crash!!!");
#endif
        return;
    }
    self.frame = CGRectMake(self.x, tail - self.height, self.width, self.height);
}

- (CGFloat)bottom {
    return self.tail;
}

- (void)setBottom:(CGFloat)bottom {
    [self setTail:bottom];
}

- (CGFloat)right {
    return self.x + self.width;
}

- (void)setRight:(CGFloat)right {
    if (isnan(right)) {
        NSLog(@"%@(%@) - target right is NaN, it will cause unexpected crash!!!", self, NSStringFromClass([self class]));
#if defined(DEBUG) && DEBUG
        NSAssert(NO, @"target right is NaN, it will cause unexpected crash!!!");
#endif
        return;
    }
    self.frame = CGRectMake(right - self.width, self.y, self.width, self.height);
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)newCenterX {
    if (isnan(newCenterX)) {
        NSLog(@"%@(%@) - target newCenterX is NaN, it will cause unexpected crash!!!", self, NSStringFromClass([self class]));
#if defined(DEBUG) && DEBUG
        NSAssert(NO, @"target newCenterX is NaN, it will cause unexpected crash!!!");
#endif
        return;
    }
    self.center = CGPointMake(newCenterX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)newCenterY {
    if (isnan(newCenterY)) {
        NSLog(@"%@(%@) - target newCenterY is NaN, it will cause unexpected crash!!!", self, NSStringFromClass([self class]));
#if defined(DEBUG) && DEBUG
        NSAssert(NO, @"target newCenterY is NaN, it will cause unexpected crash!!!");
#endif
        return;
    }
    self.center = CGPointMake(self.center.x, newCenterY);
}

@end
