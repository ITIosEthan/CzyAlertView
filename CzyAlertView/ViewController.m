//
//  ViewController.m
//  CzyAlterView
//
//  Created by macOfEthan on 17/9/26.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#import "ViewController.h"
#import "CzyAlertView.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *click;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.click rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:@"属性字符串动态增加高度"];
        [s addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, s.length)];
        [s addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, s.length)];
        
        CzyAlertView *alertView = [CzyAlertView shareInstance];
        
        [alertView showAlertWithTitle:@"很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长" andAlertTitleColor:[UIColor redColor] andAlertTitleFont:[UIFont boldSystemFontOfSize:18] andAlertTitleH:180 andButtonNames:@[s,@"非属性字符串",@"非属性字符串"] andChooseFunction:^(NSInteger tag) {
            
            NSLog(@"tag = %ld", tag);

        } andCancel:^{
            
            NSLog(@"cancel");
        }];
        
        alertView.maskViewColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }];
}




@end
