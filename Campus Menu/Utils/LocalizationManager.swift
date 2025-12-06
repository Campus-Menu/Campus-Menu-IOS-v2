//
//  LocalizationManager.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI
import Combine

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language = .turkish
    
    private let repository = DataRepository.shared
    
    init() {
        loadPreferences()
    }
    
    func loadPreferences() {
        let prefs = repository.preferences
        currentLanguage = Language(rawValue: prefs.language) ?? .turkish
    }
    
    func setLanguage(_ language: Language) {
        currentLanguage = language
        var prefs = repository.preferences
        prefs.language = language.rawValue
        repository.updatePreferences(prefs)
    }
    
    func localized(_ key: String) -> String {
        return translations[currentLanguage]?[key] ?? key
    }
}

enum Language: String, CaseIterable {
    case turkish = "tr"
    case english = "en"
    case german = "de"
    case french = "fr"
    
    var displayName: String {
        switch self {
        case .turkish: return "Türkçe"
        case .english: return "English"
        case .german: return "Deutsch"
        case .french: return "Français"
        }
    }
    
    var flag: String {
        switch self {
        case .turkish: return "🇹🇷"
        case .english: return "🇬🇧"
        case .german: return "🇩🇪"
        case .french: return "🇫🇷"
        }
    }
}

// MARK: - Translations

let translations: [Language: [String: String]] = [
    .turkish: [
        // Auth
        "role_selection": "Hoş Geldiniz",
        "select_role": "Devam etmek için rolünüzü seçin",
        "student": "Öğrenci",
        "admin": "Yönetici",
        "student_desc": "Menüleri görüntüle, değerlendir ve favorilere ekle",
        "admin_desc": "Menüleri yönet ve değerlendirmeleri kontrol et",
        "login": "Giriş Yap",
        "email": "E-posta",
        "password": "Şifre",
        "register": "Kayıt Ol",
        "no_account": "Hesabınız yok mu?",
        "have_account": "Zaten hesabınız var mı?",
        "name": "Ad Soyad",
        "student_number": "Öğrenci Numarası",
        "invalid_credentials": "Geçersiz e-posta veya şifre",
        "please_fill_all": "Lütfen tüm alanları doldurun",
        "logout": "Çıkış Yap",
        
        // Navigation
        "home": "Ana Sayfa",
        "calendar": "Takvim",
        "favorites": "Favoriler",
        "announcements": "Duyurular",
        "profile": "Profil",
        "management": "Yönetim",
        "reviews": "Değerlendirmeler",
        
        // Home Screen
        "todays_menu": "Bugünün Menüsü",
        "no_menu_today": "Bugün için menü bulunmamaktadır",
        "all": "Tümü",
        "breakfast": "Kahvaltı",
        "lunch": "Öğle Yemeği",
        "dinner": "Akşam Yemeği",
        "snack": "Atıştırmalık",
        "soup": "Çorba",
        "dessert": "Tatlı",
        "rate_menu": "Menüyü Değerlendir",
        "review": "Yorum",
        "reviews_count": "Değerlendirmeler",
        "view_reviews": "Değerlendirmeleri Gör",
        "no_reviews": "Henüz değerlendirme yok",
        "submit_review": "Gönder",
        "cancel": "İptal",
        "your_rating": "Puanınız",
        "write_review": "Yorumunuzu yazın...",
        "kcal": "kcal",
        
        // Calendar
        "menu_calendar": "Menü Takvimi",
        "no_menu_selected": "Tarih seçin",
        
        // Favorites
        "my_favorites": "Favorilerim",
        "no_favorites": "Henüz favori eklemediniz",
        
        // Announcements
        "campus_announcements": "Kampüs Duyuruları",
        "no_announcements": "Duyuru bulunmamaktadır",
        
        // Profile
        "my_profile": "Profilim",
        "settings": "Ayarlar",
        "theme": "Tema",
        "orange": "Turuncu",
        "blue": "Mavi",
        "green": "Yeşil",
        "purple": "Mor",
        "dark_mode": "Karanlık Mod",
        "language": "Dil",
        "notifications": "Bildirimler",
        "menu_updates": "Menü Güncellemeleri",
        "announcements_notify": "Duyuru Bildirimleri",
        "allergies": "Alerjilerim",
        "select_allergies": "Alerjilerinizi seçin",
        "save": "Kaydet",
        "close": "Kapat",
        
        // Admin Management
        "menu_management": "Menü Yönetimi",
        "add_menu_day": "Menü Günü Ekle",
        "edit_menu": "Menüyü Düzenle",
        "delete_menu": "Menüyü Sil",
        "confirm_delete": "Silmek istediğinize emin misiniz?",
        "delete": "Sil",
        "menu_date": "Menü Tarihi",
        "menu_items": "Menü Öğeleri",
        "add_item": "Öğe Ekle",
        "item_name": "Öğe Adı",
        "category": "Kategori",
        "calories": "Kalori",
        "allergens": "Alerjenler",
        "description": "Açıklama",
        "optional": "(İsteğe bağlı)",
        "no_menus": "Henüz menü eklenmemiş",
        
        // Admin Reviews
        "review_management": "Değerlendirme Yönetimi",
        "pending": "Bekleyen",
        "approved": "Onaylanan",
        "all_reviews": "Tümü",
        "admin_response": "Yönetici Yanıtı",
        "respond": "Yanıtla",
        "approve": "Onayla",
        "write_response": "Yanıtınızı yazın...",
        
        // Allergens
        "gluten": "Gluten",
        "dairy": "Süt Ürünleri",
        "eggs": "Yumurta",
        "nuts": "Kuruyemiş",
        "soy": "Soya",
        "fish": "Balık",
        "shellfish": "Kabuklu Deniz Ürünleri",
        
        // Announcement Types
        "maintenance": "Bakım",
        "event": "Etkinlik",
        "menu_change": "Menü Değişikliği",
        "general": "Genel",
    ],
    
    .english: [
        // Auth
        "role_selection": "Welcome",
        "select_role": "Select your role to continue",
        "student": "Student",
        "admin": "Administrator",
        "student_desc": "View menus, rate and add to favorites",
        "admin_desc": "Manage menus and moderate reviews",
        "login": "Login",
        "email": "Email",
        "password": "Password",
        "register": "Register",
        "no_account": "Don't have an account?",
        "have_account": "Already have an account?",
        "name": "Full Name",
        "student_number": "Student Number",
        "invalid_credentials": "Invalid email or password",
        "please_fill_all": "Please fill all fields",
        "logout": "Logout",
        
        // Navigation
        "home": "Home",
        "calendar": "Calendar",
        "favorites": "Favorites",
        "announcements": "Announcements",
        "profile": "Profile",
        "management": "Management",
        "reviews": "Reviews",
        
        // Home Screen
        "todays_menu": "Today's Menu",
        "no_menu_today": "No menu available for today",
        "all": "All",
        "breakfast": "Breakfast",
        "lunch": "Lunch",
        "dinner": "Dinner",
        "snack": "Snack",
        "soup": "Soup",
        "dessert": "Dessert",
        "rate_menu": "Rate Menu",
        "review": "Review",
        "reviews_count": "Reviews",
        "view_reviews": "View Reviews",
        "no_reviews": "No reviews yet",
        "submit_review": "Submit",
        "cancel": "Cancel",
        "your_rating": "Your Rating",
        "write_review": "Write your review...",
        "kcal": "kcal",
        
        // Calendar
        "menu_calendar": "Menu Calendar",
        "no_menu_selected": "Select a date",
        
        // Favorites
        "my_favorites": "My Favorites",
        "no_favorites": "You haven't added any favorites yet",
        
        // Announcements
        "campus_announcements": "Campus Announcements",
        "no_announcements": "No announcements available",
        
        // Profile
        "my_profile": "My Profile",
        "settings": "Settings",
        "theme": "Theme",
        "orange": "Orange",
        "blue": "Blue",
        "green": "Green",
        "purple": "Purple",
        "dark_mode": "Dark Mode",
        "language": "Language",
        "notifications": "Notifications",
        "menu_updates": "Menu Updates",
        "announcements_notify": "Announcement Notifications",
        "allergies": "My Allergies",
        "select_allergies": "Select your allergies",
        "save": "Save",
        "close": "Close",
        
        // Admin Management
        "menu_management": "Menu Management",
        "add_menu_day": "Add Menu Day",
        "edit_menu": "Edit Menu",
        "delete_menu": "Delete Menu",
        "confirm_delete": "Are you sure you want to delete?",
        "delete": "Delete",
        "menu_date": "Menu Date",
        "menu_items": "Menu Items",
        "add_item": "Add Item",
        "item_name": "Item Name",
        "category": "Category",
        "calories": "Calories",
        "allergens": "Allergens",
        "description": "Description",
        "optional": "(Optional)",
        "no_menus": "No menus added yet",
        
        // Admin Reviews
        "review_management": "Review Management",
        "pending": "Pending",
        "approved": "Approved",
        "all_reviews": "All",
        "admin_response": "Admin Response",
        "respond": "Respond",
        "approve": "Approve",
        "write_response": "Write your response...",
        
        // Allergens
        "gluten": "Gluten",
        "dairy": "Dairy",
        "eggs": "Eggs",
        "nuts": "Nuts",
        "soy": "Soy",
        "fish": "Fish",
        "shellfish": "Shellfish",
        
        // Announcement Types
        "maintenance": "Maintenance",
        "event": "Event",
        "menu_change": "Menu Change",
        "general": "General",
    ],
    
    .german: [
        // Auth
        "role_selection": "Willkommen",
        "select_role": "Wählen Sie Ihre Rolle",
        "student": "Student",
        "admin": "Administrator",
        "student_desc": "Menüs ansehen, bewerten und zu Favoriten hinzufügen",
        "admin_desc": "Menüs verwalten und Bewertungen moderieren",
        "login": "Anmelden",
        "email": "E-Mail",
        "password": "Passwort",
        "register": "Registrieren",
        "no_account": "Noch kein Konto?",
        "have_account": "Bereits ein Konto?",
        "name": "Vollständiger Name",
        "student_number": "Matrikelnummer",
        "invalid_credentials": "Ungültige E-Mail oder Passwort",
        "please_fill_all": "Bitte alle Felder ausfüllen",
        "logout": "Abmelden",
        
        // Navigation
        "home": "Startseite",
        "calendar": "Kalender",
        "favorites": "Favoriten",
        "announcements": "Ankündigungen",
        "profile": "Profil",
        "management": "Verwaltung",
        "reviews": "Bewertungen",
        
        // Home Screen
        "todays_menu": "Heutiges Menü",
        "no_menu_today": "Kein Menü für heute verfügbar",
        "all": "Alle",
        "breakfast": "Frühstück",
        "lunch": "Mittagessen",
        "dinner": "Abendessen",
        "snack": "Snack",
        "soup": "Suppe",
        "dessert": "Nachtisch",
        "rate_menu": "Menü bewerten",
        "review": "Bewertung",
        "reviews_count": "Bewertungen",
        "view_reviews": "Bewertungen ansehen",
        "no_reviews": "Noch keine Bewertungen",
        "submit_review": "Senden",
        "cancel": "Abbrechen",
        "your_rating": "Ihre Bewertung",
        "write_review": "Schreiben Sie Ihre Bewertung...",
        "kcal": "kcal",
        
        // Calendar
        "menu_calendar": "Menükalender",
        "no_menu_selected": "Datum auswählen",
        
        // Favorites
        "my_favorites": "Meine Favoriten",
        "no_favorites": "Sie haben noch keine Favoriten hinzugefügt",
        
        // Announcements
        "campus_announcements": "Campus-Ankündigungen",
        "no_announcements": "Keine Ankündigungen verfügbar",
        
        // Profile
        "my_profile": "Mein Profil",
        "settings": "Einstellungen",
        "theme": "Thema",
        "orange": "Orange",
        "blue": "Blau",
        "green": "Grün",
        "purple": "Lila",
        "dark_mode": "Dunkler Modus",
        "language": "Sprache",
        "notifications": "Benachrichtigungen",
        "menu_updates": "Menü-Updates",
        "announcements_notify": "Ankündigungs-Benachrichtigungen",
        "allergies": "Meine Allergien",
        "select_allergies": "Wählen Sie Ihre Allergien",
        "save": "Speichern",
        "close": "Schließen",
        
        // Admin Management
        "menu_management": "Menüverwaltung",
        "add_menu_day": "Menütag hinzufügen",
        "edit_menu": "Menü bearbeiten",
        "delete_menu": "Menü löschen",
        "confirm_delete": "Möchten Sie wirklich löschen?",
        "delete": "Löschen",
        "menu_date": "Menüdatum",
        "menu_items": "Menüpunkte",
        "add_item": "Element hinzufügen",
        "item_name": "Elementname",
        "category": "Kategorie",
        "calories": "Kalorien",
        "allergens": "Allergene",
        "description": "Beschreibung",
        "optional": "(Optional)",
        "no_menus": "Noch keine Menüs hinzugefügt",
        
        // Admin Reviews
        "review_management": "Bewertungsverwaltung",
        "pending": "Ausstehend",
        "approved": "Genehmigt",
        "all_reviews": "Alle",
        "admin_response": "Admin-Antwort",
        "respond": "Antworten",
        "approve": "Genehmigen",
        "write_response": "Schreiben Sie Ihre Antwort...",
        
        // Allergens
        "gluten": "Gluten",
        "dairy": "Milchprodukte",
        "eggs": "Eier",
        "nuts": "Nüsse",
        "soy": "Soja",
        "fish": "Fisch",
        "shellfish": "Schalentiere",
        
        // Announcement Types
        "maintenance": "Wartung",
        "event": "Veranstaltung",
        "menu_change": "Menüänderung",
        "general": "Allgemein",
    ],
    
    .french: [
        // Auth
        "role_selection": "Bienvenue",
        "select_role": "Sélectionnez votre rôle",
        "student": "Étudiant",
        "admin": "Administrateur",
        "student_desc": "Voir les menus, noter et ajouter aux favoris",
        "admin_desc": "Gérer les menus et modérer les avis",
        "login": "Connexion",
        "email": "E-mail",
        "password": "Mot de passe",
        "register": "S'inscrire",
        "no_account": "Pas encore de compte?",
        "have_account": "Vous avez déjà un compte?",
        "name": "Nom complet",
        "student_number": "Numéro d'étudiant",
        "invalid_credentials": "E-mail ou mot de passe invalide",
        "please_fill_all": "Veuillez remplir tous les champs",
        "logout": "Déconnexion",
        
        // Navigation
        "home": "Accueil",
        "calendar": "Calendrier",
        "favorites": "Favoris",
        "announcements": "Annonces",
        "profile": "Profil",
        "management": "Gestion",
        "reviews": "Avis",
        
        // Home Screen
        "todays_menu": "Menu du jour",
        "no_menu_today": "Aucun menu disponible aujourd'hui",
        "all": "Tous",
        "breakfast": "Petit-déjeuner",
        "lunch": "Déjeuner",
        "dinner": "Dîner",
        "snack": "Collation",
        "soup": "Soupe",
        "dessert": "Dessert",
        "rate_menu": "Noter le menu",
        "review": "Avis",
        "reviews_count": "Avis",
        "view_reviews": "Voir les avis",
        "no_reviews": "Pas encore d'avis",
        "submit_review": "Soumettre",
        "cancel": "Annuler",
        "your_rating": "Votre note",
        "write_review": "Écrivez votre avis...",
        "kcal": "kcal",
        
        // Calendar
        "menu_calendar": "Calendrier des menus",
        "no_menu_selected": "Sélectionner une date",
        
        // Favorites
        "my_favorites": "Mes favoris",
        "no_favorites": "Vous n'avez pas encore ajouté de favoris",
        
        // Announcements
        "campus_announcements": "Annonces du campus",
        "no_announcements": "Aucune annonce disponible",
        
        // Profile
        "my_profile": "Mon profil",
        "settings": "Paramètres",
        "theme": "Thème",
        "orange": "Orange",
        "blue": "Bleu",
        "green": "Vert",
        "purple": "Violet",
        "dark_mode": "Mode sombre",
        "language": "Langue",
        "notifications": "Notifications",
        "menu_updates": "Mises à jour du menu",
        "announcements_notify": "Notifications d'annonces",
        "allergies": "Mes allergies",
        "select_allergies": "Sélectionnez vos allergies",
        "save": "Enregistrer",
        "close": "Fermer",
        
        // Admin Management
        "menu_management": "Gestion des menus",
        "add_menu_day": "Ajouter un jour de menu",
        "edit_menu": "Modifier le menu",
        "delete_menu": "Supprimer le menu",
        "confirm_delete": "Êtes-vous sûr de vouloir supprimer?",
        "delete": "Supprimer",
        "menu_date": "Date du menu",
        "menu_items": "Éléments du menu",
        "add_item": "Ajouter un élément",
        "item_name": "Nom de l'élément",
        "category": "Catégorie",
        "calories": "Calories",
        "allergens": "Allergènes",
        "description": "Description",
        "optional": "(Optionnel)",
        "no_menus": "Aucun menu ajouté",
        
        // Admin Reviews
        "review_management": "Gestion des avis",
        "pending": "En attente",
        "approved": "Approuvé",
        "all_reviews": "Tous",
        "admin_response": "Réponse de l'admin",
        "respond": "Répondre",
        "approve": "Approuver",
        "write_response": "Écrivez votre réponse...",
        
        // Allergens
        "gluten": "Gluten",
        "dairy": "Produits laitiers",
        "eggs": "Œufs",
        "nuts": "Noix",
        "soy": "Soja",
        "fish": "Poisson",
        "shellfish": "Crustacés",
        
        // Announcement Types
        "maintenance": "Maintenance",
        "event": "Événement",
        "menu_change": "Changement de menu",
        "general": "Général",
    ]
]
