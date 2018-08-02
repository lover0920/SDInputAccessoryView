//
//  SDInputAccessoryView.m
//  LizhiRun
//
//  Created by 孙号斌 on 2018/7/10.
//  Copyright © 2018年 SX. All rights reserved.
//

#import "SDInputAccessoryView.h"

#define EDGE    10


@interface SDInputAccessoryView()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *holderLabel;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) CGRect hiddenFrame;
@property (nonatomic, assign) CGRect hiddenTVFrame;

//保存数据
@property (nonatomic, strong) NSMutableDictionary *saveDic;
@end
@implementation SDInputAccessoryView
#pragma mark - 懒加载
- (NSMutableDictionary *)saveDic
{
    if (!_saveDic) {
        _saveDic = [NSMutableDictionary dictionary];
    }
    return _saveDic;
}
#pragma mark - 初始化
- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 55)];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    self.hiddenFrame = self.frame;
    self.backgroundColor = RGB(249, 250, 251);
    [SDDrawLine drawLine:self
               lineWidth:SINGLE_LINE_WIDTH
               lineColor:RGB(220, 221, 222)
              startPoint:CGPointMake(0, 0)
             interPoints:nil
                endPoint:CGPointMake(SCREEN_WIDTH, 0)];
    
    /*************** 创建textView ***************/
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-80-EDGE*3, self.height-EDGE*2)];
    _hiddenTVFrame = _textView.frame;
    _textView.backgroundColor = RGB(251, 252, 253);
    _textView.delegate = self;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.textColor = UIColorTitle1;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.layer.borderColor = RGB(220, 221, 222).CGColor;
    _textView.layer.borderWidth = SINGLE_LINE_WIDTH;
    _textView.layer.cornerRadius = 3;
    _textView.layer.masksToBounds = YES;
    [self addSubview:_textView];
    
    _holderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-85-EDGE*3, self.height-EDGE*2)];
    _holderLabel.backgroundColor = [UIColor clearColor];
    _holderLabel.textColor = RGB(199, 199, 205);
    _holderLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_holderLabel];
    
    /*************** 创建sendButton ***************/
    _sendButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-EDGE-80, 10, 80, self.height-EDGE*2)];
    [_sendButton setBackgroundColor:UIColorTheme];
    [_sendButton setTitleColor:UIColorWhite
                      forState:UIControlStateNormal];
    [_sendButton setTitle:@"发送"
                 forState:UIControlStateNormal];
    [_sendButton addTarget:self
                    action:@selector(sendButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
    _sendButton.layer.cornerRadius = 3;
    [self addSubview:_sendButton];
}


#pragma mark - 公有方法
- (void)startInputWithPlaceholder:(NSString *)placeholder
                              key:(NSString *)key
{
    _key = key;
    _holderLabel.text = placeholder;
    
    [_textView becomeFirstResponder];
}
- (void)clearTextWithKey:(NSString *)key
{
    [self.saveDic removeObjectForKey:self.key];
}
- (void)clearAllText
{
    [self.saveDic removeAllObjects];
}




#pragma mark - 按钮的点击事件
- (void)sendButtonAction:(UIButton *)sendButton
{
    if (self.sentTextBlock) {
        self.sentTextBlock(self.textView.text);
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 通知、及响应事件
- (void)addNotiObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChange:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
}
- (void)removeNotiObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardWillShow:(NSNotification*)notification //键盘出现
{
    //!!搜狗输入法弹出时会发出三次UIKeyboardWillShowNotification的通知,和官方输入法相比,有效的一次为dUIKeyboardFrameBeginUserInfoKey.size.height都大于零时.
    CGRect beginUserInfo = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if (beginUserInfo.size.height <=0)
    {
        return;
    }
    
    _textView.text = [self.saveDic objectForKey:self.key];
    [self textViewDidChange:_textView];
    
    //动画时长
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //动画类型
    UIViewAnimationOptions options = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    //键盘的Rect
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    [UIView animateWithDuration:duration delay:duration options:options animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT - keyboardHeight - self.height, SCREEN_WIDTH, self.height);
    } completion:^(BOOL finished) {
    }];

}
- (void)keyboardWillHide:(NSNotification*)notification //键盘下落
{
    //动画时长
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //动画类型
    UIViewAnimationOptions options = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    //动画
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.textView.text = nil;
        self.holderLabel.text = @"请输入评论内容...";
        
        self.frame = self.hiddenFrame;
        self.textView.frame = self.hiddenTVFrame;
    } completion:^(BOOL finished) {
    }];
    
}
- (void)keyboardFrameChange:(NSNotification *)notification
{
    NSLog(@"-------------------keyboardFrameChange------------------------");
}


#pragma mark - TextView 的 Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.holderLabel.hidden = textView.hasText;
    
    CGSize contentSize = self.textView.contentSize;
    NSInteger row = ((NSInteger)contentSize.height - 16) / 17;
    
    CGFloat textViewHeight = 0;
    if (row >= 3)
    {
        textViewHeight = (55-EDGE*2) + 17 * (3 - 1);
    }
    else
    {
        textViewHeight = (55 - EDGE * 2) + 17 * (row-1);
    }
    if (textViewHeight <= 35.0f) {
        textViewHeight=35.0f;
    }
    textView.frame = CGRectMake(10, 10, SCREEN_WIDTH-80-EDGE*3, textViewHeight);
    
    
    CGRect selfFrame = self.frame;
    CGFloat selfHeight = textViewHeight+EDGE*2;
    CGFloat selfOriginY = selfFrame.origin.y - (selfHeight - selfFrame.size.height);
    self.frame = CGRectMake(0, selfOriginY, SCREEN_WIDTH, selfHeight);
    
    if (!EmptyStr(self.key))
    {
        [self.saveDic setValue:textView.text forKey:self.key];
    }
    
}

@end
