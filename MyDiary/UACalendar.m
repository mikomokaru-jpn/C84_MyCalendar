//------------------------------------------------------------------------------
//  UACalendar.m
//------------------------------------------------------------------------------
#import "UACalendar.h"
@interface UACalendar()
@property NSMutableDictionary* holidays;                //休日辞書
@property NSMutableArray<UACalenderDate*> *dateList;    //日付リスト
@property NSDate* firstDateOfThisMonth;                 //当月1日
@property NSInteger integerCurrentDate;                 //現在日（整数yyyymmdd）
@property NSDate* today;                                //現在日
@property  UADateUtil* dtUtil;                          //日付操作ユーティリティ
@end
// *** クラスの実装 ***
@implementation UACalendar
//------------------------------------------------------------------------------
// イニシャライザ
//------------------------------------------------------------------------------
-(id)init{
    self = [super init];
    if (self == nil){
        return self;
    }
    _dtUtil = [UADateUtil dateManager]; //日付操作ユーティリティ
    //アプリケーションバンドルからJSON形式の休日ファイルを読み込み、辞書を作成する。
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *pth01 = [bundle pathForResource:@"holiday"
                                       ofType:@"json"];
    NSURL *url01 = [NSURL fileURLWithPath:pth01];
    NSData* contents  = [NSData dataWithContentsOfURL:url01];
    NSError *error;
    _holidays = [NSJSONSerialization
                 JSONObjectWithData:contents
                            options:NSJSONReadingMutableContainers
                              error:&error];
    //当月のカレンダーを作成する
    _firstDateOfThisMonth = [_dtUtil firstDate:[NSDate date]];
    [self createDateList];
    return self;
}
//---- インスタンス・メソッド ----
-(void)createCalenderAddMonth:(NSInteger)month{
    _firstDateOfThisMonth = [_dtUtil date:_firstDateOfThisMonth addMonths:month];
    [self createDateList];
}
//当年を返す
-(NSInteger)year{
    return [_dtUtil integeryear:_firstDateOfThisMonth];
}
//当年（和暦）を返す
-(NSArray*)yearOfWareki{
    return [_dtUtil yearOfWareki:_firstDateOfThisMonth];
}
//当月を返す
-(NSInteger)month{
    return [_dtUtil integerMonth:_firstDateOfThisMonth];
}
//指定のインデックスの年を返す
-(NSInteger)yearAtIndex:(NSInteger)index{
    return _dateList[index].year;
}
//指定のインデックスの月を返す
-(NSInteger)monthAtIndex:(NSInteger)index{
    return _dateList[index].month;
}
//指定のインデックスの日を返す
-(NSInteger)dayAtIndex:(NSInteger)index{
    return _dateList[index].day;
}
//指定のインデックスの曜日（コード）を返す
-(NSInteger)weekdayAtIndex:(NSInteger)index{
    return _dateList[index].weekday;
}
//指定のインデックスの当月フラグを返す
-(BOOL)thisMonthFlagAtIndex:(NSInteger)index{
    return _dateList[index].thisMonthFlag;
}
//指定のインデックスの休日フラグを返す
-(BOOL)holidayFlagAtIndex:(NSInteger)index{
    return _dateList[index].holidayFlag;
}

//--- Internal rourine ---
-(void)createDateList{
    NSDateFormatter *format =  [[NSDateFormatter alloc] init];
    format.dateStyle = NSDateFormatterMediumStyle;
    //準備
    _dateList = [[NSMutableArray alloc] init];
    NSArray<NSNumber*>*tableCnv = @[@7,@1,@2,@3,@4,@5,@6];
    //前月処理
    NSInteger weekOf1st = [_dtUtil integerWeekday:_firstDateOfThisMonth];
    NSInteger preDays = tableCnv[weekOf1st-1].integerValue -1;
    NSDate* preDate = [_dtUtil date:_firstDateOfThisMonth addDays:-(preDays)];
    for (NSInteger i=0; i<preDays; i++){
        UACalenderDate *udt = [self makeDate: [_dtUtil date:preDate addDays:i]];
        udt.thisMonthFlag = NO;
        [_dateList addObject:udt];
    }
    //当月処理
    NSInteger daysOfThisMonth = [_dtUtil daysOfMonth:_firstDateOfThisMonth];
    for (NSInteger i=0; i<daysOfThisMonth; i++){
        UACalenderDate *udt = [self makeDate:
                               [_dtUtil date:_firstDateOfThisMonth addDays:i]];
        udt.thisMonthFlag = YES;
        //初日
        if (i==0){
            udt.firstDayFlag = YES;
        }else{
            udt.firstDayFlag = NO;
        }
        //末日
        if (i==daysOfThisMonth-1){
            udt.lastDayFlag = YES;
        }else{
            udt.lastDayFlag = NO;
        }
        [_dateList addObject:udt];
    }
    //翌月処理
    NSDate* firstDateNext = [_dtUtil date:_firstDateOfThisMonth addMonths:1];
    NSInteger nextDays = (7 - (_dateList.count % 7)) % 7;
    for (NSInteger i=0; i<nextDays; i++){
        UACalenderDate *udt = [self makeDate:
                               [_dtUtil date:firstDateNext addDays:i]];
        udt.thisMonthFlag = NO;
        [_dateList addObject:udt];
    }
    //各インデックスを求める
    _currentDateIndex = -1;
    _daysOfCalender = _dateList.count;
    for(NSInteger i=0; i<_dateList.count; i++){
        if (_dateList[i].currentFlag){
            _currentDateIndex = i;  //現在日
        }
        if (_dateList[i].firstDayFlag){
            _fiastDayIndex = i;     //初日
        }
        if (_dateList[i].lastDayFlag){
            _lastDayIndex = i;     //末日
        }
    }
}
//日付オブジェクトを作成する
-(UACalenderDate*)makeDate:(NSDate*)dt{
    UACalenderDate *udt = [[UACalenderDate alloc] init];
    udt.year = [_dtUtil integeryear:dt];            //年
    udt.month = [_dtUtil integerMonth:dt];          //月
    udt.day = [_dtUtil integerDay:dt];              //日
    udt.weekday = [_dtUtil integerWeekday:dt];      //曜日（コード）
    //現在日の判定
    if ([_dtUtil isEqualDate:dt to:[NSDate date]]){
        udt.currentFlag = YES;
    }else{
        udt.currentFlag = NO;
    }
    //休日の判定
    udt.holidayFlag = NO;
    NSString *ymd = [@(udt.year*10000 + udt.month*100 + udt.day) stringValue];
    NSString *holidayName = _holidays[ymd];
    if(holidayName){
        udt.holidayFlag = YES;
    }
    return udt;
}
@end

