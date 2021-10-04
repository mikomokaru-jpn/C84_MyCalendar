//------------------------------------------------------------------------------
//  UAView.h
//------------------------------------------------------------------------------
#import <Cocoa/Cocoa.h>
//#import "CAShapeLayer+MyShapeLayer.h"
#import "NSColor+MyColor.h"
#import "UAItemView.h"
#import "UATextView.h"
#import "UACalendar.h"

//カーソルによる日付の移動方向

typedef enum : NSInteger{
    THIS = 0,        //当日
    RIGHT = 1,       //翌日
    LEFT = 2,        //前日
    DOWN = 3,        //翌週
    UP = 4,          //前週
} MoveTyp;

@interface UAView : NSView
-(id)initWithPoint:(NSPoint)point;
-(void)moveDateIndex:(NSInteger)index to:(MoveTyp)direction;
@end
