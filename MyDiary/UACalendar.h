//------------------------------------------------------------------------------
//  UACalendar.h
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "UACalenderDate.h"
#import "UADateUtil.h"

@interface UACalendar : NSObject
@property(readonly) NSInteger daysOfCalender;   //カレンダの日数（35 or 42）
@property(readonly) NSInteger currentDateIndex; //現在日のインデックス
@property(readonly) NSInteger fiastDayIndex;    //初日のインデックス
@property(readonly) NSInteger lastDayIndex;     //末日のインデックス
-(void)createCalenderAddMonth:(NSInteger)month; //カレンダーを作成する
-(NSInteger)yearAtIndex:(NSInteger)index;       //指定のインデックスの年を返す
-(NSInteger)monthAtIndex:(NSInteger)index;      //指定のインデックスの月を返す
-(NSInteger)dayAtIndex:(NSInteger)index;        //指定のインデックスの日を返す
-(NSInteger)weekdayAtIndex:(NSInteger)index;    //指定のインデックスの曜日を返す
-(BOOL)thisMonthFlagAtIndex:(NSInteger)index;   //指定のインデックスの当月フラグを返す
-(BOOL)holidayFlagAtIndex:(NSInteger)index;     //指定のインデックスの休日フラグを返す
-(NSInteger)year;           //カレンダーの年を返す
-(NSInteger)month;          //カレンダーの月を返す
-(NSArray*)yearOfWareki;    //和暦年を返す  年号[0], 年[1]

@end
