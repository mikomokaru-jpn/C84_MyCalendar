//------------------------------------------------------------------------------
// カテゴリ宣言:CAShapeLayer
//------------------------------------------------------------------------------
#import <QuartzCore/QuartzCore.h>
#import <Cocoa/Cocoa.h>
#import "NSBezierPath+MyBezierPath.h"

@interface CAShapeLayer (MyShapeLayer)

// 格子を描画するCAShapeLayerオブジェクトを作成する
// rect:描画する矩形領域, atInterval:格子の間隔(ピクセル), eidth:格子の線の幅(ピクセル)
+(CAShapeLayer*)layerGridInRect:(NSRect)rect
                     atInterval:(float)iPixel width:(float)wPixel;

@end

