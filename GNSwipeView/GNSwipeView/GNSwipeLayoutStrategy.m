//
//  OSKSwipeUpLayoutStrategy.m
//  iOSKit
//
//  Created by Jakub Knejzlík on 19.12.12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import "GNSwipeLayoutStrategy.h"
#import "GNSwipeViewController.h"

@implementation GNSwipeLayoutStrategy

-(id)initWithTopViewController:(UIViewController *)topViewController andBaseViewController:(UIViewController *)baseViewController{
    self = [super init];
    if (self) {
        self.topViewController = topViewController;
        self.baseViewController = baseViewController;
    }
    return self;
}


-(void)didStartPanningWithTranslation:(CGPoint)translation{
}
-(void)didEndPanning{
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return CGRectContainsPoint(self.topViewController.view.bounds, [touch locationInView:self.topViewController.view]);
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

-(void)initializeControllersForSwipeViewController:(GNSwipeViewController *)swipeViewController{
    self.baseViewController.view.frame = swipeViewController.view.bounds;
    self.topViewController.view.frame = swipeViewController.view.bounds;
}

-(void)updateControllersPositionsForTranslation:(CGPoint)translation inRect:(CGRect)rect{
}
-(BOOL)shouldCloseTopControllerForTranslation:(CGPoint)translation velocity:(CGPoint)velocity inRect:(CGRect)rect{
    return YES;
}
-(void)updateControllersToOpenedPositionInRect:(CGRect)rect{
}
-(void)updateControllersToClosedPositionInRect:(CGRect)rect{
}

-(BOOL)isTopViewControllerClosedInRect:(CGRect)rect{
    return [self shouldCloseTopControllerForTranslation:CGPointZero velocity:CGPointZero inRect:rect];
}


@end
