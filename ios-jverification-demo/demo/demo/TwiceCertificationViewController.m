//
//  TwiceCertificationViewController.m
//  demo
//
//  Created by ayy on 2018/10/25.
//  Copyright © 2018年 Test. All rights reserved.
//

#import "TwiceCertificationViewController.h"
#import "ResultViewController.h"
#import "JVERIFICATIONService.h"
#import "UIView+Toast.h"

@interface TwiceCertificationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIView *failedView;
@property (weak, nonatomic) IBOutlet UIView *certifyView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonnull, copy)NSString *number;

@end

@implementation TwiceCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //从缓存取出h验证过的号码
    self.number = [[NSUserDefaults standardUserDefaults] objectForKey:@"JVerificationNumber"];
    if (self.number.length == 11) {
        NSString *placeholder = [self.number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.numberTF.placeholder = placeholder;
    }
    self.failedView.hidden = YES;
    self.alertView.hidden = YES;
    self.resultLabel.text = @"";
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//
- (IBAction)payBtnClick:(UIButton *)sender {
    
    [self.view makeToastActivity:CSToastPositionCenter];
    JVAuthEntity *entity = [[JVAuthEntity alloc] init];
    //如果没有输入，就用缓存已验证的号码
    if (self.numberTF.text.length == 0 && self.number.length) {
        entity.number = self.number;
    }else {
        entity.number = self.numberTF.text;
    }
    
    [JVERIFICATIONService verifyNumber:entity result:^(NSDictionary *result) {
        NSLog(@"verify result:%@", result);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            //验证成功
            if ([result[@"code"] integerValue] == 1000) {
                [[NSUserDefaults standardUserDefaults] setObject:entity.number forKey:@"JVerificationNumber"];
                ResultViewController *resultVC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"result"];
                resultVC.resultType = PayType;
                [self.navigationController pushViewController:resultVC animated:YES];
            }else {
                //展示认证失败的界面
                self.certifyView.hidden = YES;
                self.failedView.hidden = NO;
                NSMutableString *str = [@"" mutableCopy];
                if (result.count > 0) {
                    for (NSString *key in result) {
                        [str appendFormat:@"%@=%@, ", key, result[key]];
                    }
                }
                self.resultLabel.text = [NSString stringWithFormat:@"%@",str];
                self.alertView.hidden = NO;
                self.tipLabel.hidden = YES;
            }
        });
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
