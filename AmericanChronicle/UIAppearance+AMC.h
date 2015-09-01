//
//  UIAppearance+AMC.h
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/31/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (AMC)
// Stolen from http://stackoverflow.com/a/27807417
+ (instancetype)AMC_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass;
@end
