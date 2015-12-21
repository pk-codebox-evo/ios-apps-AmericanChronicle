//
//  UIAppearance+AMC.m
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/31/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

#import "UIAppearance+AMC.h"

@implementation UIView (AMC)
+ (instancetype)AMC_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass {
    return [self appearanceWhenContainedInInstancesOfClasses:@[containerClass]];
}
@end
