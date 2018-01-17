//
//  ViewController.m
//  VeChat
//
//  Created by csj on 2018/1/15.
//  Copyright © 2018年 csj. All rights reserved.
//

#import "ViewController.h"
#import "XMPPHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [XMPPManager shareManager];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
