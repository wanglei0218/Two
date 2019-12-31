#import "SSH_LiuYanZhanWeiFuTextView.h"


@interface SSH_LiuYanZhanWeiFuTextView ()
@property(nonatomic,weak) UILabel *placeholderLabel;
@end
@implementation SSH_LiuYanZhanWeiFuTextView
-(UILabel *)placeholderLabel
{
    if(!_placeholderLabel)
    {
        UILabel *placeholderLabel = [[UILabel alloc]init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.x = 10;
        placeholderLabel.y = 10;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        CGFloat xMargin =9, yMargin = 10;
        // 使用textContainerInset设置top、left、right
        self.textContainerInset = UIEdgeInsetsMake(yMargin, xMargin, 0, xMargin);
        //当光标在最后一行时，始终显示低边距，需使用contentInset设置bottom.
        self.contentInset = UIEdgeInsetsMake(0, 0, yMargin, 0);
        
        self.alwaysBounceVertical = YES;
        self.font = [UIFont systemFontOfSize:14];
        self.placeholderColor = [UIColor grayColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)textDidChange
{
    self.placeholderLabel.hidden = self.hasText;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    [self.placeholderLabel sizeToFit];
}
#pragma mark - 重写setter
-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}
-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholderColor = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}
-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self setNeedsLayout];
}
-(void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}
-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self textDidChange];
}
@end
