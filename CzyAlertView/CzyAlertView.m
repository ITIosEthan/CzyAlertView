//  CzyAlertView.m
//  CzyAlterView
//  Created by macOfEthan on 17/9/26.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//  Github:https://github.com/ITIosEthan
//  简书：http://www.jianshu.com/u/1d52648daace
/**
 *   █████▒█    ██  ▄████▄   ██ ▄█▀   ██████╗ ██╗   ██╗ ██████╗
 * ▓██   ▒ ██  ▓██▒▒██▀ ▀█   ██▄█▒    ██╔══██╗██║   ██║██╔════╝
 * ▒████ ░▓██  ▒██░▒▓█    ▄ ▓███▄░    ██████╔╝██║   ██║██║  ███╗
 * ░▓█▒  ░▓▓█  ░██░▒▓▓▄ ▄██▒▓██ █▄    ██╔══██╗██║   ██║██║   ██║
 * ░▒█░   ▒▒█████▓ ▒ ▓███▀ ░▒██▒ █▄   ██████╔╝╚██████╔╝╚██████╔╝
 *  ▒ ░   ░▒▓▒ ▒ ▒ ░ ░▒ ▒  ░▒ ▒▒ ▓▒   ╚═════╝  ╚═════╝  ╚═════╝
 */

#ifndef CZY
#define CZY @"CZY"
#define CZY_NORMAL_CELL_HEIGHT 50
#define CZY_SECTION_PADDING 10
#define CZY_KEY_WINDOW [UIApplication sharedApplication].keyWindow
#define CZY_FULL_WIDTH [UIScreen mainScreen].bounds.size.width
#define CZY_FULL_HEIGHT [UIScreen mainScreen].bounds.size.height
#endif

#import "CzyAlertView.h"
#import <UIKit/UIKit.h>

@interface CzyAlertViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *contentsLab;
@property (nonatomic, assign) CGFloat cellH;
@property (nonatomic, assign) CGFloat attributeFontPoint;

@end

@implementation CzyAlertViewCell

#pragma mark - Setter
- (void)setAttributeFontPoint:(CGFloat)attributeFontPoint
{
    _attributeFontPoint = attributeFontPoint;
    
    /**传入的是属性字符串情况更新frame*/
    if (_attributeFontPoint) {
        _contentsLab.frame = CGRectMake(12, _attributeFontPoint/14*CZY_NORMAL_CELL_HEIGHT/2-_attributeFontPoint/2, CZY_FULL_WIDTH-24, _attributeFontPoint);
    }
}

- (void)setCellH:(CGFloat)cellH
{
    _cellH = cellH;
    
    if (_cellH) {
        _contentsLab.frame = CGRectMake(12, 0, CZY_FULL_WIDTH-24, _cellH);
    }

}

#pragma mark - initWithStyle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self czyAlertViewCellUI];
    }
    return self;
}

#pragma mark - UI
- (void)czyAlertViewCellUI
{
    self.separatorInset = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _contentsLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, CZY_FULL_WIDTH-24, CGRectGetHeight(self.bounds))];
    _contentsLab.numberOfLines = 0;
    _contentsLab.lineBreakMode = NSLineBreakByTruncatingTail;
    _contentsLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_contentsLab];
}

@end


@interface CzyAlertView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
/**背景图*/
@property (nonatomic, strong) UIView *maskView;
/**功能按钮*/
@property (nonatomic, strong) NSArray *buttonNames;
/**弹框标题*/
@property (nonatomic, strong) NSString *alertTitle;
@property (nonatomic, strong) UIFont *alertTitleFont;
@property (nonatomic, strong) UIColor *alertTitleColor;

/**弹框内容高度*/
@property (nonatomic, assign) CGFloat titleH;

/**取消*/
@property (nonatomic, copy) CzyCancel cancel;
/**选择功能*/
@property (nonatomic, copy) CzyChooseFunction chooseFunction;

@end

@implementation CzyAlertView
static CzyAlertView *alerter = nil;

#pragma mark - Getter
- (NSArray *)buttonNames
{
    if (!_buttonNames) {
        self.buttonNames = [NSArray new];
    }
    return _buttonNames;
}

#pragma mark - Setter
- (void)setMaskViewColor:(UIColor *)maskViewColor
{
    _maskViewColor = maskViewColor;
    
    _maskView.backgroundColor = _maskViewColor;
}

#pragma mark - 单例
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alerter = [CzyAlertView new];
    });
    return alerter;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (alerter == nil) {
        
        alerter = [super allocWithZone:zone];
    }
    return alerter;
}

#pragma mark - UI
- (void)tbInit
{
    if ([self alreadyExsit]) {
        return;
    }
    
    CGFloat tbHeight = [self tableViewHeight];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CZY_FULL_HEIGHT-tbHeight, CZY_FULL_WIDTH, tbHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [CZY_KEY_WINDOW addSubview:_tableView];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CZY_FULL_WIDTH, CZY_FULL_HEIGHT-tbHeight)];
    _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    _maskView.userInteractionEnabled = YES;
    [CZY_KEY_WINDOW addSubview:_maskView];
    
    UITapGestureRecognizer *dimiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_maskView addGestureRecognizer:dimiss];
    
    [_tableView registerClass:[CzyAlertViewCell class] forCellReuseIdentifier:NSStringFromClass([CzyAlertViewCell class])];
}

#pragma mark - 弹框入口
- (void)showAlertWithTitle:(NSString *)alertTitle andAlertTitleColor:(UIColor *)alertTitleColor andAlertTitleFont:(UIFont *)alertTitleFont andAlertTitleH:(CGFloat)titleH andButtonNames:(NSArray *)buttonNames andChooseFunction:(CzyChooseFunction)chooseFunction andCancel:(CzyCancel)cancel
{
    if ([self alreadyExsit]) {
        return;
    }
    
    _buttonNames = buttonNames;
    _alertTitle = alertTitle;
    _alertTitleFont = alertTitleFont;
    _alertTitleColor = alertTitleColor;
    _titleH = titleH;
    _chooseFunction = chooseFunction;
    _cancel = cancel;
    
    [alerter tbInit];
}


#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return 1;
            break;
            
        default:
            return 1 + _buttonNames.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CzyAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CzyAlertViewCell class])];
    if (cell == nil) {
        cell = [[CzyAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CzyAlertViewCell class])];
    }
    
    if (indexPath.section == 1) {
        cell.contentsLab.text = @"取消";
    }else{
        /**弹框标题*/
        if (indexPath.row == 0) {
            cell.contentsLab.text = _alertTitle;
            cell.contentsLab.font = _alertTitleFont;
            cell.contentsLab.textColor = _alertTitleColor;
            cell.cellH = _titleH ? _titleH : CZY_NORMAL_CELL_HEIGHT;
        }else{
            /**功能区域*/
            id obj = _buttonNames[indexPath.row-1];
            
            /**类型*/
            if ([obj isKindOfClass:[NSAttributedString class]]) {
                
                NSAttributedString *attributeStr = (NSAttributedString *)_buttonNames[indexPath.row-1];
                cell.contentsLab.attributedText = attributeStr;
                CGFloat fontPoint = [self fontOfAttributeString:attributeStr];
                cell.attributeFontPoint = fontPoint;
                
            }else{
                
                NSString *normalStr = (NSString *)obj;
                cell.contentsLab.text = normalStr;
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return;
        }
        
        /**选择功能*/
        if (self.chooseFunction) {
            self.chooseFunction(indexPath.row);
        }
        
        [self dismiss];
        
    }else if (indexPath.section == 1){
        
        /**取消*/
        if (self.cancel) {
            self.cancel();
        }
        
        [self dismiss];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return .1f;
            break;
            
        default:
            return CZY_SECTION_PADDING;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**标题*/
    if (_titleH) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return _titleH;
        }
    }
    
    /**功能区域*/
    if (indexPath.section == 0) {
        id obj = _buttonNames[indexPath.row-1];
        if ([obj isKindOfClass:[NSAttributedString class]]) {
            
            NSAttributedString *str = (NSAttributedString *)obj;
            
            return [self heightOfAttribute:str];
        }
    }
    
    return CZY_NORMAL_CELL_HEIGHT;
}

#pragma mark - tableView height 
- (CGFloat)tableViewHeight
{
    CGFloat tbHeight = CZY_SECTION_PADDING+CZY_NORMAL_CELL_HEIGHT;

    if (_titleH) {
        tbHeight += _titleH;
    }else{
        tbHeight += CZY_NORMAL_CELL_HEIGHT;
    }
    
    for (id obj in _buttonNames) {

        if ([obj isKindOfClass:[NSAttributedString class]]) {
            
            tbHeight += [self fontOfAttributeString:obj]/14 *CZY_NORMAL_CELL_HEIGHT;
        }else{
            
            tbHeight += CZY_NORMAL_CELL_HEIGHT;
        }
    }
    
    return tbHeight;
}

#pragma mark - attributeString Font  Height
- (CGFloat)fontOfAttributeString:(NSAttributedString *)attributeStr
{
    NSRange range = NSMakeRange(0, attributeStr.length);
    NSDictionary*dict = [attributeStr attributesAtIndex:0 effectiveRange:&range];
    
    return [(UIFont *)dict[@"NSFont"] pointSize];
}

- (CGFloat)heightOfAttribute:(NSAttributedString *)attributeStr
{
    NSRange range = NSMakeRange(0, attributeStr.length);
    NSDictionary*dict = [attributeStr attributesAtIndex:0 effectiveRange:&range];
    UIFont *strFont = (UIFont *)dict[@"NSFont"];
    
    return strFont.pointSize/14 * CZY_NORMAL_CELL_HEIGHT;
}

#pragma mark - alreadyExsit
- (BOOL)alreadyExsit
{
    return _tableView || _maskView;
}

#pragma mark - dismiss
- (void)dismiss
{
    [_tableView removeFromSuperview];
    _tableView = nil;
    
    [_maskView removeFromSuperview];
    _maskView = nil;
}

@end










