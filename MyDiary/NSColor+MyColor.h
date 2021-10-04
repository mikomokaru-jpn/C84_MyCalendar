//------------------------------------------------------------------------------
// カテゴリ宣言:NSColor
//------------------------------------------------------------------------------
#import <Cocoa/Cocoa.h>
@interface NSColor (MyColor)
//RGB値を指定してNSColorオブジェクトを作成する（RGB値は一般的な0〜255の値で指定する）
+(NSColor*)myColorR:(float)r G:(float)g B:(float)b;
//RGB値とalph値を指定してNSColorオブジェクトを作成する（alph値は0〜1で指定)
+(NSColor*)myColorR:(float)r G:(float)g B:(float)b alpha:(float)a;
//RGB値を指定してCGColorを作成する（RGB値は一般的な0〜255の値で指定する）
+(CGColorRef)cgColorR:(float)r G:(float)g B:(float)b;
//RGB値を指定してCGColorを作成する（alph値は0〜1で指定)
+(CGColorRef)cgColorR:(float)r G:(float)g B:(float)b alpha:(float)a;
@end
