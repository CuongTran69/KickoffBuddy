// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Kickoff Buddy';

  @override
  String get home_title => 'Kickoff Buddy';

  @override
  String get home_subtitle => 'Theo dõi lịch thi đấu của bạn';

  @override
  String get home_cta_matches => 'Xem lịch thi đấu';

  @override
  String get home_cta_rules => 'Luật bóng đá';

  @override
  String get home_cta_vocabulary => 'Từ vựng';

  @override
  String get onboarding_welcome_title => 'Kickoff Buddy';

  @override
  String get onboarding_welcome_tagline =>
      'Không bỏ lỡ trận nào.\nKhông spoiler. Không nhầm lẫn.';

  @override
  String get onboarding_timezone_title => 'Múi giờ của bạn';

  @override
  String get onboarding_timezone_body =>
      'Giờ thi đấu sẽ hiển thị theo múi giờ địa phương của bạn.';

  @override
  String get onboarding_timezone_changeBtn => 'Đổi múi giờ';

  @override
  String get onboarding_language_title => 'Choose your language';

  @override
  String get onboarding_language_subtitle => 'Chọn ngôn ngữ của bạn';

  @override
  String get onboarding_language_vietnamese => 'Tiếng Việt';

  @override
  String get onboarding_language_english => 'English';

  @override
  String get onboarding_ready_title => 'Bạn đã sẵn sàng!';

  @override
  String get onboarding_ready_body =>
      'Kickoff Buddy đã sẵn sàng.\nGiờ thi đấu theo múi giờ của bạn, không spoiler.';

  @override
  String get onboarding_ready_letsGo => 'Bắt đầu thôi';

  @override
  String get onboarding_btn_next => 'Tiếp theo';

  @override
  String get matches_appBar_title => 'Lịch thi đấu';

  @override
  String get matches_filter_all => 'Tất cả';

  @override
  String get matches_filter_groupStage => 'Vòng bảng';

  @override
  String get matches_filter_knockouts => 'Vòng loại trực tiếp';

  @override
  String get matches_section_today => 'Hôm nay';

  @override
  String get matches_section_tomorrow => 'Ngày mai';

  @override
  String get matches_section_thisWeek => 'Tuần này';

  @override
  String get matches_section_later => 'Sắp tới';

  @override
  String get matches_section_past => 'Đã qua';

  @override
  String get matches_empty_title => 'Chưa có trận đấu nào';

  @override
  String get matches_retry => 'Thử lại';

  @override
  String get matches_tooltip_magicAdd => 'Magic Add';

  @override
  String get matches_tooltip_add => 'Thêm trận';

  @override
  String matches_badge_group(String group) {
    return 'Nhóm $group';
  }

  @override
  String get matches_badge_roundOf32 => 'Vòng 32';

  @override
  String get matches_badge_roundOf16 => 'Vòng 16';

  @override
  String get matches_badge_quarterFinal => 'Tứ kết';

  @override
  String get matches_badge_semiFinal => 'Bán kết';

  @override
  String get matches_badge_thirdPlace => 'Tranh hạng 3';

  @override
  String get matches_badge_final => 'Chung kết';

  @override
  String get matchDetail_appBar_title => 'Chi tiết trận đấu';

  @override
  String get matchDetail_label_date => 'Ngày';

  @override
  String get matchDetail_label_time => 'Giờ (giờ địa phương)';

  @override
  String get matchDetail_label_venue => 'Sân';

  @override
  String get matchDetail_label_group => 'Nhóm';

  @override
  String matchDetail_label_groupValue(String group) {
    return 'Nhóm $group';
  }

  @override
  String get matchDetail_label_round => 'Vòng';

  @override
  String get matchDetail_label_matchday => 'Lượt';

  @override
  String matchDetail_label_matchdayValue(int day) {
    return 'Lượt $day';
  }

  @override
  String get matchDetail_label_notes => 'Ghi chú';

  @override
  String get matchDetail_btn_addToMyMatches => 'Thêm vào trận của tôi';

  @override
  String get matchDetail_btn_removeFromMyMatches => 'Xóa khỏi trận của tôi';

  @override
  String get matchDetail_btn_setReminder => 'Đặt nhắc nhở';

  @override
  String get matchDetail_btn_matchStarted => 'Trận đã bắt đầu';

  @override
  String get matchDetail_btn_planReplay => 'Lên kế hoạch xem lại';

  @override
  String get matchDetail_btn_cancelReplayPlan => 'Hủy kế hoạch xem lại';

  @override
  String get matchDetail_btn_edit => 'Chỉnh sửa';

  @override
  String get matchDetail_btn_delete => 'Xóa';

  @override
  String get matchDetail_dialog_cancelPlan_title => 'Hủy kế hoạch xem lại?';

  @override
  String get matchDetail_dialog_cancelPlan_body =>
      'Thông báo nhắc nhở sẽ bị hủy.';

  @override
  String get matchDetail_dialog_delete_title => 'Xóa trận đấu?';

  @override
  String get matchDetail_dialog_delete_body =>
      'Hành động này không thể hoàn tác.';

  @override
  String get matchDetail_snackbar_cancelledPlan => 'Đã hủy kế hoạch xem lại';

  @override
  String get matchDetail_notFound => 'Không tìm thấy trận đấu';

  @override
  String get matchDetail_btn_backToList => 'Quay lại danh sách';

  @override
  String get matchDetail_round_groupStage => 'Vòng bảng';

  @override
  String get matchDetail_round_roundOf32 => 'Vòng 32';

  @override
  String get matchDetail_round_roundOf16 => 'Vòng 16';

  @override
  String get matchDetail_round_quarterFinal => 'Tứ kết';

  @override
  String get matchDetail_round_semiFinal => 'Bán kết';

  @override
  String get matchDetail_round_thirdPlace => 'Tranh hạng 3';

  @override
  String get matchDetail_round_final => 'Chung kết';

  @override
  String get manualAdd_appBar_title => 'Thêm trận đấu';

  @override
  String get manualAdd_appBar_title_edit => 'Chỉnh sửa trận đấu';

  @override
  String get manualAdd_field_homeTeam => 'Đội nhà *';

  @override
  String get manualAdd_field_homeTeam_hint => 'Ví dụ: Brazil';

  @override
  String get manualAdd_field_awayTeam => 'Đội khách *';

  @override
  String get manualAdd_field_awayTeam_hint => 'Ví dụ: Argentina';

  @override
  String get manualAdd_field_venue => 'Sân vận động (tùy chọn)';

  @override
  String get manualAdd_field_venue_hint => 'Ví dụ: Estadio Azteca';

  @override
  String get manualAdd_field_notes => 'Ghi chú (tùy chọn)';

  @override
  String get manualAdd_field_date => 'Ngày thi đấu *';

  @override
  String get manualAdd_field_time => 'Giờ thi đấu (giờ địa phương) *';

  @override
  String get manualAdd_placeholder_date => 'Chọn ngày';

  @override
  String get manualAdd_placeholder_time => 'Chọn giờ';

  @override
  String get manualAdd_validation_required => 'Bắt buộc';

  @override
  String get manualAdd_validation_sameTeam =>
      'Đội nhà và đội khách phải khác nhau';

  @override
  String get manualAdd_btn_save => 'Lưu';

  @override
  String get manualAdd_btn_retry => 'Thử lại';

  @override
  String get manualAdd_snackbar_saved => 'Đã thêm trận đấu';

  @override
  String get manualAdd_error_prefix => 'Lỗi khi lưu: ';

  @override
  String get magicAdd_appBar_title => 'Magic Add';

  @override
  String get magicAdd_instruction => 'Dán đoạn văn bản chứa thông tin trận đấu';

  @override
  String get magicAdd_btn_paste => 'Dán từ clipboard';

  @override
  String get magicAdd_btn_analyze => 'Phân tích';

  @override
  String get magicAdd_result_teamsFound => 'Tìm thấy đội bóng:';

  @override
  String get magicAdd_result_missingDateTime =>
      'Không tìm thấy ngày/giờ — vui lòng điền thêm.';

  @override
  String get magicAdd_btn_fillMore => 'Điền thêm thông tin';

  @override
  String get magicAdd_result_failed =>
      'Không thể phân tích — thử định dạng như:\n\"Đội A vs Đội B, June 11, 8 PM ET\"';

  @override
  String get magicAdd_result_failedHint =>
      'Không thể phân tích — thử định dạng như:\n\"Đội A vs Đội B, June 11, 8 PM ET\"';

  @override
  String get magicAdd_btn_addManually => 'Thêm thủ công';

  @override
  String get magicAdd_confirmation_title => 'Kết quả phân tích:';

  @override
  String get magicAdd_field_home => 'Đội nhà';

  @override
  String get magicAdd_field_away => 'Đội khách';

  @override
  String get magicAdd_field_date => 'Ngày';

  @override
  String get magicAdd_field_time => 'Giờ';

  @override
  String get magicAdd_field_timezone => 'Múi giờ';

  @override
  String get magicAdd_field_timezone_local => 'Địa phương';

  @override
  String get magicAdd_btn_save => 'Lưu trận đấu';

  @override
  String get magicAdd_btn_edit => 'Chỉnh sửa';

  @override
  String get magicAdd_snackbar_saved => 'Đã thêm trận đấu';

  @override
  String get magicAdd_snackbar_error =>
      'Không thể lưu trận đấu. Vui lòng thử lại.';

  @override
  String get reminder_sheet_title => 'Nhắc nhở trước giờ đá';

  @override
  String get reminder_btn_cancel => 'Hủy';

  @override
  String get reminder_btn_save => 'Lưu';

  @override
  String get reminder_snackbar_saved => 'Đã lưu nhắc nhở';

  @override
  String get reminder_snackbar_cleared => 'Đã xóa nhắc nhở';

  @override
  String reminder_snackbar_skipped(String labels) {
    return 'Đã bỏ qua $labels (đã qua)';
  }

  @override
  String get reminder_permission_title => 'Cần quyền thông báo';

  @override
  String get reminder_permission_body =>
      'Kickoff Buddy cần quyền gửi thông báo trận đấu. Mở Cài đặt để bật thông báo.';

  @override
  String get reminder_permission_openSettings => 'Mở Cài đặt';

  @override
  String get reminder_exactAlarm_title => 'Cần quyền báo thức chính xác';

  @override
  String get reminder_exactAlarm_body =>
      'Để gửi nhắc nhở đúng giờ đá, Kickoff Buddy cần quyền đặt báo thức chính xác. Nhấn \"Mở Cài đặt\" để cấp quyền.';

  @override
  String get reminder_exactAlarm_openSettings => 'Mở Cài đặt';

  @override
  String get reminder_offset_1day => '1 ngày';

  @override
  String get reminder_offset_3hours => '3 giờ';

  @override
  String get reminder_offset_30min => '30 phút';

  @override
  String get reminder_offset_5min => '5 phút';

  @override
  String get replayPlanner_dialog_title => 'Lên kế hoạch xem lại';

  @override
  String get replayPlanner_btn_cancelPlan => 'Hủy kế hoạch';

  @override
  String get replayPlanner_btn_close => 'Đóng';

  @override
  String get replayPlanner_btn_save => 'Lưu';

  @override
  String get replayPlanner_dialog_confirmCancel_title =>
      'Hủy kế hoạch xem lại?';

  @override
  String get replayPlanner_dialog_confirmCancel_body =>
      'Thông báo nhắc nhở sẽ bị hủy.';

  @override
  String get replayPlanner_btn_no => 'Không';

  @override
  String replayPlanner_snackbar_saved(String time) {
    return 'Đã lên kế hoạch xem lại lúc $time';
  }

  @override
  String get replayPlanner_snackbar_cancelled => 'Đã hủy kế hoạch xem lại';

  @override
  String get replayPlanner_validation_mustBeAfterKickoff =>
      'Thời gian xem lại phải sau giờ đá';

  @override
  String get replayPlanner_validation_mustBeInFuture =>
      'Thời gian xem lại phải trong tương lai';

  @override
  String get replayPlanner_placeholder_date => 'Chọn ngày';

  @override
  String get replayPlanner_placeholder_time => 'Chọn giờ';

  @override
  String spoiler_banner_text(String time) {
    return 'Bảo vệ spoiler đến $time';
  }

  @override
  String get rules_appBar_title => 'Luật bóng đá';

  @override
  String get rules_error_load => 'Không thể tải luật bóng đá';

  @override
  String get rules_btn_retry => 'Thử lại';

  @override
  String get rules_level_newbie => 'Người mới';

  @override
  String get rules_level_casual => 'Thỉnh thoảng';

  @override
  String get rules_level_advanced => 'Nâng cao';

  @override
  String get rules_topic_offside => 'Việt vị';

  @override
  String get rules_topic_penalty => 'Phạt đền';

  @override
  String get rules_topic_var => 'VAR';

  @override
  String get rules_topic_cards => 'Thẻ';

  @override
  String get rules_topic_stoppageTime => 'Bù giờ';

  @override
  String get rules_topic_extraTime => 'Hiệp phụ';

  @override
  String get rules_topic_penaltyShootout => 'Sút luân lưu';

  @override
  String get rules_detail_appBar_title => 'Luật bóng đá';

  @override
  String rules_detail_readTime(int seconds) {
    return 'Đọc trong: $seconds giây';
  }

  @override
  String get rules_detail_seeAlso => 'Xem thêm';

  @override
  String get rules_detail_error_load => 'Lỗi tải dữ liệu';

  @override
  String get rules_detail_notFound => 'Không tìm thấy luật';

  @override
  String get rules_detail_btn_back => 'Quay lại';

  @override
  String get rules_detail_toggle_english => 'English';

  @override
  String get vocabulary_appBar_title => 'Từ vựng';

  @override
  String get vocabulary_search_hint => 'Tìm kiếm thuật ngữ...';

  @override
  String get vocabulary_empty_title => 'Không có kết quả';

  @override
  String get vocabulary_empty_clearSearch => 'Xóa tìm kiếm';

  @override
  String get common_btn_cancel => 'Hủy';

  @override
  String get common_btn_no => 'Không';

  @override
  String get common_btn_yes => 'Có';

  @override
  String get common_btn_close => 'Đóng';

  @override
  String get a11y_changeLanguage => 'Đổi ngôn ngữ';

  @override
  String get a11y_toggleEnVi => 'Chuyển đổi Tiếng Anh / Tiếng Việt';

  @override
  String get nav_home => 'Trang chủ';

  @override
  String get nav_matches => 'Trận đấu';

  @override
  String get nav_rules => 'Luật';

  @override
  String get nav_vocabulary => 'Từ vựng';

  @override
  String get nav_settings => 'Cài đặt';

  @override
  String get nav_standings => 'Bảng xếp hạng';

  @override
  String get settings_appBar_title => 'Cài đặt';

  @override
  String get settings_language => 'Ngôn ngữ';

  @override
  String get settings_themeMode => 'Giao diện';

  @override
  String get settings_theme_light => 'Giao diện Sáng';

  @override
  String get settings_theme_dark => 'Giao diện Tối';

  @override
  String get settings_theme_system => 'Theo hệ thống';

  @override
  String get settings_language_vi => 'Tiếng Việt';

  @override
  String get settings_language_en => 'English';

  @override
  String get settings_about_title => 'Giới thiệu';

  @override
  String get settings_about_disclaimer =>
      'Kickoff Buddy là ứng dụng fan không chính thức và không liên kết với FIFA hay bất kỳ liên đoàn bóng đá nào.';

  @override
  String get home_section_nextMatch => 'Trận tiếp theo';

  @override
  String get home_section_quickLearn => 'Học nhanh';

  @override
  String get home_btn_setReminder => 'Đặt nhắc nhở';

  @override
  String get home_btn_viewDetail => 'Xem chi tiết';

  @override
  String get home_hero_noMatch_title => 'Không có trận sắp tới';

  @override
  String get home_hero_noMatch_cta => 'Xem lịch thi đấu';

  @override
  String home_countdown_days(int days, int hours) {
    return '$days ngày $hours giờ';
  }

  @override
  String home_countdown_hours(int hours, int minutes) {
    return '$hours giờ $minutes phút';
  }

  @override
  String get home_countdown_soon => 'Sắp bắt đầu';

  @override
  String get home_live_indicator => 'TRỰC TIẾP';

  @override
  String get home_live_viewDetail => 'Xem chi tiết';

  @override
  String get home_today_sectionHeader => 'Trận đấu hôm nay';

  @override
  String get standings_empty_title => 'Chưa có bảng xếp hạng';

  @override
  String get standings_error_title => 'Không thể tải bảng xếp hạng';

  @override
  String get standings_btn_retry => 'Thử lại';

  @override
  String get standings_col_group => 'Bảng';

  @override
  String get standings_col_team => 'Đội tuyển';

  @override
  String get standings_col_played => 'Trận';

  @override
  String get standings_col_wdl => 'T-H-B';

  @override
  String get standings_col_gfga => 'BT:BB';

  @override
  String get standings_col_gd => 'HS';

  @override
  String get standings_col_points => 'Điểm';

  @override
  String standings_group_label(String letter) {
    return 'Bảng $letter';
  }

  @override
  String get standings_hint_bestThird => 'Có thể đi tiếp (hạng 3 tốt nhất)';

  @override
  String matches_syncError(String reason) {
    return 'Lỗi đồng bộ tỉ số: $reason';
  }

  @override
  String get matchDetail_status_live => 'TRỰC TIẾP';

  @override
  String get matchDetail_status_ft => 'KT';

  @override
  String get matchDetail_status_scheduled => 'Sắp diễn ra';

  @override
  String get matchDetail_label_winner => 'Đội thắng';

  @override
  String get matchDetail_label_attendance => 'Khán giả';

  @override
  String get matchDetail_label_penalties => 'Luân lưu';

  @override
  String matchDetail_score_penalties(int scoreA, int scoreB) {
    return 'Luân lưu $scoreA–$scoreB';
  }

  @override
  String get sleepPlan_cardTitle => 'Kế hoạch ngủ';

  @override
  String get sleepPlan_disclaimer =>
      'Đây là gợi ý lịch cá nhân, không phải lời khuyên y tế.';

  @override
  String get sleepPlan_mode_lateWatcher_title => 'Xem khuya';

  @override
  String get sleepPlan_mode_lateWatcher_body =>
      'Chợp mắt trước trận, rồi xem trực tiếp.';

  @override
  String get sleepPlan_mode_balanced_title => 'Cân bằng';

  @override
  String get sleepPlan_mode_balanced_body =>
      'Xem hiệp hai hoặc xem highlight vào ngày mai.';

  @override
  String get sleepPlan_mode_healthyReplay_title => 'Xem lại lành mạnh';

  @override
  String get sleepPlan_mode_healthyReplay_body =>
      'Ngủ ngay bây giờ, xem lại vào buổi sáng.';

  @override
  String get sleepPlan_mode_healthyReplay_cta => 'Lên kế hoạch xem lại';

  @override
  String get etiquette_appBar_title => 'Văn hóa xem bóng đá';

  @override
  String get etiquette_error_load => 'Không thể tải mẹo văn hóa';

  @override
  String get etiquette_btn_retry => 'Thử lại';

  @override
  String get etiquette_notFound => 'Không tìm thấy mẹo';

  @override
  String get etiquette_btn_back => 'Quay lại';

  @override
  String get formatGuide_appBar_title => 'Thể thức giải đấu';

  @override
  String get formatGuide_error_load => 'Không thể tải thể thức giải đấu';

  @override
  String get formatGuide_btn_retry => 'Thử lại';

  @override
  String get formatGuide_notFound => 'Không tìm thấy mục';

  @override
  String get formatGuide_btn_back => 'Quay lại';

  @override
  String get home_dashboard_title => 'Kickoff Buddy';

  @override
  String get home_dashboard_subtitle =>
      'Cẩm nang & lịch thi đấu bóng đá tiện ích';

  @override
  String get home_action_matches => 'Lịch thi đấu';

  @override
  String get home_action_standings => 'BXH bảng';

  @override
  String get home_action_rules => 'Cẩm nang luật';

  @override
  String get home_action_vocabulary => 'Từ vựng';

  @override
  String get home_action_magicAdd => 'Thêm nhanh';

  @override
  String get home_action_manualAdd => 'Thêm thủ công';

  @override
  String get home_quickLearn_offside_label => 'Việt vị';

  @override
  String get home_quickLearn_offside_desc =>
      'Luật việt vị cơ bản cho người mới bắt đầu.';

  @override
  String get home_quickLearn_penalty_label => 'Phạt đền';

  @override
  String get home_quickLearn_penalty_desc =>
      'Tìm hiểu khi nào phạt đền xảy ra.';

  @override
  String get home_quickLearn_var_label => 'VAR';

  @override
  String get home_quickLearn_var_desc =>
      'VAR hoạt động như thế nào trong trận?';

  @override
  String get home_quickLearn_vocabulary_label => 'Từ vựng';

  @override
  String get home_quickLearn_vocabulary_desc =>
      'Tra cứu các thuật ngữ bóng đá thông dụng.';

  @override
  String get settings_resources_title => 'Tài nguyên & Tra cứu';

  @override
  String reminder_notification_title(String label) {
    return 'Nhắc trận đấu: còn $label';
  }

  @override
  String reminder_notification_body(String teamA, String teamB) {
    return '$teamA vs $teamB';
  }

  @override
  String get replay_notification_title => 'Sắp đến giờ xem lại';

  @override
  String replay_notification_body(String teamA, String teamB) {
    return '$teamA vs $teamB';
  }

  @override
  String get reminder_unit_day => 'ngày';

  @override
  String get reminder_unit_days => 'ngày';

  @override
  String get reminder_unit_hour => 'giờ';

  @override
  String get reminder_unit_hours => 'giờ';

  @override
  String get reminder_unit_minute => 'phút';

  @override
  String get reminder_unit_minutes => 'phút';

  @override
  String get spoiler_badge_label => 'Bảo vệ';

  @override
  String get rules_empty_state => 'Không có thẻ cho cấp độ này';

  @override
  String get vocabulary_search_clear_tooltip => 'Xóa tìm kiếm';

  @override
  String get common_error_network =>
      'Lỗi mạng. Vui lòng kiểm tra kết nối và thử lại.';

  @override
  String get common_error_generic => 'Đã có lỗi xảy ra. Vui lòng thử lại.';
}
