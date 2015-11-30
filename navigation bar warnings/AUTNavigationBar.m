//
//  AUTNavigationBar.m
//  navigation bar warnings
//
//  Created by Engin Kurutepe on 27/11/15.
//  Copyright © 2015 Engin Kurutepe. All rights reserved.
//

#import "AUTNavigationBar.h"

#import "UINavigationController+AUTWarningBar.h"

NS_ASSUME_NONNULL_BEGIN

NSString *CellIdentifier = @"WarningCell";

@interface AUTNavigationBar () <UITableViewDataSource, UITableViewDelegate>

@property (null_resettable, nonatomic, strong) UITableView *warningsTableView;

@end

@implementation AUTNavigationBar

- (UITableView *)warningsTableView {
    if (_warningsTableView == nil) {
        _warningsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _warningsTableView.hidden = YES;
        _warningsTableView.dataSource = self;
        _warningsTableView.delegate = self;
        [_warningsTableView registerClass:UITableViewCell.class forCellReuseIdentifier:CellIdentifier];
        [self addSubview:_warningsTableView];
    }
    
    return _warningsTableView;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize originalSize = [super sizeThatFits:size];

    CGFloat warningHeight = 0;
    
    if (self.dataSource != nil) {
        NSInteger warningCount = [self.dataSource numberOfWarningsForNavigationBar:self];
        
        for (int idx = 0; idx < warningCount; idx++) {
            warningHeight += [self.dataSource heightForWarningAtIndex:idx];
        }
    }
    
    originalSize.height += warningHeight;
    
    [self setTransform:CGAffineTransformMakeTranslation(0, -(warningHeight))];
    
    if (warningHeight > 0) {
        self.warningsTableView.hidden = NO;
        self.warningsTableView.frame = CGRectMake(0, originalSize.height, originalSize.width, warningHeight);
        self.warningsTableView.transform = CGAffineTransformInvert(self.transform);
        [self.warningsTableView reloadData];
    }
    else {
        self.warningsTableView.hidden = YES;
    }

    return originalSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            view.transform = CGAffineTransformInvert(self.transform);
        }
    }
}

#pragma mark - UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfWarningsForNavigationBar:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self.dataSource configureWarningCell:cell atIndex:indexPath.item];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource heightForWarningAtIndex:indexPath.item];
}

@end

NS_ASSUME_NONNULL_END
