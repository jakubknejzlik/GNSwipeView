//
//  NSKSwipeUpViewController.m
//  TallyCounter
//
//  Created by Jakub Knejzlík on 17.12.12.
//  Copyright (c) 2012 The Funtasty. All rights reserved.
//

#import "GNSwipeViewController.h"

@interface GNSwipeViewController ()
@end

@implementation GNSwipeViewController
@synthesize opened = _opened;

-(id)initWithLayoutStrategy:(GNSwipeLayoutStrategy *)layoutStrategy{
    self = [super init];
    if (self) {
        self.layoutStrategy = layoutStrategy;
        self.disableTopControllerUserInteractionsOnOpen = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.layoutStrategy initializeControllersForSwipeViewController:self];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userDidPan:)];
    self.panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTap:)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];

    
    [self addChildViewController:self.layoutStrategy.baseViewController];
    [self addChildViewController:self.layoutStrategy.topViewController];
    [self.view addSubview:self.layoutStrategy.topViewController.view];
}

-(void)setLayoutStrategy:(GNSwipeLayoutStrategy *)layoutStrategy{
    _layoutStrategy = layoutStrategy;
    self.panGestureRecognizer.delegate = self;
}


-(void)userDidPan:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint translation = [panGestureRecognizer translationInView:self.view];

    if(panGestureRecognizer.state == UIGestureRecognizerStateEnded){
        CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
        _panning = YES;
        [self.layoutStrategy didEndPanning];
        [self didEndPanGestureWithVelocity:velocity andTranslation:translation];
    }else if(panGestureRecognizer.state == UIGestureRecognizerStateBegan){
        _panning = YES;
        [self.layoutStrategy didStartPanningWithTranslation:translation];
        [self didBeginPanGesture];
    }else{
        [self.layoutStrategy updateControllersPositionsForTranslation:translation inRect:self.view.bounds];
    }

    [panGestureRecognizer setTranslation:CGPointZero inView:self.layoutStrategy.topViewController.view];
}
-(void)userDidTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self toggle:YES];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == self.tapGestureRecognizer) {
        return YES;
    }else{
        if ([self.delegate respondsToSelector:@selector(swipeControllerShouldBeginPanGesture:)] && ![self.delegate swipeControllerShouldBeginPanGesture:self]) {
            return NO;
        }
        return [self.layoutStrategy gestureRecognizerShouldBegin:gestureRecognizer];
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(gestureRecognizer == self.tapGestureRecognizer){
        CGRect topControllerVisibleFrame = CGRectIntersection(self.view.bounds,[self.view convertRect:self.layoutStrategy.topViewController.view.bounds fromView:self.layoutStrategy.topViewController.view]);
        if(!self.isOpened || !CGRectContainsPoint(topControllerVisibleFrame,[touch locationInView:self.view]))
            return NO;
    }
    return YES;
}



#pragma mark - Swipe Controll
-(void)close:(BOOL)animated{
    [self setOpened:NO animated:animated];
}
-(void)open:(BOOL)animated{
    [self setOpened:YES animated:animated];
}
-(void)toggle:(BOOL)animated{
    [self setOpened:!self.isOpened animated:animated];
}
-(void)setOpened:(BOOL)opened animated:(BOOL)animated{
    [self setOpened:opened animated:animated withVelocity:CGPointZero];
}
-(void)setOpened:(BOOL)opened animated:(BOOL)animated withVelocity:(CGPoint)velocity{
    if(self.disableTopControllerUserInteractionsOnOpen)self.layoutStrategy.topViewController.view.userInteractionEnabled = !opened;
    if(opened)[self ensureInsertedBaseView];
    CGFloat speed = hypot(velocity.x, velocity.y)/hypot(self.layoutStrategy.baseViewController.view.frame.size.width, self.layoutStrategy.baseViewController.view.frame.size.height);
    if(CGPointEqualToPoint(velocity, CGPointZero))speed = 5;
    if ([UIView respondsToSelector:@selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)]) {
        _opened = opened;
        [self willSetOpened:opened animated:animated];
        BOOL largeSpeed = speed > 2;
        [UIView animateWithDuration:MIN((animated?(largeSpeed?2:1)/speed:0),1) delay:0 usingSpringWithDamping:(opened?(largeSpeed?0.6:1):1) initialSpringVelocity:speed/3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if(opened)[self.layoutStrategy updateControllersToOpenedPositionInRect:self.view.bounds];
            else [self.layoutStrategy updateControllersToClosedPositionInRect:self.view.bounds];
        } completion:^(BOOL finished) {
            [self didSetOpened:opened animated:animated];
        }];
    }else{
        _opened = opened;
        [self willSetOpened:opened animated:animated];
        [UIView animateWithDuration:(animated?3/speed:0) animations:^{
            if(opened)[self.layoutStrategy updateControllersToOpenedPositionInRect:self.view.bounds];
            else [self.layoutStrategy updateControllersToClosedPositionInRect:self.view.bounds];
        } completion:^(BOOL finished) {
            [self didSetOpened:opened animated:animated];
        }];
    }
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setOpened:self.isOpened animated:YES];
}

#pragma mark - Swipe Gesture Signal Methods
-(void)didBeginPanGesture{
    [self ensureInsertedBaseView];
}
-(void)ensureInsertedBaseView{
    if(self.layoutStrategy.baseViewController.view.superview != self.view){
        [self.view insertSubview:self.layoutStrategy.baseViewController.view belowSubview:self.layoutStrategy.topViewController.view];
    }
}
-(void)didEndPanGestureWithVelocity:(CGPoint)velocity andTranslation:(CGPoint)translation{
    if([self.layoutStrategy shouldCloseTopControllerForTranslation:translation velocity:velocity inRect:self.view.bounds])[self setOpened:NO animated:YES withVelocity:velocity];
    else [self setOpened:YES animated:YES withVelocity:velocity];
}

-(void)willSetOpened:(BOOL)opened animated:(BOOL)animated{
}
-(void)didSetOpened:(BOOL)opened animated:(BOOL)animated{
    if(opened){
        if ([self.delegate respondsToSelector:@selector(swipeControllerDidOpenTopViewController:)]) {
            [self.delegate swipeControllerDidOpenTopViewController:self];
        }
    }else{
        [self.layoutStrategy.baseViewController.view removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(swipeControllerDidCloseTopViewController:)]) {
            [self.delegate swipeControllerDidCloseTopViewController:self];
        }
    }
}

@end