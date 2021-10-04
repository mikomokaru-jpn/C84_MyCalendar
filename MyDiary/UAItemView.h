//------------------------------------------------------------------------------
//  UAItemView.h
//------------------------------------------------------------------------------
#import <Cocoa/Cocoa.h>
@interface UAItemView : NSView
@property NSInteger index;                      //インデックス
@property NSAttributedString *aString;          //表示文字列
@property CGColorRef myBackgroundColor;           //背景色
@property CGFloat myBorderWidth;                  //枠線の太さ
@property CGColorRef myBorderColor;               //枠線の色
@property(weak, nonatomic) id uaViewDelegate;   //デリゲート
-(id)initWithFrame:(NSRect)frameRect;           //イニシャライザ
@end
