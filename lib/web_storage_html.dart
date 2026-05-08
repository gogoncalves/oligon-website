// Web-only storage adapter (dart:html).
import 'dart:html' as html;

String? readLang() => html.window.localStorage['oligon-lang'];
void writeLang(String lang) {
  html.window.localStorage['oligon-lang'] = lang;
  html.document.documentElement?.setAttribute('lang', lang == 'pt' ? 'pt-BR' : 'en');
}

String navigatorLanguage() => html.window.navigator.language ?? 'pt';
