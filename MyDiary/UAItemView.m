//------------------------------------------------------------------------------
//  UAItemView.m
//------------------------------------------------------------------------------
#import "UAItemView.h"
#import "UAView.h"
@implementation UAItemView
- (BOOL) isFlipped{
    return YES;
}
- (BOOL)acceptsFirstResponder{
    return YES; // default NO
}
//イニシャライザ
-(id)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if (self == nil){
        return self;
    }
    //枠線
    _myBorderWidth = 0.5;
    _myBorderColor = [NSColor lightGrayColor].CGColor;
    return self;
}
//ビューの再表示
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (_index < 0){
        //月末一週間を非表示
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
    //日付文字列の表示
    float x = (self.frame.size.width/2)-(_aString.size.width/2);
    float y = (self.frame.size.height/2)-(_aString.size.height/2);
    [_aString drawAtPoint :NSMakePoint(x, y)];
    //枠線
    self.layer.borderWidth = _myBorderWidth;
    self.layer.borderColor = _myBorderColor;
    //背景色
    self.layer.backgroundColor = _myBackgroundColor;
}
- (BOOL)becomeFirstResponder{
    _myBorderWidth = 2.5;
    _myBorderColor = [NSColor blueColor].CGColor;
     [self setNeedsDisplay:YES];  //枠線の再描画
    return YES;
}
- (BOOL)resignFirstResponder{
    _myBorderWidth = 0.5;
    _myBorderColor = [NSColor lightGrayColor].CGColor;
    [self setNeedsDisplay:YES];  //枠線の再描画
    return YES;
}
//日付をクリックする。
- (void)mouseDown:(NSEvent *)event{
    //*select
    [_uaViewDelegate moveDateIndex:self.index to:THIS];

}
//キーを押す。
-(void)keyDown:(NSEvent *)event{
    
    switch (event.keyCode) {
        case 123:   //left  前日へ
            [_uaViewDelegate moveDateIndex:self.index to:LEFT];
            break;
        case 124:   //right 翌日へ
        case 48:    //tab 翌日へ
            [_uaViewDelegate moveDateIndex:self.index to:RIGHT];
            break;
        case 125:   //down  翌週へ
            [_uaViewDelegate moveDateIndex:self.index to:DOWN];
            break;
        case 126:   //up    前週へ
            [_uaViewDelegate moveDateIndex:self.index to:UP];
            break;
        case 36:   //return
        default:
            [super keyDown:event];
            break;
    }
}
@end
