//
//  CollectionViewController.m
//  navigation bar warnings
//
//  Created by Engin Kurutepe on 27/11/15.
//  Copyright © 2015 Engin Kurutepe. All rights reserved.
//

#import "AUTCollectionViewController.h"
#import "AUTColorViewController.h"
#import "UINavigationController+AUTWarningBar.h"

@interface AUTCollectionViewController ()

@end

@implementation AUTCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.navigationItem.title = @"Collection";
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAddWarning:)],[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(didTapRemoveWarning:)]];
    

}

- (void)didTapAddWarning:(UIBarButtonItem *)item {
    self.navigationController.warnings = [@[@"important warning"] arrayByAddingObjectsFromArray:self.navigationController.warnings];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)didTapRemoveWarning:(UIBarButtonItem *)item {
    NSArray *warnings = self.navigationController.warnings;
    
    if (warnings.count == 0) return;
    
    NSRange subRange = NSMakeRange(0, warnings.count-1);
    self.navigationController.warnings = [warnings subarrayWithRange:subRange];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath {
    CGFloat shade = (1.0+(indexPath.item%5))/8.0;
    return [UIColor colorWithWhite:shade alpha:1.0];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 150;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [self colorForIndexPath:indexPath];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = [self colorForIndexPath:indexPath];
    
    AUTColorViewController *colorViewController = [[AUTColorViewController alloc] init];
    colorViewController.color = color;
    
    [self.navigationController pushViewController:colorViewController animated:YES];
}


@end
