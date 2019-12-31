//
//  USERLiuYanViewController.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/27.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERLiuYanViewController.h"

@interface USERLiuYanViewController ()<UITextViewDelegate>

@property (nonatomic,strong)UILabel *topLabel;
@property (nonatomic,strong)UITextView *contentTextView;
@property (nonatomic,strong)UILabel *textNumLabel;
@property (nonatomic,strong)UIButton *commitBtn;

@end

@implementation USERLiuYanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rootNaviBaseTitle.text = @"在线留言";
    self.rootNaviBaseLine.hidden = NO;
    self.rootNaviBaseImg.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = RGB(238, 238, 238);
    [self topLabel];
    [self contentTextView];
    [self textNumLabel];
    [self commitBtn];
}

- (UILabel *)topLabel{
    if(!_topLabel){
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight + ScreenHeight * 0.0149925, ScreenWidth, ScreenHeight * 0.019985)];
        _topLabel.text = @"感谢您宝贵的意见督促我们继续前行";
        _topLabel.textColor = RGB(153, 153, 153);
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:_topLabel];
    }
    return _topLabel;
}

- (UITextView *)contentTextView{
    if(!_contentTextView){
        _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(ScreenWidth * 0.04, CGRectGetMaxY(self.topLabel.frame) + ScreenHeight * 0.0149925, ScreenWidth - ScreenWidth * 0.08, WidthScale(180))];
        _contentTextView.delegate = self;
        _contentTextView.layer.cornerRadius = 5;
        _contentTextView.layer.masksToBounds = YES;
        _contentTextView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contentTextView];
    }
    return _contentTextView;
}

- (UILabel *)textNumLabel{
    if(!_textNumLabel){
        _textNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - ScreenWidth * 0.26666, CGRectGetMaxY(self.contentTextView.frame) + ScreenHeight * 0.0149925, ScreenWidth * 0.2, ScreenHeight * 0.029985)];
        _textNumLabel.textColor = RGB(153, 153, 153);
        _textNumLabel.font = [UIFont systemFontOfSize:13];
        _textNumLabel.textAlignment = NSTextAlignmentRight;
        _textNumLabel.text = @"0/300";
        [self.view addSubview:_textNumLabel];
    }
    return _textNumLabel;
}

- (UIButton *)commitBtn{
    if(!_commitBtn){
        _commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth * 0.04, CGRectGetMaxY(self.textNumLabel.frame) + ScreenHeight * 0.0149925, ScreenWidth - ScreenWidth * 0.08, WidthScale(44))];
        _commitBtn.backgroundColor = TEXTFUCOLOR;
        [_commitBtn setBackgroundImage:[UIImage imageNamed:@"矩形2"] forState:UIControlStateNormal];
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _commitBtn.layer.cornerRadius = 8;
        _commitBtn.layer.masksToBounds = YES;
        [_commitBtn addTarget:self action:@selector(didSelecteTheCommitBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_commitBtn];
    }
    return _commitBtn;
}

#pragma mark ================按钮触发==============
- (void)didSelecteTheCommitBtn{
    
    if(self.contentTextView.text.length == 0){
        [self.view showMBHudWithMessage:@"请输入您要反馈的意见" hide:1.5];
        
    }else{
        [SVProgressHUD show];
        [self setTimerWithLenght:1];
    }
}

#pragma mark ================文本域代理==============
- (void)textViewDidChangeSelection:(UITextView *)textView{
    NSString *str = textView.text;
    self.textNumLabel.text = [NSString stringWithFormat:@"%lu/300",(unsigned long)str.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(text.length >= 300){
        return NO;
    }else{
        return YES;
    }
}

#pragma mark ===============倒计时============
- (void)setTimerWithLenght:(int)inteval{
    __block int timeout = inteval; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            //            int minutes = timeout / 60;    //这里注释掉了，这个是用来测试多于60秒时计算分钟的。
            //            int seconds = timeout % 60;
            //            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
