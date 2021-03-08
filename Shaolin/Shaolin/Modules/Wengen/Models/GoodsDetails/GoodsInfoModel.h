//
//  GoodsInfo.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsInfoModel : NSObject

@property(nonatomic, copy)NSString *catePidId;
@property(nonatomic, copy)NSString *clubId;
@property(nonatomic, copy)NSString *desc;
@property(nonatomic, copy)NSString *goodsSn;
///商品规格参数
@property(nonatomic, strong)NSArray *goodsValueList;
///卖出数量
@property(nonatomic, copy)NSString *hasNum;
@property(nonatomic, copy)NSString *goodsid;
@property(nonatomic, copy)NSString *imgData;
@property(nonatomic, strong)NSArray *imgDataList;
@property(nonatomic, copy)NSString *intro;
@property(nonatomic, copy)NSString *isCheck;
//是否有折扣价
@property(nonatomic, copy)NSString *isDiscount;
@property(nonatomic, copy)NSString *isHot;
///是否自营 1，自营 0非自营
@property(nonatomic, copy)NSString *isSelf;
/// 是否统一运费
@property(nonatomic, copy)NSString *isShipping;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *oldPrice;
@property(nonatomic, copy)NSString *price;
@property(nonatomic, copy)NSString *shippingFee;
@property(nonatomic, copy)NSString *star;
@property(nonatomic, copy)NSString *stock;
@property(nonatomic, copy)NSString *templateId;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *userNum;
@property(nonatomic, copy)NSString *videoUrl;
@property(nonatomic, copy)NSString *weight;


//---------------------------------------------- 
@property(nonatomic, strong)NSArray *attr;
@property(nonatomic, strong)NSArray *attrStr;
//私有的，记录商品规格所对应的商品信息id
//用于查询商品库存
@property(nonatomic, copy)NSString *goodsSpecificationId;
///商品规格参数是否展开
@property(nonatomic, assign)BOOL isGoodsSpecificationSpread;
@property(nonatomic, copy)NSDictionary *attrDetail;

@end

NS_ASSUME_NONNULL_END

/**
 "brandId": null,
             "cateId": null,
             "catePidId": 5,
             "checkMessage": "",
             "clubId": 17,
             "cover": "",
             "createTime": null,
             "currentPrice": 25.00,
             "desc": "  达摩膏为纯中药制作，具有追风透骨、靶向给药，在促进局部微循环的同时更能拔出风寒湿邪等长期积累在身体内的“湿毒”，使得人的局部机能得到修复，从而使人的动力系统得到平衡，达到“通则不痛”、止痛更治痛的目的。",
             "desc2": "",
             "discount": false,
             "evaNum": null,
             "goodsAttrStrId": null,
             "goodsAttrStrName": "",
             "goodsNext": "",
             "goodsSort": null,
             "hasNum": 46,
             "id": null,
             "imgData": "[\"https:\\/\\/static.oss.cdn.oss.gaoshier.cn\\/image\\/05168bee-0af9-4ccb-bb63-c122425dadd2.jpg\",\"https:\\/\\/static.oss.cdn.oss.gaoshier.cn\\/image\\/1e0b6a15-77e1-4637-bb11-85653c88481a.jpg\",\"https:\\/\\/static.oss.cdn.oss.gaoshier.cn\\/image\\/1dd11c40-0040-42dc-bb6d-095ba6b610c2.jpg\",\"https:\\/\\/static.oss.cdn.oss.gaoshier.cn\\/image\\/93d7b119-a524-43a6-a8cb-d25c5f28f8a6.jpg\",\"https:\\/\\/static.oss.cdn.oss.gaoshier.cn\\/image\\/8a815f99-1563-42c7-a824-da2e4b04a58c.jpg\"]",
             "imgDateList": [],
             "imgUrl": "",
             "intro": "&amp;lt;p style=&amp;quot;;text-align: justify;font-size: 14px;font-family: DengXian;white-space: normal&amp;quot;&amp;gt;少林达摩膏简介&amp;lt;/p&amp;gt;&amp;lt;p style=&amp;quot;;text-align: justify;font-size: 14px;font-family: DengXian;white-space: normal&amp;quot;&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp; 一、特点：&amp;lt;/p&amp;gt;&amp;lt;p style=&amp;quot;;text-align: justify;font-size: 14px;font-family: DengXian;white-space: normal&amp;quot;&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp; 达摩膏为纯中药制作，具有追风透骨、靶向给药，在促进局部微循环的同时更能拔出风寒湿邪等长期积累在身体内的“湿毒”，使得人的局部机能得到修复，从而使人的动力系统得到平衡，达到“通则不痛”、止痛更治痛的目的。&amp;lt;/p&amp;gt;&amp;lt;p style=&amp;quot;;text-align: justify;font-size: 14px;font-family: DengXian;white-space: normal&amp;quot;&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp; 二、多长时间可愈？&amp;lt;/p&amp;gt;&amp;lt;p style=&amp;quot;;text-align: justify;font-size: 14px;font-family: DengXian;white-space: normal&amp;quot;&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp;&amp;amp;nbsp; 达摩膏每贴可贴2天，1个小周期10盒，完整周期约需25盒，一个月的量，一般情况下病轻者1周期，重者2-3周期轻松解除你的烦恼。对于那些病程日久、顽固性的患者请说明详细的症状，以便我们为你制定详细的方案。治百病，不治百人，每个人的情况不一样，病程长短也不一样，因为某些手术的适应症就不是膏药所能解决的，如果坚持绝对痊愈的患者请绕行！&amp;lt;/p&amp;gt;&amp;lt;p&amp;gt;&amp;lt;img src=&amp;quot;https://static.oss.cdn.oss.gaoshier.cn/image/13f86b1f-dec4-4c81-9525-e75bf41f04f9.jpg&amp;quot; title=&amp;quot;13f86b1f-dec4-4c81-9525-e75bf41f04f9.jpg&amp;quot; alt=&amp;quot;详情1.jpg&amp;quot;/&amp;gt;&amp;lt;img src=&amp;quot;https://static.oss.cdn.oss.gaoshier.cn/image/05a5610e-d178-48c7-97a0-7b3032071104.jpg&amp;quot; title=&amp;quot;05a5610e-d178-48c7-97a0-7b3032071104.jpg&amp;quot; alt=&amp;quot;详情2.jpg&amp;quot;/&amp;gt;&amp;lt;img src=&amp;quot;https://static.oss.cdn.oss.gaoshier.cn/image/0f1bfe34-918b-434f-8b06-91ef2de237a7.jpg&amp;quot; title=&amp;quot;0f1bfe34-918b-434f-8b06-91ef2de237a7.jpg&amp;quot; alt=&amp;quot;详情3.jpg&amp;quot;/&amp;gt;&amp;lt;img src=&amp;quot;https://static.oss.cdn.oss.gaoshier.cn/image/228be427-c423-4825-a408-f9ab1349c738.jpg&amp;quot; title=&amp;quot;228be427-c423-4825-a408-f9ab1349c738.jpg&amp;quot; alt=&amp;quot;详情4.jpg&amp;quot;/&amp;gt;&amp;lt;img src=&amp;quot;https://static.oss.cdn.oss.gaoshier.cn/image/ffcc2ca8-792a-4d93-ba28-40d9ca756d39.jpg&amp;quot; title=&amp;quot;ffcc2ca8-792a-4d93-ba28-40d9ca756d39.jpg&amp;quot; alt=&amp;quot;详情5.jpg&amp;quot;/&amp;gt;&amp;lt;img src=&amp;quot;https://static.oss.cdn.oss.gaoshier.cn/image/1136be78-826f-4a9a-81dc-f1ed96aa1bb0.jpg&amp;quot; title=&amp;quot;1136be78-826f-4a9a-81dc-f1ed96aa1bb0.jpg&amp;quot; alt=&amp;quot;详情6.jpg&amp;quot;/&amp;gt;&amp;lt;img src=&amp;quot;https://static.oss.cdn.oss.gaoshier.cn/image/72735793-540f-443f-bf4e-1aabe999dd00.jpg&amp;quot; title=&amp;quot;72735793-540f-443f-bf4e-1aabe999dd00.jpg&amp;quot; alt=&amp;quot;详情7.jpg&amp;quot;/&amp;gt;&amp;lt;img src=&amp;quot;https://static.oss.cdn.oss.gaoshier.cn/image/833cdd07-b573-4f6b-b326-28d963c5bdf2.jpg&amp;quot; title=&amp;quot;833cdd07-b573-4f6b-b326-28d963c5bdf2.jpg&amp;quot; alt=&amp;quot;详情8.jpg&amp;quot;/&amp;gt;&amp;lt;img src=&amp;quot;https://static.oss.cdn.oss.gaoshier.cn/image/743636ce-818d-4765-87fa-460fd945ad9e.jpg&amp;quot; title=&amp;quot;743636ce-818d-4765-87fa-460fd945ad9e.jpg&amp;quot; alt=&amp;quot;详情9.jpg&amp;quot;/&amp;gt;&amp;lt;/p&amp;gt;",
             "isCheck": 1,
             "isDelicate": null,
             "isDiscount": 0,
             "isHot": 0,
             "isNew": null,
             "isSelf": 1,
             "isShipping": null,
             "level": null,
             "lookLevel": "",
             "name": "少林达摩膏官方旗舰店筋骨贴正品德福堂万骨利 ",
             "oldPrice": 25.00,
             "payType": null,
             "price": 5.00,
             "shippingFee": null,
             "star": null,
             "status": null,
             "stock": 300,
             "subjectId": null,
             "tStar": null,
             "template": 4,
             "type": 1,
             "userNum": 42,
             "videoUrl": "",
             "weight": "0"
 */

/**
 {
 "code": 200,
 "msg": "获取商品详情成功",
 "data": {
 "id": 25,
 "name": "禅茶具",
 "intro": "禅文化红土茶具",
 "cate_pid_id": 434,
 "img_data": [
 "https:\/\/img.adidas.com.cn\/resources\/2019kvbanner\/nov\/keysilo-nov-transparent-EE7392.png?version=000000",
 "https:\/\/img.adidas.com.cn\/resources\/2019kvbanner\/nov\/stball-silos.png?version=000000"
 ],
 "price": "100.00",
 "old_price": "0.00",
 "video_url": "",
 "is_hot": "",
 "stock": 10,
 "user_num": "",
 "desc": "简介",
 "weight": "0",
 "club_id": 3,
 "type": 1,
 "attr": [
 {
 "id": 1,
 "goods_id": 25,
 "pid": 0,
 "name": "颜色",
 "value": "蓝色",
 "price": "0.00",
 "current_price": "0.00",
 "stock": 0,
 "has_number": 0,
 "weight": "0",
 "image": "",
 "video": "",
 "nextAttr": [
 {
 "id": 3,
 "goods_id": 4,
 "pid": 1,
 "name": "尺码",
 "value": "xl",
 "price": "10.00",
 "current_price": "10.00",
 "stock": 10,
 "has_number": 0,
 "weight": "0",
 "image": "",
 "video": ""
 },
 {
 "id": 4,
 "goods_id": 25,
 "pid": 1,
 "name": "尺码",
 "value": "xl",
 "price": "10.00",
 "current_price": "10.00",
 "stock": 10,
 "has_number": 1,
 "weight": "0",
 "image": "",
 "video": ""
 }
 ]
 }
 ],
 "goods_sn": "10000000025",
 "shopping_fee": 0
 }
 }
 */
