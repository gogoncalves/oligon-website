// Oligon Technology · landing em Flutter Web.
// Single-file pra simplicidade. Dogfood: vendemos Flutter, usamos Flutter.

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// dart:html só funciona em web; isolado em arquivo separado pra não quebrar
// análise em outras plataformas.
import 'web_storage_stub.dart' if (dart.library.html) 'web_storage_html.dart' as storage;

import 'theme.dart';
import 'i18n.dart';

void main() {
  runApp(const OligonApp());
}

// ────────────────────────────────────────────────────────────────────────────
// App + state
// ────────────────────────────────────────────────────────────────────────────

class OligonApp extends StatefulWidget {
  const OligonApp({super.key});

  @override
  State<OligonApp> createState() => _OligonAppState();
}

class _OligonAppState extends State<OligonApp> {
  Locale _locale = _detectInitialLocale();

  static Locale _detectInitialLocale() {
    // 1) Preferência salva no localStorage
    final stored = storage.readLang();
    if (stored != null && I18n.supported.contains(stored)) {
      return Locale(stored);
    }
    // 2) Idioma do navegador (primeiros 2 chars: pt-BR → pt, en-US → en, etc)
    final nav = storage.navigatorLanguage().toLowerCase();
    final code = nav.length >= 2 ? nav.substring(0, 2) : '';
    if (I18n.supported.contains(code)) return Locale(code);
    // 3) Fallback inglês (audiência internacional default), pt em última se nada bater
    return const Locale('en');
  }

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
    storage.writeLang(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final dict = I18n.dict[_locale.languageCode] ?? I18n.dict['pt']!;
    return MaterialApp(
      title: dict['meta.title']!,
      debugShowCheckedModeBanner: false,
      theme: oligonTheme(),
      home: LandingPage(
        dict: dict,
        currentLocale: _locale,
        onLocaleChange: _setLocale,
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Landing page
// ────────────────────────────────────────────────────────────────────────────

class LandingPage extends StatefulWidget {
  final Map<String, String> dict;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChange;

  const LandingPage({
    super.key,
    required this.dict,
    required this.currentLocale,
    required this.onLocaleChange,
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _scrollCtrl = ScrollController();
  final _servicesKey = GlobalKey();
  final _productsKey = GlobalKey();
  final _processKey = GlobalKey();
  final _contactKey = GlobalKey();

  bool _scrolled = false;
  bool _showPrivacy = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final shouldBe = _scrollCtrl.offset > 12;
      if (shouldBe != _scrolled) setState(() => _scrolled = shouldBe);
    });
    if (!storage.readPrivacyAck()) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => _showPrivacy = true);
      });
    }
  }

  void _ackPrivacy() {
    storage.writePrivacyAck();
    setState(() => _showPrivacy = false);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const Positioned.fill(child: AmbientBackground()),
          Positioned.fill(
            child: CustomScrollView(
              controller: _scrollCtrl,
              slivers: [
                SliverToBoxAdapter(
                  child: _FadeIn(
                    delay: const Duration(milliseconds: 50),
                    child: HeroSection(
                      dict: widget.dict,
                      onScrollToContact: () => _scrollTo(_contactKey),
                      onScrollToServices: () => _scrollTo(_servicesKey),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _FadeIn(
                    delay: const Duration(milliseconds: 200),
                    child: KeyedSubtree(key: _servicesKey, child: ServicesSection(dict: widget.dict)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _FadeIn(
                    delay: const Duration(milliseconds: 275),
                    child: KeyedSubtree(key: _productsKey, child: ProductsSection(dict: widget.dict)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _FadeIn(
                    delay: const Duration(milliseconds: 350),
                    child: KeyedSubtree(key: _processKey, child: ProcessSection(dict: widget.dict)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _FadeIn(
                    delay: const Duration(milliseconds: 500),
                    child: KeyedSubtree(key: _contactKey, child: ContactSection(dict: widget.dict)),
                  ),
                ),
                SliverToBoxAdapter(child: FooterSection(
                  dict: widget.dict,
                  onNav: (which) {
                    if (which == 'top') {
                      _scrollCtrl.animateTo(0,
                          duration: const Duration(milliseconds: 700), curve: Curves.easeOutQuart);
                      return;
                    }
                    final keys = {
                      'services': _servicesKey,
                      'products': _productsKey,
                      'process': _processKey,
                      'contact': _contactKey,
                    };
                    final k = keys[which];
                    if (k != null) _scrollTo(k);
                  },
                )),
              ],
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: HeaderBar(
              scrolled: _scrolled,
              isMobile: isMobile,
              dict: widget.dict,
              currentLocale: widget.currentLocale,
              onLocaleChange: widget.onLocaleChange,
              onNav: (which) {
                final keys = {
                  'services': _servicesKey,
                  'products': _productsKey,
                  'process': _processKey,
                  'contact': _contactKey,
                };
                _scrollTo(keys[which]!);
              },
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: _PrivacyBanner(
              visible: _showPrivacy,
              dict: widget.dict,
              onOk: _ackPrivacy,
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Background ambient
// ────────────────────────────────────────────────────────────────────────────

class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(top: -150, left: -200, child: _Blob(size: 600, color: AppColors.accent.withValues(alpha: 0.08))),
          Positioned(top: 400, right: -150, child: _Blob(size: 500, color: AppColors.accent2.withValues(alpha: 0.08))),
          Positioned(bottom: 200, left: 300, child: _Blob(size: 400, color: AppColors.accent.withValues(alpha: 0.05))),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Header
// ────────────────────────────────────────────────────────────────────────────

class HeaderBar extends StatefulWidget {
  final bool scrolled;
  final bool isMobile;
  final Map<String, String> dict;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChange;
  final ValueChanged<String> onNav;

  const HeaderBar({
    super.key,
    required this.scrolled,
    required this.isMobile,
    required this.dict,
    required this.currentLocale,
    required this.onLocaleChange,
    required this.onNav,
  });

  @override
  State<HeaderBar> createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.dict;
    return ClipRect(
      child: BackdropFilter(
        filter: widget.scrolled
            ? ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18)
            : ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.scrolled
                ? AppColors.bg.withValues(alpha: 0.72)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: widget.scrolled ? AppColors.border : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                children: [
                  const _Brand(),
                  const Spacer(),
                  if (!widget.isMobile) ...[
                    _NavLink(d['nav.services']!, onTap: () => widget.onNav('services')),
                    const SizedBox(width: 28),
                    _NavLink(d['nav.products']!, onTap: () => widget.onNav('products')),
                    const SizedBox(width: 28),
                    _NavLink(d['nav.process']!, onTap: () => widget.onNav('process')),
                    const SizedBox(width: 28),
                    _NavLink(d['nav.contact']!, onTap: () => widget.onNav('contact')),
                    const SizedBox(width: 28),
                  ],
                  LangSwitcher(
                    current: widget.currentLocale.languageCode,
                    onChange: (l) => widget.onLocaleChange(Locale(l)),
                  ),
                  if (!widget.isMobile) ...[
                    const SizedBox(width: 14),
                    _SmallBtn(d['nav.cta']!, onTap: () => widget.onNav('contact')),
                  ] else ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(_menuOpen ? Icons.close : Icons.menu, color: AppColors.text),
                      onPressed: () => setState(() => _menuOpen = !_menuOpen),
                    ),
                  ],
                ],
              ),
            ),
          ),
              if (widget.isMobile && _menuOpen)
                Container(
                  width: double.infinity,
                  color: AppColors.bg2,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _NavLink(d['nav.services']!, onTap: () { setState(() => _menuOpen = false); widget.onNav('services'); }),
                      const SizedBox(height: 18),
                      _NavLink(d['nav.products']!, onTap: () { setState(() => _menuOpen = false); widget.onNav('products'); }),
                      const SizedBox(height: 18),
                      _NavLink(d['nav.process']!, onTap: () { setState(() => _menuOpen = false); widget.onNav('process'); }),
                      const SizedBox(height: 18),
                      _NavLink(d['nav.contact']!, onTap: () { setState(() => _menuOpen = false); widget.onNav('contact'); }),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        label: d['nav.cta']!,
                        onTap: () { setState(() => _menuOpen = false); widget.onNav('contact'); },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShaderMask(
          shaderCallback: (rect) => AppColors.gradient.createShader(rect),
          child: Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            style: AppText.h6.copyWith(letterSpacing: -0.5, color: AppColors.text, fontWeight: FontWeight.w800),
            children: [
              const TextSpan(text: 'Oligon'),
              TextSpan(text: '.tech', style: TextStyle(color: AppColors.text2, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink(this.label, {required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppText.label.copyWith(color: _hover ? AppColors.text : AppColors.text2),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _SmallBtn extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _SmallBtn(this.label, {required this.onTap});

  @override
  State<_SmallBtn> createState() => _SmallBtnState();
}

class _SmallBtnState extends State<_SmallBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.bg3,
            border: Border.all(color: _hover ? AppColors.accent : AppColors.border2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.label,
            style: AppText.label.copyWith(color: _hover ? AppColors.accent : AppColors.text, fontSize: 13),
          ),
        ),
      ),
    );
  }
}

class LangSwitcher extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChange;
  const LangSwitcher({super.key, required this.current, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg3,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: I18n.supported.map((lang) {
          final active = current == lang;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onChange(lang),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: active ? AppColors.bg : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  lang.toUpperCase(),
                  style: AppText.mono.copyWith(
                    fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.6,
                    color: active ? AppColors.accent : AppColors.text3,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Container
// ────────────────────────────────────────────────────────────────────────────

class _Container extends StatelessWidget {
  final Widget child;
  const _Container({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: child,
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// HERO
// ────────────────────────────────────────────────────────────────────────────

class HeroSection extends StatelessWidget {
  final Map<String, String> dict;
  final VoidCallback onScrollToContact;
  final VoidCallback onScrollToServices;

  const HeroSection({
    super.key,
    required this.dict,
    required this.onScrollToContact,
    required this.onScrollToServices,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final titleFontSize = (width * 0.07).clamp(40.0, 88.0);
    final manifestoFontSize = (width * 0.025).clamp(20.0, 28.0);

    return _Container(
      child: Padding(
        padding: EdgeInsets.only(top: isMobile ? 100 : 160, bottom: isMobile ? 60 : 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GradientTitle(parts: _parseTitle(dict['hero.title.line1']!), fontSize: titleFontSize),
            const SizedBox(height: 4),
            _GradientTitle(parts: _parseTitle(dict['hero.title.line2']!), fontSize: titleFontSize),
            const SizedBox(height: 4),
            _GradientTitle(parts: _parseTitle(dict['hero.title.line3']!), fontSize: titleFontSize),
            const SizedBox(height: 32),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                dict['hero.lead']!,
                style: AppText.body.copyWith(
                  fontSize: isMobile ? 16 : 19, color: AppColors.text2, height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 44),
            Wrap(
              spacing: 12, runSpacing: 12,
              children: [
                PrimaryButton(label: dict['hero.ctaPrimary']!, onTap: onScrollToContact),
                GhostButton(label: dict['hero.ctaSecondary']!, onTap: onScrollToServices),
              ],
            ),
            const SizedBox(height: 72),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: _Manifesto(
                line1: dict['manifesto.line1']!,
                line2: dict['manifesto.line2']!,
                highlight: dict['manifesto.line2.hl']!,
                fontSize: manifestoFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_TitlePart> _parseTitle(String s) {
    final parts = <_TitlePart>[];
    final regex = RegExp(r'<grad>(.*?)</grad>');
    int last = 0;
    for (final m in regex.allMatches(s)) {
      if (m.start > last) parts.add(_TitlePart(s.substring(last, m.start), false));
      parts.add(_TitlePart(m.group(1)!, true));
      last = m.end;
    }
    if (last < s.length) parts.add(_TitlePart(s.substring(last), false));
    return parts;
  }
}

class _TitlePart {
  final String text;
  final bool gradient;
  _TitlePart(this.text, this.gradient);
}

class _GradientTitle extends StatelessWidget {
  final List<_TitlePart> parts;
  final double fontSize;
  const _GradientTitle({required this.parts, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    final style = AppText.h1.copyWith(fontSize: fontSize, color: AppColors.text);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: parts.map((p) {
        if (p.gradient) {
          return ShaderMask(
            shaderCallback: (rect) => AppColors.gradient.createShader(rect),
            child: Text(p.text, style: style.copyWith(color: Colors.white)),
          );
        }
        return Text(p.text, style: style);
      }).toList(),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// MANIFESTO (rendered inside hero)
// ────────────────────────────────────────────────────────────────────────────

class _Manifesto extends StatelessWidget {
  final String line1;
  final String line2;
  final String highlight;
  final double fontSize;

  const _Manifesto({required this.line1, required this.line2, required this.highlight, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    final base = AppText.h2.copyWith(fontSize: fontSize, color: AppColors.text, height: 1.25);
    final muted = base.copyWith(color: AppColors.text3);

    final hlIdx = line2.indexOf(highlight);
    final before = hlIdx >= 0 ? line2.substring(0, hlIdx) : line2;
    final after = hlIdx >= 0 ? line2.substring(hlIdx + highlight.length) : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(text: TextSpan(children: _parseMuted(line1, base, muted))),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(children: [
            if (before.isNotEmpty) TextSpan(text: before, style: base),
            if (hlIdx >= 0)
              WidgetSpan(
                child: ShaderMask(
                  shaderCallback: (rect) => AppColors.gradient.createShader(rect),
                  child: Text(highlight, style: base.copyWith(color: Colors.white)),
                ),
              ),
            if (after.isNotEmpty) TextSpan(text: after, style: base),
          ]),
        ),
      ],
    );
  }

  List<InlineSpan> _parseMuted(String s, TextStyle base, TextStyle muted) {
    final regex = RegExp(r'<m>(.*?)</m>');
    final spans = <InlineSpan>[];
    int last = 0;
    for (final m in regex.allMatches(s)) {
      if (m.start > last) spans.add(TextSpan(text: s.substring(last, m.start), style: base));
      spans.add(TextSpan(text: m.group(1)!, style: muted));
      last = m.end;
    }
    if (last < s.length) spans.add(TextSpan(text: s.substring(last), style: base));
    return spans;
  }
}

// ────────────────────────────────────────────────────────────────────────────
// SECTION HEAD (helper)
// ────────────────────────────────────────────────────────────────────────────

class SectionHead extends StatelessWidget {
  final String kicker;
  final String? title;
  final String? titleHtml;
  final String? sub;

  const SectionHead({super.key, required this.kicker, this.title, this.titleHtml, this.sub});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = (width * 0.04).clamp(28.0, 48.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(kicker.toUpperCase(),
            style: AppText.mono.copyWith(color: AppColors.accent, fontSize: 12, letterSpacing: 1.5)),
        const SizedBox(height: 16),
        if (titleHtml != null)
          _GradientTitle(parts: _parseGrad(titleHtml!), fontSize: fontSize)
        else
          Text(title!, style: AppText.h2.copyWith(color: AppColors.text, fontSize: fontSize, height: 1.1)),
        if (sub != null) ...[
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(sub!, style: AppText.body.copyWith(color: AppColors.text2, fontSize: 17)),
          ),
        ],
      ],
    );
  }

  List<_TitlePart> _parseGrad(String s) {
    final parts = <_TitlePart>[];
    final regex = RegExp(r'<grad>(.*?)</grad>');
    int last = 0;
    for (final m in regex.allMatches(s)) {
      if (m.start > last) parts.add(_TitlePart(s.substring(last, m.start), false));
      parts.add(_TitlePart(m.group(1)!, true));
      last = m.end;
    }
    if (last < s.length) parts.add(_TitlePart(s.substring(last), false));
    return parts;
  }
}

// ────────────────────────────────────────────────────────────────────────────
// SERVICES
// ────────────────────────────────────────────────────────────────────────────

class ServicesSection extends StatelessWidget {
  final Map<String, String> dict;
  const ServicesSection({super.key, required this.dict});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = width < 700 ? 1 : 2;

    final services = [
      ('01', dict['svc1.title']!, dict['svc1.desc']!),
      ('02', dict['svc2.title']!, dict['svc2.desc']!),
      ('03', dict['svc3.title']!, dict['svc3.desc']!),
      ('04', dict['svc4.title']!, dict['svc4.desc']!),
    ];

    return _Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHead(kicker: dict['services.kicker']!, title: dict['services.title']!),
            const SizedBox(height: 64),
            LayoutBuilder(
              builder: (context, c) {
                final colW = (c.maxWidth - (cols - 1) * 24) / cols;
                return Wrap(
                  spacing: 24, runSpacing: 24,
                  children: services.map((s) => SizedBox(
                    width: colW,
                    child: _ServiceCard(num: s.$1, title: s.$2, desc: s.$3),
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final String num, title, desc;
  const _ServiceCard({required this.num, required this.title, required this.desc});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _hover ? AppColors.bg3 : AppColors.bg2,
          border: Border.all(color: _hover ? AppColors.border2 : AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        transform: Matrix4.identity()..translate(0.0, _hover ? -4.0 : 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.num, style: AppText.mono.copyWith(color: AppColors.accent, fontSize: 12, letterSpacing: 1.2)),
            const SizedBox(height: 20),
            Text(widget.title, style: AppText.h4.copyWith(color: AppColors.text)),
            const SizedBox(height: 12),
            Text(widget.desc, style: AppText.body.copyWith(color: AppColors.text2, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// PRODUCTS — software we build AND sell directly (SaaS).
// Shown to Stripe's reviewer as proof that Oligon Technology has products for
// recurring billing, not just consulting. Update when a second product launches.
// ────────────────────────────────────────────────────────────────────────────

class ProductsSection extends StatelessWidget {
  final Map<String, String> dict;
  const ProductsSection({super.key, required this.dict});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final twoCols = width >= 800;

    return _Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHead(kicker: dict['products.kicker']!, title: dict['products.title']!),
            const SizedBox(height: 64),
            LayoutBuilder(
              builder: (context, c) {
                final colW = twoCols ? (c.maxWidth - 24) / 2 : c.maxWidth;
                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    SizedBox(
                      width: colW,
                      child: _ProductCard(
                        title: dict['products.attendari.title']!,
                        tag: dict['products.attendari.tag']!,
                        desc: dict['products.attendari.desc']!,
                        status: dict['products.attendari.status']!,
                        cta: dict['products.attendari.cta']!,
                        url: 'https://attendari.com',
                      ),
                    ),
                    SizedBox(
                      width: colW,
                      child: _ProductPlaceholder(
                        title: dict['products.soon.title']!,
                        desc: dict['products.soon.desc']!,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final String title;
  final String tag;
  final String desc;
  final String status;
  final String cta;
  final String url;
  const _ProductCard({
    required this.title,
    required this.tag,
    required this.desc,
    required this.status,
    required this.cta,
    required this.url,
  });
  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.bg2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hover ? AppColors.accent.withValues(alpha: 0.6) : AppColors.border,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.status,
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.tag,
                    style: const TextStyle(
                      color: AppColors.text2,
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                widget.title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.desc,
                style: const TextStyle(
                  color: AppColors.text2,
                  fontSize: 14.5,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.cta,
                style: TextStyle(
                  color: _hover ? AppColors.accent : AppColors.text,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductPlaceholder extends StatelessWidget {
  final String title;
  final String desc;
  const _ProductPlaceholder({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bg2.withValues(alpha: 0.4),
            AppColors.bg.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.text2.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'WIP',
              style: TextStyle(
                color: AppColors.text2,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: TextStyle(
              color: AppColors.text.withValues(alpha: 0.6),
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            desc,
            style: const TextStyle(
              color: AppColors.text2,
              fontSize: 14,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// PROCESS
// ────────────────────────────────────────────────────────────────────────────

class ProcessSection extends StatelessWidget {
  final Map<String, String> dict;
  const ProcessSection({super.key, required this.dict});

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('01', dict['process.s1.title']!, dict['process.s1.desc']!, dict['process.s1.time']!),
      ('02', dict['process.s2.title']!, dict['process.s2.desc']!, dict['process.s2.time']!),
      ('03', dict['process.s3.title']!, dict['process.s3.desc']!, dict['process.s3.time']!),
      ('04', dict['process.s4.title']!, dict['process.s4.desc']!, dict['process.s4.time']!),
    ];

    return _Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHead(kicker: dict['process.kicker']!, titleHtml: dict['process.title']!),
            const SizedBox(height: 64),
            for (int i = 0; i < steps.length; i++)
              _TimelineStep(
                num: steps[i].$1,
                title: steps[i].$2,
                desc: steps[i].$3,
                time: steps[i].$4,
                isLast: i == steps.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String num, title, desc, time;
  final bool isLast;
  const _TimelineStep({required this.num, required this.title, required this.desc, required this.time, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final circleSize = isMobile ? 40.0 : 56.0;
    final gap = isMobile ? 14.0 : 24.0;
    final cardPad = isMobile ? 18.0 : 28.0;
    final bottomGap = isLast ? 0.0 : (isMobile ? 20.0 : 32.0);
    final titleStyle = AppText.h4.copyWith(
      color: AppColors.text,
      fontSize: isMobile ? 17 : 20,
    );

    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accentGlow,
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(time, style: AppText.mono.copyWith(color: AppColors.accent, fontSize: 11)),
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: circleSize, height: circleSize,
                decoration: const BoxDecoration(gradient: AppColors.gradient, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  num,
                  style: AppText.h6.copyWith(
                    color: AppColors.bg,
                    fontWeight: FontWeight.w800,
                    fontSize: isMobile ? 14 : 18,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [AppColors.accent2.withValues(alpha: 0.4), AppColors.border],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: gap),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomGap),
              child: Container(
                padding: EdgeInsets.all(cardPad),
                decoration: BoxDecoration(
                  color: AppColors.bg2,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isMobile) ...[
                      Align(alignment: Alignment.centerLeft, child: pill),
                      const SizedBox(height: 10),
                      Text(title, style: titleStyle),
                    ] else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Text(title, style: titleStyle)),
                          const SizedBox(width: 12),
                          pill,
                        ],
                      ),
                    const SizedBox(height: 10),
                    Text(
                      desc,
                      style: AppText.body.copyWith(
                        color: AppColors.text2,
                        fontSize: isMobile ? 14.5 : 16,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// CONTACT
// ────────────────────────────────────────────────────────────────────────────

class ContactSection extends StatefulWidget {
  final Map<String, String> dict;
  const ContactSection({super.key, required this.dict});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _company = TextEditingController();
  final _message = TextEditingController();
  String _msg = '';
  Color _msgColor = AppColors.accent;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _company.dispose();
    _message.dispose();
    super.dispose();
  }

  static final _emailRe = RegExp(r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$');

  void _submit() {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final message = _message.text.trim();
    if (name.isEmpty || email.isEmpty || message.isEmpty || !_emailRe.hasMatch(email)) {
      setState(() {
        _msg = widget.dict['form.error']!;
        _msgColor = const Color(0xFFFFB200);
      });
      return;
    }
    final subject = '[Oligon] ${_name.text}${_company.text.isNotEmpty ? " · ${_company.text}" : ""}';
    final body = 'Name: ${_name.text}\nEmail: ${_email.text}'
        '${_company.text.isNotEmpty ? "\nCompany: ${_company.text}" : ""}'
        '\n\nMessage:\n${_message.text}';
    final uri = Uri(
      scheme: 'mailto', path: 'contact@oligontech.com',
      queryParameters: {'subject': subject, 'body': body},
    );
    launchUrl(uri);
    setState(() {
      _msg = widget.dict['form.opening']!;
      _msgColor = AppColors.accent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return _Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 32 : 56),
              decoration: BoxDecoration(
                color: AppColors.bg2,
                border: Border.all(color: AppColors.border2),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: AppColors.accent.withValues(alpha: 0.08), blurRadius: 60, spreadRadius: 4),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.dict['cta.title']!,
                      style: AppText.h2.copyWith(color: AppColors.text, fontSize: isMobile ? 28 : 40),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Text(widget.dict['cta.desc']!,
                      style: AppText.body.copyWith(color: AppColors.text2),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  if (isMobile) ...[
                    _Input(controller: _name, hint: widget.dict['cta.namePlaceholder']!),
                    const SizedBox(height: 12),
                    _Input(controller: _email, hint: widget.dict['cta.emailPlaceholder']!, type: TextInputType.emailAddress),
                  ] else
                    Row(children: [
                      Expanded(child: _Input(controller: _name, hint: widget.dict['cta.namePlaceholder']!)),
                      const SizedBox(width: 12),
                      Expanded(child: _Input(controller: _email, hint: widget.dict['cta.emailPlaceholder']!, type: TextInputType.emailAddress)),
                    ]),
                  const SizedBox(height: 12),
                  _Input(controller: _company, hint: widget.dict['cta.companyPlaceholder']!),
                  const SizedBox(height: 12),
                  _Input(controller: _message, hint: widget.dict['cta.messagePlaceholder']!, maxLines: 4),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(label: widget.dict['cta.submit']!, onTap: _submit),
                  ),
                  if (_msg.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(_msg, style: AppText.mono.copyWith(color: _msgColor, fontSize: 13)),
                  ],
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.only(top: 24),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('${widget.dict['cta.altPrefix']!} ',
                            style: AppText.body.copyWith(color: AppColors.text3, fontSize: 14)),
                        InkWell(
                          onTap: () => launchUrl(Uri.parse('mailto:contact@oligontech.com')),
                          child: Text('contact@oligontech.com',
                              style: AppText.mono.copyWith(color: AppColors.accent, fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? type;
  final int maxLines;

  const _Input({required this.controller, required this.hint, this.type, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      style: AppText.body.copyWith(color: AppColors.text),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppText.body.copyWith(color: AppColors.text3),
        filled: true,
        fillColor: AppColors.bg3,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// FOOTER
// ────────────────────────────────────────────────────────────────────────────

class FooterSection extends StatelessWidget {
  final Map<String, String> dict;
  final ValueChanged<String> onNav;
  const FooterSection({super.key, required this.dict, required this.onNav});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: _Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _cols(dict).map((c) => Padding(padding: const EdgeInsets.only(bottom: 24), child: c)).toList(),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _cols(dict)
                      .expand((c) => [Expanded(child: c), const SizedBox(width: 32)])
                      .toList()
                    ..removeLast(),
                ),
        ),
      ),
    );
  }

  List<Widget> _cols(Map<String, String> d) => [
        // Coluna 1: brand · clicável (volta ao topo)
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onNav('top'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Brand(),
                const SizedBox(height: 12),
                Text(d['footer.tag']!, style: AppText.body.copyWith(color: AppColors.text3, fontSize: 14)),
              ],
            ),
          ),
        ),
        // Coluna 2: links de navegação · todos clicáveis
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FooterLink(d['nav.services']!, onTap: () => onNav('services')),
            const SizedBox(height: 8),
            _FooterLink(d['nav.process']!, onTap: () => onNav('process')),
            const SizedBox(height: 8),
            _FooterLink(d['nav.contact']!, onTap: () => onNav('contact')),
          ],
        ),
        // Coluna 3: contato
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FooterLink(
              'contact@oligontech.com',
              mono: true,
              accent: true,
              onTap: () => launchUrl(Uri.parse('mailto:contact@oligontech.com')),
            ),
            const SizedBox(height: 12),
            Text(d['footer.copy']!, style: AppText.body.copyWith(color: AppColors.text3, fontSize: 13)),
          ],
        ),
      ];
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool mono;
  final bool accent;
  const _FooterLink(this.label, {required this.onTap, this.mono = false, this.accent = false});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final base = widget.mono ? AppText.mono : AppText.body;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: base.copyWith(
            fontSize: 14,
            color: widget.accent
                ? AppColors.accent
                : (_hover ? AppColors.text : AppColors.text2),
            decoration: _hover && !widget.accent ? TextDecoration.underline : null,
            decorationColor: AppColors.text2,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Buttons (públicos pra reuso)
// ────────────────────────────────────────────────────────────────────────────

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const PrimaryButton({super.key, required this.label, required this.onTap});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: _hover
                ? [BoxShadow(color: AppColors.accent.withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 8))]
                : null,
          ),
          transform: Matrix4.identity()..translate(0.0, _hover ? -2.0 : 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.label, style: AppText.label.copyWith(color: AppColors.bg, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                transform: Matrix4.identity()..translate(_hover ? 4.0 : 0.0, 0.0),
                child: Text('→', style: AppText.label.copyWith(color: AppColors.bg, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GhostButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const GhostButton({super.key, required this.label, required this.onTap});

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: _hover ? AppColors.bg3 : Colors.transparent,
            border: Border.all(color: _hover ? AppColors.text3 : AppColors.border2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(widget.label, style: AppText.label.copyWith(color: AppColors.text, fontSize: 14)),
        ),
      ),
    );
  }
}


// ────────────────────────────────────────────────────────────────────────────
// Reveal-on-mount fade + slide
// ────────────────────────────────────────────────────────────────────────────

// ────────────────────────────────────────────────────────────────────────────
// Privacy banner (localStorage notice — sem cookies)
// ────────────────────────────────────────────────────────────────────────────

class _PrivacyBanner extends StatelessWidget {
  final bool visible;
  final Map<String, String> dict;
  final VoidCallback onOk;
  const _PrivacyBanner({required this.visible, required this.dict, required this.onOk});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 1),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 250),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 22, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.bg2.withValues(alpha: 0.82),
                        border: Border.all(color: AppColors.border2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  dict['privacy.text']!,
                                  style: AppText.body.copyWith(color: AppColors.text2, fontSize: 13.5, height: 1.45),
                                ),
                                const SizedBox(height: 12),
                                _SmallBtn(dict['privacy.ok']!, onTap: onOk),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dict['privacy.text']!,
                                    style: AppText.body.copyWith(color: AppColors.text2, fontSize: 14, height: 1.45),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                _SmallBtn(dict['privacy.ok']!, onTap: onOk),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FadeIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _FadeIn({required this.child, this.delay = Duration.zero});

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
