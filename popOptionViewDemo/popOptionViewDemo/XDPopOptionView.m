//
//  XDPopOptionView.m
//  popOptionViewDemo
//
//  Created by 张氏集团 Inc on 20/1/6.
//

#import "XDPopOptionView.h"

@implementation XDPopOptionConfiguration

- (instancetype)init {
    if (self = [super init]) {

        self.itemSize = CGSizeMake(40, 40);
        self.popOptionMode = XDPopOptionModeRight;
        self.itemSpace = 10.0f;
        self.topMargin = 18.0f;
        self.bottomMargin = 18.0f;
        self.animationDuration = 0.8f;
    }
    
    return self;
}

+ (instancetype)defaultConfiguration {
  static __weak XDPopOptionConfiguration *instance;
    XDPopOptionConfiguration *strongInstance = instance;
  @synchronized(self){
      if (strongInstance == nil) {
          strongInstance = self.new;
          instance = strongInstance;
      }
  }
  return strongInstance;
}

@end

@interface XDPopOptionView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong, readwrite) NSArray<UIView *> *subOptionViews;

@end

@implementation XDPopOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        [self viewInit];
    }
    return self;
}

- (void)viewInit {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    [self addSubview:self.switchButton];
}

- (instancetype)initWithSubviews:(NSArray<UIView *> *)subviews configuration:(nonnull XDPopOptionConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.configuration = configuration;
        self.subOptionViews = subviews;
        [subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.tag = 100+idx;
            [self.scrollView addSubview:obj];
            obj.frame = CGRectMake(0+idx*(configuration.itemSize.width+configuration.itemSpace), 0, configuration.itemSize.width, configuration.itemSize.height);
            
            obj.userInteractionEnabled = true;
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(objTap:)];
            
            [obj addGestureRecognizer:tapGR];
        }];
        
        self.switchButton.frame = CGRectMake(0, 0, configuration.itemSize.width, configuration.itemSize.height);

        self.scrollView.frame = self.switchButton.frame;
       
        if (subviews.count == 0) {
            return self;
        }
        switch (configuration.popOptionMode) {
            case XDPopOptionModeLeft:{
                self.scrollView.contentSize = CGSizeMake(configuration.itemSize.width*subviews.count+configuration.itemSpace*(subviews.count-1), 0);
            }
                break;
            case XDPopOptionModeRight:{
                self.scrollView.contentSize = CGSizeMake(configuration.itemSize.width*subviews.count+configuration.itemSpace*(subviews.count-1), 0);
            }
                break;
            default:
                break;
        }
        
    }
    return self;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UIButton alloc] init];
        
        [_switchButton setImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
        [_switchButton setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateSelected];
        
        [_switchButton addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.alpha = 1;
        _scrollView.hidden = true;
//        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)show {
    self.hidden = false;
    self.scrollView.hidden = false;
    
    //计算位置及最大边界以防超出屏幕，
    //半圆+scrollview的contentsize宽+图标的宽+图标边界
    CGFloat radius = (self.configuration.topMargin+self.configuration.bottomMargin+self.configuration.itemSize.height)/2;
    CGFloat buttonOffset = 0.3*self.configuration.itemSize.width;
    CGFloat totalW = radius+self.scrollView.contentSize.width+self.configuration.itemSize.width+buttonOffset*2;
    
    self.layer.cornerRadius = radius;
    
    CGRect finishRect = self.frame;
    CGRect scrollViewRect = self.scrollView.frame;
    CGRect switchButtonRect = self.switchButton.frame;
    switch (self.configuration.popOptionMode) {
        case XDPopOptionModeLeft:{
            if (totalW > CGRectGetMaxX(self.frame)) {
                //超出边界
                finishRect.origin.x = 0;
                finishRect.size.width = CGRectGetMaxX(self.frame);
                
            } else {
                finishRect.origin.x = CGRectGetMaxX(self.frame)-totalW;
                finishRect.size.width = totalW;
            }
            switchButtonRect.origin.x = CGRectGetWidth(finishRect)-CGRectGetWidth(switchButtonRect)-buttonOffset;
            scrollViewRect.origin.x = radius;
            scrollViewRect.size.width = CGRectGetWidth(finishRect)-radius-CGRectGetWidth(switchButtonRect)-2*buttonOffset;
        }
            break;
        case XDPopOptionModeRight:{
            if (totalW > [UIScreen mainScreen].bounds.size.width-CGRectGetMinX(self.frame)) {
                finishRect.size.width = [UIScreen mainScreen].bounds.size.width-CGRectGetMinX(self.frame);
            } else {
                finishRect.size.width = totalW;
            }
            switchButtonRect.origin.x = buttonOffset;
            scrollViewRect.origin.x = buttonOffset*2+CGRectGetWidth(switchButtonRect);
            scrollViewRect.size.width = CGRectGetWidth(finishRect)-radius-CGRectGetWidth(switchButtonRect)-2*buttonOffset;
        }
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:self.configuration.animationDuration animations:^{
        self.switchButton.selected = true;
        self.scrollView.alpha = 1;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = finishRect;
        self.switchButton.frame = switchButtonRect;
        self.scrollView.frame = scrollViewRect;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    CGRect finishRect = self.frame;
    CGRect scrollViewRect = self.scrollView.frame;
    CGRect switchButtonRect = self.switchButton.frame;
    [self bringSubviewToFront:self.switchButton];
    switch (self.configuration.popOptionMode) {
        case XDPopOptionModeLeft:{
            finishRect.origin.x = CGRectGetMaxX(finishRect)-CGRectGetWidth(switchButtonRect);
            finishRect.size.width = CGRectGetWidth(switchButtonRect);
        }
            break;
        case XDPopOptionModeRight:{
            finishRect.size.width = CGRectGetWidth(switchButtonRect);
        }
            break;
        default:
            break;
    }
    switchButtonRect.origin.x = 0;
    scrollViewRect = switchButtonRect;
    [UIView animateWithDuration:self.configuration.animationDuration animations:^{
        self.switchButton.selected = false;
        self.backgroundColor = [UIColor clearColor];
        self.scrollView.alpha = 0;
        
        self.frame = finishRect;
        self.switchButton.frame = switchButtonRect;
        self.scrollView.frame = scrollViewRect;
    } completion:^(BOOL finished) {
        self.scrollView.hidden = true;
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancel:)]) {
            [self.delegate cancel:self];
        }
    }];
}

- (IBAction)objTap:(UITapGestureRecognizer *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popView:selectedIndex:)]) {
        [self.delegate popView:self selectedIndex:sender.view.tag-100];
    }
}

- (IBAction)switchButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self show];
    } else {
        [self dismiss];
    }
}

@end
