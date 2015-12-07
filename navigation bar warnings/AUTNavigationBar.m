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

@property (nonatomic, assign) CGFloat lastWarningHeight;

@end

@implementation AUTNavigationBar

- (UITableView *)warningsTableView {
    if (_warningsTableView == nil) {
        _warningsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _warningsTableView.hidden = YES;
        _warningsTableView.dataSource = self;
        _warningsTableView.delegate = self;
        _warningsTableView.scrollsToTop = NO;
        _warningsTableView.scrollEnabled = NO;
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
        self.warningsTableView.transform = CGAffineTransformInvert(self.transform);
        if (self.warningsTableView.frame.size.width == 0) {
            self.warningsTableView.frame = CGRectMake(0, originalSize.height, originalSize.width, 0);
        }

        NSLog(@"%@ content size: %@", NSStringFromSelector(_cmd), NSStringFromCGSize(self.warningsTableView.contentSize));
    }
    else {
        self.warningsTableView.hidden = YES;
    }

    return originalSize;
}

- (NSArray *)indexPathsFromIndexSet:(NSIndexSet *)indexSet {
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }];
    return [indexPaths copy];
}

- (void)updateWarningsByAddingAtIndexes:(NSIndexSet *)addedIndexes deletingAtIndexes:(NSIndexSet *)deletedIndexes animated:(BOOL)animated {
    
    NSArray *addedIndexPaths = [self indexPathsFromIndexSet:addedIndexes];
    NSArray *deletedIndexPaths = [self indexPathsFromIndexSet:deletedIndexes];
    
    CGFloat addedHeight = 0;
    
    for (NSIndexPath *indexPath in addedIndexPaths) {
        addedHeight += [self.dataSource heightForWarningAtIndex:indexPath.item];
    }
    
    CGFloat deletedHeight = 0;
    
    for (NSIndexPath *indexPath in deletedIndexPaths) {
        deletedHeight += [self.dataSource heightForWarningAtIndex:indexPath.item];
    }
    
    CGRect frame = self.warningsTableView.frame;
    
    frame.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(frame)+addedHeight-deletedHeight);
    
    [UIView beginAnimations:@"warning table updates" context:nil];
    self.warningsTableView.frame = frame;
    [self.warningsTableView beginUpdates];
    [self.warningsTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.warningsTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.warningsTableView deleteRowsAtIndexPaths:deletedIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [self.warningsTableView insertRowsAtIndexPaths:addedIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
    
    self.lastWarningHeight = CGRectGetHeight(frame);
    
    [self.warningsTableView endUpdates];
    [UIView commitAnimations];
    
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
