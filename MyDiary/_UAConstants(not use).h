//------------------------------------------------------------------------------
//  UAConstants.h
//------------------------------------------------------------------------------
#ifndef UAConstants_h
#define UAConstants_h
//カレンダービューを表示(移動)したときのカーソル(FirstResoinder)の位置の指定
typedef enum : NSInteger{
    CURRENT_DATE = 0,       //現在日：初期表示
    FIRST_DATE = 1,         //月初日
    LAST_DATE = 2,          //月末日
    NEXT_DATE = 3,          //翌日
    PRE_DATE = 4,           //前日
} StartPosTyp;
//カーソルによる日付の移動方向
typedef enum : NSInteger{
    THIS = 0,        //当日
    RIGHT = 1,       //翌日
    LEFT = 2,        //前日
    DOWN = 3,        //翌週
    UP = 4,          //前週
} MoveTyp;
//カレンダーの週数
typedef enum : NSInteger{
    DAYS_OF_5WEEKS = 35,
    DAYS_OF_6WEEKS = 42
} CalendarTYpe;
//日付属性フラグ
typedef enum : NSInteger{
    Weekday = 1,        //平日
    Saturday = 2,       //土曜日
    Sunday = 3,         //日曜日
} DayType;
//月属性フラグ
typedef enum : NSInteger{
    PreMonth = 1,       //前月
    ThisMonth = 2,      //当月
    NextMonth = 3,      //翌月
} MonthType;

#endif /* UAConstants_h */
