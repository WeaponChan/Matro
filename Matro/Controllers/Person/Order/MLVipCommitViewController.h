//
//  MLVipCommitViewController.h
//  Matro
//
//  Created by LHKH on 16/12/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLVipCommitViewController : MLBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property(copy,nonatomic)NSString *selCardId;//typeid
@property(copy,nonatomic)NSString *selcardID;//cardid
@property (copy,nonatomic)NSString *selCardNo;
@end
