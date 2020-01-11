//
//  XDPopOptionView.h
//  popOptionViewDemo
//
//  Created by 张氏集团 Inc on 20/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XDPopOptionView;

typedef enum : NSUInteger {
    XDPopOptionModeLeft    = 1,//向左弹出
    XDPopOptionModeRight   = 2,//向右弹出
} XDPopOptionMode;

@interface XDPopOptionConfiguration : NSObject

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) CGFloat itemSpace;

@property (nonatomic, assign) CGFloat topMargin;

@property (nonatomic, assign) CGFloat bottomMargin;

/// default is XDPopOptionModeRight
@property (nonatomic, assign) XDPopOptionMode popOptionMode;

@property (nonatomic, assign) NSTimeInterval animationDuration;


+ (instancetype)defaultConfiguration;

@end


@protocol XDPopOptionViewDelegate <NSObject>

- (void)popView:(XDPopOptionView *)popView selectedIndex:(NSUInteger)index;

@optional
- (void)cancel:(XDPopOptionView *)popView;

@end

@interface XDPopOptionView : UIView

@property (nonatomic, assign) id<XDPopOptionViewDelegate> delegate;

@property (nonatomic, strong) XDPopOptionConfiguration *configuration;

/// 开关
@property (nonatomic, strong) UIButton *switchButton;

/// 控件大小
@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, strong, readonly) NSArray<UIView *> *subOptionViews;

- (instancetype)initWithSubviews:(NSArray<UIView *> *)subviews configuration:(XDPopOptionConfiguration *)configuration;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
