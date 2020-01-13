//
//  ViewController.m
//  popOptionViewDemo
//
//  Created by 张氏集团 Inc on 20/1/6.
//

#import "ViewController.h"
#import "XDPopOptionView.h"

@interface ViewController ()<XDPopOptionViewDelegate>

@property (nonatomic, strong) XDPopOptionView *leftPopView;

@property (nonatomic, strong) XDPopOptionView *rightPopView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1= [[UIView alloc] init];
    UIView *view2= [[UIView alloc] init];
    UIView *view3= [[UIView alloc] init];
    view1.backgroundColor = [UIColor redColor];
    view2.backgroundColor = [UIColor yellowColor];
    view3.backgroundColor = [UIColor greenColor];
    
    XDPopOptionConfiguration *leftconfiguration = [[XDPopOptionConfiguration alloc] init];
//    configuration.itemSize = ;
//    configuration.itemSpace = ;
//    configuration.topMargin = ;
//    configuration.bottomMargin = ;
//    configuration.popOptionMode = ;
//    configuration.animationDuration = ;
    
    XDPopOptionView *popView = [[XDPopOptionView alloc] initWithSubviews:@[view1, view2, view3] configuration:leftconfiguration];
    
    popView.frame = CGRectMake(15, 15, leftconfiguration.itemSize.width, leftconfiguration.itemSize.height);
    popView.delegate = self;
    
    self.leftPopView = popView;
    [self.view addSubview:popView];
    
    
    UIView *view4= [[UIView alloc] init];
    UIView *view5= [[UIView alloc] init];
    UIView *view6= [[UIView alloc] init];
    view4.backgroundColor = [UIColor redColor];
    view5.backgroundColor = [UIColor yellowColor];
    view6.backgroundColor = [UIColor greenColor];
    
    XDPopOptionConfiguration *rightConfiguration = [[XDPopOptionConfiguration alloc] init];
//    configuration.itemSize = ;
//    configuration.itemSpace = ;
//    configuration.topMargin = ;
//    configuration.bottomMargin = ;
    rightConfiguration.popOptionMode = XDPopOptionModeLeft;
//    configuration.animationDuration = ;
    
    XDPopOptionView *popView1 = [[XDPopOptionView alloc] initWithSubviews:@[view4, view5, view6] configuration:rightConfiguration];
    
    popView1.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - rightConfiguration.itemSize.width-15, [UIScreen mainScreen].bounds.size.height-rightConfiguration.itemSize.height-30, rightConfiguration.itemSize.width, rightConfiguration.itemSize.height);
    popView1.delegate = self;
    
    self.rightPopView = popView1;
    [self.view addSubview:popView1];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - XDPopOptionViewDelegate
- (void)popView:(XDPopOptionView *)popView selectedIndex:(NSUInteger)index {
    
    NSString *message = [NSString stringWithFormat:@"选中第%ld个试图，颜色是%@", index, popView.subOptionViews[index].backgroundColor];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选中的视图编号" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:true completion:^{
        [alertController performSelector:@selector(dismissViewControllerAnimated:completion:) withObject:nil afterDelay:1.5f];
    }];
    
    [popView dismiss];
}


@end
