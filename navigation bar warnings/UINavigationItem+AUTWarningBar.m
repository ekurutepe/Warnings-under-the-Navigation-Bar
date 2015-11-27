//
//  UINavigationItem+AUTWarningBar.m
//  navigation bar warnings
//
//  Created by Engin Kurutepe on 27/11/15.
//  Copyright © 2015 Engin Kurutepe. All rights reserved.
//

#import <objc/runtime.h>

#import "UINavigationItem+AUTWarningBar.h"


@implementation UINavigationItem (AUTWarningBar)

@dynamic warnings;

- (NSArray *)warnings {
    NSArray *warnings = objc_getAssociatedObject(self, _cmd);
    
    return warnings;
}

- (void)setWarnings:(NSArray *)warnings {
    NSArray *currentWarnings = objc_getAssociatedObject(self, _cmd);
    
    if (![currentWarnings isEqualToArray:warnings]) {
        objc_setAssociatedObject(self, @selector(warnings), warnings, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

@end
