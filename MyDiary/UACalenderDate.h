//------------------------------------------------------------------------------
//  UACalenderDate.h
//------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
@interface UACalenderDate : NSObject
@property NSInteger year;           //年
@property NSInteger month;          //月
@property NSInteger day;            //日
@property NSInteger weekday;        //曜日（1:日曜〜7:土曜）
@property BOOL thisMonthFlag;       //当月の場合YES, 前月/翌月の場合NO
@property BOOL firstDayFlag;        //初日フラグ
@property BOOL lastDayFlag;         //末日フラグ
@property BOOL holidayFlag;         //休日フラグ
@property BOOL currentFlag;         //現在日フラグ
@end
