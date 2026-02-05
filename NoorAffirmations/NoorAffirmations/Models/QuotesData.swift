//
//  QuotesData.swift
//  NoorAffirmations
//
//  A collection of Islamic quotes from Quran and Hadith
//

import Foundation

struct QuotesData {

    static let allQuotes: [Quote] = [
        // MARK: - Patience (Sabr)
        Quote(
            textArabic: "إِنَّ اللَّهَ مَعَ الصَّابِرِينَ",
            textEnglish: "Indeed, Allah is with the patient.",
            source: "Quran",
            category: .patience,
            reference: "Surah Al-Baqarah 2:153"
        ),
        Quote(
            textArabic: "فَاصْبِرْ صَبْرًا جَمِيلًا",
            textEnglish: "So be patient with gracious patience.",
            source: "Quran",
            category: .patience,
            reference: "Surah Al-Ma'arij 70:5"
        ),
        Quote(
            textEnglish: "Patience is the key to relief.",
            source: "Hadith",
            category: .patience,
            reference: "Prophet Muhammad (PBUH)"
        ),
        Quote(
            textArabic: "وَاصْبِرْ وَمَا صَبْرُكَ إِلَّا بِاللَّهِ",
            textEnglish: "And be patient, for your patience is only through Allah.",
            source: "Quran",
            category: .patience,
            reference: "Surah An-Nahl 16:127"
        ),
        Quote(
            textEnglish: "No one has been given a gift better and more comprehensive than patience.",
            source: "Hadith",
            category: .patience,
            reference: "Sahih Bukhari"
        ),
        Quote(
            textArabic: "وَبَشِّرِ الصَّابِرِينَ",
            textEnglish: "And give good tidings to the patient.",
            source: "Quran",
            category: .patience,
            reference: "Surah Al-Baqarah 2:155"
        ),
        Quote(
            textEnglish: "Wonderful is the affair of the believer, for there is good for him in every matter. If he is happy, he thanks Allah and thus there is good for him. If he is harmed, he shows patience and thus there is good for him.",
            source: "Hadith",
            category: .patience,
            reference: "Sahih Muslim"
        ),

        // MARK: - Gratitude (Shukr)
        Quote(
            textArabic: "لَئِن شَكَرْتُمْ لَأَزِيدَنَّكُمْ",
            textEnglish: "If you are grateful, I will surely increase you in favor.",
            source: "Quran",
            category: .gratitude,
            reference: "Surah Ibrahim 14:7"
        ),
        Quote(
            textEnglish: "He who does not thank people, does not thank Allah.",
            source: "Hadith",
            category: .gratitude,
            reference: "Abu Dawud"
        ),
        Quote(
            textArabic: "وَاشْكُرُوا لِلَّهِ إِن كُنتُمْ إِيَّاهُ تَعْبُدُونَ",
            textEnglish: "And be grateful to Allah if it is Him you worship.",
            source: "Quran",
            category: .gratitude,
            reference: "Surah Al-Baqarah 2:172"
        ),
        Quote(
            textEnglish: "Look at those below you and do not look at those above you, for it is more likely that you will not belittle the blessings of Allah.",
            source: "Hadith",
            category: .gratitude,
            reference: "Sahih Muslim"
        ),
        Quote(
            textArabic: "وَإِذْ تَأَذَّنَ رَبُّكُمْ",
            textEnglish: "Whoever is grateful, it is for his own soul's benefit.",
            source: "Quran",
            category: .gratitude,
            reference: "Surah An-Naml 27:40"
        ),
        Quote(
            textEnglish: "The first thing for which people will be held accountable on the Day of Resurrection will be their prayers. If they are found to be perfect, they will be recorded as such. If something is lacking, Allah will say: Look and see if My servant has any voluntary prayers, and use them to complete his obligatory prayers.",
            source: "Hadith",
            category: .gratitude,
            reference: "Abu Dawud"
        ),

        // MARK: - Faith (Iman)
        Quote(
            textArabic: "آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ",
            textEnglish: "The Messenger has believed in what was revealed to him from his Lord, and so have the believers.",
            source: "Quran",
            category: .faith,
            reference: "Surah Al-Baqarah 2:285"
        ),
        Quote(
            textEnglish: "Faith wears out in the heart, just as clothes wear out. So ask Allah to renew the faith in your hearts.",
            source: "Hadith",
            category: .faith,
            reference: "Al-Hakim"
        ),
        Quote(
            textArabic: "إِنَّمَا الْمُؤْمِنُونَ الَّذِينَ إِذَا ذُكِرَ اللَّهُ وَجِلَتْ قُلُوبُهُمْ",
            textEnglish: "The believers are only those who, when Allah is mentioned, their hearts become fearful.",
            source: "Quran",
            category: .faith,
            reference: "Surah Al-Anfal 8:2"
        ),
        Quote(
            textEnglish: "None of you truly believes until he wishes for his brother what he wishes for himself.",
            source: "Hadith",
            category: .faith,
            reference: "Sahih Bukhari & Muslim"
        ),
        Quote(
            textArabic: "وَمَن يُؤْمِن بِاللَّهِ يَهْدِ قَلْبَهُ",
            textEnglish: "And whoever believes in Allah - He will guide his heart.",
            source: "Quran",
            category: .faith,
            reference: "Surah At-Taghabun 64:11"
        ),
        Quote(
            textEnglish: "The most complete of the believers in faith is the one with the best character among them.",
            source: "Hadith",
            category: .faith,
            reference: "Tirmidhi"
        ),

        // MARK: - Trust in Allah (Tawakkul)
        Quote(
            textArabic: "وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ",
            textEnglish: "And whoever relies upon Allah - then He is sufficient for him.",
            source: "Quran",
            category: .trust,
            reference: "Surah At-Talaq 65:3"
        ),
        Quote(
            textEnglish: "If you all relied on Allah with true reliance, He would provide for you as He provides for the birds who go out hungry in the morning and return full.",
            source: "Hadith",
            category: .trust,
            reference: "Tirmidhi"
        ),
        Quote(
            textArabic: "فَتَوَكَّلْ عَلَى اللَّهِ إِنَّكَ عَلَى الْحَقِّ الْمُبِينِ",
            textEnglish: "So rely upon Allah; indeed, you are upon the clear truth.",
            source: "Quran",
            category: .trust,
            reference: "Surah An-Naml 27:79"
        ),
        Quote(
            textEnglish: "Tie your camel and trust in Allah.",
            source: "Hadith",
            category: .trust,
            reference: "Tirmidhi"
        ),
        Quote(
            textArabic: "وَعَلَى اللَّهِ فَلْيَتَوَكَّلِ الْمُؤْمِنُونَ",
            textEnglish: "And upon Allah let the believers rely.",
            source: "Quran",
            category: .trust,
            reference: "Surah At-Tawbah 9:51"
        ),
        Quote(
            textEnglish: "Be mindful of Allah and He will protect you. Be mindful of Allah and you will find Him before you. If you ask, ask from Allah. If you seek help, seek help from Allah.",
            source: "Hadith",
            category: .trust,
            reference: "Tirmidhi"
        ),

        // MARK: - Peace (Salam)
        Quote(
            textArabic: "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
            textEnglish: "Verily, in the remembrance of Allah do hearts find rest.",
            source: "Quran",
            category: .peace,
            reference: "Surah Ar-Ra'd 13:28"
        ),
        Quote(
            textEnglish: "Spread peace, feed the hungry, and pray at night when people are sleeping, you will enter Paradise in peace.",
            source: "Hadith",
            category: .peace,
            reference: "Tirmidhi"
        ),
        Quote(
            textArabic: "وَاللَّهُ يَدْعُو إِلَى دَارِ السَّلَامِ",
            textEnglish: "And Allah invites to the Home of Peace.",
            source: "Quran",
            category: .peace,
            reference: "Surah Yunus 10:25"
        ),
        Quote(
            textEnglish: "The Muslim is the one from whose tongue and hand other Muslims are safe.",
            source: "Hadith",
            category: .peace,
            reference: "Sahih Bukhari"
        ),
        Quote(
            textArabic: "سَلَامٌ قَوْلًا مِّن رَّبٍّ رَّحِيمٍ",
            textEnglish: "Peace, a word from a Merciful Lord.",
            source: "Quran",
            category: .peace,
            reference: "Surah Ya-Sin 36:58"
        ),
        Quote(
            textEnglish: "You will not enter Paradise until you believe, and you will not believe until you love one another. Shall I not tell you of something that, if you do it, you will love one another? Spread peace among yourselves.",
            source: "Hadith",
            category: .peace,
            reference: "Sahih Muslim"
        ),

        // MARK: - Hope (Raja)
        Quote(
            textArabic: "لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ",
            textEnglish: "Do not despair of the mercy of Allah.",
            source: "Quran",
            category: .hope,
            reference: "Surah Az-Zumar 39:53"
        ),
        Quote(
            textEnglish: "Allah says: I am as My servant thinks of Me. So let him think of Me as he wishes.",
            source: "Hadith",
            category: .hope,
            reference: "Sahih Bukhari & Muslim"
        ),
        Quote(
            textArabic: "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا",
            textEnglish: "For indeed, with hardship comes ease.",
            source: "Quran",
            category: .hope,
            reference: "Surah Ash-Sharh 94:5"
        ),
        Quote(
            textEnglish: "Know that victory comes with patience, relief comes with affliction, and ease comes with hardship.",
            source: "Hadith",
            category: .hope,
            reference: "Tirmidhi"
        ),
        Quote(
            textArabic: "وَرَحْمَتِي وَسِعَتْ كُلَّ شَيْءٍ",
            textEnglish: "My mercy encompasses all things.",
            source: "Quran",
            category: .hope,
            reference: "Surah Al-A'raf 7:156"
        ),
        Quote(
            textEnglish: "When Allah created creation, He wrote in His Book, which is with Him above the Throne: My mercy prevails over My wrath.",
            source: "Hadith",
            category: .hope,
            reference: "Sahih Bukhari"
        ),

        // MARK: - Mercy (Rahma)
        Quote(
            textArabic: "وَمَا أَرْسَلْنَاكَ إِلَّا رَحْمَةً لِّلْعَالَمِينَ",
            textEnglish: "And We have not sent you except as a mercy to the worlds.",
            source: "Quran",
            category: .mercy,
            reference: "Surah Al-Anbiya 21:107"
        ),
        Quote(
            textEnglish: "The merciful are shown mercy by the Most Merciful. Be merciful to those on earth, and the One in the heavens will be merciful to you.",
            source: "Hadith",
            category: .mercy,
            reference: "Tirmidhi"
        ),
        Quote(
            textArabic: "كَتَبَ رَبُّكُمْ عَلَى نَفْسِهِ الرَّحْمَةَ",
            textEnglish: "Your Lord has decreed upon Himself mercy.",
            source: "Quran",
            category: .mercy,
            reference: "Surah Al-An'am 6:54"
        ),
        Quote(
            textEnglish: "He who does not show mercy to others, will not be shown mercy.",
            source: "Hadith",
            category: .mercy,
            reference: "Sahih Bukhari & Muslim"
        ),
        Quote(
            textArabic: "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ",
            textEnglish: "In the name of Allah, the Most Gracious, the Most Merciful.",
            source: "Quran",
            category: .mercy,
            reference: "Surah Al-Fatiha 1:1"
        ),
        Quote(
            textEnglish: "Allah divided mercy into one hundred parts. He kept ninety-nine parts with Him and sent down one part to earth. From that one part comes the compassion that all creation shows to one another.",
            source: "Hadith",
            category: .mercy,
            reference: "Sahih Bukhari"
        ),

        // MARK: - Strength (Quwwa)
        Quote(
            textArabic: "لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا",
            textEnglish: "Allah does not burden a soul beyond that it can bear.",
            source: "Quran",
            category: .strength,
            reference: "Surah Al-Baqarah 2:286"
        ),
        Quote(
            textEnglish: "The strong believer is better and more beloved to Allah than the weak believer, while there is good in both.",
            source: "Hadith",
            category: .strength,
            reference: "Sahih Muslim"
        ),
        Quote(
            textArabic: "وَلَا تَهِنُوا وَلَا تَحْزَنُوا وَأَنتُمُ الْأَعْلَوْنَ",
            textEnglish: "Do not weaken and do not grieve, and you will be superior if you are true believers.",
            source: "Quran",
            category: .strength,
            reference: "Surah Ali 'Imran 3:139"
        ),
        Quote(
            textEnglish: "The strong person is not the one who can wrestle someone else down. The strong person is the one who can control himself when he is angry.",
            source: "Hadith",
            category: .strength,
            reference: "Sahih Bukhari & Muslim"
        ),
        Quote(
            textArabic: "إِنَّ اللَّهَ لَا يُغَيِّرُ مَا بِقَوْمٍ حَتَّى يُغَيِّرُوا مَا بِأَنفُسِهِمْ",
            textEnglish: "Indeed, Allah will not change the condition of a people until they change what is in themselves.",
            source: "Quran",
            category: .strength,
            reference: "Surah Ar-Ra'd 13:11"
        ),

        // MARK: - Wisdom (Hikma)
        Quote(
            textArabic: "يُؤْتِي الْحِكْمَةَ مَن يَشَاءُ",
            textEnglish: "He gives wisdom to whom He wills, and whoever has been given wisdom has certainly been given much good.",
            source: "Quran",
            category: .wisdom,
            reference: "Surah Al-Baqarah 2:269"
        ),
        Quote(
            textEnglish: "Seeking knowledge is an obligation upon every Muslim.",
            source: "Hadith",
            category: .wisdom,
            reference: "Ibn Majah"
        ),
        Quote(
            textArabic: "ادْعُ إِلَى سَبِيلِ رَبِّكَ بِالْحِكْمَةِ وَالْمَوْعِظَةِ الْحَسَنَةِ",
            textEnglish: "Invite to the way of your Lord with wisdom and good instruction.",
            source: "Quran",
            category: .wisdom,
            reference: "Surah An-Nahl 16:125"
        ),
        Quote(
            textEnglish: "A wise word is the lost property of a believer. Wherever he finds it, he is most deserving of it.",
            source: "Hadith",
            category: .wisdom,
            reference: "Tirmidhi"
        ),
        Quote(
            textArabic: "اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ",
            textEnglish: "Read in the name of your Lord who created.",
            source: "Quran",
            category: .wisdom,
            reference: "Surah Al-'Alaq 96:1"
        ),
        Quote(
            textEnglish: "The cure for ignorance is asking questions.",
            source: "Hadith",
            category: .wisdom,
            reference: "Abu Dawud"
        ),

        // MARK: - Love (Hubb)
        Quote(
            textArabic: "وَمِنَ النَّاسِ مَن يَتَّخِذُ مِن دُونِ اللَّهِ أَندَادًا يُحِبُّونَهُمْ كَحُبِّ اللَّهِ وَالَّذِينَ آمَنُوا أَشَدُّ حُبًّا لِلَّهِ",
            textEnglish: "But those who believe are stronger in love for Allah.",
            source: "Quran",
            category: .love,
            reference: "Surah Al-Baqarah 2:165"
        ),
        Quote(
            textEnglish: "None of you truly believes until I am more beloved to him than his father, his child, and all of mankind.",
            source: "Hadith",
            category: .love,
            reference: "Sahih Bukhari & Muslim"
        ),
        Quote(
            textArabic: "قُلْ إِن كُنتُمْ تُحِبُّونَ اللَّهَ فَاتَّبِعُونِي يُحْبِبْكُمُ اللَّهُ",
            textEnglish: "Say, if you love Allah, then follow me, and Allah will love you.",
            source: "Quran",
            category: .love,
            reference: "Surah Ali 'Imran 3:31"
        ),
        Quote(
            textEnglish: "When Allah loves a servant, He calls Gabriel and says: I love so-and-so, so love him. Then Gabriel loves him, and he calls out to the inhabitants of the heavens: Allah loves so-and-so, so love him. Thus the inhabitants of the heavens love him, and he is given acceptance on earth.",
            source: "Hadith",
            category: .love,
            reference: "Sahih Bukhari & Muslim"
        ),
        Quote(
            textArabic: "إِنَّ اللَّهَ يُحِبُّ التَّوَّابِينَ وَيُحِبُّ الْمُتَطَهِّرِينَ",
            textEnglish: "Indeed, Allah loves those who are constantly repentant and loves those who purify themselves.",
            source: "Quran",
            category: .love,
            reference: "Surah Al-Baqarah 2:222"
        ),
        Quote(
            textEnglish: "There are three things that whoever has them has found the sweetness of faith: when Allah and His Messenger are more beloved to him than anything else, when he loves a person and only loves him for the sake of Allah, and when he would hate to return to disbelief just as he would hate to be thrown into the Fire.",
            source: "Hadith",
            category: .love,
            reference: "Sahih Bukhari & Muslim"
        )
    ]

    static func quotes(for category: QuoteCategory) -> [Quote] {
        allQuotes.filter { $0.category == category }
    }

    static var dailyQuote: Quote {
        // Use the day of the year to select a consistent quote for each day
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % allQuotes.count
        return allQuotes[index]
    }

    static func randomQuote() -> Quote {
        allQuotes.randomElement() ?? allQuotes[0]
    }

    static func randomQuote(from category: QuoteCategory) -> Quote {
        let categoryQuotes = quotes(for: category)
        return categoryQuotes.randomElement() ?? allQuotes[0]
    }
}
