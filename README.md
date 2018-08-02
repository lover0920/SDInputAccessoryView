# SDInputAccessoryView
动态、评论的键盘上的输入框，可以记录下视图消失后的输入的内容

---
效果图
![](https://raw.githubusercontent.com/lover0920/SDInputAccessoryView/master/效果图.png)

---
```
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

```

