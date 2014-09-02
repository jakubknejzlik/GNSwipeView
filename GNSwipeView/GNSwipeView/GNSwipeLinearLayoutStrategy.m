//
//  GNSwipeLinearLayoutStrategy.m
//
//  Created by Jakub Knejzlik on 12/11/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "GNSwipeLinearLayoutStrategy.h"


@interface GNSwipeLinearLayoutStrategy ()
@end

@implementation GNSwipeLinearLayoutStrategy

-(id)initWithTopViewController:(UIViewController *)topViewController andBaseViewController:(UIViewController *)baseViewController swipeDirection:(GNSwipeLinearLayoutStrategyDirection)direction offset:(CGFloat)offset{
    self = [super initWithTopViewController:topViewController andBaseViewController:baseViewController];
    if (self) {
        _offset = offset;
        _swipeDirection = direction;
    }
    return self;
}

-(void)setOffset:(CGFloat)offset{
    _offset = offset;
}
-(void)setSwipeDirection:(GNSwipeLinearLayoutStrategyDirection)swipeDirection{
    _swipeDirection = swipeDirection;
}
-(CGPoint)openedPointInRect:(CGRect)rect{
    if (self.offset > 0) {
        if([self isHorizontal])return CGPointMake(self.swipeDirection == GNSwipeDirectionRight?self.offset:-self.offset, 0);
        else return CGPointMake(0,self.swipeDirection == GNSwipeDirectionDown?self.offset:-self.offset);
    }else if (self.offset < 0) {
        if([self isHorizontal])return CGPointMake(self.swipeDirection == GNSwipeDirectionRight?rect.size.width+self.offset:-self.topViewController.view.frame.size.width-self.offset, 0);
        else return CGPointMake(0,self.swipeDirection == GNSwipeDirectionDown?rect.size.height+self.offset:-self.topViewController.view.frame.size.height-self.offset);
    }
    return CGPointZero;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint vel = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.topViewController.view];
    return [self isHorizontal]?(ABS(vel.x) > ABS(vel.y)):(ABS(vel.y) > ABS(vel.x)) && [super gestureRecognizerShouldBegin:gestureRecognizer];
}

-(void)updateControllersPositionsForTranslation:(CGPoint)translation inRect:(CGRect)rect{
    CGRect frame = self.topViewController.view.frame;
    frame.origin.x += translation.x;
    frame.origin.y += translation.y;
    CGPoint openedPoint = [self openedPointInRect:rect];
    if(openedPoint.x != 0){
        if(frame.origin.x < MIN(openedPoint.x,0))frame.origin.x = (self.swipeDirection == GNSwipeDirectionLeft)?(frame.origin.x-translation.x*0.5):MIN(openedPoint.x,0);
        else if(frame.origin.x > MAX(openedPoint.x,0))frame.origin.x = (self.swipeDirection == GNSwipeDirectionRight)?(frame.origin.x-translation.x*0.5):MAX(openedPoint.x,0);
    }else frame.origin.x = openedPoint.x;
    if(openedPoint.y != 0){
        if(frame.origin.y < MIN(openedPoint.y,0))frame.origin.y = (self.swipeDirection == GNSwipeDirectionUp)?(frame.origin.y-translation.y*0.5):MIN(openedPoint.y,0);
        else if(frame.origin.y > MAX(openedPoint.y,0))frame.origin.y = (self.swipeDirection == GNSwipeDirectionDown)?(frame.origin.y-translation.y*0.5):MAX(openedPoint.y,0);
    }else frame.origin.y = openedPoint.y;
    self.topViewController.view.frame = frame;
}
-(BOOL)shouldCloseTopControllerForTranslation:(CGPoint)translation velocity:(CGPoint)velocity inRect:(CGRect)rect{
    CGPoint point = CGPointMake(self.topViewController.view.frame.origin.x + translation.x + velocity.x,self.topViewController.view.frame.origin.y + translation.y + velocity.y);
    CGPoint openedPoint = [self openedPointInRect:rect];
    double distanceFromClose = hypot(point.x, point.y);
    double distanceFromOpen = hypot(point.x - openedPoint.x, point.y - openedPoint.y);
    return distanceFromClose < distanceFromOpen;
}
-(void)updateControllersToOpenedPositionInRect:(CGRect)rect{
    CGRect frame = self.topViewController.view.frame;
    frame.origin = [self openedPointInRect:rect];
    self.topViewController.view.frame = frame;
}
-(void)updateControllersToClosedPositionInRect:(CGRect)rect{
    CGRect frame = self.topViewController.view.frame;
    frame.origin = CGPointZero;
    self.topViewController.view.frame = frame;
}



-(BOOL)isHorizontal{
    return self.swipeDirection == GNSwipeDirectionLeft || self.swipeDirection == GNSwipeDirectionRight;
}

@end
