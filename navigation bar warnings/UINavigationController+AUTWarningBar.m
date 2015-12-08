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

- (NSUInteger)warningsCount {
    NSNumber *count = objc_getAssociatedObject(self, _cmd);
    
    if (count == nil) {
        count = @0;
        objc_setAssociatedObject(self, _cmd, count, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    return count.integerValue;
}

- (void)setWarningsCount:(NSUInteger)count {
    NSUInteger currentCount = [self warningsCount];
    
    if (currentCount != count) {
        objc_setAssociatedObject(self, @selector(warningsCount), @(count), OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    return;
}

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
        objc_setAssociatedObject(self, @selector(defaultWarningHeight), @(height), OBJC_ASSOCIATION_COPY_NONATOMIC);
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
        [self setWarningHeight:[self heightForWarningsTablePreUpdate] forNavigationBar:navBar];
        
        NSMutableArray *addedWarnings = [NSMutableArray arrayWithArray:warnings];
        [addedWarnings removeObjectsInArray:previousWarnings];
        
        NSIndexSet *addedIndexes = [warnings indexesOfObjectsPassingTest:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [addedWarnings containsObject:obj];
        }];
        
        NSMutableArray *removedWarnings = [NSMutableArray arrayWithArray:previousWarnings];
        [removedWarnings removeObjectsInArray:warnings];
        
        NSIndexSet *removedIndexes = [previousWarnings indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
            return [removedWarnings containsObject:obj];
        }];

        if (addedIndexes == nil && removedIndexes == nil) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setWarningsCount:warnings.count];

            UIView *topView = self.topViewController.view;
            NSIndexSet *scrollViewIndexes = [topView.subviews indexesOfObjectsPassingTest:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                *stop = [obj isKindOfClass:UIScrollView.class];
                return *stop;
            }];
            
            CGFloat offset = ((NSInteger)addedIndexes.count - (NSInteger)removedIndexes.count)*30.0;
            UIScrollView *scrollView = nil;
            
            if ([topView isKindOfClass:UIScrollView.class] || scrollViewIndexes.count > 0) {
                if ([topView isKindOfClass:UIScrollView.class]) {
                    scrollView = (UIScrollView *)topView;
                } else {
                    scrollView = topView.subviews[scrollViewIndexes.firstIndex];
                }

            }
            
            CGFloat navBarHeight = [self heightForWarningsTablePreUpdate];
            CGRect curtainFrame = CGRectMake(0, navBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - navBarHeight);
            UIView *curtain = [self.topViewController.view resizableSnapshotViewFromRect:curtainFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];

            curtain.frame = curtainFrame;
            [self.view insertSubview:curtain atIndex:1];
            [UIView animateWithDuration:0.2 animations:^{
                [navBar updateWarningsByAddingAtIndexes:addedIndexes deletingAtIndexes:removedIndexes];
                if (scrollView != nil && scrollView.contentOffset.y > 0) {
                    CGPoint contentOffset = scrollView.contentOffset;
                    contentOffset.y += offset;
                    scrollView.contentOffset = contentOffset;
                } else {
                    curtain.frame = CGRectOffset(curtain.frame, 0, offset);
                }
            } completion:^(BOOL finished) {
                [self setWarningHeight:[self heightForWarningsTablePostUpdate] forNavigationBar:navBar];
                [UIView animateWithDuration:0.2 animations:^{
                    curtain.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [curtain removeFromSuperview];
                }];
            }];
            
            
        });
    }
}

- (void)setWarningHeight:(CGFloat)height forNavigationBar:(AUTNavigationBar *)navbar {
    NSLog(@"%@ %f", NSStringFromSelector(_cmd), height);
    [navbar setWarningHeight:height];
    [self setNavigationBarHidden:YES animated:NO];
    [self setNavigationBarHidden:NO animated:NO];
}

#pragma mark - AUTNavigationBarWarningsDataSource

- (CGFloat)heightForWarningsTablePreUpdate {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return [self warningsCount] * [self.class defaultWarningHeight];
}

- (CGFloat)heightForWarningsTablePostUpdate {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return self.warnings.count * [self.class defaultWarningHeight];
    
}

- (NSInteger)numberOfWarningsForNavigationBar:(AUTNavigationBar *)navigationBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return [self warningsCount];
}

- (CGFloat)heightForWarningAtIndex:(NSInteger)index {
    NSLog(@"%@: %ld", NSStringFromSelector(_cmd), (long)index);
    return [self.class defaultWarningHeight];
}

- (void)configureWarningCell:(UITableViewCell *)cell atIndex:(NSInteger)index{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSString *title = self.warnings[index];
    cell.textLabel.text = title;
    
    cell.contentView.backgroundColor = UIColor.redColor;
    cell.textLabel.textColor = UIColor.whiteColor;
    cell.textLabel.backgroundColor = UIColor.clearColor;
}

@end

NS_ASSUME_NONNULL_END
