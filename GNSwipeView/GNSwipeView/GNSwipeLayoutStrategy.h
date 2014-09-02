//
//  OSKSwipeUpLayoutStrategy.h
//  iOSKit
//
//  Created by Jakub Knejzlík on 19.12.12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GNSwipeViewController;

@interface GNSwipeLayoutStrategy : NSObject<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIViewController *topViewController;
@property (nonatomic,strong) UIViewController *baseViewController;


-(id)initWithTopViewController:(UIViewController *)topViewController andBaseViewController:(UIViewController *)baseViewController;


-(void)didStartPanningWithTranslation:(CGPoint)translation;
-(void)didEndPanning;

-(void)initializeControllersForSwipeViewController:(GNSwipeViewController *)swipeViewController;
-(void)updateControllersPositionsForTranslation:(CGPoint)translation inRect:(CGRect)rect;
-(BOOL)shouldCloseTopControllerForTranslation:(CGPoint)translation velocity:(CGPoint)velocity inRect:(CGRect)rect;
-(void)updateControllersToOpenedPositionInRect:(CGRect)rect;
-(void)updateControllersToClosedPositionInRect:(CGRect)rect;

-(BOOL)isTopViewControllerClosedInRect:(CGRect)rect;

@end