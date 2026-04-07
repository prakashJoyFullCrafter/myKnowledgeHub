# Java Internationalization (i18n) — Complete Study Guide

> **Module 14 | Brutally Detailed Reference**
> Covers Locale, ResourceBundle, MessageFormat, NumberFormat, DecimalFormat, DateTimeFormatter, Collator, Unicode/UTF-16, surrogate pairs, and externalization best practices. Every section includes full working examples.

---

## Table of Contents

1. [Overview — What Is i18n and Why It Matters](#1-overview--what-is-i18n-and-why-it-matters)
2. [The `Locale` Class](#2-the-locale-class)
3. [ResourceBundle — Locale-Specific Property Files](#3-resourcebundle--locale-specific-property-files)
4. [MessageFormat — Parameterized Messages](#4-messageformat--parameterized-messages)
5. [NumberFormat — Locale-Aware Number Formatting](#5-numberformat--locale-aware-number-formatting)
6. [DecimalFormat — Custom Number Patterns](#6-decimalformat--custom-number-patterns)
7. [DateTimeFormatter with Locales](#7-datetimeformatter-with-locales)
8. [Collator — Locale-Sensitive String Comparison and Sorting](#8-collator--locale-sensitive-string-comparison-and-sorting)
9. [Unicode in Java — UTF-16, Surrogate Pairs, Character Methods](#9-unicode-in-java--utf-16-surrogate-pairs-character-methods)
10. [Best Practice — Externalize All User-Facing Strings](#10-best-practice--externalize-all-user-facing-strings)
11. [Additional Topics](#11-additional-topics)
12. [Quick Reference Cheat Sheet](#12-quick-reference-cheat-sheet)

---

## 1. Overview — What Is i18n and Why It Matters

**Internationalization (i18n)** is the process of designing software so it can be adapted to various languages, regions, and cultures without engineering changes. The name comes from "i" + 18 letters + "n" in "internationalization."

**Localization (L10n)** is the actual adaptation of software for a specific locale — translating strings, formatting numbers/dates, etc.

### The Core Problem

Without i18n:
```java
// WRONG — hard-coded, works only for English-speaking US users
System.out.println("Welcome, " + userName + "!");
System.out.println("Your balance is: $" + amount);
System.out.println("Date: " + LocalDate.now().toString());
```

With i18n:
```java
// CORRECT — locale-aware, works for any user in any country
ResourceBundle bundle = ResourceBundle.getBundle("messages", userLocale);
NumberFormat currency = NumberFormat.getCurrencyInstance(userLocale);
DateTimeFormatter dtf = DateTimeFormatter.ofLocalizedDate(FormatStyle.FULL).withLocale(userLocale);

System.out.println(MessageFormat.format(bundle.getString("welcome"), userName));
System.out.println(bundle.getString("balance.label") + currency.format(amount));
System.out.println(bundle.getString("date.label") + dtf.format(LocalDate.now()));
```

### Terminology

| Term | Meaning |
|---|---|
| **Locale** | A combination of language, country, and optional variant that identifies a user's linguistic/regional preferences |
| **i18n** | Internationalization — making software locale-adaptable |
| **L10n** | Localization — providing locale-specific content |
| **Resource Bundle** | A set of files containing locale-specific strings and data |
| **CLDR** | Common Locale Data Repository — the Unicode standard Java uses for locale data |

---

## 2. The `Locale` Class

`Locale` identifies a specific **geographical, political, or cultural region**. It is the foundation of all i18n operations in Java. Almost every formatting/parsing API accepts a `Locale`.

### 2.1 Locale Components

A `Locale` has three main components:

| Component | Example | Description |
|---|---|---|
| **Language** | `"en"`, `"fr"`, `"zh"` | ISO 639 language code (lowercase) |
| **Country / Region** | `"US"`, `"GB"`, `"CN"` | ISO 3166 country code (uppercase) |
| **Variant** | `"POSIX"`, `"WIN"` | Vendor or browser-specific code (rarely used) |

Plus optional extensions (Java 7+):
- **Script**: `"Latn"`, `"Hans"`, `"Cyrl"` — writing system
- **Extensions**: Unicode locale extensions for calendar system, number system, etc.

### 2.2 Creating Locales

#### Pre-defined Constants (Preferred for Common Locales)

```java
import java.util.Locale;

// Language-only constants
Locale english  = Locale.ENGLISH;   // en
Locale french   = Locale.FRENCH;    // fr
Locale german   = Locale.GERMAN;    // de
Locale italian  = Locale.ITALIAN;   // it
Locale japanese = Locale.JAPANESE;  // ja
Locale korean   = Locale.KOREAN;    // ko
Locale chinese  = Locale.CHINESE;   // zh
Locale simplCh  = Locale.SIMPLIFIED_CHINESE;  // zh_CN
Locale tradCh   = Locale.TRADITIONAL_CHINESE; // zh_TW

// Language + Country constants
Locale usEnglish  = Locale.US;      // en_US
Locale ukEnglish  = Locale.UK;      // en_GB
Locale france     = Locale.FRANCE;  // fr_FR
Locale germany    = Locale.GERMANY; // de_DE
Locale japan      = Locale.JAPAN;   // ja_JP
Locale china      = Locale.CHINA;   // zh_CN
Locale taiwan     = Locale.TAIWAN;  // zh_TW
Locale canada     = Locale.CANADA;  // en_CA
Locale canadaFr   = Locale.CANADA_FRENCH; // fr_CA
Locale italy      = Locale.ITALY;   // it_IT
Locale korea      = Locale.KOREA;   // ko_KR
```

#### Constructor (Legacy, Still Works)

```java
// new Locale(language)
Locale en  = new Locale("en");

// new Locale(language, country)
Locale enGB = new Locale("en", "GB");
Locale frFR = new Locale("fr", "FR");
Locale arEG = new Locale("ar", "EG"); // Arabic - Egypt
Locale hiIN = new Locale("hi", "IN"); // Hindi - India

// new Locale(language, country, variant)
Locale enUSPOSIX = new Locale("en", "US", "POSIX");
```

#### `Locale.Builder` (Java 7+ — Recommended for Non-Trivial Locales)

The builder validates inputs and supports all extensions:

```java
Locale locale = new Locale.Builder()
    .setLanguage("zh")
    .setRegion("CN")
    .setScript("Hans")              // Simplified Chinese script
    .build();

Locale japaneseWithCalendar = new Locale.Builder()
    .setLanguage("ja")
    .setRegion("JP")
    .setUnicodeLocaleKeyword("ca", "japanese") // Japanese imperial calendar
    .build();
```

#### `Locale.forLanguageTag()` (Java 7+ — IETF BCP 47 Format)

IETF BCP 47 is the modern standard format for language tags:

```java
Locale locale1 = Locale.forLanguageTag("en-US");     // en_US
Locale locale2 = Locale.forLanguageTag("zh-Hans-CN"); // Simplified Chinese in China
Locale locale3 = Locale.forLanguageTag("sr-Latn");    // Serbian in Latin script
Locale locale4 = Locale.forLanguageTag("en-US-u-ca-buddhist"); // US English, Buddhist calendar

// Convert back to IETF tag
System.out.println(Locale.US.toLanguageTag()); // en-US
System.out.println(new Locale("zh", "CN").toLanguageTag()); // zh-CN
```

### 2.3 `Locale.getDefault()` and `Locale.setDefault()`

The **default locale** is the locale the JVM uses when no explicit locale is provided. It is initialized from the host OS settings when the JVM starts.

```java
// Get the current default locale
Locale defaultLocale = Locale.getDefault();
System.out.println("Default locale:  " + defaultLocale);          // e.g., en_US
System.out.println("Language:        " + defaultLocale.getLanguage()); // en
System.out.println("Country:         " + defaultLocale.getCountry());  // US
System.out.println("Display name:    " + defaultLocale.getDisplayName()); // English (United States)

// Set the default locale — affects ALL locale-sensitive operations
// WARNING: This is a JVM-wide global change — use with caution in multi-threaded apps
Locale.setDefault(Locale.FRANCE);
System.out.println(Locale.getDefault()); // fr_FR

// Restore
Locale.setDefault(defaultLocale);
```

#### Locale.Category (Java 7+)

Java 7+ allows separate default locales for display and formatting:

```java
// Two categories:
// Locale.Category.DISPLAY  — used for locale names, messages
// Locale.Category.FORMAT   — used for dates, numbers, currency

Locale.setDefault(Locale.Category.DISPLAY, Locale.ENGLISH); // UI in English
Locale.setDefault(Locale.Category.FORMAT, Locale.GERMANY);  // Numbers/dates German-style

// Get category-specific defaults
Locale displayLocale = Locale.getDefault(Locale.Category.DISPLAY);
Locale formatLocale  = Locale.getDefault(Locale.Category.FORMAT);
```

### 2.4 Inspecting a Locale

```java
Locale locale = Locale.FRANCE;

// Machine-readable codes
System.out.println(locale.getLanguage());          // fr
System.out.println(locale.getCountry());           // FR
System.out.println(locale.getVariant());           // ""
System.out.println(locale.getScript());            // ""
System.out.println(locale.toLanguageTag());        // fr-FR

// Human-readable names (displayed in the Locale's own language)
System.out.println(locale.getDisplayLanguage());   // français
System.out.println(locale.getDisplayCountry());    // France
System.out.println(locale.getDisplayName());       // français (France)

// Human-readable names in a specific locale (e.g., in English)
System.out.println(locale.getDisplayLanguage(Locale.ENGLISH)); // French
System.out.println(locale.getDisplayCountry(Locale.ENGLISH));  // France
System.out.println(locale.getDisplayName(Locale.ENGLISH));     // French (France)
```

### 2.5 Listing Available Locales

```java
// All locales available in this JVM
Locale[] allLocales = Locale.getAvailableLocales();
System.out.println("Available locales: " + allLocales.length); // typically 160+

// Print all locales containing "en"
Arrays.stream(Locale.getAvailableLocales())
    .filter(l -> l.getLanguage().equals("en"))
    .sorted(Comparator.comparing(Locale::toLanguageTag))
    .forEach(l -> System.out.println(l.toLanguageTag() + " - " + l.getDisplayName(Locale.ENGLISH)));
// en, en-AG, en-AI, en-AS, en-AU, en-BB, en-BE, ...
```

### 2.6 Common Locale Examples

```java
// Arabic - Saudi Arabia (right-to-left language)
Locale arSA = new Locale("ar", "SA");

// Portuguese - Brazil vs Portugal
Locale ptBR = new Locale("pt", "BR");
Locale ptPT = new Locale("pt", "PT");

// Spanish - Mexico vs Spain
Locale esMX = new Locale("es", "MX");
Locale esES = new Locale("es", "ES");

// Chinese - Simplified vs Traditional
Locale zhCN = Locale.SIMPLIFIED_CHINESE;
Locale zhTW = Locale.TRADITIONAL_CHINESE;

// Hindi - India
Locale hiIN = new Locale("hi", "IN");
```

---

## 3. ResourceBundle — Locale-Specific Property Files

`ResourceBundle` provides a mechanism to store and load **locale-specific resources** (typically strings). The JVM finds the right file based on the locale, following a **lookup chain**.

### 3.1 Property File Naming Convention

Files follow the pattern: `baseName_language_COUNTRY_variant.properties`

```
messages.properties          ← fallback (no locale)
messages_en.properties       ← English (any country)
messages_en_US.properties    ← English, United States
messages_en_GB.properties    ← English, United Kingdom
messages_fr.properties       ← French (any country)
messages_fr_FR.properties    ← French, France
messages_fr_CA.properties    ← French, Canada
messages_de.properties       ← German
messages_ja.properties       ← Japanese
messages_ar.properties       ← Arabic
```

**File location:** Place files on the **classpath** — typically in `src/main/resources/` in a Maven/Gradle project.

### 3.2 Creating Property Files

`messages.properties` (fallback — English):
```properties
# Fallback bundle — used when no locale-specific file is found
greeting=Hello, {0}!
farewell=Goodbye, {0}!
balance.label=Your balance is: 
error.notfound=Item not found.
item.count={0,choice,0#no items|1#one item|1<{0} items}
date.label=Today's date: 
app.title=My Application
button.ok=OK
button.cancel=Cancel
```

`messages_fr.properties` (French):
```properties
# French translations — note: .properties files use ISO-8859-1 by default
# Use native2ascii tool OR use UTF-8 with ResourceBundle.Control
greeting=Bonjour, {0}\u00a0!
farewell=Au revoir, {0}\u00a0!
balance.label=Votre solde est\u00a0: 
error.notfound=\u00c9l\u00e9ment introuvable.
item.count={0,choice,0#aucun article|1#un article|1<{0} articles}
date.label=Date du jour\u00a0: 
app.title=Mon Application
button.ok=OK
button.cancel=Annuler
```

`messages_de.properties` (German):
```properties
greeting=Hallo, {0}!
farewell=Auf Wiedersehen, {0}!
balance.label=Ihr Guthaben betr\u00e4gt: 
error.notfound=Element nicht gefunden.
item.count={0,choice,0#keine Artikel|1#ein Artikel|1<{0} Artikel}
date.label=Heutiges Datum: 
app.title=Meine Anwendung
button.ok=OK
button.cancel=Abbrechen
```

`messages_ja.properties` (Japanese — using Unicode escapes):
```properties
greeting=\u3053\u3093\u306b\u3061\u306f\u3001{0}\uff01
farewell=\u3055\u3088\u3046\u306a\u3089\u3001{0}\uff01
app.title=\u79c1\u306e\u30a2\u30d7\u30ea
button.ok=OK
button.cancel=\u30ad\u30e3\u30f3\u30bb\u30eb
```

### 3.3 `ResourceBundle.getBundle()` — Loading Bundles

```java
import java.util.ResourceBundle;
import java.util.Locale;

// Load for a specific locale
ResourceBundle bundle = ResourceBundle.getBundle("messages", Locale.FRANCE);
System.out.println(bundle.getString("greeting")); // Bonjour, {0} !

// Load for US English
ResourceBundle enBundle = ResourceBundle.getBundle("messages", Locale.US);
System.out.println(enBundle.getString("greeting")); // Hello, {0}!

// Load using default locale
ResourceBundle defaultBundle = ResourceBundle.getBundle("messages");
System.out.println(defaultBundle.getString("greeting")); // depends on JVM locale

// Load from a sub-package
ResourceBundle pkgBundle = ResourceBundle.getBundle("com.myapp.i18n.messages", Locale.GERMAN);
```

### 3.4 The Lookup Chain (Resolution Algorithm)

When you request `ResourceBundle.getBundle("messages", new Locale("fr", "CA"))`, Java searches in this exact order:

```
1. messages_fr_CA.properties     ← exact match (fr + CA)
2. messages_fr.properties        ← language match (fr only)
3. messages_[default country].properties ← JVM default locale country
4. messages_[default lang].properties   ← JVM default locale language
5. messages.properties           ← base fallback
6. MissingResourceException      ← thrown if nothing found
```

**Example:** Requesting `fr_CA`, with JVM default `en_US`:
```
messages_fr_CA.properties   ← look here first
messages_fr.properties      ← then here
messages_en_US.properties   ← then JVM default with country
messages_en.properties      ← then JVM default language
messages.properties         ← finally the base fallback
```

```java
// Demonstration of fallback
Locale frCA = new Locale("fr", "CA"); // French Canada
ResourceBundle bundle = ResourceBundle.getBundle("messages", frCA);
// If messages_fr_CA.properties doesn't exist, falls back to messages_fr.properties
// If that doesn't exist either, falls back to messages.properties
```

### 3.5 Retrieving Values

```java
ResourceBundle bundle = ResourceBundle.getBundle("messages", Locale.US);

// Get a String
String greeting = bundle.getString("greeting"); // "Hello, {0}!"

// Get a String array (property value: "red,green,blue")
String[] colors = bundle.getStringArray("colors");

// Get any Object
Object obj = bundle.getObject("someKey");

// Check if a key exists (avoid MissingResourceException)
if (bundle.containsKey("optional.feature")) {
    String val = bundle.getString("optional.feature");
}

// Handle missing key gracefully
String value;
try {
    value = bundle.getString("possibly.missing.key");
} catch (MissingResourceException e) {
    value = "DEFAULT_VALUE";
}

// List all keys
Enumeration<String> keys = bundle.getKeys();
while (keys.hasMoreElements()) {
    String key = keys.nextElement();
    System.out.println(key + " = " + bundle.getString(key));
}

// Java 8+: stream keys
bundle.keySet().forEach(key -> System.out.println(key + ": " + bundle.getString(key)));
```

### 3.6 UTF-8 Property Files (Java 9+)

Before Java 9, `.properties` files were loaded as ISO-8859-1. Characters outside this range had to be escaped as Unicode (`\u00e9`). From Java 9+, `.properties` files are read as **UTF-8** by default.

```java
// Java 9+ — UTF-8 properties files work natively
// messages_fr.properties can contain:
// greeting=Bonjour, {0} !
// farewell=Au revoir, {0} !
// (no \u escapes needed)

// Java 8 and earlier — use ResourceBundle.Control for UTF-8:
ResourceBundle bundle = ResourceBundle.getBundle("messages", Locale.FRANCE,
    new ResourceBundle.Control() {
        @Override
        public ResourceBundle newBundle(String baseName, Locale locale,
                String format, ClassLoader loader, boolean reload)
                throws IOException {
            String bundleName = toBundleName(baseName, locale);
            String resourceName = toResourceName(bundleName, "properties");
            try (InputStream is = loader.getResourceAsStream(resourceName);
                 InputStreamReader isr = new InputStreamReader(is, StandardCharsets.UTF_8)) {
                return new PropertyResourceBundle(isr);
            }
        }
    });
```

### 3.7 ListResourceBundle — Programmatic Bundle

An alternative to property files: subclass `ListResourceBundle` to provide resources programmatically. Useful for non-string resources (images, etc.).

```java
public class Messages_en extends ListResourceBundle {
    @Override
    protected Object[][] getContents() {
        return new Object[][] {
            { "greeting",      "Hello, {0}!"   },
            { "farewell",      "Goodbye, {0}!" },
            { "max.retries",   3               }, // non-String value
            { "icon.warning",  loadIcon()      }, // could be any Object
        };
    }

    private Object loadIcon() { return null; /* load image */ }
}

// Use the same way:
ResourceBundle bundle = ResourceBundle.getBundle("Messages", Locale.ENGLISH);
String greeting = bundle.getString("greeting");
int retries = (Integer) bundle.getObject("max.retries");
```

### 3.8 Bundle Caching

`ResourceBundle` caches loaded bundles by default. Repeated calls to `getBundle()` with the same arguments return the cached instance.

```java
// Both calls return the SAME cached instance
ResourceBundle b1 = ResourceBundle.getBundle("messages", Locale.US);
ResourceBundle b2 = ResourceBundle.getBundle("messages", Locale.US);
System.out.println(b1 == b2); // true — same cached object

// Clear the cache (useful in hot-reload scenarios)
ResourceBundle.clearCache();

// Clear cache for a specific class loader
ResourceBundle.clearCache(MyClass.class.getClassLoader());
```

---

## 4. MessageFormat — Parameterized Messages

`MessageFormat` formats messages with **placeholders** that are replaced by supplied arguments. It is far more powerful than simple string concatenation because it supports locale-aware formatting of numbers, dates, and choice (pluralization) within messages.

### 4.1 Basic Usage — Static `format()`

```java
import java.text.MessageFormat;

// {0} is replaced by the first argument, {1} by the second, etc.
String result = MessageFormat.format("Hello, {0}! You have {1} messages.", "Alice", 5);
System.out.println(result); // Hello, Alice! You have 5 messages.

// Arguments are Object[] — primitives are autoboxed
String r2 = MessageFormat.format("Item {0} costs {1}", "Widget", 19.99);
System.out.println(r2); // Item Widget costs 19.99

// Argument reuse — same index can appear multiple times
String r3 = MessageFormat.format("{0} said: \"{1}\". {0} smiled.", "Alice", "Hello");
System.out.println(r3); // Alice said: "Hello". Alice smiled.
```

### 4.2 Format Types in Placeholders

The full placeholder syntax is: `{argumentIndex, formatType, formatStyle}`

| Format Type | Format Style | Example Pattern | Result |
|---|---|---|---|
| (none) | — | `{0}` | Default `toString()` |
| `number` | (default) | `{0,number}` | 1,234.56 |
| `number` | `integer` | `{0,number,integer}` | 1,235 |
| `number` | `currency` | `{0,number,currency}` | $1,234.56 |
| `number` | `percent` | `{0,number,percent}` | 123,456% |
| `number` | pattern | `{0,number,#,##0.00}` | 1,234.56 |
| `date` | (default) | `{0,date}` | Jan 12, 2024 |
| `date` | `short` | `{0,date,short}` | 1/12/24 |
| `date` | `medium` | `{0,date,medium}` | Jan 12, 2024 |
| `date` | `long` | `{0,date,long}` | January 12, 2024 |
| `date` | `full` | `{0,date,full}` | Friday, January 12, 2024 |
| `time` | `short` | `{0,time,short}` | 3:30 PM |
| `time` | `full` | `{0,time,full}` | 3:30:45 PM EST |
| `choice` | pattern | `{0,choice,...}` | (see Section 4.4) |

```java
// Using format types
Date now = new Date();
double price = 1234.56;

String msg = MessageFormat.format(
    "On {0,date,full}, the price was {1,number,currency}.",
    now, price
);
// On Friday, January 12, 2024, the price was $1,234.56.
System.out.println(msg);
```

### 4.3 Locale-Aware `MessageFormat`

The static `MessageFormat.format()` uses the **default locale**. For explicit locale control, instantiate `MessageFormat`:

```java
double amount = 1234567.89;
Date now = new Date();

// German locale — dot as thousands separator, comma as decimal
MessageFormat mfDe = new MessageFormat(
    "Am {0,date,long} betrug der Betrag {1,number,currency}.",
    Locale.GERMANY
);
System.out.println(mfDe.format(new Object[]{now, amount}));
// Am 12. Januar 2024 betrug der Betrag 1.234.567,89 €.

// Japanese locale
MessageFormat mfJa = new MessageFormat(
    "{0,date,full}の残高は{1,number,currency}です。",
    Locale.JAPAN
);
System.out.println(mfJa.format(new Object[]{now, amount}));
// 2024年1月12日金曜日の残高は￥1,234,568です。

// US locale
MessageFormat mfUs = new MessageFormat(
    "On {0,date,long}, the balance was {1,number,currency}.",
    Locale.US
);
System.out.println(mfUs.format(new Object[]{now, amount}));
// On January 12, 2024, the balance was $1,234,567.89.
```

### 4.4 Choice Format — Pluralization

`ChoiceFormat` embedded inside `MessageFormat` handles pluralization rules. The pattern syntax is: `{index,choice,n1#text1|n2#text2|n3<text3}`

- `#` means "equal to n"
- `<` means "greater than n (exclusive)"
- `≤` or `\u2264` means "greater than or equal to n"

```java
// Pluralization with choice format
String pattern = "There {0,choice,0#are no files|1#is one file|1<are {0} files} to process.";

for (int n : new int[]{0, 1, 2, 100}) {
    System.out.println(MessageFormat.format(pattern, n));
}
// There are no files to process.
// There is one file to process.
// There are 2 files to process.
// There are 100 files to process.
```

```java
// Choice format with different ranges
String bundleKey = "{0,choice," +
    "0#no items|"      +  // exactly 0
    "1#one item|"      +  // exactly 1
    "2#a few items|"   +  // 2 (inclusive) to... 
    "10<many items"    +  // > 10
"}";

// Combined with ResourceBundle — key in .properties:
// cart.items={0,choice,0#Your cart is empty|1#You have 1 item|1<You have {0} items}
ResourceBundle bundle = ResourceBundle.getBundle("messages", Locale.US);
String msg = MessageFormat.format(bundle.getString("cart.items"), 7);
System.out.println(msg); // You have 7 items
```

### 4.5 Escaping Single Quotes

`MessageFormat` uses single quotes `'` as escape characters. To include a literal single quote, use `''`.

```java
// WRONG — single quote starts an escape sequence
MessageFormat.format("It's {0}", "great");  // "Itgreat" — 's {0}' is treated as literal!

// CORRECT — double single quote
MessageFormat.format("It''s {0}", "great"); // "It's great"

// Escaping curly braces with single quotes
MessageFormat.format("Use '{'0'}' for placeholders"); // "Use {0} for placeholders"
```

### 4.6 Combining ResourceBundle + MessageFormat

The standard pattern for i18n applications:

```java
public class I18nApp {

    private final ResourceBundle bundle;
    private final Locale locale;

    public I18nApp(Locale locale) {
        this.locale = locale;
        this.bundle = ResourceBundle.getBundle("messages", locale);
    }

    public String getMessage(String key, Object... args) {
        String pattern = bundle.getString(key);
        if (args == null || args.length == 0) return pattern;
        return new MessageFormat(pattern, locale).format(args);
    }

    public static void main(String[] args) {
        I18nApp usApp = new I18nApp(Locale.US);
        I18nApp frApp = new I18nApp(Locale.FRANCE);

        System.out.println(usApp.getMessage("greeting", "Alice"));
        // Hello, Alice!
        System.out.println(frApp.getMessage("greeting", "Alice"));
        // Bonjour, Alice !

        System.out.println(usApp.getMessage("cart.items", 0));
        // Your cart is empty
        System.out.println(usApp.getMessage("cart.items", 1));
        // You have 1 item
        System.out.println(usApp.getMessage("cart.items", 42));
        // You have 42 items
    }
}
```

---

## 5. NumberFormat — Locale-Aware Number Formatting

`NumberFormat` is an abstract class with factory methods for locale-specific formatting and parsing of numbers, currencies, and percentages.

### 5.1 Factory Methods

```java
import java.text.NumberFormat;

// General number formatter (uses locale's number conventions)
NumberFormat nf    = NumberFormat.getInstance();                    // default locale
NumberFormat nfUS  = NumberFormat.getInstance(Locale.US);
NumberFormat nfDE  = NumberFormat.getInstance(Locale.GERMANY);

// Integer formatter (no decimal places)
NumberFormat intf  = NumberFormat.getIntegerInstance(Locale.US);

// Currency formatter
NumberFormat curr  = NumberFormat.getCurrencyInstance();           // default locale
NumberFormat currUS = NumberFormat.getCurrencyInstance(Locale.US);
NumberFormat currDE = NumberFormat.getCurrencyInstance(Locale.GERMANY);
NumberFormat currJP = NumberFormat.getCurrencyInstance(Locale.JAPAN);

// Percent formatter
NumberFormat pct   = NumberFormat.getPercentInstance(Locale.US);

// Compact formatter (Java 12+)
NumberFormat compact = NumberFormat.getCompactNumberInstance(Locale.US, NumberFormat.Style.SHORT);
```

### 5.2 Formatting Numbers

```java
double number = 1234567.89;

// Different locales format numbers differently
System.out.println(NumberFormat.getInstance(Locale.US).format(number));      // 1,234,567.89
System.out.println(NumberFormat.getInstance(Locale.GERMANY).format(number)); // 1.234.567,89
System.out.println(NumberFormat.getInstance(Locale.FRANCE).format(number));  // 1 234 567,89 (space separator)
System.out.println(NumberFormat.getInstance(Locale.INDIA).format(number));   // 12,34,567.89 (Indian grouping!)
System.out.println(NumberFormat.getInstance(new Locale("ar","SA")).format(number)); // ١٬٢٣٤٬٥٦٧٫٨٩ (Arabic-Indic digits)
```

### 5.3 Currency Formatting

```java
double amount = 9999.99;

// Same amount, different locale currencies
System.out.println(NumberFormat.getCurrencyInstance(Locale.US).format(amount));
// $9,999.99

System.out.println(NumberFormat.getCurrencyInstance(Locale.GERMANY).format(amount));
// 9.999,99 €

System.out.println(NumberFormat.getCurrencyInstance(Locale.JAPAN).format(amount));
// ¥10,000  (Yen has no decimal places)

System.out.println(NumberFormat.getCurrencyInstance(Locale.FRANCE).format(amount));
// 9 999,99 €

System.out.println(NumberFormat.getCurrencyInstance(new Locale("hi", "IN")).format(amount));
// ₹9,999.99

// Get the currency symbol
NumberFormat currUS = NumberFormat.getCurrencyInstance(Locale.US);
System.out.println(currUS.getCurrency().getSymbol()); // $
System.out.println(currUS.getCurrency().getCurrencyCode()); // USD
System.out.println(currUS.getCurrency().getDefaultFractionDigits()); // 2
```

### 5.4 Configuring Min/Max Decimal Places

```java
NumberFormat nf = NumberFormat.getInstance(Locale.US);

nf.setMinimumFractionDigits(2); // always show at least 2 decimal places
nf.setMaximumFractionDigits(4); // never show more than 4 decimal places
nf.setMinimumIntegerDigits(1);  // always show at least 1 integer digit
nf.setGroupingUsed(false);      // disable thousand separators

System.out.println(nf.format(1.5));        // 1.50
System.out.println(nf.format(1.23456789)); // 1.2346 (rounded to 4 decimals)
System.out.println(nf.format(1000000.0));  // 1000000.00 (no grouping)
```

### 5.5 Percentage Formatting

```java
// Format as percentage (value 0.75 → "75%")
NumberFormat pct = NumberFormat.getPercentInstance(Locale.US);
System.out.println(pct.format(0.75));   // 75%
System.out.println(pct.format(1.0));    // 100%
System.out.println(pct.format(0.1234)); // 12%

// More decimal places
pct.setMinimumFractionDigits(2);
System.out.println(pct.format(0.1234)); // 12.34%

// German percent
NumberFormat pctDE = NumberFormat.getPercentInstance(Locale.GERMANY);
System.out.println(pctDE.format(0.75)); // 75 % (space before %)
```

### 5.6 Compact Number Formatting (Java 12+)

```java
NumberFormat compact = NumberFormat.getCompactNumberInstance(
    Locale.US, NumberFormat.Style.SHORT);

System.out.println(compact.format(1_000));       // 1K
System.out.println(compact.format(1_500));       // 2K (rounds)
System.out.println(compact.format(1_000_000));   // 1M
System.out.println(compact.format(2_500_000));   // 3M
System.out.println(compact.format(1_000_000_000)); // 1B

// LONG style
NumberFormat compactLong = NumberFormat.getCompactNumberInstance(
    Locale.US, NumberFormat.Style.LONG);
System.out.println(compactLong.format(1_000));     // 1 thousand
System.out.println(compactLong.format(2_000_000)); // 2 million

// French compact
NumberFormat compactFR = NumberFormat.getCompactNumberInstance(
    Locale.FRANCE, NumberFormat.Style.SHORT);
System.out.println(compactFR.format(1_000)); // 1 millier? → 1 k (depends on CLDR)
```

### 5.7 Parsing Strings to Numbers

`NumberFormat` is bidirectional — it can also **parse** locale-formatted strings:

```java
NumberFormat nfDE = NumberFormat.getInstance(Locale.GERMANY);
NumberFormat nfUS = NumberFormat.getInstance(Locale.US);

try {
    // Parse German format (comma as decimal separator)
    Number n1 = nfDE.parse("1.234.567,89");
    System.out.println(n1.doubleValue()); // 1234567.89

    // Parse US format
    Number n2 = nfUS.parse("1,234,567.89");
    System.out.println(n2.doubleValue()); // 1234567.89

    // TRAP: parsing "1,234" with German locale gives 1.234 (comma = decimal)
    Number trap = nfDE.parse("1,234");
    System.out.println(trap.doubleValue()); // 1.234 (not 1234!)

} catch (ParseException e) {
    System.err.println("Parse error: " + e.getMessage());
}
```

---

## 6. DecimalFormat — Custom Number Patterns

`DecimalFormat` is a concrete subclass of `NumberFormat` that lets you specify **exact patterns** for number formatting using a special pattern language.

### 6.1 Creating a `DecimalFormat`

```java
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;

// With explicit pattern (uses default locale's symbols)
DecimalFormat df = new DecimalFormat("#,##0.00");
System.out.println(df.format(1234567.89)); // 1,234,567.89

// With pattern AND specific locale's symbols
DecimalFormat dfDE = new DecimalFormat("#,##0.00",
    new DecimalFormatSymbols(Locale.GERMANY));
System.out.println(dfDE.format(1234567.89)); // 1.234.567,89

// Change pattern after construction
df.applyPattern("0.000");
System.out.println(df.format(3.14));  // 3.140
```

### 6.2 Pattern Syntax

| Symbol | Meaning |
|---|---|
| `0` | Digit — always shown (padded with 0 if necessary) |
| `#` | Digit — omitted if zero |
| `.` | Decimal separator |
| `,` | Grouping separator (position determines group size) |
| `E` | Scientific notation (e.g., `0.##E0`) |
| `%` | Multiply by 100 and format as percent |
| `‰` (`\u2030`) | Multiply by 1000 and format as per-mille |
| `-` | Negative prefix/suffix |
| `+` | Always show sign |
| `(` `)` | Negative numbers in parentheses (accounting) |
| `'` | Escape for literal characters |
| `¤` (`\u00A4`) | Currency sign — replaced by locale symbol |
| `;` | Separates positive and negative subpatterns |

```java
// Pattern examples
DecimalFormat[] formats = {
    new DecimalFormat("#,##0.00"),      // Standard: 1,234.57
    new DecimalFormat("0.000"),          // Fixed 3 decimals: 1234.568
    new DecimalFormat("#.##"),           // Up to 2 decimals: 1234.57
    new DecimalFormat("000000"),         // Zero-padded: 001235
    new DecimalFormat("0.##E0"),         // Scientific: 1.23E3
    new DecimalFormat("#,##0.00%"),      // Percent with formatting
    new DecimalFormat("¤#,##0.00"),      // Currency symbol
    new DecimalFormat("+#,##0.00;-#,##0.00"), // Explicit +/- signs
};

double value = 1234.5678;
for (DecimalFormat fmt : formats) {
    System.out.printf("Pattern %-20s → %s%n", fmt.toPattern(), fmt.format(value));
}
// Pattern #,##0.00              → 1,234.57
// Pattern 0.000                 → 1234.568
// Pattern #.##                  → 1234.57
// Pattern 000000                → 001235
// Pattern 0.##E0                → 1.23E3
// Pattern #,##0.00%             → 123,456.78%
// Pattern ¤#,##0.00             → $1,234.57
// Pattern +#,##0.00;-#,##0.00   → +1,234.57
```

### 6.3 `DecimalFormatSymbols` — Customizing Symbols

```java
DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.US);
symbols.setDecimalSeparator(',');   // swap . and ,
symbols.setGroupingSeparator('.');  // swap , and .
symbols.setCurrencySymbol("€");     // change currency symbol
symbols.setMinusSign('−');          // use Unicode minus

DecimalFormat custom = new DecimalFormat("#,##0.00", symbols);
System.out.println(custom.format(1234567.89)); // 1.234.567,89
```

### 6.4 Positive and Negative Subpatterns

Use `;` to specify different formats for positive and negative numbers:

```java
// Accounting style: positive normal, negative in parentheses
DecimalFormat accounting = new DecimalFormat("#,##0.00;(#,##0.00)");
System.out.println(accounting.format(1234.56));  // 1,234.56
System.out.println(accounting.format(-1234.56)); // (1,234.56)

// Always show sign
DecimalFormat signed = new DecimalFormat("+#,##0.00;-#,##0.00");
System.out.println(signed.format(500.0));   // +500.00
System.out.println(signed.format(-500.0));  // -500.00
```

### 6.5 Scientific Notation

```java
DecimalFormat sci = new DecimalFormat("0.##E0");
System.out.println(sci.format(123456789.0)); // 1.23E8
System.out.println(sci.format(0.000123));    // 1.23E-4
System.out.println(sci.format(1.0));         // 1E0

// More precise
DecimalFormat sci2 = new DecimalFormat("0.0000E0");
System.out.println(sci2.format(123456789.0)); // 1.2346E8
```

### 6.6 Parsing with `DecimalFormat`

```java
DecimalFormat df = new DecimalFormat("#,##0.00");
try {
    Number n = df.parse("1,234,567.89");
    System.out.println(n.doubleValue()); // 1234567.89
} catch (ParseException e) {
    e.printStackTrace();
}

// ParsePosition for partial parsing
ParsePosition pos = new ParsePosition(0);
Number n = df.parse("1,234.56 extra text", pos);
System.out.println(n);           // 1234.56
System.out.println(pos.getIndex()); // 8 (position after the parsed number)
```

---

## 7. `DateTimeFormatter` with Locales

Java 8's `java.time.format.DateTimeFormatter` provides immutable, thread-safe formatters with full locale support.

### 7.1 Localized Format Styles

`FormatStyle` provides four pre-defined verbosity levels:

| Style | US Example | German Example | Japanese Example |
|---|---|---|---|
| `SHORT` | 1/15/24 | 15.01.24 | 2024/01/15 |
| `MEDIUM` | Jan 15, 2024 | 15.01.2024 | 2024/01/15 |
| `LONG` | January 15, 2024 | 15. Januar 2024 | 2024年1月15日 |
| `FULL` | Monday, January 15, 2024 | Montag, 15. Januar 2024 | 2024年1月15日月曜日 |

```java
import java.time.*;
import java.time.format.*;

LocalDate date = LocalDate.of(2024, 1, 15);
LocalTime time = LocalTime.of(14, 30, 45);
LocalDateTime dateTime = LocalDateTime.of(date, time);

// Date only — with different locales
for (FormatStyle style : FormatStyle.values()) {
    DateTimeFormatter fmt = DateTimeFormatter
        .ofLocalizedDate(style)
        .withLocale(Locale.US);
    System.out.printf("%-8s US:  %s%n", style, date.format(fmt));
}
// SHORT   US:  1/15/24
// MEDIUM  US:  Jan 15, 2024
// LONG    US:  January 15, 2024
// FULL    US:  Monday, January 15, 2024

// Same date in different locales with FULL style
DateTimeFormatter full = DateTimeFormatter.ofLocalizedDate(FormatStyle.FULL);
for (Locale locale : new Locale[]{Locale.US, Locale.GERMANY, Locale.JAPAN,
                                   Locale.FRANCE, new Locale("ar","SA")}) {
    System.out.printf("%-15s → %s%n",
        locale.getDisplayName(Locale.ENGLISH),
        date.format(full.withLocale(locale)));
}
// English (United States) → Monday, January 15, 2024
// German (Germany)        → Montag, 15. Januar 2024
// Japanese (Japan)        → 2024年1月15日月曜日
// French (France)         → lundi 15 janvier 2024
// Arabic (Saudi Arabia)   → الاثنين، ١٥ يناير ٢٠٢٤
```

### 7.2 `ofLocalizedDate()`, `ofLocalizedTime()`, `ofLocalizedDateTime()`

```java
LocalDate date = LocalDate.now();
LocalTime time = LocalTime.now();
LocalDateTime dt = LocalDateTime.now();

Locale frFR = Locale.FRANCE;

// Date only
DateTimeFormatter dateFormatter = DateTimeFormatter
    .ofLocalizedDate(FormatStyle.LONG)
    .withLocale(frFR);
System.out.println(date.format(dateFormatter)); // 15 janvier 2024

// Time only
DateTimeFormatter timeFormatter = DateTimeFormatter
    .ofLocalizedTime(FormatStyle.MEDIUM)
    .withLocale(frFR);
System.out.println(time.format(timeFormatter)); // 14:30:45

// Date and time (two FormatStyle args: date style, time style)
DateTimeFormatter dtFormatter = DateTimeFormatter
    .ofLocalizedDateTime(FormatStyle.LONG, FormatStyle.SHORT)
    .withLocale(frFR);
System.out.println(dt.format(dtFormatter)); // 15 janvier 2024 à 14:30
```

### 7.3 `withLocale()` — Changing Locale of an Existing Formatter

`DateTimeFormatter` is immutable. `withLocale()` returns a **new** formatter with the specified locale:

```java
// Base formatter
DateTimeFormatter base = DateTimeFormatter.ofLocalizedDate(FormatStyle.FULL);
// base.getLocale() → JVM default locale

// Create locale-specific versions
DateTimeFormatter forUS = base.withLocale(Locale.US);
DateTimeFormatter forJP = base.withLocale(Locale.JAPAN);
DateTimeFormatter forDE = base.withLocale(Locale.GERMANY);

LocalDate date = LocalDate.of(2024, 7, 4);
System.out.println(date.format(forUS)); // Thursday, July 4, 2024
System.out.println(date.format(forJP)); // 2024年7月4日木曜日
System.out.println(date.format(forDE)); // Donnerstag, 4. Juli 2024
```

### 7.4 Custom Patterns with Locale

```java
// Custom pattern, locale-aware month/day names
DateTimeFormatter custom = DateTimeFormatter
    .ofPattern("EEEE, dd MMMM yyyy")  // EEEE = full day name, MMMM = full month name
    .withLocale(Locale.FRANCE);

System.out.println(LocalDate.of(2024, 1, 15).format(custom));
// lundi, 15 janvier 2024

// Same pattern in Japanese
DateTimeFormatter customJP = DateTimeFormatter
    .ofPattern("yyyy年M月d日(EEEE)")
    .withLocale(Locale.JAPAN);
System.out.println(LocalDate.of(2024, 1, 15).format(customJP));
// 2024年1月15日(月曜日)
```

### 7.5 `withChronology()` — Non-ISO Calendar Systems

Java supports multiple calendar systems via `java.time.chrono`:

```java
import java.time.chrono.*;
import java.time.format.*;

LocalDate isoDate = LocalDate.of(2024, 1, 15);

// Japanese Imperial calendar
DateTimeFormatter jpImperial = DateTimeFormatter
    .ofLocalizedDate(FormatStyle.FULL)
    .withLocale(Locale.JAPAN)
    .withChronology(JapaneseChronology.INSTANCE);
System.out.println(isoDate.format(jpImperial));
// 令和6年1月15日月曜日 (Reiwa 6, January 15)

// Thai Buddhist calendar
DateTimeFormatter thai = DateTimeFormatter
    .ofLocalizedDate(FormatStyle.FULL)
    .withLocale(new Locale("th", "TH"))
    .withChronology(ThaiBuddhistChronology.INSTANCE);
System.out.println(isoDate.format(thai));
// วันจันทร์ที่ 15 มกราคม พ.ศ. 2567 (BE 2567)

// Hijri (Islamic) calendar
DateTimeFormatter hijri = DateTimeFormatter
    .ofLocalizedDate(FormatStyle.FULL)
    .withLocale(new Locale("ar", "SA"))
    .withChronology(HijrahChronology.INSTANCE);
System.out.println(isoDate.format(hijri));
// الاثنين، ٤ رجب ١٤٤٥ هـ
```

### 7.6 Parsing Localized Dates

```java
DateTimeFormatter parser = DateTimeFormatter
    .ofPattern("d MMMM yyyy")
    .withLocale(Locale.FRANCE);

LocalDate date = LocalDate.parse("15 janvier 2024", parser);
System.out.println(date); // 2024-01-15

// Parse German date
DateTimeFormatter deParser = DateTimeFormatter
    .ofLocalizedDate(FormatStyle.LONG)
    .withLocale(Locale.GERMANY);
LocalDate deDate = LocalDate.parse("15. Januar 2024", deParser);
System.out.println(deDate); // 2024-01-15
```

### 7.7 `DateTimeFormatterBuilder` — Full Control

```java
DateTimeFormatter formatter = new DateTimeFormatterBuilder()
    .appendLocalized(FormatStyle.FULL, null)  // full date, no time
    .optionalStart()
        .appendLiteral(" at ")
        .appendLocalized(null, FormatStyle.SHORT) // optional short time
    .optionalEnd()
    .toFormatter(Locale.US);
```

---

## 8. `Collator` — Locale-Sensitive String Comparison and Sorting

Standard Java string comparison (`String.compareTo()`) uses Unicode code points. This is **wrong** for locale-sensitive sorting. `Collator` provides linguistically correct comparison.

### 8.1 Why `String.compareTo()` Is Wrong for Sorting

```java
// String.compareTo() — Unicode code point order
List<String> names = Arrays.asList("Ångström", "Anderson", "Åberg", "Adams");
Collections.sort(names); // sort by Unicode code points
System.out.println(names); // [Adams, Anderson, Ångström, Åberg]
// Å (U+00C5 = 197) sorts AFTER 'Z' (U+005A = 90)
// In Swedish, Å, Ä, Ö sort at the END of the alphabet — so this is actually correct for Swedish!
// But in English, Å should sort like 'A'
```

### 8.2 Creating a `Collator`

```java
import java.text.Collator;

// Get collator for a specific locale
Collator usCollator  = Collator.getInstance(Locale.US);
Collator seCollator  = Collator.getInstance(new Locale("sv", "SE")); // Swedish
Collator deCollator  = Collator.getInstance(Locale.GERMANY);
Collator jaCollator  = Collator.getInstance(Locale.JAPAN);
Collator defaultCollator = Collator.getInstance(); // uses default locale
```

### 8.3 Collation Strength

`Collator.setStrength()` controls how sensitive comparisons are:

| Strength Constant | Meaning | "a" vs "A" | "a" vs "á" | "a" vs "b" |
|---|---|---|---|---|
| `PRIMARY` | Base characters only | Same | Same | Different |
| `SECONDARY` | + Accents/diacritics | Same | Different | Different |
| `TERTIARY` (default) | + Case | Different | Different | Different |
| `IDENTICAL` | + Unicode code point | Different | Different | Different |

```java
Collator col = Collator.getInstance(Locale.US);

// PRIMARY — ignores case AND accents
col.setStrength(Collator.PRIMARY);
System.out.println(col.compare("resume", "résumé") == 0); // true — same base letters
System.out.println(col.compare("Hello", "hello") == 0);   // true — case ignored

// SECONDARY — distinguishes accents but NOT case
col.setStrength(Collator.SECONDARY);
System.out.println(col.compare("resume", "résumé") == 0); // false — accent matters
System.out.println(col.compare("Hello", "hello") == 0);   // true  — case ignored

// TERTIARY (default) — distinguishes accents AND case
col.setStrength(Collator.TERTIARY);
System.out.println(col.compare("resume", "résumé") == 0); // false
System.out.println(col.compare("Hello", "hello") == 0);   // false
```

### 8.4 Sorting with Collator

```java
// Locale-correct sorting
Collator col = Collator.getInstance(Locale.GERMANY);

List<String> words = Arrays.asList("Straße", "Strassen", "straße", "Strasse");
words.sort(col); // use Collator as Comparator<Object>
System.out.println(words);
// German rules: ß sorts like "ss", case-insensitive at PRIMARY level

// Sort a list of names in Swedish
Collator swedish = Collator.getInstance(new Locale("sv", "SE"));
List<String> scandNames = Arrays.asList("Örjan", "Anders", "Åsa", "Björn", "Eva");
scandNames.sort(swedish);
System.out.println(scandNames);
// [Anders, Björn, Eva, Åsa, Örjan] — Å and Ö sort at end in Swedish
```

### 8.5 Case Decomposition

```java
Collator col = Collator.getInstance(Locale.US);

// CANONICAL_DECOMPOSITION — handles pre-composed and decomposed Unicode forms as equal
col.setDecomposition(Collator.CANONICAL_DECOMPOSITION);
// é (U+00E9) == e + ́ (U+0065 + U+0301) after decomposition

// FULL_DECOMPOSITION — also handles compatibility characters
col.setDecomposition(Collator.FULL_DECOMPOSITION);
// ﬁ (U+FB01 fi ligature) == fi

// NO_DECOMPOSITION — fastest, but may miss Unicode equivalences
col.setDecomposition(Collator.NO_DECOMPOSITION);
```

### 8.6 `CollationKey` — Efficient Repeated Comparisons

For sorting large datasets, pre-compute `CollationKey` objects. Comparing keys is much faster than re-running collation each time.

```java
Collator col = Collator.getInstance(Locale.US);

// Pre-compute keys for all strings
List<String> words = Arrays.asList("banana", "Apple", "cherry", "Date");

// Create key-string pairs
List<Map.Entry<CollationKey, String>> keyed = words.stream()
    .map(w -> Map.entry(col.getCollationKey(w), w))
    .collect(Collectors.toList());

// Sort by key (fast — binary comparison)
keyed.sort(Map.Entry.comparingByKey());

// Extract sorted strings
List<String> sorted = keyed.stream()
    .map(Map.Entry::getValue)
    .collect(Collectors.toList());

System.out.println(sorted); // [Apple, banana, cherry, Date] — case-insensitive? depends on strength
```

### 8.7 Real-World Sort Example — Phone Book Order

```java
public class PhoneBook {
    public static void main(String[] args) {
        List<String> names = Arrays.asList(
            "van der Berg", "De Vries", "Müller", "Mueller",
            "Schmidt", "Schäfer", "Straße", "Strasse",
            "Åberg", "Ångström"
        );

        // German phone book order
        Collator german = Collator.getInstance(Locale.GERMANY);
        german.setStrength(Collator.TERTIARY);

        names.sort(german);
        System.out.println("German order:");
        names.forEach(n -> System.out.println("  " + n));

        // English order
        Collator english = Collator.getInstance(Locale.US);
        List<String> englishSorted = new ArrayList<>(names);
        englishSorted.sort(english);
        System.out.println("\nEnglish order:");
        englishSorted.forEach(n -> System.out.println("  " + n));
    }
}
```

---

## 9. Unicode in Java — UTF-16, Surrogate Pairs, Character Methods

### 9.1 Unicode Fundamentals

**Unicode** assigns a unique **code point** to every character. Code points are integers from `U+0000` to `U+10FFFF` — over 1.1 million possible characters.

- **BMP (Basic Multilingual Plane)**: code points `U+0000` to `U+FFFF` — most common characters
- **Supplementary planes**: code points `U+10000` to `U+10FFFF` — emoji, historic scripts, etc.

### 9.2 How Java Represents Characters — UTF-16

Java's `char` is a **16-bit unsigned integer** (range 0–65535). This means it can directly represent BMP characters but **cannot** represent supplementary characters in a single `char`.

**UTF-16** is Java's internal string encoding:
- BMP characters: encoded as a single 16-bit `char`
- Supplementary characters: encoded as **two `char`s called a surrogate pair**

```java
// BMP character — fits in one char
char latin = 'A';            // U+0041 — fine
char euro  = '€';            // U+20AC — fine
char kanji = '日';            // U+65E5 — fine (BMP)

// Supplementary character — requires surrogate pair
// 𝄞 (MUSICAL SYMBOL G CLEF) — U+1D11E
String gClef = "\uD834\uDD1E"; // two chars: high surrogate + low surrogate
System.out.println(gClef.length()); // 2  ← not 1!
System.out.println(gClef.codePointAt(0)); // 119070 = 0x1D11E ✓

// 😀 (GRINNING FACE emoji) — U+1F600
String emoji = "😀";
System.out.println(emoji.length()); // 2  ← surprise! it's 2 chars
System.out.println(emoji.codePointCount(0, emoji.length())); // 1 ← one code point
```

### 9.3 Surrogate Pairs

When a Unicode code point is in the supplementary range (`U+10000` to `U+10FFFF`), UTF-16 encodes it as two 16-bit code units:

- **High surrogate**: `U+D800` to `U+DBFF`
- **Low surrogate**: `U+DC00` to `U+DFFF`

Together they form a surrogate pair. Their combined value encodes the supplementary code point.

```java
int codePoint = 0x1F600; // 😀 GRINNING FACE

// Encode code point to surrogate pair
char[] surrogates = Character.toChars(codePoint);
System.out.println(surrogates.length);      // 2
System.out.printf("High: U+%04X%n", (int) surrogates[0]); // High: U+D83D
System.out.printf("Low:  U+%04X%n", (int) surrogates[1]); // Low:  U+DE00

// Decode surrogate pair back to code point
int decoded = Character.toCodePoint(surrogates[0], surrogates[1]);
System.out.printf("Code point: U+%04X%n", decoded); // Code point: U+1F600

// Check if a char is a surrogate
char high = surrogates[0];
char low  = surrogates[1];
System.out.println(Character.isHighSurrogate(high)); // true
System.out.println(Character.isLowSurrogate(low));   // true
System.out.println(Character.isSurrogate(high));     // true
```

### 9.4 Safe String Iteration — Code Point by Code Point

**WRONG** — iterating by `char` breaks surrogate pairs:

```java
String text = "Hello 😀 World";

// WRONG — char loop breaks at emoji
for (int i = 0; i < text.length(); i++) {
    char c = text.charAt(i); // surrogate chars are not printable individually
    System.out.print(c + " ");
}
// 'H' 'e' 'l' 'l' 'o' ' ' '?' '?' ' ' 'W' 'o' 'r' 'l' 'd'
// The emoji appears as two garbage chars
```

**CORRECT** — iterate by code point:

```java
// Method 1: codePoints() stream (Java 8+)
"Hello 😀 World".codePoints().forEach(cp -> {
    System.out.printf("U+%04X (%s)%n", cp, new String(Character.toChars(cp)));
});
// U+0048 (H), U+0065 (e), ..., U+1F600 (😀), ...

// Method 2: manual code point loop
String text = "Hello 😀 World 𝄞";
for (int i = 0; i < text.length(); ) {
    int codePoint = text.codePointAt(i);
    System.out.printf("U+%04X → %s%n", codePoint, new String(Character.toChars(codePoint)));
    i += Character.charCount(codePoint); // advance by 1 or 2 depending on surrogate
}

// Method 3: Characters.toChars
int count = text.codePointCount(0, text.length()); // true character count
System.out.println("Char count (incorrect): " + text.length()); // 16
System.out.println("Code point count:       " + count);          // 15
```

### 9.5 `String.chars()` vs `String.codePoints()`

```java
String text = "Héllo 😀";

// chars() — streams char values (surrogates appear as separate ints)
text.chars().forEach(c -> System.out.print((char) c + " "));
// H é l l o   [high surrogate] [low surrogate]

// codePoints() — streams Unicode code points (handles surrogates correctly)
text.codePoints().forEach(cp -> System.out.print(new String(Character.toChars(cp)) + " "));
// H é l l o   😀
```

### 9.6 `Character` Methods — Unicode-Aware vs ASCII

**WRONG** — ASCII range checks break for Unicode:

```java
// WRONG — only works for ASCII/Latin letters
char c = 'ñ';
boolean isLetterWrong = (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
System.out.println(isLetterWrong); // false — ñ is a letter but not ASCII!

// WRONG — Character.isLetter(char) is correct for BMP but breaks for supplementary
char highSurrogate = "\uD83D".charAt(0);
System.out.println(Character.isLetter(highSurrogate)); // undefined behavior
```

**CORRECT** — use `Character` methods with **code point** (int) variants:

```java
// isLetter(int codePoint) — correct for all Unicode
System.out.println(Character.isLetter('A'));    // true
System.out.println(Character.isLetter('ñ'));    // true — Unicode-aware
System.out.println(Character.isLetter('日'));    // true — CJK character
System.out.println(Character.isLetter('3'));    // false — digit
System.out.println(Character.isLetter(0x1F600)); // false — emoji (Symbol, not Letter)

// Full set of correct Character methods
int cp = 'A';
Character.isLetter(cp);        // true for any Unicode letter
Character.isDigit(cp);         // true for any Unicode decimal digit
Character.isLetterOrDigit(cp); // letter or digit
Character.isWhitespace(cp);    // Java whitespace (space, tab, newline, etc.)
Character.isSpaceChar(cp);     // Unicode space character
Character.isUpperCase(cp);     // uppercase letter
Character.isLowerCase(cp);     // lowercase letter
Character.isTitleCase(cp);     // title case (some ligatures)
Character.isAlphabetic(cp);    // any alphabetic character (superset of isLetter)
Character.isIdeographic(cp);   // CJK ideographic character
Character.isDefined(cp);       // has an assigned Unicode value
Character.isMirrored(cp);      // char reverses in RTL text
Character.getType(cp);         // Unicode general category (int constant)
Character.getDirectionality(cp); // Unicode bidirectional category
```

### 9.7 Unicode General Categories

```java
// Character.getType() returns one of these constants:
Character.UPPERCASE_LETTER         // Lu — A, B, Ñ
Character.LOWERCASE_LETTER         // Ll — a, b, ñ
Character.TITLECASE_LETTER         // Lt — Dž
Character.MODIFIER_LETTER          // Lm
Character.OTHER_LETTER             // Lo — ideographs, syllables
Character.NON_SPACING_MARK         // Mn — combining accents
Character.DECIMAL_DIGIT_NUMBER     // Nd — 0-9, Arabic-Indic digits
Character.SPACE_SEPARATOR          // Zs — regular space, non-breaking space
Character.MATH_SYMBOL              // Sm — +, =, ∑
Character.CURRENCY_SYMBOL          // Sc — $, €, £
Character.OTHER_PUNCTUATION        // Po — !, ., ,

int type = Character.getType('€');
System.out.println(type == Character.CURRENCY_SYMBOL); // true
```

### 9.8 Case Conversion — Locale-Sensitive

```java
// WRONG — String.toUpperCase() uses default locale
// Famous bug: "i".toUpperCase() in Turkish locale becomes "İ" (with dot), not "I"
String str = "title";
System.out.println(str.toUpperCase()); // TITLE (fine for English)
System.out.println(str.toUpperCase(new Locale("tr", "TR"))); // TİTLE (Turkish dotted I!)

// CORRECT — always specify locale for case operations
String lower = "HELLO WORLD";
System.out.println(lower.toLowerCase(Locale.US));            // hello world
System.out.println(lower.toLowerCase(Locale.ROOT));          // hello world (locale-neutral)
System.out.println("ß".toUpperCase(Locale.GERMANY));         // SS (German sharp S)
System.out.println("ß".toUpperCase(Locale.US));              // SS (same result here)
System.out.println("straße".toUpperCase(Locale.GERMANY));    // STRASSE

// Locale.ROOT for locale-neutral operations (e.g., file formats, protocols)
"fileName".toUpperCase(Locale.ROOT);
```

### 9.9 Normalization

The same character can be represented multiple ways in Unicode:
- é = U+00E9 (pre-composed)
- é = U+0065 + U+0301 (e + combining accent)

```java
import java.text.Normalizer;

String s1 = "\u00E9";           // é as single code point
String s2 = "\u0065\u0301";     // e + combining acute accent

System.out.println(s1.equals(s2));  // false — different bytes!
System.out.println(s1.length());    // 1
System.out.println(s2.length());    // 2

// Normalize to NFC (Canonical Decomposition, then Canonical Composition — pre-composed)
String norm1 = Normalizer.normalize(s1, Normalizer.Form.NFC);
String norm2 = Normalizer.normalize(s2, Normalizer.Form.NFC);
System.out.println(norm1.equals(norm2)); // true — both become U+00E9
System.out.println(norm1.length());      // 1
System.out.println(norm2.length());      // 1

// NFD = Canonical Decomposition (decomposed form)
String nfd = Normalizer.normalize("é", Normalizer.Form.NFD);
System.out.println(nfd.length()); // 2 — e + combining accent

// Check if already normalized
System.out.println(Normalizer.isNormalized("café", Normalizer.Form.NFC)); // true (usually)
```

### 9.10 String Length vs Visual Length

```java
String text = "Hello 😀 世界"; // Hello + space + emoji + space + 2 CJK

System.out.println("text.length()   = " + text.length());           // 13 (chars, not characters!)
System.out.println("code points     = " + text.codePointCount(0, text.length())); // 12
// 'H','e','l','l','o',' ',[high],[low],' ','世','界' = 11 Java chars for 10 code points... let's count:
// H(1)+e(1)+l(1)+l(1)+o(1)+space(1)+emoji(2)+space(1)+世(1)+界(1) = 11 chars, 10 code points

// Correct way to count "characters" for display
int visualLength = (int) text.codePoints().count();
System.out.println("visual length   = " + visualLength); // 10
```

---

## 10. Best Practice — Externalize All User-Facing Strings

### 10.1 The Core Rule

> **Never hard-code user-visible strings in Java source code.**
> Every string that a user could see — labels, messages, errors, button text, tooltips — must live in a `ResourceBundle` property file.

This rule exists because:
1. Hard-coded strings cannot be translated without recompiling
2. Translators work with property files, not Java code
3. Different locales may need different sentence structures (word order varies!)
4. Plural forms differ vastly between languages (Russian has 3 plural forms; Arabic has 6)

### 10.2 What to Externalize

```java
// ❌ ALL OF THESE ARE WRONG
System.out.println("Welcome, " + name + "!");           // greeting — externalize
System.out.println("Error: file not found");            // error message — externalize
throw new Exception("Invalid input");                   // user-visible? — consider externalizing
JButton btn = new JButton("Submit");                    // UI label — externalize
log.error("Database connection failed");                // LOG messages — do NOT externalize (devs read these)
throw new IllegalArgumentException("index < 0");        // developer message — do NOT externalize
```

```java
// ✅ CORRECT
ResourceBundle b = ResourceBundle.getBundle("messages", userLocale);
System.out.println(MessageFormat.format(b.getString("welcome"), name));
System.out.println(b.getString("error.file.not.found"));
JButton btn = new JButton(b.getString("button.submit"));
```

### 10.3 Key Naming Conventions

Use hierarchical, dot-separated keys that describe the location and type of the string:

```properties
# Component type + context
button.ok=OK
button.cancel=Cancel
button.submit=Submit
button.delete=Delete

# Labels
label.username=Username
label.password=Password
label.email=Email Address

# Error messages — include error code for traceability
error.required={0} is required.
error.invalid.email=Please enter a valid email address.
error.not.found=The requested {0} was not found.
error.server=An unexpected error occurred. Please try again later.
error.validation.min={0} must be at least {1} characters.

# Page/section titles
page.title.home=Home
page.title.profile=Profile Settings
page.title.checkout=Checkout

# Navigation
nav.home=Home
nav.about=About
nav.contact=Contact

# Status messages
status.saved=Your changes have been saved.
status.deleted={0} has been deleted.
status.loading=Loading...

# Confirmation messages
confirm.delete=Are you sure you want to delete {0}? This action cannot be undone.

# Units and measurements
unit.bytes={0} bytes
unit.kilobytes={0} KB
unit.megabytes={0} MB

# Plurals using choice format
items.in.cart={0,choice,0#Your cart is empty|1#1 item in cart|1<{0} items in cart}
search.results={0,choice,0#No results found|1#1 result found|1<{0} results found}
```

### 10.4 Structured Property File Layout

```
src/
  main/
    java/
      com/myapp/
        I18n.java           ← i18n helper class
        controller/...
    resources/
      messages.properties         ← fallback (English)
      messages_fr.properties      ← French
      messages_de.properties      ← German
      messages_ja.properties      ← Japanese
      messages_zh_CN.properties   ← Simplified Chinese
      messages_ar.properties      ← Arabic
      validation.properties       ← separate bundle for validation messages
      validation_fr.properties
      errors.properties           ← separate bundle for error codes
```

### 10.5 The i18n Helper Class Pattern

```java
import java.text.MessageFormat;
import java.util.*;

/**
 * Central i18n service. Obtain an instance per user/request.
 * Thread-safe if locale is not mutated after construction.
 */
public final class I18n {

    private final Locale locale;
    private final ResourceBundle messages;

    // Multiple bundles for different contexts
    private final ResourceBundle errors;

    public I18n(Locale locale) {
        this.locale = locale;
        this.messages = ResourceBundle.getBundle("messages", locale);
        this.errors   = ResourceBundle.getBundle("errors", locale);
    }

    /** Get a plain message (no substitution). */
    public String get(String key) {
        try {
            return messages.getString(key);
        } catch (MissingResourceException e) {
            // Return the key itself as a fallback — visible in UI, alerts developers
            return "???" + key + "???";
        }
    }

    /** Get a parameterized message with substitution. */
    public String get(String key, Object... args) {
        try {
            String pattern = messages.getString(key);
            return new MessageFormat(pattern, locale).format(args);
        } catch (MissingResourceException e) {
            return "???" + key + "???";
        }
    }

    /** Get an error message from the errors bundle. */
    public String getError(String errorCode, Object... args) {
        try {
            String pattern = errors.getString(errorCode);
            return new MessageFormat(pattern, locale).format(args);
        } catch (MissingResourceException e) {
            return "Error: " + errorCode;
        }
    }

    public Locale getLocale() { return locale; }

    // Static convenience — use the JVM default locale
    private static final ThreadLocal<I18n> threadLocal = new ThreadLocal<>();

    public static void setForCurrentThread(Locale locale) {
        threadLocal.set(new I18n(locale));
    }

    public static I18n current() {
        I18n i18n = threadLocal.get();
        return (i18n != null) ? i18n : new I18n(Locale.getDefault());
    }
}
```

Usage:
```java
// In a web request handler — set locale from Accept-Language header
Locale userLocale = Locale.forLanguageTag(request.getHeader("Accept-Language"));
I18n.setForCurrentThread(userLocale);

// Anywhere in the request handling chain
I18n i18n = I18n.current();
response.setBody(i18n.get("welcome", userName));
response.setBody(i18n.get("items.in.cart", cartSize));
```

### 10.6 What NOT to Externalize

```java
// DO NOT externalize:
logger.debug("Processing request ID: {}", requestId);   // developer/ops log messages
logger.error("SQL error: {}", e.getMessage());           // stack traces, technical logs
throw new IllegalStateException("state must not be null"); // developer-facing exceptions
assert value > 0 : "value must be positive";             // assertion messages
// ...any message that developers/ops read, not end users
```

### 10.7 RTL Languages (Arabic, Hebrew, Persian)

For right-to-left languages, additional considerations apply:

```java
// Detect if a locale's language is RTL
public static boolean isRTL(Locale locale) {
    ComponentOrientation orientation = ComponentOrientation.getOrientation(locale);
    return !orientation.isLeftToRight();
}

// Arabic — Locale("ar")
Locale arabic = new Locale("ar");
System.out.println(isRTL(arabic)); // true

// Hebrew — Locale("he") or Locale("iw") (old code)
Locale hebrew = new Locale("he");
System.out.println(isRTL(hebrew)); // true

// In web apps, set the HTML dir attribute:
// <html dir="rtl" lang="ar">
//   or dynamically
String dir = isRTL(userLocale) ? "rtl" : "ltr";
String lang = userLocale.toLanguageTag();
```

---

## 11. Additional Topics

### 11.1 `Currency` Class

```java
import java.util.Currency;

Currency usd = Currency.getInstance("USD");
System.out.println(usd.getSymbol());                       // $
System.out.println(usd.getSymbol(Locale.FRANCE));          // $US (in French context)
System.out.println(usd.getCurrencyCode());                  // USD
System.out.println(usd.getDisplayName(Locale.US));         // US Dollar
System.out.println(usd.getDefaultFractionDigits());        // 2

Currency jpy = Currency.getInstance("JPY");
System.out.println(jpy.getDefaultFractionDigits());        // 0 — Yen has no cents

Currency eur = Currency.getInstance(Locale.GERMANY);
System.out.println(eur.getCurrencyCode());                  // EUR

// Get all currencies
Set<Currency> allCurrencies = Currency.getAvailableCurrencies();
allCurrencies.stream()
    .sorted(Comparator.comparing(Currency::getCurrencyCode))
    .limit(10)
    .forEach(c -> System.out.printf("%-4s %s%n", c.getCurrencyCode(), c.getDisplayName()));
```

### 11.2 `TimeZone` and Locale in Dates

When formatting `ZonedDateTime`, the locale controls the text (day/month names) while the timezone controls the actual time value:

```java
ZonedDateTime now = ZonedDateTime.now(ZoneId.of("America/New_York"));

DateTimeFormatter fmt = DateTimeFormatter
    .ofPattern("EEEE, MMMM d, yyyy 'at' h:mm a z")
    .withLocale(Locale.US)
    .withZone(ZoneId.of("America/New_York"));

System.out.println(now.format(fmt));
// Monday, January 15, 2024 at 2:30 PM EST

// Same instant, different timezone and locale
DateTimeFormatter fmtFR = DateTimeFormatter
    .ofPattern("EEEE d MMMM yyyy 'à' HH'h'mm z")
    .withLocale(Locale.FRANCE)
    .withZone(ZoneId.of("Europe/Paris"));

System.out.println(now.withZoneSameInstant(ZoneId.of("Europe/Paris")).format(fmtFR));
// lundi 15 janvier 2024 à 20h30 CET
```

### 11.3 `BreakIterator` — Locale-Aware Text Segmentation

`BreakIterator` knows where to break text for word, sentence, line, or character boundaries — correctly even for languages without spaces between words (Thai, Japanese, Chinese):

```java
import java.text.BreakIterator;

// Word boundaries
String text = "Hello, World! How are you?";
BreakIterator wb = BreakIterator.getWordInstance(Locale.US);
wb.setText(text);

int start = wb.first();
for (int end = wb.next(); end != BreakIterator.DONE; start = end, end = wb.next()) {
    String word = text.substring(start, end);
    if (!word.isBlank() && Character.isLetterOrDigit(word.charAt(0))) {
        System.out.println("Word: [" + word + "]");
    }
}
// Word: [Hello]
// Word: [World]
// Word: [How]
// Word: [are]
// Word: [you]

// Character boundaries for Thai (which doesn't use spaces)
String thai = "สวัสดีครับ"; // "Hello" in Thai
BreakIterator cb = BreakIterator.getCharacterInstance(new Locale("th", "TH"));
cb.setText(thai);
start = cb.first();
for (int end = cb.next(); end != BreakIterator.DONE; start = end, end = cb.next()) {
    System.out.println("Grapheme: " + thai.substring(start, end));
}
```

### 11.4 `Bidi` — Bidirectional Text

For mixed RTL/LTR text (e.g., Arabic document with English product names):

```java
import java.text.Bidi;

String mixed = "مرحبا Hello مرحبا";
Bidi bidi = new Bidi(mixed, Bidi.DIRECTION_DEFAULT_LEFT_TO_RIGHT);
System.out.println("Is LTR:   " + bidi.isLeftToRight()); // false (mixed)
System.out.println("Is RTL:   " + bidi.isRightToLeft()); // false (mixed)
System.out.println("Is mixed: " + bidi.isMixed());        // true

// Get visual reordering for display
byte[] levels = new byte[mixed.length()];
Bidi.reorderVisually(bidi.getLevels(), 0, levels, 0, levels.length);
```

### 11.5 Locale Detection from Accept-Language Header (Web Apps)

```java
// Parse HTTP Accept-Language header: "fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5"
public Locale detectLocale(String acceptLanguageHeader) {
    if (acceptLanguageHeader == null || acceptLanguageHeader.isBlank()) {
        return Locale.getDefault();
    }

    // Java 8+ — Locale.LanguageRange.parse handles q-values and sorting
    List<Locale.LanguageRange> ranges = Locale.LanguageRange.parse(acceptLanguageHeader);

    // Find the best match from supported locales
    List<Locale> supported = List.of(
        Locale.US, Locale.UK, Locale.FRANCE, Locale.GERMANY, Locale.JAPAN
    );

    Locale best = Locale.lookup(ranges, supported);
    return (best != null) ? best : Locale.US; // default fallback
}

// Usage
Locale userLocale = detectLocale("fr-CH, fr;q=0.9, en;q=0.8");
System.out.println(userLocale); // fr_FR (best match from supported list)
```

### 11.6 `Locale.LanguageRange` and Filtering

```java
// Filter — return all locales from the list that match any range
List<Locale.LanguageRange> ranges = Locale.LanguageRange.parse("de, *;q=0.5");
List<Locale> supported = List.of(Locale.GERMANY, Locale.US, Locale.FRANCE);
List<Locale> matched = Locale.filter(ranges, supported);
System.out.println(matched); // [de_DE, en_US, fr_FR] — de first, then any

// Lookup — return the single best matching locale
Locale best = Locale.lookup(ranges, supported);
System.out.println(best); // de_DE
```

### 11.17 `DateFormatSymbols` — Custom Date/Time Names

```java
import java.text.DateFormatSymbols;

DateFormatSymbols symbols = new DateFormatSymbols(Locale.FRANCE);
System.out.println(Arrays.toString(symbols.getMonths()));
// [janvier, février, mars, avril, mai, juin, juillet, août, septembre, octobre, novembre, décembre, ]

System.out.println(Arrays.toString(symbols.getShortWeekdays()));
// [ , dim., lun., mar., mer., jeu., ven., sam.]
// Note: index 0 is empty — weekdays are 1-indexed (Calendar.SUNDAY=1)
```

---

## 12. Quick Reference Cheat Sheet

### Locale Creation

```java
Locale.US                                   // en_US (constant)
Locale.FRANCE                               // fr_FR (constant)
new Locale("pt", "BR")                      // pt_BR (legacy constructor)
Locale.forLanguageTag("zh-Hans-CN")         // zh_CN (BCP 47 tag)
new Locale.Builder().setLanguage("de").setRegion("AT").build() // de_AT
Locale.getDefault()                         // JVM default locale
Locale.setDefault(Locale.US)               // change JVM default (global!)
locale.getLanguage()                        // "en"
locale.getCountry()                         // "US"
locale.toLanguageTag()                      // "en-US"
locale.getDisplayName(Locale.ENGLISH)       // "English (United States)"
```

### ResourceBundle

```java
ResourceBundle b = ResourceBundle.getBundle("messages", locale);
b.getString("key")                          // get a string value
b.containsKey("key")                        // check before getting
b.keySet()                                  // all keys (Java 8+)
ResourceBundle.clearCache()                 // clear cached bundles
// Lookup chain: lang_COUNTRY → lang → default_COUNTRY → default → base → exception
```

### MessageFormat

```java
MessageFormat.format("Hello {0}, you have {1} msgs", name, count) // static
new MessageFormat("Hello {0}", locale).format(new Object[]{name}) // locale-aware
// Types: {0,number,currency} {0,date,full} {0,time,short} {0,choice,...}
// Escape: '' for literal quote, '{' for literal brace
```

### NumberFormat

```java
NumberFormat.getInstance(locale).format(number)          // 1,234.56 or 1.234,56
NumberFormat.getCurrencyInstance(locale).format(amount)  // $1,234.56 or 1.234,56 €
NumberFormat.getPercentInstance(locale).format(0.75)     // 75%
NumberFormat.getIntegerInstance(locale).format(number)   // 1,235
NumberFormat.getCompactNumberInstance(locale, Style.SHORT).format(1_000) // 1K (Java 12+)
nf.setMinimumFractionDigits(2)
nf.setMaximumFractionDigits(4)
nf.setGroupingUsed(false)
nf.parse("1,234.56")                                     // → Number
```

### DecimalFormat

```java
new DecimalFormat("#,##0.00").format(1234.5)             // 1,234.50
new DecimalFormat("0.000").format(3.14)                  // 3.140
new DecimalFormat("0.##E0").format(123456)               // 1.23E5
new DecimalFormat("#,##0.00", new DecimalFormatSymbols(Locale.GERMANY)).format(1234.5) // 1.234,50
// Symbols: 0=required digit, #=optional digit, .=decimal sep, ,=grouping sep
```

### DateTimeFormatter with Locale

```java
DateTimeFormatter.ofLocalizedDate(FormatStyle.FULL).withLocale(locale)
DateTimeFormatter.ofLocalizedTime(FormatStyle.SHORT).withLocale(locale)
DateTimeFormatter.ofLocalizedDateTime(FormatStyle.LONG, FormatStyle.SHORT).withLocale(locale)
DateTimeFormatter.ofPattern("d MMMM yyyy").withLocale(locale)
// Styles: SHORT, MEDIUM, LONG, FULL
// .withChronology(JapaneseChronology.INSTANCE) for non-ISO calendars
```

### Collator

```java
Collator col = Collator.getInstance(locale)
col.compare("a", "b")                       // -1, 0, or 1
col.setStrength(Collator.PRIMARY)           // ignore accents+case
col.setStrength(Collator.SECONDARY)         // ignore case
col.setStrength(Collator.TERTIARY)          // default — accent+case sensitive
list.sort(col)                              // locale-correct sort
col.getCollationKey(str)                    // for efficient repeated comparisons
```

### Unicode / Character

```java
Character.isLetter(codePoint)              // ✅ use int codePoint, not char
Character.isDigit(codePoint)
Character.isWhitespace(codePoint)
Character.isUpperCase(codePoint)
Character.toCodePoint(highSurrogate, lowSurrogate)
Character.toChars(codePoint)               // char[1] for BMP, char[2] for supplementary
Character.charCount(codePoint)             // 1 or 2
Character.isHighSurrogate(c)
Character.isLowSurrogate(c)
str.codePoints()                           // ✅ IntStream of code points — handles surrogates
str.codePointAt(index)                     // code point at index
str.codePointCount(0, str.length())        // true character count
str.toUpperCase(Locale.ROOT)               // locale-neutral case conversion
Normalizer.normalize(str, Form.NFC)        // canonical composition
```

### Key Rules to Remember

1. **Always pass `Locale` explicitly** to format/parse methods — never rely on the default.
2. **Pre-compile `MessageFormat`** instances when reusing (costly to construct).
3. **Use `Collator`, not `String.compareTo()`** for locale-sensitive sorting.
4. **Use `String.codePoints()`, not `charAt()`** when iterating over Unicode text.
5. **`String.length()` ≠ character count** for strings with emoji or supplementary chars.
6. **Use `toUpperCase(Locale.ROOT)`** for internal (non-display) transformations.
7. **Java 9+ `.properties` files** are UTF-8 — no `\u` escapes needed.
8. **ResourceBundle caches** — call `clearCache()` only if you hot-reload resources.
9. **Externalizing strings ≠ just translating** — sentence structure and word order change too.
10. **Never hard-code strings** that end users see — period.

---

*End of Java Internationalization (i18n) Study Guide — Module 14*
