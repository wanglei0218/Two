//
//  USERBangZhuData.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/7/2.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERBangZhuData.h"

static USERBangZhuData *_defaulthandle = nil;

@interface USERBangZhuData ()
@property(nonatomic,strong)FMDatabase *fMDB;

@end

@implementation USERBangZhuData

+(USERBangZhuData *)sharedAllBangZhuData;
{
    if (_defaulthandle == nil) {
        _defaulthandle = [[USERBangZhuData alloc] init];
        
    }
    return _defaulthandle;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_defaulthandle == nil) {
        _defaulthandle = [super allocWithZone:zone];
    }
    return _defaulthandle;
}


-(FMDatabase *)fMDB{
    if (!_fMDB) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"zhuData.sqlite"];
        
        _fMDB = [FMDatabase databaseWithPath:path];
        [self initTable];
    }
    return _fMDB;
}


// 初始化数据表
-(void)initTable
{
    [_fMDB open];
    
    [_fMDB executeUpdate:@"CREATE TABLE zhuData (id INTEGER PRIMARY KEY AUTOINCREMENT,status TEXT,name TEXT,subTle TEXT,title TEXT,phoneNum TEXT,elseName TEXT,elsePhone TEXT,price TEXT,time TEXT,address TEXT)"];
    
    [_fMDB close];
}



-(void)addOneData:(USERModel *)user
{
    [self.fMDB open];
    
    [self.fMDB executeUpdateWithFormat:@"insert into zhuData (status,name,subTle,title,phoneNum,elseName,elsePhone,price,time,address) values(%ld,%@,%@,%@,%@,%@,%@,%@,%@,%@)",user.status,user.name,user.subTle,user.title,user.phoneNum,user.elseName,user.elsePhone,user.price,user.time,user.address];
    
    [self.fMDB close];
}

-(void)deleteDataByID:(int)delID
{
    [self.fMDB open];
    
    [self.fMDB executeUpdateWithFormat:@"DELETE FROM zhuData WHERE id = %d",delID];
    
    [self.fMDB close];
}

-(NSArray *)getAllDatas
{
    [self.fMDB open];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    FMResultSet *result = [self.fMDB executeQuery:@"SELECT * FROM zhuData"];
    while ([result next])
    {
        USERModel *model = [[USERModel alloc] init];
        [arr addObject:model];
        
        model.ID = [result intForColumnIndex:0];
        model.status = [result intForColumnIndex:1];
        model.name = [result stringForColumnIndex:2];
        model.subTle = [result stringForColumnIndex:3];
        model.title = [result stringForColumnIndex:4];
        model.phoneNum = [result stringForColumnIndex:5];
        model.elseName = [result stringForColumnIndex:6];
        model.elsePhone = [result stringForColumnIndex:7];
        model.price = [result stringForColumnIndex:8];
        model.time = [result stringForColumnIndex:9];
        model.address = [result stringForColumnIndex:10];
        
    }
    [self.fMDB close];
    
    return [arr copy];
}

-(void)deleteTable{
    [self.fMDB open];
    //如果表格存在 则销毁
    BOOL result1 = [self.fMDB executeUpdate:@"drop table if exists zhuData"];
    
    if (result1 ) {
//        NSLog(@"--------------------删除表1成功");
    } else {
//        NSLog(@"--------------------删除表1失败");
    }
    [self.fMDB close];
}

@end
