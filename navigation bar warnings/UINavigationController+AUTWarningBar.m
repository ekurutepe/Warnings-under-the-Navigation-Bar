//
//  UINavigationItem+AUTWarningBar.m
//  navigation bar warnings
//
//  Created by Engin Kurutepe on 27/11/15.
//  Copyright © 2015 Engin Kurutepe. All rights reserved.
//

#import <objc/runtime.h>

#import "UINavigationController+AUTWarningBar.h"
#import "AUTNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UINavigationController (AUTWarningBar)

@dynamic warnings;

+ (CGFloat)defaultWarningHeight {
    NSNumber *height = objc_getAssociatedObject(self, _cmd);
    
    if (height == nil) {
        height = @30;
        objc_setAssociatedObject(self, _cmd, height, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    return height.doubleValue;
}

+ (void)setDefaultWarningHeight:(CGFloat)height {
    CGFloat currentHeight = [self defaultWarningHeight];
    
    if (currentHeight != height) {
        objc_setAssociatedObject(self, _cmd, @(height), OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    return;
}

- (NSArray *)warnings {
    NSArray *warnings = objc_getAssociatedObject(self, _cmd);
    
    if (warnings == nil) {
        return @[];
    }
    
    return warnings;
}

- (void)setWarnings:(NSArray *)warnings {
    NSArray *previousWarnings = [self warnings];
    
    if (![previousWarnings isEqualToArray:warnings]) {
        objc_setAssociatedObject(self, @selector(warnings), warnings, OBJC_ASSOCIATION_COPY_NONATOMIC);
        AUTNavigationBar *navBar = (AUTNavigationBar *)self.navigationBar;
        
        navBar.dataSource = self;
        
        [self setNavigationBarHidden:YES animated:NO];
        [self setNavigationBarHidden:NO animated:NO];
        
        
        NSMutableArray *addedWarnings = [NSMutableArray arrayWithArray:warnings];
        [addedWarnings removeObjectsInArray:previousWarnings];
        
        NSIndexSet *addedIndexes = [warnings indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [addedWarnings containsObject:obj];
        }];
        
        NSMutableArray *removedWarnings = [NSMutableArray arrayWithArray:previousWarnings];
        [removedWarnings removeObjectsInArray:warnings];
        
        NSIndexSet *removedIndexes = [previousWarnings indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
            return [removedWarnings containsObject:obj];
        }];

        if (addedIndexes == nil && removedIndexes == nil) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [navBar updateWarningsByAddingAtIndexes:addedIndexes deletingAtIndexes:removedIndexes animated:YES];
        });
    }
}

#pragma mark - AUTNavigationBarWarningsDataSource

- (NSInteger)numberOfWarningsForNavigationBar:(AUTNavigationBar *)navigationBar {
    return self.warnings.count;
}

- (CGFloat)heightForWarningAtIndex:(NSInteger)index {
    return [self.class defaultWarningHeight];
}

- (void)configureWarningCell:(UITableViewCell *)cell atIndex:(NSInteger)index{
    NSString *title = self.warnings[index];
    cell.textLabel.text = title;
    
    cell.contentView.backgroundColor = UIColor.redColor;
    cell.textLabel.textColor = UIColor.whiteColor;
    cell.textLabel.backgroundColor = UIColor.clearColor;
}

@end

NS_ASSUME_NONNULL_END
