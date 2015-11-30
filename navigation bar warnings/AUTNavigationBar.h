//
//  AUTNavigationBar.h
//  navigation bar warnings
//
//  Created by Engin Kurutepe on 27/11/15.
//  Copyright © 2015 Engin Kurutepe. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol AUTNavigationBarWarningsDataSource;

@interface AUTNavigationBar : UINavigationBar

@property (nullable, nonatomic, weak) id<AUTNavigationBarWarningsDataSource> dataSource;

@end

@protocol AUTNavigationBarWarningsDataSource <NSObject>

- (NSInteger)numberOfWarningsForNavigationBar:(AUTNavigationBar *)navigationBar;

- (CGFloat)heightForWarningAtIndex:(NSInteger)index;

- (void)configureWarningCell:(UITableViewCell *)cell atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
