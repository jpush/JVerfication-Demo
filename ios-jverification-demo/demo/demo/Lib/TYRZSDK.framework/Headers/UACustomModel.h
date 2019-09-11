//
//  UACustomModel.h
//  Test
//
//  Created by issuser on 2018/5/18.
//  Copyright © 2018年 林涛. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UACustomModel : NSObject

/**
 版本注意事项:
 授权页面的各个控件的Y轴默认值都是以375*667屏幕为基准 系数 ： 当前屏幕高度/667
 1、当设置Y轴并有效时 偏移量OffsetY属于相对导航栏的绝对Y值
 2、（负数且超出当前屏幕无效）为保证各个屏幕适配,请自行设置好Y轴在屏幕上的比例（推荐:当前屏幕高度/667）
 */

#pragma mark -----------------------------授权页面----------------------------------

#pragma mark VC必传属性
/**1、当前VC,注意:要用一键登录这个值必传*/
@property (nonatomic,strong) UIViewController *currentVC;
#pragma mark 自定义控件
/**2、授权界面自定义控件View的Block*/
@property (nonatomic,copy) void(^authViewBlock)(UIView *customView);
/**3、授权界面背景图片*/
@property (nonatomic,strong) UIImage *authPageBackgroundImage;
#pragma mark 导航栏
/**4、导航栏颜色*/
@property (nonatomic,strong) UIColor *navColor;
/**5、状态栏着色样式*/
@property (nonatomic,assign) UIBarStyle barStyle;
/**6、导航栏标题*/
@property (nonatomic,strong) NSAttributedString *navText;
/**7、导航返回图标(尺寸根据图片大小)*/
@property (nonatomic,strong) UIImage *navReturnImg;

/**8、导航栏自定义（适配全屏图片）*/
@property (nonatomic,assign) BOOL navCustom;

/**9、导航栏右侧自定义控件（导航栏传 UIBarButtonItem对象 自定义传非UIBarButtonItem ）*/
@property (nonatomic,strong) id navControl;

#pragma mark 图片设置
/**10、LOGO图片*/
@property (nonatomic,strong) UIImage *logoImg;
/**11、LOGO图片宽度*/
@property (nonatomic,assign) CGFloat logoWidth;
/**12、LOGO图片高度*/
@property (nonatomic,assign) CGFloat logoHeight;
/**13、LOGO图片偏移量*/
@property (nonatomic,assign) CGFloat logoOffsetY;
/**14、LOGO图片隐藏*/
@property (nonatomic,assign) BOOL logoHidden;

#pragma mark 登录按钮
/**15、登录按钮文本*/
@property (nonatomic,strong) NSString *logBtnText;
/**16、登录按钮Y偏移量*/
@property (nonatomic,assign) CGFloat logBtnOffsetY;
/**17、登录按钮文本颜色*/
@property (nonatomic,strong) UIColor *logBtnTextColor;
/**18、登录按钮背景图片添加到数组(顺序如下)
 @[激活状态的图片,失效状态的图片,高亮状态的图片]
*/
@property (nonatomic,strong) NSArray <UIImage*>*logBtnImgs;

#pragma mark 号码框设置
/**19、手机号码字体颜色*/
@property (nonatomic,strong) UIColor *numberColor;
/**20、手机号码字体大小*/
@property (nonatomic,assign) CGFloat numberSize;
/**21、隐藏切换账号按钮*/
@property (nonatomic,assign) BOOL swithAccHidden;
/**22、切换账号字体颜色*/
@property (nonatomic,strong) UIColor *swithAccTextColor;
/**23、设置切换账号相对于标题栏下边缘y偏移*/
@property (nonatomic,assign) CGFloat switchOffsetY;
/**24、号码栏Y偏移量*/
@property (nonatomic,assign) CGFloat numFieldOffsetY;

#pragma mark 隐私条款
/**25、复选框未选中时图片*/
@property (nonatomic,strong) UIImage *uncheckedImg;
/**26、复选框选中时图片*/
@property (nonatomic,strong) UIImage *checkedImg;
/**27、隐私条款一:数组（务必按顺序）
 @[条款名称,条款链接]
 */
@property (nonatomic,strong) NSArray *appPrivacyOne;
/**28、隐私条款二:数组（务必按顺序）
 @[条款名称,条款链接]
 */
@property (nonatomic,strong) NSArray *appPrivacyTwo;
/**29、隐私条款名称颜色
 @[基础文字颜色,条款颜色]
 */
@property (nonatomic,strong) NSArray *appPrivacyColor;
/**30、隐私条款Y偏移量(注:此属性为与屏幕底部的距离)*/
@property (nonatomic,assign) CGFloat privacyOffsetY;

/**31、隐私条款check框默认状态 默认:NO */
@property (nonatomic,assign) BOOL privacyState;

#pragma mark 底部标识Title
/**32、slogan偏移量Y*/
@property (nonatomic,assign) CGFloat sloganOffsetY;
/**33、slogan文字颜色*/
@property (nonatomic,strong) UIColor *sloganTextColor;

#pragma mark -----------------------------------短信页面-----------------------------------

/**34、SDK短信验证码开关
 （默认为NO,不使用SDK提供的短验直接回调 ,YES:使用SDK提供的短验）
 为NO时,授权界面的切换账号按钮直接返回字典:200060 和 导航栏 “NavigationController”*/
@property (nonatomic,assign) BOOL SMSAuthOn;
/**35、短验页面导航栏标题*/
@property (nonatomic,strong) NSAttributedString *SMSNavText;
/**36、登录按钮文本内容*/
@property (nonatomic,strong) NSString *SMSLogBtnText;
/**37、登录按钮文本颜色*/
@property (nonatomic,strong) UIColor *SMSLogBtnTextColor;
/**38、短验登录按钮图片请按顺序添加到数组(顺序如下)
 @[激活状态的图片,失效状态的图片,高亮状态的图片]
 */
@property (nonatomic,strong) NSArray *SMSLogBtnImgs;
/**39、获取验证码按钮图片请按顺序添加到数组(顺序如下)
 @[激活状态的图片,失效状态的图片]
 */
@property (nonatomic,strong) NSArray *SMSGetCodeBtnImgs;
/**40、短验界面背景*/
@property (nonatomic,strong) UIImage *SMSBackgroundImage;

@end
