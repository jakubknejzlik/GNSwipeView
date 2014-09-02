//
//  OSKSwipeRighLinearLayoutStrategy.h
//  iOSKit
//
//  Created by Jakub Knejzlik on 12/11/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "GNSwipeLayoutStrategy.h"

typedef enum{
    GNSwipeDirectionLeft,
    GNSwipeDirectionRight,
    GNSwipeDirectionUp,
    GNSwipeDirectionDown
} GNSwipeLinearLayoutStrategyDirection;

@interface GNSwipeLinearLayoutStrategy : GNSwipeLayoutStrategy
@property (nonatomic) CGFloat offset;
@property (nonatomic) GNSwipeLinearLayoutStrategyDirection swipeDirection;

-(id)initWithTopViewController:(UIViewController *)topViewController andBaseViewController:(UIViewController *)baseViewController swipeDirection:(GNSwipeLinearLayoutStrategyDirection)direction offset:(CGFloat)offset;

@end
