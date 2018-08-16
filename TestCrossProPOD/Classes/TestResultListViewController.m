//
//  TestResultListViewController.m
//  TestCrossProPOD
//
//  Created by Kumar Abnit on 16/08/18.
//  Copyright © 2018 Kumar Abnit. All rights reserved.
//

#import "TestResultListViewController.h"
#import "TPMGAlertView.h"
@interface TestResultListViewController ()
@property (weak, nonatomic) IBOutlet RangeSlider *rangeSlider;

@end

@implementation TestResultListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [TPMGAlertView showAlertWithMessage:nil title:@"This is list class" cancelButtonTitle:TPMGAlertViewCancelButtonTitleOK];
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
