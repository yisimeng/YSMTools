//
//  UIView+Category.m
//  忆思梦
//
//  Created by duan on 15/6/9.
//  Copyright (c) 2015年 Yisimeng. All rights reserved.
//

#import "UIView+YSMCategory.h"

@implementation UIView (YSMCategory)
#pragma mark -- 设置tag值

static int tagOffSet = 10;
- (NSMutableArray *)getTagNameArray
{
    static NSMutableArray * tagNameArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tagNameArray = [[NSMutableArray alloc] initWithCapacity:1];
    });
    return tagNameArray;
};
/**
 *  为视图设置字符串tag值
 *
 *  @param name 字符串tag值
 */
- (void)setTagWithName:(NSString * _Nonnull )name
{
    NSMutableArray * tagNameArray = [self getTagNameArray];  //获取存放tag值得单例数组
    if (![tagNameArray containsObject:name]) {
        [tagNameArray addObject:name];          //将字符串tag值添加进数组
    }
    self.tag = ([tagNameArray indexOfObject:name] + 1) *tagOffSet;  //设置数值tag值得偏移
}
/**
 *  通过字符串tag值，获取对应的视图
 *
 *  @param name 字符串tag值
 *
 *  @return 字符串tag值对应的视图
 */
- (UIView * _Nonnull)viewWithTagName:(NSString * _Nonnull)name
{
    NSMutableArray * tagNameArray = [self getTagNameArray];
    if (tagNameArray.count == 0) {
        return nil;         //为了防止没有添加字符串tag值到数组中，引起崩溃
    }
    NSInteger tag = ([tagNameArray indexOfObject:name] + 1) *tagOffSet;   //通过获取到字符串tag值所在数组的的位置，而获取的存储的数值tag值
    return [self viewWithTag:tag];      //返回数值tag值所对应的视图
}

- (void)setLeft:(CGFloat)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
- (CGFloat)left{
    return CGRectGetMinX(self.frame);
}
/**
 *	@brief	获取左上角纵坐标
 *
 *	@return	坐标值
 */
- (CGFloat)top{
    return CGRectGetMinY(self.frame);
}
- (void)setTop:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
/**
 *	@brief	获取视图右下角横坐标
 *
 *	@return	坐标值
 */
- (CGFloat)right{
    return CGRectGetMaxX(self.frame);
}
-(void)setRight:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.x = right-frame.size.width;
    self.frame = frame;
}
/**
 *	@brief	获取视图右下角纵坐标
 *
 *	@return	坐标值
 */
- (CGFloat)bottom{
    return CGRectGetMaxY(self.frame);
}
-(void)setBottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom-frame.size.height;
    self.frame = frame;
}
/**
 *	@brief	获取视图宽度
 *
 *	@return	宽度值（像素）
 */
- (CGFloat)width{
    return CGRectGetWidth(self.frame);
}
-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
/**
 *	@brief	获取视图高度
 *
 *	@return	高度值（像素）
 */
- (CGFloat)height{
    return CGRectGetHeight(self.frame);
}
-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

/**
 *  视图中心x坐标
 *
 *  @return <#return value description#>
 */
- (CGFloat)centerX{
    return CGRectGetMidX(self.frame);
}
- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

/**
 *  视图中心y坐标
 *
 *  @return <#return value description#>
 */
- (CGFloat)centerY{
    return CGRectGetMidY(self.frame);
}
- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGPoint)origin{
    return CGPointMake(self.left, self.top);
}
- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size{
    return CGSizeMake(self.width, self.height);
}
- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (UIViewController * _Nonnull )viewController{
    for (UIView* next = [self superview];next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)addTarget:(nullable id)target action:(SEL _Nonnull)action{
    if (!self.userInteractionEnabled) {
        self.userInteractionEnabled = YES;
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

- (void)removeAllSubviews{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}
@end

@implementation UIView (YSMIBInspectable)

#pragma mark - setCornerRadius/borderWidth/borderColor
- (void)setCornerRadius:(NSInteger)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (NSInteger)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(NSInteger)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (NSInteger)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderHexRgb:(NSString *)borderHexRgb {
    NSScanner *scanner = [NSScanner scannerWithString:borderHexRgb];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return;
    self.layer.borderColor = [self colorWithRGBHex:hexNum].CGColor;
}

-(NSString *)borderHexRgb {
    return @"0xffffff";
}

- (void)setMasksToBounds:(BOOL)bounds {
    self.layer.masksToBounds = bounds;
}

- (BOOL)masksToBounds {
    return self.layer.masksToBounds;
}

#pragma mark - hexRgbColor
- (void)setHexRgbColor:(NSString *)hexRgbColor {
    NSScanner *scanner = [NSScanner scannerWithString:hexRgbColor];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return;
    self.backgroundColor = [self colorWithRGBHex:hexNum];
}

- (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


- (NSString *)hexRgbColor {
    return @"0xffffff";
}

#pragma mark - setOnePx
- (void)setOnePx:(BOOL)onePx {
    if (onePx) {
        CGRect rect = self.frame;
        rect.size.height = 1.0 / [UIScreen mainScreen].scale;
        self.frame = rect;
    }
}

- (BOOL)onePx {
    return self.onePx;
}

@end
