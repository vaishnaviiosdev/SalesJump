//
//  AuthenticationModel.swift
//  SalesJump
//
//  Created by San eforce on 28/07/26.
//

import Foundation

struct LoginModel: Codable {
    let success: Bool?
    let message: String?
    let response: LoginResponse?
}

struct LoginBiometric: Codable {
    
}

struct LoginResponse: Codable {
    let status_code: String?
    let SF_Code: String?
    let SF_Name: String?
    let Desig_Code: String?
    let SF_Status: Int?
    let Division_Code: String?
    let State_Code: String?
    let SF_Type: Int?
    let SFTPDate: String?
    let IsBiometricneed: LoginBiometric?
    let Logo_Name: String?
    let ProfilePic: String?
    let DeviveRegId: String?
    let IsDayEnd: String?
    let isNonFieldWork: String?
    let hqLatLng: String?
    let sfJoiningDate: String?
    let secOrdToday: Int?
    let priOrdToday: Int?
    let speedoMeterExpStarted: Int?
    let Message: String?
    let Jwt_Token: String?
    let SenderId: String?
    let BaseUrl: String?
    let ServerPath: String?
}

struct UploadImageResponse: Codable {
    let status: [UploadImageStatus]?
}

struct UploadImageStatus: Codable {
    let message: String?
    let fileName: String?
    let imgUrl: String?
}

struct ProfileImageData: Codable {
    let message: String?
    let imageUrl: String?
}

struct passwordResponse: Codable {
    let message: String?
}

struct getImageData: Codable {
    let base64: String?
    let contentType: String?
    let fileName: String?
}

struct logoutData: Codable {
    let success: Bool?
    let message: String?
}




struct MyDayPlanResponse: Codable {
    let response: DayPlanResponse?
    let isMyDayPlan: Bool?
    let tpList: [TPItem]?
}

struct DayPlanResponse: Codable {
    let sF_Code: String?
    let pln_date: String?
    let datewithtime: String?
    let worktype: String?
    let worktypeName: String?
    let workTypeFlag: String?
    let sf_member_code: String?
    let routeCode: String?
    let routeName: String?
    let remarks: String?
    let division_Code: String?
    let date: String?
    let distributorId: String?
    let distributorName: String?
    let dcrtype: String?
    let hqCode: String?
    let hqName: String?
    let sprstk: String?
    let place_Inv: String?
    let plnDate: String?

    let jointWorkList: [JointWork]?
    let retailerList: [MyDayRetailer]?
    let locationList: [Location]?
}

struct JointWork: Codable {
    let id: String?
    let name: String?
}

struct MyDayRetailer: Codable {
    let id: String?
    let name: String?
}

struct Location: Codable {
    let lat: Double?
    let lng: Double?
}

struct TPItem: Codable {
}







struct AppSetupResponse: Codable {
    let success: Bool?
    let data: [AppSetupData]?
}

struct AppSetupData: Codable {
    
    let SF_Code: String?

    let IsDistributorBased: String?
    let IsSelfJointWorkEnabled: String?
    let Mypln_Event_Capture: String?
    let IsTourPlanRetailerBased: String?
    let stockBasedSecOrder: String?
    let DistBased: String?
    let OfferMode: String?
    let RateEditable: String?
    let OfferMode_web: String?
    let tax_visibility_need: String?
    let closing_stock_uom_need: String?
    let free_edit_need: String?
    let eventCaptureMand: String?
    let SelfieCall: String?
    let empwise_deviation_need: String?
    let ProductRCPANeed: String?
    let Hotel_Bill_Nd: String?
    let Hotel_Bill_Photo_Nd: String?
    let call_Rate_Nd: String?
    let scheme_based: String?
    let uni_edtprc_nd: String?
    let Cl_Filter: String?
    let Prod_Card: String?
    let isgeomap_need: String?
    let Geo_Fencing: String?
    let Dist_Geo_Fencing: String?
    let isPobSobBased: String?
    let OrdRetNeed: String?
    let priRateEditable: String?
    let pri_scheme_visibility: String?
    let pri_scheme_based: String?
    let GEOTagNeed: String?
    let TP_deviation_need: String?
    let Geotag_Mandatory: String?
    let editSubmittedcallNeed: String?
    let leaveEligibility_Nd: String?
    let Audio_Remark: String?
    let Channel_Entry: String?
    let AddRoute_Nd: String?
    let Geo_Track: String?
    let AddDistibutor_Nd: String?
    let proddet: String?
    let hideClosingStockMfg: String?
    let hideClosingStockBatch: String?
    let hideClosingStockCase: String?
    let retailer_creation_geo_tag_mand: String?
    let CollectedAmount: String?
    let UNLNeed: String?
    let TP_ND: String?
    let IsDeviceIdNeed: String?
    let Volume_Nd: String?
    let StkNeed: String?
    let PaymtNd: String?
    let Van_Sales_Need: String?
    let need_order_con: String?
    let VanTransferNeed: String?
    let sample_act_need: String?
    let VanTransferApprovalNeed: String?

    let EDrCap: String?
    let EStkCap: String?
    let ssorder_Caption: String?

    let route_based_fencing_nd: String?
    let total_discount_need: String?
    let Currency_Symbol: String?

    let Mandatory: String?
    let Needed: String?

    let MaxRouteOutlet: Int?
    let PoNumMaxLen: Int?

    let clcap: String?
    let retailerLabelName: String?
    let distributorLabelName: String?
    let routeLabelName: String?

    let distanceRadius: Int?
    let prod_filter_type: Int?

    let OrdRetNeedPri: String?
    let ClSaleEntryNd: String?
    let ForceUpdateNd: String?

    let Inshop_Caption: String?
    let Inshop_Activity_Cap: String?
    let Inshop_OP_Stock_Cap: String?
    let Inshop_CL_Stock_Cap: String?

    let PromotersND: String?
    let InshopND: String?
    let Cus_Form_Nd: String?

    let Inshop_Type: Int?

    let misseddate_Nd: String?
    let Super_stockist_need_in_primary: String?
    let InshopMultiRetailNeed: String?
    let super_stockist_scheme_based: String?
    let SecRetCheckIn: String?
    let Target_woweekoff_nd: String?
    let InshopOpeningEventCaptureNotNeed: String?
    let InshopClosingEventCaptureNotNeed: String?
    let scheme_alert_need: String?
    let order_suggestion_need: String?

    let Gamification_Need: String?
    let Quiz_need: String?
    let Quiz_mand: String?

    let scheme_percentage: Int?

    let StockBasedSampleActivity: String?

    let next_visit_reminder_date_count: Int?

    let next_visit_alert_mandatory: String?
    let next_visit_alert_need: String?
    let SecondaryOrderConfirmNeed: String?

    let nonFieldHqRadius: String?
    let weekOffDays: String?

    let Login_Selfie: String?
    let Logout_Selfie: String?
    let first_call_selfie: String?

    let secondaryOrderDraftNeed: String?
    let Asset_Need: String?
    let ss_scheme_visibility: String?
    let task_management_need: String?
    let multi_uom_need: String?
    let closing_stock_retailer_need: String?

    let ExpenseType: Int?
    let isMultipleExpenseSetupEnabled: Int?

    let Badges: String?
    let SrtEndNd_rem: String?
    let OfferMode_web_disc: String?
    let order_approval_nd: String?
    let SecInvReturnNd: String?
    let invoiceNeed: String?

    let ExpDist_HQ: Int?
    let ExpDist_HQEX: Int?

    let single_discount_nd: String?

    let order_approval_condition: Int?

    let Cash_Retailer: String?
    let Is_Progress_Dialog_Need: String?
    let retailer_color_coding_need: String?
    let attend_lock_Nd: String?
    let closing_stock_ss_needed: String?
    let closing_stock_db_needed: String?
    let closing_stock_batch_no_mandatory_needed: String?
    let closing_stock_mfg_date_mandatory_needed: String?

    let AttendanceLock_Approval: String?
    let beat_optimization_need: String?
    let EOD_report_need: String?
    let universal_search_need: String?
    let category_search_need: String?

    let cash_retailer_Name: String?

    let distributor_need_in_payments: String?
    let creditlimit_outstandingamt_visiblity_need: String?

    let beat_opt_limit_remaining: Int?

    let product_voice_search_need: String?
    let distributor_prefill_need: String?
    let mtd_analysis_need: String?
    let order_summary_pdf_alignment_need: String?
    let manual_punch_location_need: String?

    let location_tracking_interval_time: Int?

    let retailer_scheme_need: String?
}
