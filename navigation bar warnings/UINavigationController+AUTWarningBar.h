//
//  UINavigationItem+AUTWarningBar.h
//  navigation bar warnings
//
//  Created by Engin Kurutepe on 27/11/15.
//  Copyright © 2015 Engin Kurutepe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AUTNavigationBar.h"



@interface UINavigationController (AUTWarningBar) <AUTNavigationBarWarningsDataSource>

@property (nonatomic, copy) NSArray *warnings;

+ (CGFloat)defaultWarningHeight;

+ (void)setDefaultWarningHeight:(CGFloat)height;

@end
