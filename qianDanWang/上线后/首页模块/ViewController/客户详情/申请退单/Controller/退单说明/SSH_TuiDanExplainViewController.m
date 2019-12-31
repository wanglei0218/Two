//
//  SSH_TuiDanExplainViewController.m
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/14.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_TuiDanExplainViewController.h"
#import "SSH_TuiDanYuanYinChoose.h"

@interface SSH_TuiDanExplainViewController ()<UIScrollViewDelegate>
{
    NSInteger _labelHeight;
}

@property (nonatomic, strong) UIScrollView *tuidanScrView;
@property (nonatomic, strong) NSArray *ReasonDesArr;

@end

@implementation SSH_TuiDanExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"退单规则说明";
    self.lineView.hidden = NO;
    self.view.backgroundColor = Colorbdbdbd;
    
    _labelHeight = 0;
    
    [self loadRequestDataRules:@"1"];
}


#pragma mark --------- 控件初始化 ---------
- (UIScrollView *)tuidanScrView{
    if (!_tuidanScrView) {
        _tuidanScrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ScreenWidth, ScreenHeight-getRectNavAndStatusHight-SafeAreaBottomHEIGHT)];
        _tuidanScrView.delegate = self;
        _tuidanScrView.scrollEnabled = YES;
    }
    return _tuidanScrView;
}

#pragma mark ================ 退单说明接口 ===============
- (void)loadRequestDataRules:(NSString *)rules{
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGTuiDanYuanYinURL parameters:@{@"userId":[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString],@"rules":rules,@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]]} success:^(id responsObject) {
        
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        if ([dictionary[@"code"] integerValue] == 200) {
            
            self.ReasonDesArr = [SSH_TuiDanYuanYinChoose creatArrayWithArray:dictionary[@"data"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self tuidanGuiZeShuoMing];
            });
        }
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark --------- 退单规则 -----

- (void)tuidanGuiZeShuoMing{
    
    for (int i=0; i<self.ReasonDesArr.count; i++) {
        SSH_TuiDanYuanYinChoose *model = self.ReasonDesArr[i];
        
        UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale(15), getRectNavAndStatusHight+WidthScale(15)+_labelHeight+WidthScale(15)*i, ScreenWidth-WidthScale(30), WidthScale(100))];
        showLabel.textColor = ColorBlack222;
        showLabel.font = [UIFont systemFontOfSize:WidthScale(14)];
        showLabel.text = model.ruleDescription;
        showLabel.numberOfLines = 0;
        [self.view addSubview:showLabel];
        [UILabel changeSpaceForLabel:showLabel withLineSpace:WidthScale(3.0f) WordSpace:WidthScale(1.0f)];
        _labelHeight += showLabel.height;
    }
    
    _tuidanScrView.contentSize = CGSizeMake(ScreenWidth, getRectNavAndStatusHight+WidthScale(15)*self.ReasonDesArr.count+1+_labelHeight+WidthScale(30));

}

@end
