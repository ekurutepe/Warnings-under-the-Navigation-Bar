//
//  AUTNavigationBar.m
//  navigation bar warnings
//
//  Created by Engin Kurutepe on 27/11/15.
//  Copyright © 2015 Engin Kurutepe. All rights reserved.
//

#import "AUTNavigationBar.h"

#import "UINavigationItem+AUTWarningBar.h"

const CGFloat DefaultWarningHeight = 30;

@interface AUTNavigationBar ()

@property (nonatomic, assign) CGFloat currentWarningHeight;

@end

@implementation AUTNavigationBar


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//
- (CGSize)sizeThatFits:(CGSize)size {
    CGSize tallerSize = [super sizeThatFits:size];
    
    if (self.topItem.warnings != nil) {
        tallerSize.height += DefaultWarningHeight;
        self.currentWarningHeight = DefaultWarningHeight;
    }
    else {
        self.currentWarningHeight = 0;
    }
    
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), NSStringFromCGSize(tallerSize));
    return tallerSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setTransform:CGAffineTransformMakeTranslation(0, -(self.currentWarningHeight))];
    
    for (UIView *view in self.subviews) {
        NSLog(@"%@: %@", NSStringFromClass(view.class), NSStringFromCGRect(view.frame));
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            
            CGRect bounds = [self bounds];
            CGRect frame = [view frame];
            frame.origin.y = bounds.origin.y + self.currentWarningHeight - 20.f;
            frame.size.height = bounds.size.height + 20.f;
            
            [view setFrame:frame];
            
        }
    }
}

@end
