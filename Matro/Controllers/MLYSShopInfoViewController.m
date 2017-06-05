//
//  MLYSShopInfoViewController.m
//  Matro
//
//  Created by LHKH on 2017/2/7.
//  Copyright © 2017年 HeinQi. All rights reserved.
//

#import "MLYSShopInfoViewController.h"
#import "UIView+Extension.h"
#import "MLHttpManager.h"
#import "CommonHeader.h"
#import "Masonry.h"
#import "MLShopBQCell.h"
#import "MLshopFLViewController.h"
#import "UIViewController+MLMenu.h"
#import "UIColor+HeinQi.h"
#import "MLShopGoodsListViewCell.h"
#import "MLYourlikeCollectionViewCell.h"
#import "MLshopFirViewCell.h"
#import "MLshopSecViewCell.h"
#import "MLSecondCollectionViewCell.h"
#import "MLshopThdViewCell.h"
#import "MLshopForViewCell.h"
#import "MLFifViewCell.h"
#import "MJRefresh.h"
#import "ZLPageControl.h"
#import "HFSUtility.h"
#import "MLLoginViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MBProgressHUD+Add.h"
#define YourlikeCCELL_IDENTIFIER @"MLYourlikeCollectionViewCell"
#define CollectionViewCellMargin 5.0f//间隔5
@interface MLYSShopInfoViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UITextField *searchText;
    NSString *userid;
    NSString *shopDetailurl;
    UIView *headView;
    UIImageView *headBgimgView;
    UIImageView *headimgView;
    UILabel *shopNameLab;
    UILabel *label;
    UIImageView *shopLvimg;
    UILabel *haopingLab;
    UIButton *shoucangBtn;
    CGFloat cellHeight;
    CGFloat _index_0_height;
    CGFloat _index_4_height;
    CGFloat _index_3_height;
    CGFloat _index_5_height;
    NSMutableArray *shopGoodsListArr;
    NSMutableArray *imgArr;
    NSMutableArray *TJArr;
    NSString *adThdImgUrl;
    NSString *adLeftThdImgUrl;
    NSString *adRightThdImgUrl;
}
@property (nonatomic,strong)UITableView *tableView;
//@property (nonatomic ,strong)NSMutableArray *shopGoodsListArr;
@property (strong,nonatomic)NSTimer *timer;
@property (strong,nonatomic)UIScrollView *imageScrollView;
@property (strong,nonatomic)ZLPageControl *pagecontrol;
@property (strong,nonatomic)UIButton *backBtn;
//@property(strong,nonatomic)NSMutableArray *imgArr;
@end
static NSInteger bq = 1;
//static NSInteger page1 = 1;
static NSInteger page2 = 1;
static NSInteger page3 = 1;
static NSInteger page4 = 1;
@implementation MLYSShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index_0_height = (193.f/750.f)*SCREENWIDTH;
    UIView   *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 28)] ;
    frameView.layer.borderWidth = 1;
    frameView.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    frameView.layer.cornerRadius = 4.f;
    frameView.layer.masksToBounds = YES;
    frameView.backgroundColor = [UIColor whiteColor];
    
    CGFloat H = frameView.bounds.size.height - 8;
    CGFloat imgW = H;
    CGFloat textW = frameView.bounds.size.width - imgW - 6;
    
    UIImageView *searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuo"]];
    searchText = [[UITextField alloc] initWithFrame:CGRectMake( 6, 4, textW, H)];
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.enablesReturnKeyAutomatically = YES;
    searchText.delegate = self;
    searchText.enabled = YES;
    
    [frameView addSubview:searchImg];
    [frameView addSubview:searchText];
    searchImg.frame = CGRectMake(textW - 58 - 70 , 4, imgW, imgW);
    
    searchText.textColor = [UIColor grayColor];
    searchText.placeholder = @"搜索店内的商品";
    searchText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    self.navigationItem.titleView = frameView;
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 22)];
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    [moreBtn setImage:[UIImage imageNamed:@"gengduozl"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(actmore) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *morebtnItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    
    UIButton *sxuanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 22)];
    [sxuanBtn setBackgroundImage:[UIImage imageNamed:@"fenlei1"] forState:UIControlStateNormal];
    [sxuanBtn addTarget:self action:@selector(actsxuan) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sxuanbtnItem = [[UIBarButtonItem alloc]initWithCustomView:sxuanBtn];
    
    self.navigationItem.rightBarButtonItems = @[morebtnItem,sxuanbtnItem];
    shopGoodsListArr = [NSMutableArray array];
    imgArr = [NSMutableArray array];
    TJArr = [NSMutableArray array];
    [self showLoadingView];
    [self loadshopInfo];
    [self loadShouyeData];
    [self loadShouyeTJData];
    [self loadShopGoodsList:4];
    [self setShopHeadView];
    [self setTableView];
    [self addTimer];
    self.backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40,self.view.frame.size.height-45-49-22, 25, 25)];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"backTop.png"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backTopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    self.backBtn.hidden = YES;
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    userid = [[NSUserDefaults standardUserDefaults] valueForKey:kUSERDEFAULT_USERID];
    [self isshoucang];
}

-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"MLShopBQCell" bundle:nil] forCellReuseIdentifier:@"MLShopBQCell"];
        [tableView registerNib:[UINib nibWithNibName:@"MLShopGoodsListViewCell" bundle:nil] forCellReuseIdentifier:@"MLShopGoodsListViewCell"];
        [tableView registerNib:[UINib nibWithNibName:@"MLshopFirViewCell" bundle:nil] forCellReuseIdentifier:@"MLshopFirViewCell"];
        [tableView registerNib:[UINib nibWithNibName:@"MLshopSecViewCell" bundle:nil] forCellReuseIdentifier:@"MLshopSecViewCell"];
        [tableView registerNib:[UINib nibWithNibName:@"MLshopThdViewCell" bundle:nil] forCellReuseIdentifier:@"MLshopThdViewCell"];
        [tableView registerNib:[UINib nibWithNibName:@"MLshopForViewCell" bundle:nil] forCellReuseIdentifier:@"MLshopForViewCell"];
        [tableView registerNib:[UINib nibWithNibName:@"MLFifViewCell" bundle:nil] forCellReuseIdentifier:@"MLFifViewCell"];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    self.tableView.tableHeaderView = headView;
    self.tableView.footer = [self loadMoreDataFooterWith:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
}

-(MJRefreshAutoNormalFooter *)loadMoreDataFooterWith:(UIScrollView *)scrollView {
    MJRefreshAutoNormalFooter *loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (bq == 2) {
            page2++;
            [self showLoadingView];
            [self loadShopGoodsList:bq];
        }else if(bq == 3){
            page3++;
            [self showLoadingView];
            [self loadShopGoodsList:bq];
        }else if(bq == 4 || bq == 1){
            page4++;
            [self showLoadingView];
            [self loadShopGoodsList:4];
        }
        
        
        [scrollView.footer endRefreshing];
    }];
    
    return loadMoreFooter;
}
-(void)setShopHeadView{
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, (215.f/750.f)*SCREENWIDTH)];
    headBgimgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, headView.width, (215.f/750.f)*SCREENWIDTH)];
    [headView addSubview:headBgimgView];
    headimgView = [[UIImageView alloc] initWithFrame: CGRectMake(10, headBgimgView.height - (90.f/750)*SCREENWIDTH-10, (74.f/750)*SCREENWIDTH, (90.f/750)*SCREENWIDTH)];
    [headView addSubview:headimgView];
    
    
    shopNameLab = [[UILabel alloc]initWithFrame:CGRectZero];
    shopNameLab.font = [UIFont systemFontOfSize:14];
    shopNameLab.textColor = [UIColor whiteColor];

    haopingLab = [[UILabel alloc] initWithFrame:CGRectZero];
    haopingLab.font = [UIFont systemFontOfSize:14];
    haopingLab.textColor = [UIColor whiteColor];
    
    label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = @"店铺等级:";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    
    shopLvimg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headView addSubview:shopNameLab];
    [headView addSubview:haopingLab];
    [headView addSubview:label];
    [headView addSubview:shopLvimg];
    [shopNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headimgView.mas_right).offset(10);
        make.right.mas_equalTo(haopingLab).offset(-10);
        make.top.mas_equalTo(headimgView).offset(0);
        make.height.mas_equalTo(20);
    }];

    [haopingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headView.mas_right).offset(-10);
        make.top.mas_equalTo(headimgView).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headimgView.mas_right).offset(10);
        make.right.mas_equalTo(shopLvimg.mas_left).offset(-5);
        make.bottom.mas_equalTo(headimgView.mas_bottom).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [shopLvimg mas_makeConstraints:^(MASConstraintMaker *make) {
    }];
    shoucangBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    shoucangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:shoucangBtn];
    [shoucangBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [shoucangBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [shoucangBtn setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateSelected];
//    [shoucangBtn setTitleColor:RGBA(38, 14, 0, 1) forState:UIControlStateNormal];
    [shoucangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [shoucangBtn setImage:[UIImage imageNamed:@"Star_big2"] forState:UIControlStateNormal];
    [shoucangBtn setImage:[UIImage imageNamed:@"Star_big1"] forState:UIControlStateSelected];
    [shoucangBtn addTarget:self action:@selector(shoucang:) forControlEvents:UIControlEventTouchUpInside];
    [shoucangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headView.mas_right).offset(-10);
        make.bottom.mas_equalTo(headimgView).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    
}

-(void)actmore{
    self.hidesBottomBarWhenPushed = NO;
    
    [self dianpushowDownMenu];
}
//店铺商品分类
-(void)actsxuan{
    
    MLshopFLViewController *vc = [[MLshopFLViewController alloc]init];
    vc.uid = _dpid;
    [self.navigationController  pushViewController:vc animated:YES];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section{
    if (bq == 1) {
        return 6;
    }else{
        return 2;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"tableviewCellID";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"MLShopBQCell" ;
        MLShopBQCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        //店铺首页
        cell.shouyeClick = ^(NSInteger tag){
            bq = tag;
            cell.shaixView.hidden = YES;
            cell.shouyeLab.textColor = [UIColor colorWithHexString:@"F1653E"];
            cell.allLab.textColor = [UIColor colorWithHexString:@"260E00"];
            cell.tuijianLab.textColor = [UIColor colorWithHexString:@"260E00"];
            cell.xinpinLab.textColor = [UIColor colorWithHexString:@"260E00"];
            cell.shoueyeView.hidden = NO;
            cell.allView.hidden = YES;
            cell.tuijianView.hidden = YES;
            cell.xinpinView.hidden = YES;
            [self showLoadingView];
            [self loadShouyeData];
            [self.tableView reloadData];
        };
        //全部商品
        cell.allClick = ^(NSInteger tag){
            bq = tag;
            page2 = 1;
            cell.shaixView.hidden = NO;
            cell.shouyeLab.textColor = [UIColor colorWithHexString:@"260E00"];
            cell.allLab.textColor = [UIColor colorWithHexString:@"F1653E"];
            cell.tuijianLab.textColor = [UIColor colorWithHexString:@"260E00"];
            cell.xinpinLab.textColor = [UIColor colorWithHexString:@"260E00"];
            cell.shoueyeView.hidden = YES;
            cell.allView.hidden = NO;
            cell.tuijianView.hidden = YES;
            cell.xinpinView.hidden = YES;
            [self showLoadingView];
            [self loadShopGoodsList:tag];
            [self.tableView reloadData];
        };
        //热销推荐
        cell.tuijianClick = ^(NSInteger tag){
            bq = tag;
            page3 = 1;
            cell.shaixView.hidden = YES;
            cell.shouyeLab.textColor = [UIColor colorWithHexString:@"260E00"];
            cell.allLab.textColor = [UIColor colorWithHexString:@"260E00"];
            cell.tuijianLab.textColor = [UIColor colorWithHexString:@"F1653E"];
            cell.xinpinLab.textColor = [UIColor colorWithHexString:@"260E00"];
            cell.shoueyeView.hidden = YES;
            cell.allView.hidden = YES;
            cell.tuijianView.hidden = NO;
            cell.xinpinView.hidden = YES;
            [self showLoadingView];
            [self loadShopGoodsList:tag];
            [self.tableView reloadData];
        };
        //新品速递
        cell.xinpinClick = ^(NSInteger tag){
            bq = tag;
            page4 = 1;
            cell.shaixView.hidden = YES;
            cell.shouyeLab.textColor = [UIColor colorWithHexString:@"260E00"];
            cell.allLab.textColor = [UIColor colorWithHexString:@"260E00"];
            cell.tuijianLab.textColor = [UIColor colorWithHexString:@"260E00"];
            cell.xinpinLab.textColor = [UIColor colorWithHexString:@"F1653E"];
            cell.shoueyeView.hidden = YES;
            cell.allView.hidden = YES;
            cell.tuijianView.hidden = YES;
            cell.xinpinView.hidden = NO;
            [self showLoadingView];
            [self loadShopGoodsList:tag];
            [self.tableView reloadData];
        };
        //销量
        cell.xiaoliangClick = ^{
            cell.jiageBtn.selected = NO;
            cell.xiaoliangBtn.selected = YES;
            
            cell.jiageBtn.imageView.hidden = YES;
            
            [cell.jiageBtn setTitleColor:[UIColor colorWithHexString:@"260E00"] forState:UIControlStateNormal];
            [cell.jiageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        };
        
        //价格
        cell.jiageClick = ^{
            
            cell.xiaoliangBtn.selected = NO;
            if (cell.jiageBtn.selected) {
                cell.jiageBtn.selected = NO;
                
                [cell.jiageBtn setImage:[UIImage imageNamed:@"jgshangjian"] forState:UIControlStateNormal];
                [cell.jiageBtn setTitleColor:[UIColor colorWithHexString:@"F1653E"] forState:UIControlStateNormal];
            }else{
                cell.jiageBtn.selected = YES;
                [cell.jiageBtn setTitleColor:[UIColor colorWithHexString:@"F1653E"] forState:UIControlStateSelected];
                [cell.jiageBtn setImage:[UIImage imageNamed:@"xiajianSelect"] forState:UIControlStateSelected];
            }
            
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (bq == 1) {
        if (indexPath.row == 1) {
            static NSString *MLshopFirViewCellID = @"MLshopFirViewCell";
            MLshopFirViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MLshopFirViewCellID];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: MLshopFirViewCellID owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, _index_0_height)];
            _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, _index_0_height)];
            _pagecontrol = [[ZLPageControl alloc]initWithFrame:CGRectMake(SIZE_WIDTH-100, _index_0_height-20, 100, 20)];
            _pagecontrol.userInteractionEnabled = NO;
            [headview addSubview:_imageScrollView];
            [headview addSubview: _pagecontrol];
            
            if (![imgArr isKindOfClass:[NSNull class]]) {//防崩溃
                [self imageUIInit];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:headview];
            
            return cell;
        }else if (indexPath.row == 2){
            static NSString *CellIdentifier = @"MLshopSecViewCell";
            MLshopSecViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
            _index_5_height = 40 +(((MAIN_SCREEN_WIDTH) - (CollectionViewCellMargin*10))/4)*1.72 ;
            
            cell.tuijianCollectionView.delegate = self;
            cell.tuijianCollectionView.dataSource = self;
            cell.tuijianCollectionView.tag = 101;
            
            
            [cell.tuijianCollectionView registerNib:[UINib  nibWithNibName:@"MLSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MLSecondCollectionViewCell"];
            [cell.tuijianCollectionView reloadData];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(indexPath.row == 3){
        
            static NSString *MLshopThdViewCellID = @"MLshopThdViewCell";
            MLshopThdViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MLshopThdViewCellID];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: MLshopThdViewCellID owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
            if (adThdImgUrl && adThdImgUrl.length > 0 && ![adThdImgUrl isKindOfClass:[NSNull class]]) {
                _index_3_height = (170.f/750.f)*SCREENWIDTH;
                if ([adThdImgUrl hasSuffix:@"webp"]) {
                        [cell.thdImg setZLWebPImageWithURLStr:adThdImgUrl withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [cell.thdImg sd_setImageWithURL:[NSURL URLWithString:adThdImgUrl] placeholderImage:[UIImage imageNamed:@"icon_default"]];
                    }
                }else{
                    
                    cell.thdImg.image = [UIImage imageNamed:@"icon_default"];
                }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 4){
            
            static NSString *MLshopForViewCellID = @"MLshopForViewCell";
            MLshopForViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MLshopForViewCellID];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: MLshopForViewCellID owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            if (adLeftThdImgUrl && adLeftThdImgUrl.length > 0 && ![adLeftThdImgUrl isKindOfClass:[NSNull class]]) {
                _index_4_height = (485.f/750.f)*SCREENWIDTH;
                if ([adLeftThdImgUrl hasSuffix:@"webp"]) {
                    [cell.thdLeftImg setZLWebPImageWithURLStr:adLeftThdImgUrl withPlaceHolderImage:PLACEHOLDER_IMAGE];
                } else {
                    [cell.thdLeftImg sd_setImageWithURL:[NSURL URLWithString:adLeftThdImgUrl] placeholderImage:[UIImage imageNamed:@"icon_default"]];
                }
            }else{
                
                cell.thdLeftImg.image = [UIImage imageNamed:@"icon_default"];
            }
            
            if (adRightThdImgUrl && adRightThdImgUrl.length > 0 && ![adRightThdImgUrl isKindOfClass:[NSNull class]]) {
                _index_4_height = (485.f/750.f)*SCREENWIDTH;
                if ([adRightThdImgUrl hasSuffix:@"webp"]) {
                    [cell.thdRightImg setZLWebPImageWithURLStr:adRightThdImgUrl withPlaceHolderImage:PLACEHOLDER_IMAGE];
                } else {
                    [cell.thdRightImg sd_setImageWithURL:[NSURL URLWithString:adRightThdImgUrl] placeholderImage:[UIImage imageNamed:@"icon_default"]];
                }
            }else{
                
                cell.thdRightImg.image = [UIImage imageNamed:@"icon_default"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *MLFifViewCellID = @"MLFifViewCell";
            MLFifViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MLFifViewCellID];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: MLFifViewCellID owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            cell.fifCollectionView.delegate = self;
            cell.fifCollectionView.dataSource = self;
            cell.fifCollectionView.tag = 105;
            
            [cell.fifCollectionView registerNib:[UINib  nibWithNibName:@"MLYourlikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:YourlikeCCELL_IDENTIFIER];
            NSLog(@"--height--%lu",(unsigned long)shopGoodsListArr.count);
            float cellW = (MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2;
            
            if ( shopGoodsListArr && shopGoodsListArr.count >0) {
               
                float height_8 = 0.0f;
                if (shopGoodsListArr.count % 2 == 0) {
                    height_8 = 80.0/750.0*SIZE_WIDTH+((MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2.0*1.35)*(shopGoodsListArr.count / 2);
                }
                else{
                    height_8 = 80.0/750.0*SIZE_WIDTH+((MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2.0*1.35)*((shopGoodsListArr.count+1)/2);
                }
                cellHeight = height_8;
                [cell.fifCollectionView reloadData];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }

    }else{
        if (indexPath.row == 1) {
            static NSString *CellIdentifier = @"MLShopGoodsListViewCell" ;
            MLShopGoodsListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            cell.shopGoodsListCollectionView.delegate = self;
            cell.shopGoodsListCollectionView.dataSource = self;
            cell.shopGoodsListCollectionView.tag = 105;
            
            [cell.shopGoodsListCollectionView registerNib:[UINib  nibWithNibName:@"MLYourlikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:YourlikeCCELL_IDENTIFIER];
            NSLog(@"--height--%lu",(unsigned long)shopGoodsListArr.count);
            float cellW = (MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2;
            
            if ( shopGoodsListArr && shopGoodsListArr.count >0) {
         
                float height_8 = 0.0f;
                if (shopGoodsListArr.count % 2 == 0) {
                    height_8 = 80.0/750.0*SIZE_WIDTH+((MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2.0*1.35)*(shopGoodsListArr.count / 2);
                }
                else{
                    height_8 = 80.0/750.0*SIZE_WIDTH+((MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2.0*1.35)*((shopGoodsListArr.count+1)/2);
                }
                cellHeight = height_8;
                [cell.shopGoodsListCollectionView reloadData];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (bq == 2) {
            return 80;
        }else {
            return 40;
        }
    }else if(bq == 1){
        if (indexPath.row == 1) {
            return _index_0_height;
        }else if(indexPath.row == 2){
            return _index_5_height;
        }else if(indexPath.row == 3){
            return _index_3_height;
        }else if(indexPath.row == 4){
            return _index_4_height;
        }
        else{
            return cellHeight;
        }
    }else{
        return cellHeight;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 101) {
        return TJArr.count;
    }
    return shopGoodsListArr.count;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 105) {
        MLYourlikeCollectionViewCell *cell = (MLYourlikeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:YourlikeCCELL_IDENTIFIER forIndexPath:indexPath];
        if (shopGoodsListArr && shopGoodsListArr.count >0) {
            NSDictionary *tempDic = shopGoodsListArr[indexPath.row];
            NSLog(@"temdic---->%@",tempDic);
            if (![tempDic isKindOfClass:[NSNull class]]) {
                
                //是否有参加的活动
                if (tempDic[@"activity_pic"]) {
                    NSArray *activity_picArr = tempDic[@"activity_pic"];
                    CGFloat width = 0.f;
                    if (activity_picArr && activity_picArr.count>0) {
                        cell.ActivityView.hidden = NO;
                        for (int i = 0; i<activity_picArr.count; i++) {
                            NSString *url = activity_picArr[i][@"pic_app"];
                            CGSize size =[self getImageSizeWithURL:url];
                            if (i>=1) {
                                NSString *preurl = activity_picArr[i-1][@"pic_app"];
                                CGSize presize =[self getImageSizeWithURL:preurl];
                                width = width + presize.width/4;
                            }
                            
                            //                        NSLog(@"size--->%@---->%f",NSStringFromCGSize(size),width);
                            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width + i*5), 0, size.width/4, size.height/4)];
                            if ([url hasSuffix:@"webp"]) {
                                [imageView setZLWebPImageWithURLStr:url withPlaceHolderImage:PLACEHOLDER_IMAGE];
                            } else {
                                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_default"]];
                            }
                            [cell.ActivityView addSubview:imageView];
                        }
                    }else{
                        cell.ActivityView.hidden = YES;
                    }
                }else{
                    cell.ActivityView.hidden = YES;
                }
                
                cell.likeNameLab.text = tempDic[@"pname"]?:@"";
                
                float  originprice= [tempDic[@"promotion_price"] floatValue];
                
                if ( ![tempDic[@"promotion_price"] isKindOfClass:[NSNull class]]) {
                    if (originprice == 0.00) {
                        cell.cuxiaoPriceLabel.hidden = YES;
                        float price = [tempDic[@"price"] floatValue];
                        
                        cell.likePriceLab.text = [NSString  stringWithFormat:@"￥%.2f",price];
                    }
                    else{
                        cell.cuxiaoPriceLabel.hidden = NO;
                        float price = [tempDic[@"price"] floatValue];
                        
                        cell.likePriceLab.text = [NSString stringWithFormat:@"￥%.2f",originprice];
                        NSString *Pricestr = [NSString stringWithFormat:@"￥%.2f",price];
                        NSAttributedString *attrStr =
                        [[NSAttributedString alloc]initWithString:Pricestr
                                                       attributes:
                         @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                           NSForegroundColorAttributeName:[UIColor grayColor],
                           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                           NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                        //                    cell.cuxiaoPriceLabel.attributedText=attrStr; //原价要划掉
                    }
                }
                float amount = [tempDic[@"amount"] floatValue];
                if (amount < 1) {
                    cell.shouqingLabel.hidden = NO;
                }else{
                    cell.shouqingLabel.hidden = YES;
                }
                
                NSString *imageurl = tempDic[@"pic"]?:@"";
                if (![imageurl isKindOfClass:[NSNull class]]) {
                    
                    if ([imageurl hasSuffix:@"webp"]) {
                        [cell.likeImage setZLWebPImageWithURLStr:imageurl withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [cell.likeImage  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                    }
                }else{
                    
                    cell.likeImage.image = [UIImage imageNamed:@"icon_default"];
                }
                
                
            }
        }
        return cell;
    }else{
        MLSecondCollectionViewCell *cell = (MLSecondCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"MLSecondCollectionViewCell" forIndexPath:indexPath];
        NSDictionary *tempDic = TJArr[indexPath.row];
        //是否有参加的活动
        if (tempDic[@"activity_pic"]) {
            NSArray *activity_picArr = tempDic[@"activity_pic"];
            CGFloat width = 0.f;
            if (activity_picArr && activity_picArr.count>0) {
                cell.ActivityView.hidden = NO;
                for (int i = 0; i<activity_picArr.count; i++) {
                    NSString *url = activity_picArr[i][@"pic_app"];
                    CGSize size =[self getImageSizeWithURL:url];
                    if (i>=1) {
                        NSString *preurl = activity_picArr[i-1][@"pic_app"];
                        CGSize presize =[self getImageSizeWithURL:preurl];
                        width = width + presize.width/4;
                    }
                    
                    //                        NSLog(@"size--->%@---->%f",NSStringFromCGSize(size),width);
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width + i*5), 0, size.width/4, size.height/4)];
                    if ([url hasSuffix:@"webp"]) {
                        [imageView setZLWebPImageWithURLStr:url withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_default"]];
                    }
                    [cell.ActivityView addSubview:imageView];
                }
            }else{
                cell.ActivityView.hidden = YES;
            }
        }else{
            cell.ActivityView.hidden = YES;
        }
        
        cell.secondNameLab.text = tempDic[@"pname"]?:@"";
        float promotion_price = [tempDic[@"promotion_price"] floatValue];
        float price = [tempDic[@"price"] floatValue];
        if (![tempDic[@"promotion_price"] isKindOfClass:[NSNull class]]) {
            if (promotion_price == 0.00) {
                
                cell.secondPriceLab.text = [NSString stringWithFormat:@"￥%.2f",price];
                
            }else{
                cell.secondPriceLab.text = [NSString stringWithFormat:@"￥%.2f",promotion_price];
            }
        }
        
        NSString *imageurl = tempDic[@"pic"]?:@"";
        if (![imageurl isKindOfClass:[NSNull class]]) {
            
            if ([imageurl hasSuffix:@"webp"]) {
                [cell.secondImageView setZLWebPImageWithURLStr:imageurl withPlaceHolderImage:PLACEHOLDER_IMAGE];
            } else {
                [cell.secondImageView  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
            }
        }else{
            
            cell.secondImageView.image = [UIImage imageNamed:@"icon_default"];
        }
        
        return cell;
    }
    

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 101) {
        NSDictionary *tempDic = TJArr[indexPath.row];
        NSString *sender = tempDic[@"id"];
        MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc ]init];
        
        vc.paramDic = @{@"id":sender};
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSDictionary *tempDic = shopGoodsListArr[indexPath.row];
        NSString *sender = tempDic[@"id"];
        MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc ]init];
        
        vc.paramDic = @{@"id":sender};
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (collectionView.tag == 101) {
        float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*10))/4);
        return CGSizeMake(width, width*1.72);
    }
    CGFloat cellW = (MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2;
    return CGSizeMake(cellW,cellW*1.35);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 105){
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, CollectionViewCellMargin*2, 0, CollectionViewCellMargin*2);
}


- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 105){
        
        return -3.f;
    }
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 7) {
        return 0.f;
    }
    return 0.f;
}

-(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
-(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
-(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
//  获取gif图片的大小
-(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

-(void)loadshopInfo{
    NSLog(@"dpid---->%@",_dpid);
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=shop&s=shop&uid=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,self.dpid,vCFBundleShortVersionStr];
    
    [MLHttpManager get:urlStr params:nil m:@"shop" s:@"shop" success:^(id responseObject){
        NSLog(@"loadshopInfo----->%@",responseObject);
        [self closeLoadingView];
        if ([responseObject[@"code"] isEqual:@0]) {
            NSDictionary *shop_info = responseObject[@"data"][@"shop_info"];
            NSString *campany = shop_info[@"company"];
            shopNameLab.text = [NSString stringWithFormat:@"%@",campany];
            NSString *favorablerate = shop_info[@"favorablerate"];
            haopingLab.text = [NSString stringWithFormat:@"好评率:%0.f%%",favorablerate.floatValue];
            NSString *backImg = shop_info[@"shop_background"];
            NSString *logo = shop_info[@"logo"];
            NSString *sellerpointsimg = shop_info[@"sellerpointsimg"];
            
            if (![backImg isKindOfClass:[NSNull class]]) {
                
                if ([backImg hasSuffix:@"webp"]) {
                    [headBgimgView setZLWebPImageWithURLStr:backImg withPlaceHolderImage:PLACEHOLDER_IMAGE];
                } else {
                    [headBgimgView sd_setImageWithURL:[NSURL URLWithString:backImg] placeholderImage:[UIImage imageNamed:@"icon_default"]];
                }
            }else{
                
                headBgimgView.image = [UIImage imageNamed:@"icon_default"];
            }
            if (![logo isKindOfClass:[NSNull class]]) {
                
                if ([logo hasSuffix:@"webp"]) {
                    [headimgView setZLWebPImageWithURLStr:logo withPlaceHolderImage:PLACEHOLDER_IMAGE];
                } else {
                    [headimgView sd_setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"icon_default"]];
                }
            }else{
                
                headimgView.image = [UIImage imageNamed:@"icon_default"];
            }
            
            if (![sellerpointsimg isKindOfClass:[NSNull class]]) {
                [shopLvimg sd_setImageWithURL:[NSURL URLWithString:sellerpointsimg] placeholderImage:[UIImage imageNamed:@"icon_default"]];
               
            }else{
                
                shopLvimg.image = [UIImage imageNamed:@"icon_default"];
            }
            
            CGSize size = [self getImageSizeWithURL:sellerpointsimg];
            
            NSLog(@"size--->%@",NSStringFromCGSize(size));
            
            [shopLvimg mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.mas_equalTo(label);
                make.height.mas_offset(20);
                make.width.mas_equalTo(size.width+5);
            }];
        }else if ([responseObject[@"code"]isEqual:@1002]){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
      
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            
        }
        
    } failure:^(NSError *error){
        [self closeLoadingView];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
        
    }];

}

-(void)loadShopGoodsList:(NSInteger)sender{
   
    NSString *urlStr = nil;
    if (sender == 2) {
        
        urlStr = [NSString stringWithFormat:@"%@/api.php?m=shop&s=home&uid=%@&op=new&pageindex=%ld&pagesize=10&client_type=ios&app_version=%@",MATROJP_BASE_URL,self.dpid,(long)page2,vCFBundleShortVersionStr];
    }else if(sender == 3){
        
        urlStr = [NSString stringWithFormat:@"%@/api.php?m=shop&s=home&uid=%@&op=hot&pageindex=%ld&pagesize=10&client_type=ios&app_version=%@",MATROJP_BASE_URL,self.dpid,(long)page3,vCFBundleShortVersionStr];
    }else if (sender == 4){
       
        urlStr = [NSString stringWithFormat:@"%@/api.php?m=shop&s=home&uid=%@&op=new&pageindex=%ld&pagesize=10&client_type=ios&app_version=%@",MATROJP_BASE_URL,self.dpid,(long)page4,vCFBundleShortVersionStr];
    }
//    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=shop&s=home&uid=%@&op=%@&pageindex=%ld&pagesize=10&client_type=ios&app_version=%@",MATROJP_BASE_URL,self.dpid,op,(long)page2,vCFBundleShortVersionStr];
    
    [MLHttpManager get:urlStr params:nil m:@"shop" s:@"shop" success:^(id responseObject){
        NSLog(@"loadShopGoodsList----->%@",responseObject);
        [self closeLoadingView];
        if ([responseObject[@"code"] isEqual:@0]) {
            if (responseObject[@"data"]) {
                if (responseObject[@"data"][@"shop_pro_list"]) {
                    NSArray *arr = responseObject[@"data"][@"shop_pro_list"];
                    if (bq == 2) {
                        if (page2 == 1) {
                            [shopGoodsListArr removeAllObjects];
                        }
                    }else if (bq == 3){
                        if (page3 == 1) {
                            [shopGoodsListArr removeAllObjects];
                        }
                    }else if (bq == 4 || bq == 1){
                        if (page4 == 1) {
                            [shopGoodsListArr removeAllObjects];
                        }
                    }
           
                    if (arr && arr.count > 0) {
                        [shopGoodsListArr addObjectsFromArray:arr];
                    }
                    NSNumber *count = responseObject[@"data"][@"count"];
                    if ([count isEqualToNumber:@0] ) {
                        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.footer;
                        footer.stateLabel.text = @"没有更多了";
                        return ;
                    }
                    [self.tableView reloadData];
                }
            }
           
        }else if ([responseObject[@"code"]isEqual:@1002]){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            
        }
        
    } failure:^(NSError *error){
        [self closeLoadingView];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
        
    }];

}

-(void)loadShouyeData{
    NSLog(@"dpid---->%@",_dpid);
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=shop&s=advertisement&uid=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,self.dpid,vCFBundleShortVersionStr];
    
    [MLHttpManager get:urlStr params:nil m:@"shop" s:@"advertisement" success:^(id responseObject){
        NSLog(@"loadShouyeData----->%@",responseObject);
        [self closeLoadingView];
        if ([responseObject[@"code"] isEqual:@0]) {
            if (responseObject[@"data"][@"aap_advs_list"] && ![responseObject[@"data"][@"aap_advs_list"] isKindOfClass:[NSString class]]) {
               NSDictionary *aap_advs_list = responseObject[@"data"][@"aap_advs_list"];
                NSArray *app_shop_banner = aap_advs_list[@"app_shop_banner"];
                [imgArr removeAllObjects];
                if (app_shop_banner && app_shop_banner.count > 0) {
                    [imgArr addObjectsFromArray:app_shop_banner];
                }
                NSString *app_shop_advs1 = aap_advs_list[@"app_shop_advs1"];
                NSString *app_shop_advs2 = aap_advs_list[@"app_shop_advs2"];
                NSString *app_shop_advs3 = aap_advs_list[@"app_shop_advs3"];
                
                adThdImgUrl = app_shop_advs1;
                adLeftThdImgUrl = app_shop_advs2;
                adRightThdImgUrl = app_shop_advs3;
            }
            [self.tableView reloadData];
        }else if ([responseObject[@"code"]isEqual:@1002]){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            
        }
        
    } failure:^(NSError *error){
        [self closeLoadingView];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
        
    }];

}

-(void)loadShouyeTJData{
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=shop&s=home&uid=%@&op=hot&pageindex=1&pagesize=20&client_type=ios&app_version=%@",MATROJP_BASE_URL,self.dpid,vCFBundleShortVersionStr];
    [MLHttpManager get:urlStr params:nil m:@"shop" s:@"home" success:^(id responseObject){
        NSLog(@"loadShouyeTJData----->%@",responseObject);
        [self closeLoadingView];
        if ([responseObject[@"code"] isEqual:@0]) {
            if (responseObject[@"data"][@"shop_pro_list"] && ![responseObject[@"data"][@"shop_pro_list"] isKindOfClass:[NSString class]]) {
                NSArray *arr = responseObject[@"data"][@"shop_pro_list"];
                [TJArr removeAllObjects];
                if (arr && arr.count >0) {
                    [TJArr addObjectsFromArray:arr];
                }
            }
            [self.tableView reloadData];
        }else if ([responseObject[@"code"]isEqual:@1002]){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            
        }
        
    } failure:^(NSError *error){
        [self closeLoadingView];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
        
    }];
    
    

}
//店铺是否收藏
-(void)isshoucang{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
    NSDictionary *params = @{@"do":@"sel"};
    
    [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
        NSLog(@"请求成功responseObject===%@",responseObject);
        if ([responseObject[@"code"]isEqual:@0]) {
            if ([responseObject[@"data"][@"shop_list"] isKindOfClass:[NSString class]]) {
                
                shoucangBtn.selected = NO;
                
            }else{
            
                NSMutableArray *dpIDArr = [NSMutableArray array];
                
                for (NSDictionary *tempdic in responseObject[@"data"][@"shop_list"]) {
                    
                    [dpIDArr addObject:tempdic[@"shopid"]];
      
                }
                
                if ([dpIDArr containsObject:_dpid]) {
                    shoucangBtn.selected = YES;
                }else{
                    shoucangBtn.selected = NO;
                }
                
            }
        }else if ([responseObject[@"code"]isEqual:@1002]){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败 error===%@",error);
        
    }];
    
}

-(void)shoucang:(id)sender{
//    shoucangBtn.selected = !shoucangBtn.selected;

    if (userid) {
        if (!shoucangBtn.selected) {
            
            NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
            NSDictionary *params = @{@"do":@"add",@"shopid":_dpid,@"uname":@"ml_13771961207",@"shopname":shopNameLab.text};
            
            [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
                NSLog(@"请求成功responseObject=1111=%@",responseObject);
                
                _hud = [[MBProgressHUD alloc]initWithView:self.view];
                [self.view addSubview:_hud];
                if ([responseObject[@"code"]isEqual:@0]) {
                    if ([responseObject[@"data"][@"shop_add"]isEqual:@1]) {
                        shoucangBtn.selected = YES;
                        [_hud show:YES];
                        _hud.mode = MBProgressHUDModeText;
                        _hud.labelText = @"收藏成功";
                        [_hud hide:YES afterDelay:1];
                        
                    }else{
                        
                        [_hud show:YES];
                        _hud.mode = MBProgressHUDModeText;
                        _hud.labelText = @"收藏失败";
                        [_hud hide:YES afterDelay:1];
                        
                    }
                }else if ([responseObject[@"code"]isEqual:@1002]){
                    
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                    [_hud hide:YES afterDelay:1];
                    [self showError];
                }else{
                    NSString *msg = responseObject[@"msg"];
                    [MBProgressHUD show:msg view:self.view];
                }
                
            } failure:^(NSError *error) {
                
                NSLog(@"请求失败 error===%@",error);
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"请求失败";
                [_hud hide:YES afterDelay:1];
                
                
            }];
        }else{
            
            NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
            NSDictionary *params = @{@"do":@"sel"};
            
            [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
                NSLog(@"请求成功responseObject=quxiao=%@",responseObject);
                
                if ([responseObject[@"data"][@"shop_list"] isKindOfClass:[NSString class]]) {
                    
                    
                }else{
                    for (NSDictionary *tempdic in responseObject[@"data"][@"shop_list"]) {
                        if ([_dpid isEqualToString:tempdic[@"shopid"]]) {
                            
                            NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
                            NSDictionary *params = @{@"do":@"del",@"id":tempdic[@"id"]};
                            [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
                                NSLog(@"请求成功responseObject==222=%@",responseObject);
                                
                                _hud = [[MBProgressHUD alloc]initWithView:self.view];
                                [self.view addSubview:_hud];
                                if ([responseObject[@"code"]isEqual:@0]) {
                                    if ([responseObject[@"data"][@"shop_del"]isEqual:@1]) {
                                        //                                    self.GuanzhuBtn.selected = NO;
                                        shoucangBtn.selected = NO;
                                        [_hud show:YES];
                                        _hud.mode = MBProgressHUDModeText;
                                        _hud.labelText = @"取消收藏成功";
                                        [_hud hide:YES afterDelay:2];
                                        
                                    }else{
                                        
                                        [_hud show:YES];
                                        _hud.mode = MBProgressHUDModeText;
                                        _hud.labelText = @"您的网络不给力啊";
                                        [_hud hide:YES afterDelay:1];
                                    }
                                }else if ([responseObject[@"code"]isEqual:@1002]){
                                    
                                    [_hud show:YES];
                                    _hud.mode = MBProgressHUDModeText;
                                    _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                                    [_hud hide:YES afterDelay:1];
                                    [self showError];
                                }else{
                                    NSString *msg = responseObject[@"msg"];
                                    [MBProgressHUD show:msg view:self.view];
                                }
                                
                                
                            } failure:^(NSError *error) {
                                NSLog(@"请求失败 error===%@",error);
                                [_hud show:YES];
                                _hud.mode = MBProgressHUDModeText;
                                _hud.labelText = @"请求失败";
                                [_hud hide:YES afterDelay:1];
                                
                            }];
                        }
                    }
                }
                
            } failure:^(NSError *error) {
                NSLog(@"请求失败 error===%@",error);
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"请求失败";
                [_hud hide:YES afterDelay:1];
                
            }];
            
        }
    }else{
        [MBProgressHUD show:@"请先登录" view:self.view];
        [self showError];
    }
    
}
-(void)showError
{
    MLLoginViewController *vc = [[MLLoginViewController alloc]init];
    vc.isLogin = YES;
    [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark- 图片相关
- (void)imageUIInit {
    
    CGFloat imageScrollViewWidth = MAIN_SCREEN_WIDTH;
    CGFloat imageScrollViewHeight = _imageScrollView.bounds.size.height;
    
    for(int i = 0; i<imgArr.count; i++) {
        if ([imgArr[i] isKindOfClass:[NSNull class]]) {
            continue;
        }
    }
    for (int i=0; i<imgArr.count; i++) {
        
        UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(imageScrollViewWidth*i, 0, imageScrollViewWidth,imageScrollViewHeight)];
        
        if ([imgArr[i] hasSuffix:@"webp"]) {
            [imageview setZLWebPImageWithURLStr:imgArr[i] withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [imageview sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        }
        // imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.tag = i;
        imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
        [imageview addGestureRecognizer:singleTap];
        [_imageScrollView addSubview:imageview];
    }
    
    _imageScrollView.contentSize = CGSizeMake(imageScrollViewWidth*imgArr.count, 0);
    _imageScrollView.bounces = NO;
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.delegate = self;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    
    _pagecontrol.numberOfPages = imgArr.count;
    
    _pagecontrol.tintColor = [UIColor whiteColor];
    _pagecontrol.currentPageIndicatorTintColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
    
    
}

- (void)photoTapped:(UITapGestureRecognizer *)tap{
    NSLog(@"tap.view.tag--->%ld",tap.view.tag);
//    NSString * sender;
//    NSString * type;
//    NSString * title;
//    if (adimageArr && adimageArr.count>0) {
//        NSDictionary *tempdic = adimageArr[tap.view.tag];
//        type = tempdic[@"ggtype"]?:@"";
//        title = tempdic[@"title"]?:@"";
//        
//        if ([type isEqualToString:@"4"]) {
//            sender = tempdic[@"url"]?:@"";
//            
//        }else{
//            sender = tempdic[@"ggv"]?:@"";
//            title = @"";
//        }
//        [self pushToType:type withUi:sender title:title];
//    }
    
}

//开启定时器
- (void)addTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

//设置当前页 实现自动滚动
- (void)nextImage
{
    int page = (int)_pagecontrol.currentPage;
    
    if (page == imgArr.count-1) {
        
        page = 0;
        
    }else{
        
        page++;
        
    }
    
    CGFloat x = page * _imageScrollView.frame.size.width;
    [_imageScrollView  setContentOffset:CGPointMake(x, 0) animated:YES];
    
}
//关闭定时器
- (void)removeTimer
{
    [self.timer invalidate];
}

#pragma mark ScrollView代理方法开始
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (scrollView == _imageScrollView) {
        CGFloat scrollviewW =  scrollView.frame.size.width;
        CGFloat x = scrollView.contentOffset.x;
        int page = (x + scrollviewW / 2) /  scrollviewW;
        _pagecontrol.currentPage = page;
    }
    else{
//        if (self.secondDelegate && [self.secondDelegate respondsToSelector:@selector(secondViewController:withContentOffest:)]) {
//            [self.secondDelegate secondViewController:self withContentOffest:scrollView.contentOffset.y];
//            
//        }
//        
        if (scrollView.contentOffset.y > 200.0f) {
            self.backBtn.hidden = NO;
        }
        else{
            self.backBtn.hidden = YES;
        }
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖拽");
    [self removeTimer];
    
//    if (self.secondDelegate && [self.secondDelegate respondsToSelector:@selector(secondViewController:withBeginOffest:)]) {
//        [self.secondDelegate secondViewController:self withBeginOffest:scrollView.contentOffset.y];
//    }
    
}
//拖拽结束后开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
    
    
}

-(void)backTopButtonAction:(UIButton*)sender{
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

//- (NSMutableArray *)imgArr{
//    if (!_imgArr) {
//        _imgArr = [NSMutableArray array];
//        
//    }
//    return _imgArr;
//}

//- (NSMutableArray *)shopGoodsListArr{
//    if (!_shopGoodsListArr) {
//        _shopGoodsListArr = [NSMutableArray array];
//        
//    }
//    return _shopGoodsListArr;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
