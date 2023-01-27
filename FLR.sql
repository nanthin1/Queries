if exists(select * from sys.views where name = 'vw_FLR3')
drop view vw_FLR3
go
create view vw_FLR3
as
select 
mcd1.MCD_CAT_NAME category1
,mcd2.MCD_CAT_NAME category2
,mcd3.MCD_CAT_NAME category3
,'Sales '+mcd3.MCD_CAT_NAME type
,sum(mss_trans_qty) Stock
,3 OrderNo
,convert(int,trim(replace(mcd3.MCD_CAT_NAME,'ML',''))) categoryOrder
from med_item_hdr mih
left outer join med_category_dtl as mcd1 with (nolock) on mcd1.mcd_cat_code=mih.mih_category_1 and mcd1.mcd_cat_aname ='MIH_CATEGORY_1'              
left outer join med_category_dtl as mcd2 with (nolock) on mcd2.mcd_cat_code=mih.mih_category_2 and mcd2.mcd_cat_aname ='MIH_CATEGORY_2'              
left outer join med_category_dtl as mcd3 with (nolock) on mcd3.mcd_cat_code=mih.MIH_CATEGORY_3 and mcd3.mcd_cat_aname ='MIH_CATEGORY_3'               
inner join med_stock_sales on MSS_ITEMCODE = MIH_ITEM_CODE
--where mih_item_code >=33 and MSS_TRAN_TYPE = 5
group by mcd1.MCD_CAT_NAME,mcd2.MCD_CAT_NAME,mcd3.MCD_CAT_NAME,MIH_ITEM_CODE

union all

select 
mcd1.MCD_CAT_NAME category1
,mcd2.MCD_CAT_NAME category2
,mcd3.MCD_CAT_NAME category3
,'Purchase '+mcd3.MCD_CAT_NAME type
,sum(mss_trans_qty) Stock
,2 OrderNo
,convert(int,trim(replace(mcd3.MCD_CAT_NAME,'ML',''))) categoryOrder
from med_item_hdr mih
left outer join med_category_dtl as mcd1 with (nolock) on mcd1.mcd_cat_code=mih.mih_category_1 and mcd1.mcd_cat_aname ='MIH_CATEGORY_1'              
left outer join med_category_dtl as mcd2 with (nolock) on mcd2.mcd_cat_code=mih.mih_category_2 and mcd2.mcd_cat_aname ='MIH_CATEGORY_2'              
left outer join med_category_dtl as mcd3 with (nolock) on mcd3.mcd_cat_code=mih.MIH_CATEGORY_3 and mcd3.mcd_cat_aname ='MIH_CATEGORY_3'               
inner join med_stock_sales on MSS_ITEMCODE = MIH_ITEM_CODE
--where mih_item_code >=33 and MSS_TRAN_TYPE = 3
group by mcd1.MCD_CAT_NAME,mcd2.MCD_CAT_NAME,mcd3.MCD_CAT_NAME,MIH_ITEM_CODE

union all

select 
mcd1.MCD_CAT_NAME category1
,mcd2.MCD_CAT_NAME category2
,mcd3.MCD_CAT_NAME category3
,'Opening '+mcd3.MCD_CAT_NAME type
,sum(mss_trans_qty) Stock
,1 OrderNo
,convert(int,trim(replace(mcd3.MCD_CAT_NAME,'ML',''))) categoryOrder
from med_item_hdr mih
left outer join med_category_dtl as mcd1 with (nolock) on mcd1.mcd_cat_code=mih.mih_category_1 and mcd1.mcd_cat_aname ='MIH_CATEGORY_1'              
left outer join med_category_dtl as mcd2 with (nolock) on mcd2.mcd_cat_code=mih.mih_category_2 and mcd2.mcd_cat_aname ='MIH_CATEGORY_2'              
left outer join med_category_dtl as mcd3 with (nolock) on mcd3.mcd_cat_code=mih.MIH_CATEGORY_3 and mcd3.mcd_cat_aname ='MIH_CATEGORY_3'               
inner join med_stock_sales on MSS_ITEMCODE = MIH_ITEM_CODE
--where mih_item_code >=33 and MSS_TRAN_TYPE = 30
group by mcd1.MCD_CAT_NAME,mcd2.MCD_CAT_NAME,mcd3.MCD_CAT_NAME,MIH_ITEM_CODE

union all

select 
mcd1.MCD_CAT_NAME category1
,mcd2.MCD_CAT_NAME category2
,mcd3.MCD_CAT_NAME category3
,'Closing '+mcd3.MCD_CAT_NAME type
,sum(mss_trans_qty) Stock
,4 OrderNo
,convert(int,trim(replace(mcd3.MCD_CAT_NAME,'ML',''))) categoryOrder
from med_item_hdr mih
left outer join med_category_dtl as mcd1 with (nolock) on mcd1.mcd_cat_code=mih.mih_category_1 and mcd1.mcd_cat_aname ='MIH_CATEGORY_1'              
left outer join med_category_dtl as mcd2 with (nolock) on mcd2.mcd_cat_code=mih.mih_category_2 and mcd2.mcd_cat_aname ='MIH_CATEGORY_2'              
left outer join med_category_dtl as mcd3 with (nolock) on mcd3.mcd_cat_code=mih.MIH_CATEGORY_3 and mcd3.mcd_cat_aname ='MIH_CATEGORY_3'               
inner join med_stock_sales on MSS_ITEMCODE = MIH_ITEM_CODE
--where mih_item_code >=33 
group by mcd1.MCD_CAT_NAME,mcd2.MCD_CAT_NAME,mcd3.MCD_CAT_NAME,MIH_ITEM_CODE
go

select * from vw_FLR3 order by OrderNo,categoryOrder desc

EXEC proc_testcat

if exists(select * from sys.procedures where name ='proc_testcat')
drop proc proc_testcat
go
create procedure proc_testcat
as
Declare @PivotCol nvarchar(max) 
DECLARE @query AS NVARCHAR(MAX)
DECLARE @cols AS NVARCHAR(MAX)
Declare @dbae1 varchar(100)             
Declare @Task1 varchar(1000)


raiserror ('HIHELLO',16,1)
set @dbae1='testcat';                                                               
SET @Task1 = 'IF EXISTS (SELECT * FROM sysobjects WHERE name = ' + CHAR(39) + @DBAE1 + CHAR(39) + ') DROP TABLE ' + @DBAE1                                
execute (@task1)  

Set @PivotCol= ' select @cols1 = STUFF((SELECT '','' + QUOTENAME(type)  from vw_FLR3 '            
Set @PivotCol= @PivotCol+ ' group by type,OrderNo,categoryOrder order by OrderNo,categoryOrder desc FOR XML PATH('''')'            
Set @PivotCol= @PivotCol+ ' , TYPE).value(''.'', ''NVARCHAR(MAX)'') ,1,1,'''')'            
Exec sp_executesql @PivotCol, N'@cols1 nvarchar(max) Output', @cols Output    
print @cols
         
if isnull(@cols,'') =''            
set @query =  'select category1,category2,type into testcat from VW_FLR3 '            
else             
set @query =  'select * into testcat from             
          (            
          select category1,category2,type,stock             
          from VW_FLR3             
          )temp            
          pivot (sum(stock) for type in (' + @cols + '))pv'            
         
execute(@query);  
go



select *
from (select mcd1.MCD_CAT_NAME cat1,mcd2.MCD_CAT_NAME cat2 from med_item_hdr mih
left outer join med_category_dtl as mcd1 with (nolock) on mcd1.mcd_cat_code=mih.mih_category_1 and mcd1.mcd_cat_aname ='MIH_CATEGORY_1'              
left outer join med_category_dtl as mcd2 with (nolock) on mcd2.mcd_cat_code=mih.mih_category_2 and mcd2.mcd_cat_aname ='MIH_CATEGORY_2'              
where mih_item_code  >=33 
group by mcd1.MCD_CAT_NAME,mcd2.MCD_CAT_NAME) base
inner join testcat on cat1 = category1 and cat2 = category2


delete from sr_report_base where REPORT_ID = 800
go
insert into sr_report_base(REPORT_ID,RETAIL_OUTLET_ID,REPORT_NAME,REPORT_DESC,SQL_FROM,SQL_WHERE,SQL_HAVING,IS_BASE,PROCEDURE_REPORT,PROCEDURE_FIXED_COLUMN,PROCEDURE_VIEW_NAME,IS_CATEGORY,CATEGORY_FIELD_NAME,DATE_FILTER,DATE_FILTER_NAME,DATE_REPLACE,TIME_FILTER,FILTER_LIST,RESOURCE_NAME,INVOICE_TYPE,JAVASCRIPT_CODE,IS_IMAGE_REPORT,IMAGE_URL,IMAGE_HEADER,IMAGE_SUB_HEADER,PARAM_LIST,PARAM_CONDITION,PARAM_CHECK_LIST,SHOW_FILTER,SHOW_CATEGORY_COLUMNS,IS_SCREEN_VISIBLE,IS_MOBILE_VISIBLE,IS_TAB_VISIBLE,IS_EXPORT_VISIBLE,IS_PRINT_VISIBLE,SRB_ADVANCE_OPTIONS,SR2_ENABLED,IS_MULTIPLE_USE,QUERY_HINT,SQL_WITH,INFO_BOX,IS_GROUP_EXPAND_ENABLED,GROUP_COLUMN,IS_TOP_N,SQL_HEADER,PARENT_REPORT,ALIAS_NAME,IS_ARCHIVAL_REPORT,NUMBER_OF_DAYS,IS_ADVANCE_FILTER_NEEDED,REGIONAL_LIST,API,CONNECT_SLAVE_DB,SERIAL_ENABLED,IMAGE_COL_REF) 
values(800,5,'FLR3A','',' from (select mcd1.MCD_CAT_NAME cat1,mcd2.MCD_CAT_NAME cat2 from med_item_hdr mih
left outer join med_category_dtl as mcd1 with (nolock) on mcd1.mcd_cat_code=mih.mih_category_1 and mcd1.mcd_cat_aname =''MIH_CATEGORY_1''              
left outer join med_category_dtl as mcd2 with (nolock) on mcd2.mcd_cat_code=mih.mih_category_2 and mcd2.mcd_cat_aname =''MIH_CATEGORY_2''               
group by mcd1.MCD_CAT_NAME,mcd2.MCD_CAT_NAME) base
inner join testcat on cat1 = category1 and cat2 = category2 ','','',0,'Execute proc_testcat','2','testcat',0,'','','',0,0,'','','','',0,'','','','','','',1,0,1,0,1,1,1,'',0,1,'','','',0,'',0,'',0,'',0,0,1,'','',0,0,'')
go
delete from sr_report_field where REPORT_ID = 800
go
insert into sr_report_field(REPORT_ID,RETAIL_OUTLET_ID,COL_DEFAULT_TITLE,SQL_COLUMN,COL_TITLE,COL_ORDERBY,ORDERBY_TYPE,COL_POSITION,COL_WIDTH,COL_GROUPBY,COL_TYPE,COL_SELECTED,IS_GROUPED,IS_TOTAL,IS_HIDE,IS_MOBILE_HIDE,IS_SCREEN_HIDE,IS_TAB_HIDE,IS_FORMULA,IS_FILTER,IS_REMOVED,IS_CONTRIBUTION,IS_AVERAGE,IS_EXPORT_HIDE,IS_PRINT_HIDE,IS_LOV,IS_LOV_MANDATORY,LOV_FLDNAME,LOV_TABNAME,LOV_ORDERBY,LOV_KEYFIELD,LOV_WHEREFIELD,LOV_CAPTION,LOV_REL_KEYFIELD,IS_PROCEDURE_DELETE,PROCEDURE_ARG,COL_LINK,EDIT_LINK,FORMULA_CONDITION,FILTER_CONDITION,IS_DELETED,IS_COL_NEED,AJAX_FILTER_TYPE,TAX_TYPE,COLUMN_DESC,COL_COLOR,REF_GROUPBY,ALLOW_DUPLICATE,PARENT_REPORT,ALLOW_REMOVE,IS_COL_AVERAGE,IS_REGIONAL,isFormulaPublic,isCustomFormula,formula_json,COL_MOBILE_POSITION,COL_MOBILE_WIDTH,IS_API_FIELD) 
values(800,5,'Category1','cat1','Category1',0,'',1,20,0,'T',1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'','','','','','','',0,1,'','','','',0,1,'','','','','',1,0,1,0,0,1,0,'',0,10,0)
go
insert into sr_report_field(REPORT_ID,RETAIL_OUTLET_ID,COL_DEFAULT_TITLE,SQL_COLUMN,COL_TITLE,COL_ORDERBY,ORDERBY_TYPE,COL_POSITION,COL_WIDTH,COL_GROUPBY,COL_TYPE,COL_SELECTED,IS_GROUPED,IS_TOTAL,IS_HIDE,IS_MOBILE_HIDE,IS_SCREEN_HIDE,IS_TAB_HIDE,IS_FORMULA,IS_FILTER,IS_REMOVED,IS_CONTRIBUTION,IS_AVERAGE,IS_EXPORT_HIDE,IS_PRINT_HIDE,IS_LOV,IS_LOV_MANDATORY,LOV_FLDNAME,LOV_TABNAME,LOV_ORDERBY,LOV_KEYFIELD,LOV_WHEREFIELD,LOV_CAPTION,LOV_REL_KEYFIELD,IS_PROCEDURE_DELETE,PROCEDURE_ARG,COL_LINK,EDIT_LINK,FORMULA_CONDITION,FILTER_CONDITION,IS_DELETED,IS_COL_NEED,AJAX_FILTER_TYPE,TAX_TYPE,COLUMN_DESC,COL_COLOR,REF_GROUPBY,ALLOW_DUPLICATE,PARENT_REPORT,ALLOW_REMOVE,IS_COL_AVERAGE,IS_REGIONAL,isFormulaPublic,isCustomFormula,formula_json,COL_MOBILE_POSITION,COL_MOBILE_WIDTH,IS_API_FIELD) 
values(800,5,'Category2','cat2','Category2',0,'',2,20,0,'T',1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'','','','','','','',0,1,'','','','',0,1,'','','','','',1,0,1,0,0,1,0,'',0,10,0)
go
update sr_report_field set TAX_TYPE = NULL,col_link = NULL,lov_orderby = NULL,LOV_REL_KEYFIELD = NULL,edit_link = NULL
,FORMULA_CONDITION = NULL,FILTER_CONDITION = NULL,AJAX_FILTER_TYPE = NULL,COLUMN_DESC = NULL,COL_COLOR = NULL ,REF_GROUPBY = NULL,IS_TAB_HIDE=1 
where REPORT_ID in (800)
go
update sr_report_base set DATE_FILTER_NAME = NULL,RESOURCE_NAME = NULL,JAVASCRIPT_CODE = NULL,IMAGE_URL = NULL,IMAGE_HEADER = NULL,IMAGE_SUB_HEADER =NULL ,PARAM_CHECK_LIST = NULL,SRB_ADVANCE_OPTIONS= NULL,QUERY_HINT = NULL,SQL_WITH = NULL,INFO_BOX = NULL
,sr2_enabled = 1,time_filter=0,DATE_REPLACE=1
where REPORT_ID in (800)
GO

select * from med_report_base where mrb_id<800 order by 1 desc

select * from sr_report_field where REPORT_ID = 800




delete from [dbo].[med_report_base] where mrb_id=800
Go
insert into med_report_base (mrb_id,mrb_name,mrb_sql,mrb_where,mrb_base,mrb_baseId,mrf_report_Desc,mrf_category_id,mrf_user_level,mrb_lookin,mrb_form_color,mrb_gridBack_color,mrb_gridFore_color,mrb_gridFixfore_color,mrb_gridFixBack_color,mrb_gridSelBack_color,mrb_gridSelFore_color,mrb_alternate1_color,mrb_alternate2_color,TS,mrb_procedure,mrb_fixedcol,mrb_retviewname,mrb_date_filter,mrb_asc_desc,Mrb_Skip_Space,Mrb_DateIn_All,Mrb_having,Mrb_numeric_enable,Mrb_Prnt_bold,Mrb_Report_FullScreenRpt,Mrb_Prnt_GrdWdth,Mrb_time_filter,mrb_category_code,Mrb_CNamein_All,Mrb_Printer_Type
,Mrb_Del_Field,Mrb_Prnt_Empty,mrb_date_Replace,Mrb_Column_sort,Mrb_Prnt_UName,Mrb_Print_Mode,mrb_freeze_column,Mrb_Left_Skip,Mrb_Prnt_Cond,Mrb_Param_List,Mrb_Param_Condition,Mrb_Date_Ason,Mrb_Prnt_Land,Mrb_CAddin_All,Mrb_Paper_Type,Mrb_Param_Check_List,Mrb_Prnt_Side,Mrb_Where_Vertical,Mrb_Filter,Mrb_Prnt_Wrap,Mrb_Prnt_Sno,Mrb_Prnt_SideTot,Mrb_Prnt_TitleHide,Mrb_Show_Dash,Mrb_Dash_Type,
Mrb_GridColor,Mrb_GrpHead_Color,Mrb_GrpTotal_Color,Mrb_PrntGrp_Empty,Mrb_gridline,Mrb_gridlinefix,Mrb_GrpHeadSelBack_Color,Mrb_GrpTotalSelBack_Color,mrb_catfldname
,mrb_Inv_type,Mrb_Sql_From,mrb_Iscentral,Mrb_Group_type,Mrb_Prnt_Summary,Mrb_LovForm_Color,Mrb_Hide_Sno,mrb_exp_grdwdth,
Mrb_Prnt_Line,Mrb_Header_Skip,mrb_where_position,mrb_TOPN,mrb_desc,PARENT_ID,mrb_CatId,mrb_linespace,mrb_prnt_colallpage,mrb_prnt_zero,mrb_prnt_pageno,
mrb_font_name,mrb_font_size,mrb_prnt_italic,mrb_top_space,mrb_bottom_space,mrb_left_space,mrb_colhead_align,mrb_numcol_leftalign,mrb_colhead_line,mrb_sno_text,mrb_ISHQ,mrb_sqltabname,mrb_sqlViewname,mrb_ISWebRpt,MRB_GROUP,RETAIL_OUTLET_ID,MRB_ACTION_NAME,MRB_RESOURCE_NAME,MRF_DASH_AXIS,MRB_COMMENT_ENABLED,MRB_NEED_FIXED_ROW,MRB_RETVIEW_COL_FILTER,MRB_JAVASCRIPT_CODE,MRB_FILTER_ENABLED,MRB_FILTER_LIST,mrb_smart_enabled)
Values (800,'FLR3A',' from (select mcd1.MCD_CAT_NAME cat1,mcd2.MCD_CAT_NAME cat2 from med_item_hdr mih
left outer join med_category_dtl as mcd1 with (nolock) on mcd1.mcd_cat_code=mih.mih_category_1 and mcd1.mcd_cat_aname =''MIH_CATEGORY_1''              
left outer join med_category_dtl as mcd2 with (nolock) on mcd2.mcd_cat_code=mih.mih_category_2 and mcd2.mcd_cat_aname =''MIH_CATEGORY_2''              
where mih_item_code  >=33 
group by mcd1.MCD_CAT_NAME,mcd2.MCD_CAT_NAME) base
inner join testcat on cat1 = category1 and cat2 = category2 '
,'',0,0,'FLR3A',0,0,1,'&HDAB787','&HFEF5ED',NULL,'&H8000000E','&HAF7F3C','&H7E4F23','&HFFFFFF','&H8000000E','&H00FEFAF5',NULL,
'exec proc_testcat ','2','testcat','',0,0,1,'',1,0,0,1,0,NULL,0,0,1,0,0,0,0,0,0,0,0,'','',0,0,0,0,NULL,0,'',0,0,0,NULL,NULL,0,'B',
NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,
'',NULL,NULL,NULL,NULL,NULL,NULL,0,
66,0,0,0,NULL,0,0,null,0,0,0,
'Courier New',9,0,0,0,2,NULL,0,0,NULL,0,'','',1,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2)
Go
delete from med_report_field where mrf_report_id =800
Go
Insert into med_report_field (mrf_report_id,mrf_column,mrf_title_default,mrf_title,mrf_tax_type,mrf_type,mrf_position,
mrf_hide,mrf_orderby,mrf_width,mrf_group,mrf_count,mrf_total,mrf_grouptotalall,mrf_selected_field,mrf_load_currentlov,
mrf_groupby,mrf_hide_allow,mrf_group_allow,mrf_total_allow,mrf_grptotal_allow,mrf_count_allow,mrf_formula,mrf_filter,
mrf_FldNames,mrf_TabName,mrf_KeyField,mrf_whereKeyField,Mrf_Procedure_arg,Mrf_Link,MRF_EDIT_LINK,Mrf_Formula_Cond,
MRF_FILTER_CONDITION,mrf_column_removed,Mrf_Formula_Set,Mrf_Numeric_Field,Mrf_TblName_desc,Mrf_Lov_FldName)
values(800,'cat1','Category1','Category1','','T',1,0,0,20,0,0,0,0,1,1,0,0,0,0,0,0,0,0,'','','','',0,'','','','',0,0,0,'','')
GO
Insert into med_report_field (mrf_report_id,mrf_column,mrf_title_default,mrf_title,mrf_tax_type,mrf_type,mrf_position,
mrf_hide,mrf_orderby,mrf_width,mrf_group,mrf_count,mrf_total,mrf_grouptotalall,mrf_selected_field,mrf_load_currentlov,
mrf_groupby,mrf_hide_allow,mrf_group_allow,mrf_total_allow,mrf_grptotal_allow,mrf_count_allow,mrf_formula,mrf_filter,
mrf_FldNames,mrf_TabName,mrf_KeyField,mrf_whereKeyField,Mrf_Procedure_arg,Mrf_Link,MRF_EDIT_LINK,Mrf_Formula_Cond,
MRF_FILTER_CONDITION,mrf_column_removed,Mrf_Formula_Set,Mrf_Numeric_Field,Mrf_TblName_desc,Mrf_Lov_FldName)
values(800,'cat2','Category2','Category2','','T',2,0,0,10,0,0,0,0,1,1,0,0,0,0,0,0,0,0,'','','','',0,'','','','',0,0,0,'','')
GO


select mrf_grouptotalall,* from med_report_field where mrf_report_id = 800
select * from med_report_field where mrf_report_id = 529 and mrf_grouptotalall  =0
update med_report_field set mrf_grouptotalall = 0,mrf_type='T' where mrf_column in ('cat2') and mrf_report_id = 800


select * from sr_report_field where REPORT_ID = 800
delete from sr_report_field where REPORT_ID = 800 and COL_POSITION>2

select * from sr_report_base where REPORT_ID = 800

select * from med_report_field where mrf_report_id = 529 order by mrf_position

select * from testcat

select * from sr_report_disp_config WHERE REPORT_ID = 800

update rsm_menu_master set rsm_menu_code_name = '800' where rsm_menu_code_name = '529'



