//
//  AUTColorViewController.m
//  navigation bar warnings
//
//  Created by Engin Kurutepe on 27/11/15.
//  Copyright © 2015 Engin Kurutepe. All rights reserved.
//

#import "AUTColorViewController.h"

@interface AUTColorViewController ()

@end

@implementation AUTColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.view.backgroundColor = _color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
