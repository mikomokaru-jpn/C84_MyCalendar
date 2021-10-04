//------------------------------------------------------------------------------
//  UATextView.m
//------------------------------------------------------------------------------
#import "UATextView.h"
@implementation UATextView
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    //draw center
    float x = (self.frame.size.width/2)-(_text.size.width/2);
    float y = (self.frame.size.height/2)-(_text.size.height/2);
    [_text drawAtPoint :NSMakePoint(x, y)];
}
@end
