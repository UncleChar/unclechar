//
//  RichTextEditorViewController.m
//  UncleCharDemos
//
//  Created by LingLi on 16/1/27.
//  Copyright © 2016年 hailong.xie. All rights reserved.
//

#import "RichTextEditorViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJSON.h"
@interface RichTextEditorViewController ()

@end

@implementation RichTextEditorViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = 0;
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"ZSSRichTextEditor";

    // Export HTML
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(exportHTML)];
    
    UITextField *tt = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 80, 7, 160, 30)];
    tt.text = @"test";
    tt.textAlignment = 1;
    tt.borderStyle = UITextBorderStyleRoundedRect;
    tt.backgroundColor = [UIColor clearColor];
    
    
    [self.navigationController.navigationBar addSubview: tt];
    
    
     NSString  *str = [NSString stringWithFormat:@"%@file/getNote/%@",@"http://101.231.216.75:8080/api/",@"8787"];
    
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://101.231.216.75:8080/api/file/getNote/8787"]];
    [request setValidatesSecureCertificate:NO];   //-----https
    [request setQueuePriority:NSOperationQueuePriorityNormal];
    [request addRequestHeader:@"Content-Type"
                        value:@"application/x-www-form-urlencoded"];
    
    [request addRequestHeader:@"HTTP_X_OAUTH"
                        value:@"d74aefd098268bca95bd49e9b0f8135a"];
    [request addRequestHeader:@"CLOUD_ID" value:@"2"];
    
    [request setDidFinishSelector:@selector(requestFinished1:)];
    

    [request setDidFailSelector:@selector(failed:)];
//    [request setRequestDidFailSelector:@selector(requestFailed1:)];

    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"509",@"tag",nil]];
    // [request setDelegate:self];
    __block ASIHTTPRequest *blockRequest = request;
    [request setCompletionBlock:^{
        [self requestFinished1:blockRequest];
    }];
    
    [request setFailedBlock:^{
        [self failed:blockRequest];
    }];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request setTimeOutSeconds:30.0f];

    
    
    
    [request startAsynchronous];

    
    
    
    
    
    // HTML Content to set in the editor
    NSString *html = @"xbfvffbgfgbfgbfnfn<!-- note This is an HTML comment -->"
    "<p>This is a test of the <strong>ZSSRichTextEditor 全携通 测试。</strong> by <a title=\"Zed Said\" href=\"http://www.zedsaid.com\">Zed Said Studio</a></p>";
    
    
    
    
    // Set the base URL if you would like to use relative links, such as to images.
//    self.baseURL = [NSURL URLWithString:@"http://www.zedsaid.com"];
//    
//    // If you want to pretty print HTML within the source view.
//    self.formatHTML = YES;
//    
//    // Set the toolbar item color
//    //self.toolbarItemTintColor = [UIColor greenColor];
//    
//    // Set the toolbar selected color
//    //self.toolbarItemSelectedTintColor = [UIColor brownColor];
//    
//    // Choose which toolbar items to show
//    //self.enabledToolbarItems = ZSSRichTextEditorToolbarSuperscript | ZSSRichTextEditorToolbarUnderline | ZSSRichTextEditorToolbarH1 | ZSSRichTextEditorToolbarH3;
//    
//    // Set the HTML contents of the editor
//    [self setHtml:html];
    // Do any additional setup after loading the view.
}

- (void)exportHTML {
    
    NSLog(@"%@", [self getHTML]);
    
}

- (void)requestFinished1:(ASIHTTPRequest *)request { //获取网络并实现吧图片存入沙盒，接着想设计好数据库存取数据，包括视频图片之类的所有文件
    
    NSData *responseData = [request responseData];
    NSString *dataString = [[NSString alloc] initWithData:responseData
                                                 encoding:NSUTF8StringEncoding];
    SBJSON *jsonParser = [[SBJSON alloc] init];
    
    NSError *parseError = nil;
    NSDictionary * result = [jsonParser objectWithString:dataString
                                                   error:&parseError];
//    NSLog(@"jsonParserresult:%@",result);

    

    NSString *html = [[result objectForKey:@"result"] objectForKey:@"file_content"];
    
    
     NSLog(@"jsonParserresult:%@",html);
    
    self.baseURL = [NSURL URLWithString:@"http://www.zedsaid.com"];
    
    // If you want to pretty print HTML within the source view.
    self.formatHTML = YES;
    
    // Set the toolbar item color
    //self.toolbarItemTintColor = [UIColor greenColor];
    
    // Set the toolbar selected color
    //self.toolbarItemSelectedTintColor = [UIColor brownColor];
    
    // Choose which toolbar items to show
    //self.enabledToolbarItems = ZSSRichTextEditorToolbarSuperscript | ZSSRichTextEditorToolbarUnderline | ZSSRichTextEditorToolbarH1 | ZSSRichTextEditorToolbarH3;
    
    // Set the HTML contents of the editor
    [self setHtml:html];

    
}

- (void)failed:(ASIHTTPRequest *)request {


    NSData  *receiveData = [request responseData];
    
    NSLog(@"-----%@,%@",[request responseString],receiveData);
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
