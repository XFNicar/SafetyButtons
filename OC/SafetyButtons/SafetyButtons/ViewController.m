//
//  ViewController.m
//  SafetyButtons
//
//  Created by YanYi on 2018/3/1.
//  Copyright © 2018年 YanYi. All rights reserved.
//

#import "ViewController.h"
#import "SafetyButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SafetyButton *button = [SafetyButton buttonWithType:UIButtonTypeCustom];
//    [button setSafetyDuration:@2 action:^{
//        NSLog(@"响应一次有效的点击");
//    }];
    
    [button setEffectivityDuration:@2 action:^{
        NSLog(@"这是一次有效响应");
    }];
    
    [self.view addSubview:button];
    button.frame = CGRectMake(0, 0, 200, 50);
    [button setTitle:@"安全点击按钮" forState:UIControlStateNormal];
    button.center = self.view.center;
    button.backgroundColor = [UIColor grayColor];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
