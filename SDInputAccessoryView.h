//
//  SDInputAccessoryView.h
//  LizhiRun
//
//  Created by 孙号斌 on 2018/7/10.
//  Copyright © 2018年 SX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDInputAccessoryView : UIView
@property (nonatomic, strong) UITextView *textView;

//发送按钮的Block
@property (nonatomic, copy) void(^sentTextBlock)(NSString *text);

//开始编辑  key一般设置成动态的ID或评论的ID
- (void)startInputWithPlaceholder:(NSString *)placeholder
                              key:(NSString *)key;
- (void)clearTextWithKey:(NSString *)key;
- (void)clearAllText;

//添加和移除键盘的通知
- (void)addNotiObserver;
- (void)removeNotiObserver;

@end
