//
//  RegisterOrLoginViewController.h
//  demo
//
//  Created by ayy on 2018/10/25.
//  Copyright © 2018年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Login,
    verify
} OperationType;

@interface RegisterOrLoginViewController : UIViewController

@property (nonatomic, assign) OperationType type;

@end

