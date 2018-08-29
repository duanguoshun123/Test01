CREATE USER [dev] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
CREATE USER [dev_writer] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
CREATE USER [ITDEV\operation.auto] FOR LOGIN [ITDEV\operation.auto] WITH DEFAULT_SCHEMA=[dbo]
GO
CREATE USER [OperationSLT] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [dev]
GO
ALTER ROLE [db_datareader] ADD MEMBER [dev_writer]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [dev_writer]
GO
ALTER ROLE [db_owner] ADD MEMBER [ITDEV\operation.auto]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [ITDEV\operation.auto]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [ITDEV\operation.auto]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [ITDEV\operation.auto]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [ITDEV\operation.auto]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ITDEV\operation.auto]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ITDEV\operation.auto]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [ITDEV\operation.auto]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [ITDEV\operation.auto]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FnCalculateActualTotalAmount] ( @contractInfoId INT )
RETURNS DECIMAL(18, 2)
AS
    BEGIN

        DECLARE @isBuy BIT;
        DECLARE @tradeRecordSum DECIMAL(18, 2);
        DECLARE @amountSum DECIMAL(18, 2);    
        DECLARE @contractFee DECIMAL(18, 2);
        DECLARE @isCargoPriceMatchFinished INT;

        IF @contractInfoId = 23902
            RETURN 11369797.5;
        IF @contractInfoId = 23510
            RETURN 28047900;
        IF @contractInfoId = 23553
            RETURN 26400000;
        IF @contractInfoId = 23633
            RETURN 4479104.57;
        IF @contractInfoId = 23621
            RETURN 1350000000;
        IF @contractInfoId = 23622
            RETURN 1350000000;
        IF @contractInfoId = 19996
            RETURN 518112;
        IF @contractInfoId = 19689
            RETURN 264096;
    
    --判断是否为采购合同    
        SELECT  @isBuy = IsBuy
        FROM    WFContractInfo
        WHERE   WFContractInfoId = @contractInfoId;

    --判断合同是否完成货
        SELECT  @isCargoPriceMatchFinished = CargoPriceMatchStatus
        FROM    WFContractInfo
        WHERE   WFContractInfoId = @contractInfoId;

    --计算@tradeRecordSum
        IF @isCargoPriceMatchFinished = 1
            BEGIN
                IF @isBuy = 1
                    BEGIN
            --select @tradeRecordSum=SUM(ROUND(TR.ActualWeight*ROUND(TR.Price,2),2)) from WFBuyContractTradeRecord TR 
            --inner join WFContractEntryRecordDetail CE on CE.WFContractEntryRecordDetailId=TR.WFContractEntryRecordDetailId
            --where CE.WFContractDetailInfoId in (select WFContractDetailInfoId from WFContractDetailInfo where WFContractInfoId=@contractInfoId and IsDeleted = 0)

                        SELECT  @tradeRecordSum = SUM(g.ActualWeight * g.Price)
                        FROM    ( SELECT    SUM(t.ActualWeight) ActualWeight ,
                                            t.Price
                                  FROM      ( SELECT    bctr.ActualWeight ActualWeight ,
                                                        bctr.Price Price
                                              FROM      WFBuyContractTradeRecord bctr ,
                                                        WFContractEntryRecordDetail cerd ,
                                                        WFContractDetailInfo cd ,
                                                        WFWarehouseEntryRecordDetail werd ,
                                                        WFWarehouseEntryRecord wer
                                              WHERE     bctr.Price IS NOT NULL
                                                        AND bctr.ActualWeight IS NOT NULL
                                                        AND cd.WFContractInfoId = @contractInfoId
                                                        AND cerd.IsDeleted = 0
                                                        AND cerd.ObjectType = 1
                                                        AND cd.IsDeleted = 0
                                                        AND werd.IsDeleted = 0
                                                        AND wer.IsDeleted = 0
                                                        AND bctr.WFContractEntryRecordDetailId = cerd.WFContractEntryRecordDetailId
                                                        AND cerd.ObjectId = cd.WFContractDetailInfoId
                                                        AND cerd.WFWarehouseEntryRecordDetailId = werd.WFWarehouseEntryRecordDetailId
                                                        AND werd.WFWarehouseEntryRecordId = wer.WFWarehouseEntryRecordId
                                            ) t
                                  GROUP BY  t.Price
                                ) g; 
                    END;
                ELSE
                    BEGIN
            --select @tradeRecordSum=SUM(ROUND(TR.ActualWeight*ROUND(TR.Price,2),2)) from WFSaleContractTradeRecord TR 
            --inner join WFContractOutRecordDetail CO on CO.WFContractOutRecordDetailId=TR.WFContractOutRecordDetailId
            --where CO.WFContractDetailInfoId in (select WFContractDetailInfoId from WFContractDetailInfo where WFContractInfoId=@contractInfoId and IsDeleted = 0)

                        SELECT  @tradeRecordSum = SUM(g.ActualWeight * g.Price)
                        FROM    ( SELECT    SUM(t.ActualWeight) ActualWeight ,
                                            t.Price
                                  FROM      ( SELECT    bctr.ActualWeight ActualWeight ,
                                                        bctr.Price Price
                                              FROM      WFSaleContractTradeRecord bctr ,
                                                        WFContractOutRecordDetail cerd ,
                                                        WFContractDetailInfo cd ,
                                                        WFWarehouseOutRecordDetail werd ,
                                                        WFWarehouseOutRecord wer
                                              WHERE     bctr.Price IS NOT NULL
                                                        AND bctr.ActualWeight IS NOT NULL
                                                        AND cd.WFContractInfoId = @contractInfoId
                                                        AND cerd.IsDeleted = 0
                                                        AND cerd.ObjectType = 1
                                                        AND cd.IsDeleted = 0
                                                        AND werd.IsDeleted = 0
                                                        AND wer.IsDeleted = 0
                                                        AND bctr.WFContractOutRecordDetailId = cerd.WFContractOutRecordDetailId
                                                        AND cerd.ObjectId = cd.WFContractDetailInfoId
                                                        AND cerd.WFWarehouseOutRecordDetailId = werd.WFWarehouseOutRecordDetailId
                                                        AND werd.WFWarehouseOutRecordId = wer.WFWarehouseOutRecordId
                                            ) t
                                  GROUP BY  t.Price
                                ) g; 
                    END;
            END;    

    --如果没有值，则利用合同金额
        IF ( @tradeRecordSum IS NULL )
            BEGIN
                SELECT  @tradeRecordSum = SUM(( CASE WHEN DI.ActualWeight IS NOT NULL
                                                          AND DI.ActualWeight != 0
                                                     THEN DI.ActualWeight
                                                     ELSE DI.Weight
                                                END )
												  * ( (CASE WHEN DI.Price IS NOT NULL
                                                              AND DI.Price != 0
                                                         THEN DI.Price
                                                         ELSE 0
                                                    END )
                                                  + ( CASE WHEN DI.PremiumDiscount IS NOT NULL
                                                              AND DI.PremiumDiscount != 0
                                                           THEN DI.PremiumDiscount
                                                           ELSE 0
                                                      END ) ))
                                             
                FROM    WFContractDetailInfo DI                      
                WHERE   DI.WFContractInfoId = @contractInfoId
                        AND DI.IsDeleted != 1;
            END;
                    
        SET @amountSum = @tradeRecordSum;
        IF @contractFee IS NOT NULL
            SET @amountSum += @contractFee;
        RETURN ROUND(@amountSum, 2);
    END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FnCalculateAmountApplied] (@contractInfoId int)
returns decimal(18,2)
as
BEGIN
    --
    declare @amountSum decimal(18,2) 
    select @amountSum = SUM(case when c.IsAmountIncludeDiscountCost = 1 then d.SettleCurrencyFutureValue else d.SettleCurrencyPresentValue end) 
    from WFPayRequestDetail d, WFPayRequest r, WFContractInfo c 
    where d.ObjectType = 1 
        and r.IsDeleted = 0 
        and c.WFContractInfoId = @contractInfoId 
        and d.WFPayRequestId = r.WFPayRequestId 
        and d.ObjectId = c.WFContractInfoId 
    return @amountSum 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[FnCalculateAmountFutureValueHappened] (@contractInfoId int)
returns decimal(18,2)
as
BEGIN
    
    --计算货款的总和
    DECLARE @amountSum decimal(18,2)
SELECT @amountSum=SUM((case when CI.IsBuy = AR.IsPay then 1 else -1 end) *case when ARD.SettleCurrencyFutureValue is not null then ARD.SettleCurrencyFutureValue else 0 end)
           FROM WFAmountRecordDetail ARD 
           INNER JOIN WFAmountRecord AR ON AR.WFAmountRecordId=ARD.WFAmountRecordId
           INNER JOIN WFContractInfo CI ON ARD.WFContractInfoId=CI.WFContractInfoId
           where ARD.WFContractInfoId=@contractInfoId AND AR.IsDeleted<>1 AND AR.PayPurposeType = 1 and ARD.ObjectType = 1
    
    if @amountSum is null 
        set @amountSum = 0

    --计算点价保证金充当的货款总和
    SELECT @amountSum+=(CASE WHEN SUM(MarginAsPayment) IS NULL THEN 0 ELSE SUM(MarginAsPayment) END ) FROM
    (
        SELECT DISTINCT AR.WFAmountRecordId,AR.MarginAsPayment
        FROM WFAmountRecord AR 
        INNER JOIN WFAmountRecordDetail ARD ON AR.WFAmountRecordId=ARD.WFAmountRecordId
        where ARD.WFContractInfoId=@contractInfoId AND AR.IsDeleted<>1 AND AR.PayPurposeType = 8
    ) TT

    RETURN CASE WHEN @amountSum is null THEN 0 ELSE @amountSum END
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--
CREATE function [dbo].[FnCalculateAmountHappened] (@contractInfoId int)
returns decimal(18,2)
as
BEGIN
    
    --计算货款的总和
    DECLARE @amountSum decimal(18,2)
    SELECT @amountSum=SUM((case when CI.IsBuy = AR.IsPay then 1 else -1 end) * coalesce((case when CI.IsAmountIncludeDiscountCost = 1 then ARD.SettleCurrencyFutureValue else ARD.SettleCurrencyPresentValue end), 0))
        FROM WFAmountRecordDetail ARD, WFAmountRecord AR, WFContractInfo CI 
        where ARD.ObjectType = 1 
           and ARD.ObjectId = CI.WFContractInfoId 
           and AR.WFAmountRecordId=ARD.WFAmountRecordId 
           and AR.IsDeleted = 0 
           and CI.WFContractInfoId = @contractInfoId 
    
    if @amountSum is null 
        set @amountSum = 0

    

    RETURN CASE WHEN @amountSum is null THEN 0 ELSE @amountSum END
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[FnCalculateAppliedSettleAmount] 
(
    @contractId int
)
RETURNS decimal(18,2)
AS
BEGIN

   DECLARE  @appliedSettleAmount decimal(18,2)
   SELECT @appliedSettleAmount = SUM((case when SR.IsPay = CI.IsBuy then 1 else -1 end) * SRD.Amount) FROM WFSettlementRequestDetail SRD
   INNER JOIN WFSettlementRequest SR ON SR.WFSettlementRequestlId = SRD.WFSettlementRequestlId
   INNER JOIN WFContractInfo CI ON SRD.WFContractInfoId = CI.WFContractInfoId
   WHERE SRD.WFContractInfoId=@contractId AND SR.IsFinished !=1 AND SR.IsDeleted !=1

   return @appliedSettleAmount
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--修改合同货发生计算方法
CREATE function [dbo].[FnCalculateCommodityHappened] (@contractInfoId int)
returns decimal(18,4)
as
BEGIN
    --判断合同是否采购还是销售
    declare @isBuy bit,@contractUnitId int
    select @isBuy=IsBuy,@contractUnitId=UnitId from WFContractInfo where WFContractInfoId=@contractInfoId
    declare @weightSum decimal(18,4)
    if @isBuy=1
        select @weightSum=SUM(ERD.ObjectUnitWeight) 
        from WFContractEntryRecordDetail ERD
        inner join WFContractDetailInfo CDI on CDI.WFContractDetailInfoId=ERD.ObjectId
        inner join WFWarehouseEntryRecordDetail ORD on ERD.WFWarehouseEntryRecordDetailId = ORD.WFWarehouseEntryRecordDetailId
        inner join WFWarehouseEntryRecord ER ON ER.WFWarehouseEntryRecordId=ORD.WFWarehouseEntryRecordId        
        where CDI.WFContractInfoId=@contractInfoId
              AND ERD.IsDeleted<>1
              AND ER.IsDeleted <>1                      
              AND ERD.ObjectType =    1         
    else 
        select @weightSum=SUM(ERD.ObjectUnitWeight) 
        from WFContractOutRecordDetail ERD
        inner join WFContractDetailInfo CDI on CDI.WFContractDetailInfoId=ERD.ObjectId        
        inner join WFWarehouseOutRecordDetail ORD on ERD.WFWarehouseOutRecordDetailId = ORD.WFWarehouseOutRecordDetailId
        inner join WFWarehouseOutRecord ER ON ER.WFWarehouseOutRecordId=ORD.WFWarehouseOutRecordID        
        where CDI.WFContractInfoId=@contractInfoId
              AND ERD.IsDeleted<>1
              AND ER.IsDeleted <>1
              AND ER.IsTemphold<>1
              AND ERD.ObjectType =1
    return @weightSum
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[FnCalculateContractDetailCommodityHappened] (@contractDetailId int) 
returns decimal(18,8) 
as 
begin 
    declare @isBuy bit = 0
    select @isBuy=c.IsBuy 
    from WFContractInfo c, WFContractDetailInfo d 
    where d.WFContractDetailInfoId=@contractDetailId  
        and  c.WFContractInfoId = d.WFContractInfoId 

    declare @weightSum decimal(18,8) = 0

    if @isBuy=1
        select @weightSum=SUM(ERD.ObjectUnitWeight) 
        from WFContractEntryRecordDetail ERD        
        inner join WFWarehouseEntryRecordDetail ORD on ERD.WFWarehouseEntryRecordDetailId = ORD.WFWarehouseEntryRecordDetailId
        inner join WFWarehouseEntryRecord ER ON ER.WFWarehouseEntryRecordId=ORD.WFWarehouseEntryRecordId 
        where ERD.ObjectId = @contractDetailId
              AND ERD.IsDeleted = 0 
              AND ORD.IsDeleted = 0 
              AND ER.IsDeleted = 0 
              AND ERD.ObjectType = 1 
    else 
        select @weightSum=SUM(ERD.ObjectUnitWeight) 
        from WFContractOutRecordDetail ERD
        inner join WFWarehouseOutRecordDetail ORD on ERD.WFWarehouseOutRecordDetailId = ORD.WFWarehouseOutRecordDetailId
        inner join WFWarehouseOutRecord ER ON ER.WFWarehouseOutRecordId=ORD.WFWarehouseOutRecordID 
        where ERD.ObjectId = @contractDetailId 
              AND ERD.IsDeleted = 0 
              AND ORD.IsDeleted = 0 
              AND ER.IsDeleted = 0 
              AND ER.IsTemphold<>1
              AND ERD.ObjectType = 1 

    return coalesce(@weightSum, 0) 
end 

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[FnCalculateContractWeight](@contractInfoId int)
returns decimal(18,8)
as
BEGIN
	
	declare @contractCommodity decimal(18,8)

	select @contractCommodity=Sum(DI.Weight) from WFContractDetailInfo DI 
	where DI.IsDeleted!=1 and DI.WFContractInfoId=@contractInfoId
	
	return @contractCommodity
END


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------计算合同票的申请量和发生量（预制量）---------------------------------------------------
CREATE FUNCTION [dbo].[FnCalculateInvoiceApplied](@contractInfoId INT)
RETURNS DECIMAL(38,18)
AS
BEGIN
    DECLARE @amountSum DECIMAL(38,18)
    DECLARE @tradeType int
    declare @isReturn bit 

    SELECT @tradeType = TradeType, @isReturn = IsReturn 
    FROM WFContractInfo 
    WHERE WFContractInfoId = @contractInfoId 

    IF ((@tradeType & 1) = 1)
        BEGIN
            SELECT @amountSum=SUM((case when CI.IsReturn = 0 then 1 else -1 end) * ARD.Amount) FROM WFInvoiceRequestDetail ARD 
                    INNER JOIN WFContractDetailInfo AR ON AR.WFContractDetailInfoId=ARD.WFContractDetailInfoId
                    INNER JOIN WFInvoiceRequest IR ON IR.WFInvoiceRequestId = ARD.WFInvoiceRequestId
                    INNER JOIN WFContractInfo CI on CI.WFContractInfoId = AR.WFContractInfoId
                    WHERE AR.WFContractInfoId=@contractInfoId
                    AND IR.IsDeleted<>1

            -- 收票 （收票发票只会取其一）
            SELECT 
                @amountSum = coalesce(@amountSum, 0) + coalesce(sum((case when @isReturn = 1 then -1 else 1 end) * ci.Amount), 0) 
            FROM
                WFContractInvoice ci
            WHERE
                WFContractInvoiceId IN
                (
                    SELECT 
                        DISTINCT y.WFContractInvoiceId
                    from 
                        WFInvoiceObject x
                        inner join WFContractInvoice y on x.WFContractInvoiceId = y.WFContractInvoiceId
                        inner join WFInvoiceRecord z on z.WFInvoiceRecordId = y.WFInvoiceRecordId
                    where
                        z.Status IN (2, 3, 4) -- 初始，预制， 过账
                        AND z.IsDeleted = 0
                        AND z.IsReceive = 1
                        and x.ObjectType = 4 --合同
                        and x.ObjectId = @contractInfoId -- 合同Id
                    UNION
                    SELECT 
                        DISTINCT y.WFContractInvoiceId
                    from 
                        WFInvoiceObject x
                        inner join WFContractInvoice y on x.WFContractInvoiceId = y.WFContractInvoiceId
                        inner join WFInvoiceRecord z on z.WFInvoiceRecordId = y.WFInvoiceRecordId
                    where
                        z.Status IN (2, 3, 4) -- 初始，预制， 过账
                        AND z.IsDeleted = 0
                        AND z.IsReceive = 0
                        and x.ObjectType = 4 --合同
                        and x.ObjectId = @contractInfoId -- 合同Id
                )			
        END
    ELSE
        BEGIN
            -- 外贸
            select @amountSum = sum(amount) 
            from (
                select 
                    SUM((case when f.IsBuy = b.IsReceive then 1 else -1 end) * 
                    coalesce(case when a.FinalInvoiceRecordId is null 
                        then c.Amount 
                        else c.FinalAmount end, 0)) amount
                from 
                    WFCommercialInvoice a 
                    INNER JOIN WFInvoiceRecord b on b.WFInvoiceRecordId = a.WFInvoiceRecordId
                    INNER JOIN dbo.WFContractInvoice c ON c.WFInvoiceRecordId = b.WFInvoiceRecordId
                    INNER JOIN WFInvoiceObject d on d.WFContractInvoiceId = c.WFContractInvoiceId
                    INNER JOIN WFContractDetailInfo e ON e.WFContractDetailInfoId = d.ObjectId	
                    INNER JOIN WFContractInfo f on f.WFContractInfoId = e.WFContractInfoId
                where 
                    f.WFContractInfoId = @contractInfoId 
                    and b.IsDeleted <> 1
                    and d.ObjectType = 1
                    and
                    (
                        (a.IsFinal = 0 AND a.IsBalance = 0) or (a.IsFinal = 1 and a.IsBalance = 0)
                    )           
            ) ciamount
        END
    RETURN @amountSum
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------计算合同票的申请量和发生量（预制量）---------------------------------------------------
CREATE FUNCTION [dbo].[FnCalculateInvoiceAppliedWeight](@contractInfoId INT)
RETURNS DECIMAL(38,18)
AS
BEGIN
    DECLARE @quantitySum DECIMAL(38,18)
    DECLARE @tradeType int
    declare @isReturn bit 

    SELECT @tradeType = TradeType, @isReturn = IsReturn 
    FROM WFContractInfo 
    WHERE WFContractInfoId = @contractInfoId 

    IF ((@tradeType & 1) = 1)
        BEGIN
            SELECT @quantitySum=SUM((case when CI.IsReturn = 0 then 1 else -1 end) * ARD.Weight) FROM WFInvoiceRequestDetail ARD 
                    INNER JOIN WFContractDetailInfo AR ON AR.WFContractDetailInfoId=ARD.WFContractDetailInfoId
                    INNER JOIN WFInvoiceRequest IR ON IR.WFInvoiceRequestId = ARD.WFInvoiceRequestId
                    INNER JOIN WFContractInfo CI on CI.WFContractInfoId = AR.WFContractInfoId
                    WHERE AR.WFContractInfoId=@contractInfoId
                    AND IR.IsDeleted<>1

            -- 收票 （收票发票只会取其一）
            SELECT 
                @quantitySum = coalesce(@quantitySum, 0) + coalesce(sum((case when @isReturn = 1 then -1 else 1 end) * ci.Weight), 0) 
            FROM
                WFContractInvoice ci
            WHERE
                WFContractInvoiceId IN
                (
                    SELECT 
                        DISTINCT y.WFContractInvoiceId
                    from 
                        WFInvoiceObject x
                        inner join WFContractInvoice y on x.WFContractInvoiceId = y.WFContractInvoiceId
                        inner join WFInvoiceRecord z on z.WFInvoiceRecordId = y.WFInvoiceRecordId
                    where
                        z.Status IN (2, 3, 4) -- 初始，预制， 过账
                        AND z.IsDeleted = 0
                        AND z.IsReceive = 1
                        and x.ObjectType = 4 --合同
                        and x.ObjectId = @contractInfoId -- 合同Id
                    UNION
                    SELECT 
                        DISTINCT y.WFContractInvoiceId
                    from 
                        WFInvoiceObject x
                        inner join WFContractInvoice y on x.WFContractInvoiceId = y.WFContractInvoiceId
                        inner join WFInvoiceRecord z on z.WFInvoiceRecordId = y.WFInvoiceRecordId
                    where
                        z.Status IN (2, 3, 4) -- 初始，预制， 过账
                        AND z.IsDeleted = 0
                        AND z.IsReceive = 0
                        and x.ObjectType = 4 --合同
                        and x.ObjectId = @contractInfoId -- 合同Id
                )			
        END
    ELSE
        BEGIN
            -- 外贸
            select @quantitySum = sum(quantity) 
            from (
                select 
                    SUM((case when f.IsBuy = b.IsReceive then 1 else -1 end) * 
                    coalesce(case when a.FinalInvoiceRecordId is null 
                        then c.Weight 
                        else c.FinalWeight end, 0)) quantity
                from 
                    WFCommercialInvoice a 
                    INNER JOIN WFInvoiceRecord b on b.WFInvoiceRecordId = a.WFInvoiceRecordId
                    INNER JOIN dbo.WFContractInvoice c ON c.WFInvoiceRecordId = b.WFInvoiceRecordId
                    INNER JOIN WFInvoiceObject d on d.WFContractInvoiceId = c.WFContractInvoiceId
                    INNER JOIN WFContractDetailInfo e ON e.WFContractDetailInfoId = d.ObjectId	
                    INNER JOIN WFContractInfo f on f.WFContractInfoId = e.WFContractInfoId
                where 
                    f.WFContractInfoId = @contractInfoId 
                    and b.IsDeleted <> 1
                    and d.ObjectType = 1
                    and
                    (
                        (a.IsFinal = 0 AND a.IsBalance = 0) or (a.IsFinal = 1 and a.IsBalance = 0)
                    )           
            ) ciamount
        END
    RETURN @quantitySum
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[FnCalculateInvoiceFutureValueHappened](@contractInfoId int)
returns decimal(18,2)
as
BEGIN
    --
    declare @amountSum decimal(18,2)
    declare @tradeType int
    select @tradeType = TradeType from WFContractInfo where WFContractInfoId = @contractInfoId
    if ((@tradeType & 1) = 1)
    begin
    -- 内贸
        select @amountSum=SUM((case when CI.IsBuy = IR.IsReceive then 1 else -1 end) * ARD.Amount) from WFContractInvoice ARD 
              INNER JOIN WFContractDetailInfo AR ON AR.WFContractDetailInfoId=ARD.WFContractDetailInfoId
            INNER JOIN WFInvoiceRecord IR on IR.WFInvoiceRecordId = ARD.WFInvoiceRecordId
            INNER JOIN WFContractInfo CI on CI.WFContractInfoId = AR.WFContractInfoId
            where AR.WFContractInfoId=@contractInfoId AND IR.IsDeleted<>1
    end
    else
    begin
    -- 外贸
        select @amountSum=SUM((case when CInfo.IsBuy = IR.IsReceive then 1 else -1 end) * 
        (case when CI.FinalTotalAmount is not null then
        (case when InvO.FinalObjectCurrencyFutureValue is not null then  CI.TotalHappendAmount else 0 end) 
        -- (case when InvO.FinalObjectCurrencyFutureValue is not null then  InvO.FinalObjectCurrencyFutureValue else 0 end) 
         else (case when InvO.ObjectCurrencyFutureValue is not null then InvO.ObjectCurrencyFutureValue else 0 end) end)) 
         from WFCommercialInvoice CI
            INNER JOIN WFInvoiceRecord IR on CI.WFInvoiceRecordId=IR.WFInvoiceRecordId
            INNER JOIN WFInvoiceObject InvO on CI.WFInvoiceRecordId=InvO.WFInvoiceRecordId
            INNER JOIN WFContractInfo CInfo on CInfo.WFContractInfoId = CI.WFContractInfoId
            where CI.WFContractInfoId = @contractInfoId AND IR.IsDeleted <> 1
    end
            
    return @amountSum
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[FnCalculateInvoiceHappened] (@contractInfoId int)
returns decimal(38,18)
as
BEGIN
    declare @amountSum decimal(38,18)
    declare @tradeType int
    declare @isReturn bit 

    select @tradeType = TradeType, @isReturn = IsReturn 
    from WFContractInfo 
    where WFContractInfoId = @contractInfoId 

    if ((@tradeType & 1) = 1)
        begin
            -- 内贸

            -- 对接SAP前历史数据
            select 
                @amountSum = SUM((case when CI.IsBuy = IR.IsReceive then 1 else -1 end) * ARD.Amount) 
            from 
                WFContractInvoice ARD 
                INNER JOIN WFContractDetailInfo AR ON AR.WFContractDetailInfoId = ARD.WFContractDetailInfoId
                INNER JOIN WFInvoiceRecord IR on IR.WFInvoiceRecordId = ARD.WFInvoiceRecordId
                INNER JOIN WFContractInfo CI on CI.WFContractInfoId = AR.WFContractInfoId
            where 
                AR.WFContractInfoId = @contractInfoId 
                AND IR.IsDeleted <> 1
                and (ir.Status is null or ir.Status = 1) -- null or None

            -- 收票 （收票发票只会取其一）
            SELECT 
                @amountSum = coalesce(@amountSum, 0) + coalesce(sum((case when @isReturn = 1 then -1 else 1 end) * ci.Amount), 0) 
            FROM
                WFContractInvoice ci
            WHERE
                WFContractInvoiceId IN
                (
                    SELECT 
                        DISTINCT y.WFContractInvoiceId
                    from 
                        WFInvoiceObject x
                        inner join WFContractInvoice y on x.WFContractInvoiceId = y.WFContractInvoiceId
                        inner join WFInvoiceRecord z on z.WFInvoiceRecordId = y.WFInvoiceRecordId
                    where
                        z.Status IN (3, 4) -- 预制,过账
                        AND z.IsDeleted = 0
                        AND z.IsReceive = 1
                        and x.ObjectType = 4 --合同
                        and x.ObjectId = @contractInfoId -- 合同Id
                    UNION 
                    SELECT 
                        DISTINCT y.WFContractInvoiceId
                    from 
                        WFInvoiceObject x
                        inner join WFContractInvoice y on x.WFContractInvoiceId = y.WFContractInvoiceId
                        inner join WFInvoiceRecord z on z.WFInvoiceRecordId = y.WFInvoiceRecordId
                    where
                        z.Status IN (3, 4) -- 预制,过账
                        AND z.IsDeleted = 0
                        AND z.IsReceive = 0
                        and x.ObjectType = 4 --合同
                        and x.ObjectId = @contractInfoId -- 合同Id
                )
        end
    else
    begin
    -- 外贸
        SELECT 
            @amountSum = sum(ci.Amount) 
        FROM
            WFContractInvoice ci
        WHERE
            WFContractInvoiceId IN
            (
                SELECT 
                    DISTINCT y.WFContractInvoiceId
                from 
                    WFInvoiceObject x
                    inner join WFContractInvoice y on x.WFContractInvoiceId = y.WFContractInvoiceId
                    inner join WFInvoiceRecord z on z.WFInvoiceRecordId = y.WFInvoiceRecordId
                where
                    z.Status IN (3, 4) -- 预制,过账
                    and z.TradeType = 14
                    and z.InvoiceCategory = 1 --财务发票
                    and z.InvoiceType = 2 --商业发票
                    and z.IsDeleted = 0
                    and x.ObjectType = 4 --合同
                    and x.ObjectId = @contractInfoId -- 合同Id
                    and z.WFInvoiceRecordId not in (
                        SELECT 
                            DISTINCT xx.ParentId
                        from 
                            WFInvoiceRecord xx
                            inner join WFContractInvoice yy on yy.WFInvoiceRecordId = xx.WFInvoiceRecordId
                            inner join WFInvoiceObject zz on zz.WFContractInvoiceId = yy.WFContractInvoiceId
                        where
                            xx.Status IN (3, 4) -- 预制,过账
                            and xx.TradeType = 14
                            and xx.InvoiceCategory = 1 --财务发票
                            and xx.InvoiceType = 2 --商业发票
                            and xx.InvoicePropertyType = 2 --调整发票
                            and xx.IsDeleted = 0
                            and zz.ObjectType = 4 --合同
                            and zz.ObjectId = @contractInfoId -- 合同Id
                    )	
            )
    end

    return @amountSum
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[FnCalculateInvoiceHappenedWeight] (@contractInfoId int)
returns decimal(38,18)
as
BEGIN
    declare @quantitySum decimal(38,18)
    declare @tradeType int
    declare @isReturn bit 

    select @tradeType = TradeType, @isReturn = IsReturn 
    from WFContractInfo 
    where WFContractInfoId = @contractInfoId 

    if ((@tradeType & 1) = 1)
        begin
            -- 内贸

            -- 对接SAP前历史数据
            select 
                @quantitySum = SUM((case when CI.IsBuy = IR.IsReceive then 1 else -1 end) * ARD.Weight) 
            from 
                WFContractInvoice ARD 
                INNER JOIN WFContractDetailInfo AR ON AR.WFContractDetailInfoId = ARD.WFContractDetailInfoId
                INNER JOIN WFInvoiceRecord IR on IR.WFInvoiceRecordId = ARD.WFInvoiceRecordId
                INNER JOIN WFContractInfo CI on CI.WFContractInfoId = AR.WFContractInfoId
            where 
                AR.WFContractInfoId = @contractInfoId 
                AND IR.IsDeleted <> 1
                and (ir.Status is null or ir.Status = 1) -- null or None

            -- 收票 （收票发票只会取其一）
            SELECT 
                @quantitySum = coalesce(@quantitySum, 0) + coalesce(sum((case when @isReturn = 1 then -1 else 1 end) * ci.Weight), 0) 
            FROM
                WFContractInvoice ci
            WHERE
                WFContractInvoiceId IN
                (
                    SELECT 
                        DISTINCT y.WFContractInvoiceId
                    from 
                        WFInvoiceObject x
                        inner join WFContractInvoice y on x.WFContractInvoiceId = y.WFContractInvoiceId
                        inner join WFInvoiceRecord z on z.WFInvoiceRecordId = y.WFInvoiceRecordId
                    where
                        z.Status IN (3, 4) -- 预制,过账
                        AND z.IsDeleted = 0
                        AND z.IsReceive = 1
                        and x.ObjectType = 4 --合同
                        and x.ObjectId = @contractInfoId -- 合同Id
                    UNION 
                    SELECT 
                        DISTINCT y.WFContractInvoiceId
                    from 
                        WFInvoiceObject x
                        inner join WFContractInvoice y on x.WFContractInvoiceId = y.WFContractInvoiceId
                        inner join WFInvoiceRecord z on z.WFInvoiceRecordId = y.WFInvoiceRecordId
                    where
                        z.Status IN (3, 4) -- 预制,过账
                        AND z.IsDeleted = 0
                        AND z.IsReceive = 0
                        and x.ObjectType = 4 --合同
                        and x.ObjectId = @contractInfoId -- 合同Id
                )
        end
    else
    begin
    -- 外贸
        SELECT 
            @quantitySum = sum(ci.Weight) 
        FROM
            WFContractInvoice ci
        WHERE
            WFContractInvoiceId IN
            (
                SELECT 
                    DISTINCT y.WFContractInvoiceId
                from 
                    WFInvoiceObject x
                    inner join WFContractInvoice y on x.WFContractInvoiceId = y.WFContractInvoiceId
                    inner join WFInvoiceRecord z on z.WFInvoiceRecordId = y.WFInvoiceRecordId
                where
                    z.Status IN (3, 4) -- 预制,过账
                    and z.TradeType = 14
                    and z.InvoiceCategory = 1 --财务发票
                    and z.InvoiceType = 2 --商业发票
                    and z.IsDeleted = 0
                    and x.ObjectType = 4 --合同
                    and x.ObjectId = @contractInfoId -- 合同Id
                    and z.WFInvoiceRecordId not in (
                        SELECT 
                            DISTINCT xx.ParentId
                        from 
                            WFInvoiceRecord xx
                            inner join WFContractInvoice yy on yy.WFInvoiceRecordId = xx.WFInvoiceRecordId
                            inner join WFInvoiceObject zz on zz.WFContractInvoiceId = yy.WFContractInvoiceId
                        where
                            xx.Status IN (3, 4) -- 预制,过账
                            and xx.TradeType = 14
                            and xx.InvoiceCategory = 1 --财务发票
                            and xx.InvoiceType = 2 --商业发票
                            and xx.InvoicePropertyType = 2 --调整发票
                            and xx.IsDeleted = 0
                            and zz.ObjectType = 4 --合同
                            and zz.ObjectId = @contractInfoId -- 合同Id
                    )	
            )
    end

    return @quantitySum
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FnIsPriceFinished] (@priceDetailId int)
returns bit
as
BEGIN

    declare @priceMakingType smallint
    declare @isFinished bit
    
    --判断是否为采购合同    
    select @priceMakingType=PriceMakingType from WFPriceDetail where WFPriceDetailId=@priceDetailId

    --判断合同是否完成货
    -- Fire = 2
    -- Avg = 3
    -- ComplexPrice = 4
    -- Undeclared = 5
    if @priceMakingType = 2
          begin
            select @isFinished = (select IsFireCompleted from WFFirePriceDetail where WFPriceDetailId=@priceDetailId)
            end            
    else
            begin
            select @isFinished = (case when PD.FinalPrice is not null and PD.FinalPrice != 0 then 1 else 0 end) from WFPriceDetail PD where PD.WFPriceDetailId = @priceDetailId
            end
  
return @isFinished
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[FnSplitStr]
(
    @str nvarchar(max),
    @split nchar(1)
)
RETURNS @temp TABLE ( F1 nvarchar(500) )
AS
    BEGIN   
        DECLARE @ch AS nvarchar(500);   
        DECLARE @i_p as int;
        DECLARE @i_c as int;
        DECLARE @len as int;
        set @i_p = 0;
        set @i_c = CHARINDEX(@split, @str);
        set @len = len(@str);
        if @len > 0
        begin
        while @i_c <> 0 
        begin
            set @ch = substring(@str, @i_p + 1, @i_c - @i_p - 1);
            INSERT @temp VALUES (@ch);
            set @i_p = @i_c;
            set @i_c = CHARINDEX(@split, @str, @i_c + 1);
        end
        set @ch = substring(@str, @i_p + 1, @len - @i_p);
        INSERT @temp VALUES (@ch);
        end

        RETURN  

        --SET @str = @str + @split;     
        --WHILE ( @str <> '' )
            --BEGIN   
                --SET @ch = LEFT(@str, CHARINDEX(',', @str, 1) - 1)  
                --INSERT @temp VALUES (@ch) 
                --SET @str = STUFF(@str, 1, CHARINDEX(',', @str, 1), '')   
            --END  
        --RETURN  
    END 

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[FnSplitStrToInt]
(
    @str nvarchar(max),
    @split nchar(1)
)
RETURNS @temp TABLE ( F1 int not null )
AS
    BEGIN   
        DECLARE @ch AS nvarchar(20);   
        DECLARE @i_p as int;
        DECLARE @i_c as int;
        DECLARE @len as int;
        set @i_p = 0;
        set @i_c = CHARINDEX(@split, @str);
        set @len = len(@str);
        if @len > 0
        begin
        while @i_c <> 0 
        begin
            set @ch = substring(@str, @i_p + 1, @i_c - @i_p - 1);
            INSERT @temp VALUES (@ch);
            set @i_p = @i_c;
            set @i_c = CHARINDEX(@split, @str, @i_c + 1);
        end
        set @ch = substring(@str, @i_p + 1, @len - @i_p);
        INSERT @temp VALUES (@ch);
        end

        RETURN  
    END 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[FnSplitStrToLong]
(
    @str nvarchar(max),
    @split nchar(1)
)
RETURNS @temp TABLE ( F1 bigint not null )
AS
    BEGIN   
        DECLARE @ch AS nvarchar(20);   
        DECLARE @i_p as int;
        DECLARE @i_c as int;
        DECLARE @len as int;
        set @i_p = 0;
        set @i_c = CHARINDEX(@split, @str);
        set @len = len(@str);
        if @len > 0
        begin
        while @i_c <> 0 
        begin
            set @ch = substring(@str, @i_p + 1, @i_c - @i_p - 1);
            INSERT @temp VALUES (@ch);
            set @i_p = @i_c;
            set @i_c = CHARINDEX(@split, @str, @i_c + 1);
        end
        set @ch = substring(@str, @i_p + 1, @len - @i_p);
        INSERT @temp VALUES (@ch);
        end

        RETURN  
    END 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[Get_StrArrayLength] 
( 
@str varchar(max), --要分割的字符串 
@split varchar(10) --分隔符号 
) 
returns int 
as 
begin 
declare @location int 
declare @start int 
declare @length int 

set @str=ltrim(rtrim(@str)) 
set @location=charindex(@split,@str) 
set @length=1 
while @location<>0 
begin 
set @start=@location+1 
set @location=charindex(@split,@str,@start) 
set @length=@length+1 
end 
return @length 
end 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[Get_StrArrayStrOfIndex] 
( 
@str varchar(max), --要分割的字符串 
@split varchar(10), --分隔符号 
@index int --取第几个元素 
) 
returns varchar(max) 
as 
begin 
declare @location int 
declare @start int 
declare @next int 
declare @seed int 

set @str=ltrim(rtrim(@str)) 
set @start=1 
set @next=1 
set @seed=len(@split) 

set @location=charindex(@split,@str) 
while @location<>0 and @index>@next 
begin 
set @start=@location+@seed 
set @location=charindex(@split,@str,@start) 
set @next=@next+1 
end 
if @location =0 select @location =len(@str)+1 
--这儿存在两种情况：1、字符串不存在分隔符号 2、字符串中存在分隔符号，跳出while循环后，@location为0，那默认为字符串后边有一个分隔符号。 

return substring(@str,@start,@location-@start) 
end 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OnlineTime](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountingEntity] [nvarchar](100) NULL,
	[Commodity] [nvarchar](50) NULL,
	[Currency] [nvarchar](50) NULL,
	[Corporation] [nvarchar](100) NULL,
	[TradeDate] [date] NOT NULL,
	[Type] [smallint] NOT NULL,
	[TradeType] [int] NULL,
 CONSTRAINT [PK_OnlineTime] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OnlineTimeFlag](
	[TradeDate] [date] NOT NULL,
 CONSTRAINT [PK_ONLINETIMEFLAG] PRIMARY KEY CLUSTERED 
(
	[TradeDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpotMortgageProcessingFlag](
	[WFPledgeInfoId] [int] NOT NULL,
	[WFUnPledgeInfoId] [int] NOT NULL,
	[LastUpdateTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpotTradeProcessingFlag](
	[FlagId] [int] IDENTITY(1,1) NOT NULL,
	[AccountingDataLogId] [int] NOT NULL,
	[LastUpdatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_SPOTTRADEPROCESSINGFLAG] PRIMARY KEY CLUSTERED 
(
	[FlagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SyncContractDetail](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Unavailable] [bit] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
	[LastUpdateTime] [datetime] NULL,
	[ContractDetailId] [int] NOT NULL,
	[ContractId] [int] NULL,
	[Material] [nvarchar](30) NULL,
	[Brand] [nvarchar](50) NULL,
	[Volume] [decimal](19, 9) NULL,
	[BasisPrice] [decimal](19, 9) NULL,
	[SettlementPrice] [decimal](19, 9) NULL,
	[PremiumDiscount] [decimal](19, 9) NULL,
	[FreightCharges] [decimal](19, 9) NULL,
	[ProcessingCharges] [decimal](19, 9) NULL,
 CONSTRAINT [PK_SyncContractDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_SyncContractDetail] UNIQUE NONCLUSTERED 
(
	[ContractDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SynchronizationErrorLog](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[ErrorMsg] [nvarchar](1000) NULL,
	[LastUpdateTime] [datetime] NULL,
 CONSTRAINT [PK_SYNCHRONIZATIONERRORLOG] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SyncSpotInventory](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TradeDate] [date] NULL,
	[AccountingEntity] [nvarchar](30) NULL,
	[Corporation] [nvarchar](20) NULL,
	[Currency] [nvarchar](10) NULL,
	[Commodity] [nvarchar](20) NULL,
	[Volume] [decimal](19, 9) NULL,
	[LastUpdateTime] [datetime] NULL,
 CONSTRAINT [PK_SyncSpotInventory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SyncSpotMortgage](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MortgageSequenceNumber] [nvarchar](50) NULL,
	[TradeDate] [date] NULL,
	[AccountingEntity] [nvarchar](30) NULL,
	[Corporation] [nvarchar](20) NULL,
	[Currency] [nvarchar](10) NULL,
	[Commodity] [nvarchar](20) NULL,
	[Counterparty] [nvarchar](30) NULL,
	[MortgageDirection] [nvarchar](20) NULL,
	[MortgageVolume] [decimal](19, 9) NULL,
	[MortgageRate] [decimal](19, 9) NULL,
	[Volume] [decimal](19, 9) NULL,
	[MortgagePrice] [decimal](19, 9) NULL,
	[TotalAmount] [decimal](19, 6) NULL,
	[MortgageInterestRate] [decimal](19, 9) NULL,
	[Interest] [decimal](19, 9) NULL,
	[RedemptionStatus] [nvarchar](50) NULL,
	[LastUpdateTime] [datetime] NULL,
	[ObjectType] [int] NULL,
	[ObjectId] [int] NULL,
 CONSTRAINT [PK_SyncSpotMortgage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SyncSpotTrade](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RecordStatus] [tinyint] NOT NULL,
	[AccountingDataLogId] [int] NULL,
	[OriginalId] [varchar](50) NULL,
	[TradeDate] [date] NULL,
	[AccountingEntity] [nvarchar](30) NULL,
	[Sponsor] [nvarchar](30) NULL,
	[TradingPurpose] [nvarchar](20) NULL,
	[Currency] [nvarchar](10) NULL,
	[Commodity] [nvarchar](20) NULL,
	[Direction] [nvarchar](8) NULL,
	[Volume] [decimal](19, 9) NULL,
	[Price] [decimal](19, 9) NULL,
	[ExtensionFee] [decimal](19, 9) NULL,
	[Rebate] [decimal](19, 9) NULL,
	[TotalAmount] [decimal](19, 6) NULL,
	[Corporation] [nvarchar](20) NULL,
	[HedgingCorporation] [nvarchar](20) NULL,
	[PremiumDiscount] [decimal](19, 9) NULL,
	[Counterparty] [nvarchar](100) NULL,
	[Brand] [nvarchar](100) NULL,
	[Warehouse] [nvarchar](100) NULL,
	[OtherFees] [decimal](19, 9) NULL,
	[PaymentMethods] [nvarchar](50) NULL,
	[ContractNumber] [nvarchar](50) NULL,
	[ContractCommodity] [nvarchar](20) NULL,
	[ContractVolume] [decimal](19, 9) NULL,
	[Operator] [nvarchar](50) NULL,
	[Remark] [nvarchar](1000) NULL,
	[ContractId] [int] NULL,
	[DataType] [nvarchar](50) NULL,
	[LastUpdateTime] [datetime] NULL,
	[LastProcessingTime] [datetime] NULL,
	[LastUserModifiesTime] [datetime] NULL,
	[Unavailable] [bit] NOT NULL,
	[ContractType] [nvarchar](50) NULL,
 CONSTRAINT [PK_SyncSpotTrade] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SyncTradeContractInfo](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ContractId] [int] NULL,
	[ContractNumber] [nvarchar](50) NULL,
	[ERPContractNumber] [nvarchar](50) NULL,
	[Direction] [nvarchar](8) NULL,
	[TradeType] [nvarchar](8) NULL,
	[ContractType] [nvarchar](10) NULL,
	[TransactionType] [nvarchar](10) NULL,
	[ObjectId] [int] NULL,
	[AccountingEntity] [nvarchar](30) NULL,
	[Corporation] [nvarchar](100) NULL,
	[Counterparty] [nvarchar](100) NULL,
	[Commodity] [nvarchar](20) NULL,
	[Volume] [decimal](19, 9) NULL,
	[Unit] [nvarchar](20) NULL,
	[Currency] [nvarchar](15) NULL,
	[MortgageInterestRate] [decimal](19, 9) NULL,
	[TaxRate] [decimal](19, 6) NULL,
	[Unavailable] [bit] NOT NULL,
	[SignDate] [date] NULL,
	[CommodityCompletedDate] [datetime] NULL,
	[PriceCompletedDate] [datetime] NULL,
	[AmountCompletedDate] [datetime] NULL,
	[InvoiceCompletedDate] [datetime] NULL,
	[ContractCompletedDate] [datetime] NULL,
	[CreationTime] [datetime] NOT NULL,
	[LastUpdateTime] [datetime] NULL,
	[UnitExchangeRate] [decimal](18, 8) NULL,
	[PricingUnit] [nvarchar](10) NULL,
	[PricingCurrency] [nvarchar](10) NULL,
	[PricingTempExchangeRate] [decimal](18, 8) NULL,
	[PricingFinalExchangeRate] [decimal](18, 8) NULL,
	[FinalExchangeRateConfirmDate] [datetime] NULL,
	[PlegeDetailNumber] [int] NULL,
	[Department] [nvarchar](100) NULL,
	[Saler] [nvarchar](50) NULL,
	[PriceMarket] [nvarchar](100) NULL,
	[TotalAmount] [decimal](19, 6) NULL,
	[PurposeType] [nvarchar](30) NULL,
	[MortgageRate] [decimal](19, 9) NULL,
 CONSTRAINT [PK_SYNCTRADECONTRACTINFO] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SyncTradeDeliveryBatch](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DeliveryDate] [date] NULL,
	[ContractId] [int] NULL,
	[BatchCode] [nvarchar](20) NULL,
	[PrecursorBatchCode] [nvarchar](20) NULL,
	[OrigianlBatchCode] [nvarchar](50) NULL,
	[PrecursorSaleContractId] [int] NULL,
	[DeliveryId] [int] NULL,
	[DeliveryCode] [nvarchar](50) NULL,
	[Direction] [nvarchar](8) NULL,
	[Commodity] [nvarchar](20) NULL,
	[Volume] [decimal](19, 9) NULL,
	[Unit] [nvarchar](20) NULL,
	[DataType] [nvarchar](15) NULL,
	[OperationType] [nvarchar](15) NULL,
	[Operator] [nvarchar](50) NULL,
	[OriginalId] [uniqueidentifier] NOT NULL,
	[Unavailable] [bit] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
	[LastUpdateTime] [datetime] NOT NULL,
	[PreorderBatchCode] [nvarchar](20) NULL,
	[ContractDetailId] [int] NULL,
	[AccountingEntity] [nvarchar](30) NULL,
	[Corporation] [nvarchar](100) NULL,
	[WarehouseId] [int] NULL,
	[Warehouse] [nvarchar](100) NULL,
	[TradeType] [nvarchar](8) NULL,
 CONSTRAINT [PK_SYNCTRADEDELIVERYBATCH] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SyncTradePayment](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TradeDate] [date] NULL,
	[ContractId] [int] NULL,
	[Direction] [nvarchar](8) NULL,
	[Volume] [decimal](19, 9) NULL,
	[PayType] [nvarchar](8) NULL,
	[PayCurrency] [nvarchar](15) NULL,
	[PayVolume] [decimal](19, 9) NULL,
	[BillCode] [nvarchar](50) NULL,
	[BillCurrency] [nvarchar](15) NULL,
	[BillAmount] [decimal](19, 9) NULL,
	[DiscountCost] [decimal](19, 9) NULL,
	[AmountRecordId] [int] NULL,
	[Unavailable] [bit] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
	[LastUpdateTime] [datetime] NULL,
 CONSTRAINT [PK_SYNCTRADEPAYMENT] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SyncTradePriced](
	[Id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TradeDate] [date] NULL,
	[ContractId] [int] NULL,
	[Direction] [nvarchar](8) NULL,
	[Volume] [decimal](19, 9) NULL,
	[Price] [decimal](19, 9) NULL,
	[PremiumDiscount] [decimal](19, 9) NULL,
	[ExtensionFee] [decimal](19, 9) NULL,
	[Swap] [decimal](19, 9) NULL,
	[OperationType] [nvarchar](15) NULL,
	[Operator] [nvarchar](50) NULL,
	[ObjectType] [int] NULL,
	[ObjectId] [int] NULL,
	[OriginalId] [uniqueidentifier] NOT NULL,
	[Unavailable] [bit] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
	[LastUpdateTime] [datetime] NOT NULL,
	[ContractDetailId] [int] NULL,
	[FirePriceRecordId] [int] NULL,
	[FreightCharges] [decimal](19, 9) NULL,
	[ProcessingCharges] [decimal](19, 9) NULL,
	[BasisPrice] [decimal](19, 9) NULL,
 CONSTRAINT [PK_SYNCTRADEPRICED] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAccountEntity](
	[WFAccountEntityId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[ParentDepartmentId] [int] NULL,
	[Type] [smallint] NULL,
	[IsAccounting] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AccountingName] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFACCOUNTENTITY] PRIMARY KEY CLUSTERED 
(
	[WFAccountEntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAccountingDataLog](
	[AccountingDataLogId] [int] IDENTITY(1,1) NOT NULL,
	[TradeDate] [date] NOT NULL,
	[AccountingEntity] [nvarchar](50) NULL,
	[Sponsor] [nvarchar](30) NOT NULL,
	[Currency] [nvarchar](10) NOT NULL,
	[Commodity] [nvarchar](20) NOT NULL,
	[Direction] [nvarchar](8) NOT NULL,
	[Volume] [decimal](18, 8) NOT NULL,
	[Price] [decimal](18, 8) NOT NULL,
	[Corporation] [nvarchar](20) NOT NULL,
	[Counterparty] [nvarchar](100) NULL,
	[Brand] [nvarchar](100) NULL,
	[Warehouse] [nvarchar](100) NULL,
	[UpdateTime] [datetime] NOT NULL,
	[OperationType] [int] NOT NULL,
	[ObjectId] [int] NULL,
	[ObjectType] [int] NULL,
	[LinkId] [nvarchar](50) NOT NULL,
	[DataType] [nvarchar](50) NOT NULL,
	[Modifier] [nvarchar](50) NOT NULL,
	[ContractId] [int] NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[ProcessingStatus] [tinyint] NULL,
	[PremiumDiscount] [decimal](18, 8) NULL,
	[ContractCode] [nvarchar](50) NULL,
	[ContractType] [nvarchar](50) NULL,
	[ExtensionFee] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFACCOUNTINGDATALOG] PRIMARY KEY CLUSTERED 
(
	[AccountingDataLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAccountingDataLogDetail](
	[WFAccountingDataLogDetailId] [int] IDENTITY(1,1) NOT NULL,
	[AccountingDataLogId] [int] NULL,
	[OrignalValue] [nvarchar](100) NOT NULL,
	[NewValue] [nvarchar](100) NOT NULL,
	[ValueType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_WFACCOUNTINGDATALOGDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFAccountingDataLogDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAccountingFee](
	[WFAccountingFeeId] [int] IDENTITY(1,1) NOT NULL,
	[FeeDate] [datetime] NULL,
	[FinanceDate] [datetime] NULL,
	[AccountEntity] [nvarchar](50) NULL,
	[Coporation] [nvarchar](100) NULL,
	[Commodity] [nvarchar](50) NULL,
	[FeeType] [nvarchar](50) NULL,
	[FinanceAccount] [nvarchar](100) NULL,
	[Amount] [decimal](18, 8) NULL,
	[Currency] [nvarchar](50) NULL,
	[ContractCode] [nvarchar](50) NULL,
	[Creator] [nvarchar](50) NULL,
	[CreateTime] [datetime] NULL,
	[OperationType] [nvarchar](50) NULL,
	[OperationStatus] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFACCOUNTINGFEE] PRIMARY KEY CLUSTERED 
(
	[WFAccountingFeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAccountingTask](
	[WFAccountingTaskId] [int] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[TaskResult] [bit] NULL,
 CONSTRAINT [PK_WFACCOUNTINGTASK] PRIMARY KEY CLUSTERED 
(
	[WFAccountingTaskId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFActualApprovalStep](
	[WFActualApprovalStepId] [int] IDENTITY(1,1) NOT NULL,
	[WFActualApprovalWFId] [int] NULL,
	[WFActualApproverId] [int] NULL,
	[IsHappened] [bit] NULL,
	[StepIndex] [int] NULL,
	[ParentStepId] [int] NULL,
	[StepType] [smallint] NULL,
	[Name] [nvarchar](50) NULL,
	[Note] [nvarchar](200) NULL,
	[ActualNextStepId] [int] NULL,
	[StepResult] [smallint] NULL,
 CONSTRAINT [PK_WFACTUALAPPROVALSTEP] PRIMARY KEY CLUSTERED 
(
	[WFActualApprovalStepId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFActualApprovalStepUser](
	[WFActualApprovalStepUserId] [int] IDENTITY(1,1) NOT NULL,
	[WFActualApprovalStepId] [int] NULL,
	[UserId] [int] NOT NULL,
	[StepUserType] [smallint] NOT NULL,
	[ActualApprovalId] [int] NULL,
 CONSTRAINT [PK_WFACTUALAPPROVALSTEPUSER] PRIMARY KEY CLUSTERED 
(
	[WFActualApprovalStepUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFActualApprovalStepUser] UNIQUE NONCLUSTERED 
(
	[WFActualApprovalStepId] ASC,
	[UserId] ASC,
	[StepUserType] ASC,
	[ActualApprovalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFActualApprovalWF](
	[WFActualApprovalWFId] [int] IDENTITY(1,1) NOT NULL,
	[WFApprovalWorkflowTemplateId] [int] NULL,
	[ObjectId] [int] NULL,
	[ObjectType] [int] NULL,
	[UserId] [int] NULL,
	[Time] [datetime] NULL,
	[Status] [smallint] NULL,
	[CurrentStepId] [int] NULL,
	[ContentType] [smallint] NOT NULL,
	[IsOtherForm] [bit] NOT NULL,
 CONSTRAINT [PK_WFACTUALAPPROVALWF] PRIMARY KEY CLUSTERED 
(
	[WFActualApprovalWFId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFActualApprover](
	[WFActualApproverId] [int] IDENTITY(1,1) NOT NULL,
	[ApproverType] [smallint] NULL,
	[Name] [nvarchar](100) NULL,
	[Note] [nvarchar](500) NULL,
	[WFUserId] [int] NULL,
 CONSTRAINT [PK_WFACTUALAPPROVER] PRIMARY KEY CLUSTERED 
(
	[WFActualApproverId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFActualStepCondition](
	[WFActualStepConditionId] [int] IDENTITY(1,1) NOT NULL,
	[SourceWFActualApprovalStepId] [int] NULL,
	[TargetWFActualApprovalStepId] [int] NULL,
	[Condition] [nvarchar](1000) NULL,
	[Action] [smallint] NULL,
	[Result] [smallint] NULL,
	[ConditionNote] [nvarchar](500) NULL,
	[MemberPassType] [smallint] NULL,
 CONSTRAINT [PK_WFACTUALSTEPCONDITION] PRIMARY KEY CLUSTERED 
(
	[WFActualStepConditionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFActuaStepAction](
	[WFActuaStepActionId] [int] IDENTITY(1,1) NOT NULL,
	[WFActualApproverId] [int] NULL,
	[WFActualApprovalStepId] [int] NULL,
	[ActionType] [smallint] NULL,
	[IsPreStepAction] [bit] NULL,
	[StepResultType] [smallint] NULL,
 CONSTRAINT [PK_WFACTUASTEPACTION] PRIMARY KEY CLUSTERED 
(
	[WFActuaStepActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAdditionalConfiguration](
	[WFAdditionalConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[AdditionalConfigurationType] [smallint] NOT NULL,
	[SAPCode] [nvarchar](50) NULL,
	[Name] [nvarchar](100) NULL,
	[Note] [nvarchar](100) NULL,
	[Direction] [smallint] NULL,
	[TaxCodeType] [smallint] NULL,
	[TaxRate] [decimal](18, 8) NULL,
	[FeeConditionTypeCategory] [smallint] NULL,
 CONSTRAINT [PK_WFAdditionalConfiguration] PRIMARY KEY CLUSTERED 
(
	[WFAdditionalConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAggregateBill](
	[WFAggregateBillId] [int] IDENTITY(1,1) NOT NULL,
	[AggregateBillType] [int] NOT NULL,
	[CreationTime] [datetime] NULL,
	[Creator] [int] NULL,
 CONSTRAINT [PK_WFAGGREGATEBILL] PRIMARY KEY CLUSTERED 
(
	[WFAggregateBillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAggregateBillDetail](
	[WFAggregateBillDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFAggregateBillId] [int] NOT NULL,
	[ObjectId] [int] NOT NULL,
 CONSTRAINT [PK_WFAGGREGATEBILLDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFAggregateBillDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFAggregateBillDetail] UNIQUE NONCLUSTERED 
(
	[WFAggregateBillId] ASC,
	[ObjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAmountRecord](
	[WFAmountRecordId] [int] IDENTITY(1,1) NOT NULL,
	[WFPayRequestId] [int] NULL,
	[CorporationId] [int] NULL,
	[CustomerId] [int] NULL,
	[IsPay] [bit] NOT NULL,
	[PayType] [int] NULL,
	[Amount] [decimal](18, 8) NULL,
	[CurrencyId] [int] NOT NULL,
	[CreateTime] [datetime] NULL,
	[IsSystemGenerate] [bit] NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[CompanyBankInfoId] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[PayPurpose] [nvarchar](100) NULL,
	[WFSettlementRequestId] [int] NULL,
	[PayReceiveDate] [datetime] NULL,
	[CommodityId] [int] NULL,
	[Creator] [int] NULL,
	[SalerId] [int] NULL,
	[AccountingEntityId] [int] NULL,
	[PayPurposeType] [smallint] NOT NULL,
	[MarginReturned] [decimal](18, 8) NULL,
	[MarginAsPayment] [decimal](18, 8) NULL,
	[TradeType] [smallint] NOT NULL,
	[ExchangeRateId] [int] NULL,
	[ActualCurrencyId] [int] NULL,
	[ActualCurrencyAmount] [decimal](18, 8) NULL,
	[SettleCurrencyPresentValue] [decimal](18, 8) NULL,
	[SettleCurrencyFutureValue] [decimal](18, 8) NULL,
	[ActualCurrencyPresentValue] [decimal](18, 8) NULL,
	[ActualCurrencyFutureValue] [decimal](18, 8) NULL,
	[WFExchangeBillId] [int] NULL,
	[BillDiscountRate] [decimal](18, 17) NULL,
	[BillDiscountDays] [int] NULL,
	[DetailObjectType] [int] NOT NULL,
	[WholeAmountUid] [uniqueidentifier] NULL,
	[AnnualDays] [int] NULL,
	[DiscountRatio] [decimal](18, 17) NULL,
	[AmountMapType] [int] NOT NULL,
	[AmountPayeeId] [int] NULL,
	[WFReceivingClaimId] [int] NULL,
	[ExchangeBillCode] [nvarchar](50) NULL,
	[WFPaymentProposalId] [int] NULL,
 CONSTRAINT [WFAmountRecord_PK] PRIMARY KEY CLUSTERED 
(
	[WFAmountRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAmountRecordDetail](
	[WFAmountRecordDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFAmountRecordId] [int] NULL,
	[WFContractInfoId] [int] NULL,
	[ObjectId] [int] NULL,
	[SettleCurrencyPresentValue] [decimal](18, 8) NULL,
	[SettleCurrencyFutureValue] [decimal](18, 8) NULL,
	[WholeAmountDetailUid] [uniqueidentifier] NULL,
	[ObjectType] [int] NULL,
	[ObjectCurrencyId] [int] NULL,
	[ExchangeRateId] [int] NULL,
	[TempExchangeRateId] [int] NULL,
	[ObjectCurrencyDiscount]  AS ([SettleCurrencyFutureValue]-[SettleCurrencyPresentValue]),
	[ObjectAmountIncludeDiscount] [bit] NOT NULL,
	[SapAmountTransaction] [int] NULL,
 CONSTRAINT [WFAmountRecordDetail_PK] PRIMARY KEY CLUSTERED 
(
	[WFAmountRecordDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAmountRecordSubDetail](
	[WFAmountRecordSubDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFAmountRecordDetailId] [int] NULL,
	[SubDetailType] [int] NULL,
	[ObjectType] [int] NULL,
	[ObjectId] [int] NULL,
	[ObjectCurrencyId] [int] NULL,
	[ObjectCurrencyFutureValue] [decimal](18, 8) NULL,
	[SapAmountTransaction] [int] NULL,
 CONSTRAINT [PK_WFAMOUNTRECORDSUBDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFAmountRecordSubDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFApprovalAttachment](
	[WFApprovalAttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[WFActualApprovalWFId] [int] NULL,
	[AttachmentId] [int] NULL,
	[IsMainContent] [bit] NULL,
 CONSTRAINT [PK_WFAPPROVALATTACHMENT] PRIMARY KEY CLUSTERED 
(
	[WFApprovalAttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFApprovalCancellationForm](
	[WFApprovalCancellationFormId] [int] IDENTITY(1,1) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
	[CreatorId] [int] NULL,
	[ApprovalStatus] [int] NULL,
	[AutomationType] [int] NOT NULL,
	[OriginFlowId] [int] NOT NULL,
	[Title] [nvarchar](100) NULL,
	[Note] [nvarchar](1000) NULL,
	[OriginFlowType] [int] NULL,
	[OriginFlowIsOtherForm] [bit] NOT NULL,
	[OriginFlowObjectId] [int] NULL,
	[ObjectCorporationId] [int] NULL,
	[ObjectTradeType] [int] NULL,
 CONSTRAINT [PK_WFAPPROVALCANCELLATIONFORM] PRIMARY KEY CLUSTERED 
(
	[WFApprovalCancellationFormId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFApprovalConfiguration](
	[WFApprovalConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[WFCommodityId] [int] NULL,
	[DepartmentId] [int] NULL,
	[CorporationId] [int] NULL,
	[TradeType] [smallint] NULL,
	[BillType] [int] NULL,
	[Priority] [smallint] NOT NULL,
	[AllowApproval] [bit] NOT NULL,
	[WFConditionId] [int] NULL,
	[Note] [nvarchar](200) NULL,
 CONSTRAINT [PK_WFAPPROVALCONFIGURATION] PRIMARY KEY CLUSTERED 
(
	[WFApprovalConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFApprovalWorkflowLog](
	[WFApprovalWorkflowLogId] [int] IDENTITY(1,1) NOT NULL,
	[ActualApprovalWFId] [int] NULL,
	[WFActualApprovalStepId] [int] NULL,
	[Time] [datetime] NULL,
	[UserId] [int] NULL,
	[Note] [nvarchar](500) NULL,
	[ApprovalAction] [int] NULL,
	[Result] [smallint] NULL,
	[Receiver] [int] NULL,
	[PreviousActionId] [int] NULL,
 CONSTRAINT [PK_WFAPPROVALWORKFLOWLOG] PRIMARY KEY CLUSTERED 
(
	[WFApprovalWorkflowLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFApprovalWorkflowStepTemplate](
	[WFApprovalWorkflowStepTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[WFApproverTemplateId] [int] NULL,
	[WFApprovalWorkflowTemplateId] [int] NULL,
	[StepIndex] [int] NULL,
	[StepType] [smallint] NULL,
	[Name] [nvarchar](50) NULL,
	[Note] [nvarchar](200) NULL,
 CONSTRAINT [PK_WFAPPROVALWORKFLOWSTEPTEMPL] PRIMARY KEY CLUSTERED 
(
	[WFApprovalWorkflowStepTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFApprovalWorkflowTemplate](
	[WFApprovalWorkflowTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Note] [nvarchar](500) NULL,
	[IsDeleted] [bit] NOT NULL,
	[WorkflowType] [int] NULL,
 CONSTRAINT [PK_WFAPPROVALWORKFLOWTEMPLATE] PRIMARY KEY CLUSTERED 
(
	[WFApprovalWorkflowTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFApprovalWorkflowTemplateRole](
	[WFApproverTemplateId] [int] NULL,
	[WFApprovalWorkflowTemplateId] [int] NULL,
	[WFApprovalWorkflowTemplateRoleId] [int] IDENTITY(1,1) NOT NULL,
	[UserType] [smallint] NULL,
 CONSTRAINT [PK_WFAPPROVALUSER] PRIMARY KEY CLUSTERED 
(
	[WFApprovalWorkflowTemplateRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFApproverTemplate](
	[WFApproverTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[ApproverType] [smallint] NULL,
	[Name] [nvarchar](100) NULL,
	[Note] [nvarchar](500) NULL,
 CONSTRAINT [PK_WFAPPROVERTEMPLATE] PRIMARY KEY CLUSTERED 
(
	[WFApproverTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAuthorization](
	[WFAuthorizationId] [int] IDENTITY(1,1) NOT NULL,
	[AuthorizerId] [int] NOT NULL,
	[AuthorizeeId] [int] NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[IsValid] [bit] NOT NULL,
	[Type] [smallint] NULL,
	[CreatTime] [datetime] NULL,
	[Note] [nvarchar](500) NULL,
 CONSTRAINT [PK_WFAUTHORIZATION] PRIMARY KEY CLUSTERED 
(
	[WFAuthorizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAuthorizationContent](
	[WFAuthorizationContentId] [int] IDENTITY(1,1) NOT NULL,
	[WFAuthorizationId] [int] NULL,
	[ObjectId] [int] NOT NULL,
	[ObjectType] [smallint] NOT NULL,
 CONSTRAINT [PK_WFAUTHORIZATIONCONTENT] PRIMARY KEY CLUSTERED 
(
	[WFAuthorizationContentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFAvgPriceDetail](
	[WFPriceDetailId] [int] NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[PriceCalculateType] [int] NULL,
	[PriceMarket] [int] NULL,
	[DayCount] [int] NULL,
	[SettlementPriceType] [int] NULL,
	[ContinuousInstrument] [int] NULL,
	[InstrumentCategoryId] [int] NULL,
	[FinalPriceCalculateType] [int] NULL,
 CONSTRAINT [PK_WFAVGPRICEDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFPriceDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFBillContentArchive](
	[WFBillContentArchiveId] [int] IDENTITY(1,1) NOT NULL,
	[BillType] [int] NOT NULL,
	[BillContent] [nvarchar](max) NULL,
	[BillId] [int] NULL,
	[BillContentType] [smallint] NOT NULL,
	[WFBillTemplateId] [int] NULL,
	[LastManipulateTime] [datetime] NULL,
 CONSTRAINT [PK_WFBILLCONTENTARCHIVE] PRIMARY KEY CLUSTERED 
(
	[WFBillContentArchiveId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFBillContentPrint](
	[WFBillContentPrintId] [int] IDENTITY(1,1) NOT NULL,
	[WFBillContentArchiveId] [int] NULL,
	[PrintTime] [datetime] NOT NULL,
	[UserId] [int] NULL,
	[IsUnrestricted] [bit] NOT NULL,
 CONSTRAINT [PK_WFBillContentPrint] PRIMARY KEY CLUSTERED 
(
	[WFBillContentPrintId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFBillTemplate](
	[WFBillTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[HTMLContent] [nvarchar](max) NULL,
	[Note] [nvarchar](1000) NULL,
	[TemplateType] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[TemplateFile] [nvarchar](500) NULL,
	[TemplateFileType] [int] NOT NULL,
	[PrintCountCap] [int] NULL,
 CONSTRAINT [WFContractTemplate_PK] PRIMARY KEY CLUSTERED 
(
	[WFBillTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFBillTemplate] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFBrand](
	[WFBrandId] [int] IDENTITY(1,1) NOT NULL,
	[WFCommodityId] [int] NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
	[EnglishName] [nvarchar](50) NULL,
	[Origin] [nvarchar](50) NULL,
	[SAPEigenvalue] [nvarchar](50) NULL,
 CONSTRAINT [WFBrand_PK] PRIMARY KEY CLUSTERED 
(
	[WFBrandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFBusiness](
	[WFBusinessId] [int] IDENTITY(1,1) NOT NULL,
	[WFCommodityId] [int] NULL,
	[DepartmentId] [int] NULL,
	[CorporationId] [int] NULL,
	[TradeType] [smallint] NULL,
	[IsDisabled] [bit] NOT NULL,
 CONSTRAINT [PK_WFCOMMODITYACCOUNTENTITY] PRIMARY KEY CLUSTERED 
(
	[WFBusinessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFBusinessBillTemplate](
	[WFBusinessBillTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[WFBillTemplateId] [int] NULL,
	[WFConditionId] [int] NULL,
	[CommodityId] [int] NULL,
	[DepartmentId] [int] NULL,
	[CorporationId] [int] NULL,
	[TradeType] [int] NULL,
	[AttachmentObjectType] [int] NULL,
 CONSTRAINT [PK_WFBUSINESSBILLTEMPLATE] PRIMARY KEY CLUSTERED 
(
	[WFBusinessBillTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFBuyContractTradeRecord](
	[WFBuyContractTradeRecordId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractEntryRecordDetailId] [int] NULL,
	[WFContractDetailInfoId] [int] NULL,
	[ActualWeight] [decimal](18, 8) NULL,
	[UnitId] [int] NOT NULL,
	[Price] [decimal](18, 8) NULL,
	[CurrencyId] [int] NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[BasePrice] [decimal](18, 8) NULL,
	[PremiumDiscount] [decimal](18, 8) NULL,
	[WFFirePriceRecordId] [int] NULL,
	[WFFinalPriceId] [int] NULL,
 CONSTRAINT [PK_WFBUYCONTRACTTRADERECORD] PRIMARY KEY CLUSTERED 
(
	[WFBuyContractTradeRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCardCodeInfo](
	[WFCardCodeInfoId] [int] IDENTITY(1,1) NOT NULL,
	[WarehouseId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[CorporationId] [int] NOT NULL,
	[CardCode] [nvarchar](50) NULL,
	[CreateTime] [datetime] NOT NULL,
	[Used] [bit] NOT NULL,
	[Note] [nvarchar](500) NULL,
 CONSTRAINT [PK_WFCARDCODEINFO] PRIMARY KEY CLUSTERED 
(
	[WFCardCodeInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCargoInseparabilityConfiguration](
	[WFCargoInseparabilityConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[InventoryStorageType] [int] NOT NULL,
	[CommodityId] [int] NULL,
	[TradeType] [int] NOT NULL,
	[CargoInseparability] [smallint] NOT NULL,
	[Priority] [smallint] NOT NULL,
	[Note] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFCARGOINSEPARABILITYCONFIG] PRIMARY KEY CLUSTERED 
(
	[WFCargoInseparabilityConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCarry](
	[WFCarryId] [int] IDENTITY(1,1) NOT NULL,
	[ToObjectId] [int] NOT NULL,
	[ToObjectType] [int] NOT NULL,
	[ToAmount] [decimal](18, 8) NOT NULL,
	[ToCurrencyId] [int] NOT NULL,
	[FromObjectId] [int] NOT NULL,
	[FromObjectType] [int] NOT NULL,
	[FromAmount] [decimal](18, 8) NOT NULL,
	[FromCurrencyId] [int] NOT NULL,
	[ExchangeRateId] [int] NULL,
	[CreateTime] [datetime] NOT NULL,
	[Creator] [int] NULL,
	[Notes] [nvarchar](1000) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CarryDate] [datetime] NULL,
 CONSTRAINT [PK_WFCARRY] PRIMARY KEY CLUSTERED 
(
	[WFCarryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCodeCustomization](
	[WFCodeCustomizationId] [int] IDENTITY(1,1) NOT NULL,
	[WFCodeTemplateDetailId] [int] NOT NULL,
	[Value] [nvarchar](200) NOT NULL,
	[Text] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFCODECUSTOMIZATION] PRIMARY KEY CLUSTERED 
(
	[WFCodeCustomizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCodeTemplate](
	[WFCodeTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[TemplateName] [nvarchar](50) NULL,
	[MaxGenLen] [int] NULL,
	[MinGenLen] [int] NULL,
	[Notes] [nvarchar](200) NULL,
 CONSTRAINT [PK_WFCODETEMPLATE] PRIMARY KEY CLUSTERED 
(
	[WFCodeTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCodeTemplateDetail](
	[WFCodeTemplateDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFCodeTemplateId] [int] NOT NULL,
	[OrderIndex] [int] NOT NULL,
	[EvalExp] [int] NOT NULL,
	[ConstValue] [nvarchar](50) NULL,
	[FormatString] [nvarchar](50) NULL,
	[MaxGenLen] [int] NULL,
	[MinGenLen] [int] NULL,
 CONSTRAINT [PK_WFCODETEMPLATEDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFCodeTemplateDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCommercialInvoice](
	[WFInvoiceRecordId] [int] NOT NULL,
	[FinalInvoiceRecordId] [int] NULL,
	[IsBalance] [bit] NOT NULL,
	[IsFinal] [bit] NOT NULL,
	[TotalGrossWeight] [decimal](18, 8) NULL,
	[TotalBundles] [int] NULL,
	[AvgPrice] [decimal](18, 8) NULL,
	[TotalHappendAmount] [decimal](18, 8) NULL,
	[BeneficiaryBankAccountId] [int] NULL,
	[CorrespondentBank] [int] NULL,
	[WFContractInfoId] [int] NULL,
	[FinalTotalAmount] [decimal](18, 8) NULL,
	[FinalDiscountCost] [decimal](18, 8) NULL,
	[TotalTempInvoicesHappendAmount] [decimal](18, 8) NULL,
	[ApprovalStatus] [smallint] NULL,
	[PaymentCurrencyId] [int] NULL,
	[PaymentCurrencyTotalAmount] [decimal](18, 8) NULL,
	[PaymentCurrencyAvgPrice] [decimal](18, 8) NULL,
	[PaymentExchangeRateId] [int] NULL,
	[HappenedWeight] [decimal](18, 8) NULL,
	[BusinessSetting] [int] NOT NULL,
 CONSTRAINT [PK_WFCOMMERCIALINVOICE] PRIMARY KEY CLUSTERED 
(
	[WFInvoiceRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCommodity](
	[WFCommodityId] [int] IDENTITY(1,1) NOT NULL,
	[WFCommodityTypeId] [int] NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
	[StorageType] [int] NULL,
	[OrderIndex] [int] NOT NULL,
	[EnglishName] [nvarchar](50) NULL,
	[MainQuantityId] [int] NULL,
	[SAPCode] [nvarchar](20) NULL,
	[DisplayName] [nvarchar](100) NULL,
	[SapDivision] [nvarchar](10) NULL,
	[SapDivisionNote] [nvarchar](10) NULL,
	[DefaultUnitId] [int] NULL,
	[AccountingName] [nvarchar](50) NULL,
 CONSTRAINT [WFCommodity_PK] PRIMARY KEY CLUSTERED 
(
	[WFCommodityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCommodityQuantityUnit](
	[WFCommodityQuantityUnitId] [int] IDENTITY(1,1) NOT NULL,
	[WFCommodityId] [int] NOT NULL,
	[WFUnitId] [int] NOT NULL,
	[WFQuantityTypeId] [int] NOT NULL,
	[IsMainQuantity] [bit] NOT NULL,
	[Scale] [smallint] NULL,
	[Priority] [smallint] NULL,
	[TradeType] [int] NULL,
 CONSTRAINT [PK_WFCommodityQuantityUnit] PRIMARY KEY CLUSTERED 
(
	[WFCommodityQuantityUnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCommodityType](
	[WFCommodityTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AccountingName] [nvarchar](50) NULL,
	[OrderIndex] [int] NOT NULL,
	[EnglishName] [nvarchar](50) NULL,
 CONSTRAINT [WFCommodityType_PK] PRIMARY KEY CLUSTERED 
(
	[WFCommodityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCompany](
	[WFCompanyId] [int] IDENTITY(1,1) NOT NULL,
	[ShortName] [nvarchar](100) NULL,
	[FullName] [nvarchar](100) NULL,
	[LegalRepresentative] [nvarchar](50) NULL,
	[NatureText] [nvarchar](50) NULL,
	[FoundDate] [datetime] NULL,
	[Telphone] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[TaxCode] [nvarchar](50) NULL,
	[OpenBillAddress] [nvarchar](100) NULL,
	[OpenBillTelphone] [nvarchar](50) NULL,
	[MailingAddress] [nvarchar](50) NULL,
	[PostCode] [nvarchar](50) NULL,
	[LinkMan] [nvarchar](50) NULL,
	[LinkPhone] [nvarchar](50) NULL,
	[MobilePhone] [nvarchar](50) NULL,
	[Note] [nvarchar](1000) NULL,
	[Type] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[Abbreviation] [nvarchar](50) NULL,
	[GroupId] [int] NULL,
	[CreditRatingModificationStatus] [smallint] NULL,
	[BuyWFCreditRatingId] [int] NULL,
	[SaleWFCreditRatingId] [int] NULL,
	[CorporationRank] [int] NULL,
	[EnglishFullName] [nvarchar](150) NULL,
	[EnglishShortName] [nvarchar](150) NULL,
	[EnglishOpenBillAddress] [nvarchar](100) NULL,
	[EnglishMailingAddress] [nvarchar](500) NULL,
	[IsDisabled] [bit] NOT NULL,
	[RegistCapital] [decimal](18, 6) NULL,
	[RegisteredCapitalCurrencyId] [int] NULL,
	[IsDomestic] [bit] NULL,
	[LockSettings] [int] NOT NULL,
	[MetaCompanyType] [int] NULL,
	[RelationCategory] [int] NULL,
	[AccountingName] [nvarchar](50) NULL,
 CONSTRAINT [WFCompany_PK] PRIMARY KEY CLUSTERED 
(
	[WFCompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCompanyBankInfo](
	[WFCompanyBankInfoId] [int] IDENTITY(1,1) NOT NULL,
	[WFCompanyId] [int] NULL,
	[BankName] [nvarchar](100) NULL,
	[BankAccount] [nvarchar](50) NULL,
	[Type] [int] NULL,
	[IsActive] [bit] NULL,
	[Address] [nvarchar](200) NULL,
	[IsDeleted] [bit] NOT NULL,
	[EnglishName] [nvarchar](100) NULL,
	[LegacyWarehouseBankInfoId] [int] NULL,
	[SwiftCode] [nvarchar](15) NULL,
	[IsDisabled] [bit] NOT NULL,
	[SAPCode] [nvarchar](10) NULL,
 CONSTRAINT [WFCompanyBankInfo_PK] PRIMARY KEY CLUSTERED 
(
	[WFCompanyBankInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCompanyBankInfoCommodityAccountEntity](
	[WFCompanyBankInfoCommodityAccountEntityId] [int] IDENTITY(1,1) NOT NULL,
	[WFCompanyBankInfoId] [int] NULL,
	[WFBusinessId] [int] NULL,
 CONSTRAINT [PK_WFCompanyBankInfoCommodityA] PRIMARY KEY CLUSTERED 
(
	[WFCompanyBankInfoCommodityAccountEntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCompanyBusiness](
	[WFCompanyBusinessId] [int] IDENTITY(1,1) NOT NULL,
	[WFCompanyId] [int] NULL,
	[WFBusinessId] [int] NULL,
	[InvoiceName] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFCOMPANYBUSINESS] PRIMARY KEY CLUSTERED 
(
	[WFCompanyBusinessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFCompanyBusiness] UNIQUE NONCLUSTERED 
(
	[WFCompanyId] ASC,
	[WFBusinessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCompanySAPCode](
	[WFCompanySAPCodeId] [int] IDENTITY(1,1) NOT NULL,
	[WFCompanyId] [int] NOT NULL,
	[SAPCode] [nvarchar](10) NULL,
	[SAPCodeType] [int] NOT NULL,
 CONSTRAINT [PK_WFCOMPANYSAPCODE] PRIMARY KEY CLUSTERED 
(
	[WFCompanySAPCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFCompanySAPCode] UNIQUE NONCLUSTERED 
(
	[WFCompanyId] ASC,
	[SAPCodeType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCondition](
	[WFConditionId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[ConditionType] [int] NOT NULL,
	[EvaluationType] [int] NOT NULL,
	[Expression] [nvarchar](1000) NULL,
	[Note] [nvarchar](1000) NULL,
	[ApprovalType] [int] NULL,
 CONSTRAINT [PK_WFCONDITION] PRIMARY KEY CLUSTERED 
(
	[WFConditionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFConditionProperty](
	[WFConditionPropertyId] [int] IDENTITY(1,1) NOT NULL,
	[ConditionType] [int] NULL,
	[ApprovalType] [int] NULL,
	[PropertyName] [nvarchar](100) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[SideType] [int] NOT NULL,
	[SupportDynamicValue] [bit] NOT NULL,
	[ValueType] [int] NOT NULL,
	[ValueRanges] [nvarchar](200) NOT NULL,
	[AvailableOperators] [int] NOT NULL,
 CONSTRAINT [PK_WFCONDITIONPROPERTY] PRIMARY KEY CLUSTERED 
(
	[WFConditionPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContact](
	[WFContactId] [int] IDENTITY(1,1) NOT NULL,
	[WFCompanyId] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[OpenBillAddress] [nvarchar](50) NULL,
	[OpenBillTelphone] [nvarchar](50) NULL,
	[LinkMan] [nvarchar](50) NULL,
	[LinkPhone] [nvarchar](50) NULL,
	[MobilePhone] [nvarchar](50) NULL,
	[PostCode] [nvarchar](50) NULL,
	[MailingAddress] [nvarchar](50) NULL,
	[Note] [nvarchar](1000) NULL,
	[Fax] [nvarchar](50) NULL,
	[IdCode] [nvarchar](18) NULL,
	[CarCode] [nvarchar](20) NULL,
	[ContactEnglishName] [nvarchar](50) NULL,
	[EnglishAddress] [nvarchar](100) NULL,
 CONSTRAINT [PK_WFCONTACT] PRIMARY KEY CLUSTERED 
(
	[WFContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContactCommodityAccountEntity](
	[WFContactCommodityAccountEntityId] [int] IDENTITY(1,1) NOT NULL,
	[WFContactId] [int] NULL,
	[WFBusinessId] [int] NULL,
 CONSTRAINT [PK_WFCONTACTCOMMODITYACCOUNTEN] PRIMARY KEY CLUSTERED 
(
	[WFContactCommodityAccountEntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractBillArchive](
	[WFContractBillArchiveId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Note] [nvarchar](1000) NULL,
	[IsDeleted] [bit] NOT NULL,
	[RelatedObjectId] [int] NULL,
	[ObjectType] [int] NULL,
	[CreateTime] [datetime] NULL,
	[Creator] [int] NULL,
	[ApprovalStatus] [smallint] NULL,
	[Amount] [decimal](18, 8) NULL,
	[Weight] [decimal](18, 8) NULL,
	[Saler] [int] NULL,
	[BillType] [smallint] NOT NULL,
 CONSTRAINT [WFContractBillArchive_PK] PRIMARY KEY CLUSTERED 
(
	[WFContractBillArchiveId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractBillArchiveDetail](
	[WFContractBillArchiveDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractBillArchiveId] [int] NULL,
	[FileName] [nvarchar](100) NULL,
	[FileSize] [int] NULL,
	[BillPath] [nvarchar](200) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_WFCONTRACTBILLARCHIVEDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFContractBillArchiveDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractBillArchiveLinker](
	[WFContractBillArchiveLinkerId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractInfoId] [int] NULL,
	[WFBillArchiveId] [int] NULL,
 CONSTRAINT [PK_WFCONTRACTBILLARCHIVELINKER] PRIMARY KEY CLUSTERED 
(
	[WFContractBillArchiveLinkerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractComment](
	[WFContractCommentId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractInfoId] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[Creator] [int] NULL,
	[CreateTime] [datetime] NULL,
	[LastModifyTime] [datetime] NULL,
 CONSTRAINT [WFContractComment_PK] PRIMARY KEY CLUSTERED 
(
	[WFContractCommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractCustomer](
	[WFContractCustomerId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractInfoId] [int] NULL,
	[CustomerId] [int] NULL,
	[StatusOfAmount] [int] NULL,
	[StatusOfInovice] [int] NULL,
	[StatusOfCommodity] [int] NULL,
	[Status] [int] NULL,
	[AmountHappened] [decimal](18, 8) NULL,
	[InvoiceHappened] [decimal](18, 8) NULL,
	[CommodityHappened] [decimal](18, 8) NULL,
	[UnitId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
 CONSTRAINT [WFContractCustomer_PK] PRIMARY KEY CLUSTERED 
(
	[WFContractCustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractDetailInfo](
	[WFContractDetailInfoId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractInfoId] [int] NULL,
	[BrandId] [int] NULL,
	[SpecificationId] [int] NULL,
	[DeliveryAddress] [nvarchar](200) NULL,
	[Price] [decimal](18, 8) NULL,
	[ActualPrice] [decimal](18, 8) NULL,
	[PremiumDiscount] [decimal](18, 8) NULL,
	[Weight] [decimal](18, 8) NULL,
	[ActualWeight] [decimal](18, 8) NULL,
	[CommodityHappened] [decimal](18, 8) NULL,
	[IsSpot] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[ExposureVolumne] [decimal](18, 8) NULL,
	[BasicGap] [decimal](18, 8) NULL,
	[WholeContractDetailUid] [uniqueidentifier] NULL,
	[WFPriceInfoId] [int] NULL,
	[CommodityApplied] [decimal](18, 8) NULL,
	[DeliveryWarehouseId] [int] NULL,
	[Notes] [nvarchar](200) NULL,
 CONSTRAINT [WFContractDetailInfo_PK] PRIMARY KEY CLUSTERED 
(
	[WFContractDetailInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractEntryRecordDetail](
	[WFContractEntryRecordDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractDetailInfoId] [int] NULL,
	[WFWarehouseEntryRecordDetailId] [int] NULL,
	[Volume] [decimal](18, 8) NULL,
	[Weight] [decimal](18, 8) NULL,
	[ActualWeight] [decimal](18, 8) NULL,
	[CreateTime] [datetime] NULL,
	[Creator] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[IsDeleted] [bit] NOT NULL,
	[ObjectId] [int] NULL,
	[ObjectType] [smallint] NULL,
	[GroupCode] [nvarchar](50) NULL,
	[WholeOutEntryDetailUid] [uniqueidentifier] NULL,
	[CurrencyId] [int] NULL,
	[Price] [decimal](18, 8) NULL,
	[ObjectUnitWeight] [decimal](18, 8) NULL,
	[AssignedNewFinancialBatchCode] [nvarchar](15) NULL,
 CONSTRAINT [WFContractEntryRecord_PK] PRIMARY KEY CLUSTERED 
(
	[WFContractEntryRecordDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractFee](
	[WFContractFeeId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractInfoId] [int] NULL,
	[WFFeeRecordId] [int] NULL,
	[WFSystemFeeId] [int] NULL,
	[Amount] [decimal](18, 8) NULL,
	[CommodityId] [int] NULL,
	[FeeName] [nvarchar](50) NULL,
	[CurrencyId] [int] NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[IsDeleted] [bit] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CustomerId] [int] NULL,
	[Price] [decimal](18, 8) NULL,
	[Weight] [decimal](18, 8) NULL,
	[CreateTime] [datetime] NULL,
	[CreatorId] [int] NULL,
	[IsAdjust] [bit] NOT NULL,
	[IsSystemAutoGenerate] [bit] NOT NULL,
	[FeeConfigurationId] [int] NULL,
	[WarehouseStorageId] [int] NULL,
	[HasPaid] [bit] NOT NULL,
	[FeeType] [int] NULL,
	[FinanceAccount] [int] NULL,
	[FinanceTime] [datetime] NULL,
	[Type] [smallint] NULL,
	[CorporationId] [int] NULL,
	[TradeType] [smallint] NOT NULL,
 CONSTRAINT [PK_WFCONTRACTFEE] PRIMARY KEY CLUSTERED 
(
	[WFContractFeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractFeeType](
	[WFContractFeeTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
 CONSTRAINT [WFContractFeeType_PK] PRIMARY KEY CLUSTERED 
(
	[WFContractFeeTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WFContractInfo](
	[WFContractInfoId] [int] IDENTITY(1,1) NOT NULL,
	[CorporationId] [int] NULL,
	[CustomerId] [int] NULL,
	[IsBuy] [bit] NOT NULL,
	[ContractType] [int] NULL,
	[CommodityId] [int] NULL,
	[SalerId] [int] NULL,
	[ExcutorId] [int] NULL,
	[AmountTotal] [decimal](18, 8) NULL,
	[AmountActualTotal] [decimal](18, 8) NULL,
	[ContractCode] [nvarchar](50) NULL,
	[WFLongContractId] [int] NULL,
	[WFDeliveryContractId] [int] NULL,
	[WFLongContractDetailId] [int] NULL,
	[InvoiceDate] [datetime] NULL,
	[StatusOfAmount] [int] NULL,
	[StatusOfCommodity] [int] NULL,
	[StatusOfInvoice] [int] NULL,
	[AmountHappened] [decimal](18, 8) NULL,
	[CommodityHappened] [decimal](18, 8) NULL,
	[InvoiceHappened] [decimal](18, 8) NULL,
	[StatusOfContract] [int] NULL,
	[CreateTime] [datetime] NULL,
	[Creator] [int] NULL,
	[LastModifyTime] [datetime] NULL,
	[Modifier] [int] NULL,
	[UnitId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[TradingPurpose] [nvarchar](50) NULL,
	[AccountingEntityId] [int] NULL,
	[SignDate] [date] NULL,
	[PayDate] [date] NULL,
	[NeedPayTransferFee] [bit] NOT NULL,
	[DeliveryType] [smallint] NULL,
	[ApprovalStatus] [smallint] NULL,
	[DepartmentId] [int] NULL,
	[TransactionType] [smallint] NOT NULL,
	[WFContractWholeId] [int] NULL,
	[TransactionSetting] [int] NULL,
	[AccountPeriod] [int] NOT NULL,
	[TradeType] [smallint] NOT NULL,
	[WFPriceInfoId] [int] NULL,
	[PriceMakingType] [int] NULL,
	[WFSettleOptionId] [int] NULL,
	[ParentId] [int] NULL,
	[TradePattern] [smallint] NULL,
	[IsAmountIncludeDiscountCost] [bit] NOT NULL,
	[DiscountCost] [decimal](18, 8) NULL,
	[Weight] [decimal](18, 8) NULL,
	[ApplyingPaymentAmount] [decimal](18, 8) NULL,
	[InvoiceApplied] [decimal](18, 8) NULL,
	[CompanyBankInfoId] [int] NULL,
	[IsSystemGenerate] [bit] NOT NULL,
	[ContractMapType] [int] NOT NULL,
	[DeliveryDate] [datetime] NULL,
	[CommodityApplied] [decimal](18, 8) NULL,
	[SapConfTaxCodeId] [int] NULL,
	[InvoiceCompletedDate] [datetime] NULL,
	[CommodityCompletedDate] [datetime] NULL,
	[PriceCompletedDate] [datetime] NULL,
	[AmountCompletedDate] [datetime] NULL,
	[ContractCompletedDate] [datetime] NULL,
	[SpecialTradeType] [int] NULL,
	[PriceToleranceRatio] [decimal](18, 17) NULL,
	[CargoToleranceRatio] [decimal](18, 17) NULL,
	[CargoPriceMatchStatus] [int] NULL,
	[IsAllPriceCompleted] [bit] NOT NULL,
	[MoneyCargoToleranceAmount] [decimal](18, 8) NULL,
	[IsReturn] [bit] NOT NULL,
	[IsPurchase]  AS ([IsReturn]^[IsBuy]) PERSISTED NOT NULL,
	[Direction]  AS ([IsReturn]*(2)|([IsReturn]^[IsBuy])) PERSISTED NOT NULL,
	[PurposeType] [int] NULL,
	[IsSealed] [bit] NULL,
	[AgreementDate] [date] NULL,
 CONSTRAINT [WFContractInfo_PK] PRIMARY KEY CLUSTERED 
(
	[WFContractInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractInvoice](
	[WFContractInvoiceId] [int] IDENTITY(1,1) NOT NULL,
	[WFInvoiceRecordId] [int] NULL,
	[WFContractDetailInfoId] [int] NULL,
	[SpecificationId] [int] NULL,
	[Weight] [decimal](18, 8) NULL,
	[Price] [decimal](18, 8) NULL,
	[Amount] [decimal](18, 8) NULL,
	[Note] [nvarchar](1000) NULL,
	[IsFinished] [bit] NOT NULL,
	[TaxRate] [decimal](18, 8) NULL,
	[Taxation] [decimal](18, 8) NULL,
	[BrandId] [int] NULL,
	[ObjectType] [int] NULL,
	[ObjectId] [int] NULL,
	[Status] [int] NULL,
	[HappendAmount] [decimal](18, 8) NULL,
	[GrossWeight] [decimal](18, 8) NULL,
	[Bundles] [int] NULL,
	[FinalPrice] [decimal](18, 8) NULL,
	[FinalWeight] [decimal](18, 8) NULL,
	[WholeInvoiceDetailUid] [uniqueidentifier] NULL,
	[FinalAmount] [decimal](18, 8) NULL,
 CONSTRAINT [WFContractInvoice_PK] PRIMARY KEY CLUSTERED 
(
	[WFContractInvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractLog](
	[WFContractLogId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractInfoId] [int] NULL,
	[ActorId] [int] NULL,
	[Action] [nvarchar](100) NULL,
	[ActionTime] [datetime] NULL,
	[Note] [nvarchar](1000) NULL,
 CONSTRAINT [PK_WFCONTRACTLOG] PRIMARY KEY CLUSTERED 
(
	[WFContractLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractMultiplier](
	[ContractMultiplierId] [int] IDENTITY(1,1) NOT NULL,
	[ExchangeId] [int] NOT NULL,
	[CommodityTypeId] [int] NULL,
	[Volumne] [decimal](18, 8) NULL,
	[Note] [nvarchar](1000) NULL,
	[UnitId] [int] NOT NULL,
 CONSTRAINT [PK_WFCONTRACTMULTIPLIER] PRIMARY KEY CLUSTERED 
(
	[ContractMultiplierId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractOutRecordDetail](
	[WFContractOutRecordDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractDetailInfoId] [int] NULL,
	[WFWarehouseOutRecordDetailId] [int] NULL,
	[Volume] [int] NULL,
	[Weight] [decimal](18, 8) NULL,
	[ActualWeight] [decimal](18, 8) NULL,
	[Note] [nvarchar](1000) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsClearUp] [bit] NOT NULL,
	[ObjectId] [int] NULL,
	[ObjectType] [smallint] NULL,
	[WholeOutEntryDetailUid] [uniqueidentifier] NULL,
	[CurrencyId] [int] NULL,
	[Price] [decimal](18, 8) NULL,
	[ObjectUnitWeight] [decimal](18, 8) NULL,
	[AssignedNewFinancialBatchCode] [nvarchar](15) NULL,
	[GroupIdentity] [uniqueidentifier] NULL,
 CONSTRAINT [WFContractOutRecord_PK] PRIMARY KEY CLUSTERED 
(
	[WFContractOutRecordDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractSecondPart](
	[WFContractInfoId] [int] NOT NULL,
	[DailySumAmount] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFCONTRACTSECONDPART] PRIMARY KEY CLUSTERED 
(
	[WFContractInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFContractWhole](
	[WFContractWholeId] [int] IDENTITY(1,1) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[TransactionType] [smallint] NOT NULL,
	[ContractType] [int] NOT NULL,
	[TransactionSetting] [int] NOT NULL,
	[SellCorporationId] [int] NULL,
	[BuyCorporationId] [int] NULL,
	[SellContractCode] [nvarchar](50) NULL,
	[BuyContractCode] [nvarchar](50) NULL,
	[SellDepartmentId] [int] NULL,
	[BuyDepartmentId] [int] NULL,
	[SellAccountingEntityId] [int] NULL,
	[BuyAccountingEntityId] [int] NULL,
	[SellSalerId] [int] NULL,
	[BuySalerId] [int] NULL,
	[SellCommodityId] [int] NULL,
	[BuyCommodityId] [int] NULL,
 CONSTRAINT [PK_WFCONTRACTWHOLE] PRIMARY KEY CLUSTERED 
(
	[WFContractWholeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCorporationApprovalWFTemplate](
	[WFCorporationApprovalWFTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[WFCompanyId] [int] NULL,
	[WFApprovalWorkflowTemplateId] [int] NOT NULL,
	[ApprovalType] [int] NOT NULL,
	[CommodityId] [int] NULL,
	[BusinessDepartmentId] [int] NULL,
	[RequestDepartmentId] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[IsDeleted] [bit] NOT NULL,
	[WFConditionId] [int] NULL,
	[TradeType] [int] NULL,
	[Priority] [int] NOT NULL,
 CONSTRAINT [PK_WFCORPORATIONAPPROVALWFTEMP] PRIMARY KEY CLUSTERED 
(
	[WFCorporationApprovalWFTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCorporationDepartment](
	[WFCorporationDepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[WFAccountEntityId] [int] NULL,
	[CorporationId] [int] NULL,
	[Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFCORPORATIONDEPARTMENT] PRIMARY KEY CLUSTERED 
(
	[WFCorporationDepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCorporationTypeConfiguration](
	[WFCorporationTypeConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[WFCompanyId] [int] NULL,
	[CorporationType] [int] NULL,
	[IsDisabled] [bit] NOT NULL,
 CONSTRAINT [PK_WFCORPORATIONTYPECONFIGURAT] PRIMARY KEY CLUSTERED 
(
	[WFCorporationTypeConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCorporationTypeFinancing](
	[WFCorporationTypeConfigurationId] [int] NOT NULL,
	[PledgeInterestRate] [decimal](18, 8) NULL,
	[PledgeProportion] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFCORPORATIONTYPEFINANCING] PRIMARY KEY CLUSTERED 
(
	[WFCorporationTypeConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCorporationTypeMarket](
	[WFCorporationTypeConfigurationId] [int] NOT NULL,
	[MarketType] [int] NULL,
 CONSTRAINT [PK_WFCORPORATIONTYPEMARKET] PRIMARY KEY CLUSTERED 
(
	[WFCorporationTypeConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCostPayRecord](
	[WFCostPayRecordId] [int] IDENTITY(1,1) NOT NULL,
	[WFCostPayRequestId] [int] NULL,
	[CorporationId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[PayType] [int] NOT NULL,
	[Amount] [decimal](18, 8) NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[CompanyBankInfoId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[PayPurpose] [nvarchar](100) NULL,
	[PayReceiveDate] [datetime] NOT NULL,
	[CommodityId] [int] NOT NULL,
	[Creator] [int] NULL,
	[AccountingEntityId] [int] NOT NULL,
	[CostType] [int] NOT NULL,
	[LastModifyDate] [datetime] NULL,
	[TradeType] [smallint] NOT NULL,
 CONSTRAINT [PK_WFCOSTPAYRECORD] PRIMARY KEY CLUSTERED 
(
	[WFCostPayRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCostPayRequest](
	[WFCostPayRequestId] [int] IDENTITY(1,1) NOT NULL,
	[PayCustomerId] [int] NOT NULL,
	[CorporationId] [int] NOT NULL,
	[CompanyBankInfoId] [int] NOT NULL,
	[PayPurpose] [nvarchar](50) NULL,
	[Amount] [decimal](18, 8) NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[RequestorId] [int] NOT NULL,
	[RequestTime] [datetime] NOT NULL,
	[PayType] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[CommodityId] [int] NOT NULL,
	[AccountingEntityId] [int] NOT NULL,
	[CostType] [int] NOT NULL,
	[TradeType] [smallint] NOT NULL,
 CONSTRAINT [PK_WFCOSTPAYREQUEST] PRIMARY KEY CLUSTERED 
(
	[WFCostPayRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCostPrice](
	[WFCostPriceId] [int] NOT NULL,
	[WFBuyContractTradeRecordId] [int] NULL,
	[WFSaleContractTradeRecordId] [int] NULL,
	[Weight] [decimal](18, 8) NULL,
	[UnitId] [int] NOT NULL,
 CONSTRAINT [PK_WFCOSTPRICE] PRIMARY KEY CLUSTERED 
(
	[WFCostPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCreditRating](
	[WFCreditRatingId] [int] IDENTITY(1,1) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[AmountQuota] [decimal](18, 8) NULL,
	[QuantityQuota] [decimal](18, 8) NULL,
	[IsBuy] [bit] NOT NULL,
	[IsTradeAllowed] [bit] NULL,
 CONSTRAINT [PK_WFCREDITRATING] PRIMARY KEY CLUSTERED 
(
	[WFCreditRatingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCreditRatingDetail](
	[WFCreditRatingDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFCreditRatingId] [int] NULL,
	[WFCommodityId] [int] NULL,
	[CreditRatingDetailType] [smallint] NOT NULL,
	[AmountQuota] [decimal](18, 8) NULL,
	[QuantityQuota] [decimal](18, 8) NULL,
	[Note] [nvarchar](1000) NULL,
	[IsTradeAllowed] [bit] NULL,
 CONSTRAINT [PK_WFCREDITRATINGDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFCreditRatingDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCurrency](
	[WFCurrencyId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
	[EnglishName] [nvarchar](50) NULL,
	[Symbol] [nvarchar](20) NULL,
	[TradingFlag] [int] NULL,
	[DomesticIndex] [int] NULL,
	[InterIndex] [int] NULL,
	[ShortName] [nvarchar](50) NULL,
	[Scale] [smallint] NULL,
	[AccountingName] [nvarchar](50) NULL,
 CONSTRAINT [WFCurrency_PK] PRIMARY KEY CLUSTERED 
(
	[WFCurrencyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCurrencyPair](
	[WFCurrencyPairId] [int] IDENTITY(1,1) NOT NULL,
	[BaseCurrencyId] [int] NOT NULL,
	[CounterCurrencyId] [int] NOT NULL,
 CONSTRAINT [PK_WFCURRENCYPAIR] PRIMARY KEY CLUSTERED 
(
	[WFCurrencyPairId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFCurrencyPair] UNIQUE NONCLUSTERED 
(
	[BaseCurrencyId] ASC,
	[CounterCurrencyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFCustomerCommodity](
	[WFCompanyId] [int] NULL,
	[WFCommodityId] [int] NULL,
	[WFCustomerCommodityId] [int] IDENTITY(1,1) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[BuyWFCreditRatingId] [int] NULL,
	[SaleWFCreditRatingId] [int] NULL,
 CONSTRAINT [PK_WFCUSTOMERCOMMODITY] PRIMARY KEY CLUSTERED 
(
	[WFCustomerCommodityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFDefaultExchangeSetting](
	[WFDefaultExchangeSettingId] [int] IDENTITY(1,1) NOT NULL,
	[WFCurrencyPairId] [int] NULL,
	[DatasourceType] [int] NOT NULL,
	[DatasourceId] [int] NULL,
	[DefaultBaseUnitAmount] [decimal](18, 8) NOT NULL,
 CONSTRAINT [PK_WFDEFAULTEXCHANGESETTING] PRIMARY KEY CLUSTERED 
(
	[WFDefaultExchangeSettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFDeliveryContract](
	[WFDeliveryContractId] [int] IDENTITY(1,1) NOT NULL,
	[InstrumentId] [int] NULL,
	[ExchangeId] [int] NULL,
	[IsStandard] [bit] NOT NULL,
	[DeliveryDate] [datetime] NULL,
 CONSTRAINT [WFDeliveryContract_PK] PRIMARY KEY CLUSTERED 
(
	[WFDeliveryContractId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFDeliveryNotification](
	[WFDeliveryNotificationId] [int] IDENTITY(1,1) NOT NULL,
	[IsReceive] [bit] NULL,
	[DeliveryNotificationType] [int] NULL,
	[InventoryStorageType] [int] NULL,
	[CommodityId] [int] NULL,
	[CorporationId] [int] NULL,
	[AccountingEntityId] [int] NULL,
	[CustomerId] [int] NULL,
	[TradeType] [int] NULL,
	[BillTime] [datetime] NULL,
	[ExpectedActualDate] [datetime] NULL,
	[UnitId] [int] NULL,
	[WarehouseOutEntryType] [int] NULL,
	[DeliveryType] [int] NULL,
	[IsCompleted] [int] NULL,
	[Note] [nvarchar](200) NULL,
	[ReceiverName] [nvarchar](20) NULL,
	[ReceiverCarNumber] [nvarchar](20) NULL,
	[IdCode] [nvarchar](20) NULL,
	[SourceInventory] [nvarchar](100) NULL,
	[IsPledge] [bit] NULL,
	[WholeDeliveryNotificationUid] [uniqueidentifier] NULL,
	[DeliveryNotificationCode] [nvarchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
	[WarehouseId] [int] NULL,
	[CreateTime] [datetime] NULL,
	[DetailObjectType] [int] NULL,
	[ApprovalStatus] [smallint] NULL,
	[Creator] [int] NULL,
	[DepartmentId] [int] NULL,
	[SapShippingType] [int] NULL,
	[VerifyStatus] [int] NOT NULL,
	[IsPrePicking] [bit] NOT NULL,
	[PlaceOfIssue] [nvarchar](50) NULL,
	[PlaceOfDelivery] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFDeliveryNotification] PRIMARY KEY CLUSTERED 
(
	[WFDeliveryNotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFDeliveryNotification] UNIQUE NONCLUSTERED 
(
	[DeliveryNotificationCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFDeliveryNotificationDetail](
	[WFDeliveryNotificationDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFDeliveryNotificationId] [int] NULL,
	[BrandId] [int] NULL,
	[SpecificationId] [int] NULL,
	[Weight] [decimal](18, 4) NULL,
	[SAPCode] [nvarchar](20) NULL,
	[GroupCode] [nvarchar](20) NULL,
	[StorageCode] [nvarchar](20) NULL,
	[WholeDeliveryNotificationDetailUid] [uniqueidentifier] NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreateTime] [datetime] NULL,
	[Notes] [nvarchar](200) NULL,
 CONSTRAINT [PK_WFDeliveryNotificationDetail] PRIMARY KEY CLUSTERED 
(
	[WFDeliveryNotificationDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFDeliveryNotificationObject](
	[WFDeliveryNotificationObjectId] [int] IDENTITY(1,1) NOT NULL,
	[WFDeliveryNotificationDetailId] [int] NULL,
	[ObjectType] [int] NULL,
	[ObjectId] [int] NULL,
 CONSTRAINT [PK_WFDeliveryNotificationObject] PRIMARY KEY CLUSTERED 
(
	[WFDeliveryNotificationObjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFDepartmentAccountEntity](
	[DepartmentId] [int] NOT NULL,
	[AccountEntityId] [int] NOT NULL,
	[WFDepartmentAccountEntityId] [int] IDENTITY(1,1) NOT NULL,
	[SAPCode] [nvarchar](10) NULL,
 CONSTRAINT [PK_WFDEPARTMENTACCOUNTENTITY] PRIMARY KEY CLUSTERED 
(
	[WFDepartmentAccountEntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFDeposit](
	[WFDepositId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[DepositType] [int] NOT NULL,
	[IsPay] [bit] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[Notes] [nvarchar](1000) NULL,
	[Amount] [decimal](18, 8) NOT NULL,
	[AmountHappened] [decimal](18, 8) NOT NULL,
	[AmountReturned] [decimal](18, 8) NOT NULL,
	[AmountSettled] [decimal](18, 8) NOT NULL,
	[AmountRemained]  AS (([AmountHappened]-[AmountReturned])-[AmountSettled]),
	[IsDeleted] [bit] NOT NULL,
	[DepartmentId] [int] NULL,
	[Saler] [int] NULL,
	[Creator] [int] NULL,
	[CreatedTime] [datetime] NOT NULL,
	[ModifiedTime] [datetime] NOT NULL,
	[CorporationId] [int] NULL,
	[TradeType] [int] NOT NULL,
	[AccountingEntityId] [int] NULL,
	[CommodityId] [int] NULL,
	[MigrateFromWFAmountRecordId] [int] NULL,
 CONSTRAINT [PK_WFDEPOSIT] PRIMARY KEY CLUSTERED 
(
	[WFDepositId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFDepositContract](
	[WFDepositContractId] [int] IDENTITY(1,1) NOT NULL,
	[WFDepositId] [int] NOT NULL,
	[ObjectType] [int] NULL,
	[ObjectId] [int] NULL,
	[Amount] [decimal](18, 8) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_WFDEPOSITCONTRACT] PRIMARY KEY CLUSTERED 
(
	[WFDepositContractId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFEntityProperty](
	[WFEntityPropertyId] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[EntityPropertyValue] [nvarchar](100) NULL,
	[WFEntityPropertyTypeId] [int] NOT NULL,
 CONSTRAINT [PK_WFEntityProperty] PRIMARY KEY CLUSTERED 
(
	[WFEntityPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFEntityProperty] UNIQUE NONCLUSTERED 
(
	[WFEntityPropertyTypeId] ASC,
	[EntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFEntityPropertyType](
	[WFEntityPropertyTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EntityType] [int] NOT NULL,
	[PropertyName] [nvarchar](50) NULL,
	[IsBuiltIn] [bit] NOT NULL,
	[BuiltInKey] [int] NULL,
 CONSTRAINT [PK_WFENTITYPROPERTYTYPE] PRIMARY KEY CLUSTERED 
(
	[WFEntityPropertyTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFEntityPropertyType] UNIQUE NONCLUSTERED 
(
	[EntityType] ASC,
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFEntitySapPart](
	[WFEntitySapPartId] [int] IDENTITY(1,1) NOT NULL,
	[ObjectType] [smallint] NOT NULL,
	[ObjectId] [int] NULL,
	[CurrentSapTransactionId] [bigint] NULL,
	[TransactionObjectStatus] [smallint] NULL,
	[SapWriteOffCode] [nvarchar](50) NULL,
	[SapDocumentCode] [nvarchar](50) NULL,
	[SapDocumentYear] [int] NULL,
	[SapObdCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFENTITYSAPPART] PRIMARY KEY CLUSTERED 
(
	[WFEntitySapPartId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFEntitySapPart] UNIQUE NONCLUSTERED 
(
	[ObjectType] ASC,
	[ObjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFExchangeBill](
	[WFExchangeBillId] [int] IDENTITY(1,1) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[WFLetterOfCreditId] [int] NULL,
	[Type] [int] NOT NULL,
	[Code] [nvarchar](50) NULL,
	[CurrencyId] [int] NOT NULL,
	[Amount] [decimal](18, 8) NOT NULL,
	[IssueDate] [datetime] NULL,
	[DrawerId] [int] NULL,
	[DraweeId] [int] NULL,
	[PayeeId] [int] NULL,
	[HolderId] [int] NULL,
	[IsTransferable] [bit] NULL,
	[BillAmountUseStatus] [int] NOT NULL,
	[CorporationId] [int] NULL,
	[AccountingEntityId] [int] NULL,
	[Notes] [nvarchar](1000) NULL,
	[PurposeStatus] [smallint] NOT NULL,
	[BillUseStatus] [int] NOT NULL,
	[IsDrawer] [bit] NOT NULL,
	[IsRights] [bit] NOT NULL,
	[IsObligation] [bit] NOT NULL,
 CONSTRAINT [PK_WFEXCHANGEBILL] PRIMARY KEY CLUSTERED 
(
	[WFExchangeBillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFExchangeRate](
	[WFExchangeRateId] [int] IDENTITY(1,1) NOT NULL,
	[LastModifiedTime] [datetime] NOT NULL,
	[DatasourceType] [int] NOT NULL,
	[DatasourceId] [int] NULL,
	[PriceDate] [datetime] NOT NULL,
	[WFCurrencyPairId] [int] NOT NULL,
	[BaseUnitAmount] [decimal](18, 8) NOT NULL,
	[CounterAmount] [decimal](18, 8) NOT NULL,
 CONSTRAINT [PK_WFEXCHANGERATE] PRIMARY KEY CLUSTERED 
(
	[WFExchangeRateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFExportTradeRecord](
	[WFExportTradeRecordId] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [WFExportTradeRecord_PK] PRIMARY KEY CLUSTERED 
(
	[WFExportTradeRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFExportWarehouseStorage](
	[WFExportWarehouseStorageId] [int] NOT NULL,
 CONSTRAINT [WFExportWarehouseStorage_PK] PRIMARY KEY CLUSTERED 
(
	[WFExportWarehouseStorageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFFeeEstimate](
	[WFFeeEstimateId] [int] IDENTITY(1,1) NOT NULL,
	[ObjectType] [smallint] NULL,
	[ObjectId] [int] NULL,
	[SapConfFeeConditionTypeId] [int] NULL,
	[FeeConditionValue] [decimal](18, 8) NULL,
	[CurrencyId] [int] NULL,
	[FeeProviderId] [int] NULL,
	[Note] [nvarchar](50) NULL,
	[IsIncludedInPrice] [bit] NOT NULL,
	[IsActualFee] [bit] NOT NULL,
 CONSTRAINT [PK_WFFEEESTIMATE] PRIMARY KEY CLUSTERED 
(
	[WFFeeEstimateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFFeeRecord](
	[WFFeeRecordId] [int] IDENTITY(1,1) NOT NULL,
	[WFSystemFeeId] [int] NULL,
	[CommodityId] [int] NULL,
	[FeeName] [nvarchar](50) NULL,
	[Amount] [decimal](18, 8) NULL,
	[CurrencyId] [int] NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[IsDeleted] [bit] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CustomerId] [int] NULL,
	[Price] [decimal](18, 8) NULL,
	[Weight] [decimal](18, 8) NULL,
	[CreateTime] [datetime] NULL,
	[CreatorId] [int] NULL,
	[FeeConfigurationId] [int] NULL,
	[StorageId] [int] NULL,
	[HasPaid] [bit] NOT NULL,
	[FeeType] [int] NULL,
	[FinanceAccount] [int] NULL,
	[FinanceTime] [datetime] NULL,
	[CorporationId] [int] NULL,
	[InvoiceCode] [nvarchar](100) NULL,
	[TradeType] [smallint] NOT NULL,
 CONSTRAINT [WFContractFee_PK] PRIMARY KEY CLUSTERED 
(
	[WFFeeRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFFinalPrice](
	[WFFinalPriceId] [int] IDENTITY(1,1) NOT NULL,
	[WFPriceDetailId] [int] NULL,
	[Weight] [decimal](18, 8) NULL,
	[FinalExchangeRateId] [int] NULL,
	[PricingFinalPrice] [decimal](18, 8) NULL,
	[PricingFinalPremiumDiscount] [decimal](18, 8) NULL,
	[FinalPrice] [decimal](18, 8) NULL,
	[FinalPremiumDiscount] [decimal](18, 8) NULL,
	[IsAdjusted] [bit] NOT NULL,
	[ExchangeRateConfirmDate] [datetime] NULL,
 CONSTRAINT [PK_WFFINALPRICE] PRIMARY KEY CLUSTERED 
(
	[WFFinalPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFFinancialBatch](
	[WFFinancialBatchId] [int] IDENTITY(1,1) NOT NULL,
	[FinancialBatchCode] [nvarchar](15) NULL,
	[CreationSystem] [smallint] NULL,
	[PrecursorFinancialBatchId] [int] NULL,
	[CorporationId] [int] NULL,
	[AccountingEntityId] [int] NULL,
	[UnitId] [int] NULL,
	[CommodityId] [int] NULL,
	[BrandId] [int] NULL,
	[SpecificationId] [int] NULL,
	[InventoryStorageType] [smallint] NULL,
	[SavePlaceType] [smallint] NULL,
	[WarehouseId] [int] NULL,
	[ExchangeId] [int] NULL,
	[ObjectType] [int] NULL,
	[ObjectId] [int] NULL,
	[WarehouseEntryRecordId] [int] NULL,
	[InQuantity] [decimal](18, 8) NULL,
	[OutQuantity] [decimal](18, 8) NULL,
	[PostingWeight] [decimal](18, 8) NULL,
	[OutPostingWeight] [decimal](18, 8) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_WFFINANCIALBATCH] PRIMARY KEY CLUSTERED 
(
	[WFFinancialBatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFFinancialBatch] UNIQUE NONCLUSTERED 
(
	[FinancialBatchCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFFinancialBatchInventory](
	[WFFinancialBatchInventoryId] [int] IDENTITY(1,1) NOT NULL,
	[WFFinancialBatchId] [int] NULL,
	[WFWarehouseStorageId] [int] NULL,
	[Weight] [decimal](18, 8) NOT NULL,
	[IsBoundary] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeliveryDate] [datetime] NULL,
 CONSTRAINT [PK_WFFINANCIALBATCHINVENTORY] PRIMARY KEY CLUSTERED 
(
	[WFFinancialBatchInventoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFFinancialBatchInventory] UNIQUE NONCLUSTERED 
(
	[WFFinancialBatchId] ASC,
	[WFWarehouseStorageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFFinancialBatchOutDetail](
	[WFFinancialBatchOutDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFFinancialBatchId] [int] NULL,
	[WFWarehouseOutRecordDetailId] [int] NULL,
	[Weight] [decimal](18, 8) NOT NULL,
	[IsBoundary] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeliveryDate] [datetime] NULL,
	[WFContractOutRecordDetailId] [int] NULL,
 CONSTRAINT [PK_WFFINANCIALBATCHOUTDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFFinancialBatchOutDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFFinancialBatchOutDetail] UNIQUE NONCLUSTERED 
(
	[WFFinancialBatchId] ASC,
	[WFWarehouseOutRecordDetailId] ASC,
	[WFContractOutRecordDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFFirePriceConfirm](
	[WFFirePriceConfirmId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[Seller] [nvarchar](100) NULL,
	[Buyer] [nvarchar](100) NULL,
	[Title] [nvarchar](500) NULL,
	[Ending] [nvarchar](500) NULL,
	[ApprovalStatus] [smallint] NULL,
	[WFPriceDetailId] [int] NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [WFFirePriceConfirm_PK] PRIMARY KEY CLUSTERED 
(
	[WFFirePriceConfirmId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFFirePriceDetail](
	[WFPriceDetailId] [int] NOT NULL,
	[FireStartDate] [datetime] NULL,
	[FireEndDate] [datetime] NULL,
	[InstrumentId] [int] NULL,
	[IsFireCompleted] [bit] NOT NULL,
	[IsBuyerFire] [bit] NOT NULL,
	[PriceCalcType] [int] NULL,
	[PriceMarket] [int] NULL,
	[IsPostponed] [bit] NOT NULL,
	[MarginRate] [decimal](18, 8) NULL,
	[IsSwap] [bit] NOT NULL,
	[PricingType] [smallint] NOT NULL,
	[FinalPriceCalculateType] [int] NULL,
 CONSTRAINT [PK_WFFIREPRICEDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFPriceDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WFFirePricePostponeConfirm](
	[WFFirePricePostponeConfirmId] [int] IDENTITY(1,1) NOT NULL,
	[FromLastPricingDate] [datetime] NULL,
	[ToLastPricingDate] [datetime] NULL,
	[Weight] [decimal](18, 8) NULL,
	[Fee] [decimal](18, 8) NULL,
	[FromInstrument] [int] NULL,
	[ToInstrument] [int] NULL,
	[Note] [nvarchar](200) NULL,
	[IsDeleted] [bit] NOT NULL,
	[ApprovalStatus] [smallint] NULL,
	[Code] [varchar](50) NULL,
	[CurrencyId] [int] NOT NULL,
	[WFPriceDetailId] [int] NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_WFFIREPRICEPOSTPONECONFIRM] PRIMARY KEY CLUSTERED 
(
	[WFFirePricePostponeConfirmId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFFirePriceRecord](
	[WFFirePriceRecordId] [int] IDENTITY(1,1) NOT NULL,
	[WFFirePriceConfirmId] [int] NULL,
	[FireDate] [datetime] NULL,
	[Weight] [decimal](18, 8) NULL,
	[Price] [decimal](18, 8) NULL,
	[UnitId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[InstrumentId] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[IsConfirmed] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[PremiumDiscount] [decimal](18, 8) NULL,
	[SettlementPrice] [decimal](18, 8) NULL,
	[IsDefered] [bit] NOT NULL,
	[DeferedFee] [decimal](18, 8) NULL,
	[MarketId] [int] NULL,
	[HappenedMargin] [decimal](18, 8) NULL,
	[WFPriceDetailId] [int] NULL,
	[SwapFee] [decimal](18, 8) NULL,
	[PricingType] [smallint] NOT NULL,
	[MarketQuoteId] [int] NULL,
	[CargoUnitId] [int] NOT NULL,
	[LastManipulateTime] [datetime] NULL,
 CONSTRAINT [WFFirePriceRecord_PK] PRIMARY KEY CLUSTERED 
(
	[WFFirePriceRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFFutureTradeRecord](
	[WFFutureTradeRecordId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractDetailInfoId] [int] NULL,
	[ExchangeId] [int] NULL,
	[BrokerId] [int] NULL,
	[InstrumentId] [int] NULL,
	[Price] [decimal](18, 8) NULL,
	[Volume] [decimal](18, 8) NULL,
	[Weight] [decimal](18, 8) NULL,
	[Note] [nvarchar](1000) NULL,
	[FutureExcutorId] [int] NULL,
	[CreatedTime] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[UnitId] [int] NOT NULL,
	[CommodityId] [int] NULL,
 CONSTRAINT [PK_WFFUTURETRADERECORD] PRIMARY KEY CLUSTERED 
(
	[WFFutureTradeRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFGeneralModification](
	[WFGeneralModificationId] [int] IDENTITY(1,1) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Creator] [int] NULL,
	[CreateTime] [datetime] NULL,
	[Note] [nvarchar](1000) NULL,
	[ModificationType] [int] NOT NULL,
	[ObjectId] [int] NULL,
	[ApprovalStatus] [smallint] NULL,
	[Applied] [bit] NOT NULL,
	[ApplyTime] [datetime] NULL,
	[SalerId] [int] NULL,
 CONSTRAINT [PK_WFGENERALMODIFICATION] PRIMARY KEY CLUSTERED 
(
	[WFGeneralModificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFGeneralModificationDetail](
	[WFGeneralModificationDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFGeneralModificationId] [int] NULL,
	[TableType] [int] NOT NULL,
	[ObjectId] [int] NOT NULL,
	[ColumnName] [nvarchar](100) NOT NULL,
	[OldValue] [nvarchar](1000) NOT NULL,
	[OldDisplayValue] [nvarchar](1000) NULL,
	[NewValue] [nvarchar](1000) NOT NULL,
	[NewDisplayValue] [nvarchar](1000) NULL,
	[Note] [nvarchar](100) NULL,
 CONSTRAINT [PK_WFGENERALMODIFICATIONDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFGeneralModificationDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFInstrument](
	[WFInstrumentId] [int] IDENTITY(1,1) NOT NULL,
	[WFCommodityTypeId] [int] NULL,
	[InstrumentCode] [nvarchar](50) NULL,
	[ExchangeId] [int] NULL,
	[CurrentStartDate] [datetime] NULL,
	[LastTradingDay] [datetime] NULL,
	[InstrumentType] [smallint] NOT NULL,
	[CurrencyId] [int] NULL,
	[UnitId] [int] NULL,
	[WFInstrumentCategoryId] [int] NULL,
	[PromptDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_WFINSTRUMENT] PRIMARY KEY CLUSTERED 
(
	[WFInstrumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFInstrumentCategory](
	[WFInstrumentCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[MarketId] [int] NULL,
	[WFCommodityTypeId] [int] NULL,
	[WFCurrencyId] [int] NULL,
	[WFUnitId] [int] NULL,
	[InstrumentPeriodType] [int] NULL,
	[InstrumentCodeTmpl] [nvarchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Code] [nvarchar](50) NULL,
	[FinancialInstrumentType] [int] NULL,
 CONSTRAINT [PK_WFINSTRUMENTCATEGORY] PRIMARY KEY CLUSTERED 
(
	[WFInstrumentCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFInstrumentSettlementPrice](
	[WFInstrumentSettlementPriceId] [int] IDENTITY(1,1) NOT NULL,
	[InstrumentId] [int] NULL,
	[PriceDate] [datetime] NULL,
	[SettlementPrice] [decimal](18, 8) NULL,
	[TradeWeight] [decimal](18, 8) NULL,
	[PriceMarket] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[FullDaySettlementPrice] [decimal](18, 8) NULL,
	[FullDayTradeWeight] [decimal](18, 8) NULL,
	[CommodityId] [int] NULL,
	[LastUpdatedTime] [datetime] NULL,
	[MarketQuotePriceType] [int] NOT NULL,
	[FixingPrice] [decimal](18, 8) NULL,
	[CurrencyId] [int] NULL,
	[UnitId] [int] NULL,
	[PremiumDiscount] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFINSTRUMENTSETTLEMENTPRICE] PRIMARY KEY CLUSTERED 
(
	[WFInstrumentSettlementPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFInventoryAdjustmentRequest](
	[WFInventoryAdjustmentRequestId] [int] IDENTITY(1,1) NOT NULL,
	[WarehouseId] [int] NOT NULL,
	[CommodityId] [int] NOT NULL,
	[CorporationId] [int] NOT NULL,
	[AccountingEntityId] [int] NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[SalerId] [int] NOT NULL,
	[InventoryStorageType] [int] NOT NULL,
	[Weight] [decimal](18, 8) NULL,
	[UnitId] [int] NOT NULL,
	[AdjustmentType] [int] NOT NULL,
	[Reason] [nvarchar](100) NOT NULL,
	[Note] [nvarchar](100) NULL,
	[ApprovalStatus] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[Creator] [int] NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[HappenedWeight] [decimal](18, 8) NULL,
	[IsFinished] [bit] NULL,
	[TradeType] [int] NOT NULL,
	[Category] [int] NULL,
 CONSTRAINT [PK_WFINVENTORYADJUSTMENTREQUES] PRIMARY KEY CLUSTERED 
(
	[WFInventoryAdjustmentRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFInvoiceObject](
	[WFInvoiceObjectId] [int] IDENTITY(1,1) NOT NULL,
	[WFInvoiceRecordId] [int] NULL,
	[Weight] [decimal](18, 8) NULL,
	[Note] [nvarchar](100) NULL,
	[ObjectType] [int] NULL,
	[ObjectId] [int] NULL,
	[WholeInvoiceObjectUid] [uniqueidentifier] NULL,
	[ObjectCurrencyId] [int] NULL,
	[ExchangeRateId] [int] NULL,
	[ObjectCurrencyPresentValue] [decimal](18, 8) NULL,
	[ObjectCurrencyFutureValue] [decimal](18, 8) NULL,
	[FinalObjectCurrencyPresentValue] [decimal](18, 8) NULL,
	[FinalObjectCurrencyFutureValue] [decimal](18, 8) NULL,
	[WFContractInvoiceId] [int] NULL,
 CONSTRAINT [WFInvoiceObject_PK] PRIMARY KEY CLUSTERED 
(
	[WFInvoiceObjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFInvoiceRecord](
	[WFInvoiceRecordId] [int] IDENTITY(1,1) NOT NULL,
	[WFInvoiceRequestId] [int] NULL,
	[CreateTime] [datetime] NULL,
	[IsReceive] [bit] NOT NULL,
	[OpenDate] [datetime] NULL,
	[ReceiveDate] [datetime] NULL,
	[ExpressageCompaniesId] [int] NULL,
	[ExpressNumber] [nvarchar](100) NULL,
	[Note] [nvarchar](1000) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CustomerId] [int] NULL,
	[TotalAmount] [decimal](18, 8) NULL,
	[TotalWeight] [decimal](18, 8) NULL,
	[CorporationId] [int] NULL,
	[DeliveryDate] [datetime] NULL,
	[CommodityId] [int] NULL,
	[Creator] [int] NULL,
	[SalerId] [int] NULL,
	[TradeType] [smallint] NOT NULL,
	[InvoiceType] [smallint] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[UnitId] [int] NOT NULL,
	[InvoiceCode] [nvarchar](100) NULL,
	[ExchangeProcessType] [int] NULL,
	[PaymentFormType] [int] NULL,
	[IsAmountIncludeDiscountCost] [bit] NOT NULL,
	[DiscountCost] [decimal](18, 8) NULL,
	[WholeInvoiceUid] [uniqueidentifier] NULL,
	[DiscountRate] [decimal](18, 17) NULL,
	[DiscountDays] [int] NULL,
	[AnnualDays] [int] NULL,
	[DiscountRatio] [decimal](18, 17) NULL,
	[AmountPayeeId] [int] NULL,
	[DepartmentId] [int] NULL,
	[Status] [int] NULL,
	[ReverseDocumentSAPCode] [nvarchar](50) NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Taxation] [decimal](18, 8) NULL,
	[CustomerBankId] [int] NULL,
	[AccountingEntityId] [int] NULL,
	[ParentId] [int] NULL,
	[BusinessInvoiceId] [int] NULL,
	[InvoiceCategory] [int] NULL,
	[AdjustInvoiceType] [int] NULL,
	[InvoicePropertyType] [int] NULL,
	[TaxInvoiceCode] [nvarchar](50) NULL,
	[TaxInvoiceNumber] [nvarchar](50) NULL,
	[IsReturn] [bit] NULL,
 CONSTRAINT [WFInvoiceRecord_PK] PRIMARY KEY CLUSTERED 
(
	[WFInvoiceRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFInvoiceRequest](
	[WFInvoiceRequestId] [int] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[CurrencyId] [int] NOT NULL,
	[Amount] [decimal](18, 8) NULL,
	[Taxation] [decimal](18, 8) NULL,
	[Status] [int] NULL,
	[RequestorId] [int] NULL,
	[RequestTime] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[CustomerId] [int] NULL,
	[CustomerBankId] [int] NULL,
	[CorporationId] [int] NULL,
	[CommodityId] [int] NULL,
	[SalerId] [int] NULL,
	[TradeType] [smallint] NOT NULL,
	[UnitId] [int] NOT NULL,
	[DepartmentId] [int] NULL,
 CONSTRAINT [WFInvoiceRequest_PK] PRIMARY KEY CLUSTERED 
(
	[WFInvoiceRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFInvoiceRequestDetail](
	[WFInvoiceRequestDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFInvoiceRequestId] [int] NULL,
	[WFContractDetailInfoId] [int] NULL,
	[Weight] [decimal](18, 8) NULL,
	[Price] [decimal](18, 8) NULL,
	[Amount] [decimal](18, 8) NULL,
	[TaxRate] [decimal](18, 8) NULL,
	[Taxation] [decimal](18, 8) NULL,
	[Note] [nvarchar](1000) NULL,
 CONSTRAINT [WFInvoiceRequestDetail_PK] PRIMARY KEY CLUSTERED 
(
	[WFInvoiceRequestDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFLcContract](
	[WFLcContractId] [int] IDENTITY(1,1) NOT NULL,
	[WFLetterOfCreditId] [int] NULL,
	[WFContractInfoId] [int] NULL,
 CONSTRAINT [PK_WFLCCONTRACT] PRIMARY KEY CLUSTERED 
(
	[WFLcContractId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFLetterOfCredit](
	[WFLetterOfCreditId] [int] IDENTITY(1,1) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[IssuingBankId] [int] NOT NULL,
	[AdvisingBankId] [int] NOT NULL,
	[BeneficiaryId] [int] NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[IsSight] [bit] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CorporationId] [int] NOT NULL,
	[AccountingEntityId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[Amount] [decimal](18, 8) NOT NULL,
	[AvailableAmount] [decimal](18, 8) NOT NULL,
	[IsPay] [bit] NOT NULL,
	[Status] [int] NOT NULL,
	[PresentationExpiryDate] [datetime] NULL,
	[CommodityId] [int] NULL,
	[Weight] [decimal](18, 8) NULL,
	[Notes] [nvarchar](1000) NULL,
	[IssueDate] [datetime] NULL,
	[FloatingInterestRateType] [smallint] NULL,
	[DiscountRate] [decimal](18, 8) NULL,
	[DiscountDays] [int] NULL,
	[ExpirationDate] [datetime] NULL,
	[PositiveFloatingAmountRatio] [decimal](18, 8) NULL,
	[NegativeFloatingAmountRatio] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFLETTEROFCREDIT] PRIMARY KEY CLUSTERED 
(
	[WFLetterOfCreditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFLongContract](
	[WFLongContractId] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CommodityId] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[TotalWeight] [decimal](18, 8) NULL,
	[PriceMarket] [int] NULL,
 CONSTRAINT [WFLongContract_PK] PRIMARY KEY CLUSTERED 
(
	[WFLongContractId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFLongContractDetail](
	[WFLongContractDetailId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[WFLongContractId] [int] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Note] [nvarchar](1000) NULL,
 CONSTRAINT [WFLongContractDetail_PK] PRIMARY KEY CLUSTERED 
(
	[WFLongContractDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFMoneyConversion](
	[WFMoneyConversionId] [int] IDENTITY(1,1) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Creator] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[IsFinished] [bit] NOT NULL,
	[MoneyConversionType] [int] NOT NULL,
	[AccountingEntityId] [int] NULL,
	[CorporationId] [int] NOT NULL,
	[CounterCompanyId] [int] NOT NULL,
	[PayPaymentFormType] [int] NULL,
	[ReceivePaymentFormType] [int] NULL,
	[StartDate] [datetime] NULL,
	[FinishDate] [datetime] NULL,
	[PayCurrencyId] [int] NOT NULL,
	[ReceiveCurrencyId] [int] NOT NULL,
	[TotalPayAmount] [decimal](18, 8) NOT NULL,
	[TotalReceiveAmount] [decimal](18, 8) NOT NULL,
	[Note] [nvarchar](200) NULL,
	[PayExchangeBillId] [int] NULL,
	[BillDiscountDate] [datetime] NULL,
	[BillDiscountDays] [int] NULL,
	[BillDiscountRate] [decimal](18, 17) NULL,
	[AnnualDays] [decimal](18, 8) NULL,
	[DiscountRatio] [decimal](18, 17) NULL,
	[ReceiveExchangeRate] [int] NULL,
	[ReceiveExchangeBillId] [int] NULL,
	[TotalPayPresentValue] [decimal](18, 8) NOT NULL,
	[TotalReceivePresentValue] [decimal](18, 8) NOT NULL,
	[PayCurrencyFee] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFMONEYCONVERSION] PRIMARY KEY CLUSTERED 
(
	[WFMoneyConversionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFMultiPrecursorBatch](
	[WFMultiPrecursorBatchId] [int] IDENTITY(1,1) NOT NULL,
	[SuccessorBatchId] [int] NULL,
	[PrecursorBatchId] [int] NULL,
	[SuccessorUnitQuantity] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFMULTIPRECURSORBATCH] PRIMARY KEY CLUSTERED 
(
	[WFMultiPrecursorBatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFMultiPrecursorBatch] UNIQUE NONCLUSTERED 
(
	[SuccessorBatchId] ASC,
	[PrecursorBatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFOfficeAddress](
	[WFOfficeAddressId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](200) NOT NULL,
	[EnglishAddress] [nvarchar](200) NULL,
	[PostCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFOFFICEADDRESS] PRIMARY KEY CLUSTERED 
(
	[WFOfficeAddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFOrderInfo](
	[WFOrderInfoId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractInfoId] [int] NULL,
	[StatusOfOrder] [int] NULL,
	[CorporationId] [int] NULL,
	[CustomerId] [int] NULL,
	[IsBuy] [bit] NOT NULL,
	[CreateTime] [datetime] NULL,
	[SalerId] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[IsFurtureDelivery] [bit] NOT NULL,
	[IsInvoiceThisMonth] [bit] NOT NULL,
 CONSTRAINT [WFOrderInfo_PK] PRIMARY KEY CLUSTERED 
(
	[WFOrderInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFOtherBill](
	[WFOtherBillId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Note] [nvarchar](1000) NULL,
	[ApprovalTemplate] [int] NULL,
	[SalerId] [int] NULL,
	[Amount] [decimal](18, 8) NULL,
	[Weight] [decimal](18, 8) NULL,
	[OperationType] [smallint] NULL,
	[ApprovalStatus] [smallint] NULL,
	[CreateTime] [datetime] NULL,
	[Creator] [int] NULL,
	[CorporationId] [int] NULL,
	[CommodityId] [int] NULL,
	[DepartmentId] [int] NULL,
	[SpotAmountType] [int] NULL,
	[IsBuy] [bit] NULL,
	[TransactionType] [smallint] NULL,
	[TradeType] [smallint] NOT NULL,
	[WFBusinessApprovalFlowTemplateId] [int] NULL,
	[ApprovalType] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_WFOTHERBILL] PRIMARY KEY CLUSTERED 
(
	[WFOtherBillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFOurPlantTransferWarehouseNotification](
	[WFOurPlantTransferWarehouseNotificationId] [int] IDENTITY(1,1) NOT NULL,
	[WFStorageConversionId] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[CorporationId] [int] NOT NULL,
	[SourceWarehouseId] [int] NOT NULL,
	[TargetWarehouseId] [int] NOT NULL,
	[CommodityId] [int] NOT NULL,
	[UnitId] [int] NOT NULL,
	[BillDate] [date] NOT NULL,
	[PostingDate] [date] NOT NULL,
	[MaterialDocumentYear] [int] NOT NULL,
	[MaterialDocumentCode] [nvarchar](50) NULL,
	[CreateTime] [datetime] NOT NULL,
	[SourceInventoryId] [int] NOT NULL,
	[SourceBatchId] [int] NOT NULL,
	[TotalWeight] [decimal](18, 8) NOT NULL,
 CONSTRAINT [PK_WFOurPlantTransferWarehouseNotification] PRIMARY KEY CLUSTERED 
(
	[WFOurPlantTransferWarehouseNotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFOurPlantTransferWarehouseNotificationDetail](
	[WFOurPlantTransferWarehouseNotificationDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFOurPlantTransferWarehouseNotificationId] [int] NULL,
	[IssueBatchCode] [nvarchar](15) NULL,
	[AssignedReceiveBatchCode] [nvarchar](15) NULL,
	[Weight] [decimal](18, 8) NOT NULL,
 CONSTRAINT [PK_WFOurPlantTransferWarehouseNotificationDetail] PRIMARY KEY CLUSTERED 
(
	[WFOurPlantTransferWarehouseNotificationDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFOutRecordAssistantMeasureInfo](
	[WFWarehouseOutRecordDetailId] [int] NOT NULL,
	[Quantity] [decimal](18, 8) NOT NULL,
	[UnitId] [int] NOT NULL,
	[SubMeasureType] [smallint] NOT NULL,
	[WFOutRecordAssistantMeasureInfoId] [int] IDENTITY(1,1) NOT NULL,
	[QuantityId] [int] NOT NULL,
 CONSTRAINT [PK_WFOUTRECORDASSISTANTMEASURE] PRIMARY KEY CLUSTERED 
(
	[WFOutRecordAssistantMeasureInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFOutRecordAssistantMeasureInfo] UNIQUE NONCLUSTERED 
(
	[WFWarehouseOutRecordDetailId] ASC,
	[QuantityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPaymentProposal](
	[WFPaymentProposalId] [int] IDENTITY(1,1) NOT NULL,
	[WFPayRequestId] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[PaymentProposalStatus] [int] NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[IsSystemGenerate] [bit] NOT NULL,
	[NeedFinancePay] [bit] NOT NULL,
	[IsInitialPosted] [bit] NOT NULL,
	[PaymentFormType] [int] NOT NULL,
	[PayeeId] [int] NULL,
	[BankAccountId] [int] NULL,
	[ObjectsCurrencyAmount] [decimal](18, 8) NULL,
	[ActualCurrencyAmount] [decimal](18, 8) NULL,
	[CargoQuantity] [decimal](18, 8) NULL,
	[PaymentProposalNote] [nvarchar](100) NULL,
	[PaymentProposalCode] [nvarchar](50) NULL,
	[SapAmountTransaction] [int] NULL,
	[PayPurposeType] [smallint] NOT NULL,
	[DetailObjectType] [int] NOT NULL,
	[AmountMapType] [int] NOT NULL,
	[CommodityId] [int] NULL,
	[ExchangeRateId] [int] NULL,
	[ObjectsCurrencyId] [int] NOT NULL,
	[ActualCurrencyId] [int] NOT NULL,
	[CargoUnitId] [int] NULL,
	[PayCustomerId] [int] NULL,
 CONSTRAINT [PK_WFPAYMENTPROPOSAL] PRIMARY KEY CLUSTERED 
(
	[WFPaymentProposalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPaymentProposalDetail](
	[WFPaymentProposalDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFPaymentProposalId] [int] NULL,
	[WFContractInfoId] [int] NULL,
	[ObjectType] [int] NULL,
	[ObjectId] [int] NULL,
	[ObjectCurrencyId] [int] NULL,
	[ExchangeRateId] [int] NULL,
	[SettleCurrencyPresentValue] [decimal](18, 8) NULL,
	[SettleCurrencyFutureValue] [decimal](18, 8) NULL,
	[ObjectAmountIncludeDiscount] [bit] NOT NULL,
	[SapAmountTransaction] [int] NULL,
	[ObjectCargoUnitId] [int] NULL,
	[ObjectCargoQuantity] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFPAYMENTPROPOSALDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFPaymentProposalDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPaymentProposalSubDetail](
	[WFPaymentProposalSubDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFPaymentProposalDetailId] [int] NULL,
	[SubDetailType] [int] NULL,
	[ObjectType] [int] NULL,
	[ObjectId] [int] NULL,
	[ObjectCurrencyId] [int] NULL,
	[ObjectCurrencyFutureValue] [decimal](18, 8) NULL,
	[SapAmountTransaction] [int] NULL,
 CONSTRAINT [PK_WFPAYMENTPROPOSALSUBDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFPaymentProposalSubDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPayRequest](
	[WFPayRequestId] [int] IDENTITY(1,1) NOT NULL,
	[WFSettlementRequestlId] [int] NULL,
	[PayCustomerId] [int] NULL,
	[CorporationId] [int] NULL,
	[CompanyBankInfoId] [int] NULL,
	[PayPurpose] [nvarchar](500) NULL,
	[Amount] [decimal](18, 8) NULL,
	[CurrencyId] [int] NOT NULL,
	[Status] [int] NULL,
	[RequestorId] [int] NULL,
	[RequestTime] [datetime] NULL,
	[PayType] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[CommodityId] [int] NULL,
	[SalerId] [int] NULL,
	[AccountingEntityId] [int] NULL,
	[PayPurposeType] [smallint] NOT NULL,
	[ApprovalStatus] [smallint] NULL,
	[TradeType] [smallint] NOT NULL,
	[ExchangeRateId] [int] NULL,
	[ActualCurrencyId] [int] NULL,
	[ActualCurrencyAmount] [decimal](18, 8) NULL,
	[DetailObjectType] [int] NOT NULL,
	[IsSystemGenerate] [bit] NOT NULL,
	[AmountMapType] [int] NOT NULL,
	[AmountPayeeId] [int] NULL,
	[DepartmentId] [int] NULL,
	[NeedFinancePay] [bit] NULL,
	[SapAmountTransaction] [int] NULL,
	[PayRequestCode] [nvarchar](12) NULL,
	[CreateTime] [datetime] NOT NULL,
	[NeedSubmitSap] [bit] NULL,
	[CargoUnitId] [int] NULL,
	[CargoQuantity] [decimal](18, 8) NULL,
	[CapitalPlan] [int] NULL,
 CONSTRAINT [WFPayRequest_PK] PRIMARY KEY CLUSTERED 
(
	[WFPayRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPayRequestDetail](
	[WFPayRequestDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFPayRequestId] [int] NULL,
	[WFContractInfoId] [int] NULL,
	[ObjectId] [int] NULL,
	[SettleCurrencyPresentValue] [decimal](18, 8) NULL,
	[SettleCurrencyFutureValue] [decimal](18, 8) NULL,
	[ObjectType] [int] NULL,
	[ObjectCurrencyId] [int] NULL,
	[ExchangeRateId] [int] NULL,
	[ObjectCurrencyDiscount]  AS ([SettleCurrencyFutureValue]-[SettleCurrencyPresentValue]),
	[ObjectAmountIncludeDiscount] [bit] NOT NULL,
	[SapAmountTransaction] [int] NULL,
	[ObjectCargoUnitId] [int] NULL,
	[ObjectCargoQuantity] [decimal](18, 8) NULL,
 CONSTRAINT [WFPayRequestDetail_PK] PRIMARY KEY CLUSTERED 
(
	[WFPayRequestDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPayRequestSubDetail](
	[WFPayRequestSubDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFPayRequestDetailId] [int] NULL,
	[SubDetailType] [int] NULL,
	[ObjectType] [int] NULL,
	[ObjectId] [int] NULL,
	[ObjectCurrencyId] [int] NULL,
	[ObjectCurrencyFutureValue] [decimal](18, 8) NULL,
	[SapAmountTransaction] [int] NULL,
 CONSTRAINT [PK_WFPAYREQUESTSUBDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFPayRequestSubDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPledgeContract](
	[WFContractInfoId] [int] NOT NULL,
	[PledgeType] [int] NULL,
	[PledgeRate] [decimal](18, 8) NULL,
	[PledgeInterestRate] [decimal](18, 8) NULL,
	[PledgeExchangeId] [int] NULL,
	[PledgeDays] [int] NULL,
	[ExpiryDate] [datetime] NULL,
 CONSTRAINT [PK_WFPLEDGECONTRACT] PRIMARY KEY CLUSTERED 
(
	[WFContractInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPledgeInfo](
	[WFPledgeInfoId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[CorporationId] [int] NULL,
	[UnitId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[CommodityId] [int] NULL,
	[TotalWeight] [decimal](18, 8) NULL,
	[PledgeRate] [decimal](18, 8) NULL,
	[PledgeWeight] [decimal](18, 8) NULL,
	[Price] [decimal](18, 8) NULL,
	[PledgeAmount] [decimal](18, 8) NULL,
	[PledgeInterestRate] [decimal](18, 8) NULL,
	[PledgeInterest] [decimal](18, 8) NULL,
	[IsUnPledgeFinished] [bit] NOT NULL,
	[PledgeStartDate] [datetime] NULL,
	[PledgeEndDate] [datetime] NULL,
	[RequestorId] [int] NULL,
	[ExcutorId] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[LastModifiedTime] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[PledgeType] [int] NULL,
	[AccountEntityId] [int] NULL,
	[IsSpotPledge] [bit] NOT NULL,
	[ThirdPartyCustomer] [int] NULL,
	[PurchaseContractId] [int] NULL,
	[IsFeeDuringPledgeOwnedByUs] [bit] NOT NULL,
	[ExchangeId] [int] NULL,
	[TradeType] [smallint] NOT NULL,
 CONSTRAINT [WFPledgeInfo_PK] PRIMARY KEY CLUSTERED 
(
	[WFPledgeInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPledgeRenewal](
	[WFPledgeRenewalId] [int] IDENTITY(1,1) NOT NULL,
	[OldPledgeContractId] [int] NULL,
	[RedeemContractId] [int] NULL,
	[NewPledgeContractId] [int] NULL,
	[RedeemContractCode] [nvarchar](50) NULL,
	[NewPledgeContractCode] [nvarchar](50) NULL,
	[PledgeRate] [decimal](18, 8) NULL,
	[PledgeInterestRate] [decimal](18, 8) NULL,
	[PledgeDays] [int] NULL,
	[ExpiryDate] [datetime] NULL,
	[SignDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[ApprovalStatus] [smallint] NULL,
 CONSTRAINT [PK_WFPLEDGERENEWAL] PRIMARY KEY CLUSTERED 
(
	[WFPledgeRenewalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPledgeRenewalDetail](
	[WFPledgeRenewalDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFPledgeRenewalId] [int] NULL,
	[BrandId] [int] NULL,
	[SpecificationId] [int] NULL,
	[Weight] [decimal](18, 8) NULL,
	[RedeemPrice] [decimal](18, 8) NULL,
	[NewPledgePrice] [decimal](18, 8) NULL,
	[RedeemBasePrice] [decimal](18, 8) NULL,
	[RedeemPremiumDiscount] [decimal](18, 8) NULL,
	[NewPledgeBasePrice] [decimal](18, 8) NULL,
	[NewPledgePremiumDiscount] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFPLEDGERENEWALDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFPledgeRenewalDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPost](
	[WFPostId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Note] [nvarchar](100) NULL,
	[EnumValue] [smallint] NULL,
 CONSTRAINT [PK_WFPOST] PRIMARY KEY CLUSTERED 
(
	[WFPostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPostingInfo](
	[WFPostingInfoId] [int] IDENTITY(1,1) NOT NULL,
	[Weight] [decimal](18, 8) NOT NULL,
	[UnitId] [int] NOT NULL,
	[ObjectId] [int] NOT NULL,
	[PostingTime] [datetime] NOT NULL,
	[Note] [nvarchar](200) NULL,
	[IsDeleted] [bit] NOT NULL,
	[ObjectType] [int] NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[Creator] [int] NOT NULL,
	[BusinessType] [int] NULL,
	[PropertyType] [int] NULL,
	[SAPStatus] [int] NULL,
	[InitialPosted] [bit] NOT NULL,
	[EntryOutDate] [datetime] NULL,
 CONSTRAINT [PK_WFPOSTINGINFO] PRIMARY KEY CLUSTERED 
(
	[WFPostingInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPostingInfoDetail](
	[WFPostingInfoDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFPostingInfoId] [int] NULL,
	[ObjectType] [int] NOT NULL,
	[ObjectId] [int] NOT NULL,
	[PostingWeight] [decimal](18, 8) NOT NULL,
	[HappenedInvoiceWeight] [decimal](18, 8) NULL,
	[IsDeleted] [bit] NOT NULL,
	[BrandId] [int] NULL,
	[SpecificationId] [int] NULL,
	[GroupCode] [nvarchar](50) NULL,
	[StorageCode] [nvarchar](50) NULL,
	[CreateTime] [datetime] NOT NULL,
	[CreatorId] [int] NOT NULL,
	[WFFinancialBatchId] [int] NULL,
 CONSTRAINT [PK_WFPOSTINGINFODETAIL] PRIMARY KEY CLUSTERED 
(
	[WFPostingInfoDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPriceConfirmationLetter](
	[WFPriceConfirmationLetterId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractInfoId] [int] NULL,
	[UnitId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[ContractName] [nvarchar](50) NULL,
	[Note] [nvarchar](1000) NULL,
	[CreateTime] [date] NULL,
	[PriceType] [int] NULL,
	[ApprovalStatus] [smallint] NULL,
	[TradeType] [smallint] NULL,
	[PriceDetailId] [int] NULL,
	[PricingUnitId] [int] NOT NULL,
	[PricingCurrencyId] [int] NOT NULL,
 CONSTRAINT [PK_WFPRICECONFIRMATIONLETTER] PRIMARY KEY CLUSTERED 
(
	[WFPriceConfirmationLetterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPriceConfirmationLetterDetails](
	[WFPriceConfirmationLetterDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[WFPriceConfirmationLetterId] [int] NULL,
	[Price] [decimal](18, 8) NULL,
	[Weight] [decimal](18, 8) NULL,
	[CommodityId] [int] NULL,
	[SpecificationId] [int] NULL,
	[BrandId] [int] NULL,
	[Premium] [decimal](18, 8) NULL,
	[BasePrice] [decimal](18, 8) NULL,
	[PricingPrice] [decimal](18, 8) NULL,
	[PricingPremium] [decimal](18, 8) NULL,
	[PricingBasePrice] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFPRICECONFIRMATIONLETTERDE] PRIMARY KEY CLUSTERED 
(
	[WFPriceConfirmationLetterDetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPriceDetail](
	[WFPriceDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFPriceInfoId] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[PriceMakingType] [int] NOT NULL,
	[Weight] [decimal](18, 8) NULL,
	[TempPrice] [decimal](18, 8) NULL,
	[FinalPrice] [decimal](18, 8) NULL,
	[IsCompleted] [bit] NOT NULL,
	[PricingTempPrice] [decimal](18, 8) NULL,
	[PricingTempPremiumDiscount] [decimal](18, 8) NULL,
	[TempPremiumDiscount] [decimal](18, 8) NULL,
	[PriceMarket] [int] NULL,
	[InstrumentCategoryId] [int] NULL,
 CONSTRAINT [PK_WFPRICEDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFPriceDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPriceInfo](
	[WFPriceInfoId] [int] IDENTITY(1,1) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[PriceMakingType] [int] NOT NULL,
	[UnitId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[CommodityId] [int] NULL,
	[Scale] [smallint] NULL,
	[PricingUnitId] [int] NOT NULL,
	[PricingCurrencyId] [int] NOT NULL,
	[PricingScale] [smallint] NULL,
	[TempExchangeRateId] [int] NULL,
 CONSTRAINT [PK_WFPRICEINFO] PRIMARY KEY CLUSTERED 
(
	[WFPriceInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPriceInstrument](
	[WFPriceInstrumenttId] [int] IDENTITY(1,1) NOT NULL,
	[WFPriceDetailId] [int] NULL,
	[WFInstrumentId] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_WFPRICEINSTRUMENT] PRIMARY KEY CLUSTERED 
(
	[WFPriceInstrumenttId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFPriceQuantityScale](
	[WFPriceQuantityScaleId] [int] IDENTITY(1,1) NOT NULL,
	[MoneyUnitId] [int] NULL,
	[CargoUnitId] [int] NULL,
	[CommodityId] [int] NULL,
	[Scale] [smallint] NULL,
	[Priority] [smallint] NOT NULL,
 CONSTRAINT [PK_WFPRICEQUANTITYSCALE] PRIMARY KEY CLUSTERED 
(
	[WFPriceQuantityScaleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFQuantityType](
	[WFQuantityTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[EnglishName] [nvarchar](50) NULL,
	[QuantityKind] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_WFQUANTITYTYPE] PRIMARY KEY CLUSTERED 
(
	[WFQuantityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFReceivingClaim](
	[WFReceivingClaimId] [int] IDENTITY(1,1) NOT NULL,
	[CorporationId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[Amount] [decimal](18, 6) NOT NULL,
	[CustomerId] [int] NULL,
	[BillCode] [nvarchar](50) NULL,
	[BankInfoId] [int] NULL,
	[CustomerBankName] [nvarchar](200) NULL,
	[CustomerBankAccount] [nvarchar](50) NULL,
	[Note] [nvarchar](500) NULL,
	[SapSequenceNumber] [nvarchar](16) NULL,
	[DaybookDate] [datetime] NULL,
	[RemarksSapAmountTransaction] [int] NULL,
	[RemarksSapAmountTransactionCategoryId] [int] NULL,
	[SapPaymentMethod] [int] NULL,
	[RemarksIsSupplierCode] [bit] NULL,
	[ReceiveDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsNeedReturn] [bit] NULL,
	[ExecutorId] [int] NULL,
	[CreateTime] [datetime] NOT NULL,
	[PostingDate] [datetime] NULL,
	[Status] [int] NULL,
	[PostingStatus] [int] NULL,
	[IsPay] [bit] NULL,
	[YGBillCode] [nvarchar](20) NULL,
	[YGBillItemCode] [nvarchar](20) NULL,
	[CustomerBankAccountId] [int] NULL,
	[CorporationBankAccountCode] [nvarchar](50) NULL,
	[CorporationBankName] [nvarchar](200) NULL,
	[IsSystemGenerate] [bit] NOT NULL,
 CONSTRAINT [PK_WFRECEIVINGCLAIM] PRIMARY KEY CLUSTERED 
(
	[WFReceivingClaimId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFRoleBusiness](
	[WFRoleBusinessId] [int] IDENTITY(1,1) NOT NULL,
	[WFRoleInfoId] [int] NOT NULL,
	[WFBusinessId] [int] NULL,
	[IsDisabled] [bit] NOT NULL,
 CONSTRAINT [PK_WFROLEBUSINESS] PRIMARY KEY CLUSTERED 
(
	[WFRoleBusinessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFRoleBusiness] UNIQUE NONCLUSTERED 
(
	[WFRoleInfoId] ASC,
	[WFBusinessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFRoleConditionConfiguration](
	[WFRoleConditionConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[ApproverTemplateId] [int] NULL,
	[CorporationId] [int] NULL,
	[DepartmentId] [int] NULL,
	[CommodityId] [int] NULL,
	[TradeType] [int] NULL,
	[ApprovalType] [int] NULL,
	[ApproverActionType] [int] NULL,
	[Users] [nvarchar](150) NULL,
	[Note] [nvarchar](1000) NULL,
 CONSTRAINT [PK_WFROLECONDITIONCONFIGURATIO] PRIMARY KEY CLUSTERED 
(
	[WFRoleConditionConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFRoleInfo](
	[WFRoleInfoId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[WFDepartmentId] [int] NULL,
	[WFPostId] [int] NULL,
	[CorporationId] [int] NULL,
	[CommodityId] [int] NULL,
	[TradeType] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[RoleType] [int] NULL,
 CONSTRAINT [PK_WFROLEINFO] PRIMARY KEY CLUSTERED 
(
	[WFRoleInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFRolePrivilege](
	[WFRolePrivilegeId] [int] IDENTITY(1,1) NOT NULL,
	[Privilege] [int] NOT NULL,
	[WFRoleInfoId] [int] NOT NULL,
	[CorporationId] [int] NULL,
	[TradeType] [smallint] NULL,
 CONSTRAINT [PK_WFROLEPRIVILEGE] PRIMARY KEY CLUSTERED 
(
	[WFRolePrivilegeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFRolePrivilege] UNIQUE NONCLUSTERED 
(
	[Privilege] ASC,
	[WFRoleInfoId] ASC,
	[CorporationId] ASC,
	[TradeType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSaleContractTradeRecord](
	[WFSaleContractTradeRecordId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractOutRecordDetailId] [int] NULL,
	[ActualWeight] [decimal](18, 8) NULL,
	[UnitId] [int] NOT NULL,
	[Price] [decimal](18, 8) NULL,
	[CurrencyId] [int] NOT NULL,
	[Note] [nvarchar](1000) NULL,
	[BasePrice] [decimal](18, 8) NULL,
	[PremiumDiscount] [decimal](18, 8) NULL,
	[WFFirePriceRecordId] [int] NULL,
	[WFFinalPriceId] [int] NULL,
 CONSTRAINT [PK_WFSALECONTRACTTRADERECORD] PRIMARY KEY CLUSTERED 
(
	[WFSaleContractTradeRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSapAmountCategoryCommodity](
	[WFSapAmountCategoryCommodityId] [int] IDENTITY(1,1) NOT NULL,
	[WFSapConfigurationId] [int] NULL,
	[WFCommodityId] [int] NULL,
 CONSTRAINT [PK_WFSAPAMOUNTCATEGORYCOMMODIT] PRIMARY KEY CLUSTERED 
(
	[WFSapAmountCategoryCommodityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSapConfiguration](
	[WFSapConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[SapConfigurationType] [smallint] NOT NULL,
	[SapCode] [nvarchar](30) NULL,
	[Name] [nvarchar](100) NULL,
	[Note] [nvarchar](100) NULL,
	[SapZxxtEnabled] [bit] NULL,
	[SapAmountCategoryType] [int] NULL,
	[SapAmountTransactionIsPay] [bit] NULL,
	[SapAmountTransactionPayPurposeType] [int] NULL,
	[SapAmountTransactionCompanyCodeType] [int] NULL,
	[CompanyId] [int] NULL,
	[SapCompanyCodeCurrencyId] [int] NULL,
	[SapAmountTransactionInitialPosted] [bit] NULL,
 CONSTRAINT [PK_WFSAPCONFIGURATION] PRIMARY KEY CLUSTERED 
(
	[WFSapConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSapTransaction](
	[WFSapTransactionId] [bigint] IDENTITY(1,1) NOT NULL,
	[Tid] [uniqueidentifier] NOT NULL,
	[ServiceOperation] [smallint] NOT NULL,
	[IsOut] [bit] NOT NULL,
	[IsAsync] [bit] NOT NULL,
	[NeedFeedback] [bit] NOT NULL,
	[IsMultiple] [bit] NOT NULL,
	[TransactionStatus] [smallint] NOT NULL,
	[MessageOperation] [smallint] NULL,
	[MessageGenericOperation] [smallint] NULL,
	[MessageGenericOperationCategory] [smallint] NULL,
	[CreationTime] [datetime] NULL,
	[BeginTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[FromSystem] [nvarchar](10) NULL,
	[ToSystem] [nvarchar](10) NULL,
	[UserId] [int] NULL,
	[UserName] [nvarchar](50) NULL,
	[FeedbackResult] [smallint] NULL,
	[FeedbackText] [nvarchar](220) NULL,
	[ObjectType] [smallint] NOT NULL,
	[ObjectId] [int] NULL,
	[Note] [nvarchar](220) NULL,
	[TransferMessage] [nvarchar](max) NULL,
	[RecreateNewTid] [uniqueidentifier] NULL,
	[TransferMessagePhase2] [nvarchar](max) NULL,
 CONSTRAINT [PK_WFSAPTRANSACTION] PRIMARY KEY CLUSTERED 
(
	[WFSapTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFSAPTRANSACTION] UNIQUE NONCLUSTERED 
(
	[Tid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSapTransactionMultiObject](
	[WFSapTransactionMultiObjectId] [bigint] IDENTITY(1,1) NOT NULL,
	[WFSapTransactionId] [bigint] NOT NULL,
	[ObjectId] [int] NULL,
 CONSTRAINT [PK_WFSAPTRANSACTIONMULTIOBJECT] PRIMARY KEY CLUSTERED 
(
	[WFSapTransactionMultiObjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSettlementRequest](
	[WFSettlementRequestlId] [int] IDENTITY(1,1) NOT NULL,
	[CorporationId] [int] NULL,
	[CustomerId] [int] NULL,
	[RequestorId] [int] NULL,
	[RequestTime] [datetime] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Amount] [decimal](18, 8) NULL,
	[IsPay] [bit] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[IsFinished] [bit] NOT NULL,
	[PayType] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[CommodityId] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[SalerId] [int] NULL,
	[TradeType] [smallint] NOT NULL,
	[IsSystemGenerate] [bit] NOT NULL,
	[BalanceMapType] [int] NOT NULL,
	[SettlementDetailObjectType] [int] NULL,
	[DepartmentId] [int] NULL,
 CONSTRAINT [WFSettlementRequest_PK] PRIMARY KEY CLUSTERED 
(
	[WFSettlementRequestlId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSettlementRequestDetail](
	[WFSettlementRequestDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFContractInfoId] [int] NULL,
	[WFSettlementRequestlId] [int] NULL,
	[Amount] [decimal](18, 8) NOT NULL,
	[ObjectId] [int] NULL,
	[ObjectType] [int] NULL,
 CONSTRAINT [WFSettlementRequestDetail_PK] PRIMARY KEY CLUSTERED 
(
	[WFSettlementRequestDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSettleOption](
	[WFSettleOptionId] [int] IDENTITY(1,1) NOT NULL,
	[Note] [nvarchar](500) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[OptionType] [int] NOT NULL,
	[ExchangeProcessType] [int] NULL,
	[PaymentFormType] [int] NULL,
	[ProvisionalPaymentProportion] [decimal](18, 8) NULL,
	[DepositProportion] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFSETTLEOPTION] PRIMARY KEY CLUSTERED 
(
	[WFSettleOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSettleOptionDetail](
	[WFSettleOptionDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFSettleOptionId] [int] NULL,
	[Note] [nvarchar](500) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_WFSETTLEOPTIONDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFSettleOptionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSettleOptionDetailExchangeProcess](
	[WFSettleOptionDetailId] [int] NOT NULL,
	[ExchangeProcessType] [int] NOT NULL,
 CONSTRAINT [PK_WFSETTLEOPTIONDETAILEXCHANG] PRIMARY KEY CLUSTERED 
(
	[WFSettleOptionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSettleOptionDetailPaymentForm](
	[WFSettleOptionDetailId] [int] NOT NULL,
	[PaymentFormType] [int] NULL,
 CONSTRAINT [PK_WFSETTLEOPTIONDETAILPAYMENT] PRIMARY KEY CLUSTERED 
(
	[WFSettleOptionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSodEpAmountFirst](
	[WFSettleOptionDetailId] [int] NOT NULL,
 CONSTRAINT [PK_WFSODEPAMOUNTFIRST] PRIMARY KEY CLUSTERED 
(
	[WFSettleOptionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSodEpConditionalRelease](
	[WFSettleOptionDetailId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[Amount] [decimal](18, 8) NULL,
	[ReleaseCondition] [smallint] NOT NULL,
 CONSTRAINT [PK_WFSodEpConditionalRelease] PRIMARY KEY CLUSTERED 
(
	[WFSettleOptionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSodEpDocumentsAgainstAcceptance](
	[WFSettleOptionDetailId] [int] NOT NULL,
	[BuyerBankId] [int] NULL,
	[SalerBankId] [int] NULL,
	[Amount] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFSodEpDocumentsAgainstAcceptance] PRIMARY KEY CLUSTERED 
(
	[WFSettleOptionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSodEpDocumentsAgainstPayment](
	[WFSettleOptionDetailId] [int] NOT NULL,
	[BuyerBankId] [int] NULL,
	[SalerBankId] [int] NULL,
	[Amount] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFSodEpDocumentsAgainstPayment] PRIMARY KEY CLUSTERED 
(
	[WFSettleOptionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSodEpLetterOfCredit](
	[WFSettleOptionDetailId] [int] NOT NULL,
	[TermType] [smallint] NOT NULL,
	[IssuingBankId] [int] NULL,
	[AdvisingBankId] [int] NULL,
	[Amount] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFSODEPLETTEROFCREDIT] PRIMARY KEY CLUSTERED 
(
	[WFSettleOptionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSodPfExchangeBill](
	[WFSettleOptionDetailId] [int] NOT NULL,
	[FloatInterestType] [smallint] NULL,
	[DiscountRate] [decimal](18, 8) NULL,
	[DiscountDays] [int] NULL,
	[Type] [smallint] NOT NULL,
 CONSTRAINT [PK_WFSODPFEXCHANGEBILL] PRIMARY KEY CLUSTERED 
(
	[WFSettleOptionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSpecialFeeConfiguration](
	[WFSpecialFeeConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[WFWarehouseFeeId] [int] NULL,
	[WFWarehouseId] [int] NULL,
	[WFCommodityId] [int] NULL,
	[StartDay] [decimal](4, 1) NULL,
	[EndDay] [decimal](4, 1) NULL,
	[Price] [decimal](18, 4) NULL,
	[SpecialDate] [date] NULL,
	[SystemFeeTypeId] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_WFSPECIALFEECONFIGURATION] PRIMARY KEY CLUSTERED 
(
	[WFSpecialFeeConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSpecification](
	[WFSpecificationId] [int] IDENTITY(1,1) NOT NULL,
	[WFCommodityId] [int] NULL,
	[Code] [nvarchar](30) NULL,
	[Name] [nvarchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
	[EnglishName] [nvarchar](50) NULL,
	[AccountingName] [nvarchar](50) NULL,
 CONSTRAINT [WFSpecification_PK] PRIMARY KEY CLUSTERED 
(
	[WFSpecificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSpotReceiptConvertDetailInfo](
	[WFSpotReceiptConvertDetailInfoId] [int] IDENTITY(1,1) NOT NULL,
	[WFSpotReceiptConvertInfoId] [int] NULL,
	[WFWarehouseStorageId] [int] NULL,
	[RequestWeight] [decimal](18, 8) NULL,
	[ActualWeight] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFSPOTRECEIPTCONVERTDETAILI] PRIMARY KEY CLUSTERED 
(
	[WFSpotReceiptConvertDetailInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSpotReceiptConvertInfo](
	[WFSpotReceiptConvertInfoId] [int] IDENTITY(1,1) NOT NULL,
	[ConvertWeight] [decimal](18, 8) NULL,
	[ConvertCost] [decimal](18, 8) NULL,
	[IsConvertToSpot] [bit] NOT NULL,
	[RequestDate] [datetime] NULL,
	[ConvertDate] [datetime] NULL,
	[ActorId] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[UnitId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CardCode] [nvarchar](50) NULL,
	[IsReceiptCodeRemain] [bit] NOT NULL,
	[BrandId] [int] NULL,
	[SpecificationId] [int] NULL,
	[WarehouseId] [int] NULL,
	[ExchangeId] [int] NULL,
	[CommodityId] [int] NULL,
	[CorporationId] [int] NULL,
	[Creator] [int] NULL,
	[AccountEntityId] [int] NULL,
	[VoucherCode] [nvarchar](100) NULL,
	[SalerId] [int] NULL,
	[Code] [nvarchar](20) NULL,
	[CreateDate] [datetime] NULL,
	[TradeType] [smallint] NOT NULL,
 CONSTRAINT [WFSpotReceiptConvertInfo_PK] PRIMARY KEY CLUSTERED 
(
	[WFSpotReceiptConvertInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFStepActionTemplate](
	[WFStepActionTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[WFApproverTemplateId] [int] NULL,
	[WFApprovalWorkflowStepTemplateId] [int] NULL,
	[ActionType] [smallint] NULL,
	[IsPreStepAction] [bit] NULL,
	[StepResultType] [smallint] NULL,
 CONSTRAINT [PK_WFSTEPACTIONTEMPLATE] PRIMARY KEY CLUSTERED 
(
	[WFStepActionTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFStepConditionTemplate](
	[WFStepConditionId] [int] IDENTITY(1,1) NOT NULL,
	[PreviousWFApprovalWorkflowStepId] [int] NULL,
	[NextWFApprovalWorkflowStepId] [int] NULL,
	[WFConditionId] [int] NULL,
	[Action] [smallint] NULL,
	[Result] [smallint] NULL,
	[ConditionNote] [nvarchar](500) NULL,
	[MemberPassType] [smallint] NULL,
 CONSTRAINT [PK_WFSTEPCONDITIONTEMPLATE] PRIMARY KEY CLUSTERED 
(
	[WFStepConditionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFStorageAssistantMeasureInfo](
	[WFWarehouseStorageId] [int] NOT NULL,
	[Quantity] [decimal](18, 8) NOT NULL,
	[UnitId] [int] NOT NULL,
	[SubMeasureType] [smallint] NOT NULL,
	[WFStorageAssistantMeasureInfoId] [int] IDENTITY(1,1) NOT NULL,
	[PledgeQuantity] [decimal](18, 8) NULL,
	[TempHoldQuantity] [decimal](18, 8) NULL,
	[AvailableQuantity] [decimal](18, 8) NULL,
	[QuantityId] [int] NOT NULL,
 CONSTRAINT [PK_WFSTORAGEASSISTANTMEASUREIN] PRIMARY KEY CLUSTERED 
(
	[WFStorageAssistantMeasureInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFStorageAssistantMeasureInfo] UNIQUE NONCLUSTERED 
(
	[WFWarehouseStorageId] ASC,
	[QuantityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFStorageConversion](
	[WFStorageConversionId] [int] IDENTITY(1,1) NOT NULL,
	[StorageConversionType] [int] NOT NULL,
	[RequestDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[FinishedDate] [datetime] NULL,
	[Note] [nvarchar](1000) NULL,
	[UnitId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[SourceWarehouseId] [int] NOT NULL,
	[TargetWarehouseId] [int] NULL,
	[CorporationId] [int] NOT NULL,
	[Creator] [int] NOT NULL,
	[AccountEntityId] [int] NOT NULL,
	[SalerId] [int] NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Weight] [decimal](18, 8) NULL,
	[CommodityId] [int] NOT NULL,
	[TradeType] [smallint] NOT NULL,
	[IsFinished] [bit] NOT NULL,
	[ExchangeId] [int] NULL,
	[ConvertCost] [decimal](18, 8) NULL,
	[IsReceiptCodeRemain] [bit] NULL,
	[VoucherCode] [nvarchar](100) NULL,
	[DepartmentId] [int] NULL,
	[ApprovalStatus] [int] NULL,
	[TransferDeliveryDate] [datetime] NULL,
	[TransferPlateNumber] [nvarchar](7) NULL,
	[TransferCustomerName] [nvarchar](100) NULL,
	[TransferDeliveryAddress] [nvarchar](100) NULL,
	[TransferDestination] [nvarchar](100) NULL,
	[TransferDriverName] [nvarchar](8) NULL,
	[TransferIdNumber] [nvarchar](18) NULL,
	[TransferTelephone] [nvarchar](11) NULL,
	[TransferDeliveryType] [nvarchar](10) NULL,
 CONSTRAINT [PK_WFSTORAGECOVERSION] PRIMARY KEY CLUSTERED 
(
	[WFStorageConversionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFStorageConversionDetail](
	[WFStorageConversionDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFStorageConversionId] [int] NOT NULL,
	[BrandId] [int] NOT NULL,
	[SpecificationId] [int] NOT NULL,
	[GroupCode] [nvarchar](20) NULL,
	[StorageCode] [nvarchar](20) NULL,
	[Weight] [decimal](18, 8) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_WFStorageConversionDetail] PRIMARY KEY CLUSTERED 
(
	[WFStorageConversionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSupplementalAgreement](
	[NewContractId] [int] NOT NULL,
	[OriginContractId] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[ApplicationDate] [datetime] NULL,
	[ContractContinuationType] [int] NOT NULL,
 CONSTRAINT [PK_WFSupplementalAgreement] PRIMARY KEY CLUSTERED 
(
	[NewContractId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSupplementalAgreementDetail](
	[NewContractDetailId] [int] NOT NULL,
	[NewContractId] [int] NULL,
	[OriginContractDetailId] [int] NOT NULL,
	[Weight] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFSupplementalAgreementDetail] PRIMARY KEY CLUSTERED 
(
	[NewContractDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSystemCodeInfo](
	[WFSystemCodeInfoId] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [date] NULL,
	[CurrentMaxCode] [int] NULL,
	[CodeType] [smallint] NULL,
	[PeriodType] [smallint] NULL,
	[PeriodCount] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[RuleDescription] [nvarchar](100) NULL,
	[WFCodeTemplateId] [int] NULL,
 CONSTRAINT [PK_WFSYSTEMCODEINFO] PRIMARY KEY CLUSTERED 
(
	[WFSystemCodeInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSystemCodeInfoConfiguration](
	[WFSystemCodeInfoConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[WFSystemCodeInfoId] [int] NULL,
	[CorporationId] [int] NULL,
	[CommodityId] [int] NULL,
	[WarehouseId] [int] NULL,
	[IsBuy] [bit] NULL,
	[TradeType] [smallint] NULL,
	[ContractInfoId] [int] NULL,
 CONSTRAINT [PK_WFSYSTEMCODEINFOCONFIGURATI] PRIMARY KEY CLUSTERED 
(
	[WFSystemCodeInfoConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSystemConfigDetail](
	[WFSystemConfigDetailId] [int] IDENTITY(1,1) NOT NULL,
	[TradeType] [int] NULL,
	[CorporationId] [int] NULL,
	[DepartmentId] [int] NULL,
	[CommodityId] [int] NULL,
	[ExchangeId] [int] NULL,
	[WFValue] [nvarchar](2000) NULL,
	[Note] [nvarchar](200) NULL,
	[UnitId] [int] NULL,
	[CurrencyId] [int] NULL,
	[WFSystemConfigurationId] [int] NULL,
	[CustomerId] [int] NULL,
	[Addition1] [int] NULL,
	[AccountingEntityId] [int] NULL,
 CONSTRAINT [PK_WFSYSTEMCONFIGDETAIL] PRIMARY KEY CLUSTERED 
(
	[WFSystemConfigDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSystemConfiguration](
	[WFKey] [nvarchar](100) NOT NULL,
	[WFValue] [nvarchar](2000) NULL,
	[Note] [nvarchar](500) NULL,
	[Name] [nvarchar](100) NULL,
	[ConfCategory] [int] NULL,
	[WFSystemConfigurationId] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_WFSYSTEMCONFIGURATION] PRIMARY KEY CLUSTERED 
(
	[WFSystemConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFSystemConfiguration] UNIQUE NONCLUSTERED 
(
	[WFKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSystemFee](
	[WFSystemFeeId] [int] IDENTITY(1,1) NOT NULL,
	[WFSystemFinanceAccountId] [int] NULL,
	[FeeName] [nvarchar](100) NULL,
	[FeeType] [int] NULL,
	[Note] [nvarchar](500) NULL,
	[AbleAutoGenerate] [bit] NULL,
	[AutoFeeType] [int] NULL,
 CONSTRAINT [PK_WFSYSTEMFEE] PRIMARY KEY CLUSTERED 
(
	[WFSystemFeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSystemFeeConfiguration](
	[WFSystemFeeConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[WFCommodityId] [int] NULL,
	[IsSpotFee] [bit] NULL,
	[Price] [decimal](18, 4) NULL,
	[SystemFeeTypeId] [int] NULL,
	[HasSpecialFee] [bit] NULL,
	[CurrencyId] [int] NULL,
	[WeightUnitId] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[StorageType] [int] NULL,
	[WFCompanyId] [int] NULL,
 CONSTRAINT [PK_WFSYSTEMFEECONFIGURATION] PRIMARY KEY CLUSTERED 
(
	[WFSystemFeeConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSystemFinanceAccount](
	[WFSystemFinanceAccountId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Note] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFSYSTEMFINANCEACCOUNT] PRIMARY KEY CLUSTERED 
(
	[WFSystemFinanceAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFSystemLog](
	[WFSystemLogId] [int] IDENTITY(1,1) NOT NULL,
	[LogType] [int] NULL,
	[ObjectType] [nvarchar](50) NULL,
	[ObjectId] [nvarchar](50) NULL,
	[UserId] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[LogTime] [datetime] NULL,
	[ObjectContent] [nvarchar](max) NULL,
 CONSTRAINT [WFSystemLog_PK] PRIMARY KEY CLUSTERED 
(
	[WFSystemLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFTempData](
	[WFTempDataId] [int] IDENTITY(1,1) NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[WFKey] [nvarchar](100) NOT NULL,
	[WFValue] [nvarchar](4000) NULL,
 CONSTRAINT [PK_WFTEMPDATA] PRIMARY KEY CLUSTERED 
(
	[WFTempDataId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [AK_WFTempData_WFKey] UNIQUE NONCLUSTERED 
(
	[WFKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFTradeCalendar](
	[ExchangeId] [int] NOT NULL,
	[IsTradeDay] [bit] NOT NULL,
	[Date] [datetime] NOT NULL,
	[WFTradeCalendarId] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[WFTradeCalendarId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFUnit](
	[WFUnitId] [int] IDENTITY(1,1) NOT NULL,
	[Symbol] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
	[EnglishName] [nvarchar](50) NULL,
	[QuantityKind] [int] NOT NULL,
	[InformalSymbol] [nvarchar](50) NULL,
	[InformalName] [nvarchar](50) NULL,
	[InformalEnglishName] [nvarchar](50) NULL,
	[SapCode] [nvarchar](15) NULL,
	[AccountingName] [nvarchar](50) NULL,
 CONSTRAINT [WFUnit_PK] PRIMARY KEY CLUSTERED 
(
	[WFUnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFUnitConversion](
	[WFUnitConversionId] [int] IDENTITY(1,1) NOT NULL,
	[FromUnitId] [int] NOT NULL,
	[ToUnitId] [int] NOT NULL,
	[FromUnitNumericValue] [decimal](18, 17) NOT NULL,
	[ToUnitNumericValue] [decimal](18, 17) NOT NULL,
	[Note] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFUNITCONVERSION] PRIMARY KEY CLUSTERED 
(
	[WFUnitConversionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_WFUNITCONVERSION] UNIQUE NONCLUSTERED 
(
	[FromUnitId] ASC,
	[ToUnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFUnPledgeInfo](
	[WFUnPledgeInfoId] [int] IDENTITY(1,1) NOT NULL,
	[WFPledgeInfoId] [int] NULL,
	[CustomerId] [int] NULL,
	[CorporationId] [int] NULL,
	[UnitId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[CommodityId] [int] NULL,
	[TotalWeight] [decimal](18, 8) NULL,
	[PledgeRate] [decimal](18, 8) NULL,
	[PledgeWeight] [decimal](18, 8) NULL,
	[Price] [decimal](18, 8) NULL,
	[PledgeAmount] [decimal](18, 8) NULL,
	[PledgeInterestRate] [decimal](18, 8) NULL,
	[PledgeInterest] [decimal](18, 8) NULL,
	[UnPledgeDate] [datetime] NOT NULL,
	[RequestorId] [int] NULL,
	[ExcutorId] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[LastModifiedTime] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AccountEntityId] [int] NULL,
	[IsUnpledgeSpot] [bit] NOT NULL,
	[TradeType] [smallint] NOT NULL,
 CONSTRAINT [WFUnPledgeInfo_PK] PRIMARY KEY CLUSTERED 
(
	[WFUnPledgeInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WFUser](
	[WFUserId] [int] IDENTITY(1,1) NOT NULL,
	[Password] [nvarchar](50) NULL,
	[LoginName] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[MailAddress] [nvarchar](50) NULL,
	[IsOutofOffice] [bit] NULL,
	[IsDeleted] [bit] NOT NULL,
	[OfficePhone] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[WXUserId] [nvarchar](50) NULL,
	[TrustedDevice] [nvarchar](300) NULL,
	[NotifyingAgents] [int] NOT NULL,
	[EnglishName] [nvarchar](50) NULL,
	[WFOfficeAddressId] [int] NULL,
	[IsDisabled] [bit] NOT NULL,
	[SAPCode] [nvarchar](10) NULL,
	[DdId] [nvarchar](50) NULL,
 CONSTRAINT [WFUser_PK] PRIMARY KEY CLUSTERED 
(
	[WFUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFUserBusiness](
	[WFUserBusinessId] [int] IDENTITY(1,1) NOT NULL,
	[WFUserId] [int] NULL,
	[WFBusinessId] [int] NULL,
	[UserConfigType] [smallint] NOT NULL,
	[OrderIndex] [int] NULL,
 CONSTRAINT [PK_WFUSERBUSINESS] PRIMARY KEY CLUSTERED 
(
	[WFUserBusinessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFUserCorporation](
	[WFUserCorporationId] [int] IDENTITY(1,1) NOT NULL,
	[WFUserId] [int] NULL,
	[WFCorporationId] [int] NULL,
 CONSTRAINT [PK_WFUSERCORPORATION] PRIMARY KEY CLUSTERED 
(
	[WFUserCorporationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFUserLinker](
	[WFUserLinkerId] [int] IDENTITY(1,1) NOT NULL,
	[FromUserId] [int] NOT NULL,
	[ToUserId] [int] NOT NULL,
	[CommodityId] [int] NULL,
 CONSTRAINT [PK_WFUSERLINKER] PRIMARY KEY CLUSTERED 
(
	[WFUserLinkerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFUserMessage](
	[WFUserMessageId] [int] IDENTITY(1,1) NOT NULL,
	[WFUserId] [int] NULL,
	[Title] [nvarchar](500) NULL,
	[Content] [nvarchar](2000) NULL,
	[IsRead] [bit] NOT NULL,
	[CreateTime] [datetime] NULL,
	[SenderId] [int] NULL,
	[ObjectId] [int] NULL,
	[ObjectType] [int] NULL,
	[CorporationId] [int] NULL,
	[MessageType] [smallint] NULL,
	[MessageRelatedEntityId] [int] NULL,
	[IsNotified] [bit] NULL,
	[Priority] [smallint] NOT NULL,
	[TradeType] [smallint] NOT NULL,
	[IsOtherForm] [bit] NULL,
 CONSTRAINT [PK_WFUSERMESSAGE] PRIMARY KEY CLUSTERED 
(
	[WFUserMessageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFUserPublishInformation](
	[WFUserPublishInformationId] [int] IDENTITY(1,1) NOT NULL,
	[WFUserId] [int] NULL,
	[BdUserId] [nvarchar](256) NULL,
	[BdChannelId] [nvarchar](256) NULL,
 CONSTRAINT [PK_WFUSERPUBLISHINFORMATION] PRIMARY KEY CLUSTERED 
(
	[WFUserPublishInformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFUserRequest](
	[WFUserRequestId] [int] IDENTITY(1,1) NOT NULL,
	[WFUserId] [int] NULL,
	[Title] [nvarchar](100) NULL,
	[Content] [nvarchar](3000) NULL,
	[ObjectId] [int] NULL,
	[ObjectType] [int] NULL,
	[CreateTime] [datetime] NULL,
	[Status] [smallint] NULL,
	[Note] [nvarchar](1000) NULL,
	[ApprovalWFId] [int] NULL,
	[CorporationId] [int] NULL,
	[TradeType] [smallint] NOT NULL,
	[IsOtherForm] [bit] NULL,
 CONSTRAINT [PK_WFUSERREQUEST] PRIMARY KEY CLUSTERED 
(
	[WFUserRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFUserRole](
	[WFUserRoleId] [int] IDENTITY(1,1) NOT NULL,
	[WFUserId] [int] NULL,
	[WFRoleInfoId] [int] NULL,
 CONSTRAINT [PK_WFUSERROLE] PRIMARY KEY CLUSTERED 
(
	[WFUserRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFUserTask](
	[WFUserTaskId] [int] IDENTITY(1,1) NOT NULL,
	[WFUserId] [int] NULL,
	[Title] [nvarchar](500) NULL,
	[Content] [nvarchar](2000) NULL,
	[ObjectId] [int] NULL,
	[ObjectType] [int] NULL,
	[IsFinished] [bit] NOT NULL,
	[CreateTime] [datetime] NULL,
	[IsEffective] [bit] NULL,
	[ApprovalStepId] [int] NULL,
	[OperationType] [smallint] NULL,
	[Note] [nvarchar](1000) NULL,
	[ApprovalWFId] [int] NULL,
	[CorporationId] [int] NULL,
	[RequestorId] [int] NULL,
	[IsNotified] [bit] NULL,
	[SearchContent] [nvarchar](2000) NULL,
	[AuthorizerId] [int] NULL,
	[Priority] [smallint] NOT NULL,
	[TradeType] [smallint] NOT NULL,
	[IsOtherForm] [bit] NULL,
 CONSTRAINT [PK_WFUSERTASK] PRIMARY KEY CLUSTERED 
(
	[WFUserTaskId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWarehouseCalculateFeeType](
	[WFWarehouseCalculateFeeTypeId] [int] IDENTITY(1,1) NOT NULL,
	[CommodityId] [int] NULL,
	[StorageStandardizationType] [smallint] NULL,
	[CalculateType] [smallint] NULL,
	[WFCompanyId] [int] NULL,
 CONSTRAINT [PK_WFWAREHOUSECALCULATEFEETYPE] PRIMARY KEY CLUSTERED 
(
	[WFWarehouseCalculateFeeTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWarehouseCardCodePrefix](
	[WFWarehouseCardCodePrefixId] [int] IDENTITY(1,1) NOT NULL,
	[CorporationId] [int] NOT NULL,
	[CardCodePrefix] [nvarchar](15) NOT NULL,
	[TradeType] [smallint] NOT NULL,
	[WFCompanyId] [int] NULL,
 CONSTRAINT [PK_WFWAREHOUSECARDCODEPREFIX] PRIMARY KEY CLUSTERED 
(
	[WFWarehouseCardCodePrefixId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWarehouseCompany](
	[WFCompanyId] [int] NOT NULL,
	[LegacyWarehouseId] [int] NULL,
	[WarehouseCode] [nvarchar](50) NULL,
	[SignDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Address] [nvarchar](50) NULL,
	[StorageFee] [nvarchar](50) NULL,
	[TransferFee] [nvarchar](50) NULL,
	[EntryFee] [nvarchar](50) NULL,
	[Contacter] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[FaxNumber] [nvarchar](50) NULL,
	[SecondContacter] [nvarchar](50) NULL,
	[SecondPhone] [nvarchar](50) NULL,
	[Area] [nvarchar](50) NULL,
	[Note] [nvarchar](1000) NULL,
	[IsFeeDuringPledgeOwnedByUs] [bit] NOT NULL,
	[EnglishAddress] [nvarchar](100) NULL,
	[SpecialWarehouse] [int] NULL,
	[RelatedVirtualWarehouseId] [int] NULL,
 CONSTRAINT [PK_WFWAREHOUSECOMPANY] PRIMARY KEY CLUSTERED 
(
	[WFCompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWarehouseEntryRecord](
	[WFWarehouseEntryRecordId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[CorporationId] [int] NULL,
	[CustomerId] [int] NULL,
	[CommodityId] [int] NULL,
	[TotalWeight] [decimal](18, 8) NULL,
	[ActualWeight] [decimal](18, 8) NULL,
	[UnitId] [int] NOT NULL,
	[WarehouseId] [int] NULL,
	[CreateTime] [datetime] NULL,
	[Creator] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[ExchangeId] [int] NULL,
	[EntryTime] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeliveryOrderCode] [nvarchar](100) NULL,
	[StorageType] [int] NULL,
	[EntryType] [int] NULL,
	[ReceiveType] [smallint] NOT NULL,
	[SalerId] [int] NULL,
	[AccountingEntityId] [int] NULL,
	[ReceiveBillTime] [datetime] NULL,
	[WholeOutEntryUid] [uniqueidentifier] NULL,
	[TradeType] [smallint] NOT NULL,
	[WhStorageType] [smallint] NOT NULL,
	[IsSystemGenerate] [bit] NOT NULL,
	[EntryMapType] [int] NOT NULL,
	[CargoInseparability] [smallint] NOT NULL,
	[AccountingBatchCode] [uniqueidentifier] NULL,
	[TradeContractId] [int] NULL,
	[IsPledgeContract] [bit] NULL,
	[WFDeliveryNotificationId] [int] NULL,
	[ConversionId] [int] NULL,
	[Status] [int] NULL,
	[HappenedPostingWeight] [decimal](18, 8) NULL,
	[IsPosting] [bit] NULL,
	[DetailObjectType] [int] NULL,
	[LastManipulateTime] [datetime] NULL,
	[FirstAffectedDate] [date] NULL,
	[LogisticsCompanyId] [int] NULL,
	[ActualFreightCharges] [decimal](18, 8) NULL,
 CONSTRAINT [WFWarehouseEntryOrder_PK] PRIMARY KEY CLUSTERED 
(
	[WFWarehouseEntryRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWarehouseEntryRecordDetail](
	[WFWarehouseEntryRecordDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFWarehouseEntryRecordId] [int] NULL,
	[CardCode] [nvarchar](50) NULL,
	[BrandId] [int] NULL,
	[SpecificationId] [int] NULL,
	[Volume] [decimal](18, 8) NULL,
	[Weight] [decimal](18, 8) NULL,
	[ActualWeight] [decimal](18, 8) NULL,
	[CreateTime] [datetime] NULL,
	[Creator] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[IsDeleted] [bit] NOT NULL,
	[WholeOutEntryDetailUid] [uniqueidentifier] NULL,
	[AssignedNewFinancialBatchCode] [nvarchar](15) NULL,
 CONSTRAINT [WFWarehouseEntryRecord_PK] PRIMARY KEY CLUSTERED 
(
	[WFWarehouseEntryRecordDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWarehouseOutOrder](
	[WFWarehouseOutOrderId] [int] IDENTITY(1,1) NOT NULL,
	[WFWarehouseOutRecordId] [int] NULL,
	[CorporationId] [int] NULL,
	[CustomerId] [int] NULL,
	[OutDate] [datetime] NULL,
	[TotalVolume] [decimal](18, 8) NULL,
	[TotalWeight] [decimal](18, 8) NULL,
	[UnitId] [int] NOT NULL,
	[WarehouseId] [int] NULL,
	[ReceiverName] [nvarchar](50) NULL,
	[ReceiverIdenityCard] [nvarchar](50) NULL,
	[CreateTime] [datetime] NULL,
	[Creator] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[WeightMemos] [nvarchar](500) NULL,
	[IsSpot] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [WFWarehouseOutOrder_PK] PRIMARY KEY CLUSTERED 
(
	[WFWarehouseOutOrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWarehouseOutRecord](
	[WFWarehouseOutRecordId] [int] IDENTITY(1,1) NOT NULL,
	[CorporationId] [int] NULL,
	[CustomerId] [int] NULL,
	[OutDate] [datetime] NULL,
	[TotalVolume] [decimal](18, 8) NULL,
	[TotalWeight] [decimal](18, 8) NULL,
	[UnitId] [int] NOT NULL,
	[CommodityId] [int] NULL,
	[ActualWeight] [decimal](18, 8) NULL,
	[WarehouseId] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeliveryOrderCode] [nvarchar](100) NULL,
	[Creator] [int] NULL,
	[AccountEntityId] [int] NULL,
	[ReceiverName] [nvarchar](50) NULL,
	[ReceiverIdenityCard] [nvarchar](50) NULL,
	[ReceiverCarNumber] [nvarchar](50) NULL,
	[OutType] [int] NULL,
	[CreateTime] [datetime] NULL,
	[SendType] [smallint] NOT NULL,
	[IsTemphold] [bit] NOT NULL,
	[OpenBillTime] [datetime] NULL,
	[SalerId] [int] NULL,
	[ApprovalStatus] [smallint] NULL,
	[WholeOutEntryUid] [uniqueidentifier] NULL,
	[TradeType] [smallint] NOT NULL,
	[ExchangeId] [int] NULL,
	[WhStorageType] [smallint] NOT NULL,
	[IsSystemGenerate] [bit] NOT NULL,
	[OutMapType] [int] NOT NULL,
	[CargoInseparability] [smallint] NOT NULL,
	[TradeContractId] [int] NULL,
	[IsPledgeContract] [bit] NULL,
	[WFDeliveryNotificationId] [int] NULL,
	[ConversionId] [int] NULL,
	[Status] [int] NULL,
	[HappenedPostingWeight] [decimal](18, 8) NULL,
	[IsPosting] [bit] NULL,
	[DetailObjectType] [int] NULL,
	[LastManipulateTime] [datetime] NULL,
	[FirstAffectedDate] [date] NULL,
	[DeliveryType] [int] NULL,
	[PlaceOfIssue] [nvarchar](50) NULL,
	[PlaceOfDelivery] [nvarchar](50) NULL,
	[LogisticsCompanyId] [int] NULL,
	[ActualFreightCharges] [decimal](18, 8) NULL,
	[ReceiverCompanyId] [int] NULL,
	[ReceiverCompanyName] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFWAREHOUSEOUTRECORD] PRIMARY KEY CLUSTERED 
(
	[WFWarehouseOutRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWarehouseOutRecordDetail](
	[WFWarehouseOutRecordDetailId] [int] IDENTITY(1,1) NOT NULL,
	[WFWarehouseOutRecordId] [int] NULL,
	[CardCode] [nvarchar](50) NULL,
	[BrandId] [int] NULL,
	[SpecificationId] [int] NULL,
	[Volume] [int] NULL,
	[Weight] [decimal](18, 8) NULL,
	[ActualWeight] [decimal](18, 8) NULL,
	[CreateTime] [datetime] NULL,
	[Creator] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[IsClearUp] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[WholeOutEntryDetailUid] [uniqueidentifier] NULL,
	[WFWarehouseStorageId] [int] NULL,
	[AssignedNewFinancialBatchCode] [nvarchar](15) NULL,
 CONSTRAINT [WFWarehouseOutRecord_PK] PRIMARY KEY CLUSTERED 
(
	[WFWarehouseOutRecordDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWarehouseShiftingRecord](
	[WFWarehouseShiftingRecordId] [int] IDENTITY(1,1) NOT NULL,
	[OutRecordId] [int] NULL,
	[EntryRecordId] [int] NULL,
 CONSTRAINT [PK_WFWAREHOUSESHIFTINGRECORD] PRIMARY KEY CLUSTERED 
(
	[WFWarehouseShiftingRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWarehouseStorage](
	[WFWarehouseStorageId] [int] IDENTITY(1,1) NOT NULL,
	[WarehouseId] [int] NULL,
	[PurchaseContractDetailId] [int] NULL,
	[SalerId] [int] NULL,
	[CommodityId] [int] NULL,
	[BrandId] [int] NULL,
	[SpecificationId] [int] NULL,
	[Weight] [decimal](18, 8) NOT NULL,
	[UnitId] [int] NOT NULL,
	[IsSaleOut] [bit] NOT NULL,
	[AailableWeight] [decimal](18, 8) NOT NULL,
	[ExchangeId] [int] NULL,
	[SourceType] [int] NULL,
	[IsPledge] [bit] NOT NULL,
	[CorporationId] [int] NULL,
	[ReceiptQualityStatus] [nvarchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AccountEntityId] [int] NULL,
	[CreatedTime] [datetime] NULL,
	[IsExistedOutsideSystem] [bit] NOT NULL,
	[LossWeight] [decimal](18, 8) NULL,
	[Note] [nvarchar](1000) NULL,
	[IsAllowedEdit] [bit] NOT NULL,
	[IsActualWeight] [bit] NOT NULL,
	[PledgeWeight] [decimal](18, 8) NULL,
	[ActualEntryTime] [datetime] NULL,
	[SavePlaceType] [int] NULL,
	[DeliveryStatusCode] [nvarchar](20) NULL,
	[WhStorageType] [smallint] NULL,
	[SavePlaceIdentity] [nvarchar](30) NULL,
	[IsTemphold] [bit] NOT NULL,
	[TempholdWeight] [decimal](18, 8) NULL,
	[TotalWeight]  AS ([AailableWeight]+case when [TempholdWeight] IS NOT NULL then [TempholdWeight] else (0) end),
	[BatchImportIdentity] [nvarchar](50) NULL,
	[TradeType] [smallint] NOT NULL,
	[WFWarehouseEntryRecordDetailId] [int] NULL,
	[MeasureType] [smallint] NOT NULL,
	[GroupCode] [nvarchar](50) NULL,
	[StorageCode] [nvarchar](50) NULL,
	[GroupDocumentIdentity] [nvarchar](50) NULL,
 CONSTRAINT [WFWarehouseStorage_PK] PRIMARY KEY CLUSTERED 
(
	[WFWarehouseStorageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWarehouseStorageHistory](
	[WFWarehouseStorageHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[StorageDate] [datetime] NOT NULL,
	[CorporationId] [int] NOT NULL,
	[AccountingEntityId] [int] NOT NULL,
	[WarehouseId] [int] NOT NULL,
	[CommodityId] [int] NOT NULL,
	[BrandId] [int] NOT NULL,
	[SpecificationId] [int] NOT NULL,
	[CommodityType] [smallint] NOT NULL,
	[CommodityStatus] [smallint] NOT NULL,
	[LatestModifiedDate] [datetime] NOT NULL,
	[Currency] [nvarchar](50) NULL,
	[Weight] [decimal](38, 18) NOT NULL,
	[ExchangeId] [int] NULL,
	[TradeType] [smallint] NOT NULL,
	[UnitId] [int] NOT NULL,
	[InQuantity] [decimal](18, 8) NULL,
	[OutQuantity] [decimal](18, 8) NULL,
 CONSTRAINT [PK_WFWarehouseStorageHistory] PRIMARY KEY CLUSTERED 
(
	[WFWarehouseStorageHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWarehouseStorageItem](
	[WFWarehouseStorageItemId] [int] IDENTITY(1,1) NOT NULL,
	[WFWarehouseStorageId] [int] NULL,
	[Code] [nvarchar](50) NULL,
	[Weight] [decimal](18, 8) NULL,
	[UnitId] [int] NOT NULL,
	[IsValid] [bit] NOT NULL,
	[StorageStatus] [int] NULL,
	[Note] [nvarchar](1000) NULL,
 CONSTRAINT [PK_WFWAREHOUSESTORAGEITEM] PRIMARY KEY CLUSTERED 
(
	[WFWarehouseStorageItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WFWhStorageFlowTrack](
	[WFWhStorageFlowTrackId] [int] IDENTITY(1,1) NOT NULL,
	[SourceWarehouseStorageId] [int] NULL,
	[TargetWarehouseStorageId] [int] NULL,
	[ObjectId] [int] NULL,
	[ObjectType] [int] NULL,
	[Weight] [decimal](18, 8) NULL,
	[UnitId] [int] NOT NULL,
	[Time] [datetime] NULL,
	[Note] [nvarchar](1000) NULL,
	[IsDeleted] [bit] NOT NULL,
	[ActualWeight] [decimal](18, 8) NULL,
	[DeliveryOrderCode] [nvarchar](100) NULL,
	[LeftPledgedWeight] [decimal](18, 8) NULL,
	[ToWeight] [decimal](18, 8) NULL,
	[ToUnitId] [int] NULL,
	[WFWarehouseOutRecordDetailId] [int] NULL,
	[WhFlowTrackWholeUid] [uniqueidentifier] NULL,
 CONSTRAINT [WFWhStorageFlowTrack_PK] PRIMARY KEY CLUSTERED 
(
	[WFWhStorageFlowTrackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[ViewUnitConversion] (
    FromUnitId
    , ToUnitId
    , FromUnitNumericValue
    , ToUnitNumericValue
    , Note
    , IsReverse
    , WFUnitConversionId 
) 
as 
select 
    FromUnitId
    , ToUnitId
    , FromUnitNumericValue
    , ToUnitNumericValue
    , Note
    , ISNULL(IsReverse, 0) as IsReverse
    , WFUnitConversionId 
from (
select FromUnitId
    , ToUnitId
    , FromUnitNumericValue
    , ToUnitNumericValue
    , Note
    , cast(0 as bit) as IsReverse
    , WFUnitConversionId   
from WFUnitConversion 
union all 
select ToUnitId as FromUnitId
    , FromUnitId as ToUnitId
    , ToUnitNumericValue as FromUnitNumericValue
    , FromUnitNumericValue as ToUnitNumericValue
    , Note
    , cast(1 as bit) as IsReverse
    , WFUnitConversionId   
from WFUnitConversion 
) t0 
where t0.FromUnitId <> t0.ToUnitId 
and exists (select 1 from WFUnit f where f.IsDeleted = 0 and f.QuantityKind not in (2, 4) and f.WFUnitId = t0.FromUnitId) 
and exists (select 1 from WFUnit f where f.IsDeleted = 0 and f.QuantityKind not in (2, 4) and f.WFUnitId = t0.ToUnitId) 

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[ViewUnitConversionUnconfigured] (
    FromUnitId
    , ToUnitId
    , WFUnitConversionId 
)
as 
select FromUnitId
    , ToUnitId 
    , null as WFUnitConversionId
from (
select f.WFUnitId FromUnitId
    , t.WFUnitId ToUnitId 
from WFUnit f, WFUnit t 
where f.WFUnitId <> t.WFUnitId 
and f.QuantityKind = t.QuantityKind 
and f.QuantityKind not in (2, 4) 
and f.IsDeleted = 0 
and t.IsDeleted = 0 
except 
select FromUnitId
    , ToUnitId 
from ViewUnitConversion 
) t0
union all 
select FromUnitId
    , ToUnitId 
    , WFUnitConversionId
from ViewUnitConversion 
where FromUnitNumericValue = 0 or ToUnitNumericValue = 0 

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[ViewExchangeRate](
    WFExchangeRateId
    , FromCurrencyId
    , ToCurrencyId
    , FromCurrencyAmount
    , ToCurrencyAmount
    , WFCurrencyPairId
    , PriceDate
    , LastModifiedTime
    , DatasourceType
    , DatasourceId     
) 
as 
select r.WFExchangeRateId
    , p.BaseCurrencyId
    , p.CounterCurrencyId
    , r.BaseUnitAmount
    , r.CounterAmount 
    , p.WFCurrencyPairId
    , r.PriceDate
    , r.LastModifiedTime
    , r.DatasourceType
    , r.DatasourceId     
from WFExchangeRate r, WFCurrencyPair p 
where r.WFCurrencyPairId = p.WFCurrencyPairId 
union all 
select r.WFExchangeRateId
    , p.CounterCurrencyId
    , p.BaseCurrencyId
    , r.CounterAmount 
    , r.BaseUnitAmount 
    , p.WFCurrencyPairId
    , r.PriceDate
    , r.LastModifiedTime
    , r.DatasourceType
    , r.DatasourceId     
from WFExchangeRate r, WFCurrencyPair p 
where r.WFCurrencyPairId = p.WFCurrencyPairId 

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- tmpl 模板 结束 


-- view 开始 

CREATE VIEW [dbo].[ViewWFPledgeInfo]
AS 
SELECT P.[WFPledgeInfoId]
,P.[CustomerId]
,P.[CorporationId]
,P.[UnitId]
,P.[CurrencyId]
,P.[CommodityId]
,P.[TotalWeight]
,P.[PledgeRate]
,P.[PledgeWeight]
,P.[Price]
,P.[PledgeAmount]
,P.[PledgeInterestRate]
,P.[PledgeInterest]
,P.[IsUnPledgeFinished]
,P.[PledgeStartDate]
,P.[PledgeEndDate]
,P.[RequestorId]
,P.[ExcutorId]
,P.[Note]
,P.[LastModifiedTime]
,P.[IsDeleted]
,P.[PledgeType]
,P.[AccountEntityId]
,P.[IsSpotPledge]
,P.[ThirdPartyCustomer]
,P.[PurchaseContractId]
,P.[IsFeeDuringPledgeOwnedByUs]
,AE.Name as AccountingEntity
,CT.AccountingName as Commodity
,CU.Name as Currency
,CO.ShortName as Corporation 
FROM [WFPledgeInfo] as P 
LEFT JOIN [WFAccountEntity] as AE ON P.AccountEntityId = AE.WFAccountEntityId
LEFT JOIN [WFCommodity] as CM ON P.CommodityId = CM.WFCommodityId
LEFT JOIN [WFCommodityType] as CT ON CT.WFCommodityTypeId = CM.WFCommodityTypeId
LEFT JOIN [WFCurrency] as CU ON P.CurrencyId = CU.WFCurrencyId
LEFT JOIN [WFCompany] as CO ON P.CorporationId = CO.WFCompanyId
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ViewWFUnPledgeInfo]
AS 
SELECT UP.[WFUnPledgeInfoId]
,UP.[WFPledgeInfoId]
,UP.[CustomerId]
,UP.[CorporationId]
,UP.[UnitId]
,UP.[CurrencyId]
,UP.[CommodityId]
,UP.[TotalWeight]
,UP.[PledgeRate]
,UP.[PledgeWeight]
,UP.[Price]
,UP.[PledgeAmount]
,UP.[PledgeInterestRate]
,UP.[PledgeInterest]
,UP.[UnPledgeDate]
,UP.[RequestorId]
,UP.[ExcutorId]
,UP.[Note]
,UP.[LastModifiedTime]
,UP.[IsDeleted]
,UP.[AccountEntityId]
,UP.[IsUnpledgeSpot]
,AE.Name as AccountingEntity
,CT.AccountingName as Commodity
,CU.Name as Currency
,CO.ShortName as Corporation 
FROM [WFUnPledgeInfo] as UP 
LEFT JOIN [WFAccountEntity] as AE ON UP.AccountEntityId = AE.WFAccountEntityId
LEFT JOIN [WFCommodity] as CM ON UP.CommodityId = CM.WFCommodityId
LEFT JOIN [WFCommodityType] as CT ON CT.WFCommodityTypeId = CM.WFCommodityTypeId
LEFT JOIN [WFCurrency] as CU ON UP.CurrencyId = CU.WFCurrencyId
LEFT JOIN [WFCompany] as CO ON UP.CorporationId = CO.WFCompanyId
GO
CREATE NONCLUSTERED INDEX [WFWarehouseEntryRecordDetailId_IDX] ON [dbo].[WFContractEntryRecordDetail]
(
	[WFWarehouseEntryRecordDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WFWarehouseOutRecordDetailId_IDX] ON [dbo].[WFContractOutRecordDetail]
(
	[WFWarehouseOutRecordDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [FinancialBatchCode_idx] ON [dbo].[WFFinancialBatch]
(
	[FinancialBatchCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WFFinancialBatchId_idx] ON [dbo].[WFFinancialBatchInventory]
(
	[WFFinancialBatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WFWarehouseStorageId_idx] ON [dbo].[WFFinancialBatchInventory]
(
	[WFWarehouseStorageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WFWarehouseEntryRecordId_IDX] ON [dbo].[WFWarehouseEntryRecordDetail]
(
	[WFWarehouseEntryRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [WFWarehouseOutRecordId_IDX] ON [dbo].[WFWarehouseOutRecordDetail]
(
	[WFWarehouseOutRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SourceWarehouseStorageId_idx] ON [dbo].[WFWhStorageFlowTrack]
(
	[SourceWarehouseStorageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TargetWarehouseStorageId_idx] ON [dbo].[WFWhStorageFlowTrack]
(
	[TargetWarehouseStorageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OnlineTime] ADD  DEFAULT ((1)) FOR [Type]
GO
ALTER TABLE [dbo].[SyncSpotTrade] ADD  DEFAULT ((0)) FOR [RecordStatus]
GO
ALTER TABLE [dbo].[SyncSpotTrade] ADD  DEFAULT ((0)) FOR [Unavailable]
GO
ALTER TABLE [dbo].[WFAccountEntity] ADD  DEFAULT ((0)) FOR [IsAccounting]
GO
ALTER TABLE [dbo].[WFAccountEntity] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFAmountRecord] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFAmountRecord] ADD  DEFAULT ((1)) FOR [PayPurposeType]
GO
ALTER TABLE [dbo].[WFAmountRecord] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFAmountRecord] ADD  DEFAULT ((1)) FOR [DetailObjectType]
GO
ALTER TABLE [dbo].[WFAmountRecordDetail] ADD  DEFAULT ((1)) FOR [ObjectType]
GO
ALTER TABLE [dbo].[WFBillContentArchive] ADD  DEFAULT ((1)) FOR [BillContentType]
GO
ALTER TABLE [dbo].[WFBillTemplate] ADD  DEFAULT ((0)) FOR [TemplateFileType]
GO
ALTER TABLE [dbo].[WFBrand] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFCardCodeInfo] ADD  DEFAULT ((0)) FOR [WarehouseId]
GO
ALTER TABLE [dbo].[WFCardCodeInfo] ADD  DEFAULT ((0)) FOR [UserId]
GO
ALTER TABLE [dbo].[WFCardCodeInfo] ADD  DEFAULT ((0)) FOR [CorporationId]
GO
ALTER TABLE [dbo].[WFCardCodeInfo] ADD  DEFAULT ((0)) FOR [Used]
GO
ALTER TABLE [dbo].[WFCommodity] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFCommodity] ADD  DEFAULT ((0)) FOR [OrderIndex]
GO
ALTER TABLE [dbo].[WFCommodityType] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFCommodityType] ADD  DEFAULT ((0)) FOR [OrderIndex]
GO
ALTER TABLE [dbo].[WFCompany] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFCompanyBankInfo] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFContact] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFContractBillArchive] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFContractBillArchive] ADD  DEFAULT ((1)) FOR [BillType]
GO
ALTER TABLE [dbo].[WFContractBillArchiveDetail] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFContractFee] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFContractFee] ADD  DEFAULT ((0)) FOR [IsAdjust]
GO
ALTER TABLE [dbo].[WFContractFee] ADD  DEFAULT ((0)) FOR [IsSystemAutoGenerate]
GO
ALTER TABLE [dbo].[WFContractFee] ADD  DEFAULT ((0)) FOR [HasPaid]
GO
ALTER TABLE [dbo].[WFContractFee] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFContractInfo] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFContractInfo] ADD  DEFAULT ((0)) FOR [NeedPayTransferFee]
GO
ALTER TABLE [dbo].[WFContractInfo] ADD  DEFAULT ((1)) FOR [TransactionType]
GO
ALTER TABLE [dbo].[WFContractInfo] ADD  DEFAULT ((0)) FOR [AccountPeriod]
GO
ALTER TABLE [dbo].[WFContractInfo] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFContractInfo] ADD  DEFAULT ((0)) FOR [IsAmountIncludeDiscountCost]
GO
ALTER TABLE [dbo].[WFContractWhole] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFCostPayRecord] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFCostPayRecord] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFCostPayRequest] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFCostPayRequest] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFCreditRating] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFCreditRating] ADD  DEFAULT ((0)) FOR [IsBuy]
GO
ALTER TABLE [dbo].[WFCreditRatingDetail] ADD  DEFAULT ((4)) FOR [CreditRatingDetailType]
GO
ALTER TABLE [dbo].[WFCurrency] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFCustomerCommodity] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFDefaultExchangeSetting] ADD  DEFAULT ((1)) FOR [DefaultBaseUnitAmount]
GO
ALTER TABLE [dbo].[WFDeliveryContract] ADD  DEFAULT ((1)) FOR [IsStandard]
GO
ALTER TABLE [dbo].[WFDeliveryNotification] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFDeliveryNotification] ADD  DEFAULT (getdate()) FOR [CreateTime]
GO
ALTER TABLE [dbo].[WFDeliveryNotification] ADD  DEFAULT ((0)) FOR [IsPrePicking]
GO
ALTER TABLE [dbo].[WFDeliveryNotificationDetail] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFDeliveryNotificationDetail] ADD  DEFAULT (getdate()) FOR [CreateTime]
GO
ALTER TABLE [dbo].[WFExchangeBill] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFExchangeRate] ADD  DEFAULT ((1)) FOR [BaseUnitAmount]
GO
ALTER TABLE [dbo].[WFFeeRecord] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFFeeRecord] ADD  DEFAULT ((0)) FOR [HasPaid]
GO
ALTER TABLE [dbo].[WFFeeRecord] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFFirePriceConfirm] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFFirePriceDetail] ADD  DEFAULT ((0)) FOR [IsPostponed]
GO
ALTER TABLE [dbo].[WFFirePriceDetail] ADD  DEFAULT ((0)) FOR [IsSwap]
GO
ALTER TABLE [dbo].[WFFirePriceDetail] ADD  DEFAULT ((1)) FOR [PricingType]
GO
ALTER TABLE [dbo].[WFFirePricePostponeConfirm] ADD  DEFAULT ((1)) FOR [CurrencyId]
GO
ALTER TABLE [dbo].[WFFirePriceRecord] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFFirePriceRecord] ADD  DEFAULT ((1)) FOR [PricingType]
GO
ALTER TABLE [dbo].[WFGeneralModification] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFGeneralModification] ADD  DEFAULT ((0)) FOR [Applied]
GO
ALTER TABLE [dbo].[WFInstrument] ADD  DEFAULT ((1)) FOR [InstrumentType]
GO
ALTER TABLE [dbo].[WFInvoiceRecord] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFInvoiceRecord] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFInvoiceRecord] ADD  DEFAULT ((1)) FOR [IsAmountIncludeDiscountCost]
GO
ALTER TABLE [dbo].[WFInvoiceRequest] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFInvoiceRequest] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFLetterOfCredit] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFOtherBill] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFOtherBill] ADD  CONSTRAINT [DF_WFOtherBill_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFOutRecordAssistantMeasureInfo] ADD  DEFAULT ((1)) FOR [SubMeasureType]
GO
ALTER TABLE [dbo].[WFPayRequest] ADD  CONSTRAINT [DF__WFPayRequ__IsDel__3CC16359]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFPayRequest] ADD  CONSTRAINT [DF__WFPayRequ__PayPu__2E933F93]  DEFAULT ((1)) FOR [PayPurposeType]
GO
ALTER TABLE [dbo].[WFPayRequest] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFPayRequest] ADD  DEFAULT ((1)) FOR [DetailObjectType]
GO
ALTER TABLE [dbo].[WFPayRequestDetail] ADD  DEFAULT ((1)) FOR [ObjectType]
GO
ALTER TABLE [dbo].[WFPledgeInfo] ADD  DEFAULT ((0)) FOR [IsSpotPledge]
GO
ALTER TABLE [dbo].[WFPledgeInfo] ADD  DEFAULT ((0)) FOR [IsFeeDuringPledgeOwnedByUs]
GO
ALTER TABLE [dbo].[WFPledgeInfo] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFPledgeRenewal] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFPriceConfirmationLetter] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFPriceDetail] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFPriceInfo] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFRoleInfo] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFSettlementRequest] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFSettlementRequest] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFSettleOption] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFSettleOptionDetail] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFSpecification] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFSpotReceiptConvertInfo] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFStorageAssistantMeasureInfo] ADD  DEFAULT ((1)) FOR [SubMeasureType]
GO
ALTER TABLE [dbo].[WFTradeCalendar] ADD  DEFAULT ((1)) FOR [IsTradeDay]
GO
ALTER TABLE [dbo].[WFUnit] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFUnit] ADD  DEFAULT ((1)) FOR [QuantityKind]
GO
ALTER TABLE [dbo].[WFUnPledgeInfo] ADD  DEFAULT ((0)) FOR [IsUnpledgeSpot]
GO
ALTER TABLE [dbo].[WFUnPledgeInfo] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFUser] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFUser] ADD  DEFAULT ((7)) FOR [NotifyingAgents]
GO
ALTER TABLE [dbo].[WFUserMessage] ADD  DEFAULT ((0)) FOR [IsRead]
GO
ALTER TABLE [dbo].[WFUserMessage] ADD  DEFAULT ((10)) FOR [Priority]
GO
ALTER TABLE [dbo].[WFUserMessage] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFUserRequest] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFUserTask] ADD  DEFAULT ((0)) FOR [IsFinished]
GO
ALTER TABLE [dbo].[WFUserTask] ADD  DEFAULT ((20)) FOR [Priority]
GO
ALTER TABLE [dbo].[WFUserTask] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFWarehouseCardCodePrefix] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFWarehouseCompany] ADD  DEFAULT ((0)) FOR [IsFeeDuringPledgeOwnedByUs]
GO
ALTER TABLE [dbo].[WFWarehouseEntryRecord] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFWarehouseEntryRecord] ADD  DEFAULT ((4)) FOR [ReceiveType]
GO
ALTER TABLE [dbo].[WFWarehouseEntryRecord] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFWarehouseEntryRecord] ADD  DEFAULT ((0)) FOR [WhStorageType]
GO
ALTER TABLE [dbo].[WFWarehouseEntryRecordDetail] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFWarehouseOutOrder] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFWarehouseOutRecord] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFWarehouseOutRecord] ADD  DEFAULT ((4)) FOR [SendType]
GO
ALTER TABLE [dbo].[WFWarehouseOutRecord] ADD  DEFAULT ((0)) FOR [IsTemphold]
GO
ALTER TABLE [dbo].[WFWarehouseOutRecord] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFWarehouseOutRecord] ADD  DEFAULT ((0)) FOR [WhStorageType]
GO
ALTER TABLE [dbo].[WFWarehouseOutRecordDetail] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFWarehouseStorage] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[WFWarehouseStorage] ADD  DEFAULT ((0)) FOR [IsTemphold]
GO
ALTER TABLE [dbo].[WFWarehouseStorage] ADD  DEFAULT ((1)) FOR [TradeType]
GO
ALTER TABLE [dbo].[WFWarehouseStorage] ADD  DEFAULT ((2)) FOR [MeasureType]
GO
ALTER TABLE [dbo].[WFAccountingDataLogDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFACCOUNTINGDATALOGDETAIL_REFERENCE_87_WFACCOUNTINGDATALOG] FOREIGN KEY([AccountingDataLogId])
REFERENCES [dbo].[WFAccountingDataLog] ([AccountingDataLogId])
GO
ALTER TABLE [dbo].[WFAccountingDataLogDetail] CHECK CONSTRAINT [FK_WFACCOUNTINGDATALOGDETAIL_REFERENCE_87_WFACCOUNTINGDATALOG]
GO
ALTER TABLE [dbo].[WFActualApprovalStep]  WITH CHECK ADD  CONSTRAINT [FK_WFACTUALAPPROVALSTEP_REFERENCE_127_WFACTUALAPPROVALWF] FOREIGN KEY([WFActualApprovalWFId])
REFERENCES [dbo].[WFActualApprovalWF] ([WFActualApprovalWFId])
GO
ALTER TABLE [dbo].[WFActualApprovalStep] CHECK CONSTRAINT [FK_WFACTUALAPPROVALSTEP_REFERENCE_127_WFACTUALAPPROVALWF]
GO
ALTER TABLE [dbo].[WFActualApprovalStep]  WITH CHECK ADD  CONSTRAINT [FK_WFACTUALAPPROVALSTEP_REFERENCE_141_WFACTUALAPPROVER] FOREIGN KEY([WFActualApproverId])
REFERENCES [dbo].[WFActualApprover] ([WFActualApproverId])
GO
ALTER TABLE [dbo].[WFActualApprovalStep] CHECK CONSTRAINT [FK_WFACTUALAPPROVALSTEP_REFERENCE_141_WFACTUALAPPROVER]
GO
ALTER TABLE [dbo].[WFActualApprovalStepUser]  WITH CHECK ADD  CONSTRAINT [FK_WFACTUALAPPROVALSTEPUSER_REFERENCE_134_WFACTUALAPPROVALSTEP] FOREIGN KEY([WFActualApprovalStepId])
REFERENCES [dbo].[WFActualApprovalStep] ([WFActualApprovalStepId])
GO
ALTER TABLE [dbo].[WFActualApprovalStepUser] CHECK CONSTRAINT [FK_WFACTUALAPPROVALSTEPUSER_REFERENCE_134_WFACTUALAPPROVALSTEP]
GO
ALTER TABLE [dbo].[WFActualStepCondition]  WITH CHECK ADD  CONSTRAINT [FK_WFACTUALSTEPCONDITION_REFERENCE_128_WFACTUALAPPROVALSTEP] FOREIGN KEY([SourceWFActualApprovalStepId])
REFERENCES [dbo].[WFActualApprovalStep] ([WFActualApprovalStepId])
GO
ALTER TABLE [dbo].[WFActualStepCondition] CHECK CONSTRAINT [FK_WFACTUALSTEPCONDITION_REFERENCE_128_WFACTUALAPPROVALSTEP]
GO
ALTER TABLE [dbo].[WFActualStepCondition]  WITH CHECK ADD  CONSTRAINT [FK_WFACTUALSTEPCONDITION_REFERENCE_129_WFACTUALAPPROVALSTEP] FOREIGN KEY([TargetWFActualApprovalStepId])
REFERENCES [dbo].[WFActualApprovalStep] ([WFActualApprovalStepId])
GO
ALTER TABLE [dbo].[WFActualStepCondition] CHECK CONSTRAINT [FK_WFACTUALSTEPCONDITION_REFERENCE_129_WFACTUALAPPROVALSTEP]
GO
ALTER TABLE [dbo].[WFActuaStepAction]  WITH CHECK ADD  CONSTRAINT [FK_WFACTUASTEPACTION_REFERENCE_139_WFACTUALAPPROVALSTEP] FOREIGN KEY([WFActualApprovalStepId])
REFERENCES [dbo].[WFActualApprovalStep] ([WFActualApprovalStepId])
GO
ALTER TABLE [dbo].[WFActuaStepAction] CHECK CONSTRAINT [FK_WFACTUASTEPACTION_REFERENCE_139_WFACTUALAPPROVALSTEP]
GO
ALTER TABLE [dbo].[WFActuaStepAction]  WITH CHECK ADD  CONSTRAINT [FK_WFACTUASTEPACTION_REFERENCE_140_WFACTUALAPPROVER] FOREIGN KEY([WFActualApproverId])
REFERENCES [dbo].[WFActualApprover] ([WFActualApproverId])
GO
ALTER TABLE [dbo].[WFActuaStepAction] CHECK CONSTRAINT [FK_WFACTUASTEPACTION_REFERENCE_140_WFACTUALAPPROVER]
GO
ALTER TABLE [dbo].[WFAggregateBillDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_WFAggregateBillDetail_REFERENCE_WFAggregateBill] FOREIGN KEY([WFAggregateBillId])
REFERENCES [dbo].[WFAggregateBill] ([WFAggregateBillId])
GO
ALTER TABLE [dbo].[WFAggregateBillDetail] CHECK CONSTRAINT [FK_WFAggregateBillDetail_REFERENCE_WFAggregateBill]
GO
ALTER TABLE [dbo].[WFAmountRecord]  WITH CHECK ADD  CONSTRAINT [FK_WFAMOUNT_REFERENCE_WFRECEIVINGCLAIM] FOREIGN KEY([WFReceivingClaimId])
REFERENCES [dbo].[WFReceivingClaim] ([WFReceivingClaimId])
GO
ALTER TABLE [dbo].[WFAmountRecord] CHECK CONSTRAINT [FK_WFAMOUNT_REFERENCE_WFRECEIVINGCLAIM]
GO
ALTER TABLE [dbo].[WFAmountRecord]  WITH CHECK ADD  CONSTRAINT [FK_WFAmountRecord_REFERENCE_WFExchangeBill] FOREIGN KEY([WFExchangeBillId])
REFERENCES [dbo].[WFExchangeBill] ([WFExchangeBillId])
GO
ALTER TABLE [dbo].[WFAmountRecord] CHECK CONSTRAINT [FK_WFAmountRecord_REFERENCE_WFExchangeBill]
GO
ALTER TABLE [dbo].[WFAmountRecord]  WITH CHECK ADD  CONSTRAINT [FK_WFAmountRecord_REFERENCE_WFPaymentProposal] FOREIGN KEY([WFPaymentProposalId])
REFERENCES [dbo].[WFPaymentProposal] ([WFPaymentProposalId])
GO
ALTER TABLE [dbo].[WFAmountRecord] CHECK CONSTRAINT [FK_WFAmountRecord_REFERENCE_WFPaymentProposal]
GO
ALTER TABLE [dbo].[WFAmountRecord]  WITH CHECK ADD  CONSTRAINT [WFPayRequest_WFAmountRecord_FK1] FOREIGN KEY([WFPayRequestId])
REFERENCES [dbo].[WFPayRequest] ([WFPayRequestId])
GO
ALTER TABLE [dbo].[WFAmountRecord] CHECK CONSTRAINT [WFPayRequest_WFAmountRecord_FK1]
GO
ALTER TABLE [dbo].[WFAmountRecordDetail]  WITH CHECK ADD  CONSTRAINT [WFAmountRecord_WFAmountRecordDetail_FK1] FOREIGN KEY([WFAmountRecordId])
REFERENCES [dbo].[WFAmountRecord] ([WFAmountRecordId])
GO
ALTER TABLE [dbo].[WFAmountRecordDetail] CHECK CONSTRAINT [WFAmountRecord_WFAmountRecordDetail_FK1]
GO
ALTER TABLE [dbo].[WFAmountRecordDetail]  WITH CHECK ADD  CONSTRAINT [WFContractInfo_WFAmountRecordDetail_FK1] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFAmountRecordDetail] CHECK CONSTRAINT [WFContractInfo_WFAmountRecordDetail_FK1]
GO
ALTER TABLE [dbo].[WFAmountRecordSubDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFAmountRecordSubDetail_REFERENCE_WFAmountRecordDetail] FOREIGN KEY([WFAmountRecordDetailId])
REFERENCES [dbo].[WFAmountRecordDetail] ([WFAmountRecordDetailId])
GO
ALTER TABLE [dbo].[WFAmountRecordSubDetail] CHECK CONSTRAINT [FK_WFAmountRecordSubDetail_REFERENCE_WFAmountRecordDetail]
GO
ALTER TABLE [dbo].[WFApprovalAttachment]  WITH CHECK ADD  CONSTRAINT [FK_WFAPPROVALATTACHMENT_REFERENCE_126_WFACTUALAPPROVALWF] FOREIGN KEY([WFActualApprovalWFId])
REFERENCES [dbo].[WFActualApprovalWF] ([WFActualApprovalWFId])
GO
ALTER TABLE [dbo].[WFApprovalAttachment] CHECK CONSTRAINT [FK_WFAPPROVALATTACHMENT_REFERENCE_126_WFACTUALAPPROVALWF]
GO
ALTER TABLE [dbo].[WFApprovalConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WFApprovalConfiguration_REFERENCE_WFCondition] FOREIGN KEY([WFConditionId])
REFERENCES [dbo].[WFCondition] ([WFConditionId])
GO
ALTER TABLE [dbo].[WFApprovalConfiguration] CHECK CONSTRAINT [FK_WFApprovalConfiguration_REFERENCE_WFCondition]
GO
ALTER TABLE [dbo].[WFApprovalWorkflowLog]  WITH CHECK ADD  CONSTRAINT [FK_WFAPPROVALWORKFLOWLOG_REFERENCE_130_WFACTUALAPPROVALSTEP] FOREIGN KEY([WFActualApprovalStepId])
REFERENCES [dbo].[WFActualApprovalStep] ([WFActualApprovalStepId])
GO
ALTER TABLE [dbo].[WFApprovalWorkflowLog] CHECK CONSTRAINT [FK_WFAPPROVALWORKFLOWLOG_REFERENCE_130_WFACTUALAPPROVALSTEP]
GO
ALTER TABLE [dbo].[WFApprovalWorkflowStepTemplate]  WITH CHECK ADD  CONSTRAINT [FK_WFAPPROVALWORKFLOWSTEPTEMPLA_REFERENCE_121_WFAPPROVALWORKFLOWTEMPLATE] FOREIGN KEY([WFApprovalWorkflowTemplateId])
REFERENCES [dbo].[WFApprovalWorkflowTemplate] ([WFApprovalWorkflowTemplateId])
GO
ALTER TABLE [dbo].[WFApprovalWorkflowStepTemplate] CHECK CONSTRAINT [FK_WFAPPROVALWORKFLOWSTEPTEMPLA_REFERENCE_121_WFAPPROVALWORKFLOWTEMPLATE]
GO
ALTER TABLE [dbo].[WFApprovalWorkflowStepTemplate]  WITH CHECK ADD  CONSTRAINT [FK_WFAPPROVALWORKFLOWSTEPTEMPLA_REFERENCE_138_WFAPPROVERTEMPLATE] FOREIGN KEY([WFApproverTemplateId])
REFERENCES [dbo].[WFApproverTemplate] ([WFApproverTemplateId])
GO
ALTER TABLE [dbo].[WFApprovalWorkflowStepTemplate] CHECK CONSTRAINT [FK_WFAPPROVALWORKFLOWSTEPTEMPLA_REFERENCE_138_WFAPPROVERTEMPLATE]
GO
ALTER TABLE [dbo].[WFApprovalWorkflowTemplateRole]  WITH CHECK ADD  CONSTRAINT [FK_WFAPPROVALUSER_REFERENCE_135_WFAPPROVERTEMPLATE] FOREIGN KEY([WFApproverTemplateId])
REFERENCES [dbo].[WFApproverTemplate] ([WFApproverTemplateId])
GO
ALTER TABLE [dbo].[WFApprovalWorkflowTemplateRole] CHECK CONSTRAINT [FK_WFAPPROVALUSER_REFERENCE_135_WFAPPROVERTEMPLATE]
GO
ALTER TABLE [dbo].[WFApprovalWorkflowTemplateRole]  WITH CHECK ADD  CONSTRAINT [FK_WFAPPROVALUSER_REFERENCE_151_WFAPPROVALWORKFLOWTEMPLATE] FOREIGN KEY([WFApprovalWorkflowTemplateId])
REFERENCES [dbo].[WFApprovalWorkflowTemplate] ([WFApprovalWorkflowTemplateId])
GO
ALTER TABLE [dbo].[WFApprovalWorkflowTemplateRole] CHECK CONSTRAINT [FK_WFAPPROVALUSER_REFERENCE_151_WFAPPROVALWORKFLOWTEMPLATE]
GO
ALTER TABLE [dbo].[WFAuthorizationContent]  WITH CHECK ADD  CONSTRAINT [FK_WFAUTHORIZATIONCONTENT_REFERENCE_154_WFAUTHORIZATION] FOREIGN KEY([WFAuthorizationId])
REFERENCES [dbo].[WFAuthorization] ([WFAuthorizationId])
GO
ALTER TABLE [dbo].[WFAuthorizationContent] CHECK CONSTRAINT [FK_WFAUTHORIZATIONCONTENT_REFERENCE_154_WFAUTHORIZATION]
GO
ALTER TABLE [dbo].[WFAvgPriceDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFAVGPRI_REFERENCE_WFPRICED] FOREIGN KEY([WFPriceDetailId])
REFERENCES [dbo].[WFPriceDetail] ([WFPriceDetailId])
GO
ALTER TABLE [dbo].[WFAvgPriceDetail] CHECK CONSTRAINT [FK_WFAVGPRI_REFERENCE_WFPRICED]
GO
ALTER TABLE [dbo].[WFBillContentArchive]  WITH CHECK ADD  CONSTRAINT [FK_WFBILLCO_REFERENCE_WFBILLTE] FOREIGN KEY([WFBillTemplateId])
REFERENCES [dbo].[WFBillTemplate] ([WFBillTemplateId])
GO
ALTER TABLE [dbo].[WFBillContentArchive] CHECK CONSTRAINT [FK_WFBILLCO_REFERENCE_WFBILLTE]
GO
ALTER TABLE [dbo].[WFBillContentPrint]  WITH CHECK ADD  CONSTRAINT [FK_WFBillContentPrint_REFERENCE_WFBillContentArchive] FOREIGN KEY([WFBillContentArchiveId])
REFERENCES [dbo].[WFBillContentArchive] ([WFBillContentArchiveId])
GO
ALTER TABLE [dbo].[WFBillContentPrint] CHECK CONSTRAINT [FK_WFBillContentPrint_REFERENCE_WFBillContentArchive]
GO
ALTER TABLE [dbo].[WFBrand]  WITH CHECK ADD  CONSTRAINT [WFCommodity_WFBrand_FK1] FOREIGN KEY([WFCommodityId])
REFERENCES [dbo].[WFCommodity] ([WFCommodityId])
GO
ALTER TABLE [dbo].[WFBrand] CHECK CONSTRAINT [WFCommodity_WFBrand_FK1]
GO
ALTER TABLE [dbo].[WFBusiness]  WITH CHECK ADD  CONSTRAINT [FK_WFBUSINE_REFERENCE_WFCOMPAN] FOREIGN KEY([CorporationId])
REFERENCES [dbo].[WFCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFBusiness] CHECK CONSTRAINT [FK_WFBUSINE_REFERENCE_WFCOMPAN]
GO
ALTER TABLE [dbo].[WFBusiness]  WITH CHECK ADD  CONSTRAINT [FK_WFCOMMODITYACCOUNTENTITY_REFERENCE_149_WFCOMMODITY] FOREIGN KEY([WFCommodityId])
REFERENCES [dbo].[WFCommodity] ([WFCommodityId])
GO
ALTER TABLE [dbo].[WFBusiness] CHECK CONSTRAINT [FK_WFCOMMODITYACCOUNTENTITY_REFERENCE_149_WFCOMMODITY]
GO
ALTER TABLE [dbo].[WFBusiness]  WITH CHECK ADD  CONSTRAINT [FK_WFCOMMODITYACCOUNTENTITY_REFERENCE_150_WFACCOUNTENTITY] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[WFAccountEntity] ([WFAccountEntityId])
GO
ALTER TABLE [dbo].[WFBusiness] CHECK CONSTRAINT [FK_WFCOMMODITYACCOUNTENTITY_REFERENCE_150_WFACCOUNTENTITY]
GO
ALTER TABLE [dbo].[WFBusinessBillTemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_WFBusinessBillTemplate_REFERENCE_WFBillTemplate] FOREIGN KEY([WFBillTemplateId])
REFERENCES [dbo].[WFBillTemplate] ([WFBillTemplateId])
GO
ALTER TABLE [dbo].[WFBusinessBillTemplate] CHECK CONSTRAINT [FK_WFBusinessBillTemplate_REFERENCE_WFBillTemplate]
GO
ALTER TABLE [dbo].[WFBusinessBillTemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_WFBusinessBillTemplate_REFERENCE_WFCondition] FOREIGN KEY([WFConditionId])
REFERENCES [dbo].[WFCondition] ([WFConditionId])
GO
ALTER TABLE [dbo].[WFBusinessBillTemplate] CHECK CONSTRAINT [FK_WFBusinessBillTemplate_REFERENCE_WFCondition]
GO
ALTER TABLE [dbo].[WFBuyContractTradeRecord]  WITH NOCHECK ADD  CONSTRAINT [FK_WFBUYCONTRACTTRADERECORD_REFERENCE_58_WFCONTRACTENTRYRECORDDETAIL] FOREIGN KEY([WFContractEntryRecordDetailId])
REFERENCES [dbo].[WFContractEntryRecordDetail] ([WFContractEntryRecordDetailId])
GO
ALTER TABLE [dbo].[WFBuyContractTradeRecord] CHECK CONSTRAINT [FK_WFBUYCONTRACTTRADERECORD_REFERENCE_58_WFCONTRACTENTRYRECORDDETAIL]
GO
ALTER TABLE [dbo].[WFBuyContractTradeRecord]  WITH NOCHECK ADD  CONSTRAINT [FK_WFBUYCONTRACTTRADERECORD_REFERENCE_68_WFCONTRACTDETAILINFO] FOREIGN KEY([WFContractDetailInfoId])
REFERENCES [dbo].[WFContractDetailInfo] ([WFContractDetailInfoId])
GO
ALTER TABLE [dbo].[WFBuyContractTradeRecord] CHECK CONSTRAINT [FK_WFBUYCONTRACTTRADERECORD_REFERENCE_68_WFCONTRACTDETAILINFO]
GO
ALTER TABLE [dbo].[WFBuyContractTradeRecord]  WITH NOCHECK ADD  CONSTRAINT [FK_WFBuyContractTradeRecord_REFERENCE_WFFinalPrice] FOREIGN KEY([WFFinalPriceId])
REFERENCES [dbo].[WFFinalPrice] ([WFFinalPriceId])
GO
ALTER TABLE [dbo].[WFBuyContractTradeRecord] CHECK CONSTRAINT [FK_WFBuyContractTradeRecord_REFERENCE_WFFinalPrice]
GO
ALTER TABLE [dbo].[WFCodeCustomization]  WITH CHECK ADD  CONSTRAINT [FK_WFCodeCustomization_REFERENCE_WFCodeTemplateDetail] FOREIGN KEY([WFCodeTemplateDetailId])
REFERENCES [dbo].[WFCodeTemplateDetail] ([WFCodeTemplateDetailId])
GO
ALTER TABLE [dbo].[WFCodeCustomization] CHECK CONSTRAINT [FK_WFCodeCustomization_REFERENCE_WFCodeTemplateDetail]
GO
ALTER TABLE [dbo].[WFCodeTemplateDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFCodeTemplateDetail_REFERENCE_WFCodeTemplate] FOREIGN KEY([WFCodeTemplateId])
REFERENCES [dbo].[WFCodeTemplate] ([WFCodeTemplateId])
GO
ALTER TABLE [dbo].[WFCodeTemplateDetail] CHECK CONSTRAINT [FK_WFCodeTemplateDetail_REFERENCE_WFCodeTemplate]
GO
ALTER TABLE [dbo].[WFCommercialInvoice]  WITH CHECK ADD  CONSTRAINT [FK_WFCommercialInvoice_REFERENCE_WFContractInfo] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFCommercialInvoice] CHECK CONSTRAINT [FK_WFCommercialInvoice_REFERENCE_WFContractInfo]
GO
ALTER TABLE [dbo].[WFCommercialInvoice]  WITH CHECK ADD  CONSTRAINT [FK_WFCommercialInvoice_REFERENCE_WFExchangeRate] FOREIGN KEY([PaymentExchangeRateId])
REFERENCES [dbo].[WFExchangeRate] ([WFExchangeRateId])
GO
ALTER TABLE [dbo].[WFCommercialInvoice] CHECK CONSTRAINT [FK_WFCommercialInvoice_REFERENCE_WFExchangeRate]
GO
ALTER TABLE [dbo].[WFCommercialInvoice]  WITH CHECK ADD  CONSTRAINT [FK_WFCommercialInvoice_REFERENCE_WFInvoiceRecord] FOREIGN KEY([WFInvoiceRecordId])
REFERENCES [dbo].[WFInvoiceRecord] ([WFInvoiceRecordId])
GO
ALTER TABLE [dbo].[WFCommercialInvoice] CHECK CONSTRAINT [FK_WFCommercialInvoice_REFERENCE_WFInvoiceRecord]
GO
ALTER TABLE [dbo].[WFCommercialInvoice]  WITH CHECK ADD  CONSTRAINT [K_WFCommercialInvoice_REFERENCE_WFCommercialInvoice_Final] FOREIGN KEY([FinalInvoiceRecordId])
REFERENCES [dbo].[WFCommercialInvoice] ([WFInvoiceRecordId])
GO
ALTER TABLE [dbo].[WFCommercialInvoice] CHECK CONSTRAINT [K_WFCommercialInvoice_REFERENCE_WFCommercialInvoice_Final]
GO
ALTER TABLE [dbo].[WFCommodity]  WITH CHECK ADD  CONSTRAINT [FK_WFCOMMODITY_REFERENCE_66_WFCOMMODITYTYPE] FOREIGN KEY([WFCommodityTypeId])
REFERENCES [dbo].[WFCommodityType] ([WFCommodityTypeId])
GO
ALTER TABLE [dbo].[WFCommodity] CHECK CONSTRAINT [FK_WFCOMMODITY_REFERENCE_66_WFCOMMODITYTYPE]
GO
ALTER TABLE [dbo].[WFCommodity]  WITH CHECK ADD  CONSTRAINT [FK_WFCommodity_REFERENCE_WFQuantityType] FOREIGN KEY([MainQuantityId])
REFERENCES [dbo].[WFQuantityType] ([WFQuantityTypeId])
GO
ALTER TABLE [dbo].[WFCommodity] CHECK CONSTRAINT [FK_WFCommodity_REFERENCE_WFQuantityType]
GO
ALTER TABLE [dbo].[WFCommodityQuantityUnit]  WITH CHECK ADD  CONSTRAINT [FK_WFCommodityQuantityUnit_REFERENCE_WFCommodity] FOREIGN KEY([WFCommodityId])
REFERENCES [dbo].[WFCommodity] ([WFCommodityId])
GO
ALTER TABLE [dbo].[WFCommodityQuantityUnit] CHECK CONSTRAINT [FK_WFCommodityQuantityUnit_REFERENCE_WFCommodity]
GO
ALTER TABLE [dbo].[WFCommodityQuantityUnit]  WITH CHECK ADD  CONSTRAINT [FK_WFCommodityQuantityUnit_REFERENCE_WFQuantityType] FOREIGN KEY([WFQuantityTypeId])
REFERENCES [dbo].[WFQuantityType] ([WFQuantityTypeId])
GO
ALTER TABLE [dbo].[WFCommodityQuantityUnit] CHECK CONSTRAINT [FK_WFCommodityQuantityUnit_REFERENCE_WFQuantityType]
GO
ALTER TABLE [dbo].[WFCommodityQuantityUnit]  WITH CHECK ADD  CONSTRAINT [FK_WFCommodityQuantityUnit_REFERENCE_WFUnit] FOREIGN KEY([WFUnitId])
REFERENCES [dbo].[WFUnit] ([WFUnitId])
GO
ALTER TABLE [dbo].[WFCommodityQuantityUnit] CHECK CONSTRAINT [FK_WFCommodityQuantityUnit_REFERENCE_WFUnit]
GO
ALTER TABLE [dbo].[WFCompany]  WITH CHECK ADD  CONSTRAINT [FK_WFCOMPAN_REFERENCE_WFCOMPAN] FOREIGN KEY([GroupId])
REFERENCES [dbo].[WFCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFCompany] CHECK CONSTRAINT [FK_WFCOMPAN_REFERENCE_WFCOMPAN]
GO
ALTER TABLE [dbo].[WFCompany]  WITH CHECK ADD  CONSTRAINT [FK_WFCOMPANY_REFERENCE_159_WFCREDITRATING] FOREIGN KEY([BuyWFCreditRatingId])
REFERENCES [dbo].[WFCreditRating] ([WFCreditRatingId])
GO
ALTER TABLE [dbo].[WFCompany] CHECK CONSTRAINT [FK_WFCOMPANY_REFERENCE_159_WFCREDITRATING]
GO
ALTER TABLE [dbo].[WFCompany]  WITH CHECK ADD  CONSTRAINT [FK_WFCOMPANY_REFERENCE_166_WFCREDITRATING] FOREIGN KEY([SaleWFCreditRatingId])
REFERENCES [dbo].[WFCreditRating] ([WFCreditRatingId])
GO
ALTER TABLE [dbo].[WFCompany] CHECK CONSTRAINT [FK_WFCOMPANY_REFERENCE_166_WFCREDITRATING]
GO
ALTER TABLE [dbo].[WFCompanyBankInfo]  WITH CHECK ADD  CONSTRAINT [WFCompany_WFCompanyBankInfo_FK1] FOREIGN KEY([WFCompanyId])
REFERENCES [dbo].[WFCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFCompanyBankInfo] CHECK CONSTRAINT [WFCompany_WFCompanyBankInfo_FK1]
GO
ALTER TABLE [dbo].[WFCompanyBankInfoCommodityAccountEntity]  WITH CHECK ADD  CONSTRAINT [FK_WFCBCD_WFCommodityAccountEn] FOREIGN KEY([WFBusinessId])
REFERENCES [dbo].[WFBusiness] ([WFBusinessId])
GO
ALTER TABLE [dbo].[WFCompanyBankInfoCommodityAccountEntity] CHECK CONSTRAINT [FK_WFCBCD_WFCommodityAccountEn]
GO
ALTER TABLE [dbo].[WFCompanyBankInfoCommodityAccountEntity]  WITH CHECK ADD  CONSTRAINT [FK_WFCBCD_WFCompanyBankInfo] FOREIGN KEY([WFCompanyBankInfoId])
REFERENCES [dbo].[WFCompanyBankInfo] ([WFCompanyBankInfoId])
GO
ALTER TABLE [dbo].[WFCompanyBankInfoCommodityAccountEntity] CHECK CONSTRAINT [FK_WFCBCD_WFCompanyBankInfo]
GO
ALTER TABLE [dbo].[WFCompanyBusiness]  WITH NOCHECK ADD  CONSTRAINT [FK_WFCB_REFERENCE_WFCOMPAN] FOREIGN KEY([WFCompanyId])
REFERENCES [dbo].[WFCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFCompanyBusiness] CHECK CONSTRAINT [FK_WFCB_REFERENCE_WFCOMPAN]
GO
ALTER TABLE [dbo].[WFCompanyBusiness]  WITH NOCHECK ADD  CONSTRAINT [FK_WFCOMPAN_REFERENCE_WFBUSINE] FOREIGN KEY([WFBusinessId])
REFERENCES [dbo].[WFBusiness] ([WFBusinessId])
GO
ALTER TABLE [dbo].[WFCompanyBusiness] CHECK CONSTRAINT [FK_WFCOMPAN_REFERENCE_WFBUSINE]
GO
ALTER TABLE [dbo].[WFCompanySAPCode]  WITH CHECK ADD  CONSTRAINT [FK_WFCompanySAPCode_REFERENCE_WFCompany] FOREIGN KEY([WFCompanyId])
REFERENCES [dbo].[WFCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFCompanySAPCode] CHECK CONSTRAINT [FK_WFCompanySAPCode_REFERENCE_WFCompany]
GO
ALTER TABLE [dbo].[WFContact]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTAC_REFERENCE_WFCOMPAN] FOREIGN KEY([WFCompanyId])
REFERENCES [dbo].[WFCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFContact] CHECK CONSTRAINT [FK_WFCONTAC_REFERENCE_WFCOMPAN]
GO
ALTER TABLE [dbo].[WFContactCommodityAccountEntity]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTAC_REFERENCE_WFCOMMOD] FOREIGN KEY([WFBusinessId])
REFERENCES [dbo].[WFBusiness] ([WFBusinessId])
GO
ALTER TABLE [dbo].[WFContactCommodityAccountEntity] CHECK CONSTRAINT [FK_WFCONTAC_REFERENCE_WFCOMMOD]
GO
ALTER TABLE [dbo].[WFContactCommodityAccountEntity]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTAC_REFERENCE_WFCONTAC] FOREIGN KEY([WFContactId])
REFERENCES [dbo].[WFContact] ([WFContactId])
GO
ALTER TABLE [dbo].[WFContactCommodityAccountEntity] CHECK CONSTRAINT [FK_WFCONTAC_REFERENCE_WFCONTAC]
GO
ALTER TABLE [dbo].[WFContractBillArchiveDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRACTBILLARCHIVEDETAIL_REFERENCE_84_WFCONTRACTBILLARCHIVE] FOREIGN KEY([WFContractBillArchiveId])
REFERENCES [dbo].[WFContractBillArchive] ([WFContractBillArchiveId])
GO
ALTER TABLE [dbo].[WFContractBillArchiveDetail] CHECK CONSTRAINT [FK_WFCONTRACTBILLARCHIVEDETAIL_REFERENCE_84_WFCONTRACTBILLARCHIVE]
GO
ALTER TABLE [dbo].[WFContractBillArchiveLinker]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRACTBILLARCHIVELINKER_REFERENCE_105_WFCONTRACTBILLARCHIVE] FOREIGN KEY([WFBillArchiveId])
REFERENCES [dbo].[WFContractBillArchive] ([WFContractBillArchiveId])
GO
ALTER TABLE [dbo].[WFContractBillArchiveLinker] CHECK CONSTRAINT [FK_WFCONTRACTBILLARCHIVELINKER_REFERENCE_105_WFCONTRACTBILLARCHIVE]
GO
ALTER TABLE [dbo].[WFContractBillArchiveLinker]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRACTBILLARCHIVELINKER_REFERENCE_106_WFCONTRACTINFO] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFContractBillArchiveLinker] CHECK CONSTRAINT [FK_WFCONTRACTBILLARCHIVELINKER_REFERENCE_106_WFCONTRACTINFO]
GO
ALTER TABLE [dbo].[WFContractComment]  WITH NOCHECK ADD  CONSTRAINT [WFContractInfo_WFContractComment_FK1] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFContractComment] CHECK CONSTRAINT [WFContractInfo_WFContractComment_FK1]
GO
ALTER TABLE [dbo].[WFContractCustomer]  WITH CHECK ADD  CONSTRAINT [WFContractInfo_WFContractCustomer_FK1] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFContractCustomer] CHECK CONSTRAINT [WFContractInfo_WFContractCustomer_FK1]
GO
ALTER TABLE [dbo].[WFContractDetailInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRD_REFERENCE_WFPRICEI] FOREIGN KEY([WFPriceInfoId])
REFERENCES [dbo].[WFPriceInfo] ([WFPriceInfoId])
GO
ALTER TABLE [dbo].[WFContractDetailInfo] CHECK CONSTRAINT [FK_WFCONTRD_REFERENCE_WFPRICEI]
GO
ALTER TABLE [dbo].[WFContractDetailInfo]  WITH CHECK ADD  CONSTRAINT [WFContractInfo_WFContractDetailInfo_FK1] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFContractDetailInfo] CHECK CONSTRAINT [WFContractInfo_WFContractDetailInfo_FK1]
GO
ALTER TABLE [dbo].[WFContractEntryRecordDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_WFCONTRACTENTRYRECORDDETAIL_FK_WFCONTRACTENTRYR_WFWAREHOUSEENTRYRECORDDETAIL] FOREIGN KEY([WFWarehouseEntryRecordDetailId])
REFERENCES [dbo].[WFWarehouseEntryRecordDetail] ([WFWarehouseEntryRecordDetailId])
GO
ALTER TABLE [dbo].[WFContractEntryRecordDetail] CHECK CONSTRAINT [FK_WFCONTRACTENTRYRECORDDETAIL_FK_WFCONTRACTENTRYR_WFWAREHOUSEENTRYRECORDDETAIL]
GO
ALTER TABLE [dbo].[WFContractEntryRecordDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_WFCONTRACTENTRYRECORDDETAIL_REFERENCE_70_WFCONTRACTDETAILINFO] FOREIGN KEY([WFContractDetailInfoId])
REFERENCES [dbo].[WFContractDetailInfo] ([WFContractDetailInfoId])
GO
ALTER TABLE [dbo].[WFContractEntryRecordDetail] CHECK CONSTRAINT [FK_WFCONTRACTENTRYRECORDDETAIL_REFERENCE_70_WFCONTRACTDETAILINFO]
GO
ALTER TABLE [dbo].[WFContractFee]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRA_REFERENCE_WFCONTRA] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFContractFee] CHECK CONSTRAINT [FK_WFCONTRA_REFERENCE_WFCONTRA]
GO
ALTER TABLE [dbo].[WFContractFee]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRA_REFERENCE_WFFEEREC] FOREIGN KEY([WFFeeRecordId])
REFERENCES [dbo].[WFFeeRecord] ([WFFeeRecordId])
GO
ALTER TABLE [dbo].[WFContractFee] CHECK CONSTRAINT [FK_WFCONTRA_REFERENCE_WFFEEREC]
GO
ALTER TABLE [dbo].[WFContractFee]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRA_REFERENCE_WFSYSTEM] FOREIGN KEY([WFSystemFeeId])
REFERENCES [dbo].[WFSystemFee] ([WFSystemFeeId])
GO
ALTER TABLE [dbo].[WFContractFee] CHECK CONSTRAINT [FK_WFCONTRA_REFERENCE_WFSYSTEM]
GO
ALTER TABLE [dbo].[WFContractInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRA_REFERENCE_WFCONTRACTWHOLE] FOREIGN KEY([WFContractWholeId])
REFERENCES [dbo].[WFContractWhole] ([WFContractWholeId])
GO
ALTER TABLE [dbo].[WFContractInfo] CHECK CONSTRAINT [FK_WFCONTRA_REFERENCE_WFCONTRACTWHOLE]
GO
ALTER TABLE [dbo].[WFContractInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRA_REFERENCE_WFPRICEI] FOREIGN KEY([WFPriceInfoId])
REFERENCES [dbo].[WFPriceInfo] ([WFPriceInfoId])
GO
ALTER TABLE [dbo].[WFContractInfo] CHECK CONSTRAINT [FK_WFCONTRA_REFERENCE_WFPRICEI]
GO
ALTER TABLE [dbo].[WFContractInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRACTINFO_REFERENCE_78_WFLONGCONTRACT] FOREIGN KEY([WFLongContractId])
REFERENCES [dbo].[WFLongContract] ([WFLongContractId])
GO
ALTER TABLE [dbo].[WFContractInfo] CHECK CONSTRAINT [FK_WFCONTRACTINFO_REFERENCE_78_WFLONGCONTRACT]
GO
ALTER TABLE [dbo].[WFContractInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRACTINFO_REFERENCE_80_WFDELIVERYCONTRACT] FOREIGN KEY([WFDeliveryContractId])
REFERENCES [dbo].[WFDeliveryContract] ([WFDeliveryContractId])
GO
ALTER TABLE [dbo].[WFContractInfo] CHECK CONSTRAINT [FK_WFCONTRACTINFO_REFERENCE_80_WFDELIVERYCONTRACT]
GO
ALTER TABLE [dbo].[WFContractInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRACTINFO_REFERENCE_86_WFLONGCONTRACTDETAIL] FOREIGN KEY([WFLongContractDetailId])
REFERENCES [dbo].[WFLongContractDetail] ([WFLongContractDetailId])
GO
ALTER TABLE [dbo].[WFContractInfo] CHECK CONSTRAINT [FK_WFCONTRACTINFO_REFERENCE_86_WFLONGCONTRACTDETAIL]
GO
ALTER TABLE [dbo].[WFContractInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFContractInfo_REFERENCE_WFSettleOption] FOREIGN KEY([WFSettleOptionId])
REFERENCES [dbo].[WFSettleOption] ([WFSettleOptionId])
GO
ALTER TABLE [dbo].[WFContractInfo] CHECK CONSTRAINT [FK_WFContractInfo_REFERENCE_WFSettleOption]
GO
ALTER TABLE [dbo].[WFContractInvoice]  WITH CHECK ADD  CONSTRAINT [WFContractInfo_WFContractInvoice_FK1] FOREIGN KEY([WFContractDetailInfoId])
REFERENCES [dbo].[WFContractDetailInfo] ([WFContractDetailInfoId])
GO
ALTER TABLE [dbo].[WFContractInvoice] CHECK CONSTRAINT [WFContractInfo_WFContractInvoice_FK1]
GO
ALTER TABLE [dbo].[WFContractInvoice]  WITH CHECK ADD  CONSTRAINT [WFInvoiceRecord_WFContractInvoice_FK1] FOREIGN KEY([WFInvoiceRecordId])
REFERENCES [dbo].[WFInvoiceRecord] ([WFInvoiceRecordId])
GO
ALTER TABLE [dbo].[WFContractInvoice] CHECK CONSTRAINT [WFInvoiceRecord_WFContractInvoice_FK1]
GO
ALTER TABLE [dbo].[WFContractLog]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRACTLOG_REFERENCE_74_WFCONTRACTINFO] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFContractLog] CHECK CONSTRAINT [FK_WFCONTRACTLOG_REFERENCE_74_WFCONTRACTINFO]
GO
ALTER TABLE [dbo].[WFContractOutRecordDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_WFCONTRACTOUTRECORDDETAIL_REFERENCE_71_WFCONTRACTDETAILINFO] FOREIGN KEY([WFContractDetailInfoId])
REFERENCES [dbo].[WFContractDetailInfo] ([WFContractDetailInfoId])
GO
ALTER TABLE [dbo].[WFContractOutRecordDetail] CHECK CONSTRAINT [FK_WFCONTRACTOUTRECORDDETAIL_REFERENCE_71_WFCONTRACTDETAILINFO]
GO
ALTER TABLE [dbo].[WFContractOutRecordDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_WFCONTRACTOUTRECORDDETAIL_REFERENCE_72_WFWAREHOUSEOUTRECORDDETAIL] FOREIGN KEY([WFWarehouseOutRecordDetailId])
REFERENCES [dbo].[WFWarehouseOutRecordDetail] ([WFWarehouseOutRecordDetailId])
GO
ALTER TABLE [dbo].[WFContractOutRecordDetail] CHECK CONSTRAINT [FK_WFCONTRACTOUTRECORDDETAIL_REFERENCE_72_WFWAREHOUSEOUTRECORDDETAIL]
GO
ALTER TABLE [dbo].[WFContractSecondPart]  WITH CHECK ADD  CONSTRAINT [FK_WFCONTRACT2NDPART_WFCONTRAC] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFContractSecondPart] CHECK CONSTRAINT [FK_WFCONTRACT2NDPART_WFCONTRAC]
GO
ALTER TABLE [dbo].[WFCorporationApprovalWFTemplate]  WITH CHECK ADD  CONSTRAINT [FK_WFCORPORATIONAPPROVALWFTEMPL_REFERENCE_122_WFCOMPANY] FOREIGN KEY([WFCompanyId])
REFERENCES [dbo].[WFCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFCorporationApprovalWFTemplate] CHECK CONSTRAINT [FK_WFCORPORATIONAPPROVALWFTEMPL_REFERENCE_122_WFCOMPANY]
GO
ALTER TABLE [dbo].[WFCorporationApprovalWFTemplate]  WITH CHECK ADD  CONSTRAINT [FK_WFCORPORATIONAPPROVALWFTEMPL_REFERENCE_131_WFAPPROVALWORKFLOWTEMPLATE] FOREIGN KEY([WFApprovalWorkflowTemplateId])
REFERENCES [dbo].[WFApprovalWorkflowTemplate] ([WFApprovalWorkflowTemplateId])
GO
ALTER TABLE [dbo].[WFCorporationApprovalWFTemplate] CHECK CONSTRAINT [FK_WFCORPORATIONAPPROVALWFTEMPL_REFERENCE_131_WFAPPROVALWORKFLOWTEMPLATE]
GO
ALTER TABLE [dbo].[WFCorporationApprovalWFTemplate]  WITH CHECK ADD  CONSTRAINT [FK_WFCorporationApprovalWFTemplate_REFERENCE_WFCondition] FOREIGN KEY([WFConditionId])
REFERENCES [dbo].[WFCondition] ([WFConditionId])
GO
ALTER TABLE [dbo].[WFCorporationApprovalWFTemplate] CHECK CONSTRAINT [FK_WFCorporationApprovalWFTemplate_REFERENCE_WFCondition]
GO
ALTER TABLE [dbo].[WFCorporationDepartment]  WITH CHECK ADD  CONSTRAINT [FK_WFCORPORATIONDEPARTMENT_REFERENCE_170_WFACCOUNTENTITY] FOREIGN KEY([WFAccountEntityId])
REFERENCES [dbo].[WFAccountEntity] ([WFAccountEntityId])
GO
ALTER TABLE [dbo].[WFCorporationDepartment] CHECK CONSTRAINT [FK_WFCORPORATIONDEPARTMENT_REFERENCE_170_WFACCOUNTENTITY]
GO
ALTER TABLE [dbo].[WFCorporationTypeConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WFCorporationTypeConfiguration_REFERENCE_WFCompany] FOREIGN KEY([WFCompanyId])
REFERENCES [dbo].[WFCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFCorporationTypeConfiguration] CHECK CONSTRAINT [FK_WFCorporationTypeConfiguration_REFERENCE_WFCompany]
GO
ALTER TABLE [dbo].[WFCorporationTypeFinancing]  WITH CHECK ADD  CONSTRAINT [FK_WFCorporationTypeFinancing_REFERENCE_WFCorporationTypeConfiguration] FOREIGN KEY([WFCorporationTypeConfigurationId])
REFERENCES [dbo].[WFCorporationTypeConfiguration] ([WFCorporationTypeConfigurationId])
GO
ALTER TABLE [dbo].[WFCorporationTypeFinancing] CHECK CONSTRAINT [FK_WFCorporationTypeFinancing_REFERENCE_WFCorporationTypeConfiguration]
GO
ALTER TABLE [dbo].[WFCorporationTypeMarket]  WITH CHECK ADD  CONSTRAINT [FK_WFCorporationTypeMarket_REFERENCE_WFCorporationTypeConfiguration] FOREIGN KEY([WFCorporationTypeConfigurationId])
REFERENCES [dbo].[WFCorporationTypeConfiguration] ([WFCorporationTypeConfigurationId])
GO
ALTER TABLE [dbo].[WFCorporationTypeMarket] CHECK CONSTRAINT [FK_WFCorporationTypeMarket_REFERENCE_WFCorporationTypeConfiguration]
GO
ALTER TABLE [dbo].[WFCostPayRecord]  WITH CHECK ADD  CONSTRAINT [FK_WFCOSTPAYRECORD_REFERENCE_107_WFCOSTPAYREQUEST] FOREIGN KEY([WFCostPayRequestId])
REFERENCES [dbo].[WFCostPayRequest] ([WFCostPayRequestId])
GO
ALTER TABLE [dbo].[WFCostPayRecord] CHECK CONSTRAINT [FK_WFCOSTPAYRECORD_REFERENCE_107_WFCOSTPAYREQUEST]
GO
ALTER TABLE [dbo].[WFCostPrice]  WITH CHECK ADD  CONSTRAINT [FK_WFCOSTPRICE_REFERENCE_57_WFBUYCONTRACTTRADERECORD] FOREIGN KEY([WFBuyContractTradeRecordId])
REFERENCES [dbo].[WFBuyContractTradeRecord] ([WFBuyContractTradeRecordId])
GO
ALTER TABLE [dbo].[WFCostPrice] CHECK CONSTRAINT [FK_WFCOSTPRICE_REFERENCE_57_WFBUYCONTRACTTRADERECORD]
GO
ALTER TABLE [dbo].[WFCostPrice]  WITH CHECK ADD  CONSTRAINT [FK_WFCOSTPRICE_REFERENCE_62_WFSALECONTRACTTRADERECORD] FOREIGN KEY([WFSaleContractTradeRecordId])
REFERENCES [dbo].[WFSaleContractTradeRecord] ([WFSaleContractTradeRecordId])
GO
ALTER TABLE [dbo].[WFCostPrice] CHECK CONSTRAINT [FK_WFCOSTPRICE_REFERENCE_62_WFSALECONTRACTTRADERECORD]
GO
ALTER TABLE [dbo].[WFCreditRatingDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFCREDIT_REFERENCE_WFCOMMOD] FOREIGN KEY([WFCommodityId])
REFERENCES [dbo].[WFCommodity] ([WFCommodityId])
GO
ALTER TABLE [dbo].[WFCreditRatingDetail] CHECK CONSTRAINT [FK_WFCREDIT_REFERENCE_WFCOMMOD]
GO
ALTER TABLE [dbo].[WFCreditRatingDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFCREDIT_REFERENCE_WFCREDIT] FOREIGN KEY([WFCreditRatingId])
REFERENCES [dbo].[WFCreditRating] ([WFCreditRatingId])
GO
ALTER TABLE [dbo].[WFCreditRatingDetail] CHECK CONSTRAINT [FK_WFCREDIT_REFERENCE_WFCREDIT]
GO
ALTER TABLE [dbo].[WFCustomerCommodity]  WITH CHECK ADD  CONSTRAINT [FK_WFCUSTOMERCOMMODITY_REFERENCE_103_WFCOMPANY] FOREIGN KEY([WFCompanyId])
REFERENCES [dbo].[WFCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFCustomerCommodity] CHECK CONSTRAINT [FK_WFCUSTOMERCOMMODITY_REFERENCE_103_WFCOMPANY]
GO
ALTER TABLE [dbo].[WFCustomerCommodity]  WITH CHECK ADD  CONSTRAINT [FK_WFCUSTOMERCOMMODITY_REFERENCE_104_WFCOMMODITY] FOREIGN KEY([WFCommodityId])
REFERENCES [dbo].[WFCommodity] ([WFCommodityId])
GO
ALTER TABLE [dbo].[WFCustomerCommodity] CHECK CONSTRAINT [FK_WFCUSTOMERCOMMODITY_REFERENCE_104_WFCOMMODITY]
GO
ALTER TABLE [dbo].[WFCustomerCommodity]  WITH CHECK ADD  CONSTRAINT [FK_WFCUSTOMERCOMMODITY_REFERENCE_158_WFCREDITRATING] FOREIGN KEY([BuyWFCreditRatingId])
REFERENCES [dbo].[WFCreditRating] ([WFCreditRatingId])
GO
ALTER TABLE [dbo].[WFCustomerCommodity] CHECK CONSTRAINT [FK_WFCUSTOMERCOMMODITY_REFERENCE_158_WFCREDITRATING]
GO
ALTER TABLE [dbo].[WFCustomerCommodity]  WITH CHECK ADD  CONSTRAINT [FK_WFCUSTOMERCOMMODITY_REFERENCE_167_WFCREDITRATING] FOREIGN KEY([SaleWFCreditRatingId])
REFERENCES [dbo].[WFCreditRating] ([WFCreditRatingId])
GO
ALTER TABLE [dbo].[WFCustomerCommodity] CHECK CONSTRAINT [FK_WFCUSTOMERCOMMODITY_REFERENCE_167_WFCREDITRATING]
GO
ALTER TABLE [dbo].[WFDefaultExchangeSetting]  WITH CHECK ADD  CONSTRAINT [FK_WFDefaultExchangeSetting_REFERENCE_WFCurrencyPair] FOREIGN KEY([WFCurrencyPairId])
REFERENCES [dbo].[WFCurrencyPair] ([WFCurrencyPairId])
GO
ALTER TABLE [dbo].[WFDefaultExchangeSetting] CHECK CONSTRAINT [FK_WFDefaultExchangeSetting_REFERENCE_WFCurrencyPair]
GO
ALTER TABLE [dbo].[WFDeliveryNotificationDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFDeliveryNotificationDetail_REFERENCE_WFDeliveryNotification] FOREIGN KEY([WFDeliveryNotificationId])
REFERENCES [dbo].[WFDeliveryNotification] ([WFDeliveryNotificationId])
GO
ALTER TABLE [dbo].[WFDeliveryNotificationDetail] CHECK CONSTRAINT [FK_WFDeliveryNotificationDetail_REFERENCE_WFDeliveryNotification]
GO
ALTER TABLE [dbo].[WFDeliveryNotificationObject]  WITH CHECK ADD  CONSTRAINT [FK_WFDeliveryNotificationObject_REFERENCE_WFDeliveryNotificationDetail] FOREIGN KEY([WFDeliveryNotificationDetailId])
REFERENCES [dbo].[WFDeliveryNotificationDetail] ([WFDeliveryNotificationDetailId])
GO
ALTER TABLE [dbo].[WFDeliveryNotificationObject] CHECK CONSTRAINT [FK_WFDeliveryNotificationObject_REFERENCE_WFDeliveryNotificationDetail]
GO
ALTER TABLE [dbo].[WFDepartmentAccountEntity]  WITH CHECK ADD  CONSTRAINT [FK_WFDEPARTMENTACCOUNTENTITY_REFERENCE_152_WFACCOUNTENTITY] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[WFAccountEntity] ([WFAccountEntityId])
GO
ALTER TABLE [dbo].[WFDepartmentAccountEntity] CHECK CONSTRAINT [FK_WFDEPARTMENTACCOUNTENTITY_REFERENCE_152_WFACCOUNTENTITY]
GO
ALTER TABLE [dbo].[WFDepartmentAccountEntity]  WITH CHECK ADD  CONSTRAINT [FK_WFDEPARTMENTACCOUNTENTITY_REFERENCE_153_WFACCOUNTENTITY] FOREIGN KEY([AccountEntityId])
REFERENCES [dbo].[WFAccountEntity] ([WFAccountEntityId])
GO
ALTER TABLE [dbo].[WFDepartmentAccountEntity] CHECK CONSTRAINT [FK_WFDEPARTMENTACCOUNTENTITY_REFERENCE_153_WFACCOUNTENTITY]
GO
ALTER TABLE [dbo].[WFDepositContract]  WITH CHECK ADD  CONSTRAINT [FK_WFDepositContract_REFERENCE_WFDeposit] FOREIGN KEY([WFDepositId])
REFERENCES [dbo].[WFDeposit] ([WFDepositId])
GO
ALTER TABLE [dbo].[WFDepositContract] CHECK CONSTRAINT [FK_WFDepositContract_REFERENCE_WFDeposit]
GO
ALTER TABLE [dbo].[WFEntityProperty]  WITH CHECK ADD  CONSTRAINT [FK_WFEntityProperty_REFERENCE_WFEntityPropertyType] FOREIGN KEY([WFEntityPropertyTypeId])
REFERENCES [dbo].[WFEntityPropertyType] ([WFEntityPropertyTypeId])
GO
ALTER TABLE [dbo].[WFEntityProperty] CHECK CONSTRAINT [FK_WFEntityProperty_REFERENCE_WFEntityPropertyType]
GO
ALTER TABLE [dbo].[WFEntitySapPart]  WITH CHECK ADD  CONSTRAINT [FK_WFEntitySapPart_REFERENCE_WFSapTransaction] FOREIGN KEY([CurrentSapTransactionId])
REFERENCES [dbo].[WFSapTransaction] ([WFSapTransactionId])
GO
ALTER TABLE [dbo].[WFEntitySapPart] CHECK CONSTRAINT [FK_WFEntitySapPart_REFERENCE_WFSapTransaction]
GO
ALTER TABLE [dbo].[WFExchangeBill]  WITH CHECK ADD  CONSTRAINT [FK_WFExchangeBill_REFERENCE_WFLetterOfCredit] FOREIGN KEY([WFLetterOfCreditId])
REFERENCES [dbo].[WFLetterOfCredit] ([WFLetterOfCreditId])
GO
ALTER TABLE [dbo].[WFExchangeBill] CHECK CONSTRAINT [FK_WFExchangeBill_REFERENCE_WFLetterOfCredit]
GO
ALTER TABLE [dbo].[WFExchangeRate]  WITH CHECK ADD  CONSTRAINT [FK_WFExchangeRate_REFERENCE_WFCurrencyPair] FOREIGN KEY([WFCurrencyPairId])
REFERENCES [dbo].[WFCurrencyPair] ([WFCurrencyPairId])
GO
ALTER TABLE [dbo].[WFExchangeRate] CHECK CONSTRAINT [FK_WFExchangeRate_REFERENCE_WFCurrencyPair]
GO
ALTER TABLE [dbo].[WFFeeRecord]  WITH CHECK ADD  CONSTRAINT [FK_WFFEERECORD_REFERENCE_115_WFSYSTEMFEE] FOREIGN KEY([WFSystemFeeId])
REFERENCES [dbo].[WFSystemFee] ([WFSystemFeeId])
GO
ALTER TABLE [dbo].[WFFeeRecord] CHECK CONSTRAINT [FK_WFFEERECORD_REFERENCE_115_WFSYSTEMFEE]
GO
ALTER TABLE [dbo].[WFFinalPrice]  WITH CHECK ADD  CONSTRAINT [FK_WFFinalPrice_REFERENCE_WFPriceDetail] FOREIGN KEY([WFPriceDetailId])
REFERENCES [dbo].[WFPriceDetail] ([WFPriceDetailId])
GO
ALTER TABLE [dbo].[WFFinalPrice] CHECK CONSTRAINT [FK_WFFinalPrice_REFERENCE_WFPriceDetail]
GO
ALTER TABLE [dbo].[WFFinancialBatch]  WITH CHECK ADD  CONSTRAINT [FK_WFFinancialBatch_REFERENCE_WFFinancialBatch] FOREIGN KEY([PrecursorFinancialBatchId])
REFERENCES [dbo].[WFFinancialBatch] ([WFFinancialBatchId])
GO
ALTER TABLE [dbo].[WFFinancialBatch] CHECK CONSTRAINT [FK_WFFinancialBatch_REFERENCE_WFFinancialBatch]
GO
ALTER TABLE [dbo].[WFFinancialBatchInventory]  WITH NOCHECK ADD  CONSTRAINT [FK_WFFinancialBatchInventory_REFERENCE_WFFinancialBatch] FOREIGN KEY([WFFinancialBatchId])
REFERENCES [dbo].[WFFinancialBatch] ([WFFinancialBatchId])
GO
ALTER TABLE [dbo].[WFFinancialBatchInventory] CHECK CONSTRAINT [FK_WFFinancialBatchInventory_REFERENCE_WFFinancialBatch]
GO
ALTER TABLE [dbo].[WFFinancialBatchInventory]  WITH NOCHECK ADD  CONSTRAINT [FK_WFFinancialBatchInventory_REFERENCE_WFWarehouseStorage] FOREIGN KEY([WFWarehouseStorageId])
REFERENCES [dbo].[WFWarehouseStorage] ([WFWarehouseStorageId])
GO
ALTER TABLE [dbo].[WFFinancialBatchInventory] CHECK CONSTRAINT [FK_WFFinancialBatchInventory_REFERENCE_WFWarehouseStorage]
GO
ALTER TABLE [dbo].[WFFinancialBatchOutDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_WFFinancialBatchOutDetail_REFERENCE_WFContractOutRecordDetail] FOREIGN KEY([WFContractOutRecordDetailId])
REFERENCES [dbo].[WFContractOutRecordDetail] ([WFContractOutRecordDetailId])
GO
ALTER TABLE [dbo].[WFFinancialBatchOutDetail] CHECK CONSTRAINT [FK_WFFinancialBatchOutDetail_REFERENCE_WFContractOutRecordDetail]
GO
ALTER TABLE [dbo].[WFFinancialBatchOutDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_WFFinancialBatchOutDetail_REFERENCE_WFFinancialBatch] FOREIGN KEY([WFFinancialBatchId])
REFERENCES [dbo].[WFFinancialBatch] ([WFFinancialBatchId])
GO
ALTER TABLE [dbo].[WFFinancialBatchOutDetail] CHECK CONSTRAINT [FK_WFFinancialBatchOutDetail_REFERENCE_WFFinancialBatch]
GO
ALTER TABLE [dbo].[WFFinancialBatchOutDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_WFFinancialBatchOutDetail_REFERENCE_WFWarehouseOutRecordDetail] FOREIGN KEY([WFWarehouseOutRecordDetailId])
REFERENCES [dbo].[WFWarehouseOutRecordDetail] ([WFWarehouseOutRecordDetailId])
GO
ALTER TABLE [dbo].[WFFinancialBatchOutDetail] CHECK CONSTRAINT [FK_WFFinancialBatchOutDetail_REFERENCE_WFWarehouseOutRecordDetail]
GO
ALTER TABLE [dbo].[WFFirePriceConfirm]  WITH CHECK ADD  CONSTRAINT [FK_WFFPC_REFERENCE_WFPRICED] FOREIGN KEY([WFPriceDetailId])
REFERENCES [dbo].[WFPriceDetail] ([WFPriceDetailId])
GO
ALTER TABLE [dbo].[WFFirePriceConfirm] CHECK CONSTRAINT [FK_WFFPC_REFERENCE_WFPRICED]
GO
ALTER TABLE [dbo].[WFFirePriceDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFFIREPR_REFERENCE_WFPRICED] FOREIGN KEY([WFPriceDetailId])
REFERENCES [dbo].[WFPriceDetail] ([WFPriceDetailId])
GO
ALTER TABLE [dbo].[WFFirePriceDetail] CHECK CONSTRAINT [FK_WFFIREPR_REFERENCE_WFPRICED]
GO
ALTER TABLE [dbo].[WFFirePricePostponeConfirm]  WITH CHECK ADD  CONSTRAINT [FK_WFFPPC_REFERENCE_WFPRICED] FOREIGN KEY([WFPriceDetailId])
REFERENCES [dbo].[WFPriceDetail] ([WFPriceDetailId])
GO
ALTER TABLE [dbo].[WFFirePricePostponeConfirm] CHECK CONSTRAINT [FK_WFFPPC_REFERENCE_WFPRICED]
GO
ALTER TABLE [dbo].[WFFirePriceRecord]  WITH CHECK ADD  CONSTRAINT [FK_WFFPR_REFERENCE_WFPRICED] FOREIGN KEY([WFPriceDetailId])
REFERENCES [dbo].[WFPriceDetail] ([WFPriceDetailId])
GO
ALTER TABLE [dbo].[WFFirePriceRecord] CHECK CONSTRAINT [FK_WFFPR_REFERENCE_WFPRICED]
GO
ALTER TABLE [dbo].[WFFirePriceRecord]  WITH CHECK ADD  CONSTRAINT [WFFirePriceConfirm_WFFirePriceRecord_FK1] FOREIGN KEY([WFFirePriceConfirmId])
REFERENCES [dbo].[WFFirePriceConfirm] ([WFFirePriceConfirmId])
GO
ALTER TABLE [dbo].[WFFirePriceRecord] CHECK CONSTRAINT [WFFirePriceConfirm_WFFirePriceRecord_FK1]
GO
ALTER TABLE [dbo].[WFFutureTradeRecord]  WITH CHECK ADD  CONSTRAINT [FK_WFFUTURETRADERECORD_REFERENCE_88_WFCONTRACTDETAILINFO] FOREIGN KEY([WFContractDetailInfoId])
REFERENCES [dbo].[WFContractDetailInfo] ([WFContractDetailInfoId])
GO
ALTER TABLE [dbo].[WFFutureTradeRecord] CHECK CONSTRAINT [FK_WFFUTURETRADERECORD_REFERENCE_88_WFCONTRACTDETAILINFO]
GO
ALTER TABLE [dbo].[WFGeneralModificationDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFGENERA_REFERENCE_WFGENERA] FOREIGN KEY([WFGeneralModificationId])
REFERENCES [dbo].[WFGeneralModification] ([WFGeneralModificationId])
GO
ALTER TABLE [dbo].[WFGeneralModificationDetail] CHECK CONSTRAINT [FK_WFGENERA_REFERENCE_WFGENERA]
GO
ALTER TABLE [dbo].[WFInstrument]  WITH CHECK ADD  CONSTRAINT [FK_WFINSTRUMENT_REFERENCE_79_WFCOMMODITYTYPE] FOREIGN KEY([WFCommodityTypeId])
REFERENCES [dbo].[WFCommodityType] ([WFCommodityTypeId])
GO
ALTER TABLE [dbo].[WFInstrument] CHECK CONSTRAINT [FK_WFINSTRUMENT_REFERENCE_79_WFCOMMODITYTYPE]
GO
ALTER TABLE [dbo].[WFInstrument]  WITH CHECK ADD  CONSTRAINT [FK_WFInstrument_REFERENCE_WFCompany] FOREIGN KEY([ExchangeId])
REFERENCES [dbo].[WFCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFInstrument] CHECK CONSTRAINT [FK_WFInstrument_REFERENCE_WFCompany]
GO
ALTER TABLE [dbo].[WFInstrument]  WITH CHECK ADD  CONSTRAINT [FK_WFInstrument_REFERENCE_WFInstrumentCategory] FOREIGN KEY([WFInstrumentCategoryId])
REFERENCES [dbo].[WFInstrumentCategory] ([WFInstrumentCategoryId])
GO
ALTER TABLE [dbo].[WFInstrument] CHECK CONSTRAINT [FK_WFInstrument_REFERENCE_WFInstrumentCategory]
GO
ALTER TABLE [dbo].[WFInstrumentCategory]  WITH CHECK ADD  CONSTRAINT [FK_WFInstrumentCategory_REFERENCE_WFCommodityType] FOREIGN KEY([WFCommodityTypeId])
REFERENCES [dbo].[WFCommodityType] ([WFCommodityTypeId])
GO
ALTER TABLE [dbo].[WFInstrumentCategory] CHECK CONSTRAINT [FK_WFInstrumentCategory_REFERENCE_WFCommodityType]
GO
ALTER TABLE [dbo].[WFInstrumentCategory]  WITH CHECK ADD  CONSTRAINT [FK_WFInstrumentCategory_REFERENCE_WFCompany] FOREIGN KEY([MarketId])
REFERENCES [dbo].[WFCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFInstrumentCategory] CHECK CONSTRAINT [FK_WFInstrumentCategory_REFERENCE_WFCompany]
GO
ALTER TABLE [dbo].[WFInstrumentCategory]  WITH CHECK ADD  CONSTRAINT [FK_WFInstrumentCategory_REFERENCE_WFCurrency] FOREIGN KEY([WFCurrencyId])
REFERENCES [dbo].[WFCurrency] ([WFCurrencyId])
GO
ALTER TABLE [dbo].[WFInstrumentCategory] CHECK CONSTRAINT [FK_WFInstrumentCategory_REFERENCE_WFCurrency]
GO
ALTER TABLE [dbo].[WFInstrumentCategory]  WITH CHECK ADD  CONSTRAINT [FK_WFInstrumentCategory_REFERENCE_WFUnit] FOREIGN KEY([WFUnitId])
REFERENCES [dbo].[WFUnit] ([WFUnitId])
GO
ALTER TABLE [dbo].[WFInstrumentCategory] CHECK CONSTRAINT [FK_WFInstrumentCategory_REFERENCE_WFUnit]
GO
ALTER TABLE [dbo].[WFInstrumentSettlementPrice]  WITH CHECK ADD  CONSTRAINT [FK_WFInstrumentSettlementPrice_REFERENCE_WFInstrument] FOREIGN KEY([InstrumentId])
REFERENCES [dbo].[WFInstrument] ([WFInstrumentId])
GO
ALTER TABLE [dbo].[WFInstrumentSettlementPrice] CHECK CONSTRAINT [FK_WFInstrumentSettlementPrice_REFERENCE_WFInstrument]
GO
ALTER TABLE [dbo].[WFInvoiceObject]  WITH CHECK ADD  CONSTRAINT [FK_WFInvoiceObject_REFERENCE_WFContractInvoice] FOREIGN KEY([WFContractInvoiceId])
REFERENCES [dbo].[WFContractInvoice] ([WFContractInvoiceId])
GO
ALTER TABLE [dbo].[WFInvoiceObject] CHECK CONSTRAINT [FK_WFInvoiceObject_REFERENCE_WFContractInvoice]
GO
ALTER TABLE [dbo].[WFInvoiceObject]  WITH CHECK ADD  CONSTRAINT [FK_WFInvoiceObject_REFERENCE_WFInvoiceRecord] FOREIGN KEY([WFInvoiceRecordId])
REFERENCES [dbo].[WFInvoiceRecord] ([WFInvoiceRecordId])
GO
ALTER TABLE [dbo].[WFInvoiceObject] CHECK CONSTRAINT [FK_WFInvoiceObject_REFERENCE_WFInvoiceRecord]
GO
ALTER TABLE [dbo].[WFInvoiceRecord]  WITH CHECK ADD  CONSTRAINT [FK_WFInvoiceRecord_REFERENCE_WFCommercialInvoice] FOREIGN KEY([BusinessInvoiceId])
REFERENCES [dbo].[WFCommercialInvoice] ([WFInvoiceRecordId])
GO
ALTER TABLE [dbo].[WFInvoiceRecord] CHECK CONSTRAINT [FK_WFInvoiceRecord_REFERENCE_WFCommercialInvoice]
GO
ALTER TABLE [dbo].[WFInvoiceRecord]  WITH CHECK ADD  CONSTRAINT [FK_WFInvoiceRecord_REFERENCE_WFInvoiceRecord] FOREIGN KEY([ParentId])
REFERENCES [dbo].[WFInvoiceRecord] ([WFInvoiceRecordId])
GO
ALTER TABLE [dbo].[WFInvoiceRecord] CHECK CONSTRAINT [FK_WFInvoiceRecord_REFERENCE_WFInvoiceRecord]
GO
ALTER TABLE [dbo].[WFInvoiceRecord]  WITH CHECK ADD  CONSTRAINT [WFInvoiceRequest_WFInvoiceRecord_FK1] FOREIGN KEY([WFInvoiceRequestId])
REFERENCES [dbo].[WFInvoiceRequest] ([WFInvoiceRequestId])
GO
ALTER TABLE [dbo].[WFInvoiceRecord] CHECK CONSTRAINT [WFInvoiceRequest_WFInvoiceRecord_FK1]
GO
ALTER TABLE [dbo].[WFInvoiceRequestDetail]  WITH CHECK ADD  CONSTRAINT [WFContractInfo_WFInvoiceRequestDetail_FK1] FOREIGN KEY([WFContractDetailInfoId])
REFERENCES [dbo].[WFContractDetailInfo] ([WFContractDetailInfoId])
GO
ALTER TABLE [dbo].[WFInvoiceRequestDetail] CHECK CONSTRAINT [WFContractInfo_WFInvoiceRequestDetail_FK1]
GO
ALTER TABLE [dbo].[WFInvoiceRequestDetail]  WITH CHECK ADD  CONSTRAINT [WFInvoiceRequest_WFInvoiceRequestDetail_FK1] FOREIGN KEY([WFInvoiceRequestId])
REFERENCES [dbo].[WFInvoiceRequest] ([WFInvoiceRequestId])
GO
ALTER TABLE [dbo].[WFInvoiceRequestDetail] CHECK CONSTRAINT [WFInvoiceRequest_WFInvoiceRequestDetail_FK1]
GO
ALTER TABLE [dbo].[WFLcContract]  WITH CHECK ADD  CONSTRAINT [FK_WFLCCONT_REFERENCE_WFCONTRA] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFLcContract] CHECK CONSTRAINT [FK_WFLCCONT_REFERENCE_WFCONTRA]
GO
ALTER TABLE [dbo].[WFLcContract]  WITH CHECK ADD  CONSTRAINT [FK_WFLCCONT_REFERENCE_WFLETTER] FOREIGN KEY([WFLetterOfCreditId])
REFERENCES [dbo].[WFLetterOfCredit] ([WFLetterOfCreditId])
GO
ALTER TABLE [dbo].[WFLcContract] CHECK CONSTRAINT [FK_WFLCCONT_REFERENCE_WFLETTER]
GO
ALTER TABLE [dbo].[WFLongContractDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFLONGCONTRACTDETAIL_REFERENCE_83_WFLONGCONTRACT] FOREIGN KEY([WFLongContractId])
REFERENCES [dbo].[WFLongContract] ([WFLongContractId])
GO
ALTER TABLE [dbo].[WFLongContractDetail] CHECK CONSTRAINT [FK_WFLONGCONTRACTDETAIL_REFERENCE_83_WFLONGCONTRACT]
GO
ALTER TABLE [dbo].[WFMultiPrecursorBatch]  WITH CHECK ADD  CONSTRAINT [FK_WFMultiPrecursorBatch_PrecursorBatchId_REFERENCE_WFFinancialBatch] FOREIGN KEY([PrecursorBatchId])
REFERENCES [dbo].[WFFinancialBatch] ([WFFinancialBatchId])
GO
ALTER TABLE [dbo].[WFMultiPrecursorBatch] CHECK CONSTRAINT [FK_WFMultiPrecursorBatch_PrecursorBatchId_REFERENCE_WFFinancialBatch]
GO
ALTER TABLE [dbo].[WFMultiPrecursorBatch]  WITH CHECK ADD  CONSTRAINT [FK_WFMultiPrecursorBatch_SuccessorBatchId_REFERENCE_WFFinancialBatch] FOREIGN KEY([SuccessorBatchId])
REFERENCES [dbo].[WFFinancialBatch] ([WFFinancialBatchId])
GO
ALTER TABLE [dbo].[WFMultiPrecursorBatch] CHECK CONSTRAINT [FK_WFMultiPrecursorBatch_SuccessorBatchId_REFERENCE_WFFinancialBatch]
GO
ALTER TABLE [dbo].[WFOrderInfo]  WITH CHECK ADD  CONSTRAINT [WFContractInfo_WFOrderInfo_FK1] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFOrderInfo] CHECK CONSTRAINT [WFContractInfo_WFOrderInfo_FK1]
GO
ALTER TABLE [dbo].[WFOurPlantTransferWarehouseNotification]  WITH CHECK ADD  CONSTRAINT [FK_WFOurPlantTransferWarehouseNotification_REFERENCE_WFStorageConversion] FOREIGN KEY([WFStorageConversionId])
REFERENCES [dbo].[WFStorageConversion] ([WFStorageConversionId])
GO
ALTER TABLE [dbo].[WFOurPlantTransferWarehouseNotification] CHECK CONSTRAINT [FK_WFOurPlantTransferWarehouseNotification_REFERENCE_WFStorageConversion]
GO
ALTER TABLE [dbo].[WFOurPlantTransferWarehouseNotificationDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFOurPlantTransferWarehouseNotificationDetail_REFERENCE_WFOurPlantTransferWarehouseNotification] FOREIGN KEY([WFOurPlantTransferWarehouseNotificationId])
REFERENCES [dbo].[WFOurPlantTransferWarehouseNotification] ([WFOurPlantTransferWarehouseNotificationId])
GO
ALTER TABLE [dbo].[WFOurPlantTransferWarehouseNotificationDetail] CHECK CONSTRAINT [FK_WFOurPlantTransferWarehouseNotificationDetail_REFERENCE_WFOurPlantTransferWarehouseNotification]
GO
ALTER TABLE [dbo].[WFOutRecordAssistantMeasureInfo]  WITH NOCHECK ADD  CONSTRAINT [FK_WFOUTRECORDASSISTANTMEASUREI_REFERENCE_207_WFWAREHOUSEOUTRECORDDETAIL] FOREIGN KEY([WFWarehouseOutRecordDetailId])
REFERENCES [dbo].[WFWarehouseOutRecordDetail] ([WFWarehouseOutRecordDetailId])
GO
ALTER TABLE [dbo].[WFOutRecordAssistantMeasureInfo] CHECK CONSTRAINT [FK_WFOUTRECORDASSISTANTMEASUREI_REFERENCE_207_WFWAREHOUSEOUTRECORDDETAIL]
GO
ALTER TABLE [dbo].[WFPaymentProposal]  WITH CHECK ADD  CONSTRAINT [FK_WFPaymentProposal_REFERENCE_WFPayRequest] FOREIGN KEY([WFPayRequestId])
REFERENCES [dbo].[WFPayRequest] ([WFPayRequestId])
GO
ALTER TABLE [dbo].[WFPaymentProposal] CHECK CONSTRAINT [FK_WFPaymentProposal_REFERENCE_WFPayRequest]
GO
ALTER TABLE [dbo].[WFPaymentProposalDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFPaymentProposalDetail_REFERENCE_WFContractInfo] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFPaymentProposalDetail] CHECK CONSTRAINT [FK_WFPaymentProposalDetail_REFERENCE_WFContractInfo]
GO
ALTER TABLE [dbo].[WFPaymentProposalDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFPaymentProposalDetail_REFERENCE_WFPaymentProposal] FOREIGN KEY([WFPaymentProposalId])
REFERENCES [dbo].[WFPaymentProposal] ([WFPaymentProposalId])
GO
ALTER TABLE [dbo].[WFPaymentProposalDetail] CHECK CONSTRAINT [FK_WFPaymentProposalDetail_REFERENCE_WFPaymentProposal]
GO
ALTER TABLE [dbo].[WFPaymentProposalSubDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFPaymentProposalSubDetail_REFERENCE_WFPaymentProposalDetail] FOREIGN KEY([WFPaymentProposalDetailId])
REFERENCES [dbo].[WFPaymentProposalDetail] ([WFPaymentProposalDetailId])
GO
ALTER TABLE [dbo].[WFPaymentProposalSubDetail] CHECK CONSTRAINT [FK_WFPaymentProposalSubDetail_REFERENCE_WFPaymentProposalDetail]
GO
ALTER TABLE [dbo].[WFPayRequest]  WITH CHECK ADD  CONSTRAINT [FK_WFPAYREQUEST_REFERENCE_99_WFSETTLEMENTREQUEST] FOREIGN KEY([WFSettlementRequestlId])
REFERENCES [dbo].[WFSettlementRequest] ([WFSettlementRequestlId])
GO
ALTER TABLE [dbo].[WFPayRequest] CHECK CONSTRAINT [FK_WFPAYREQUEST_REFERENCE_99_WFSETTLEMENTREQUEST]
GO
ALTER TABLE [dbo].[WFPayRequestDetail]  WITH CHECK ADD  CONSTRAINT [WFContractInfo_WFPayRequestDetail_FK1] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFPayRequestDetail] CHECK CONSTRAINT [WFContractInfo_WFPayRequestDetail_FK1]
GO
ALTER TABLE [dbo].[WFPayRequestDetail]  WITH CHECK ADD  CONSTRAINT [WFPayRequest_WFPayRequestDetail_FK1] FOREIGN KEY([WFPayRequestId])
REFERENCES [dbo].[WFPayRequest] ([WFPayRequestId])
GO
ALTER TABLE [dbo].[WFPayRequestDetail] CHECK CONSTRAINT [WFPayRequest_WFPayRequestDetail_FK1]
GO
ALTER TABLE [dbo].[WFPayRequestSubDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFPayRequestSubDetail_REFERENCE_WFPayRequestDetail] FOREIGN KEY([WFPayRequestDetailId])
REFERENCES [dbo].[WFPayRequestDetail] ([WFPayRequestDetailId])
GO
ALTER TABLE [dbo].[WFPayRequestSubDetail] CHECK CONSTRAINT [FK_WFPayRequestSubDetail_REFERENCE_WFPayRequestDetail]
GO
ALTER TABLE [dbo].[WFPledgeContract]  WITH CHECK ADD  CONSTRAINT [FK_WFPLEDGECONTRACT_REFERENCE_198_WFCONTRACTINFO] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFPledgeContract] CHECK CONSTRAINT [FK_WFPLEDGECONTRACT_REFERENCE_198_WFCONTRACTINFO]
GO
ALTER TABLE [dbo].[WFPledgeRenewal]  WITH CHECK ADD  CONSTRAINT [FK_WFPledgeRenewal_REFERENCE_WFPledgeContract] FOREIGN KEY([OldPledgeContractId])
REFERENCES [dbo].[WFPledgeContract] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFPledgeRenewal] CHECK CONSTRAINT [FK_WFPledgeRenewal_REFERENCE_WFPledgeContract]
GO
ALTER TABLE [dbo].[WFPledgeRenewalDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFPledgeRenewalDetail_REFERENCE_WFPledgeRenewal] FOREIGN KEY([WFPledgeRenewalId])
REFERENCES [dbo].[WFPledgeRenewal] ([WFPledgeRenewalId])
GO
ALTER TABLE [dbo].[WFPledgeRenewalDetail] CHECK CONSTRAINT [FK_WFPledgeRenewalDetail_REFERENCE_WFPledgeRenewal]
GO
ALTER TABLE [dbo].[WFPostingInfoDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFPostingInfoDetail_REFERENCE_WFFinancialBatch] FOREIGN KEY([WFFinancialBatchId])
REFERENCES [dbo].[WFFinancialBatch] ([WFFinancialBatchId])
GO
ALTER TABLE [dbo].[WFPostingInfoDetail] CHECK CONSTRAINT [FK_WFPostingInfoDetail_REFERENCE_WFFinancialBatch]
GO
ALTER TABLE [dbo].[WFPostingInfoDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFPostingInfoDetail_REFERENCE_WFPostingInfo] FOREIGN KEY([WFPostingInfoId])
REFERENCES [dbo].[WFPostingInfo] ([WFPostingInfoId])
GO
ALTER TABLE [dbo].[WFPostingInfoDetail] CHECK CONSTRAINT [FK_WFPostingInfoDetail_REFERENCE_WFPostingInfo]
GO
ALTER TABLE [dbo].[WFPriceConfirmationLetter]  WITH CHECK ADD  CONSTRAINT [FK_WFPRICECONFIRMATIONLETTER_REFERENCE_64_WFCONTRACTINFO] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFPriceConfirmationLetter] CHECK CONSTRAINT [FK_WFPRICECONFIRMATIONLETTER_REFERENCE_64_WFCONTRACTINFO]
GO
ALTER TABLE [dbo].[WFPriceConfirmationLetterDetails]  WITH CHECK ADD  CONSTRAINT [FK_WFPRICECONFIRMATIONLETTERDET_REFERENCE_63_WFPRICECONFIRMATIONLETTER] FOREIGN KEY([WFPriceConfirmationLetterId])
REFERENCES [dbo].[WFPriceConfirmationLetter] ([WFPriceConfirmationLetterId])
GO
ALTER TABLE [dbo].[WFPriceConfirmationLetterDetails] CHECK CONSTRAINT [FK_WFPRICECONFIRMATIONLETTERDET_REFERENCE_63_WFPRICECONFIRMATIONLETTER]
GO
ALTER TABLE [dbo].[WFPriceDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFPRICED_REFERENCE_WFPRICEI] FOREIGN KEY([WFPriceInfoId])
REFERENCES [dbo].[WFPriceInfo] ([WFPriceInfoId])
GO
ALTER TABLE [dbo].[WFPriceDetail] CHECK CONSTRAINT [FK_WFPRICED_REFERENCE_WFPRICEI]
GO
ALTER TABLE [dbo].[WFPriceInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFPriceInfo_REFERENCE_WFCommodity] FOREIGN KEY([CommodityId])
REFERENCES [dbo].[WFCommodity] ([WFCommodityId])
GO
ALTER TABLE [dbo].[WFPriceInfo] CHECK CONSTRAINT [FK_WFPriceInfo_REFERENCE_WFCommodity]
GO
ALTER TABLE [dbo].[WFPriceInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFPriceInfo_REFERENCE_WFCurrency] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[WFCurrency] ([WFCurrencyId])
GO
ALTER TABLE [dbo].[WFPriceInfo] CHECK CONSTRAINT [FK_WFPriceInfo_REFERENCE_WFCurrency]
GO
ALTER TABLE [dbo].[WFPriceInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFPriceInfo_REFERENCE_WFUnit] FOREIGN KEY([UnitId])
REFERENCES [dbo].[WFUnit] ([WFUnitId])
GO
ALTER TABLE [dbo].[WFPriceInfo] CHECK CONSTRAINT [FK_WFPriceInfo_REFERENCE_WFUnit]
GO
ALTER TABLE [dbo].[WFPriceInstrument]  WITH CHECK ADD  CONSTRAINT [FK_WFPI_REFERENCE_WFPRICED] FOREIGN KEY([WFPriceDetailId])
REFERENCES [dbo].[WFPriceDetail] ([WFPriceDetailId])
GO
ALTER TABLE [dbo].[WFPriceInstrument] CHECK CONSTRAINT [FK_WFPI_REFERENCE_WFPRICED]
GO
ALTER TABLE [dbo].[WFPriceInstrument]  WITH CHECK ADD  CONSTRAINT [FK_WFPRICEI_REFERENCE_WFINSTRU] FOREIGN KEY([WFInstrumentId])
REFERENCES [dbo].[WFInstrument] ([WFInstrumentId])
GO
ALTER TABLE [dbo].[WFPriceInstrument] CHECK CONSTRAINT [FK_WFPRICEI_REFERENCE_WFINSTRU]
GO
ALTER TABLE [dbo].[WFRoleBusiness]  WITH NOCHECK ADD  CONSTRAINT [FK_WFRoleBusiness_REFERENCE_WFBusiness] FOREIGN KEY([WFBusinessId])
REFERENCES [dbo].[WFBusiness] ([WFBusinessId])
GO
ALTER TABLE [dbo].[WFRoleBusiness] CHECK CONSTRAINT [FK_WFRoleBusiness_REFERENCE_WFBusiness]
GO
ALTER TABLE [dbo].[WFRoleBusiness]  WITH NOCHECK ADD  CONSTRAINT [FK_WFRoleBusiness_REFERENCE_WFRoleInfo] FOREIGN KEY([WFRoleInfoId])
REFERENCES [dbo].[WFRoleInfo] ([WFRoleInfoId])
GO
ALTER TABLE [dbo].[WFRoleBusiness] CHECK CONSTRAINT [FK_WFRoleBusiness_REFERENCE_WFRoleInfo]
GO
ALTER TABLE [dbo].[WFRoleConditionConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WFRoleConditionConfiguration_REFERENCE_WFApproverTemplate] FOREIGN KEY([ApproverTemplateId])
REFERENCES [dbo].[WFApproverTemplate] ([WFApproverTemplateId])
GO
ALTER TABLE [dbo].[WFRoleConditionConfiguration] CHECK CONSTRAINT [FK_WFRoleConditionConfiguration_REFERENCE_WFApproverTemplate]
GO
ALTER TABLE [dbo].[WFRoleInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFROLEINFO_REFERENCE_136_WFPOST] FOREIGN KEY([WFPostId])
REFERENCES [dbo].[WFPost] ([WFPostId])
GO
ALTER TABLE [dbo].[WFRoleInfo] CHECK CONSTRAINT [FK_WFROLEINFO_REFERENCE_136_WFPOST]
GO
ALTER TABLE [dbo].[WFRolePrivilege]  WITH NOCHECK ADD  CONSTRAINT [FK_WFRolePrivilege_REFERENCE_WFRoleInfo] FOREIGN KEY([WFRoleInfoId])
REFERENCES [dbo].[WFRoleInfo] ([WFRoleInfoId])
GO
ALTER TABLE [dbo].[WFRolePrivilege] CHECK CONSTRAINT [FK_WFRolePrivilege_REFERENCE_WFRoleInfo]
GO
ALTER TABLE [dbo].[WFSaleContractTradeRecord]  WITH CHECK ADD  CONSTRAINT [FK_WFSALECONTRACTTRADERECORD_REFERENCE_61_WFCONTRACTOUTRECORDDETAIL] FOREIGN KEY([WFContractOutRecordDetailId])
REFERENCES [dbo].[WFContractOutRecordDetail] ([WFContractOutRecordDetailId])
GO
ALTER TABLE [dbo].[WFSaleContractTradeRecord] CHECK CONSTRAINT [FK_WFSALECONTRACTTRADERECORD_REFERENCE_61_WFCONTRACTOUTRECORDDETAIL]
GO
ALTER TABLE [dbo].[WFSaleContractTradeRecord]  WITH CHECK ADD  CONSTRAINT [FK_WFSaleContractTradeRecord_REFERENCE_WFFinalPrice] FOREIGN KEY([WFFinalPriceId])
REFERENCES [dbo].[WFFinalPrice] ([WFFinalPriceId])
GO
ALTER TABLE [dbo].[WFSaleContractTradeRecord] CHECK CONSTRAINT [FK_WFSaleContractTradeRecord_REFERENCE_WFFinalPrice]
GO
ALTER TABLE [dbo].[WFSapAmountCategoryCommodity]  WITH CHECK ADD  CONSTRAINT [FK_WFSapAmountCategoryCommodity_REFERENCE_WFSapConfiguration] FOREIGN KEY([WFSapConfigurationId])
REFERENCES [dbo].[WFSapConfiguration] ([WFSapConfigurationId])
GO
ALTER TABLE [dbo].[WFSapAmountCategoryCommodity] CHECK CONSTRAINT [FK_WFSapAmountCategoryCommodity_REFERENCE_WFSapConfiguration]
GO
ALTER TABLE [dbo].[WFSapTransactionMultiObject]  WITH CHECK ADD  CONSTRAINT [FK_WFSapTransactionMultiObject_REFERENCE_WFSapTransaction] FOREIGN KEY([WFSapTransactionId])
REFERENCES [dbo].[WFSapTransaction] ([WFSapTransactionId])
GO
ALTER TABLE [dbo].[WFSapTransactionMultiObject] CHECK CONSTRAINT [FK_WFSapTransactionMultiObject_REFERENCE_WFSapTransaction]
GO
ALTER TABLE [dbo].[WFSettlementRequestDetail]  WITH CHECK ADD  CONSTRAINT [WFContractInfo_WFSettlementRequestDetail_FK1] FOREIGN KEY([WFContractInfoId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFSettlementRequestDetail] CHECK CONSTRAINT [WFContractInfo_WFSettlementRequestDetail_FK1]
GO
ALTER TABLE [dbo].[WFSettlementRequestDetail]  WITH CHECK ADD  CONSTRAINT [WFSettlementRequest_WFSettlementRequestDetail_FK1] FOREIGN KEY([WFSettlementRequestlId])
REFERENCES [dbo].[WFSettlementRequest] ([WFSettlementRequestlId])
GO
ALTER TABLE [dbo].[WFSettlementRequestDetail] CHECK CONSTRAINT [WFSettlementRequest_WFSettlementRequestDetail_FK1]
GO
ALTER TABLE [dbo].[WFSettleOptionDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFSettleOptionDetail_REFERENCE_WFSettleOption] FOREIGN KEY([WFSettleOptionId])
REFERENCES [dbo].[WFSettleOption] ([WFSettleOptionId])
GO
ALTER TABLE [dbo].[WFSettleOptionDetail] CHECK CONSTRAINT [FK_WFSettleOptionDetail_REFERENCE_WFSettleOption]
GO
ALTER TABLE [dbo].[WFSettleOptionDetailExchangeProcess]  WITH CHECK ADD  CONSTRAINT [FK_SodEp_REFERENCE_Sod] FOREIGN KEY([WFSettleOptionDetailId])
REFERENCES [dbo].[WFSettleOptionDetail] ([WFSettleOptionDetailId])
GO
ALTER TABLE [dbo].[WFSettleOptionDetailExchangeProcess] CHECK CONSTRAINT [FK_SodEp_REFERENCE_Sod]
GO
ALTER TABLE [dbo].[WFSettleOptionDetailPaymentForm]  WITH CHECK ADD  CONSTRAINT [FK_SodPf_REFERENCE_Sod] FOREIGN KEY([WFSettleOptionDetailId])
REFERENCES [dbo].[WFSettleOptionDetail] ([WFSettleOptionDetailId])
GO
ALTER TABLE [dbo].[WFSettleOptionDetailPaymentForm] CHECK CONSTRAINT [FK_SodPf_REFERENCE_Sod]
GO
ALTER TABLE [dbo].[WFSodEpAmountFirst]  WITH CHECK ADD  CONSTRAINT [FK_WFSodEpAmountFirst_REFERENCE_WFSettleOptionDetailExchangeProcess] FOREIGN KEY([WFSettleOptionDetailId])
REFERENCES [dbo].[WFSettleOptionDetailExchangeProcess] ([WFSettleOptionDetailId])
GO
ALTER TABLE [dbo].[WFSodEpAmountFirst] CHECK CONSTRAINT [FK_WFSodEpAmountFirst_REFERENCE_WFSettleOptionDetailExchangeProcess]
GO
ALTER TABLE [dbo].[WFSodEpConditionalRelease]  WITH CHECK ADD  CONSTRAINT [FK_SodEpCr_REFERENCE_SodEp] FOREIGN KEY([WFSettleOptionDetailId])
REFERENCES [dbo].[WFSettleOptionDetailExchangeProcess] ([WFSettleOptionDetailId])
GO
ALTER TABLE [dbo].[WFSodEpConditionalRelease] CHECK CONSTRAINT [FK_SodEpCr_REFERENCE_SodEp]
GO
ALTER TABLE [dbo].[WFSodEpDocumentsAgainstAcceptance]  WITH CHECK ADD  CONSTRAINT [FK_SodEpDa_REFERENCE_SodEp] FOREIGN KEY([WFSettleOptionDetailId])
REFERENCES [dbo].[WFSettleOptionDetailExchangeProcess] ([WFSettleOptionDetailId])
GO
ALTER TABLE [dbo].[WFSodEpDocumentsAgainstAcceptance] CHECK CONSTRAINT [FK_SodEpDa_REFERENCE_SodEp]
GO
ALTER TABLE [dbo].[WFSodEpDocumentsAgainstPayment]  WITH CHECK ADD  CONSTRAINT [FK_SodEpDp_REFERENCE_SodEp] FOREIGN KEY([WFSettleOptionDetailId])
REFERENCES [dbo].[WFSettleOptionDetailExchangeProcess] ([WFSettleOptionDetailId])
GO
ALTER TABLE [dbo].[WFSodEpDocumentsAgainstPayment] CHECK CONSTRAINT [FK_SodEpDp_REFERENCE_SodEp]
GO
ALTER TABLE [dbo].[WFSodEpLetterOfCredit]  WITH CHECK ADD  CONSTRAINT [FK_SodEpLc_REFERENCE_SodEp] FOREIGN KEY([WFSettleOptionDetailId])
REFERENCES [dbo].[WFSettleOptionDetailExchangeProcess] ([WFSettleOptionDetailId])
GO
ALTER TABLE [dbo].[WFSodEpLetterOfCredit] CHECK CONSTRAINT [FK_SodEpLc_REFERENCE_SodEp]
GO
ALTER TABLE [dbo].[WFSodPfExchangeBill]  WITH CHECK ADD  CONSTRAINT [FK_SodPfBill_REFERENCE_SodPf] FOREIGN KEY([WFSettleOptionDetailId])
REFERENCES [dbo].[WFSettleOptionDetailPaymentForm] ([WFSettleOptionDetailId])
GO
ALTER TABLE [dbo].[WFSodPfExchangeBill] CHECK CONSTRAINT [FK_SodPfBill_REFERENCE_SodPf]
GO
ALTER TABLE [dbo].[WFSpecialFeeConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WFSPECIALFEECONFIGURATION_REFERENCE_112_WFSYSTEMFEECONFIGURATION] FOREIGN KEY([WFWarehouseFeeId])
REFERENCES [dbo].[WFSystemFeeConfiguration] ([WFSystemFeeConfigurationId])
GO
ALTER TABLE [dbo].[WFSpecialFeeConfiguration] CHECK CONSTRAINT [FK_WFSPECIALFEECONFIGURATION_REFERENCE_112_WFSYSTEMFEECONFIGURATION]
GO
ALTER TABLE [dbo].[WFSpecification]  WITH CHECK ADD  CONSTRAINT [WFCommodity_WFSpecification_FK1] FOREIGN KEY([WFCommodityId])
REFERENCES [dbo].[WFCommodity] ([WFCommodityId])
GO
ALTER TABLE [dbo].[WFSpecification] CHECK CONSTRAINT [WFCommodity_WFSpecification_FK1]
GO
ALTER TABLE [dbo].[WFSpotReceiptConvertDetailInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFSPOTRECEIPTCONVERTDETAILIN_REFERENCE_101_WFSPOTRECEIPTCONVERTINFO] FOREIGN KEY([WFSpotReceiptConvertInfoId])
REFERENCES [dbo].[WFSpotReceiptConvertInfo] ([WFSpotReceiptConvertInfoId])
GO
ALTER TABLE [dbo].[WFSpotReceiptConvertDetailInfo] CHECK CONSTRAINT [FK_WFSPOTRECEIPTCONVERTDETAILIN_REFERENCE_101_WFSPOTRECEIPTCONVERTINFO]
GO
ALTER TABLE [dbo].[WFSpotReceiptConvertDetailInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFSPOTRECEIPTCONVERTDETAILIN_REFERENCE_102_WFWAREHOUSESTORAGE] FOREIGN KEY([WFWarehouseStorageId])
REFERENCES [dbo].[WFWarehouseStorage] ([WFWarehouseStorageId])
GO
ALTER TABLE [dbo].[WFSpotReceiptConvertDetailInfo] CHECK CONSTRAINT [FK_WFSPOTRECEIPTCONVERTDETAILIN_REFERENCE_102_WFWAREHOUSESTORAGE]
GO
ALTER TABLE [dbo].[WFStepActionTemplate]  WITH CHECK ADD  CONSTRAINT [FK_WFSTEPACTIONTEMPLATE_REFERENCE_133_WFAPPROVALWORKFLOWSTEPTEMPLA] FOREIGN KEY([WFApprovalWorkflowStepTemplateId])
REFERENCES [dbo].[WFApprovalWorkflowStepTemplate] ([WFApprovalWorkflowStepTemplateId])
GO
ALTER TABLE [dbo].[WFStepActionTemplate] CHECK CONSTRAINT [FK_WFSTEPACTIONTEMPLATE_REFERENCE_133_WFAPPROVALWORKFLOWSTEPTEMPLA]
GO
ALTER TABLE [dbo].[WFStepActionTemplate]  WITH CHECK ADD  CONSTRAINT [FK_WFSTEPACTIONTEMPLATE_REFERENCE_137_WFAPPROVERTEMPLATE] FOREIGN KEY([WFApproverTemplateId])
REFERENCES [dbo].[WFApproverTemplate] ([WFApproverTemplateId])
GO
ALTER TABLE [dbo].[WFStepActionTemplate] CHECK CONSTRAINT [FK_WFSTEPACTIONTEMPLATE_REFERENCE_137_WFAPPROVERTEMPLATE]
GO
ALTER TABLE [dbo].[WFStepConditionTemplate]  WITH CHECK ADD  CONSTRAINT [FK_WFSTEPCONDITIONTEMPLATE_REFERENCE_117_WFAPPROVALWORKFLOWSTEPTEMPLA] FOREIGN KEY([PreviousWFApprovalWorkflowStepId])
REFERENCES [dbo].[WFApprovalWorkflowStepTemplate] ([WFApprovalWorkflowStepTemplateId])
GO
ALTER TABLE [dbo].[WFStepConditionTemplate] CHECK CONSTRAINT [FK_WFSTEPCONDITIONTEMPLATE_REFERENCE_117_WFAPPROVALWORKFLOWSTEPTEMPLA]
GO
ALTER TABLE [dbo].[WFStepConditionTemplate]  WITH CHECK ADD  CONSTRAINT [FK_WFSTEPCONDITIONTEMPLATE_REFERENCE_118_WFAPPROVALWORKFLOWSTEPTEMPLA] FOREIGN KEY([NextWFApprovalWorkflowStepId])
REFERENCES [dbo].[WFApprovalWorkflowStepTemplate] ([WFApprovalWorkflowStepTemplateId])
GO
ALTER TABLE [dbo].[WFStepConditionTemplate] CHECK CONSTRAINT [FK_WFSTEPCONDITIONTEMPLATE_REFERENCE_118_WFAPPROVALWORKFLOWSTEPTEMPLA]
GO
ALTER TABLE [dbo].[WFStepConditionTemplate]  WITH CHECK ADD  CONSTRAINT [FK_WFStepConditionTemplate_REFERENCE_WFCondition] FOREIGN KEY([WFConditionId])
REFERENCES [dbo].[WFCondition] ([WFConditionId])
GO
ALTER TABLE [dbo].[WFStepConditionTemplate] CHECK CONSTRAINT [FK_WFStepConditionTemplate_REFERENCE_WFCondition]
GO
ALTER TABLE [dbo].[WFStorageAssistantMeasureInfo]  WITH NOCHECK ADD  CONSTRAINT [FK_WFSTORAGEASSISTANTMEASUREINF_REFERENCE_206_WFWAREHOUSESTORAGE] FOREIGN KEY([WFWarehouseStorageId])
REFERENCES [dbo].[WFWarehouseStorage] ([WFWarehouseStorageId])
GO
ALTER TABLE [dbo].[WFStorageAssistantMeasureInfo] CHECK CONSTRAINT [FK_WFSTORAGEASSISTANTMEASUREINF_REFERENCE_206_WFWAREHOUSESTORAGE]
GO
ALTER TABLE [dbo].[WFStorageConversionDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFStorageConversionDetail_REFERENCE_WFStorageConversion] FOREIGN KEY([WFStorageConversionId])
REFERENCES [dbo].[WFStorageConversion] ([WFStorageConversionId])
GO
ALTER TABLE [dbo].[WFStorageConversionDetail] CHECK CONSTRAINT [FK_WFStorageConversionDetail_REFERENCE_WFStorageConversion]
GO
ALTER TABLE [dbo].[WFSupplementalAgreement]  WITH CHECK ADD  CONSTRAINT [FK_WFSupplementalAgreement_REFERENCE_WFContractInfo] FOREIGN KEY([OriginContractId])
REFERENCES [dbo].[WFContractInfo] ([WFContractInfoId])
GO
ALTER TABLE [dbo].[WFSupplementalAgreement] CHECK CONSTRAINT [FK_WFSupplementalAgreement_REFERENCE_WFContractInfo]
GO
ALTER TABLE [dbo].[WFSupplementalAgreementDetail]  WITH CHECK ADD  CONSTRAINT [FK_WFSupplementalAgreementDetail_REFERENCE_WFSupplementalAgreement] FOREIGN KEY([NewContractId])
REFERENCES [dbo].[WFSupplementalAgreement] ([NewContractId])
GO
ALTER TABLE [dbo].[WFSupplementalAgreementDetail] CHECK CONSTRAINT [FK_WFSupplementalAgreementDetail_REFERENCE_WFSupplementalAgreement]
GO
ALTER TABLE [dbo].[WFSystemCodeInfo]  WITH CHECK ADD  CONSTRAINT [FK_WFSystemCodeInfo_REFERENCE_WFCodeTemplate] FOREIGN KEY([WFCodeTemplateId])
REFERENCES [dbo].[WFCodeTemplate] ([WFCodeTemplateId])
GO
ALTER TABLE [dbo].[WFSystemCodeInfo] CHECK CONSTRAINT [FK_WFSystemCodeInfo_REFERENCE_WFCodeTemplate]
GO
ALTER TABLE [dbo].[WFSystemCodeInfoConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WFSYSTEM_REFERENCE_WFSYSTEM] FOREIGN KEY([WFSystemCodeInfoId])
REFERENCES [dbo].[WFSystemCodeInfo] ([WFSystemCodeInfoId])
GO
ALTER TABLE [dbo].[WFSystemCodeInfoConfiguration] CHECK CONSTRAINT [FK_WFSYSTEM_REFERENCE_WFSYSTEM]
GO
ALTER TABLE [dbo].[WFSystemConfigDetail]  WITH NOCHECK ADD  CONSTRAINT [WFSystemConfiguration_WFSystemConfigDetail_FK1] FOREIGN KEY([WFSystemConfigurationId])
REFERENCES [dbo].[WFSystemConfiguration] ([WFSystemConfigurationId])
GO
ALTER TABLE [dbo].[WFSystemConfigDetail] CHECK CONSTRAINT [WFSystemConfiguration_WFSystemConfigDetail_FK1]
GO
ALTER TABLE [dbo].[WFSystemFee]  WITH CHECK ADD  CONSTRAINT [FK_WFSYSTEMFEE_REFERENCE_116_WFSYSTEMFINANCEACCOUNT] FOREIGN KEY([WFSystemFinanceAccountId])
REFERENCES [dbo].[WFSystemFinanceAccount] ([WFSystemFinanceAccountId])
GO
ALTER TABLE [dbo].[WFSystemFee] CHECK CONSTRAINT [FK_WFSYSTEMFEE_REFERENCE_116_WFSYSTEMFINANCEACCOUNT]
GO
ALTER TABLE [dbo].[WFSystemFeeConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WFSystemFeeConfiguration_REFERENCE_WFWAREHO] FOREIGN KEY([WFCompanyId])
REFERENCES [dbo].[WFWarehouseCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFSystemFeeConfiguration] CHECK CONSTRAINT [FK_WFSystemFeeConfiguration_REFERENCE_WFWAREHO]
GO
ALTER TABLE [dbo].[WFUnPledgeInfo]  WITH CHECK ADD  CONSTRAINT [WFPledgeInfo_WFUnPledgeInfo_FK1] FOREIGN KEY([WFPledgeInfoId])
REFERENCES [dbo].[WFPledgeInfo] ([WFPledgeInfoId])
GO
ALTER TABLE [dbo].[WFUnPledgeInfo] CHECK CONSTRAINT [WFPledgeInfo_WFUnPledgeInfo_FK1]
GO
ALTER TABLE [dbo].[WFUser]  WITH CHECK ADD  CONSTRAINT [FK_WFUSER_REFERENCE_208_WFOFFICEADDRESS] FOREIGN KEY([WFOfficeAddressId])
REFERENCES [dbo].[WFOfficeAddress] ([WFOfficeAddressId])
GO
ALTER TABLE [dbo].[WFUser] CHECK CONSTRAINT [FK_WFUSER_REFERENCE_208_WFOFFICEADDRESS]
GO
ALTER TABLE [dbo].[WFUserBusiness]  WITH CHECK ADD  CONSTRAINT [FK_WFUSERBU_REFERENCE_WFBUSINE] FOREIGN KEY([WFBusinessId])
REFERENCES [dbo].[WFBusiness] ([WFBusinessId])
GO
ALTER TABLE [dbo].[WFUserBusiness] CHECK CONSTRAINT [FK_WFUSERBU_REFERENCE_WFBUSINE]
GO
ALTER TABLE [dbo].[WFUserBusiness]  WITH CHECK ADD  CONSTRAINT [FK_WFUSERBU_REFERENCE_WFUSER] FOREIGN KEY([WFUserId])
REFERENCES [dbo].[WFUser] ([WFUserId])
GO
ALTER TABLE [dbo].[WFUserBusiness] CHECK CONSTRAINT [FK_WFUSERBU_REFERENCE_WFUSER]
GO
ALTER TABLE [dbo].[WFUserCorporation]  WITH CHECK ADD  CONSTRAINT [FK_WFUSERCORPORATION_REFERENCE_173_WFUSER] FOREIGN KEY([WFUserId])
REFERENCES [dbo].[WFUser] ([WFUserId])
GO
ALTER TABLE [dbo].[WFUserCorporation] CHECK CONSTRAINT [FK_WFUSERCORPORATION_REFERENCE_173_WFUSER]
GO
ALTER TABLE [dbo].[WFUserMessage]  WITH CHECK ADD  CONSTRAINT [FK_WFUSERMESSAGE_REFERENCE_119_WFUSER] FOREIGN KEY([WFUserId])
REFERENCES [dbo].[WFUser] ([WFUserId])
GO
ALTER TABLE [dbo].[WFUserMessage] CHECK CONSTRAINT [FK_WFUSERMESSAGE_REFERENCE_119_WFUSER]
GO
ALTER TABLE [dbo].[WFUserRequest]  WITH CHECK ADD  CONSTRAINT [FK_WFUSERREQUEST_REFERENCE_125_WFUSER] FOREIGN KEY([WFUserId])
REFERENCES [dbo].[WFUser] ([WFUserId])
GO
ALTER TABLE [dbo].[WFUserRequest] CHECK CONSTRAINT [FK_WFUSERREQUEST_REFERENCE_125_WFUSER]
GO
ALTER TABLE [dbo].[WFUserRole]  WITH NOCHECK ADD  CONSTRAINT [FK_WFUSERROLE_REFERENCE_93_WFUSER] FOREIGN KEY([WFUserId])
REFERENCES [dbo].[WFUser] ([WFUserId])
GO
ALTER TABLE [dbo].[WFUserRole] CHECK CONSTRAINT [FK_WFUSERROLE_REFERENCE_93_WFUSER]
GO
ALTER TABLE [dbo].[WFUserRole]  WITH NOCHECK ADD  CONSTRAINT [FK_WFUSERROLE_REFERENCE_94_WFROLEINFO] FOREIGN KEY([WFRoleInfoId])
REFERENCES [dbo].[WFRoleInfo] ([WFRoleInfoId])
GO
ALTER TABLE [dbo].[WFUserRole] CHECK CONSTRAINT [FK_WFUSERROLE_REFERENCE_94_WFROLEINFO]
GO
ALTER TABLE [dbo].[WFUserTask]  WITH CHECK ADD  CONSTRAINT [FK_WFUSERTASK_REFERENCE_120_WFUSER] FOREIGN KEY([WFUserId])
REFERENCES [dbo].[WFUser] ([WFUserId])
GO
ALTER TABLE [dbo].[WFUserTask] CHECK CONSTRAINT [FK_WFUSERTASK_REFERENCE_120_WFUSER]
GO
ALTER TABLE [dbo].[WFUserTask]  WITH CHECK ADD  CONSTRAINT [FK_WFUserTask_REFERENCE_WFUser] FOREIGN KEY([RequestorId])
REFERENCES [dbo].[WFUser] ([WFUserId])
GO
ALTER TABLE [dbo].[WFUserTask] CHECK CONSTRAINT [FK_WFUserTask_REFERENCE_WFUser]
GO
ALTER TABLE [dbo].[WFWarehouseCalculateFeeType]  WITH CHECK ADD  CONSTRAINT [FK_WFWarehouseCalculateFeeType_REFERENCE_WFWAREHO] FOREIGN KEY([WFCompanyId])
REFERENCES [dbo].[WFWarehouseCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFWarehouseCalculateFeeType] CHECK CONSTRAINT [FK_WFWarehouseCalculateFeeType_REFERENCE_WFWAREHO]
GO
ALTER TABLE [dbo].[WFWarehouseCardCodePrefix]  WITH CHECK ADD  CONSTRAINT [FK_WFWAREHO_REFERENCE_WFWarehouseCompany] FOREIGN KEY([WFCompanyId])
REFERENCES [dbo].[WFWarehouseCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFWarehouseCardCodePrefix] CHECK CONSTRAINT [FK_WFWAREHO_REFERENCE_WFWarehouseCompany]
GO
ALTER TABLE [dbo].[WFWarehouseCompany]  WITH CHECK ADD  CONSTRAINT [FK_WFWAREHO_REFERENCE_WFCOMPAN] FOREIGN KEY([WFCompanyId])
REFERENCES [dbo].[WFCompany] ([WFCompanyId])
GO
ALTER TABLE [dbo].[WFWarehouseCompany] CHECK CONSTRAINT [FK_WFWAREHO_REFERENCE_WFCOMPAN]
GO
ALTER TABLE [dbo].[WFWarehouseEntryRecord]  WITH NOCHECK ADD  CONSTRAINT [FK_WFWarehouseEntryRecord_REFERENCE_WFDeliveryNotification] FOREIGN KEY([WFDeliveryNotificationId])
REFERENCES [dbo].[WFDeliveryNotification] ([WFDeliveryNotificationId])
GO
ALTER TABLE [dbo].[WFWarehouseEntryRecord] CHECK CONSTRAINT [FK_WFWarehouseEntryRecord_REFERENCE_WFDeliveryNotification]
GO
ALTER TABLE [dbo].[WFWarehouseEntryRecordDetail]  WITH NOCHECK ADD  CONSTRAINT [WFWarehouseEntryOrder_WFWarehouseEntryRecord_FK1] FOREIGN KEY([WFWarehouseEntryRecordId])
REFERENCES [dbo].[WFWarehouseEntryRecord] ([WFWarehouseEntryRecordId])
GO
ALTER TABLE [dbo].[WFWarehouseEntryRecordDetail] CHECK CONSTRAINT [WFWarehouseEntryOrder_WFWarehouseEntryRecord_FK1]
GO
ALTER TABLE [dbo].[WFWarehouseOutOrder]  WITH CHECK ADD  CONSTRAINT [FK_WFWAREHOUSEOUTORDER_REFERENCE_73_WFWAREHOUSEOUTRECORD] FOREIGN KEY([WFWarehouseOutRecordId])
REFERENCES [dbo].[WFWarehouseOutRecord] ([WFWarehouseOutRecordId])
GO
ALTER TABLE [dbo].[WFWarehouseOutOrder] CHECK CONSTRAINT [FK_WFWAREHOUSEOUTORDER_REFERENCE_73_WFWAREHOUSEOUTRECORD]
GO
ALTER TABLE [dbo].[WFWarehouseOutRecord]  WITH CHECK ADD  CONSTRAINT [FK_WFWarehouseOutRecord_REFERENCE_WFDeliveryNotification] FOREIGN KEY([WFDeliveryNotificationId])
REFERENCES [dbo].[WFDeliveryNotification] ([WFDeliveryNotificationId])
GO
ALTER TABLE [dbo].[WFWarehouseOutRecord] CHECK CONSTRAINT [FK_WFWarehouseOutRecord_REFERENCE_WFDeliveryNotification]
GO
ALTER TABLE [dbo].[WFWarehouseOutRecordDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_OutDetail_REFERENCE_Storage] FOREIGN KEY([WFWarehouseStorageId])
REFERENCES [dbo].[WFWarehouseStorage] ([WFWarehouseStorageId])
GO
ALTER TABLE [dbo].[WFWarehouseOutRecordDetail] CHECK CONSTRAINT [FK_OutDetail_REFERENCE_Storage]
GO
ALTER TABLE [dbo].[WFWarehouseOutRecordDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_WFWAREHOUSEOUTRECORDDETAIL_REFERENCE_69_WFWAREHOUSEOUTRECORD] FOREIGN KEY([WFWarehouseOutRecordId])
REFERENCES [dbo].[WFWarehouseOutRecord] ([WFWarehouseOutRecordId])
GO
ALTER TABLE [dbo].[WFWarehouseOutRecordDetail] CHECK CONSTRAINT [FK_WFWAREHOUSEOUTRECORDDETAIL_REFERENCE_69_WFWAREHOUSEOUTRECORD]
GO
ALTER TABLE [dbo].[WFWarehouseStorage]  WITH NOCHECK ADD  CONSTRAINT [FK_Storage_REFERENCE_EntryDetail] FOREIGN KEY([WFWarehouseEntryRecordDetailId])
REFERENCES [dbo].[WFWarehouseEntryRecordDetail] ([WFWarehouseEntryRecordDetailId])
GO
ALTER TABLE [dbo].[WFWarehouseStorage] CHECK CONSTRAINT [FK_Storage_REFERENCE_EntryDetail]
GO
ALTER TABLE [dbo].[WFWarehouseStorageHistory]  WITH CHECK ADD  CONSTRAINT [FK_WFWarehouseStorageHistory_REFERENCE_WFCOMMODITY] FOREIGN KEY([CommodityId])
REFERENCES [dbo].[WFCommodity] ([WFCommodityId])
GO
ALTER TABLE [dbo].[WFWarehouseStorageHistory] CHECK CONSTRAINT [FK_WFWarehouseStorageHistory_REFERENCE_WFCOMMODITY]
GO
ALTER TABLE [dbo].[WFWarehouseStorageItem]  WITH CHECK ADD  CONSTRAINT [FK_WFWAREHOUSESTORAGEITEM_REFERENCE_65_WFWAREHOUSESTORAGE] FOREIGN KEY([WFWarehouseStorageId])
REFERENCES [dbo].[WFWarehouseStorage] ([WFWarehouseStorageId])
GO
ALTER TABLE [dbo].[WFWarehouseStorageItem] CHECK CONSTRAINT [FK_WFWAREHOUSESTORAGEITEM_REFERENCE_65_WFWAREHOUSESTORAGE]
GO
ALTER TABLE [dbo].[WFWhStorageFlowTrack]  WITH NOCHECK ADD  CONSTRAINT [FK_WFWHSTORAGEFLOWTRACK_REFERENCE_100_WFWAREHOUSESTORAGE] FOREIGN KEY([TargetWarehouseStorageId])
REFERENCES [dbo].[WFWarehouseStorage] ([WFWarehouseStorageId])
GO
ALTER TABLE [dbo].[WFWhStorageFlowTrack] CHECK CONSTRAINT [FK_WFWHSTORAGEFLOWTRACK_REFERENCE_100_WFWAREHOUSESTORAGE]
GO
ALTER TABLE [dbo].[WFWhStorageFlowTrack]  WITH NOCHECK ADD  CONSTRAINT [FK_WFWhStorageFlowTrack_REFERENCE_WFWarehouseOutRecordDetail] FOREIGN KEY([WFWarehouseOutRecordDetailId])
REFERENCES [dbo].[WFWarehouseOutRecordDetail] ([WFWarehouseOutRecordDetailId])
GO
ALTER TABLE [dbo].[WFWhStorageFlowTrack] CHECK CONSTRAINT [FK_WFWhStorageFlowTrack_REFERENCE_WFWarehouseOutRecordDetail]
GO
ALTER TABLE [dbo].[WFWhStorageFlowTrack]  WITH NOCHECK ADD  CONSTRAINT [WFWarehouseStorage_WFWhStorageFlowTrack_FK1] FOREIGN KEY([SourceWarehouseStorageId])
REFERENCES [dbo].[WFWarehouseStorage] ([WFWarehouseStorageId])
GO
ALTER TABLE [dbo].[WFWhStorageFlowTrack] CHECK CONSTRAINT [WFWarehouseStorage_WFWhStorageFlowTrack_FK1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CalcSyncSpotInventory]
    @FromDate DATE = NULL,
    @ToDate DATE = NULL,
    @LastUpdateTime DATETIME = NULL
AS
Begin

    SET NOCOUNT ON;

    DECLARE @inventory TABLE(PhysicalId INT, TradeDate DATE, AccountingEntity NVARCHAR(30), Corporation NVARCHAR(20),
                            Currency NVARCHAR(10),Commodity NVARCHAR(20),Volume DECIMAL(19, 9),LastUpdateTime DATETIME);
    DECLARE @tempDate DATE
    
    /* OnlineTime中的设置日期 */
    IF(@tempDate IS NULL)
        BEGIN
            SELECT TOP 1 @tempDate = CAST(WFValue AS date) FROM WFSystemConfiguration  WHERE WFKey = N'InventoryAccounting'
            IF(@tempDate IS NULL) RETURN;
        END
    
    /* 当@ToDate为默认参数NULL时，就使用当天日期 */
    IF(@ToDate IS NULL)
        SET @ToDate=GETDATE()
        
    /* 当@LastUpdateTime为默认参数NULL时，就从SyncSpotInventory中获取最近一次更新时间 */
    IF(@LastUpdateTime IS NULL)
    BEGIN
        SELECT @LastUpdateTime=MAX(LastUpdateTime) FROM SyncSpotInventory
        IF(@LastUpdateTime IS NULL) SET @LastUpdateTime='2014/1/1'
    END
    
    /* WFWarehouseStorageHistory中没有新的更新，就直接返回 */
    IF(@FromDate IS NULL)
    BEGIN
        SELECT @FromDate=MIN(StorageDate) FROM WFWarehouseStorageHistory WHERE CommodityStatus!=16 and LatestModifiedDate>DATEADD(MINUTE, -5, @LastUpdateTime)    
        IF(@FromDate IS NULL) RETURN;
    END
    
    /*  取@FromDate与OnlineTime中设置日期，取两者中的较大值 */
    Set @FromDate=IIF(@FromDate>@tempDate, @FromDate, @tempDate)
    Set @tempDate=@FromDate
    
    
    -- ////////////////////////////////////////////////////////////////
    -- /// 1. 将 Fill @inventory///////////////////////////////////////
    -- ////////////////////////////////////////////////////////////////
    WHILE( @tempDate <= @ToDate )
    BEGIN
        Insert Into @inventory(TradeDate,AccountingEntity,Commodity,Currency,Corporation,Volume,LastUpdateTime)
        SELECT @tempDate, b.Name, e.AccountingName, a.Currency, d.ShortName, SUM(Weight), GetDate()
        FROM WFWarehouseStorageHistory a
        INNER JOIN WFAccountEntity b ON a.AccountingEntityId = b.WFAccountEntityId
        INNER JOIN WFCommodity c ON a.CommodityId = c.WFCommodityId
        INNER JOIN WFCompany d ON a.CorporationId=d.WFCompanyId
        INNER JOIN WFCommodityType e ON e.WFCommodityTypeId = c.WFCommodityTypeId
        Where a.StorageDate = @tempDate and a.CommodityStatus!=16 
        and
        (   EXISTS
            (
                select 1 from WFSystemConfigDetail m,WFSystemConfiguration n  
				 where (case when CorporationId is null then 1 when CorporationId = d.WFCompanyId then 1 else 0 end = 1 )  
               -- and  (case when CurrencyId is null then 1 when (select name from WFCurrency WHERE WFCurrencyId = CurrencyId and IsDeleted=0) = a.Currency then 1 else 0 end =1 )  
                and  (case when AccountingEntityId is null then 1 when  AccountingEntityId = b.WFAccountEntityId then 1 else 0 end =1 )			
                and  (case when CommodityId is null then 1 when  CommodityId = e.WFCommodityTypeId then 1 else 0 end =1 )
               -- and  (case when TradeType is null then 1 when  TradeType=a.TradeType then 1 else 0 end =1 )
			   -- and  (case when UnitId is null then 1 when  UnitId=a.UnitId then 1 else 0 end =1 )
                and n.WFKey = N'InventoryAccounting'and m.WFSystemConfigurationId=n.WFSystemConfigurationId
             )
            OR
            EXISTS
            (
                select 1 from WFSystemConfiguration where WFKey = N'InventoryAccounting' AND WFValue IS NOT NULL
             )
         )
        GROUP BY b.Name, e.AccountingName, a.Currency, d.ShortName                
        
        Set @tempDate=DATEADD(DAY, IIF(DATEPART(WEEKDAY,@tempDate)=6,3,1), @tempDate)
    END
    DELETE FROM @inventory WHERE Volume=0

    
    -- ////////////////////////////////////////////////////////////////
    -- /// 2. 处理数据 dbo.SyncSpotInventory///////////////////////////
    -- ////////////////////////////////////////////////////////////////
    DECLARE @hasDataRow BIT, @doUpdate BIT, @doInsert BIT
    SELECT @hasDataRow=CASE WHEN Count(*)>0 THEN 1 ELSE 0 END FROM @inventory
    If (@hasDataRow=1)
    BEGIN

        -- 1) 给@inventory中的字段PhysicalId赋值
        UPDATE @inventory 
        Set PhysicalId=b.Id
        From @inventory a INNER JOIN 
            (SELECT * From SyncSpotInventory WHERE TradeDate BETWEEN @FromDate AND @ToDate) b
        On a.TradeDate=b.TradeDate AND a.AccountingEntity=b.AccountingEntity AND 
           a.Corporation=b.Corporation AND a.Currency=b.Currency AND a.Commodity=b.Commodity 
            
        Select @doUpdate=CASE WHEN Count(*)>0 THEN 1 ELSE 0 END FROM @inventory Where PhysicalId IS NOT NULL
        Select @doInsert=CASE WHEN Count(*)>0 THEN 1 ELSE 0 END FROM @inventory Where PhysicalId IS NULL

        -- 2) 删除之前存在但现在不存在，需要删除的行
        DELETE FROM SyncSpotInventory 
        WHERE Id in (
            SELECT Id From SyncSpotInventory WHERE TradeDate BETWEEN @FromDate AND @ToDate
            EXCEPT
            SELECT PhysicalId AS Id From @inventory
        )

        -- 3) 对已经存在的列，Update对应的数据值
        If (@doUpdate=1)
            UPDATE SyncSpotInventory
            SET Volume=b.Volume, LastUpdateTime=b.LastUpdateTime                    
            FROM SyncSpotInventory a INNER JOIN @inventory b ON a.Id=b.PhysicalId
            
        -- 4) 对不存在的列，Insert对应的数据值
        If (@doInsert=1)
            Insert into SyncSpotInventory
                  (TradeDate,AccountingEntity,Commodity,Currency,Corporation,Volume,LastUpdateTime)
            Select TradeDate,AccountingEntity,Commodity,Currency,Corporation,Volume,LastUpdateTime
            From @inventory
            Where PhysicalId IS NULL

    END
    Else
    BEGIN
        DELETE FROM SyncSpotInventory WHERE TradeDate BETWEEN @FromDate AND @ToDate
    END
    
End
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CalcSyncSpotMortgage]
    @FromDate DATE = NULL,
    @ToDate DATE = NULL
AS
Begin

    SET NOCOUNT ON;

    DECLARE @mortgage TABLE(
        PhysicalId INT,
        ObjectType int,

        MortgageSequenceNumber NVARCHAR(50), 
        TradeDate DATE, 
        AccountingEntity NVARCHAR(30), 
        Corporation NVARCHAR(20), 
        Currency NVARCHAR(10), 
        Commodity NVARCHAR(20), 
        Counterparty NVARCHAR(30), 
        MortgageDirection NVARCHAR(20), 
        MortgageVolume DECIMAL(19, 9), 
        MortgageRate DECIMAL(19, 9), 
        Volume DECIMAL(19, 9), 
        MortgagePrice DECIMAL(19, 9), 
        TotalAmount DECIMAL(19, 6), 
        MortgageInterestRate DECIMAL(19, 9), 
        Interest DECIMAL(19, 9), 
        RedemptionStatus NVARCHAR(50));    
    
    -- ////////////////////////////////////////////////////////////////
    -- /// 1. 将 Fill @mortgage///////////////////////////////////////
    -- ////////////////////////////////////////////////////////////////
    
    
	IF(@FromDate IS NULL)
		BEGIN
			SELECT TOP 1 @FromDate = CAST(WFValue AS date) FROM WFSystemConfiguration  WHERE WFKey = N'MortgageAccounting'
			IF(@FromDate IS NULL) RETURN;
		END
    IF(@ToDate IS NULL)
        SET @ToDate=GETDATE()
        
    -- 质押记录
    Insert Into @mortgage(ObjectType,
                MortgageSequenceNumber,TradeDate,AccountingEntity,Corporation,Commodity,Currency,
                Counterparty,MortgageDirection,MortgageVolume,MortgageRate,Volume,MortgagePrice,TotalAmount,
                MortgageInterestRate,Interest,RedemptionStatus)
    SELECT 3,a.WFPledgeInfoId, a.PledgeStartDate, a.AccountingEntity, a.Corporation, a.Commodity, a.Currency, 
           c.FullName, N'质押', b.Weight, a.PledgeRate, b.Weight*a.PledgeRate, a.Price, a.PledgeAmount,
           a.PledgeInterestRate, a.PledgeInterest, Case When a.IsUnPledgeFinished=0 Then N'未完全赎回' ELSE N'完全赎回' END
    FROM ViewWFPledgeInfo a
    INNER JOIN (
        SELECT ObjectId, AccountEntityId, SUM(Weight) AS Weight FROM(
            SELECT ObjectId, b.AccountEntityId, b.Weight FROM (SELECT * FROM WFWhStorageFlowTrack Where ObjectType=0 AND IsDeleted=0) a
            INNER JOIN WFWarehouseStorage b ON a.SourceWarehouseStorageId = b.WFWarehouseStorageId) t1
        GROUP BY ObjectId, AccountEntityId) b 
    On a.WFPledgeInfoId=b.ObjectId
    Left Join WFCompany c On a.CustomerId=c.WFCompanyId
    WHERE  a.PledgeStartDate BETWEEN @FromDate AND @ToDate
    
    -- 解押记录
    Insert Into @mortgage(ObjectType,
                MortgageSequenceNumber,TradeDate,AccountingEntity,Corporation,Commodity,Currency,
                Counterparty,MortgageDirection,MortgageVolume,MortgageRate,Volume,MortgagePrice,TotalAmount,
                MortgageInterestRate,Interest,RedemptionStatus)
    SELECT 4,a.WFPledgeInfoId, a.UnPledgeDate, a.AccountingEntity, a.Corporation, a.Commodity, ISNULL(a.Currency,N'人民币'),  
           c.FullName, N'赎回', b.Weight, a.PledgeRate, b.Weight*a.PledgeRate, a.Price, a.PledgeAmount,
           a.PledgeInterestRate, a.PledgeInterest, NULL
    FROM ViewWFUnPledgeInfo a 
    INNER JOIN (
        SELECT ObjectId, AccountEntityId, SUM(Weight) AS Weight FROM(
            SELECT ObjectId, b.AccountEntityId, b.Weight FROM (SELECT * FROM WFWhStorageFlowTrack Where ObjectType=1 AND IsDeleted=0) a
            INNER JOIN WFWarehouseStorage b ON a.SourceWarehouseStorageId = b.WFWarehouseStorageId) t1
        GROUP BY ObjectId, AccountEntityId) b 
    On a.WFUnPledgeInfoId=b.ObjectId
    Left Join WFCompany c On a.CustomerId=c.WFCompanyId
    WHERE  a.UnPledgeDate BETWEEN @FromDate AND @ToDate

    -- ////////////////////////////////////////////////////////////////
    -- /// 2. 处理数据 dbo.SyncSpotMortgage////////////////////////////
    -- ////////////////////////////////////////////////////////////////
    
    DECLARE @hasDataRow BIT, @doUpdate BIT, @doInsert BIT
    SELECT @hasDataRow=CASE WHEN Count(*)>0 THEN 1 ELSE 0 END FROM @mortgage
    If (@hasDataRow=1)
    BEGIN

        -- 1) 给@mortgage中的字段PhysicalId赋值
        UPDATE @mortgage 
        Set PhysicalId=b.Id 
        From @mortgage a join 
            (SELECT * FROM SyncSpotMortgage WHERE TradeDate BETWEEN @FromDate AND @ToDate) b
        On      a.MortgageSequenceNumber=b.MortgageSequenceNumber 
            AND a.TradeDate = b.TradeDate 
            AND a.AccountingEntity = b.AccountingEntity 
            AND a.Corporation = b.Corporation 
            AND a.Currency = b.Currency 
            AND a.Commodity = b.Commodity 
            AND a.MortgageDirection = b.MortgageDirection
            AND a.MortgageVolume = b.MortgageVolume
            
        Select @doUpdate=CASE WHEN Count(*)>0 THEN 1 ELSE 0 END FROM @mortgage Where PhysicalId IS NOT NULL
        Select @doInsert=CASE WHEN Count(*)>0 THEN 1 ELSE 0 END FROM @mortgage Where PhysicalId IS NULL

        -- 2) 删除之前存在但现在不存在，需要删除的行
        DELETE FROM SyncSpotMortgage 
        WHERE Id in (
            SELECT Id From SyncSpotMortgage WHERE ObjectType in(3,4) and TradeDate BETWEEN @FromDate AND @ToDate
            EXCEPT
            SELECT PhysicalId AS Id From @mortgage
        )

        -- 3) 对已经存在的列，Update对应的数据值
        If (@doUpdate=1)
            UPDATE SyncSpotMortgage
            SET 
               Counterparty=b.Counterparty, 
                MortgageDirection=b.MortgageDirection, 
                MortgageVolume=b.MortgageVolume, 
                MortgageRate=b.MortgageRate, 
                Volume=b.Volume, 
                MortgagePrice=b.MortgagePrice, 
                TotalAmount=b.TotalAmount, 
                MortgageInterestRate=b.MortgageInterestRate, 
                Interest=b.Interest, 
                RedemptionStatus=b.RedemptionStatus, 
                LastUpdateTime=GetDate(),
                ObjectType=b.ObjectType                
            FROM SyncSpotMortgage a Join @mortgage b ON a.Id=b.PhysicalId
            
        -- 4) 对不存在的列，Insert对应的数据值
        If (@doInsert=1)
            Insert into SyncSpotMortgage
                  (ObjectType,MortgageSequenceNumber,TradeDate,AccountingEntity,Corporation,Commodity,Currency,
                   Counterparty,MortgageDirection,MortgageVolume,MortgageRate,Volume,MortgagePrice,TotalAmount,
                   MortgageInterestRate,Interest,RedemptionStatus,LastUpdateTime)
            Select  ObjectType, MortgageSequenceNumber,TradeDate,AccountingEntity,Corporation,Commodity,Currency,
                   Counterparty,MortgageDirection,MortgageVolume,MortgageRate,Volume,MortgagePrice,TotalAmount,
                   MortgageInterestRate,Interest,RedemptionStatus,GetDate()
            From @mortgage
            Where PhysicalId IS NULL

    END
    
    --(2014/10/16) Hedong: FIX 因执行系统中客户名称的修改造成同一序号的质(解)押记录的客户名称不一致的问题!
    --根据如武的描述，一个序号的质(解)押闭环，只会有一个客户!
    IF Exists(SELECT COUNT(*) FROM SyncSpotMortgage GROUP BY MortgageSequenceNumber HAVING COUNT(DISTINCT Counterparty)>1)
        UPDATE SyncSpotMortgage
        SET Counterparty=c.Counterparty, LastUpdateTime=GETDATE()
        FROM SyncSpotMortgage INNER JOIN (
            SELECT b.SequenceNumber, a.Counterparty 
            FROM SyncSpotMortgage a INNER JOIN (
                SELECT MortgageSequenceNumber AS SequenceNumber, MAX(Id) AS Id
                FROM SyncSpotMortgage
                GROUP BY MortgageSequenceNumber
                HAVING COUNT(DISTINCT Counterparty)>1 
            )b ON a.Id=b.Id
        )c On SyncSpotMortgage.MortgageSequenceNumber=c.SequenceNumber

End
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--***************************************************
-- 所有质押合同未赎回重量的列表SP修改
CREATE PROCEDURE [dbo].[CalcUnpledgedContracts]
	@CustomerId int = NULL,
    @TradeType smallint = NULL,
	@CorporationId int = NULL,
    @CommodityId int = NULL,
    @AccountingEntityId int = NULL,
    @CurrencyId int = NULL,
    @ContractCode nvarchar(500) = NULL
as
with
T
as
(
	SELECT
		CI.WFContractInfoId,
		CI.CommodityId,
		CI.AccountingEntityId,
		CI.SalerId,
		CI.CurrencyId,
		CI.ContractCode,
		CI.CustomerId,
		CI.SignDate,
		PC.PledgeInterestRate,
		PC.PledgeRate,
		PC.PledgeType,
		PC.PledgeDays,
		PC.ExpiryDate,
		CI.CommodityHappened as PledgedWeight,
		CI.UnitId,
		(select sum(CI2.CommodityHappened) from WFContractInfo CI2 where CI2.ParentId = CI.WFContractInfoId and CI2.IsDeleted = 0) as UnpledgedWeight
	from 
		WFContractInfo CI
		inner join WFPledgeContract PC on CI.WFContractInfoId = PC.WFContractInfoId
	where 
		CI.ContractType = 6
		AND CI.IsDeleted = 0
		and CI.IsBuy = 0
		and CI.ContractMapType = 1
		and (CI.CustomerId = (case when @CustomerId is not null then @CustomerId END) or (@CustomerId is null and CI.CustomerId is not null))
		and ((CI.TradeType & (case when @TradeType is not null then @TradeType END)) <> 0 or (@TradeType is null and CI.TradeType is not null))
		and (CI.CorporationId = (case when @CorporationId is not null then @CorporationId END) or (@CorporationId is null and CI.CorporationId is not null))
		and (CI.CommodityId = (case when @CommodityId is not null then @CommodityId END) or (@CommodityId is null and CI.CommodityId is not null))
		and (CI.AccountingEntityId = (case when @AccountingEntityId is not null then @AccountingEntityId END) or (@AccountingEntityId is null and CI.AccountingEntityId is not null))
		and (CI.CurrencyId = (case when @CurrencyId is not null then @CurrencyId END) or (@CurrencyId is null and CI.CurrencyId is not null))
		and (CI.ContractCode like N'%'+(case when @ContractCode is not null then @ContractCode END)+N'%' or (@ContractCode is null and CI.ContractCode is not null))
),
T1
as
(
	select
	  T.WFContractInfoId, T.CommodityId, T.AccountingEntityId, T.SalerId, T.CurrencyId, T.ContractCode, T.CustomerId,
	   T.SignDate, T.PledgeInterestRate, T.PledgeRate, T.PledgeType, T.PledgeDays, T.ExpiryDate,T.UnitId,
	   (T.PledgedWeight - (case when T.UnpledgedWeight is not null then T.UnpledgedWeight else 0 end)) as UnpledgedWeight
	from T T
)

select
  -- 不用select * 为以后万一调整返回字段作准备
  T1.WFContractInfoId, T1.CommodityId, T1.AccountingEntityId, T1.SalerId, T1.CurrencyId, T1.ContractCode, T1.CustomerId, T1.SignDate,
   T1.PledgeInterestRate, T1.PledgeRate, T1.PledgeType, T1.PledgeDays, T1.ExpiryDate, T1.UnitId,T1.UnpledgedWeight
from T1 T1 where T1.UnpledgedWeight > 0
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


------------------------计算合同总额和发生额修改---------------------------------------
CREATE procedure [dbo].[SPCalculateActualTotalAmount]
@contractIdStr varchar(max)
as
begin	 
	declare @result  varchar(max)
	set @result='';
	declare @next int 
	set @next=1 
	while @next<=dbo.Get_StrArrayLength(@contractIdStr,',') 
	begin 
		declare @tempContractId int
		declare @tempAmountHappened decimal(18,2)
		set @tempContractId=Cast(dbo.Get_StrArrayStrOfIndex(@contractIdStr,',',@next)  as int);
		set @tempAmountHappened= dbo.FnCalculateActualTotalAmount(@tempContractId);
		if @tempAmountHappened is null set @tempAmountHappened=-1
		set @result += Cast(@tempContractId as varchar)+'_'+Cast(@tempAmountHappened as varchar) +',';
		print @result
		set @next=@next+1 
	end 
	--
	select @result	
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SPCalculateAmountFutureValueHappened]
@contractIdStr varchar(1000)
as
begin     
    declare @result varchar(5000)
    set @result='';
    declare @next int 
    set @next=1 
    while @next<=dbo.Get_StrArrayLength(@contractIdStr,',') 
    begin 
        declare @tempContractId int
        declare @tempAmountHappened decimal(18,2)
        set @tempContractId=Cast(dbo.Get_StrArrayStrOfIndex(@contractIdStr,',',@next)  as int);
        set @tempAmountHappened= dbo.FNCalculateAmountFutureValueHappened(@tempContractId);
        if @tempAmountHappened is null set @tempAmountHappened=-1
        set @result += Cast(@tempContractId as varchar)+'_'+Cast(@tempAmountHappened as varchar) +',';
        print @result
        set @next=@next+1 
    end 
    --
    select @result    
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SPCalculateAmountHappened]
@contractIdStr varchar(max)
as
begin	 
	declare @result varchar(max)
	set @result='';
	declare @next int 
	set @next=1 
	while @next<=dbo.Get_StrArrayLength(@contractIdStr,',') 
	begin 
		declare @tempContractId int
		declare @tempAmountHappened decimal(18,2)
		set @tempContractId=Cast(dbo.Get_StrArrayStrOfIndex(@contractIdStr,',',@next)  as int);
		set @tempAmountHappened= dbo.FNCalculateAmountHappened(@tempContractId);
		if @tempAmountHappened is null set @tempAmountHappened=-1
		set @result += Cast(@tempContractId as varchar)+'_'+Cast(@tempAmountHappened as varchar) +',';
		print @result
		set @next=@next+1 
	end 
	--
	select @result	
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[SPCalculateAmoutApplied]
@contractIdStr varchar(1000)
as
begin	 
	declare @result varchar(5000)
	set @result='';
	declare @next int 
	set @next=1 
	while @next<=dbo.Get_StrArrayLength(@contractIdStr,',') 
	begin 
		declare @tempContractId int
		declare @tempAmountHappened decimal(18,2)
		set @tempContractId=Cast(dbo.Get_StrArrayStrOfIndex(@contractIdStr,',',@next)  as int);
		set @tempAmountHappened= dbo.FnCalculateAmountApplied(@tempContractId);
		if @tempAmountHappened is null set @tempAmountHappened=-1
		set @result += Cast(@tempContractId as varchar)+'_'+Cast(@tempAmountHappened as varchar) +',';
		print @result
		set @next=@next+1 
	end 
	--
	select @result	
end

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SPCalculateCommodityHappened]
@contractIdStr varchar(1000)
as
begin	 
	declare @result varchar(5000)
	set @result='';
	declare @next int 
	set @next=1 
	while @next<=dbo.Get_StrArrayLength(@contractIdStr,',') 
	begin 
		declare @tempContractId int
		declare @tempWegithHappened decimal(18,4)
		set @tempContractId=Cast(dbo.Get_StrArrayStrOfIndex(@contractIdStr,',',@next)  as int);
		set @tempWegithHappened= dbo.FNCalculateCommodityHappened(@tempContractId);
		if @tempWegithHappened is null set @tempWegithHappened=-1
		set @result += Cast(@tempContractId as varchar)+'_'+Cast(@tempWegithHappened as varchar) +',';
		print @result
		set @next=@next+1 
	end 
	--
	select @result	
end

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[SPCalculateContractWeight]
@contractIdStr varchar(1000)
as
begin	 
	declare @result varchar(5000)
	set @result='';
	declare @next int 
	set @next=1 
	while @next<=dbo.Get_StrArrayLength(@contractIdStr,',') 
	begin 
		declare @tempContractId int
		declare @tempAmountHappened decimal(18,8)
		set @tempContractId=Cast(dbo.Get_StrArrayStrOfIndex(@contractIdStr,',',@next)  as int);
		set @tempAmountHappened= dbo.FnCalculateContractWeight(@tempContractId);
		if @tempAmountHappened is null set @tempAmountHappened=-1
		set @result += Cast(@tempContractId as varchar)+'_'+Cast(@tempAmountHappened as varchar) +',';
		print @result
		set @next=@next+1 
	end 
	--
	select @result	
end



GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[SPCalculateInvoiceApplied]
@contractIdStr varchar(1000)
as
begin	 
	declare @result varchar(5000)
	set @result='';
	declare @next int 
	set @next=1 
	while @next<=dbo.Get_StrArrayLength(@contractIdStr,',') 
	begin 
		declare @tempContractId int
		declare @tempAmountHappened decimal(18,2)
		set @tempContractId=Cast(dbo.Get_StrArrayStrOfIndex(@contractIdStr,',',@next)  as int);
		set @tempAmountHappened= dbo.FnCalculateInvoiceApplied(@tempContractId);
		if @tempAmountHappened is null set @tempAmountHappened=-1
		set @result += Cast(@tempContractId as varchar)+'_'+Cast(@tempAmountHappened as varchar) +',';
		print @result
		set @next=@next+1 
	end 
	--
	select @result	
end

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SPCalculateInvoiceFutureValueHappened]
@contractIdStr varchar(1000)
as
begin     
    declare @result varchar(5000)
    set @result='';
    declare @next int 
    set @next=1 
    while @next<=dbo.Get_StrArrayLength(@contractIdStr,',') 
    begin 
        declare @tempContractId int
        declare @tempAmountHappened decimal(18,2)
        set @tempContractId=Cast(dbo.Get_StrArrayStrOfIndex(@contractIdStr,',',@next)  as int);
        set @tempAmountHappened= dbo.FnCalculateInvoiceFutureValueHappened(@tempContractId);
        if @tempAmountHappened is null set @tempAmountHappened=-1
        set @result += Cast(@tempContractId as varchar)+'_'+Cast(@tempAmountHappened as varchar) +',';
        print @result
        set @next=@next+1 
    end 
    --
    select @result    
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[SPCalculateInvoiceHappened]
@contractIdStr varchar(1000)
as
begin	 
	declare @result varchar(5000)
	set @result='';
	declare @next int 
	set @next=1 
	while @next<=dbo.Get_StrArrayLength(@contractIdStr,',') 
	begin 
		declare @tempContractId int
		declare @tempAmountHappened decimal(18,2)
		set @tempContractId=Cast(dbo.Get_StrArrayStrOfIndex(@contractIdStr,',',@next)  as int);
		set @tempAmountHappened= dbo.FnCalculateInvoiceHappened(@tempContractId);
		if @tempAmountHappened is null set @tempAmountHappened=-1
		set @result += Cast(@tempContractId as varchar)+'_'+Cast(@tempAmountHappened as varchar) +',';
		print @result
		set @next=@next+1 
	end 
	--
	select @result	
end

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPGenerateInvoiceReport]
    @CommodityIdList NVARCHAR(MAX),
    @DepartmentIdList NVARCHAR(MAX),
    @ContractIdList NVARCHAR(MAX),
    @CustomerId INT,
    @ContractCode NVARCHAR(50),
    @IsReceive BIT,
    @CommodityId INT,
    @CorporationId INT,
    @DepartmentId INT,
    @UnitId INT,
    @CurrencyId INT,
    @StartDate DATETIME,
    @EndDate DATETIME,
    @PageSize INT,
    @PageIndex INT
AS
BEGIN   
    if @IsReceive is null
        throw 50000, N'@IsReceive is null', 1;

    DECLARE @OffsetCount INT
    DECLARE @FetchCount INT
    DECLARE @TotalCount INT
    DECLARE @ContractId TABLE(id INT)
    DECLARE @TempTable TABLE
    (
        WFContractInfoId int
        , IsReturn bit not null
        , IsPurchase bit not null
        , ContractCode NVARCHAR(50)
        , SignDate DATETIME
        , ContractUnitId INT
        , ContractCurrenyId INT
        , CustomerId INT
        , DepartmentId INT
        , CommodityId INT
          
        , AppliedInvoiceAmount DECIMAL(30, 8)
        , HappenedInvoiceAmount DECIMAL(30, 8)
        , ContractWeight DECIMAL(30, 8) -- 总过账量
        , HappenedInvoiceWeight DECIMAL(30, 8)
        , ContractAmount DECIMAL(30, 8)
        , AppliedInvoiceWeight DECIMAL(30, 8)
        , NotHappenedInvoiceWeight DECIMAL(30, 8)
          
        , TotalCount INT
    )

    INSERT INTO @ContractId
        SELECT 
            WFContractInfoId
        FROM 
            dbo.WFContractInfo 
        WHERE 
            IsDeleted = 0
            AND StatusOfInvoice <> 4
            AND (@CustomerId IS NULL OR (CustomerId = @CustomerId))
            AND (@ContractCode IS NULL OR (ContractCode LIKE N'%' + @ContractCode + N'%'))
            AND (IsPurchase = @IsReceive)
            AND ((@CommodityId IS NULL AND (@CommodityIdList is null or CommodityId IN (SELECT * FROM dbo.FnSplitStrToInt(@CommodityIdList, ',')))) or (CommodityId = @CommodityId))
            AND (@CorporationId IS NULL OR (CorporationId = @CorporationId))
            AND ((@DepartmentId IS NULL AND (@DepartmentIdList is null or DepartmentId IN(SELECT * FROM dbo.FnSplitStrToInt(@DepartmentIdList, ',')))) OR (DepartmentId = @DepartmentId))

            AND (@UnitId IS NULL OR (UnitId = @UnitId))
            AND (@CurrencyId IS NULL OR (CurrencyId = @CurrencyId))
            AND (@StartDate IS NULL OR (CreateTime >= @StartDate))
            AND (@EndDate IS NULL OR (CreateTime <= @EndDate))
            AND (@ContractIdList IS NULL OR (WFContractInfoId IN (SELECT * FROM dbo.FnSplitStrToInt(@ContractIdList, ','))))

    INSERT INTO @TempTable (
        WFContractInfoId 
        , IsReturn
        , IsPurchase
        , ContractCode 
        , SignDate 
        , ContractUnitId 
        , ContractCurrenyId 
        , CustomerId 
        , DepartmentId
        , CommodityId 
        , AppliedInvoiceAmount 
        , HappenedInvoiceAmount 
        , ContractWeight 
        , HappenedInvoiceWeight 
        , ContractAmount 
        , AppliedInvoiceWeight 
    )
    SELECT [t0].[WFContractInfoId]
    , [t0].[IsReturn]
    , [t0].[IsPurchase]
    , [t0].[ContractCode]
    , [t0].[SignDate]
    , [t0].[UnitId] AS [ContractUnitId]
    , [t0].[CurrencyId] AS [ContractCurrenyId]
    , [t0].[CustomerId]
    , [t0].[DepartmentId]
    , [t0].[CommodityId]
    , COALESCE(dbo.FnCalculateInvoiceApplied(WFContractInfoId), 0) as AppliedInvoiceAmount
    , COALESCE(dbo.FnCalculateInvoiceHappened(WFContractInfoId), 0) as HappenedInvoiceAmount
    , COALESCE((
        SELECT SUM([t8].[value])
        FROM (
            SELECT [t4].[value] + (COALESCE((
                SELECT SUM([t7].[value])
                FROM (
                    SELECT [t5].[PostingWeight] AS [value], [t5].[IsDeleted], [t6].[IsDeleted] AS [IsDeleted2], [t6].[SAPStatus]
                        , [t6].[ObjectType], [t5].[ObjectType] AS [ObjectType2], [t6].[UnitId]
                        , [t5].[WFPostingInfoId], [t6].[WFPostingInfoId] AS [WFPostingInfoId2], [t5].[ObjectId]
                    FROM [WFPostingInfoDetail] AS [t5], [WFPostingInfo] AS [t6]
                    ) AS [t7]
                WHERE (([t7].[IsDeleted] = 0)) AND (([t7].[IsDeleted2] = 0)) AND ([t7].[SAPStatus] = 2) 
                    AND ([t7].[ObjectType] = 3) AND ([t7].[ObjectType2] = 3) AND ([t0].[UnitId] = [t7].[UnitId]) 
                    AND ([t7].[WFPostingInfoId] = ([t7].[WFPostingInfoId2])) AND ([t7].[ObjectId] = [t4].[WFPostingInfoDetailId])
                ), 0)) AS [value]
                , [t4].[IsDeleted], [t4].[IsDeleted2], [t4].[IsDeleted3], [t4].[SAPStatus], [t4].[ObjectType], [t4].[ObjectType2]
                , [t4].[UnitId], [t4].[WFPostingInfoId], [t4].[WFPostingInfoId2], [t4].[ObjectId], [t4].[WFContractDetailInfoId], [t4].[WFContractInfoId]
            FROM (
                SELECT [t2].[WFPostingInfoDetailId], [t2].[PostingWeight] AS [value]
                    , [t1].[IsDeleted], [t2].[IsDeleted] AS [IsDeleted2], [t3].[IsDeleted] AS [IsDeleted3], [t3].[SAPStatus]
                    , [t3].[ObjectType], [t2].[ObjectType] AS [ObjectType2], [t3].[UnitId], [t2].[WFPostingInfoId], [t3].[WFPostingInfoId] AS [WFPostingInfoId2]
                    , [t2].[ObjectId], [t1].[WFContractDetailInfoId], [t1].[WFContractInfoId]
                FROM [WFContractDetailInfo] AS [t1], [WFPostingInfoDetail] AS [t2], [WFPostingInfo] AS [t3]
                ) AS [t4]
            ) AS [t8]
        WHERE (([t0].[IsDeleted] = 0)) AND (([t8].[IsDeleted] = 0)) AND (([t8].[IsDeleted2] = 0)) AND (([t8].[IsDeleted3] = 0)) AND ([t8].[SAPStatus] = 2) 
            AND ([t8].[ObjectType] = ((CASE WHEN [t0].[IsBuy] = 1 THEN 1 ELSE 2 END))) 
            AND ([t8].[ObjectType2] = 4) AND ([t0].[UnitId] = [t8].[UnitId]) AND ([t8].[WFPostingInfoId] = ([t8].[WFPostingInfoId2])) 
            AND ([t8].[ObjectId] = [t8].[WFContractDetailInfoId]) AND ([t8].[WFContractInfoId] = ([t0].[WFContractInfoId]))
        ), 0) AS [ContractWeight]
    , COALESCE(dbo.FnCalculateInvoiceHappenedWeight(WFContractInfoId), 0) as HappenedInvoiceWeight
    , COALESCE(dbo.FnCalculateActualTotalAmount(WFContractInfoId), 0) as ContractAmount
    , COALESCE(dbo.FnCalculateInvoiceAppliedWeight(WFContractInfoId), 0) as AppliedInvoiceWeight
    FROM [WFContractInfo] AS [t0]
    where t0.WFContractInfoId in (select id from @ContractId) 

    UPDATE @TempTable SET NotHappenedInvoiceWeight = ContractWeight - AppliedInvoiceWeight 

    DELETE FROM @TempTable WHERE NotHappenedInvoiceWeight <= 0 

    select @TotalCount = (SELECT COUNT(*) FROM @TempTable) 

    UPDATE @TempTable SET TotalCount = @TotalCount 

    if @PageIndex > 0 and @PageSize > 0 
        select @OffsetCount = (@PageIndex - 1) * @PageSize, @FetchCount = @PageSize  
    else 
        select @OffsetCount = 0, @FetchCount = (case when @TotalCount > 0 then @TotalCount else 1 end) 

    SELECT WFContractInfoId
    , IsReturn
    , IsPurchase
    , ContractCode
    , SignDate
    , ContractUnitId
    , ContractCurrenyId
    , CustomerId
    , DepartmentId
    , CommodityId
    , AppliedInvoiceAmount
    , HappenedInvoiceAmount
    , ContractWeight
    , HappenedInvoiceWeight
    , ContractAmount
    , AppliedInvoiceWeight
    , NotHappenedInvoiceWeight
    , TotalCount
    FROM @TempTable 
    order by WFContractInfoId desc 
    offset @OffsetCount rows 
    fetch next @FetchCount rows only 

END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------存储过程修改---------------------------------
CREATE PROCEDURE [dbo].[SPListSettleUnfinishedCustomers]
	@ExcutorId INT,
	@CorporationId INT,
	@CustomerId INT,
	@AccountEntityId INT,
	@CurrencyId INT,
	@TradeType SMALLINT
AS
BEGIN

--获取用户有权限品种
SELECT distinct WC.WFCommodityId INTO #CommodityId FROM WFUser US
INNER JOIN WFUserRole UR ON UR.WFUserId = US.WFUserId
INNER JOIN WFRoleInfo RI ON RI.WFRoleInfoId = UR.WFRoleInfoId
INNER JOIN WFRoleBusiness RB on RB.WFRoleInfoId = RI.WFRoleInfoId
INNER JOIN WFBusiness BU ON RB.WFBusinessId = BU.WFBusinessId
INNER JOIN WFCommodity WC ON WC.WFCommodityId = BU.WFCommodityId
WHERE US.WFUserId = @ExcutorId

--获取用户有权限的核算主体
declare @AccountEntityT table
(
	AccountEntityId int
)
if @AccountEntityId <>0
    INSERT @AccountEntityT VALUES (@AccountEntityId)
else
	INSERT @AccountEntityT
		SELECT distinct WC.WFAccountEntityId FROM WFUser US    
		INNER JOIN WFUserRole UR ON UR.WFUserId = US.WFUserId
		INNER JOIN WFRoleInfo RI ON RI.WFRoleInfoId = UR.WFRoleInfoId
		INNER JOIN WFRoleBusiness RB on RB.WFRoleInfoId = RI.WFRoleInfoId
		INNER JOIN WFBusiness BU ON RB.WFBusinessId = BU.WFBusinessId
		INNER JOIN WFAccountEntity WC ON WC.WFAccountEntityId in
		 (select AccountEntityId from WFDepartmentAccountEntity where DepartmentId = BU.DepartmentId)
		 WHERE US.WFUserId = @ExcutorId
    
--获取所有有未结尾款的客户Id清单
declare @ClientIdT table
(
	ClientId int
)
if @CustomerId <> 0
	insert @ClientIdT values (@CustomerId)
else
	insert @ClientIdT
		SELECT distinct(CustomerId) FROM WFContractInfo WCI
		INNER JOIN WFCompany WC ON WC.WFCompanyId=WCI.CustomerId
		WHERE StatusOfAmount != 4 AND WCI.IsDeleted = 0 AND CorporationId = @CorporationId 
		AND CommodityId IN (SELECT WFCommodityId FROM #CommodityId)
		AND AccountingEntityId IN (SELECT AccountEntityId FROM @AccountEntityT)
		AND ContractType != 3
		AND (@TradeType & WCI.TradeType) > 0
		AND @CurrencyId = WCI.CurrencyId

--计算客户的尾款,已申请款,及未对冲款
select CustomerId, WC.FullName,
SUM(CASE IsBuy WHEN 0 THEN 0 ELSE 1 END) AS PurchaseContractCount,
SUM(CASE IsBuy WHEN 1 THEN 0 ELSE 1 END) AS SaleContractCount,
SUM(PurchaseContractTotalAmount) AS PurchaseContractTotalAmount,
SUM(SaleContractTotalAmount) AS SaleContractTotalAmount,
SUM(PurchaseContractHappenedAmount)AS PurchaseContractHappenedAmount,
SUM(SaleContractHappenedAmount) AS SaleContractHappenedAmount from 
(
	 SELECT 
	 (CASE IsBuy WHEN 1 THEN dbo.FnCalculateActualTotalAmount(WFContractInfoId) ELSE 0 END) AS PurchaseContractTotalAmount,
     (CASE IsBuy WHEN 0 THEN dbo.FnCalculateActualTotalAmount(WFContractInfoId) ELSE 0 END) AS SaleContractTotalAmount,
     (CASE IsBuy WHEN 1 THEN dbo.FNCalculateAmountHappened(WFContractInfoId) ELSE 0 END) AS PurchaseContractHappenedAmount,
     (CASE IsBuy WHEN 0 THEN dbo.FNCalculateAmountHappened(WFContractInfoId) ELSE 0 END) AS SaleContractHappenedAmount,
     CustomerId,IsBuy,WFContractInfoId
	 FROM WFContractInfo WCI
	 WHERE StatusOfAmount != 4 AND WCI.IsDeleted=0 AND CorporationId = @CorporationId AND StatusOfContract not in (2,1)
	 AND CommodityId IN (SELECT WFCommodityId FROM #CommodityId)
	 AND AccountingEntityId IN (SELECT AccountingEntityId FROM @AccountEntityT)
	 AND ContractType != 3 
	 AND CustomerId IN (SELECT ClientId FROM @ClientIdT)
	 AND (@TradeType & WCI.TradeType) > 0
	 AND @CurrencyId = WCI.CurrencyId) M
INNER JOIN WFCompany WC ON WC.WFCompanyId = M.CustomerId And wc.IsDeleted=0
group by CustomerId,WC.FullName
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SpMaintainCurrencyPair] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    insert into WFCurrencyPair (BaseCurrencyId, CounterCurrencyId) 
    select b.WFCurrencyId, c.WFCurrencyId  
    from WFCurrency b, WFCurrency c 
    where b.WFCurrencyId <> c.WFCurrencyId 
    except 
    select p.BaseCurrencyId, p.CounterCurrencyId 
    from WFCurrencyPair p 

END
GO
