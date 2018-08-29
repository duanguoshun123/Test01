
GO
if not exists(select 1 from WFPost ) 
begin 
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'执行人员',NULL,11)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'执行主管',NULL,1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'业务员',NULL,20)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'业务主管',NULL,20)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'事业部副总经理',NULL,1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'事业部总经理',NULL,1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'总裁',NULL,1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'财务人员',NULL,1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'财务主管',NULL,1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'核算人员',NULL,30)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'核算主管',NULL,1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'资金部人员',NULL,1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'资金部主管',NULL,1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'物流执行人员',NULL,1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'运维人员',N'',1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'其他岗位类别',NULL,1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'内控专员',NULL,1)
INSERT WFPost([Name],[Note],[EnumValue]) VALUES (N'内控部长',NULL,1)
end 
Go
if not exists( select 1 from sys.tables where name=N'WFPrivilege' )  
begin 
CREATE TABLE WFPrivilege(
	[WFFunctionId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Note] [nvarchar](500) NULL,
	[IsDisabled] [bit] NOT NULL,
	[Category] [int] NULL
)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1,N'CreateContract',N'新建合同',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(2,N'SearchContract',N'查询合同',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3,N'ContractCostManagement',N'批次合同费用管理',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(4,N'ContractNoteManagement',N'批次合同备注管理',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(5,N'ContractAttachmentManagement',N'批次合同附件管理',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(6,N'SplitSpecialSpotPrice',N'拆分特殊点价',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(7,N'ContractResidualSettlement',N'批次合同尾款结算',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(8,N'CreatePriceConfirm',N'新建价格确认单',0,42)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(9,N'UpdateContract',N'更新合同',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(10,N'ObsoleteContract',N'作废合同',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(11,N'PrintContract',N'打印合同',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(12,N'FinishContract',N'完成合同',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(13,N'CancelFinishContract',N'撤销完成合同',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(14,N'CreateLongContract',N'新建长单合同',0,2)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(15,N'SearchLongContract',N'查询长单合同',0,2)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(16,N'ContractManagement',N'长单合同批次管理',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(17,N'LongTermContractNoteManagement',N'长单合同备注管理',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(18,N'LongTermContractAttachmentManagement',N'长单合同附件管理',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(19,N'LongTermContractResidualSettlement',N'长单合同尾款结算',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(20,N'UpdateLongContract',N'更新长单合同',0,2)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(21,N'ObsoleteLongContract',N'作废长单合同',0,2)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(22,N'PrintLongContract',N'打印长单合同',0,2)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(23,N'DeleteLongTermContract',N'删除长单合同',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(24,N'FinishLongContract',N'完成长单合同',0,2)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(25,N'CancelFinishLongContract',N'撤销完成长单合同',0,2)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(26,N'CreateReceivingGoodsRecord',N'新建收货记录',0,3)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(27,N'SearchReceivingGoodsRecord',N'查询收货记录',0,3)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(28,N'ReceivingGoodsRecordAttachmentManagement',N'收货附件管理',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(29,N'UpdateReceivingGoodsRecord',N'编辑收货记录',0,3)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(30,N'DeleteReceivingGoodsRecord',N'删除收货记录',0,3)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(31,N'FinishDelivery',N'完成收发货2',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(32,N'CancelFinishDelivery',N'撤销完成收发货2',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(33,N'CreateSendingGoodsRecord',N'新建发货记录',0,4)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(34,N'SearchSendingGoodsRecord',N'查询发货记录',0,4)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(35,N'SendingGoodsRecordAttachmentManagement',N'发货附件管理',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(36,N'UpdateSendingGoodsRecord',N'编辑发货记录',0,4)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(37,N'DeleteSendingGoodsRecord',N'删除发货记录',0,4)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(38,N'SearchPaymentApplication',N'查询付款申请',0,5)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(39,N'CreatePaymentApplication',N'新建付款申请',0,5)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(40,N'UpdatePaymentApplication',N'更新付款申请',0,5)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(41,N'DeletePaymentApplication',N'删除付款申请',0,5)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(42,N'FinishPayment',N'完成收付款',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(43,N'CancelFinishPayment',N'撤销完成收付款',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(44,N'GeneratePaymentApplication',N'生成付款申请单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(45,N'CreatePaymentRecord',N'新建付款记录',0,24)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(46,N'UpdatePaymentRecord',N'更新付款记录',0,24)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(47,N'DeletePaymentRecord',N'删除付款记录',0,24)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(48,N'SearchPaymentRecord',N'查询付款记录',0,24)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(49,N'CreateReceivingPaymentRecord',N'新建收款记录',0,25)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(50,N'UpdateReceivingPaymentRecord',N'更新收款记录',0,25)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(51,N'DeleteReceivingPaymentRecord',N'删除收款记录',0,25)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(52,N'SearchReceivingPaymentRecord',N'查询收款记录',0,25)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(53,N'CreateInvoice',N'申请开票',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(54,N'ListInvoice',N'查询及查看开票申请详情',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(55,N'EditInvoice',N'编辑开票申请',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(56,N'DeleteInvoice',N'删除开票申请',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(57,N'FinishInvoice',N'完成收开票',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(58,N'CancelFinishInvoice',N'撤销完成收开票',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(59,N'PrintInvoiceRecord',N'打印开票记录',0,6)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(60,N'SearchInvoiceRecord',N'查询开票记录',0,6)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(61,N'CreateInvoiceRecord',N'新建开票记录',0,6)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(62,N'UpdateInvoiceRecord',N'修改开票记录',0,6)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(63,N'DeleteInvoiceRecord',N'删除开票记录',0,6)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(64,N'GenerateInvoiceConfirmation',N'生成回执单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(65,N'CreateReceiveInvoiceRecord',N'新建收票记录',0,7)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(66,N'SearchReceiveInvoiceRecord',N'查询收票记录',0,7)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(67,N'UpdateReceiveInvoiceRecord',N'编辑收票记录',0,7)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(68,N'DeleteReceiveInvoiceRecord',N'删除收票记录',0,7)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(69,N'CreateBalanceSettlement',N'新建尾款结算',0,8)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(70,N'UpdateBalanceSettlement',N'更新尾款结算',0,8)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(71,N'DeleteBalanceSettlement',N'删除尾款结算',0,8)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(72,N'FinishBalanceSettlement',N'完成尾款结算',0,8)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(73,N'SearchStorage',N'查询库存',0,9)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(74,N'CreateStorage',N'新建库存',0,9)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(75,N'UpdateStorage',N'更新库存',0,9)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(76,N'DeleteStorage',N'删除库存',0,9)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(77,N'ImportWarehouseReceipt',N'导入仓单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(78,N'ListWarehouseReceipt',N'查询及查看仓单详情',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(79,N'EditWarehouseReceipt',N'编辑仓单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(80,N'DeleteWarehouseReceipt',N'删除仓单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(81,N'CreateStorageConvert',N'添加货物转换',0,45)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(82,N'SearchStorageConvert',N'查询货物转换',0,45)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(83,N'UpdateStorageConvert',N'更新货物转换',0,45)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(84,N'DeleteStorageConvert',N'删除货物转换',0,45)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(85,N'CreateSpotRecord',N'添加仓单转现货记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(86,N'ListSpotRecord',N'查询仓单转现货记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(87,N'EditSpotRecord',N'编辑仓单转现货记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(88,N'DeleteSpotRecord',N'删除仓单转现货记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(89,N'ListPledge',N'查询及查看质押详情',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(90,N'CreatePledge',N'创建仓库质押',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(91,N'EditPledge',N'编辑质押',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(92,N'DeletePledge',N'删除质押',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(93,N'ListUnpledge',N'查询及查看解质押详情',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(94,N'CreateUnpledge',N'创建解质押',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(95,N'EditUnpledge',N'编辑解质押',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(96,N'DeleteUnpledge',N'删除解质押',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(97,N'SearchLedgerReport',N'查询分类账',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(98,N'ConfirmReport',N'业务每天确认合同业务',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(99,N'SearchContractJournalReport',N'查询合同采销对应报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(100,N'SearchStorageReport',N'查询库存报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(101,N'ListRistManagementReport',N'查询风险报表',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(102,N'ListExposureVolumneReport',N'查询敞口报表',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(103,N'ListBasicGapReport',N'查询基差报表',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(104,N'SearchCustomer',N'查询客户',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(105,N'CreateCustomer',N'新建客户',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(106,N'SearchMarketData',N'查询行情',0,34)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(107,N'CreateMarketData',N'新建行情',0,34)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(108,N'SearchWarehouse',N'查询仓库',0,33)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(109,N'CreateWarehouse',N'新建仓库',0,33)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(110,N'CreateUser',N'新建用户',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(111,N'CreateRole',N'新建角色',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(112,N'ListUser',N'查询用户2',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(113,N'ListRole',N'查询角色2',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(114,N'CreateGrant',N'新建授权',0,12)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(115,N'ListGrant',N'查询授权2',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(116,N'CreateTemplate',N'新建模板',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(117,N'SearchTemplate',N'查询模板',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(118,N'ListFuturesRecords',N'查询期货交易（旧）',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(119,N'ModifyFuturesRecord',N'修改期货交易记录（旧）',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(120,N'CreateFuturesRecord',N'添加期货交易记录（旧）',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(121,N'DeleteFuturesRecord',N'删除期货交易记录（旧）',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(122,N'CreateCostManagement',N'创建费用管理',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(123,N'ModifyCostManagement',N'修改费用管理',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(124,N'DeleteCostManagement',N'删除费用管理',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(125,N'CreateNote',N'创建备注',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(126,N'ModifyNote',N'修改备注2',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(127,N'DeleteNote',N'删除备注',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(128,N'ModifyPremiumDiscountAndPrice',N'变更升贴水价格',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(129,N'CreateContractBatch',N'创建批次',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(130,N'ModifyContractBatch',N'修改批次',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(131,N'DeleteContractBatch',N'删除批次',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(132,N'BatchFinishContract',N'批量完成合同',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(133,N'SearchBrand',N'查询品牌',0,37)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(134,N'CreateBrand',N'新建品牌',0,37)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(135,N'UpdateBrand',N'编辑品牌',0,37)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(136,N'DeleteBrand',N'删除品牌',0,37)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(137,N'SearchArchive',N'查询存档',0,32)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(138,N'CreateArchive',N'新建存档',0,32)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(139,N'ListLogisticFeeRequest',N'查询物流费申请',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(140,N'CreateLogisticFeeRequest',N'新建物流费申请',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(141,N'EditLogisticFeeRequest',N'修改物流费申请',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(142,N'DeleteLogisticFeeRequest',N'删除物流费申请',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(143,N'ListLogisticFeeRecord',N'查询物流费记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(144,N'CreateLogisticFeeRecord',N'新建物流费记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(145,N'EditLogisticFeeRecord',N'修改物流费记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(146,N'DeleteLogisticFeeRecord',N'删除物流费记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(147,N'ListWarehouseFeeRequest',N'查询仓储费申请',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(148,N'CreateWarehouseFeeRequest',N'新建仓储费申请',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(149,N'EditWarehouseFeeRequest',N'修改仓储费申请',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(150,N'DeleteWarehouseFeeRequest',N'删除仓储费申请',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(151,N'ListWarehouseFeeRecord',N'查询仓储费记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(152,N'CreateWarehouseFeeRecord',N'新建仓储费记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(153,N'EditWarehouseFeeRecord',N'修改仓储费记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(154,N'DeleteWarehouseFeeRecord',N'删除仓储费记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(155,N'CancelFinishFirePrice',N'撤销完成点价',0,13)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(156,N'FinishFirePrice',N'完成点价',0,13)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(157,N'FinishPledge',N'完成质押',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(158,N'CancelFinishPledge',N'取消完成质押',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(159,N'ListFee',N'费用报表',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(160,N'ListFeeRecord',N'查询费用记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(161,N'CreateFeeRecord',N'新建费用记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(162,N'EditFeeRecord',N'编辑费用记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(163,N'DeleteFeeRecord',N'删除费用记录',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(164,N'GenerateContractFee',N'自动生成合同相关费用',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(165,N'SearchDailyReport',N'查询日报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(166,N'CreateContractApproval',N'新建合同审批',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(167,N'CancelContractApproval',N'撤销合同审批',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(168,N'DeliveryRequestApproval',N'申请提单审批',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(169,N'DeliveryCancelApproval',N'撤销提单审批',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(170,N'CreatePayRequestApproval',N'新建付款申请审批',0,5)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(171,N'CancelPayRequestApproval',N'撤销付款申请审批',0,5)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(172,N'CreateOtherFormApproval',N'新建系统外单据审批',0,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(173,N'CancelOtherFormApproval',N'撤销系统外单据审批',0,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(174,N'CancelFinishedApproval',N'撤销已经完成的审批流',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(175,N'ManualFinishApproval',N'手工完成审批流',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(176,N'UpdateApprovaledContract',N'编辑审批完成的合同',1,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(177,N'ObsoleteApprovaledContract',N'作废审批完成的合同',1,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(178,N'UpdateApprovaledPayRequest',N'编辑审批完成的付款申请',1,5)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(179,N'ObsoleteApprovaledPayRequest',N'作废审批完成的付款申请',1,5)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(180,N'EditApprovaledDeliveryBill',N'编辑审批完成的提单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(181,N'CancelApprovaledDeliveryBill',N'作废审批完成的提单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(182,N'EditApprovaledBill',N'编辑通过审批的单据',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(183,N'CancelApprovaledBill',N'删除通过审批的单据',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(184,N'CreateFirePriceApproval',N'新建点价确认函审批',0,44)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(185,N'CancelFirePriceApproval',N'撤销点价确认函审批',0,44)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(186,N'ObsoleteApprovaledFirePrice',N'作废完成审批的点价确认函',1,44)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(187,N'ObsoleteFirePriceApproval',N'作废点价确认函审批',0,44)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(188,N'CreatePriceConfirmApproval',N'新建价格确认单审批',0,42)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(189,N'CancelPriceConfirmApproval',N'撤销价格确认单审批',0,42)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(190,N'ObsoleteApprovaledPriceConfirm',N'作废完成审批的价格确认单',1,42)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(191,N'ObsoletePriceConfirmApproval',N'作废价格确认单审批',0,42)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(192,N'CostFeePayRequestApproval',N'价格确认单申请审批',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(193,N'CostFeePayCancelApproval',N'价格确认单撤销审批',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(194,N'CostFeePayEditApprovaled',N'作废审批完成的价格确认单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(195,N'CostFeePayCancelApprovaled',N'作废完成的价格确认单审批',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(196,N'SearchOtherBill',N'查询系统外单据',0,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(197,N'CreateOtherBill',N'新建系统外单据',0,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(198,N'UpdateOtherBill',N'更新系统外单据',0,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(199,N'DeleteOtherBill',N'删除系统外单据',0,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(200,N'PrintOtherBill',N'打印系统外单据',0,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(201,N'WriteInvoice',N'WriteInvoice',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(202,N'CancelContractBatch',N'CancelContractBatch',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(203,N'ChangeWarehouse',N'ChangeWarehouse',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(204,N'CreatePostponedFirePriceApproval',N'新建延期点价确认函审批',0,43)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(205,N'CancelPostponedFirePriceApproval',N'撤销延期点价确认函审批',0,43)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(206,N'UpdateApprovaledPostponedFirePrice',N'编辑完成审批的延期点价确认函',1,43)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(207,N'ObsoletePostponedFirePriceApproval',N'作废延期点价确认函审批',0,43)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(208,N'UpdateApprovaledOtherForm',N'编辑审批完成的系统外单据',1,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(209,N'ObsoleteOtherFormApproval',N'作废系统外单据审批',0,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(210,N'CreateDepartment',N'新建部门',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(211,N'SearchDepartment',N'查询部门',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(212,N'SearchCreditRating',N'查询信用评级',0,36)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(213,N'CreateCreditRating',N'新建信用评级',0,36)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(214,N'UpdateCreditRating',N'更新信用评级',0,36)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(215,N'DeleteCreditRating',N'删除信用评级',0,36)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(216,N'SearchContact',N'查询通讯录',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(217,N'CreateContact',N'新建通讯录',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(218,N'UpdateContact',N'更新通讯录',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(219,N'DeleteContact',N'删除通讯录',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(220,N'CreateCompanyCreditRatingModificationApproval',N'新建客户信用评级调整审批',0,15)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(221,N'CancelCompanyCreditRatingModificationApproval',N'撤销客户信用评级调整审批',0,15)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(222,N'UpdateApprovaledCompanyCreditRatingModification',N'更新完成审批的客户信用评级调整',1,15)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(223,N'ObsoleteApprovaledCompanyCreditRatingModification',N'作废完成审批的客户信用评级调整',1,15)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(224,N'SearchTradeRiskReport',N'查询客户信用报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(225,N'SearchInvoice',N'尾款核对',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(226,N'SetSkipCeoApproval',N'跳过总裁审批',1,12)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(227,N'SetSkipToCeoApproval',N'跳转至总裁审批',1,12)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(228,N'SearchExchangeBill',N'查询票据',0,16)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(229,N'CreateExchangeBill',N'创建票据',0,16)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(230,N'UpdateExchangeBill',N'更新票据',0,16)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(231,N'DeleteExchangeBill',N'删除票据',0,16)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(232,N'SearchLetterOfCredit',N'查询信用证',0,47)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(233,N'CreateLetterOfCredit',N'创建信用证',0,47)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(234,N'UpdateLetterOfCredit',N'编辑信用证',0,47)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(235,N'DeleteLetterOfCredit',N'删除信用证',0,47)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(236,N'SearchCommercialInvoice',N'查询商业发票',0,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(237,N'CreateCommercialInvoice',N'新建商业发票',0,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(238,N'UpdateCommercialInvoice',N'更新商业发票',0,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(239,N'DeleteCommercialInvoice',N'删除商业发票',0,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(240,N'PrintCommercialInvoice',N'打印商业发票',0,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(241,N'CanPriceConfirmationCancelApproval',N'撤销价格确认单审批2',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(242,N'SearchPledgeContract',N'查看质押/赎回合同',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(243,N'CreatePledgeContract',N'创建质押/赎回合同',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(244,N'UpdatePledgeContract',N'修改质押/赎回合同',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(245,N'DeletePledgeContract',N'删除质押/赎回合同',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(246,N'SearchDeposit',N'查看保证金',0,19)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(247,N'CreateDeposit',N'创建保证金',0,19)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(248,N'UpdateDeposit',N'修改保证金',0,19)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(249,N'DeleteDeposit',N'删除保证金',0,19)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(250,N'SearchCarry',N'查看结转记录',0,19)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(251,N'CreateCarry',N'创建结转记录',0,19)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(252,N'UpdateCarry',N'修改结转记录',0,19)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(253,N'DeleteCarry',N'删除结转记录',0,19)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(254,N'ReturnDeposit',N'退还保证金',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(255,N'SearchPledgeRenewal',N'查看质押展期',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(256,N'CreatePledgeRenewal',N'创建质押展期',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(257,N'UpdatePledgeRenewal',N'修改质押展期',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(258,N'DeletePledgeRenewal',N'删除质押展期',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(259,N'CreatePledgeRenewalApproval',N'新建/提交展期申批',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(260,N'CancelPledgeRenewalApproval',N'撤销展期申批',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(261,N'ObsoletePledgeRenewalApproval',N'作废展期申批',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(262,N'PledgeRenewalCancelApprovaled',N'撤销已通过申请的展期',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(263,N'CreateCommercialInvoiceApproval',N'新建商业发票审批',0,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(264,N'CancelCommercialInvoiceApproval',N'撤销商业发票审批',0,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(265,N'UpdateApprovaledCommercialInvoice',N'更新通过审批的商业发票',1,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(266,N'ObsoleteApprovaledCommercialInvoice',N'作废通过审批的商业发票',1,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(267,N'FinishPledgeContract',N'完成质押/赎回合同',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(268,N'CancelFinishPledgeContract',N'取消完成质押/赎回合同',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(269,N'CreatePledgeContractApproval',N'新建质押合同审批',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(270,N'CancelPledgeContractApproval',N'撤销质押合同审批',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(271,N'UpdateApprovaledPledgeContract',N'更新通过审批的质押合同',1,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(272,N'ObsoleteApprovaledPledgeContract',N'作废通过审批的质押合同',1,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(273,N'PledgeRenewalRequestApproval',N'质押展期申请审批',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(274,N'PledgeRenewalCancelApproval',N'质押展期撤销审批',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(275,N'UpdateApprovaledPledgeRenewal',N'编辑通过审批的质押展期',1,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(276,N'ObsoleteApprovaledPledgeRenewal',N'作废通过审批的质押展期',1,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(277,N'ImportWeightMemo',N'导入码单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(278,N'DisableUser',N'停用用户',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(279,N'DisableCompany',N'停用客户',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(281,N'EditClient',N'编辑客户2',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(282,N'EditWarehouse',N'修改仓库',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(283,N'AddReceivingNotification',N'新增收货通知单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(284,N'EditReceivingNotification',N'编辑收货通知单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(285,N'DeleteReceivingNotification',N'删除收货通知单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(286,N'ListReceivingNotification',N'查看收货通知单',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(287,N'CreateSendingNotification',N'新建发货通知单',0,49)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(288,N'UpdateSendingNotification',N'编辑发货通知单',0,49)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(289,N'DeleteSendingNotification',N'删除发货通知单',0,49)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(290,N'SearchSendingNotification',N'查看发货通知单',0,49)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(291,N'CreateReceivingClaim',N'新增收款流水记录',0,20)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(292,N'UpdateReceivingClaim',N'编辑收款流水记录',0,20)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(293,N'DeleteReceivingClaim',N'删除收款流水记录',0,20)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(294,N'SearchReceivingClaim',N'查看收款流水记录',0,20)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(295,N'SetFinancialInvociePrefabricated',N'预制财务发票',0,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(296,N'PostingInvoice',N'过账发票',0,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(297,N'ReversalInvoice',N'冲销发票',0,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(298,N'AddBusinessInvoice',N'新增业务发票',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(299,N'EditBusinessInvoice',N'编辑业务发票',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(300,N'DeleteBusinessInvoice',N'删除业务发票',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(301,N'ListBusinessInvoice',N'查看业务发票',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(302,N'CreateFeeEstimate',N'新增费用暂估',0,21)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(303,N'UpdateFeeEstimate',N'编辑费用暂估',0,21)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(304,N'DeleteFeeEstimate',N'删除费用暂估',0,21)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(305,N'SearchFeeEstimate',N'查看费用暂估',0,21)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(306,N'CreateInventoryAdjustmentApproval',N'新建库存调差审批',0,46)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(307,N'CancelInventoryAdjustmentApproval',N'撤销库存调差审批',0,46)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(308,N'UpdateApprovaledInventoryAdjustment',N'编辑审批完成的库存调差申请',1,9)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(309,N'ObsoleteApprovaledInventoryAdjustment',N'作废审批完成的库存调差申请',1,9)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(310,N'CreateDeliveryNotificationApproval',N'新建发货申请单审批',0,49)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(311,N'CancelDeliveryNotificationApproval',N'撤销发货申请单审批',0,49)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(312,N'UpdateApprovaledDeliveryNotification',N'编辑审批完成的发货申请单申请',1,49)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(313,N'ObsoleteApprovaledDeliveryNotification',N'作废审批完成的发货申请单申请',1,49)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(314,N'CreateStorageConversionApproval',N'新建货物转换审批',0,9)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(315,N'CancelStorageConversionApproval',N'撤销货物转换审批',0,9)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(316,N'UpdateApprovaledStorageConversion',N'编辑审批完成的货物转换',1,9)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(317,N'ObsoleteApprovaledStorageConversion',N'作废审批完成的货物转换',1,9)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(318,N'UnLockCustomer',N'解锁客户',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(319,N'LockedCustomer',N'锁定客户2',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(320,N'SearchRiskControlParameters',N'查看风险控制参数',0,22)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(321,N'CreateRiskControlParameters',N'创建风险控制参数',0,22)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(322,N'UpdateRiskControlParameters',N'修改风险控制参数',0,22)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(323,N'DeleteRiskControlParameters',N'删除风险控制参数',0,22)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(324,N'SearchPostingInfo',N'查询过账记录',0,29)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(325,N'CreatePostingInfo',N'创建过账记录',0,29)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(326,N'UpdatePostingInfo',N'编辑过账记录',0,29)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(327,N'DeletePostingInfo',N'删除过账记录',0,29)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(328,N'UpdateCurrentCorporation',N'修改当前法人信息',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(330,N'EditMarketData',N'修改行情数据',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(332,N'SetGoodsReversal',N'冲销收发货过账',0,29)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(333,N'FinishGoods',N'完成收发货',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(334,N'CancelFinishGoods',N'撤销完成收发货',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(335,N'PrintReceiveInvoiceRecord',N'打印收票记录',0,7)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(336,N'SearchBalanceSettlement',N'查询尾款结算',0,8)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(337,N'CancelFinishBalanceSettlement',N'取消完成尾款结算',0,8)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(338,N'SearchContractExcuteRiskReport',N'查询合同执行风险报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(339,N'SearchUnCheckedDeliveryNoficationReport',N'查询未复核发货申请报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(340,N'SearchFunctionReport',N'查询权限报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(341,N'UpdateCustomer',N'编辑客户',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(342,N'DeleteCustomer',N'删除客户',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(343,N'DisableCustomer',N'禁用客户',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(344,N'EnableCustomer',N'启用客户',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(345,N'LockCustomer',N'锁定客户',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(346,N'CreateCompanyBankInfo',N'新建银行账户',0,40)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(347,N'UpdateCompanyBankInfo',N'编辑银行账户',0,40)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(348,N'DeleteCompanyBankInfo',N'删除银行账户',0,40)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(349,N'DisableCompanyBankInfo',N'停用银行帐户',0,40)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(350,N'EnableCompanyBankInfo',N'启用银行账户',0,40)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(351,N'UpdateMarketData',N'更新行情',0,34)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(352,N'DeleteMarketData',N'删除行情',0,34)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(353,N'UpdateWarehouse',N'更新仓库',0,33)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(354,N'DeleteWarehouse',N'删除仓库',0,33)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(355,N'DisableWarehouse',N'停用仓库',0,33)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(356,N'EnableWarehouse',N'启用仓库',0,33)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(357,N'UpdateUser',N'更新用户',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(358,N'DeleteUser',N'删除用户',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(359,N'SearchUser',N'查询用户',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(361,N'EnableUser',N'启用用户',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(362,N'UpdateRole',N'更新角色',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(363,N'DeleteRole',N'删除角色',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(364,N'SearchRole',N'查询角色',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(365,N'UpdateGrant',N'更新授权',0,12)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(366,N'DeleteGrant',N'删除授权',0,12)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(367,N'SearchGrant',N'查询授权',0,12)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(368,N'DeleteTemplate',N'删除模板',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(369,N'UpdateTemplate',N'更新模板',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(370,N'UpdateArchive',N'更新存档',0,32)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(371,N'DeleteArchive',N'删除存档',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(372,N'ObsoleteContractApproval',N'作废合同审批',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(373,N'ObsoletePayRequestApproval',N'作废付款申请审批',0,5)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(374,N'ObsoleteApprovaledOtherForm',N'作废审批完成的系统外单据',1,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(375,N'UpdateApprovaledFirePrice',N'编辑完成审批的点价确认函',1,44)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(376,N'UpdateApprovaledPriceConfirm',N'编辑完成审批的价格确认单',1,42)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(377,N'ObsoleteApprovaledPostponedFirePrice',N'作废完成审批的延期点价确认函',1,43)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(378,N'UpdateDepartment',N'更新部门',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(379,N'DeleteDepartment',N'删除部门',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(380,N'ObsoleteCompanyCreditRatingModificationApproval',N'作废客户信用评级调整审批',0,15)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(381,N'SearchMoneyConversion',N'查询票据贴现',0,16)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(382,N'CreateMoneyConversion',N'创建票据贴现',0,16)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(383,N'UpdateMoneyConversion',N'更新票据贴现',0,16)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(384,N'DeleteMoneyConversion',N'删除票据贴现',0,16)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(385,N'ObsoleteCommercialInvoiceApproval',N'作废商业发票审批',0,17)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(386,N'ObsoletePledgeContractApproval',N'作废质押合同审批',0,18)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(387,N'ObsoleteInventoryAdjustmentApproval',N'作废库存调差审批',0,9)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(388,N'ObsoleteDeliveryNotificationApproval',N'作废发货申请单审批',0,49)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(389,N'ObsoleteStorageConversionApproval',N'作废货物转换审批',0,9)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(390,N'ManageFirePrice',N'管理作价',0,13)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(391,N'ManagePriceAdjustment',N'价格调整',0,13)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(392,N'ManageCargoPriceMapping',N'货价匹配',0,13)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(393,N'UpdatePriceConfirm',N'更新价格确认单',0,42)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(394,N'DeletePriceConfirm',N'删除价格确认单',0,42)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(395,N'CreateCommodity',N'新建品种',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(396,N'UpdateCommodity',N'更新品种',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(397,N'DeleteCommodity',N'删除品种',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(398,N'SearchCommodity',N'查询品种',1,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(399,N'SearchSapLog',N'查询SAP操作日志',0,29)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(400,N'RetrySapOperation',N'重试SAP操作',0,29)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(401,N'SearchContractRisk',N'查看合同风险敞口',0,11)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(402,N'SearchContractAccountingInformation',N'查看合同核算信息',0,11)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(403,N'SearchAllGrant',N'查询所有授权',0,12)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(404,N'CreateFirePrice',N'新建点价记录',0,41)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(405,N'UpdateFirePrice',N'编辑点价记录',0,41)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(406,N'DeleteFirePrice',N'删除点价记录',0,41)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(407,N'CreateFireConfirm',N'新建点价确认函',0,44)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(408,N'UpdateFireConfirm',N'编辑点价确认函',0,44)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(409,N'DeleteFireConfirm',N'删除点价确认函',0,44)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(410,N'CreatePostponedFireConfirm',N'新建延期点价确认函',0,43)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(411,N'UpdatePostponedFireConfirm',N'编辑延期点价确认函',0,43)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(412,N'DeletePostponedFireConfirm',N'删除延期点价确认函',0,43)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(413,N'SearchStopLossReport',N'查询止损跟踪报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(414,N'ManageAccountPeriod',N'财务账期配置',0,28)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(415,N'SearchGroup',N'查询信用组',0,39)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(416,N'UnLockGroup',N'解锁信用组',0,39)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(417,N'LockedGroup',N'锁定信用组',0,39)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(418,N'CreateGroup',N'新增信用组',0,39)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(419,N'UpdateGroup',N'编辑信用组',0,39)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(420,N'DeleteGroup',N'删除信用组',0,39)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(421,N'DisableCorporationType',N'禁用公司类型',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(422,N'EnableCorporationType',N'启用公司类型',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(423,N'CreateCorporationType',N'新建公司类型',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(424,N'UpdateCorporationType',N'编辑公司类型',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(425,N'DeleteCorporationType',N'删除公司类型',0,35)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(426,N'ManageCustomerBusinessConfiguration',N'管理客户业务配置',0,30)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(427,N'ManageWarehouseBusinessConfiguration',N'管理仓库业务配置',0,30)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(428,N'ManageBankAccountBusinessConfiguration',N'管理银行帐号业务配置',0,30)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(429,N'SearchApprovalReport',N'查询业务审批流程报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(430,N'SearchPriceConfirm',N'查询价格确认单',0,42)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(431,N'SearchHistoryStorageReport',N'查询历史库存报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(432,N'SearchCommercialInvoiceExecuteReport',N'查询商业发票执行报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(433,N'UnrestrictedPrintBillContent',N'不受限制地打印单据内容',0,27)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(434,N'SetDeliveryNoficationVerify',N'复核发货申请单',0,49)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(435,N'CompletePayRequestAmount',N'完成付款',0,5)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(436,N'CancelCompletePayRequestAmount',N'取消完成付款',0,5)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(437,N'SearchMaterial',N'查询物料',0,38)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(438,N'CreateMaterial',N'新增物料',0,38)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(439,N'UpdateMaterial',N'编辑物料',0,38)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(440,N'DeleteMaterial',N'删除物料',0,38)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(441,N'SearchSupplementalAgreement',N'查询补充协议',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(442,N'CreateSupplementalAgreement',N'新增补充协议',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(443,N'UpdateSupplementalAgreement',N'编辑补充协议',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(444,N'DeleteSupplementalAgreement',N'删除补充协议',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(445,N'CreateSupplementalAgreementApproval',N'新建补充协议审批',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(446,N'CancelSupplementalAgreementApproval',N'撤销补充协议审批',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(447,N'ObsoleteSupplementalAgreementApproval',N'作废补充协议审批',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(448,N'SearchReturnedPurchase',N'查询退货订单',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(449,N'CreateReturnedPurchase',N'新增退货订单',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(450,N'UpdateReturnedPurchase',N'编辑退货订单',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(451,N'DeleteReturnedPurchase',N'删除退货订单',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(452,N'CreateReturnedPurchaseApproval',N'新建退货订单审批',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(453,N'CancelReturnedPurchaseApproval',N'撤销退货订单审批',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(454,N'ObsoleteReturnedPurchaseApproval',N'作废退货订单审批',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(455,N'CancelSetDeliveryNoficationVerify',N'取消复核发货申请单',0,49)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(456,N'PrintDeliveryConfirm',N'打印收货确认函',0,4)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(457,N'SearchDeliveryOutInDailyReport',N'查询出入库日报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(458,N'SearchPickingDeliveryOutReport',N'查询拣配发货报表',0,4)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(459,N'InfrastructureDataCompanyManagement',N'基础数据客户管理（可查询无业务客户）',0,11)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1457,N'UpdateReceiverCompany',N'更新提货单位',0,4)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1458,N'SearchPriceRiskReport',N'查询价格风险报表',0,10)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1459,N'SetSealed',N'确认盖章',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1460,N'CancelSealed',N'取消盖章',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1461,N'AdjustApprovalWorkflow',N'调整审批流程',0,12)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1462,N'SearchCancellationForm',N'查询审批撤销单',0,48)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1463,N'CreateCancellationForm',N'新增审批撤销单',0,48)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1464,N'UpdateCancellationForm',N'更新审批撤销单',0,48)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1465,N'DeleteCancellationForm',N'删除审批撤销单',0,48)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1466,N'CreateCancellationFormApproval',N'新增审批撤销单审批',0,48)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1500,N'SearchPrintHistory',N'查看打印历史',0,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1501,N'AggregatePrint',N'聚合打印',0,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1502,N'SearchDeletedRecords',N'查询已删除记录',0,14)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(1503,N'SearchOrgStructure',N'查询组织架构',0,11)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(2461,N'SetPaymentProposalSplit',N'付款建议拆分',0,5)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(2467,N'SearchWarehouseFeeRequest',N'SearchWarehouseFeeRequest',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(2468,N'CostFeePayRequestCancelApproval',N'CostFeePayRequestCancelApproval',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(2469,N'CostFeePayRequestEditApprovaled',N'CostFeePayRequestEditApprovaled',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(2470,N'CostFeePayRequestCancelApprovaled',N'CostFeePayRequestCancelApprovaled',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(2471,N'SearchExchangeRate',N'SearchExchangeRate',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(2472,N'CreateExchangeRate',N'CreateExchangeRate',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(2473,N'UpdateExchangeRate',N'UpdateExchangeRate',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(2474,N'DeleteExchangeRate',N'DeleteExchangeRate',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(2475,N'UpdateNote',N'修改备注',1,0)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3000,N'BackendManagerBasicData',N'后台管理-基础数据',0,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3001,N'BackendManagerBasicMaintenance',N'后台管理-基础运维',0,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3002,N'BackendManagerGrant',N'后台管理-授权',0,26)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3003,N'AddFutureTradeRecord',N'新增期货交易记录',0,50)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3004,N'EditFutureTradeRecord',N'编辑期货交易记录',0,50)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3005,N'DeleteFutureTradeRecord',N'删除期货交易记录',0,50)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3006,N'ListFutureTradeRecord',N'查看期货交易记录',0,50)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3007,N'SearchTradeInstruction',N'查询交易指令',0,31)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3008,N'CreateTradeInstruction',N'新增交易指令',0,31)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3009,N'EditTradeInstruction',N'编辑交易指令',0,31)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3010,N'DeleteTradeInstruction',N'删除交易指令',0,31)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(3011,N'UpdateContractWeight',N'更新合同重量',0,1)
insert WFPrivilege(WFFunctionId,Name,Note,IsDisabled,Category) values(10000,N'BmSiteLogOn',N'登录管理站',0,26)
end 
Go
if not exists(select 1 from WFCurrency ) 
begin 
INSERT WFCurrency([Code],[Name],[IsDeleted],[EnglishName],[Symbol],[TradingFlag],[DomesticIndex],[InterIndex],[ShortName],[Scale],[AccountingName]) VALUES (N'CNY',N'人民币',0,N'Yuan Renminbi',N'¥',NULL,1,2,N'元',2,N'人民币')
INSERT WFCurrency([Code],[Name],[IsDeleted],[EnglishName],[Symbol],[TradingFlag],[DomesticIndex],[InterIndex],[ShortName],[Scale],[AccountingName]) VALUES (N'USD',N'美元',0,N'US Dollar',N'$',NULL,2,1,N'美元',2,N'美元')
INSERT WFCurrency([Code],[Name],[IsDeleted],[EnglishName],[Symbol],[TradingFlag],[DomesticIndex],[InterIndex],[ShortName],[Scale],[AccountingName]) VALUES (N'GBP',N'英镑',0,N'Pound Sterling',N'£',NULL,3,3,N'英镑',2,N'英镑')
INSERT WFCurrency([Code],[Name],[IsDeleted],[EnglishName],[Symbol],[TradingFlag],[DomesticIndex],[InterIndex],[ShortName],[Scale],[AccountingName]) VALUES (N'JPY',N'日元',0,N'Yen',N'￥',NULL,4,4,N'日元',0,N'日元')
INSERT WFCurrency([Code],[Name],[IsDeleted],[EnglishName],[Symbol],[TradingFlag],[DomesticIndex],[InterIndex],[ShortName],[Scale],[AccountingName]) VALUES (N'CAD',N'加元',0,N'Canadian Dollar',N'$',NULL,5,5,N'加元',2,N'加元')
INSERT WFCurrency([Code],[Name],[IsDeleted],[EnglishName],[Symbol],[TradingFlag],[DomesticIndex],[InterIndex],[ShortName],[Scale],[AccountingName]) VALUES (N'SGD',N'新加坡元',0,N'Singapore Dollar',N'S$',NULL,6,6,N'新加坡元',2,N'新加坡元')
INSERT WFCurrency([Code],[Name],[IsDeleted],[EnglishName],[Symbol],[TradingFlag],[DomesticIndex],[InterIndex],[ShortName],[Scale],[AccountingName]) VALUES (N'THB',N'泰铢',0,N'Baht',N'฿',NULL,7,7,N'铢',2,N'泰铢')
INSERT WFCurrency([Code],[Name],[IsDeleted],[EnglishName],[Symbol],[TradingFlag],[DomesticIndex],[InterIndex],[ShortName],[Scale],[AccountingName]) VALUES (N'HKD',N'港元',0,N'Hong Kong Dollar',N'H$',NULL,8,8,N'港元',2,N'港元')
INSERT WFCurrency([Code],[Name],[IsDeleted],[EnglishName],[Symbol],[TradingFlag],[DomesticIndex],[InterIndex],[ShortName],[Scale],[AccountingName]) VALUES (N'CHF',N'瑞士法郎',0,N'Swiss Franc',N'CHF',NULL,9,9,N'瑞士法郎',2,N'瑞士法郎')
INSERT WFCurrency([Code],[Name],[IsDeleted],[EnglishName],[Symbol],[TradingFlag],[DomesticIndex],[InterIndex],[ShortName],[Scale],[AccountingName]) VALUES (N'EUR',N'欧元',0,N'Euro',N'€',NULL,10,10,N'欧元',2,N'欧元')
INSERT WFCurrency([Code],[Name],[IsDeleted],[EnglishName],[Symbol],[TradingFlag],[DomesticIndex],[InterIndex],[ShortName],[Scale],[AccountingName]) VALUES (N'CNH',N'人民币（离岸）',0,N'Offshore Renminbi',NULL,NULL,11,11,N'人民币（离岸）',2,N'人民币（离岸）')
end 
Go
if not exists(select 1 from WFCurrencyPair ) 
begin 
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (1,2)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (1,3)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (1,4)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (1,5)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (1,6)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (1,7)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (1,8)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (1,9)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (1,10)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (1,11)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (2,1)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (2,3)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (2,4)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (2,5)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (2,6)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (2,7)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (2,8)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (2,9)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (2,10)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (2,11)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (3,1)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (3,2)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (3,4)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (3,5)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (3,6)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (3,7)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (3,8)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (3,9)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (3,10)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (3,11)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (4,1)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (4,2)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (4,3)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (4,5)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (4,6)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (4,7)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (4,8)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (4,9)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (4,10)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (4,11)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (5,1)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (5,2)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (5,3)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (5,4)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (5,6)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (5,7)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (5,8)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (5,9)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (5,10)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (5,11)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (6,1)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (6,2)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (6,3)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (6,4)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (6,5)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (6,7)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (6,8)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (6,9)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (6,10)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (6,11)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (7,1)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (7,2)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (7,3)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (7,4)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (7,5)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (7,6)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (7,8)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (7,9)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (7,10)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (7,11)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (8,1)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (8,2)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (8,3)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (8,4)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (8,5)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (8,6)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (8,7)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (8,9)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (8,10)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (8,11)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (9,1)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (9,2)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (9,3)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (9,4)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (9,5)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (9,6)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (9,7)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (9,8)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (9,10)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (9,11)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (10,1)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (10,2)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (10,3)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (10,4)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (10,5)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (10,6)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (10,7)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (10,8)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (10,9)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (10,11)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (11,1)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (11,2)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (11,3)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (11,4)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (11,5)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (11,6)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (11,7)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (11,8)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (11,9)
INSERT WFCurrencyPair([BaseCurrencyId],[CounterCurrencyId]) VALUES (11,10)
end 
Go
if not exists(select 1 from WFUnit ) 
begin 
INSERT WFUnit([Symbol],[Name],[IsDeleted],[EnglishName],[QuantityKind],[InformalSymbol],[InformalName],[InformalEnglishName],[SapCode],[AccountingName]) VALUES (N't',N'吨',0,N'tonne',1,N'MT',N'吨',N'metric ton',N'T',N'吨')
INSERT WFUnit([Symbol],[Name],[IsDeleted],[EnglishName],[QuantityKind],[InformalSymbol],[InformalName],[InformalEnglishName],[SapCode],[AccountingName]) VALUES (N'kg',N'千克',0,N'kilogram',1,N'KG',N'千克',N'kilogram',N'KG',N'千克')
INSERT WFUnit([Symbol],[Name],[IsDeleted],[EnglishName],[QuantityKind],[InformalSymbol],[InformalName],[InformalEnglishName],[SapCode],[AccountingName]) VALUES (N'lb',N'磅',0,N'pound',1,N'LB',N'磅',N'pound',NULL,N'磅')
INSERT WFUnit([Symbol],[Name],[IsDeleted],[EnglishName],[QuantityKind],[InformalSymbol],[InformalName],[InformalEnglishName],[SapCode],[AccountingName]) VALUES (N'g',N'克',0,N'gram',1,N'G',N'克',N'gram',N'G',N'克')
INSERT WFUnit([Symbol],[Name],[IsDeleted],[EnglishName],[QuantityKind],[InformalSymbol],[InformalName],[InformalEnglishName],[SapCode],[AccountingName]) VALUES (N'bundle',N'捆',0,N'bundle',2,N'Bundle',N'捆',N'bundle',NULL,N'捆')
INSERT WFUnit([Symbol],[Name],[IsDeleted],[EnglishName],[QuantityKind],[InformalSymbol],[InformalName],[InformalEnglishName],[SapCode],[AccountingName]) VALUES (N'oz t',N'金衡盎司',0,N'troy ounce',1,N'oz t',N'金衡盎司',N'troy ounce',N'TOZ',N'金衡盎司')
INSERT WFUnit([Symbol],[Name],[IsDeleted],[EnglishName],[QuantityKind],[InformalSymbol],[InformalName],[InformalEnglishName],[SapCode],[AccountingName]) VALUES (N'pc',N'条',0,N'piece',2,N'pc',N'条',N'piece',NULL,N'条')
INSERT WFUnit([Symbol],[Name],[IsDeleted],[EnglishName],[QuantityKind],[InformalSymbol],[InformalName],[InformalEnglishName],[SapCode],[AccountingName]) VALUES (N'pallet',N'托盘',0,N'pallet',2,N'pallet',N'托盘',N'pallet',NULL,N'托盘')
INSERT WFUnit([Symbol],[Name],[IsDeleted],[EnglishName],[QuantityKind],[InformalSymbol],[InformalName],[InformalEnglishName],[SapCode],[AccountingName]) VALUES (N'oz customized',N'盎司（非标准）',0,N'ounce (customized)',1,N'oz',N'盎司',N'ounce',N'NOZ',N'盎司（非标准）')
INSERT WFUnit([Symbol],[Name],[IsDeleted],[EnglishName],[QuantityKind],[InformalSymbol],[InformalName],[InformalEnglishName],[SapCode],[AccountingName]) VALUES (N'bar',N'根',0,N'bar',2,N'bar',N'根',N'bar',NULL,N'根')
end 
Go
if not exists(select 1 from WFUnitConversion ) 
begin 
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (2,1,1.00000000000000000,0.00100000000000000,NULL)
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (4,2,1.00000000000000000,0.00100000000000000,NULL)
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (4,1,1.00000000000000000,0.00000100000000000,NULL)
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (6,2,1.00000000000000000,0.03110347680000000,N'按照定义')
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (6,1,1.00000000000000000,0.00003110347680000,NULL)
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (6,4,0.00100000000000000,0.03110347680000000,NULL)
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (3,2,1.00000000000000000,0.45359237000000000,N'常衡磅定义')
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (3,1,1.00000000000000000,0.00045359237000000,NULL)
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (3,4,0.00100000000000000,0.45359237000000000,NULL)
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (3,6,0.04800000000000000,0.70000000000000000,NULL)
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (9,6,0.99999855155376000,1.00000000000000000,NULL)
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (9,2,0.03215070000000000,0.00100000000000000,NULL)
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (9,4,0.03215070000000000,1.00000000000000000,NULL)
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (9,1,0.03215070000000000,0.00000100000000000,NULL)
INSERT WFUnitConversion([FromUnitId],[ToUnitId],[FromUnitNumericValue],[ToUnitNumericValue],[Note]) VALUES (9,3,0.69999898608763200,0.04800000000000000,NULL)
end 
Go
if not exists(select 1 from WFQuantityType ) 
begin 
INSERT WFQuantityType([Name],[EnglishName],[QuantityKind],[IsDeleted]) VALUES (N'重量',N'weight',1,0)
INSERT WFQuantityType([Name],[EnglishName],[QuantityKind],[IsDeleted]) VALUES (N'款',N'money',4,0)
INSERT WFQuantityType([Name],[EnglishName],[QuantityKind],[IsDeleted]) VALUES (N'毛重',N'gross weight',1,0)
INSERT WFQuantityType([Name],[EnglishName],[QuantityKind],[IsDeleted]) VALUES (N'捆数',N'number of bundles',2,0)
INSERT WFQuantityType([Name],[EnglishName],[QuantityKind],[IsDeleted]) VALUES (N'锭数',N'number of pieces',2,0)
INSERT WFQuantityType([Name],[EnglishName],[QuantityKind],[IsDeleted]) VALUES (N'托盘数',N'number of pallets',2,0)
INSERT WFQuantityType([Name],[EnglishName],[QuantityKind],[IsDeleted]) VALUES (N'收缩包数',N'number of shrink wrapped',2,0)
INSERT WFQuantityType([Name],[EnglishName],[QuantityKind],[IsDeleted]) VALUES (N'根数',N'number of bars',2,0)
end 
Go
if not exists(select 1 from WFCargoInseparabilityConfiguration) 
begin 
INSERT WFCargoInseparabilityConfiguration([InventoryStorageType],[CommodityId],[TradeType],[CargoInseparability],[Priority],[Note]) VALUES (25,NULL,15,1,0,N'非普通现货')
end 
Go
if not exists(select 1 from WFSystemConfiguration ) 
begin 
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'AccountPeriodThreshold',N'0',N'提交合同时，如果合同账期大于此配置项值，系统会提示用户合同存在账期风险
合同审批时，如果合同账期大于此配置项值，系统会提示风控此合同存在账期风险',N'最大允许账期（数字）',6)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'AlgorithmicMoneyTolerance',N'1',N'设置合同款项完成时，合同已发生款项需要处于 系统计算合同金额±此项配置 的范围内
设置合同发票完成时，合同已发生发票金额需要处于 系统计算合同金额±此项配置 的范围内
发起付款申请时，最大允许付款金额=系统计算金额±此项配置',N'算法金额容差（数字）',6)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'AlgorithmicToleranceRatio',N'0',N'发起付款申请时，系统计算最大允许金额=系统计算金额*（1+此配置项）
发起发货申请时，系统最大允许货值=系统计算金额*（1+此配置项）
导出提单时，系统最大允许货值=系统计算金额*（1+此配置项）
合同执行风险报表中的风险金额计算
商业发票的最大申请金额，系统计算最大合同金额=系统计算金额*（1+此配置项）',N'算法容差比例（0~1）',6)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'CommonModelVersion',N'de044680-5ae7-41db-92d0-1506e792bac8',N'更新后浏览器会强制刷新系统基础数据为最新数据',N'系统浏览器缓存（GUID）',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DailyContractAmountLimit',N'150000000',N'合同审批时，如果当日累计合同金额大于此项配置，提示当日超额风险
客户信用报表，当前客户进行中订单累计金额大于此配置项，提示超额风险',N'合同日限额（数字）',1)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DailyContractAmountRatio',N'0.8',N'与合同日限额（DailyContractAmountLimit）配合使用，如果大于日限额*当前配置，系统会做预警提示',N'合同日限额警告比例（0~1）',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DateOfSupportHistoryStorage',N'2014-09-24',N'历史库存计算时，重算的最早日期。历史库存计算时，不会重算小于此日期的库存',N'历史库存起始日期（日期）',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DefaultCargoToleranceRatio',N'0.1',N'合同新增时的默认货容差（长单合同默认为0）
赎回合同新增时，最多可赎回量是否超过质押合同的重量比例',N'合同缺省货容差比例（0~1）',1)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DefaultPriceToleranceRatio',N'0.05',N'合同新增时，默认的价格容差比例',N'缺省价容差比例（0~1）',1)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'InstrumentVersion',N'fc0171e1-005e-4486-88df-cfeda4e38660',N'更新后，浏览器会强制刷新系统缓存合约为最新数据',N'系统合约缓存（GUID）',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'IsCommercialInvoiceConnectedMainBuy',N'true',N'用于申请时，取审批人。如果以采购方为主，则默认审批人不管从哪方发起都会走到采购方订单对应的审批人',N'关联交易的商业发票是否以采购方为主（bool）',7)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'IsEnableCargoAmountValidate',N'false',N'新增付款申请时，是否需要验证付款金额符合货值
新增尾款结算时，是否需要验证尾款申请金额是否符合货值
新增发货申请时，是否需要验证发货货值是否符合已收付款金额',N'是否开启货与款值的申请验证（bool）',12)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'IsPremiumNonZero',N'false',N'用于合同完成时验证货价管理升贴水不能为0',N'合同完成时是否验证货价管理升贴水不能为0（bool）',6)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'IsValidateBatchTrackQuantity',N'true',N'用于解决系统部分情况下，批次拆分太细，拆分前后导致“后继批次收货量超过了前驱批次发货量”
此情况下，先设置此项配置为false后，提交收货。修改批次相关量后再设置此项配置为true',N'是否验证前驱批次发货量与后继收货量匹配（bool）',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'LimitInvoiceApplyDays',N'-7',N'与IsLimitInvoiceApply配合使用，多少个工作日内未预制的发票需要限制提交，一般设置为负数才可生效',N'商业发票申请天数限制（数字）',7)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'ProxySiteURL',N'',N'暂未使用',N'微信proxy 站 url（链接）',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'ReceivingClaimAmountErrorRatio',N'0.01',N'用于限制流水下的认领金额不能大于流水的金额比例（仅限于内贸电汇使用）',N'流水认领金额误差比例（0~1）',1)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'ReceivingClaimRatio',N'0.03',N'流水金额与已认领金额之差小于流程金额*此项配置，系统将会提示用于是否将流水设置为完成状态，反之不提示',N'自动完成款项流水容差比例（0~1）',10)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'ToleranceRiskControlFactor',N'1',N'表示风控强度，范围-1至+1，1表示最宽松（百分比）使用方法：数量*（1+容差*此配置）
用于发货申请时验证发货对应合同或商业发票的最大可申请重量
用于发货申请与付款申请时，系统货值计算时，最大货值的计算',N'容差风控指数（-1~1）',1)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'WarningMoneyTolerance',N'0',N'合同金额与含容差的发生货款的偏差金额, 金额超出范围则此合同隶属每日预警报表',N'报表预警容差金额（数字）',1)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'WarningToleranceRatio',N'0',N'合同金额与含容差的发生货款的偏差范围(百分比), 超出范围则此合同隶属每日预警报表',N'报表预警容差比例（0~1）',1)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'WebSiteURL',N'http://10.5.0.39',N'用于移动端站点查看附件时，附件组装链接需要默认配置业务站点网址
用于审批邮件中的附件组装附件地址',N'web站url（链接）',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'WechatURL',N'',N'用于通知微信端消息时，组装链接
用于微信端内部callback时，组装链接',N'微信站url（链接）',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'AccountPeriodMaxDate',N'null',N'收发货过账时，最大允许时间，默认每月更新一次，配置为当月最大时间',N'账期截至日期（日期）',3)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'AccountPeriodMinDate',N'null',N'收发货过账时，最小允许时间，默认每月更新一次，配置为当月最小时间',N'账期起始日期（日期）',3)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DiscountFee',N'50',N'用于止损价报表中的止损价计算中默认的信用证贴息费用',N'信用证贴息费用（数字）',2)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'FuturesFee',N'20',N'用于止损价报表中的止损价计算中默认的期货费用',N'期货费用（数字）',2)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'MinProfit',N'300',N'用于止损价报表中的止损价计算中默认的最小盈利',N'最小盈利（数字）',2)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'IsDisableAccounting',N'false',N'false：开启；true：禁用',N'核算对接禁用与开启（bool）',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'SpotAccounting',N'2016-01-01',N'用于AccountingDataLog表验证是否需要同步核算',N'现货交易核算上线配置（日期）',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'InventoryAccounting',N'2016-01-01',N'用于存储过程中配置是否同步核算历史库存信息',N'库存核算上线配置（日期）',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'MortgageAccounting',N'2016-01-01',N'用于SyncSpotMortgage表验证是否需要同步核算',N'质押核算上线配置（日期）',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'PricedAccounting',N'2016-01-01',N'计价量核算上线配置（SyncTradePriced）',N'计价量核算上线配置（日期）',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'BatchAccounting',N'2016-01-01',N'批次核算上线配置',N'批次核算上线配置',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'PledgeBatchAccounting',N'null',N'质押批次核算上线配置',N'质押批次核算上线配置',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'AutoCompleteContractDays',N'15',N'货价完成后 此项配置 个自然日且合同金额=收付款金额时，系统后台自动完成款项状态
货价完成后 此项配置 个自然日且合同金额=收开票金额时，系统后台自动完成票状态
合同款、票完成后 此项配置 个自然日后，系统后台自动完成
需要与系统Task配合才可以生效',N'自动完成合同时间（数字）',1)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'PriceRiskWarningRatio',N'0.01',N'用于合同审批时，是否提示价格风险。',N'价格风险预警比例（0~2）',1)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'InvoiceAmountTolerance',N'0.5',N'用于发票新增时，税额和发票金额*0.17之间的容差 以及 价*量与发票金额之间的容差',N'发票金额容差（数字）',3)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'SpecialCargoToleranceRatio',N'0.2',N'用于信任客户交易出口新增时默认赋值合同货容差',N'特殊缺省货容差比例（信任客户交易出口货容差）（0~1）',1)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'ContractNotRequireAmount',N'false',N'用于新增时合同时，合同款项状态默认为不需要，并自动完成款',N'某些合同不需要款（bool）',6)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'InvoiceFromCargoDocument',N'false',N'用于前台限制新增发票时，不能编辑重量以及修改系统默认计算金额，主要用于开票',N'某些发票必须与物料凭证过帐保持一致，货物量、金额、税额不能调整',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'IssueInvoiceNotRequireBankAccount',N'false',N'用于前台开票是否必须选择开户行
用于后台判断开户行是否必须选择',N'某些发票不需要银行帐号',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'InvoiceNotRequireSameMonth',N'false',N'用于提交发票时，验证发票下的收发货过账日期不能跨月',N'某些发票不需要禁止跨月',7)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DaybookRequireSpecialProcess',N'false',N'某些流水特殊处理：允许支付形式为空的流水、允许收款的且来自资金系统的且客户在执行系统中不存在的流水、允许电汇的我方银行帐号或我方银行名称为空的流水、允许收款日期为空的流水、初始已过帐为空时缺省值为是',N'某些流水特殊处理',10)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DeliveryRequreSomeProperty',N'false',N'用于发货申请时，前台判断装运类型、实际发货日期必填',N'某些发货需要某些字段：装运类型、实际发货日期',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'SapPiEnabled',N'true',N'是否与 Sap Pi 对接。此设置在上线后不要改。配置明细中 Addition1 用作 ServiceOperation。',N'是否与 Sap Pi 对接(总开关为开,才会对接SAP,总开关为关,不对接SAP)',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'SapPiValidationEnabled',N'true',N'是否需要某些与 Sap Pi 有关的验证。此全局设置在上线后不要改。',N'是否需要某些与 Sap Pi 有关的验证',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DefaultMoneyCargoToleranceAmount',N'0',N'合同新增时，合同的默认合同款项与货物之间容差金额，后续用于发货导出提单时的货值款值验证',N'款项与货物之间容差金额（非特定货币单位）缺省值',1)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'IsOnceDeliveryOut',N'false',N'发货申请是否为单次发货。用于发货验证发货申请单允许发货的次数单次/多次',N'是否单次发货',11)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'IsProcessingChargesPremiumDiscountType',N'false',N'溢价折价方式是否为加工费方式',N'溢价折价方式是否为加工费方式',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'RefMarketOfMarketPremiumDiscount',N'null',N'行情升贴水的参考作价市场',N'行情升贴水的参考作价市场',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'GeneralPremiumDiscountDisplayText',N'升贴水',N'溢价折价显示文字：加工费等；升贴水；',N'溢价折价显示文字',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'EnableDailyContractAmountLimit',N'true',N'开启当日合同限额，用于审批计算合同当日限额，默认开启。
某些条件下关闭表示此条件下的合同金额不进入当日合同限额的计算',N'开启当日合同限额',6)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'OmitRiskForNotIsBuy',N'true',N'不计算非IsBuy合同的风险。可按法人配置明细，若配置false则该法人下关闭。默认全局开启。',N'不计算非IsBuy合同的风险',6)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'IsDeliveryOutVerify',N'false',N'用于验证发货时，发货明细规格是否与发货申请明细规格一致',N'发货明细规格是否与发货申请明细规格一致',11)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'EnableLoadCurrentOperator',N'true',N'加载当前操作人,用于界面默认选中当前操作人员，配置false,则该法人下关闭。默认开启。',N'开启当提前操作人加载',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DisableValidateAmountForInvoiceFinished',N'false',N'不验证合同金额和发票金额(票完成)，主要用于长单批次票完成。',N'不验证合同金额和发票金额(票完成时),配置true则开启(不验证)。默认关闭',6)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DaybookRequireSpecialProcess2',N'false',N'某些流水特殊处理-2：付款流水如果“阳谷付款流水-订单号”的值不为空 则自动创建付款申请与记录',N'某些流水特殊处理-2',10)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'IsEnableCargoAmountValidateForPrint',N'true',N'付款申请打印时，是否验证付款金额与货值是否符合
付款建议打印时，是否验证付款金额与货值是否符合',N'付款是否开启货与款值打印验证（bool）',8)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'EnableTaxCodeConf',N'true',N'启用某税码。在明细配置中，配置税码的启用或禁用，Addition1字段用作税码id',N'启用某税码',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'BMSiteURL',N'',N'用于业务端跳转管理端组装链接',N'BMSite站点url',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'ProduceInAccounting',N'2016-01-01',N'生产入库批次核算上线配置',N'生产入库批次核算上线配置',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'ProduceOutAccounting',N'2016-01-01',N'生产出库批次核算上线配置',N'生产出库批次核算上线配置',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'InventoryAdjustmentAccounting',N'2016-01-01',N'库存调差批次核算上线配置',N'库存调差批次核算上线配置',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'ContractInfoAccounting',N'2016-01-01',N'合同核算上线（SyncTradeContractInfo）',N'合同信息核算上线配置（日期）',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'ContractDetailAccounting',N'2016-01-01',N'合同明细核算上线（SyncContractDetail）',N'合同明细核算上线配置（日期）',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'PaymentAccounting',N'2016-01-01',N'合同款项上线（SyncTradePayment）',N'款项核算上线配置（日期）',4)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DeliveryCargoToleranceRatio',N'0.1',N'货转收发货时，用于判断申请量与实际发生是否超过比例
库存没有结算重量时，库存发出重量与剩余可用重量是否超过比例
库存调差时，剩余重量是否小于容差
收货的库存已有发出，且修改后的重量小于发出的重量
货转记录的收货重量与发货重量相差比较',N'收发货相关货容差比例（0~1）',0)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'IsLimitInvoiceApply',N'false',N'用于验证外贸N天前同法人同品种审批通过但是未预制的发票如果存在，则不允许提交新的审批',N'是否启用商业发票申请天数限制（bool）',7)
INSERT WFSystemConfiguration([WFKey],[WFValue],[Note],[Name],[ConfCategory]) VALUES (N'DefaultTradingCalendarExchangeId',N'228',N'用于商业发票计算申请天数限制时，配合交易所下的交易日历使用',N'工作日默认计算取值交易所（交易所ID）',0)
end 
Go
if not exists(select 1 from WFConditionProperty ) 
begin 
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (1,4,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (1,4,N'ContractType',N'合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (1,1024,N'ExchangeProcessType',N'货款方式',0,1,0,2,N'enumOptions.ExchangeProcessType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (1,1024,N'PaymentCurrencyId',N'实付币种',0,3,1,2,N'allCurrencies',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (1,1024,N'CurrencyId',N'币种',0,3,1,2,N'allCurrencies',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (1,1,N'ContractType',N'合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (2,1024,N'WFContractInfo.ContractType',N'商业发票.合同.合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (2,1024,N'WFContractInfo.TradeType',N'商业发票.合同.贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (2,1024,N'WFContractInfo.TransactionType',N'商业发票.合同.交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (2,1024,N'WFInvoiceRecord.IsReceive',N'商业发票.方向',0,1,0,6,N'[收票,开票]',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (2,1024,N'WFContractInfo.CorporationId',N'商业发票.合同.法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (2,1024,N'WFInvoiceRecord.CustomerId',N'商业发票.客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (2,1,N'ContractType',N'合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,4,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,4,N'ContractType',N'合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,4,N'PledgeType',N'所内所外',0,1,0,2,N'enumOptions.PledgeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'TransactionType',N'合同交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'ContractType',N'合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'AccountPeriod',N'账期',0,1,1,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'AccountPeriodQuota',N'账期限额',0,2,0,5,N'',0)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'BillType',N'审批类型',0,1,0,2,N'enumOptions.ApprovalType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'DailySumAmountQuota',N'当日限额计算方法',0,2,0,5,N'',0)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'ContractType',N'合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'CustomerCompanyType',N'客户公司类型',0,1,0,2,N'enumOptions.CorporationTypeFlag',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'DailySumAmount',N'当日金额累计',0,1,1,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'ExchangeProcessType',N'货款方式',0,1,0,2,N'enumOptions.ExchangeProcessType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'IsBank',N'是否银行',0,1,0,6,N'',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'IsBuy',N'方向',0,1,0,6,N'[采购,销售]',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'TransactionType',N'合同交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,4,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,4,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,4,N'ContractType',N'合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,4,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,4,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,4,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,4,N'PledgeType',N'所内所外',0,1,0,2,N'enumOptions.PledgeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,4,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,4,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,4,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,8,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,8,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,8,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,8,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,8,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,8,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,8,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,8,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,16,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,16,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,16,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,16,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,16,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,16,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,16,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,16,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32,N'ContractType',N'合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32,N'PledgeType',N'所内所外',0,1,0,2,N'enumOptions.PledgeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,64,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,64,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,64,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,64,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,64,N'ExchangeProcessType',N'货款方式',0,1,0,2,N'enumOptions.ExchangeProcessType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,64,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,64,N'IsBuy',N'方向',0,1,0,6,N'[采购,销售]',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,64,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,64,N'SpotAmountType',N'货款方式',0,1,0,2,N'enumOptions.ExchangeProcessType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,64,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,64,N'TransactionType',N'合同交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,64,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,128,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,128,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,128,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,128,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,128,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,128,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,128,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,128,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,256,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,256,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'TransactionType',N'合同交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'BillType',N'审批类型',0,1,0,2,N'enumOptions.ApprovalType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'ContractType',N'合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'ExchangeProcessType',N'货款方式',0,1,0,2,N'enumOptions.ExchangeProcessType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'IsBuy',N'方向',0,1,0,6,N'[采购,销售]',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'PledgeType',N'所内所外',0,1,0,2,N'enumOptions.PledgeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'TransactionType',N'合同交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,512,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'AccountPeriod',N'账期',0,1,1,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'AccountPeriodQuota',N'账期限额',0,2,0,5,N'',0)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'BillType',N'审批类型',0,1,0,2,N'enumOptions.ApprovalType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'ExchangeProcessType',N'货款方式',0,1,0,2,N'enumOptions.ExchangeProcessType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'IsBuy',N'方向',0,1,0,6,N'[采购,销售]',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'PledgeType',N'所内所外',0,1,0,2,N'enumOptions.PledgeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'TransactionType',N'合同交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,2048,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32768,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32768,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32768,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32768,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32768,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32768,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,32768,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,131072,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,131072,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,131072,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,131072,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,131072,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,131072,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,131072,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'WFContractInfo.ContractType',N'商业发票.合同.合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'WFContractInfo.TradeType',N'商业发票.合同.贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'WFContractInfo.TransactionType',N'商业发票.合同.交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'WFInvoiceRecord.IsReceive',N'商业发票.方向',0,1,0,6,N'[收票,开票]',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'WFContractInfo.CorporationId',N'商业发票.合同.法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'WFInvoiceRecord.CustomerId',N'商业发票.客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'PaymentCurrencyId',N'实付币种',0,3,1,2,N'allCurrencies',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1024,N'CurrencyId',N'币种',0,3,1,2,N'allCurrencies',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'AccountPeriod',N'账期',0,1,1,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'AccountPeriodQuota',N'账期限额',0,2,0,5,N'',0)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'BillType',N'审批类型',0,1,0,2,N'enumOptions.ApprovalType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'DailySumAmountQuota',N'当日限额计算方法',0,2,0,5,N'',0)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'CustomerCompanyType',N'客户公司类型',0,1,0,2,N'enumOptions.CorporationTypeFlag',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'DailySumAmount',N'当日金额累计',0,1,1,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'ExchangeProcessType',N'货款方式',0,1,0,2,N'enumOptions.ExchangeProcessType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'IsBank',N'是否银行',0,1,0,6,N'',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'IsBuy',N'方向',0,1,0,6,N'[采购,销售]',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,4,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,4,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,4,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,4,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,4,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,4,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,4,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,8,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,8,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,8,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,8,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,8,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,8,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,8,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,8,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,16,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,16,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,16,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,16,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,16,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,16,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,16,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,16,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32,N'ContractType',N'合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32,N'PledgeType',N'所内所外',0,1,0,2,N'enumOptions.PledgeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,64,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,64,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,64,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,64,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,64,N'ExchangeProcessType',N'货款方式',0,1,0,2,N'enumOptions.ExchangeProcessType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,64,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,64,N'IsBuy',N'方向',0,1,0,6,N'[采购,销售]',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,64,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,64,N'SpotAmountType',N'货款方式',0,1,0,2,N'enumOptions.ExchangeProcessType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,64,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,64,N'TransactionType',N'合同交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,64,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,128,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,128,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,128,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,128,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,128,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,128,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,128,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,128,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,256,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,256,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'BillType',N'审批类型',0,1,0,2,N'enumOptions.ApprovalType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'ContractType',N'合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'ExchangeProcessType',N'货款方式',0,1,0,2,N'enumOptions.ExchangeProcessType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'IsBuy',N'方向',0,1,0,6,N'[采购,销售]',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'PledgeType',N'所内所外',0,1,0,2,N'enumOptions.PledgeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'TransactionType',N'合同交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'Amount',N'金额',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'CurrencyId',N'币种',0,3,1,2,N'allCurrencies',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'PaymentCurrencyId',N'实付币种',0,3,1,2,N'allCurrencies',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'TransactionType',N'合同交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'WFContractInfo.ContractType',N'商业发票.合同.合同类型',0,1,0,2,N'enumOptions.ContractType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'WFContractInfo.CorporationId',N'商业发票.合同.法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'WFContractInfo.TradeType',N'商业发票.合同.贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'WFContractInfo.TransactionType',N'商业发票.合同.交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'WFInvoiceRecord.CustomerId',N'商业发票.客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'WFInvoiceRecord.IsReceive',N'商业发票.方向',0,1,0,6,N'[收票,开票]',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'AccountPeriod',N'账期',0,1,1,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'AccountPeriodQuota',N'账期限额',0,2,0,5,N'',0)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'BillType',N'审批类型',0,1,0,2,N'enumOptions.ApprovalType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'ExchangeProcessType',N'货款方式',0,1,0,2,N'enumOptions.ExchangeProcessType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'IsBuy',N'方向',0,1,0,6,N'[采购,销售]',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'PledgeType',N'所内所外',0,1,0,2,N'enumOptions.PledgeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'TransactionType',N'合同交易类型',0,1,0,2,N'enumOptions.TransactionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32768,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32768,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32768,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32768,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32768,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32768,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32768,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,131072,N'CommodityId',N'品种',0,1,0,2,N'allCommodities',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,131072,N'CorporationId',N'法人',0,1,0,2,N'allCorporations',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,131072,N'DepartmentId',N'部门',0,1,0,2,N'allDepartments',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,131072,N'ExcutorId',N'执行',0,1,0,2,N'allExcutors',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,131072,N'SalerId',N'业务员',0,1,0,2,N'allSalers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,131072,N'TradeType',N'贸易类型',0,1,0,2,N'enumOptions.SimpleTradeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,131072,N'Weight',N'重量',0,1,0,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (1,1,N'IsBuy',N'方向',0,1,0,6,N'[采购,销售]',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (1,1,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'CustomerDailyRisk',N'客户当日风险累计',0,1,1,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'CustomerRisk',N'客户风险',0,1,1,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'PriceMakingType',N'作价方式',0,1,0,2,N'enumOptions.PriceMakingType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1,N'RelationCategory',N'公司内外分类',0,1,0,2,N'enumOptions.CorporationRelationCategory',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,4,N'IsSettlementAmount',N'是否尾款',0,1,0,6,N'',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'CustomerDailyRisk',N'客户当日风险累计',0,1,1,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'CustomerRisk',N'客户风险',0,1,1,5,N'[0]',63)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'PriceMakingType',N'作价方式',0,1,0,2,N'enumOptions.PriceMakingType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1,N'RelationCategory',N'公司内外分类',0,1,0,2,N'enumOptions.CorporationRelationCategory',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,4,N'IsSettlementAmount',N'是否尾款',0,1,0,6,N'',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (2,1,N'Direction',N'合同方向',0,1,0,2,N'enumOptions.PartDirection',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,8,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,16,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,32,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,128,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,512,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,1024,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,2048,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (3,65536,N'CustomerId',N'客户',0,1,0,2,N'allCustomers',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (2,131072,N'StorageConversionType',N'货转类型',0,1,0,2,N'enumOptions.StorageConversionType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (2,512,N'PledgeType',N'所内所外',0,1,0,2,N'enumOptions.PledgeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (2,2048,N'PledgeType',N'所内所外',0,1,0,2,N'enumOptions.PledgeType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1048576,N'OriginFlowType',N'原审批流的审批类型',0,1,0,2,N'enumOptions.ApprovalType',3)
INSERT WFConditionProperty([ConditionType],[ApprovalType],[PropertyName],[DisplayName],[IsDeleted],[SideType],[SupportDynamicValue],[ValueType],[ValueRanges],[AvailableOperators]) VALUES (5,1048576,N'IsSealed',N'合同是否已盖章',0,1,0,6,N'[已盖章,未盖章]',3)
end 
Go
if not exists(select 1 from WFApproverTemplate ) 
begin 
INSERT WFApproverTemplate([ApproverType],[Name],[Note]) VALUES (1,N'SalerId',N'SalerId')
end 
Go
if not exists(select 1 from WFAdditionalConfiguration ) 
begin 
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (2,N'',N'仓储费',N'每年调整',1,NULL,NULL,3)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (2,N'ZOA1',N'关税',N'',2,NULL,NULL,2)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (2,N'ZTD1',N'提单进境',N'',2,NULL,NULL,1)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (2,N'ZRK1',N'入库费',N'每年调整',2,NULL,NULL,3)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (2,N'ZHB1',N'出库费',N'每年调整',1,NULL,NULL,3)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (2,N'ZHB2',N'有条件放货',N'',3,NULL,NULL,1)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (2,N'ZHB3',N'国际运费',N'陆运费按照目的地相对固定，海运费每单不同',3,NULL,NULL,3)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (2,N'ZHB4',N'内陆运费',N'陆运费按照目的地相对固定，海运费每单不同',3,NULL,NULL,3)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (1,N'J0',N'0.00%',N'外贸',1,1,0.00000000,NULL)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (1,N'J1',N'17.00%',N'内贸',1,1,0.17000000,NULL)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (1,N'X0',N'0.00%',N'外贸',2,2,0.00000000,NULL)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (1,N'X1',N'17.00%',N'内贸',2,2,0.17000000,NULL)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (1,N'J2',N'13.00%',N'内贸',1,1,0.13000000,NULL)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (1,N'X2',N'13.00%',N'内贸',2,2,0.13000000,NULL)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (1,N'JF',N'11.00%',N'内贸',1,1,0.11000000,NULL)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (1,N'X4',N'11.00%',N'内贸',2,2,0.11000000,NULL)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (1,N'JI',N'10.00%',NULL,1,1,0.10000000,NULL)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (1,N'JJ',N'16.00%',NULL,1,1,0.16000000,NULL)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (1,N'X8',N'10.00%',NULL,2,2,0.10000000,NULL)
INSERT WFAdditionalConfiguration([AdditionalConfigurationType],[SAPCode],[Name],[Note],[Direction],[TaxCodeType],[TaxRate],[FeeConditionTypeCategory]) VALUES (1,N'X9',N'16.00%',NULL,2,2,0.16000000,NULL)
end 
Go
if not exists(select 1 from WFRolePrivilege) 
begin 
--初始化内置角色模板
--后台管理-基础数据（登录+数据配置）
--后台管理-基础运维（登录+基础运维）
--后台管理-授权
insert WFRoleInfo(Name,Note,WFPostId,IsDeleted,RoleType)
select N'后台管理-基础数据',N'内置角色',(select WFPostId from WFPost where Name=N'其他岗位类别') , 0 ,1
union
select N'后台管理-基础运维',N'内置角色',(select WFPostId from WFPost where Name=N'其他岗位类别') , 0 ,1
union
select N'后台管理-授权管理',N'内置角色',(select WFPostId from WFPost where Name=N'其他岗位类别') , 0 ,1
union
--初始化通用模板角色
select  N'通用执行人员权限',N'模板角色',(select WFPostId from WFPost where Name=N'执行人员') , 0 ,2
union
select  N'通用执行主管权限',N'模板角色',(select WFPostId from WFPost where Name=N'执行主管') , 0 ,2
union
select N'通用业务员权限',N'模板角色',(select WFPostId from WFPost where Name=N'业务员') , 0 ,2
union
select N'通用物流人员权限',N'模板角色',(select WFPostId from WFPost where Name=N'其他岗位类别') , 0 ,2
union
select N'通用财务人员权限',N'模板角色',(select WFPostId from WFPost where Name=N'其他岗位类别') , 0 ,2
union
select N'通用风控人员权限',N'模板角色',(select WFPostId from WFPost where Name=N'其他岗位类别') , 0 ,2
except select Name,Note,WFPostId,IsDeleted ,RoleType from  WFRoleInfo

update WFRoleInfo set Note=N'普通角色',RoleType=0
where  Note not in(N'内置角色',N'模板角色') and IsDeleted=0

insert into WFRolePrivilege(WFRoleInfoId, Privilege,CorporationId, TradeType )
--后台管理-基础数据
select  WFRoleInfoId,WFFunctionId,null,null
from WFRoleInfo a,WFPrivilege b
where a.IsDeleted=0 and a.Name=N'后台管理-基础数据'
and b.Name=N'BackendManagerBasicData'
 Union
 select  WFRoleInfoId, WFFunctionId,null,null
from WFRoleInfo a,WFPrivilege b
where a.IsDeleted=0 and a.Name=N'后台管理-基础数据'
and b.Name=N'BmSiteLogOn'
 Union
 --后台管理-基础运维
 select  WFRoleInfoId, WFFunctionId,null,null
from WFRoleInfo a,WFPrivilege b
where a.IsDeleted=0 and a.Name=N'后台管理-基础运维'
and b.Name=N'BackendManagerBasicMaintenance'
 Union
 select  WFRoleInfoId, WFFunctionId,null,null
from WFRoleInfo a,WFPrivilege b
where a.IsDeleted=0 and a.Name=N'后台管理-基础运维'
and b.Name=N'BmSiteLogOn'
 Union
 --后台管理-授权
 select  WFRoleInfoId, WFFunctionId,null,null
from WFRoleInfo a,WFPrivilege b
where a.IsDeleted=0 and a.Name=N'后台管理-授权管理'
and b.Name=N'BackendManagerGrant'
 Union
 select  WFRoleInfoId, WFFunctionId,null,null
from WFRoleInfo a,WFPrivilege b
where a.IsDeleted=0 and a.Name=N'后台管理-授权管理'
and b.Name=N'BmSiteLogOn'
 Union
--通用执行人员权限
select ( select WFRoleInfoId from WFRoleInfo
where IsDeleted=0 and Name=N'通用执行人员权限') WFRoleInfoId,WFFunctionId,null,null
  FROM WFPrivilege 
  WHERE IsDisabled = 0
  AND (Name LIKE N'Create%'
       OR Name LIKE N'Update%'
       OR Name LIKE N'Delete%'
       OR Name LIKE N'Search%'
       OR Name LIKE N'Cancel%' 
	   OR Name like N'Print%'
	   OR Name IN ( --特殊需要给的权限
			N'ManageCustomerBusinessConfiguration',
			N'ManageWarehouseBusinessConfiguration',
			N'ManageBankAccountBusinessConfiguration',
			N'FinishFirePrice'
	   ))
  AND Category != 12 --授权
  AND Category != 15 --信用评级
  AND Category != 22 --风控参数
  AND Name NOT IN(--特殊不能给的权限
	 N'SearchContractAccountingInformation',
	 N'CancelSealed',
	 N'ManageAccountPeriod',
     N'CreateReceivingClaim',
     N'UpdateReceivingClaim',
     N'DeleteReceivingClaim',
	 N'SetSealed',
	 N'SetDeliveryNoficationVerify',
	 N'CancelSetDeliveryNoficationVerify')
Union
--通用执行主管权限
select ( select WFRoleInfoId from WFRoleInfo
where IsDeleted=0 and Name=N'通用执行主管权限') WFRoleInfoId,WFFunctionId,null,null
FROM WFPrivilege 
WHERE IsDisabled = 0 
AND (Name LIKE N'Manage%' 
	OR Name LIKE N'Search%')
  AND Category != 12 --授权
  AND Category != 15 --信用评级
  AND Category != 22 --风控参数
  AND Name NOT IN(--特殊不能给的权限
	 N'SearchContractAccountingInformation',
	 N'CancelSealed',
	 N'ManageAccountPeriod',
     N'CreateReceivingClaim',
     N'UpdateReceivingClaim',
     N'DeleteReceivingClaim',
	 N'SetSealed',
	 N'SetDeliveryNoficationVerify',
	 N'CancelSetDeliveryNoficationVerify')
Union
--通用业务员权限
select ( select WFRoleInfoId from WFRoleInfo
where IsDeleted=0 and Name=N'通用业务员权限') WFRoleInfoId,WFFunctionId,null,null
FROM WFPrivilege 
WHERE IsDisabled = 0 
AND (Name LIKE N'Search%')
  AND Category != 12 --授权
  AND Category != 15 --信用评级
  AND Category != 22 --风控参数
 Union
--通用物流人员权限
select ( select WFRoleInfoId from WFRoleInfo
where IsDeleted=0 and Name=N'通用物流人员权限') WFRoleInfoId,WFFunctionId,null,null
from WFPrivilege
where IsDisabled = 0 and 
Name in(N'SearchContract',N'SearchLongContract',
N'CreateReceivingGoodsRecord',N'SearchReceivingGoodsRecord',N'UpdateReceivingGoodsRecord',N'DeleteReceivingGoodsRecord',
N'CreateSendingGoodsRecord',N'SearchSendingGoodsRecord',N'UpdateSendingGoodsRecord',N'DeleteSendingGoodsRecord',
N'SearchStorage',N'SearchStorageReport',N'SearchWarehouse',N'SearchDailyReport',
N'CreateSendingNotification',N'UpdateSendingNotification',N'DeleteSendingNotification',N'SearchSendingNotification',
N'UpdateWarehouse',N'ManageWarehouseBusinessConfiguration',N'SearchHistoryStorageReport',N'SearchDeliveryOutInDailyReport',
N'SearchPickingDeliveryOutReport')
Union
--通用财务人员权限
select ( select WFRoleInfoId from WFRoleInfo
where IsDeleted=0 and Name=N'通用财务人员权限') WFRoleInfoId,WFFunctionId,null,null
FROM WFPrivilege
WHERE IsDisabled = 0
  AND (Name LIKE N'Search%'
       OR Name LIKE N'Obsolete%'
       OR Name IN ( N'ManageAccountPeriod',
                    N'CreateReceivingClaim',
                    N'UpdateReceivingClaim',
                    N'DeleteReceivingClaim',
					N'SetSealed',
					N'CancelSealed',
					N'SetDeliveryNoficationVerify',
					N'CancelSetDeliveryNoficationVerify'))
  AND Category != 12 --授权
  AND Category != 15 --信用评级
  AND Category != 22 --风控参数
Union
--通用风控人员权限
select ( select WFRoleInfoId from WFRoleInfo
where IsDeleted=0 and Name=N'通用风控人员权限') WFRoleInfoId,WFFunctionId,null,null
FROM WFPrivilege
WHERE IsDisabled = 0
  AND ((Category = 12 --授权
  OR Category = 15 --信用评级
  OR Category = 22) --风控参数
  OR (Name LIKE N'Search%'))
 except select WFRoleInfoId,Privilege,CorporationId, TradeType  from  WFRolePrivilege
 end 
Go
--初始化执行审批开关需要关闭
insert WFApprovalConfiguration(Priority,AllowApproval,Note) values (100,0,N'全局关闭')
Go
--初始化执行对接SAP需要关闭
UPDATE WFSystemConfiguration SET WFValue='false'  where WFKey  IN(N'SapPiEnabled',N'SapPiValidationEnabled')
Go
--初始化执行对接核算需要关闭
UPDATE WFSystemConfiguration SET WFValue='true'  where WFKey  IN(N'IsDisableAccounting')
--Go
----删除存储过程 sp_CreateInsertScript
--DROP PROCEDURE [dbo].[sp_CreateInsertScript]
Go
--删除数据表 WFPrivilege
Drop table WFPrivilege
Go
declare @dbname nvarchar(100) 
set @dbname = db_name() 
--查询数据库状态
select name,user_access,user_access_desc,
    snapshot_isolation_state,
    is_read_committed_snapshot_on
from sys.databases
where name = @dbname 
exec(N' 
use master 
alter database ' + @dbname + N' set single_user with rollback immediate 
alter database ' + @dbname + N' set allow_snapshot_isolation on 
alter database ' + @dbname + N' set read_committed_snapshot on 
alter database ' + @dbname + N' set multi_user 
use ' + @dbname + N' 
') 
--查询数据库状态
select name,user_access,user_access_desc,
    snapshot_isolation_state,
    is_read_committed_snapshot_on
from sys.databases
where name = @dbname 
go 

insert into WFApproverTemplate (Name, ApproverType, Note) 
select N'财务',2,  N' 财务审批'
except 
select Name, ApproverType, Note from WFApproverTemplate
Go

insert into WFApprovalWorkflowTemplate (Name, Note, IsDeleted) 
values (N'占位符 --> 财务', N'占位符 --> 财务', 0)
, (N'占位符', N'占位符', 0) 
go 

insert into WFApprovalWorkflowStepTemplate (WFApprovalWorkflowTemplateId, StepIndex, StepType, Name, WFApproverTemplateId) 
select f.WFApprovalWorkflowTemplateId, 0, 16, N'发起审批', null 
from WFApprovalWorkflowTemplate f 
where f.Name = N'占位符 --> 财务' 
union all 
select f.WFApprovalWorkflowTemplateId, 1, 32, N'占位符', null 
from WFApprovalWorkflowTemplate f 
where f.Name = N'占位符 --> 财务' 
union all 
select f.WFApprovalWorkflowTemplateId, 2, 4, N'财务审批', a.WFApproverTemplateId 
from WFApprovalWorkflowTemplate f, WFApproverTemplate a 
where f.Name = N'占位符 --> 财务' and a.Name = N'财务' 
union all 
select f.WFApprovalWorkflowTemplateId, 3, 8, N'结束', null 
from WFApprovalWorkflowTemplate f 
where f.Name = N'占位符 --> 财务' 
union all 
select f.WFApprovalWorkflowTemplateId, 0, 16, N'发起审批', null 
from WFApprovalWorkflowTemplate f 
where f.Name = N'占位符' 
union all 
select f.WFApprovalWorkflowTemplateId, 1, 32, N'占位符', null 
from WFApprovalWorkflowTemplate f 
where f.Name = N'占位符' 
union all 
select f.WFApprovalWorkflowTemplateId, 2, 8, N'结束', null 
from WFApprovalWorkflowTemplate f 
where f.Name = N'占位符' 
go 

insert into WFStepConditionTemplate (PreviousWFApprovalWorkflowStepId, NextWFApprovalWorkflowStepId, Action, Result, ConditionNote, MemberPassType) 
select p.WFApprovalWorkflowStepTemplateId, s.WFApprovalWorkflowStepTemplateId, null, null, null, 2 
from WFApprovalWorkflowStepTemplate p, WFApprovalWorkflowStepTemplate s, WFApprovalWorkflowTemplate f 
where p.StepIndex = 0 and s.StepIndex = 1 and f.Name = N'占位符 --> 财务' 
and f.WFApprovalWorkflowTemplateId = p.WFApprovalWorkflowTemplateId 
and f.WFApprovalWorkflowTemplateId = s.WFApprovalWorkflowTemplateId 
union all 
select p.WFApprovalWorkflowStepTemplateId, s.WFApprovalWorkflowStepTemplateId, null, null, null, 2 
from WFApprovalWorkflowStepTemplate p, WFApprovalWorkflowStepTemplate s, WFApprovalWorkflowTemplate f 
where p.StepIndex = 1 and s.StepIndex = 2 and f.Name = N'占位符 --> 财务' 
and f.WFApprovalWorkflowTemplateId = p.WFApprovalWorkflowTemplateId 
and f.WFApprovalWorkflowTemplateId = s.WFApprovalWorkflowTemplateId 
union all 
select p.WFApprovalWorkflowStepTemplateId, s.WFApprovalWorkflowStepTemplateId, 2, 1, N'财务同意', 2 
from WFApprovalWorkflowStepTemplate p, WFApprovalWorkflowStepTemplate s, WFApprovalWorkflowTemplate f 
where p.StepIndex = 2 and s.StepIndex = 3 and f.Name = N'占位符 --> 财务' 
and f.WFApprovalWorkflowTemplateId = p.WFApprovalWorkflowTemplateId 
and f.WFApprovalWorkflowTemplateId = s.WFApprovalWorkflowTemplateId 
union all 
select p.WFApprovalWorkflowStepTemplateId, s.WFApprovalWorkflowStepTemplateId, 2, 2, N'财务不同意', 2 
from WFApprovalWorkflowStepTemplate p, WFApprovalWorkflowStepTemplate s, WFApprovalWorkflowTemplate f 
where p.StepIndex = 2 and s.StepIndex = 3 and f.Name = N'占位符 --> 财务' 
and f.WFApprovalWorkflowTemplateId = p.WFApprovalWorkflowTemplateId 
and f.WFApprovalWorkflowTemplateId = s.WFApprovalWorkflowTemplateId 
union all 
select p.WFApprovalWorkflowStepTemplateId, s.WFApprovalWorkflowStepTemplateId, null, null, null, 2 
from WFApprovalWorkflowStepTemplate p, WFApprovalWorkflowStepTemplate s, WFApprovalWorkflowTemplate f 
where p.StepIndex = 0 and s.StepIndex = 1 and f.Name = N'占位符' 
and f.WFApprovalWorkflowTemplateId = p.WFApprovalWorkflowTemplateId 
and f.WFApprovalWorkflowTemplateId = s.WFApprovalWorkflowTemplateId 
union all 
select p.WFApprovalWorkflowStepTemplateId, s.WFApprovalWorkflowStepTemplateId, null, null, null, 2 
from WFApprovalWorkflowStepTemplate p, WFApprovalWorkflowStepTemplate s, WFApprovalWorkflowTemplate f 
where p.StepIndex = 1 and s.StepIndex = 2 and f.Name = N'占位符' 
and f.WFApprovalWorkflowTemplateId = p.WFApprovalWorkflowTemplateId 
and f.WFApprovalWorkflowTemplateId = s.WFApprovalWorkflowTemplateId 
go
