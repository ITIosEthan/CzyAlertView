```
Example:

NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:@"属性字符串动态增加高度"];
[s addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, s.length)];
[s addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, s.length)];

CzyAlertView *alertView = [CzyAlertView shareInstance];
        
[alertView showAlertWithTitle:@"很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长" 
andAlertTitleColor:[UIColor redColor] andAlertTitleFont:[UIFont boldSystemFontOfSize:18] andAlertTitleH:180 andButtonNames:@[s,@"非属性字符串",@"非属性字符串"] andChooseFunction:^(NSInteger tag) {
            
        NSLog(@"tag = %ld", tag);

        } andCancel:^{
            
        NSLog(@"cancel");
}];

```

![自定义弹框 ](https://github.com/ITIosEthan/CzyAlertView/blob/master/a%20example.png)

