//
//顶部栏
//


#define SCREENW  ([UIScreen mainScreen].bounds.size.width)


#import "SCNavTabBar.h"
#import "NSString+Extension.h"
#import "IndexOfNews.h"
#import "ChannelName.h"

@interface SCNavTabBar ()
{
    UIScrollView    *_navgationTabBar;
    UIView          *_line;                 // underscore show which item selected
    NSArray         *_itemsWidth;           // an array of items' width
}
@property (nonatomic,strong)NSMutableArray* m_naviBtn_array;
@end

@implementation SCNavTabBar

-(NSMutableArray *)m_naviBtn_array{
    if(!_m_naviBtn_array){
        _m_naviBtn_array = [NSMutableArray array];
    }
    return _m_naviBtn_array;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initConfig];
    }
    return self;
}

- (void)initConfig
{
    _items = [@[] mutableCopy];
    [self viewConfig];
}

- (void)viewConfig
{
    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _navgationTabBar.backgroundColor = [UIColor clearColor];
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationTabBar];
}

- (void)updateData
{
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    if (_itemsWidth.count)
    {
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, 0);
    }
}

- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = 0;
    
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        button.titleLabel.font = kFONT(16);
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        CGSize textMaxSize = CGSizeMake(SCREENW, MAXFLOAT);
        CGSize textRealSize = [_itemTitles[index] sizeWithFont:kFONT(16) maxSize:textMaxSize].size;

        textRealSize = CGSizeMake(textRealSize.width + 15*2, kWidth(16));
        button.frame = CGRectMake(buttonX, 0, textRealSize.width, self.frame.size.height);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, self.frame.size.height-kWidth(16), 0);
        
        //字体颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [button addTarget:self action:@selector(itemPressed:type:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabBar addSubview:button];
        [self.m_naviBtn_array addObject:button];
        [_items addObject:button];
        buttonX += button.frame.size.width;
    }
    
    [self showLineWithButtonWidth:[widths[0] floatValue]];
    return buttonX;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    UIButton *btn = _items[selectedIndex];
    [self itemPressed:btn type:(int)selectedIndex];
}

-(void)initNaviTitle:(NSArray*)titles{
//    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
//    if (_itemsWidth.count)
//    {
//        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
//        _navgationTabBar.contentSize = CGSizeMake(contentWidth, 0);
//    }
}

#pragma mark - 重新刷新-但不要有默认index
-(void)updateDataAgain{
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    if (_itemsWidth.count)
    {
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth_again:_itemsWidth];
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, 0);
    }
}
- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth_again:(NSArray *)widths
{
    CGFloat buttonX = 0;
    
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        button.titleLabel.font = kFONT(16);
        CGSize textMaxSize = CGSizeMake(SCREENW, MAXFLOAT);
        CGSize textRealSize = [_itemTitles[index] sizeWithFont:kFONT(16) maxSize:textMaxSize].size;
        
        textRealSize = CGSizeMake(textRealSize.width + 15*2, kWidth(16));
        button.frame = CGRectMake(buttonX, 0 ,textRealSize.width, self.frame.size.height);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, self.frame.size.height-kWidth(16), 0);
        
        //字体颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(itemPressed:type:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabBar addSubview:button];
        [self.m_naviBtn_array addObject:button];
        [_items addObject:button];
        buttonX += button.frame.size.width;
    }
    
    [self showLineWithButtonWidth_again:[widths[0] floatValue]];
    return buttonX;
}

#pragma mark  下划线
- (void)showLineWithButtonWidth:(CGFloat)width
{
    //第一个线的位置
    _line = [[UIView alloc] initWithFrame:CGRectMake(15, self.frame.size.height - kWidth(5), width, kWidth(5))];
    _line.backgroundColor = self.lineColor;
    [_line.layer setCornerRadius:kWidth(5)/2];
    [_navgationTabBar addSubview:_line];
    
    UIButton *btn = _items[0];
    [self itemPressed:btn type:0];
}

- (void)showLineWithButtonWidth_again:(CGFloat)width
{
    //第一个线的位置
    _line = [[UIView alloc] initWithFrame:CGRectMake(15, self.frame.size.height - kWidth(5), width, kWidth(5))];
    _line.backgroundColor = self.lineColor;
    [_line.layer setCornerRadius:kWidth(5)/2];
    [_navgationTabBar addSubview:_line];
    
//    UIButton *btn = _items[0];
//    [self itemPressed:btn type:0];
}

- (void)itemPressed:(UIButton *)button type:(int)type
{
    NSInteger index = [_items indexOfObject:button];
    [_delegate itemDidSelectedWithIndex:index withCurrentIndex:_currentItemIndex];
}

//计算数组内字体的宽度
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        CGSize textMaxSize = CGSizeMake(kWidth(80), MAXFLOAT);
        CGSize textRealSize = [title sizeWithFont:[UIFont systemFontOfSize:16] maxSize:textMaxSize].size;
       
        NSNumber *width = [NSNumber numberWithFloat:textRealSize.width];
        [widths addObject:width];
    }
  
    return widths;
}

#pragma mark 偏移
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    UIButton *button = _items[currentItemIndex];

    CGFloat flag = self.frame.size.width;
    
    if (button.frame.origin.x + button.frame.size.width + 50 >= flag)
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (_currentItemIndex < [_itemTitles count]-1)
        {
            offsetX = offsetX + button.frame.size.width;
        }
        [_navgationTabBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        
    }
    else
    {
        [_navgationTabBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
       //下划线的偏移量
    [UIView animateWithDuration:0.1f animations:^{
        _line.frame = CGRectMake(button.frame.origin.x + 15, _line.frame.origin.y, [_itemsWidth[currentItemIndex] floatValue], _line.frame.size.height);
    }];
}
@end
