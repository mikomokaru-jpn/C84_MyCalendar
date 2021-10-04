//------------------------------------------------------------------------------
//  UAView.m
//------------------------------------------------------------------------------
#import "UAView.h"
@interface UAView()
@property UACalendar* calender;     //カレンダーオブジェクト
@property NSMutableArray<UAItemView*>* itemViewList;    //日付ビューリスト
@property UATextView *headerView;   //年月見出し
@property NSFont* font;             //日付フォント
@property NSFont* fontSmall;        //日付フォント（小）
@property NSInteger selectedItemIndex;  //選択中の日付ビュー
@end

@implementation UAView
- (BOOL) isFlipped{
    return YES;
}
//イニシャライザ
- (id)initWithPoint:(NSPoint)point{
    NSRect myFrame = NSMakeRect(point.x, point.y, 300, 330);    //ビューの大きさ
    self = [super initWithFrame:myFrame];
    if (self == nil){
        return self;
    }
    self.wantsLayer = YES;
    self.layer.backgroundColor =  [NSColor lightGrayColor].CGColor; //背景色
    //フォントの定義
    //@"YuKyo-Bold"
    _font = [NSFont fontWithName:@"Arial" size:24];
    _fontSmall = [NSFont fontWithName:@"Arial" size:16];
    /*
    //格子の表示
    CAShapeLayer* grid1 = [CAShapeLayer layerGridInRect:self.frame
                                            atInterval:10 width:0.2];
    CAShapeLayer* grid2 = [CAShapeLayer layerGridInRect:self.frame
                                             atInterval:50 width:1.0];
    [self.layer addSublayer:grid1];
    [self.layer addSublayer:grid2];
    */
    //日付ビューリスト
    _itemViewList = [[NSMutableArray alloc] init];
    //当月カレンダーの作成（現在日を元に）
    _calender = [[UACalendar alloc] init];
    //サブビュー（コントロール、日付ビュー）の作成と配置
    [self arrangeControlViews];
    //日付ビューに日付をセットする
    [self putDateToIemView];
    //* select
    _selectedItemIndex = _calender.currentDateIndex;
    return self;
}
//ビューの再表示
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    //fiestResponderをハイライトする
    [self.window makeFirstResponder:_itemViewList[_selectedItemIndex]];
}
//---- Delegate 日付ビューの移動 ----
-(void)moveDateIndex:(NSInteger)index to:(MoveTyp)direction{
    switch (direction) {
        case LEFT:
            if (_selectedItemIndex > 0){
                _selectedItemIndex--;       //前日へ
            }else{
                NSInteger addition = 0;
                //カーソルの位置
                if(![_calender thisMonthFlagAtIndex:_selectedItemIndex]){
                    //カレンダーの初日が前月であれば、カーソルを1週前にスキップ
                    addition = 7;
                }
                [_calender createCalenderAddMonth:-1];  //前月のカレンダーの作成
                [self putDateToIemView];                //日付ビューに日付をセットする
                _selectedItemIndex = (_calender.daysOfCalender -1) - addition;
            }
            break;
        case RIGHT:
            if (_selectedItemIndex < _calender.daysOfCalender-1){
                _selectedItemIndex++;       //翌日へ
            }else{
                NSInteger addition = 0;
                //カーソルの位置
                if(![_calender thisMonthFlagAtIndex:_selectedItemIndex]){
                    //カレンダーの末日が翌月であれば、カーソルを1週あとにスキップ
                    addition = 7;
                }
                [_calender createCalenderAddMonth:1];  //前月のカレンダーの作成
                [self putDateToIemView];                //日付ビューに日付をセットする
                _selectedItemIndex = addition;
            }
            break;
        case DOWN:
            if (_selectedItemIndex < _calender.daysOfCalender-7){
                _selectedItemIndex += 7;      //翌週へ
            }
            break;
        case UP:
            if (_selectedItemIndex >= 7 ){
                _selectedItemIndex -=7;       //前週へ
            }
            break;
        default:
            _selectedItemIndex = index;
            break;
    }
    self.needsDisplay = YES;
}
//--- Internal routine ---
//サブビュー（コントロール、日付ビュー）の作成と配置 in initializer
-(void)arrangeControlViews{
    //年月見出し
    _headerView = [[UATextView alloc]
                   initWithFrame:NSMakeRect(40,8,220,40)];
    _headerView.wantsLayer = YES;
    _headerView.layer.backgroundColor = [NSColor clearColor].CGColor;
    [self addSubview:_headerView];
    //前月へボタンの作成
    NSButton* clickPreButton = [NSButton buttonWithTitle:@"<"
                                target:self
                                action:@selector(clickPreButton)];
    clickPreButton.frame = NSMakeRect(5,8,30,35);
    [clickPreButton setButtonType:NSMomentaryPushInButton];
    [clickPreButton setBezelStyle:NSBezelStyleTexturedSquare];
    [self addSubview:clickPreButton];
    //翌月へボタン
    NSButton *clickNextButton = [NSButton buttonWithTitle:@">"
                                 target:self
                                 action:@selector(clickNextButton)];
    clickNextButton.frame = NSMakeRect(265,10,30,35);
    [clickNextButton setButtonType:NSMomentaryPushInButton];
    [clickNextButton setBezelStyle:NSBezelStyleTexturedSquare];
    [self addSubview:clickNextButton];
    //曜日見出し
    NSArray<NSString*> *youbis = @[@"月",@"火",@"水",@"木",@"金",@"土",@"日"];
    for (int i=0; i<youbis.count; i++){
        UATextView *youbiView = [[UATextView alloc]
                       initWithFrame:NSMakeRect(10+(40*i),48,40,22)];
        youbiView.wantsLayer = YES;
        youbiView.layer.backgroundColor = [NSColor clearColor].CGColor;
        youbiView.text = [[NSMutableAttributedString alloc]
                          initWithString:youbis[i]
                          attributes:@{NSFontAttributeName:_fontSmall}];
        [self addSubview:youbiView];
    }
    //日付ビューのグリッド(6行×7列)を作成してカレンダービューへ追加する
    CGFloat CELL_WIDTH = 40;
    CGFloat CELL_HEIGHT = 40;
    NSInteger index = 0;
    for (NSInteger i=1; i<=6; i++){
        for (NSInteger j=1; j<=7; j++){
            //日付ビュー(CAItemVieクラス)の作成
            float x = ((j-1) % 7) * CELL_WIDTH + 10;
            float y =  70 + ((i-1) * CELL_HEIGHT);
            NSRect rect = NSMakeRect(x,
                                     y,
                                     CELL_WIDTH,
                                     CELL_HEIGHT);
            //日付ビューオブジェクトの作成
            UAItemView *item = [[UAItemView alloc] initWithFrame:rect];
            item.uaViewDelegate = self; //デリゲートのセット
            [_itemViewList addObject:item];
            [self addSubview:item];
            index++;
        }
    }
}
//日付ビューに日付をセットする
//イニシャライザ、または前月/翌月の移動処理から呼ばれる
-(void)putDateToIemView{
    //現在日の背景色
    //categoryを利用
    CGColorRef currentDaycolor = [NSColor cgColorR:200 G:220 B:240 alpha:1];
    //年月見出しの編集
    NSArray *wareki = [_calender yearOfWareki];
    NSString *text = [NSString stringWithFormat:@"%ld年%ld月(%@%@)",
      [_calender year], [_calender month], wareki[0], wareki[1]];
    NSFont *font = [NSFont fontWithName:@"YuGothic" size:22];
    NSDictionary *attributes = @{NSFontAttributeName:font};
    _headerView.text = [[NSMutableAttributedString alloc]
                        initWithString:text attributes:attributes];
    _headerView.needsDisplay = YES;
    
    for (NSInteger i=0; i<_itemViewList.count; i++){
        if (i < _calender.daysOfCalender){
            _itemViewList[i].index = i; //インデックス
            _itemViewList[i].aString = [self attributedDay:i];  //日付文字列
            //現在日の日付ビューの背景色を変える
            if (i == _calender.currentDateIndex){
                _itemViewList[i].myBackgroundColor = currentDaycolor;
            }else{
                _itemViewList[i].myBackgroundColor = [NSColor whiteColor].CGColor;
            }
        }else{
            _itemViewList[i].index = -1;
        }
        _itemViewList[i].needsDisplay = YES;
    }
}
//前月へボタン
-(void)clickPreButton{
    [_calender createCalenderAddMonth:-1];  //前月のカレンダーの作成
    [self putDateToIemView];                //日付ビューに日付をセットする
    //* select
    _selectedItemIndex = _calender.lastDayIndex;
    self.needsDisplay = YES;
}
//翌月へボタン
-(void)clickNextButton{
    [_calender createCalenderAddMonth:1];   //翌月のカレンダーの作成
    [self putDateToIemView];                //日付ビューに日付をセットする
    //* select
    _selectedItemIndex = _calender.fiastDayIndex;
    self.needsDisplay = YES;
}
//文字列・日の作成
-(NSAttributedString*)attributedDay:(NSInteger)index{
    //文字列の属性
    NSDictionary *attributes;
    NSFont* font;
    //当月以外の日を小さくする
    if ([_calender thisMonthFlagAtIndex:index]){
        font = _font;
    }else{
        font = _fontSmall;
    }
    //曜日により日の色を変える
    if ([_calender weekdayAtIndex:index] == 1 ||
        [_calender holidayFlagAtIndex:index]){
        //日曜日・休日
        attributes = @{NSFontAttributeName:font,
                       NSForegroundColorAttributeName:[NSColor redColor]};
    }else if ([_calender weekdayAtIndex:index] == 7){
        //土曜日
        attributes = @{NSFontAttributeName:font,
                       NSForegroundColorAttributeName:[NSColor blueColor]};
    }else{
        //平日
        attributes = @{NSFontAttributeName:font,
                       NSForegroundColorAttributeName:[NSColor blackColor]};
    }
    //属性付き文字列の作成
    NSString* day = [NSString stringWithFormat:@"%ld",
                     [_calender dayAtIndex:index]];
    NSAttributedString *atrDay = [[NSAttributedString alloc]
                                  initWithString:day attributes:attributes];
    return atrDay;
}
@end
