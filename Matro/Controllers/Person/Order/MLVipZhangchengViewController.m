//
//  MLVipZhangchengViewController.m
//  Matro
//
//  Created by LHKH on 16/12/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLVipZhangchengViewController.h"
#import "MLHttpManager.h"
#import "CommonHeader.h"
#import "HFSConstants.h"
#import "MBProgressHUD+Add.h"
@interface MLVipZhangchengViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation MLVipZhangchengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"会员章程";
    _webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        webView.delegate = self;
        [self.view addSubview:webView];
        webView;
    });
    [self getcardZhangcheng];
}

//获取会员卡章程
-(void)getcardZhangcheng{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_cardup&action=getCradConstitution",MATROJP_BASE_URL];
    [MLHttpManager get:url params:nil m:@"member" s:@"admin_cardup" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"result===%@",result);
        if ([result[@"code"] isEqual:@0]) {
            NSString *htmlCode = result[@"data"][@"CradConstitution"];
            [_webView loadHTMLString:htmlCode baseURL:nil];
        }
        else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showSuccess:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var script = document.createElement('script');"
                                                     "script.type = 'text/javascript';"
                                                     "script.text = \"function ResizeImages() { "
                                                     "var myimg,oldwidth;"
                                                     "var maxwidth=%f;" //缩放系数
                                                     "for(i=0;i <document.images.length;i++){"
                                                     "myimg = document.images[i];"
                                                     "if(myimg.width > maxwidth){"
                                                     "oldwidth = myimg.width;"
                                                     "myimg.width = maxwidth;"
                                                     "myimg.height = myimg.height * (maxwidth/oldwidth);"
                                                     "}"
                                                     "}"
                                                     "}\";"
                                                     "document.getElementsByTagName('head')[0].appendChild(script);",MAIN_SCREEN_WIDTH]
     ];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
}

@end
