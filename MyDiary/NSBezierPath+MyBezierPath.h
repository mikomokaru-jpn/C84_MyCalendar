//------------------------------------------------------------------------------
// カテゴリ宣言:NSBezierPath aaa
//------------------------------------------------------------------------------
#import <Cocoa/Cocoa.h>

@interface NSBezierPath (MyBezierPath)
// NSBezierPathをCGPathに変換する
-(CGPathRef)cgPath;

@end

