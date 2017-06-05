//
//  MLSearchViewController.m
//  Matro
//
//  Created by hyk on 16/3/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSearchViewController.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "UIImage+HeinQi.h"
#import "UIColor+HeinQi.h"
#import "MLGoodsListViewController.h"
#import "SearchHistory.h"
#import <DWTagList/DWTagList.h>
#import <MagicalRecord/MagicalRecord.h>
#import "CommonHeader.h"
#import "MLHttpManager.h"
#import "Masonry.h"
#import "MLLoginViewController.h"
#import "MLSearchTableViewCell.h"
#import "MBProgressHUD+Add.h"
@interface MLSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,DWTagListDelegate,UITextFieldDelegate>
{
    
    NSMutableArray *_historySearchTextArray;//搜索历史的数组，用于保存热门搜索历史
    
    DWTagList *_hotSearchTagList;//标签控件，标签的形式显示热门列表
    DWTagList *mySearchTagList;//标签控件，标签的形式显示热门列表
    NSMutableArray *hotSearchTagArray;
    
    
    NSManagedObjectContext *_context;
    NSMutableArray *hotSearchArray;
    NSMutableArray *hotSearchplaceholderArray;
    UITextField *searchText;
    NSMutableArray *searchArray;
    NSString *searchstring;

}
@property (strong, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *hotSearchTagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotSearchTagHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mySearchTagHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *mySearchTagView;//搜索历史
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tbvH;

@property (strong, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotViewH;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIView *ScrollContentView;
@property (weak, nonatomic) IBOutlet UIView *hotView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableview;


@end
static CGFloat kHeight = 0;


@implementation MLSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
    
//    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 44)];
//    [ _searchBar setImage:[UIImage imageNamed:@"sousuo2"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    _searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
//    for(id cc in [_searchBar subviews])
//    {
//        if([cc isKindOfClass:[UITextField class]])
//        {
//            UITextField *textField = (UITextField *)textField;
//            textField.clipsToBounds = NO;
//            textField.leftView = nil;
//        }
//    }
//    
//    _searchBar.delegate = self;
//    self.navigationItem.titleView = _searchBar;
    _searchBar.delegate = self;
    
    //添加边框和提示
    /*
//    UIView   *frameView = [[UIView alloc] initWithFrame:CGRectMake(45, 25, MAIN_SCREEN_WIDTH-45-46, 28)] ;
    UIView   *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, MAIN_SCREEN_WIDTH - 50, 28)] ;
    frameView.backgroundColor = [UIColor whiteColor];
    frameView.layer.cornerRadius = 4.f;
    frameView.layer.masksToBounds = YES;
    
    CGFloat H = frameView.bounds.size.height - 8;
    CGFloat imgW = H;
    CGFloat textW = frameView.bounds.size.width - imgW - 6;
    NSLog(@"textW===%f",textW);
    
    UIImageView *searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuozhou"]];
    
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(imgW+6, 4, textW, H)];
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.enablesReturnKeyAutomatically = YES;
    searchText.delegate = self;
    searchText.enabled = YES;
    
    
    [frameView addSubview:searchText];
    [frameView addSubview:searchImg];
    searchImg.frame = CGRectMake(8 , 6, imgW-6, imgW-6);
    
    searchText.textColor = [UIColor grayColor];
    searchText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    self.navigationItem.titleView = frameView;
*/
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, MAIN_SCREEN_WIDTH, 28)] ;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 4, 30, 20)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(returnAction :) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:backBtn];
    
    UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, mainView.frame.size.width - 100, 28)] ;
    frameView.backgroundColor = [UIColor whiteColor];
    frameView.layer.cornerRadius = 4.f;
    frameView.layer.masksToBounds = YES;
    
    CGFloat H = frameView.bounds.size.height - 8;
    CGFloat imgW = H;
    CGFloat textW = frameView.bounds.size.width - imgW - 6;
    UIImageView *searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuozhou"]];
    
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(imgW+6, 4, textW, H)];
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.enablesReturnKeyAutomatically = YES;
    searchText.delegate = self;
    searchText.enabled = YES;
    
    
    [frameView addSubview:searchText];
    [frameView addSubview:searchImg];
    searchImg.frame = CGRectMake(8 , 6, imgW-6, imgW-6);
    
    searchText.textColor = [UIColor grayColor];
    searchText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    [mainView addSubview:frameView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(frameView.frame.size.width + 50, 4, 40, 20)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelBtn setTintColor:[UIColor blackColor]];
    [cancelBtn setTitleColor:RGBA(131, 131, 131, 1) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(returnAction :) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:cancelBtn];
    
    self.navigationItem.titleView = mainView;
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [frameView addGestureRecognizer:singleTap];
    
    
    hotSearchArray = [NSMutableArray new];
    hotSearchTagArray = [NSMutableArray new];
    searchArray = [NSMutableArray new];

    hotSearchplaceholderArray = [NSMutableArray new];
    
    //弹出系统键盘
//    [_searchBar becomeFirstResponder];
    [searchText becomeFirstResponder];
 
    /*
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(returnAction :)];
    returnBtn.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    returnBtn.width = -20;
    NSDictionary * attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    [returnBtn setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [returnBtn setTintColor:RGBA(131, 131, 131, 1)];
    self.navigationItem.rightBarButtonItem = returnBtn;
    
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@""  style:UIBarButtonItemStylePlain target:self action:@selector(returnAction :)];
    item.imageInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    item.title = @"";
    item.image = backButtonImage;
    item.width = -20;
    self.navigationItem.leftBarButtonItem = item;
    */
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_rootScrollView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;

    _context = [NSManagedObjectContext MR_defaultContext];
 
    self.edgesForExtendedLayout = UIRectEdgeBottom;

    self.clearBtn.backgroundColor = RGBA(174, 142, 93, 1);
    self.clearBtn.layer.borderWidth =1;
    self.clearBtn.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);//201,201,201
    self.clearBtn.layer.cornerRadius = 4.f;
    self.clearBtn.layer.masksToBounds = YES;
    //UiTextField变化通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchtextChangeAction:) name:UITextFieldTextDidChangeNotification object:searchText];
    //推荐关键字
    [self getSearchplaceholder];
    //历史
    [self loadSearchHistory];
    //热门搜索
    [self gethotKeywords];
    self.searchTableview.hidden = YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
//    [self.historyTableView reloadData];
    [self loadSearchHistory];
    
    
}

-(void)setTableView{
//    _tableView = ({
//        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
//        [tableView registerNib:[UINib nibWithNibName:@"MLSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"MLSearchTableViewCell"];
//        tableView.backgroundColor = RGBA(245, 245, 245, 1);
//
//        tableView.delegate = self;
//        tableView.dataSource = self;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self.ScrollContentView addSubview:tableView];
//        tableView;
//    });
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.mas_equalTo(self.view);
//    }];
//    self.tableView.hidden = YES;

}
-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    
    
}

//隐藏键盘
- (void) hideKeyboard {
//    [_searchBar resignFirstResponder];
    [searchText resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getSearchplaceholder{
    
    //热门搜索关键字推荐

    NSString *str = [NSString stringWithFormat:@"%@/api.php?m=product&s=recommend&method=input_recommend&client_type=ios&app_version=%@",MATROJP_BASE_URL,vCFBundleShortVersionStr];
   
    [MLHttpManager get:str params:nil m:@"product" s:@"recommend" success:^(id responseObject){
        
        NSLog(@"responseObject====%@",responseObject);
       
        if ([responseObject[@"code"] isEqual:@0]) {
            NSDictionary *dataDic = responseObject[@"data"];
            hotSearchplaceholderArray = dataDic[@"recommend"];
            if ([self.searchDic objectForKey:@"keyWord"]) {
                
                NSString *str = self.searchDic[@"keyWord"];
                searchText.text = str;
                
                
            }else{
                
                if (hotSearchplaceholderArray.count == 0) {
                    //_searchBar.placeholder  = @"默认搜索内容";
                    searchText.placeholder = @"默认搜索内容";
                }else{
                    //_searchBar.placeholder = hotSearchplaceholderArray[0];
                    searchText.placeholder = hotSearchplaceholderArray[0];
                    NSString *str = hotSearchplaceholderArray[0];
                    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"searchBlankStr"];
                }
            }
        }else if ([responseObject[@"code"]isEqual:@1002]){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            [self loginAction:nil];
        
        }else{
        
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
        }

    } failure:^( NSError *error){
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        NSLog(@"error===%@",error);
    }];
    
}

-(void)gethotKeywords
{
    //热门搜索关键字
    self.hotView.hidden = YES;
    
    NSString *str = [NSString stringWithFormat:@"%@/api.php?m=product&s=recommend&method=list_recommend&pageindex=1&pagesize=20&client_type=ios&app_version=%@",MATROJP_BASE_URL,vCFBundleShortVersionStr];
   
    [MLHttpManager get:str params:nil m:@"product" s:@"recommend" success:^(id responseObject){
        
        self.hotView.hidden = NO;
        
        if ([responseObject[@"code"] isEqual:@0]) {
            NSLog(@"responseObject===1111%@",responseObject);
            
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *dic = dataDic[@"recommend"];
            int i=0;
            if (dic && dic.count>0) {
                for (NSDictionary *tempDic in dic) {
                    if (i>20) {
                        break;
                    }
                    
                    [hotSearchTagArray addObject:tempDic[@"statu"]];
                    [hotSearchArray addObject:tempDic[@"keyword"]];
                    i++;
                }
                
                _hotSearchTagList = [[DWTagList alloc]initWithFrame:CGRectMake(12, 0, MAIN_SCREEN_WIDTH - 24, 35)];
                _hotSearchTagList.tagDelegate = self;
                [_hotSearchTagList setTags:dic];
                [_hotSearchTagView addSubview:_hotSearchTagList];
                _hotSearchTagHeightConstraint.constant = _hotSearchTagList.contentSize.height;
                [self.view layoutIfNeeded];
                _hotSearchTagList.frame = _hotSearchTagView.bounds;
                
            }
        }else if ([responseObject[@"code"]isEqual:@1002]){
        
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            [self loginAction:nil];
        }else{
        
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
        }
        
    } failure:^( NSError *error){
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        NSLog(@"error===%@",error);
    }];
}


//加载搜索历史纪录
- (void)loadSearchHistory {
    
    NSMutableArray *historySearchArray = (NSMutableArray*)[SearchHistory MR_findAllInContext:_context];
    
    _historySearchTextArray = [NSMutableArray array];
    if (historySearchArray.count == 0) {
        
        self.myViewH.constant = 0;
        [self.hotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ScrollContentView).offset(0);
        }];
        
    }else{
    
    for (SearchHistory *searchHistory in historySearchArray) {
        
            [_historySearchTextArray addObject:searchHistory.keywork];
  
    }
    
    _historySearchTextArray = (NSMutableArray *)[[_historySearchTextArray reverseObjectEnumerator] allObjects];
    
    //采用标题形式
    mySearchTagList = [[DWTagList alloc]initWithFrame:CGRectMake(12, 0, MAIN_SCREEN_WIDTH - 24, 35)];
    mySearchTagList.tagDelegate = self;
    [mySearchTagList setTag:_historySearchTextArray];
    [self.mySearchTagView addSubview:mySearchTagList];
    _mySearchTagHeightConstraint.constant = mySearchTagList.contentSize.height;
   [self.view layoutIfNeeded];
    mySearchTagList.frame = self.mySearchTagView.bounds;
    self.myViewH.constant = self.mySearchTagView.bounds.size.height + 40;
    
        
    }

    self.clearBtn.hidden = (_historySearchTextArray.count == 0);
    self.myView.hidden = (_historySearchTextArray.count == 0);
    
    // _tbvH.constant = _historySearchTextArray.count * 30;
    //[_historyTableView reloadData];
}

//清除搜索历史纪录
- (IBAction)clearSearchHistoryAction:(id)sender {
    
    [SearchHistory MR_truncateAllInContext:_context];
    self.myViewH.constant = 0;
    
    [self.hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ScrollContentView).offset(0);
    }];
    [self loadSearchHistory];
}


- (void) hide {
    
    [self.parentViewController.view removeFromSuperview];
    [self.parentViewController removeFromParentViewController];
}

//返回的方法(就是把他隐藏起来)
-(void)returnAction:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    [self hide];
}

#pragma mark- UISearchBarDelegate
//点击键盘上的search按钮时调用
-(void)searchtextChangeAction:(NSNotification *)notification{

    UITextField *text = notification.object;
    searchstring = text.text;
    NSLog(@"textField--->%@",text.text);
    if (text.text.length >0) {
        NSString *textStr = [text.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [NSString stringWithFormat:@"%@/api.php?m=product&s=recommend&method=hint&hint=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,textStr,vCFBundleShortVersionStr];
        
        [MLHttpManager get:str params:nil m:@"product" s:@"recommend" success:^(id responseObject){
            
            if ([responseObject[@"code"] isEqual:@0]) {
                NSLog(@"responseObject===5555%@",responseObject);
                if ([responseObject[@"data"][@"result"] isKindOfClass:[NSString class]]) {
                    self.rootScrollView.hidden = NO;
                    self.searchTableview.hidden = YES;
                }else{
                    self.rootScrollView.hidden = YES;
                    self.searchTableview.hidden = NO;
                    NSArray *arr = responseObject[@"data"][@"result"][@"options"];
                    [searchArray removeAllObjects];
                    [searchArray addObjectsFromArray:arr];
                    [self.searchTableview reloadData];
                }
                
            }else if ([responseObject[@"code"]isEqual:@1002]){
                
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                [_hud hide:YES afterDelay:1];
                [self loginAction:nil];
            }else{
                
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                [_hud hide:YES afterDelay:1];
            }
            
        } failure:^( NSError *error){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:1];
            NSLog(@"error===%@",error);
        }];
    }else{
    
        self.rootScrollView.hidden = NO;
        self.searchTableview.hidden = YES;
    }
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [searchText resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *searchBlankStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"searchBlankStr"];
    NSString *searchTerm;
//    NSRange textFieldrange = [textField.text rangeOfString:@" "];
//    if (textFieldrange.location != NSNotFound) {
//        searchTerm = searchBlankStr;
//    }else{
//        searchTerm = textField.text;
//    }
    
    if (!textField.text) {
        searchTerm = searchBlankStr;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [textField.text stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            searchTerm = searchBlankStr;
        } else {
            searchTerm = textField.text;
        }
    }
    
//     NSString *searchTerm = textField.text;
    [searchText resignFirstResponder];
    searchText.text  = textField.text;
    
    
    if (![searchTerm isEqualToString:@""] && ![searchTerm isKindOfClass:[NSNull class]])
    {
        BOOL isRepeat = NO;
        
        for (NSString *searhStr in _historySearchTextArray) {
            if ([searhStr isEqualToString:searchTerm]) {
                isRepeat = YES;
            }
        }
        if (!isRepeat) {
            SearchHistory *searchHistory = [SearchHistory MR_createEntityInContext:_context];
           
//            NSRange range = [textField.text rangeOfString:@" "];
//            
//            if (range.location != NSNotFound) {
//               searchHistory.keywork = searchBlankStr;
//            }else{
//                searchHistory.keywork = textField.text;
//            }
            
            if (!textField.text) {
                searchHistory.keywork = searchBlankStr;
            } else {
                //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
                NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                
                //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
                NSString *trimedString = [textField.text stringByTrimmingCharactersInSet:set];
                
                if ([trimedString length] == 0) {
                    searchHistory.keywork = searchBlankStr;
                } else {
                    searchHistory.keywork = textField.text;
                }
            }
  
                [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    [self loadSearchHistory];
                }];
        }
        //隐藏就是关闭当前的搜索的页面
        if (!textField.text) {
            [self hide];
            [_delegate SearchText:searchBlankStr];
        } else {
            //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
            NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            
            //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
            NSString *trimedString = [textField.text stringByTrimmingCharactersInSet:set];
            
            if ([trimedString length] == 0) {
                [self hide];
                [_delegate SearchText:searchBlankStr];
            } else {
                [self hide];
                [_delegate SearchText:searchTerm];
            }
        }
        //将搜索框的值带回上一个页面
        /*
        NSRange range = [textField.text rangeOfString:@" "];
        if (range.location != NSNotFound) {
            //有空格
            
            NSLog(@"searchBlankStr--->%@",searchBlankStr);
//            [MBProgressHUD show:@"关键字含有非法字符" view:self.view];
            [self hide];
            [_delegate SearchText:searchBlankStr];
            
        }else {
            //没有空格
            [self hide];
            [_delegate SearchText:searchTerm];
        }
        */
        
    }else{
        [self hide];
        [_delegate SearchText:searchBlankStr];
    }

    return YES;
}

/*
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = searchBar.text;
    [searchBar resignFirstResponder];
    searchBar.text  = searchBar.text;
    
    if (![searchTerm isEqualToString:@""])
    {
        BOOL isRepeat = NO;
        for (NSString *searhStr in _historySearchTextArray) {
            if ([searhStr isEqualToString:searchTerm]) {
                isRepeat = YES;
            }
        }
        if (!isRepeat) {
            SearchHistory *searchHistory = [SearchHistory MR_createEntityInContext:_context];
            searchHistory.keywork = searchBar.text;
            
            [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                [self loadSearchHistory];
            }];
        }
        //隐藏就是关闭当前的搜索的页面
        [self hide];
        //将搜索框的值带回上一个页面
        [_delegate SearchText:searchTerm];

    }
}
 */

//输入文本实时更新时调用
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText

{
    if (searchText.length == 0) {
        return;
    }
    NSLog(@"searchText--->%@",searchText);
}

//点击搜索框时调用
- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if ([_searchBar.placeholder isEqualToString:@"默认搜索内容"]) {
        
    }else{
        _searchBar.text  = _searchBar.placeholder;
    }
}

//点击取消
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    [self hide];

}

#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return searchArray.count;
//    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    static NSString *CellIdentifier = @"MLSearchTableViewCell" ;
    MLSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    NSDictionary *dic = searchArray[indexPath.row];
    NSString *textstr = dic[@"text"];
    if (searchstring.length>0) {
        NSRange range = [textstr rangeOfString:searchstring];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:textstr];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        cell.searchLab.attributedText = attr;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hide];
    //点击当前的搜索历史，将当前的文字带回上一个页面
//    _searchBar.text  = searchArray[indexPath.row];
    NSDictionary *dic = searchArray[indexPath.row];
    NSString *text = dic[@"text"];
    [_delegate SearchText:text];
    BOOL isRepeat = NO;
    for (NSString *searhStr in _historySearchTextArray) {
        if ([searhStr isEqualToString:text]) {
            isRepeat = YES;
        }
    }
    if (!isRepeat) {
        SearchHistory *searchHistory = [SearchHistory MR_createEntityInContext:_context];
        
        searchHistory.keywork = text;
  
        [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            [self loadSearchHistory];
        }];
    }
    
}

#pragma mark - DWTagListDelegate

- (void)selectedTag:(NSString *)tagName;{
    [self hide];
    
    BOOL isRepeat = NO;
    for (NSString *searhStr in _historySearchTextArray) {
        if ([searhStr isEqualToString:tagName]) {
            isRepeat = YES;
        }
    }
    if (!isRepeat) {
        SearchHistory *searchHistory = [SearchHistory MR_createEntityInContext:_context];
        searchHistory.keywork = tagName;
        
        [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            [self loadSearchHistory];
        }];

    }
    _searchBar.text = tagName;
    
    [_delegate SearchText:tagName];
    
}
- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}
///键盘显示事件
- (void)keyboardWasShown:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    
    //将视图上移计算好的偏移
    if (_historySearchTextArray.count>5) {
        [UIView animateWithDuration:0.1 animations:^{
            kHeight = kbHeight;
            CGSize size = self.rootScrollView.contentSize;
            self.rootScrollView.contentSize = CGSizeMake(size.width,size.height+kbHeight);
        }];
    }
    
}
///键盘消失事件
- (void)keyboardWillBeHidden:(NSNotification *)notify {
    //视图下沉恢复原状
    if (kHeight>0) {
        [UIView animateWithDuration:0.1 animations:^{
            CGSize size = self.rootScrollView.contentSize;
            self.rootScrollView.contentSize = CGSizeMake(size.width,size.height-kHeight);
            kHeight = 0;
            
        }];
    }
 
}

//判断内容是否全部为空格  yes 全部为空格  no 不是
//+ (BOOL) isEmpty:(NSString *) str {
//    
//    if (!str) {
//        return true;
//    } else {
//        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
//        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//        
//        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
//        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
//        
//        if ([trimedString length] == 0) {
//            return true;
//        } else {
//            return false;
//        }
//    }
//}

- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}

@end
