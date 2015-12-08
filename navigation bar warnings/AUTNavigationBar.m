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

@property (nonatomic, assign) CGFloat warningHeight;

@end

@implementation AUTNavigationBar

- (UITableView *)warningsTableView {
    if (_warningsTableView == nil) {
        _warningsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _warningsTableView.dataSource = self;
        _warningsTableView.delegate = self;
        _warningsTableView.scrollsToTop = NO;
        _warningsTableView.scrollEnabled = NO;
        _warningsTableView.backgroundColor = [UIColor clearColor];
        _warningsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_warningsTableView registerClass:UITableViewCell.class forCellReuseIdentifier:CellIdentifier];
        [self addSubview:_warningsTableView];
    }
    
    return _warningsTableView;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize originalSize = [super sizeThatFits:size];
    
    originalSize.height += self.warningHeight;
    
    [self setTransform:CGAffineTransformMakeTranslation(0, -(self.warningHeight))];
    self.warningsTableView.transform = CGAffineTransformInvert(self.transform);
    self.warningsTableView.frame = CGRectMake(0, originalSize.height, originalSize.width, self.warningHeight);

    NSLog(@"%@ size: %@", NSStringFromSelector(_cmd), NSStringFromCGSize(originalSize));
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

- (void)setWarningHeight:(CGFloat)height {
    if (_warningHeight != height) {
        _warningHeight = height;
    }
}

- (void)updateWarningsByAddingAtIndexes:(NSIndexSet *)addedIndexes deletingAtIndexes:(NSIndexSet *)deletedIndexes {
    NSLog(@"%@", NSStringFromSelector(_cmd));
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

    self.warningsTableView.frame = frame;
    [self.warningsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
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
