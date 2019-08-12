/// {@nodoc}
library languageString;

import 'package:melodyku/core/types.dart';

dynamic language_detail_List = [
  {
    'name'      :'english',
    'code'      :'en',
    'direction' :Direction.ltr,
    'flag'      :'',
  },
  {
    'name'      :'فارسی',
    'code'      :'fa_IR',
    'direction' :Direction.rtl,
    'flag'      :'',
    'default'   :true,
  },
];

dynamic languageStrings = [
  
  /* Titles
    ========================
    - common
    - pages
    - login form
    - main menu drawer
    - profile drawer
    - language form
    ======================== 
  */

  // {
  //   'name': '',
  //   'en'  : '',
  //   'fa_IR'  : '',
  // },
  
  // ========================
  // common
  // ========================
  {
    'name': 'done',
    'en'  : 'done',
    'fa_IR'  : 'انجام شد'
  },
  {
    'name': 'install',
    'en'  : 'Install',
    'fa_IR'  : 'نصب'
  },
  {
    'name': 'apply',
    'en'  : 'Apply',
    'fa_IR'  : 'اعمال کردن',
  },
  {
    'name': 'logout',
    'en'  : 'Logout',
    'fa_IR'  : 'خروج',
  },
  {
    'name': 'playAll',
    'en'  : 'Play All',
    'fa_IR'  : 'گوش دادن',
  },
  {
    'name': 'submit',
    'en'  : 'Submit',
    'fa_IR'  : 'ثبت',
  },
  {
    'name': 'moreDetail',
    'en'  : 'more detail',
    'fa_IR'  : 'جزئیات بیشتر'
  },
  {
    'name': 'more',
    'en'  : 'More',
    'fa_IR'  : 'بیشتر'
  },
  {
    'name': 'whatAreYouSearchingFor',
    'en'  : 'what are you searching for',
    'fa_IR': 'دنبال چی میگردی ...',
  },
  {
    'name': 'notFound',
    'en'  : 'No Found 404',
    'fa_IR': 'متاسفانه چیزی پیدا نشد!',
  },
  {
    'name': 'select',
    'en'  : 'Select',
    'fa_IR': 'انتخاب',
  },

  // ========================
  // payment
  // ========================
  {
    'name': 'irt',
    'en'  : 'Toman (IRT)',
    'fa_IR': 'تومان',
  },
  {
    'name': 'eur',
    'en'  : '€ (EUR)',
    'fa_IR': 'یورو',
  },
  {
    'name': 'chooseCurrency',
    'en'  : 'Choose a Currency',
    'fa_IR': 'یک واحد پولی انتخاب کنید',
  },
  {
    'name'  : 'surTopayment',
    'en'    : 'If you sure to want buy this plan, select a getway and make purchase.',
    'fa_IR' : 'اگر برای خرید این بلن مطمئن هستید، یکی از درگاه های پرداخت را انتخاب کنید و سپش دکمه پرداخت را بفشارید.'
  },
  {
    'name' : 'createFactor',
    'en'   : 'Checkout',
    'fa_IR': 'صدور فاکتور'
  },
  {
    'name' : 'pay',
    'en'   : 'pay',
    'fa_IR': 'پرداخت'
  },

  // ========================
  // warnings
  // ========================
  {
    'name': 'warningPlayingDemo',
    'en'  : 'playing demo version of this song.',
    'fa_IR'  : 'در حال پخش نسخه دمو این ترانه',
  },
  {
    'name': 'install_warning',
    'en'  : 'you can install Melodyku app on your device only by one click.',
    'fa_IR'  : 'ملودیکو را بر روی دستگاه خود داشته باشید.'
  },

  // ========================
  // common lables
  // ========================
  {
    'name': 'featuredArtists',
    'en'  : 'Featured Artists ',
    'fa_IR'  : 'خواننده های ویژه',
  },
  {
    'name': 'featuredAlbums',
    'en'  : 'Featured Albums',
    'fa_IR'  : 'آلبوم های ویژه',
  },
  {
    'name': 'featuredSongs',
    'en'  : 'Featured Songs',
    'fa_IR'  : 'ترانه های ویژه',
  },
  {
    'name': 'bestAllTime',
    'en'  : 'Best Of All The Time',
    'fa_IR'  : 'برترین های تاریخ',
  },
  {
    'name': 'lasts',
    'en'  : 'Lasts',
    'fa_IR'  : 'آخرین ها',
  },
  {
    'name': 'forYou',
    'en'  : 'For You',
    'fa_IR'  : 'برای شما',
  },
  {
    'name': 'day',
    'en'  : 'Best Of The Day',
    'fa_IR'  : 'پیشنهاد های امروز',
  },
  {
    'name': 'week',
    'en'  : 'Best Of The Week',
    'fa_IR'  : 'پیشنهاد های هفته',
  },
  {
    'name': 'random',
    'en'  : 'Random',
    'fa_IR'  : 'پیشنهاد های تصادفی',
  },
  {
    'name': 'otherPlaylist',
    'en'  : 'Other Playlist',
    'fa_IR'  : 'دیگر لیست ها',
  },

  // ========================
  // pages
  // ========================
  {
    'name': 'search',
    'en'  : 'search',
    'fa_IR'  : 'جستجو',
  },
  {
    'name': 'profile',
    'en'  : 'Profile',
    'fa_IR'  : 'پروفایل کاربری',
  },
  {
    'name': 'vitrin',
    'en'  : 'Vitrin',
    'fa_IR'  : 'ویترین',
  },
  {
    'name': 'albums',
    'en'  : 'Albums',
    'fa_IR'  : 'آلبوم ها',
  },
  {
    'name': 'playlists',
    'en'  : 'Playlists',
    'fa_IR'  : 'لیست های پخش',
  },
  {
    'name': 'artists',
    'en'  : 'Artists',
    'fa_IR'  : 'هنرمندان',
  },
  {
    'name': 'songs',
    'en'  : 'Songs',
    'fa_IR'  : 'ترانه ها',
  },
  {
    'name': 'genres',
    'en'  : 'Genres',
    'fa_IR'  : 'ژانر ها',
  },
  {
    'name': 'top_tracks',
    'en'  : 'Top Tracks',
    'fa_IR'  : 'بهترین ها',
  },
  {
    'name': 'subscription',
    'en'  : 'Subscription',
    'fa_IR'  : 'خرید اشتراک',
  },

  // ========================
  // login form
  // ========================
  {
    'name': 'loginRegister',
    'en'  : 'login / register',
    'fa_IR'  : 'ورود / ثبت نام',
  },
  {
    'name': 'loginToAccount',
    'en'  : 'login to your account',
    'fa_IR'  : 'ورود به حساب کاربری',
  },
  {
    'name': 'getResetLink',
    'en'  : 'get reset link',
    'fa_IR'  : 'درخواست تغییر رمز',
  },
  {
    'name': 'getConfirmation',
    'en'  : 'resend confirmation',
    'fa_IR'  : 'دریافت تائیدیه ایمیل',
  },
  {
    'name': 'resetLinkSent',
    'en'  : 'reset link has been sent to your email, check it out, please',
    'fa_IR'  : 'لینک بازناشی رمز به ایمیل شما ارسال شد.',
  },
  {
    'name': 'LinkInvalid',
    'en'  : 'link is expired or invalid',
    'fa_IR'  : 'لینک منقضی شده است، لطفا از ابتدا اقدام کنید.',
  },
  {
    'name': 'sendConfirmation',
    'en'  : 'resend confirmation email',
    'fa_IR'  : 'ارسال مجدد تائید ایمیل',
  },
  {
    'name': 'confirmationSent',
    'en'  : 'confirmation email has been sent to you',
    'fa_IR'  : 'تائیدیه ایمیل برای شما ارسال شد.',
  },
  {
    'name': 'userCreated',
    'en'  : 'your user created and an confirmation email was sent to you.',
    'fa_IR'  : 'حساب کاربری شما ساخته شد و یک ایمیل تائیدیه برای شما ارسال شد.',
  },
  {
    'name': 'email',
    'en'  : 'Email',
    'fa_IR'  : 'ایمیل',
  },
  {
    'name': 'password',
    'en'  : 'Password',
    'fa_IR'  : 'رمز عبور',
  },
  {
    'name': 'login',
    'en'  : 'Login',
    'fa_IR'  : 'ورود',
  },
  {
    'name': 'loginHere',
    'en'  : 'Login Here',
    'fa_IR'  : 'ورود',
  },
  {
    'name': 'forgotPassword',
    'en'  : 'Forgot Password?',
    'fa_IR'  : 'آیا رمز خود را فراموش کرده اید؟',
  },
  {
    'name': 'insertPhone',
    'en'  : 'insert your phone',
    'fa_IR'  : 'لطفا شماره موبایل خود را با پیش شماره کشوری وارد کنید',
  },
  {
    'name': 'insertCode',
    'en'  : 'sms code',
    'fa_IR'  : 'کد پیامک',
  },
  {
    'name': 'insertNewPassword',
    'en'  : 'new password',
    'fa_IR'  : 'رمز جدید',
  },
  {
    'name': 'createAccount',
    'en'  : 'Create An Account',
    'fa_IR'  : 'ساخت حساب کاربری',
  },
  {
    'name': 'fullName',
    'en'  : 'Full name',
    'fa_IR'  : 'نام کامل',
  },
  {
    'name': 'register',
    'en'  : 'Register Now',
    'fa_IR'  : 'ثبت نام',
  },
  {
    'name': 'alreadyHaveAccount',
    'en'  : 'Already Have an Account?',
    'fa_IR'  : 'قبلا حساب ساخته اید؟',
  },

  // ========================
  // main menu drawer
  // ========================
  {
    'name': 'vitrin',
    'en'  : 'Vitrin',
    'fa_IR'  : 'ویترین',
  },
  {
    'name': 'albums',
    'en'  : 'Albums',
    'fa_IR'  : 'آلبوم ها',
  },
  {
    'name': 'artists',
    'en'  : 'Artists',
    'fa_IR'  : 'هنرمندان',
  },
  {
    'name': 'genres',
    'en'  : 'Genres',
    'fa_IR'  : 'ژانر ها',
  },
  {
    'name': 'topTracks',
    'en'  : 'Top Tracks',
    'fa_IR'  : 'ترانه های ناب',
  },

  // ========================
  // profile drawer
  // ========================
  // user
  {
    'name': 'favorites',
    'en'  : 'Favorites',
    'fa_IR'  : 'لایک شده ها',
  },
  {
    'name': 'history',
    'en'  : 'History',
    'fa_IR'  : 'شنیده شده ها',
  },
  {
    'name': 'downloads',
    'en'  : 'Downloads',
    'fa_IR'  : 'دانلود شده ها',
  },

  // archive sergeant
  {
    'name': 'archive_artistList',
    'en'  : 'Artists Manager',
    'fa_IR'  : 'مدیریت هنرمندان',
  },
  {
    'name': 'archive_upload',
    'en'  : 'Upload',
    'fa_IR'  : 'آپلود',
  },
  {
    'name': 'archive_convert',
    'en'  : 'Convert System',
    'fa_IR'  : 'مبدل صوتی',
  },

  // category sergeant
  {
    'name': 'archive_categories',
    'en'  : 'Category Manager',
    'fa_IR'  : 'مدیریت دسته بندی ها',
  },
  {
    'name'  : 'multi_categorizing',
    'en'    : 'Multi Categorizing',
    'fa_IR' : 'دسته بندی جمعی'
  },

  // administrator
  {
    'name': 'users',
    'en'  : 'User Manager',
    'fa_IR'  : 'مدیریت کاربران',
  },
  {
    'name': 'advanced_settings',
    'en'  : 'Advanced Settings',
    'fa_IR'  : 'تنظیمات پیشرفته',
  },

  // ========================
  // language form
  // ========================
  {
    'name': 'selectLanguage',
    'en'  : 'Language Selection',
    'fa_IR'  : 'انتخاب زبان',
  },

  // ========================
  // small Menu-Items
  // ========================
  {
    'name': 'addTofavourites',
    'en'  : 'Add To favourites',
    'fa_IR'  : 'افزودن به علاقمندی ها',
  },
  {
    'name': 'share',
    'en'  : 'Share',
    'fa_IR'  : 'اشتراک گذاری',
  },

  // ========================
  // item detail
  // ========================
  {
    'name': 'songTitle',
    'en'  : 'Song Title',
    'fa_IR'  : 'عنوان',
  },
  {
    'name': 'album',
    'en'  : 'Album',
    'fa_IR'  : 'آلبوم',
  },
  {
    'name': 'artist',
    'en'  : 'Artist',
    'fa_IR'  : 'هنرمند',
  },
  {
    'name': 'song',
    'en'  : 'Song',
    'fa_IR'  : 'موسیقی',
  },
  {
    'name': 'duration',
    'en'  : 'Duration',
    'fa_IR'  : 'زمان',
  },
  {
    'name': 'favoriteStatus',
    'en'  : 'favorite Status',
    'fa_IR'  : 'وضعیت علاقمندی',
  },
  {
    'name': 'playlist',
    'en'  : 'Playlist',
    'fa_IR'  : 'لیست پخش',
  },

  // ========================
  // subscription
  // ======================== 
  {
    'name': 'buySubscription',
    'en'  : 'Get a Subscription',
    'fa_IR'  : 'خرید اشتراک'
  },
  {
    'name': 'days',
    'en'  : 'Days',
    'fa_IR'  : 'روز',
  },
  {
    'name': 'price',
    'en'  : 'Price',
    'fa_IR'  : 'قیمت',
  },
  {
    'name': 'offlineAccess',
    'en'  : 'Offline Accesss',
    'fa_IR'  : 'استفاده به صورت افلاین',
  },
  {
    'name': 'downloadSongs',
    'en'  : 'Download Songs',
    'fa_IR'  : 'دانلود ترانه ها',
  },
  {
    'name': 'multipleQuality',
    'en'  : 'Multiple Quality',
    'fa_IR'  : 'کیفیت های مختلف',
  },
  {
    'name': 'subscriptionPlan',
    'en'  : 'Subscription Plan',
    'fa_IR'  : 'اشتراک فعال',
  },
  {
    'name': 'daysLeft',
    'en'  : 'Days Left',
    'fa_IR'  : 'روز های باقی مانده',
  },
  {
    'name': 'listenlastMonth',
    'en'  : 'listen last Month',
    'fa_IR'  : 'شنیده شده های این ماه',
  },
  {
    'name': 'likedLastMonth',
    'en'  : 'liked Last Month',
    'fa_IR'  : 'لایک شده های این ماه',
  },
  {
    'name': 'youDontHaveSubscriptionYet',
    'en'  : "You Don't Have any plan Yet.",
    'fa_IR'  : 'شما هنوز هیچ اشتراک فعالی ندارید.',
  },
];