//
//  ViewController.m
//  XMix
//
//  Created by davidli on 15/6/29.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "ViewController.h"
#import "MovieViewController.h"
#import "GCDViewController.h"
#import "TLVersionHelper.h"
#import "OauthViewController.h"
#import "MainCollectionViewController.h"
#import "WKWebviewController.h"

#import "Student.h"
#import "Fox.h"
#import "PeriscopeViewController.h"
#import "XSpeechController.h"

CGFloat const kHeightOfTopMargin    =  64;
CGFloat const kHeightOfTopOffset    =  60;


typedef void (^XMixBlock)(id data);

@interface ViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
TLVersionHelperProtocol,
UIAlertViewDelegate,
UIViewControllerPreviewingDelegate
>

@property (nonatomic, strong) TLVersionHelper *helper;
@property (weak, nonatomic) IBOutlet UITableView *mTableview;
@property (nonatomic, strong) NSMutableArray *mDatasource;
@property (nonatomic, copy) NSString *urlStr;

@end

@implementation ViewController

-(TLVersionHelper *)helper{
    if (!_helper) {
        _helper = [TLVersionHelper new];
    }
    return _helper;
}

#pragma mark -周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUps];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setHidesBottomBarWhenPushed:NO];
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -DELEGATE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_mDatasource count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (NONE == indexPath.row) {
        cell.textLabel.text = @"观看视频";
    }else if (ONE == indexPath.row){
        cell.textLabel.text = @"多线程-GCD";
    }else if (2 == indexPath.row){
        cell.textLabel.text = @"app跳转";
    }else if (3 == indexPath.row){
        cell.textLabel.text = @"检测版本号";
    }else if (4 == indexPath.row){
        cell.textLabel.text = @"Facebook Twitter";
    }else if (5 == indexPath.row){
        cell.textLabel.text = @"Window";
    }else if (6 == indexPath.row){
        cell.textLabel.text = @"序列化/反序列化";
    }else if (7 == indexPath.row){
        cell.textLabel.text = @"3D Touch检测";
    }else if (8 == indexPath.row){
        cell.textLabel.text = @"动态添加Quick Action";
    }else if (9 == indexPath.row){
        cell.textLabel.text = @"Persiscope";
    }else if (10 == indexPath.row){
        cell.textLabel.text = @"Method";
    }else if (11 == indexPath.row){
        cell.textLabel.text = @"翻译官";
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == NONE)
    {
        MovieViewController *movieViewControlelr = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieViewController"];
        [self.navigationController pushViewController:movieViewControlelr animated:YES];
    }else if (ONE == indexPath.row)
    {
        GCDViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"GCD"];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }else if (2 == indexPath.row)
    {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        mDic[@"sourcescheme"] = @"XMix";
        mDic[@"sourceapp"]    = @"D.XMix";
        mDic[@"sourceappname"]= @"XMix";
        mDic[@"pic"]          = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superplus/img/logo_white_ee663702.png";
        mDic[@"roomType"]     = @(17);
        mDic[@"version"]      = @(21);
        mDic[@"optType"]      = @(1);
        mDic[@"account"]      = @(30000081);

        NSError *error    = nil;
        NSData *strData   = [NSJSONSerialization dataWithJSONObject:mDic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonStr = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
        NSString *urlStr  = [jsonStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *finalStr= [NSString stringWithFormat:@"taole734c433198fd6b30://%@",urlStr];

        NSURL *url = [NSURL URLWithString:finalStr];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }else if (3 == indexPath.row)
    {
        TLVerRequestEntity *verEntity = [TLVerRequestEntity new];
        verEntity.target = VERSION_TARGET_DANDELION;
        verEntity.api = @"http://www.pgyer.com/apiv1/app/viewGroup";
        verEntity.appID = @"7a779b5ceca4c8a0ed85832ed2c94d2d";
        verEntity.apiKey = @"994824468692f7d89ca8308f74c93405";
        
        [self.helper httpReqVersionWithEntity:verEntity delegate:self];
        
    }else if (4 == indexPath.row){
        OauthViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"oauthViewController"];
        [self.navigationController pushViewController:viewController animated:YES];

    }else if (5 == indexPath.row){
        UIWindow *window = [[UIWindow alloc] initWithFrame:self.view.window.frame];
        window.windowLevel = UIWindowLevelStatusBar;
        window.backgroundColor = RGBACOLOR(255, 0, 0, 0.5);
        window.userInteractionEnabled = NO;
        [window makeKeyAndVisible];

        //timer持有window对象 此window会显示出来 否则即使makeKeyAndVisible也看不到
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onReleaseWindow:) userInfo:window repeats:NO];

    }else if (6 == indexPath.row){

        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"xxx"];
        Student *student1 = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        Student *student = [Student new];
        student.name = @"David";
        student.hobby = @"DOTA2";
        student.age = 25;
        student.sex = ONE;
        student.married = NO;
        student.className = @"1年1班";
        student.classNumber = 5;
        student.niceClass = YES;

        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:student] forKey:@"xxx"];

        Student *copyStudent = [student copy];
        TraceS(@"++++++%@",copyStudent);

    }else if (7 == indexPath.row){
        NSString *message = @"Sorry,你的手机不支持3D Touch！";
        NSString *version = [[UIDevice currentDevice] systemVersion];
        if (9.0 <= [version doubleValue]) {
            if (UIForceTouchCapabilityAvailable == self.traitCollection.forceTouchCapability) {
                message = @"恭喜，你的手机支持3D Touch！";
            }
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }else if (8 == indexPath.row){

        NSString *version = [[UIDevice currentDevice] systemVersion];
        if (9.0 > [version doubleValue]) {
            return;
        }
        UIApplication *application = [UIApplication sharedApplication];
        UIApplicationShortcutIcon *cameraIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCaptureVideo];
        UIApplicationShortcutItem *cameraItem = [[UIApplicationShortcutItem alloc] initWithType:@"Three" localizedTitle:@"拍照菌" localizedSubtitle:@"自信点 你很美!" icon:cameraIcon userInfo:nil];

        UIApplicationShortcutIcon *shareIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
        UIApplicationShortcutItem *shareItem = [[UIApplicationShortcutItem alloc] initWithType:@"Four" localizedTitle:@"分享菌" localizedSubtitle:@"分享 让你更快乐！" icon:shareIcon userInfo:nil];
        application.shortcutItems = @[cameraItem,shareItem];
    }else if (9 == indexPath.row){
        PeriscopeViewController *viewControl = [self.storyboard instantiateViewControllerWithIdentifier:@"Periscope"];
        [self.navigationController pushViewController:viewControl animated:YES];
    }else if (10 == indexPath.row){
        id fox = [[Fox alloc] init];
        [fox performSelector:@selector(testMethod) withObject:nil afterDelay:NONE];
    }else if (11 == indexPath.row){
        XSpeechController *speech = [self.storyboard instantiateViewControllerWithIdentifier:@"XSpeech"];
        [self.navigationController pushViewController:speech animated:YES];
    }
}



#pragma mark -UIViewPreview Delegete

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath *indexPath = [_mTableview indexPathForRowAtPoint:location];
    if (8 == indexPath.row) {
        UITableViewCell *cell = [_mTableview cellForRowAtIndexPath:indexPath];
        previewingContext.sourceRect = cell.frame;

        MovieViewController *movieViewControlelr = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieViewController"];
        movieViewControlelr.preferredContentSize = CGSizeMake(300, 400);
        return movieViewControlelr;
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}



#pragma mark - versionHelper 代理
-(void)versionHelper:(TLVersionHelper *)versionHelper onFinishedWithResult:(TLVerResultEntity *)resultEntity{
    
    NSString *message = [NSString stringWithFormat:@"++版本:%@++\n下载链接:%@\n更新说明:%@\n错误:%@",resultEntity.version,resultEntity.downLoadUrl,resultEntity.updateDes,resultEntity.error];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"版本信息" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertview show];
    
    _urlStr = resultEntity.downLoadUrl;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (ONE == buttonIndex) {
        NSURL *url = [NSURL URLWithString:_urlStr];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}



#pragma mark -BUSINESS
-(void)search
{
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (NSInteger i = ONE; i<= 10000; i++) {
        [mArray addObject:@(i)];
    }
    
    NSInteger min = NONE, max = [mArray count], mid = NONE; //置当前查找区间上、下界的初值
    NSInteger target = 500;
    
    while(min <= max){ //当前查找区间R[min..max]非空
        mid = (min + max) / 2;
        
        TraceS(@"++++++min=%ld  max=%ld",min,max);
        
        if([mArray[mid] integerValue] == target){
            TraceS(@"已查到 index=%ld",mid);
            break;
        }
        else{
            if([mArray[mid] integerValue] > target){
                max = mid-1; //继续在R[min..mid-1]中查找
            }
            else{
                min = mid+1; //继续在R[mid+1..max]中查找
            }
        }
    }
}


-(void)sort{
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSInteger i = NONE; i < 100; i++) {
        NSInteger N = arc4random() % 100;
        [mArray addObject:@(N)];
    }
    
    TraceS(@"+++++++原数组\n%@",mArray);
    
    NSInteger count = mArray.count;
    for (NSInteger i = NONE; i < count; i++) {
        for (NSInteger j = i; j < count; j++) {
            id tmp = mArray[i];
            if (mArray[i] > mArray[j]) {
                mArray[i] = mArray[j];
                mArray[j] = tmp;
            }
        }
    }
    
    TraceS(@"+++++++新数组\n%@",mArray);
}



- (void)onReleaseWindow:(id)data
{
}


#pragma mark -其他
-(void)setUps{
    [self setTitle:@"大杂汇"];

    self.mTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(NONE, NONE, CGRectGetWidth(self.view.frame), NONE)];
    
    _mDatasource = [NSMutableArray array];
    for (NSInteger i = NONE; i < 12; i++) {
        [_mDatasource addObject:@""];
    }

    //3D Touch检测
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if (9.0 <= [version doubleValue]) {
        if (UIForceTouchCapabilityAvailable == self.traitCollection.forceTouchCapability){
            [self registerForPreviewingWithDelegate:self sourceView:self.view];
        }
    }

    //block
    BOOL (^block)(NSInteger,NSInteger) = ^(NSInteger index,NSInteger index2){
        return YES;
    };
    block(ONE,ONE);

    [self textBlock:^(id data) {
        TraceS(@"++++result:%@",data);
    }];
}


-(void)textBlock:(XMixBlock)block
{
    if (ONE == ONE) {
        block(@(YES));
    }
}
@end
