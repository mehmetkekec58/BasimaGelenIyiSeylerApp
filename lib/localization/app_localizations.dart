import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static AppLocalizations of(BuildContext context, {bool listen = true}) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: listen);
    return AppLocalizations(languageProvider.currentLanguage);
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Settings Page
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'notifications': 'Notifications',
      'enable_daily_reminders': 'Enable daily reminders',
      'language': 'Language',
      'about_app': 'About App',
      'version': 'Version 1.0.0',
      'app_name': 'Good Things That Happened To Me',
      'app_description': 'An app designed to record your daily good memories.',
      'more': 'More',

      // Home Page
      'experiences': 'Experiences',
      'view_all_experiences': 'View all your experiences',
      'add_experience': 'Add Experience',
      'add_new_experience': 'Record a new experience',
      'remember_me': 'Remember Me',
      'discover_random_memories': 'Discover your old memories randomly',
      'backup': 'Backup',
      'backup_experiences': 'Backup your experiences',
      'import_export': 'Import/Export',
      'import_export_data': 'Import/Export your data',
      'customize_app': 'Customize the app',

      // Search Page
      'search': 'Search',
      'search_experiences': 'Search experiences...',
      'significance': 'Significance',
      'all': 'All',
      'select_date_range': 'Select date range',
      'clear_date_range': 'Clear date range',
      'no_experiences_found': 'No experiences found',
      'no_experiences_yet': 'You haven\'t added any experiences yet!',
      'add_something_good_today': 'You can add something good that happened today.',
      'add_new': 'Add New',
      'delete_experience': 'Delete Experience',
      'delete_experience_confirm': 'Are you sure you want to delete this experience?',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'update': 'Update',
      'edit_experience': 'Edit Experience',
      'search_title_desc_tag_location': 'Search by title, description, tag or location',
      'importance_level': 'Importance Level',
      'date_range': 'Date Range',
      'all_importance_levels': 'All',

      // Importance Levels
      'low_importance': 'Low Importance',
      'medium_importance': 'Medium Importance',
      'important': 'Important',
      'very_important': 'Very Important',
      'critical': 'Critical',

      // Image Picker
      'tap_to_select_images': 'Tap to select images',
      'multiple_images_allowed': 'You can select multiple images',
      'add_more_images': 'Add more images',

      // New translation
      'what_good_today': 'What Good Thing Happened Today?',

      // Form field labels and validation messages
      'title_label': 'Title',
      'title_required_message': 'Please enter a title',
      'description_label': 'Description (Optional)',
      'moment_importance': 'Importance of This Moment',
      'add_tag_label': 'Add Tag',
      'location_label': 'Location',
      'date_label': 'Date',
      'save': 'Save',
      'date_format': 'Date: {day}.{month}.{year}',

      // Remember Me Page
      'last_month': 'Last Month',
      'last_month_description': 'Remember a good moment from the last month',
      'last_year': 'Last Year',
      'last_year_description': 'Remember a good moment from the last year',
      'last_five_years': 'Last 5 Years',
      'last_five_years_description': 'Discover memories from your long journey',
      'filtered_suggestions': 'Filtered Suggestions',
      'filtered_suggestions_description': 'Discover your memories with special filters',
      'coming_soon': 'Coming Soon',
      'no_experiences_in_period': 'No experiences found in {period}.',
      'suggest_random_memory': 'How about remembering one of your experiences from {period}?',
      'suggest_random': 'Suggest Random Memory',

      // Experience Detail Page
      'experience_detail': 'Experience Detail',
      'tags': 'Tags',
      'month_1': 'January',
      'month_2': 'February',
      'month_3': 'March',
      'month_4': 'April',
      'month_5': 'May',
      'month_6': 'June',
      'month_7': 'July',
      'month_8': 'August',
      'month_9': 'September',
      'month_10': 'October',
      'month_11': 'November',
      'month_12': 'December',

      'month_short_1': 'Jan',
      'month_short_2': 'Feb',
      'month_short_3': 'Mar',
      'month_short_4': 'Apr',
      'month_short_5': 'May',
      'month_short_6': 'Jun',
      'month_short_7': 'Jul',
      'month_short_8': 'Aug',
      'month_short_9': 'Sep',
      'month_short_10': 'Oct',
      'month_short_11': 'Nov',
      'month_short_12': 'Dec',

      // Import/Export Page
      'import_export_title': 'Import/Export',
      'import_export_description': 'Import or export your experiences',
      'export_experiences': 'Export Experiences',
      'export_experiences_description': 'Save your experiences as a backup file',
      'import_experiences': 'Import Experiences',
      'import_experiences_description': 'Restore your experiences from a backup file',
      'coming_soon_restore': 'Restore from backup will be added soon',
      'export_pdf': 'Export as PDF',
      'export_pdf_description': 'Export all your experiences in PDF format',
      'export_excel': 'Export as Excel',
      'export_excel_description': 'View your experiences in Excel format',
      'coming_soon_pdf': 'PDF export will be added soon',
      'coming_soon_excel': 'Excel export will be added soon',

      // Backup Plans
      'backup_plans': 'Backup Plans',
      'backup_plans_description': 'Choose the plan that suits you best',
      'free_plan': 'Free',
      'free_plan_description': 'Basic features',
      'free_plan_experiences': '50 experiences',
      'free_plan_images': '100 images',
      'free_plan_price': 'Free',
      'monthly_plan': 'Monthly Plan',
      'monthly_plan_description': 'Unlimited backup',
      'monthly_plan_experiences': 'Unlimited experiences',
      'monthly_plan_images': 'Unlimited images',
      'yearly_plan': 'Yearly Plan',
      'yearly_plan_description': 'Best value',
      'yearly_plan_experiences': 'Unlimited experiences',
      'yearly_plan_images': 'Unlimited images',
      'yearly_plan_save': 'Save {discount}%',
      'select_plan': 'Select Plan',
      'current_plan': 'Current Plan',
      'backup_page_title': 'Backup',
      'backup_page_description': 'Backup your experiences and images',
      'coming_soon_label': 'Coming Soon',

    },
    'tr': {
      // Ayarlar Sayfası
      'settings': 'Ayarlar',
      'dark_mode': 'Karanlık Mod',
      'notifications': 'Bildirimler',
      'enable_daily_reminders': 'Günlük hatırlatmaları etkinleştir',
      'language': 'Dil',
      'about_app': 'Uygulama Hakkında',
      'version': 'Versiyon 1.0.0',
      'app_name': 'Başıma Gelen İyi Şeyler',
      'app_description': 'Günlük iyi anılarınızı kaydetmek için tasarlanmış bir uygulama.',
      'more': 'Diğer',

      // Ana Sayfa
      'experiences': 'Deneyimler',
      'view_all_experiences': 'Tüm deneyimlerinizi görüntüleyin',
      'add_experience': 'Deneyim Ekle',
      'add_new_experience': 'Yeni bir deneyim kaydedin',
      'remember_me': 'Hatırla Beni',
      'discover_random_memories': 'Eski deneyimlerini rastgele keşfet',
      'backup': 'Yedekleme',
      'backup_experiences': 'Deneyimlerinizi yedekleyin',
      'import_export': 'İçe/Dışa Aktar',
      'import_export_data': 'Verilerinizi içe/dışa aktarın',
      'customize_app': 'Uygulamayı özelleştir',

      // Arama Sayfası
      'search': 'Ara',
      'search_experiences': 'Deneyimlerde ara...',
      'significance': 'Önem Derecesi',
      'all': 'Tümü',
      'select_date_range': 'Tarih aralığı seç',
      'clear_date_range': 'Tarih aralığını temizle',
      'no_experiences_found': 'Deneyim bulunamadı',
      'no_experiences_yet': 'Henüz hiç deneyim eklemediniz!',
      'add_something_good_today': 'Bugün sana iyi gelen bir şeyi ekleyebilirsin.',
      'add_new': 'Yeni Ekle',
      'delete_experience': 'Deneyimi Sil',
      'delete_experience_confirm': 'Bu deneyimi silmek istediğinize emin misiniz?',
      'cancel': 'İptal',
      'delete': 'Sil',
      'update': 'Güncelle',
      'edit_experience': 'Deneyimi Düzenle',
      'search_title_desc_tag_location': 'Başlık, açıklama, etiket veya konuma göre ara',
      'importance_level': 'Önem Derecesi',
      'date_range': 'Tarih Aralığı',
      'all_importance_levels': 'Tümü',

      // Önem Seviyeleri
      'low_importance': 'Düşük Önemli',
      'medium_importance': 'Orta Önemli',
      'important': 'Önemli',
      'very_important': 'Çok Önemli',
      'critical': 'Hayati Önemli',

      // Image Picker
      'tap_to_select_images': 'Resim seçmek için dokun',
      'multiple_images_allowed': 'Birden fazla resim seçebilirsiniz',
      'add_more_images': 'Daha fazla resim ekle',

      // New translation
      'what_good_today': 'Bugün Sana İyi Gelen Nedir?',

      // Form field labels and validation messages
      'title_label': 'Başlık',
      'title_required_message': 'Lütfen bir başlık girin',
      'description_label': 'Açıklama (İsteğe Bağlı)',
      'moment_importance': 'Bu Anının Önemi',
      'add_tag_label': 'Etiket Ekle',
      'location_label': 'Konum',
      'date_label': 'Tarih',
      'save': 'Kaydet',
      'date_format': 'Tarih: {day}.{month}.{year}',

      // Beni Hatırla Sayfası
      'last_month': 'Son 1 Ay',
      'last_month_description': 'Geçen 1 ay içinde yaşadığın güzel anılar',
      'last_year': 'Son 1 Yıl',
      'last_year_description': 'Geçen 1 yıl içinde yaşadığın güzel anılar',
      'last_five_years': 'Son 5 Yıl',
      'last_five_years_description': 'Uzun zamandır biriktirdiğin anılar',
      'filtered_suggestions': 'Filtreli Öner',
      'filtered_suggestions_description': 'Özel filtrelerle anılarını keşfet',
      'coming_soon': 'Yakında Eklenecek',
      'no_experiences_in_period': '{period} içinde kaydedilmiş deneyim bulunamadı.',
      'suggest_random_memory': '{period} içindeki deneyimlerinden\nbirini hatırlamaya ne dersin?',
      'suggest_random': 'Bana Rastgele Öner',

      // Experience Detail Page
      'experience_detail': 'Deneyim Detayı',
      'tags': 'Etiketler',
      'month_1': 'Ocak',
      'month_2': 'Şubat',
      'month_3': 'Mart',
      'month_4': 'Nisan',
      'month_5': 'Mayıs',
      'month_6': 'Haziran',
      'month_7': 'Temmuz',
      'month_8': 'Ağustos',
      'month_9': 'Eylül',
      'month_10': 'Ekim',
      'month_11': 'Kasım',
      'month_12': 'Aralık',

      'month_short_1': 'Oca',
      'month_short_2': 'Şub',
      'month_short_3': 'Mar',
      'month_short_4': 'Nis',
      'month_short_5': 'May',
      'month_short_6': 'Haz',
      'month_short_7': 'Tem',
      'month_short_8': 'Ağu',
      'month_short_9': 'Eyl',
      'month_short_10': 'Eki',
      'month_short_11': 'Kas',
      'month_short_12': 'Ara',

      // İçe/Dışa Aktarma Sayfası
      'import_export_title': 'İçe/Dışa Aktar',
      'import_export_description': 'Deneyimlerinizi içe veya dışa aktarın',
      'export_experiences': 'Deneyimleri Dışa Aktar',
      'export_experiences_description': 'Deneyimlerinizi yedek dosyası olarak kaydedin',
      'import_experiences': 'Deneyimleri İçe Aktar',
      'import_experiences_description': 'Deneyimlerinizi yedek dosyasından geri yükleyin',
      'coming_soon_restore': 'Yedekten geri yükleme yakında eklenecek',
      'export_pdf': 'PDF Olarak Dışa Aktar',
      'export_pdf_description': 'Tüm deneyimlerinizi PDF formatında dışa aktarın',
      'export_excel': 'Excel Olarak Dışa Aktar',
      'export_excel_description': 'Deneyimlerinizi Excel formatında görüntüleyin',
      'coming_soon_pdf': 'PDF dışa aktarma yakında eklenecek',
      'coming_soon_excel': 'Excel dışa aktarma yakında eklenecek',

      // Yedekleme Planları
      'backup_plans': 'Yedekleme Planları',
      'backup_plans_description': 'Size en uygun planı seçin',
      'free_plan': 'Ücretsiz',
      'free_plan_description': 'Temel özellikler',
      'free_plan_experiences': '50 deneyim',
      'free_plan_images': '100 resim',
      'free_plan_price': 'Ücretsiz',
      'monthly_plan': 'Aylık Plan',
      'monthly_plan_description': 'Sınırsız yedekleme',
      'monthly_plan_experiences': 'Sınırsız deneyim',
      'monthly_plan_images': 'Sınırsız resim',
      'yearly_plan': 'Yıllık Plan',
      'yearly_plan_description': 'En iyi değer',
      'yearly_plan_experiences': 'Sınırsız deneyim',
      'yearly_plan_images': 'Sınırsız resim',
      'yearly_plan_save': '%{discount} tasarruf',
      'select_plan': 'Planı Seç',
      'current_plan': 'Mevcut Plan',
      'backup_page_title': 'Yedekleme',
      'backup_page_description': 'Deneyimlerinizi ve resimlerinizi yedekleyin',
      'coming_soon_label': 'Yakında Eklenecek',
    },
  };

  String get(String key) {
    return _localizedValues[languageCode]?[key] ?? key;
  }
} 