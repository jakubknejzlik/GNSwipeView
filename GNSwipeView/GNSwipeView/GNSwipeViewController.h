//
//  NSKSwipeUpViewController.h
//  TallyCounter
//
//  Created by Jakub Knejzlík on 17.12.12.
//  Copyright (c) 2012 The Funtasty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GNSwipeLinearLayoutStrategy.h"

@protocol GNSwipeViewControllerDelegate;


@interface GNSwipeViewController : UIViewController<UIGestureRecognizerDelegate>
@property (nonatomic,assign) id<GNSwipeViewControllerDelegate> delegate;
@property (nonatomic,strong) GNSwipeLayoutStrategy *layoutStrategy;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;
@property BOOL disableTopControllerUserInteractionsOnOpen;
@property (readonly,getter = isPanning) BOOL panning;
@property (readonly,getter = isOpened) BOOL opened;

-(id)initWithLayoutStrategy:(GNSwipeLayoutStrategy *)layoutStrategy;

-(void)close:(BOOL)animated;
-(void)open:(BOOL)animated;
-(void)toggle:(BOOL)animated;

-(void)didBeginPanGesture;
-(void)didEndPanGestureWithVelocity:(CGPoint)velocity andTranslation:(CGPoint)translation;

-(void)willSetOpened:(BOOL)opened animated:(BOOL)animated;
-(void)didSetOpened:(BOOL)opened animated:(BOOL)animated;

@end

@protocol GNSwipeViewControllerDelegate <NSObject>

@optional
-(void)swipeControllerDidOpenTopViewController:(GNSwipeViewController *)swipeViewController;
-(void)swipeControllerDidCloseTopViewController:(GNSwipeViewController *)swipeViewController;

-(BOOL)swipeControllerShouldBeginPanGesture:(GNSwipeViewController *)swipeViewController;

@end
