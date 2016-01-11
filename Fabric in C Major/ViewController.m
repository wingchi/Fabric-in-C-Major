//
//  ViewController.m
//  Fabric in C Major
//
//  Created by Stephen Wong on 1/11/16.
//  Copyright © 2016 Wingchi. All rights reserved.
//

#import "ViewController.h"
#import <TwitterKit/TwitterKit.h>

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)twitterLoginAction:(UIButton *)sender {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
