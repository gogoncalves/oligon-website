// Oligon Technology · landing em Flutter Web.
// Single-file pra simplicidade. Dogfood: vendemos Flutter, usamos Flutter.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final stored = storage.readLang();
    if (stored == 'pt' || stored == 'en') return Locale(stored!);
    final nav = storage.navigatorLanguage().toLowerCase();
    if (nav.startsWith('en')) return const Locale('en');
    return const Locale('pt');
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
  final _stackKey = GlobalKey();
  final _processKey = GlobalKey();
  final _contactKey = GlobalKey();

  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final shouldBe = _scrollCtrl.offset > 12;
      if (shouldBe != _scrolled) setState(() => _scrolled = shouldBe);
    });
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
                  child: HeroSection(
                    dict: widget.dict,
                    onScrollToContact: () => _scrollTo(_contactKey),
                    onScrollToServices: () => _scrollTo(_servicesKey),
                  ),
                ),
                SliverToBoxAdapter(child: ManifestoSection(dict: widget.dict)),
                SliverToBoxAdapter(
                  child: KeyedSubtree(key: _servicesKey, child: ServicesSection(dict: widget.dict)),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(key: _stackKey, child: StackSection(dict: widget.dict)),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(key: _processKey, child: ProcessSection(dict: widget.dict)),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(key: _contactKey, child: ContactSection(dict: widget.dict)),
                ),
                SliverToBoxAdapter(child: FooterSection(dict: widget.dict)),
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
                  'stack': _stackKey,
                  'process': _processKey,
                  'contact': _contactKey,
                };
                _scrollTo(keys[which]!);
              },
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
          Positioned(top: -150, left: -200, child: _Blob(size: 600, color: AppColors.accent.withOpacity(0.08))),
          Positioned(top: 400, right: -150, child: _Blob(size: 500, color: AppColors.accent2.withOpacity(0.08))),
          Positioned(bottom: 200, left: 300, child: _Blob(size: 400, color: AppColors.accent.withOpacity(0.05))),
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
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppColors.bg.withOpacity(0.85),
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
                    _NavLink(d['nav.stack']!, onTap: () => widget.onNav('stack')),
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
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _NavLink(d['nav.services']!, onTap: () { setState(() => _menuOpen = false); widget.onNav('services'); }),
                  const SizedBox(height: 16),
                  _NavLink(d['nav.stack']!, onTap: () { setState(() => _menuOpen = false); widget.onNav('stack'); }),
                  const SizedBox(height: 16),
                  _NavLink(d['nav.process']!, onTap: () { setState(() => _menuOpen = false); widget.onNav('process'); }),
                  const SizedBox(height: 16),
                  _NavLink(d['nav.contact']!, onTap: () { setState(() => _menuOpen = false); widget.onNav('contact'); }),
                ],
              ),
            ),
        ],
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
          child: const Icon(Icons.diamond_outlined, size: 22, color: Colors.white),
        ),
        const SizedBox(width: 8),
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
        children: ['pt', 'en'].map((lang) {
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
            const SizedBox(height: 80),
            const StackMarquee(),
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
// Marquee
// ────────────────────────────────────────────────────────────────────────────

class StackMarquee extends StatefulWidget {
  const StackMarquee({super.key});

  @override
  State<StackMarquee> createState() => _StackMarqueeState();
}

class _StackMarqueeState extends State<StackMarquee> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  static const _items = [
    'Flutter', 'iOS', 'Android', 'React', 'Next.js', 'Angular',
    'Java', 'Spring Boot', 'Kotlin', '.NET', 'Python', 'FastAPI',
    'Go', 'Rust', 'Elixir', 'Kafka', 'AWS', 'GCP', 'Azure',
    'Kubernetes', 'Terraform', 'Datadog', 'OpenAI', 'Anthropic',
    'Gemini', 'LangChain', 'MCP', 'Vector DB',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: 50,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return Transform.translate(
              offset: Offset(-_ctrl.value * _items.length * 120.0, 0),
              child: Row(children: [_buildRow(), _buildRow()]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow() {
    return Row(
      children: _items.expand((t) => [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(t, style: AppText.mono.copyWith(color: AppColors.text2, fontSize: 13)),
        ),
        Text('·', style: TextStyle(color: AppColors.text3)),
      ]).toList(),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// MANIFESTO
// ────────────────────────────────────────────────────────────────────────────

class ManifestoSection extends StatelessWidget {
  final Map<String, String> dict;
  const ManifestoSection({super.key, required this.dict});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = (width * 0.04).clamp(28.0, 48.0);

    return _Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: _Manifesto(
            line1: dict['manifesto.line1']!,
            line2: dict['manifesto.line2']!,
            highlight: dict['manifesto.line2.hl']!,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

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
    final cols = width < 700 ? 1 : (width < 1100 ? 2 : 3);

    final services = [
      ('01', dict['svc1.title']!, dict['svc1.desc']!, ['Web apps', 'APIs', 'Dashboards', 'Integrations']),
      ('02', dict['svc2.title']!, dict['svc2.desc']!, ['Flutter', 'iOS', 'Android', 'App Store']),
      ('03', dict['svc3.title']!, dict['svc3.desc']!, ['OpenAI', 'Anthropic', 'Gemini', 'RAG', 'Agents']),
      ('04', dict['svc4.title']!, dict['svc4.desc']!, ['AWS', 'GCP', 'K8s', 'Terraform', 'Datadog']),
      ('05', dict['svc5.title']!, dict['svc5.desc']!, ['Architecture', 'Audit', 'DD', 'Hiring']),
      ('06', dict['svc6.title']!, dict['svc6.desc']!, ['Retainer', 'SLA', 'Squad', 'Roadmap']),
    ];

    return _Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHead(kicker: dict['services.kicker']!, title: dict['services.title']!),
            const SizedBox(height: 64),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              crossAxisSpacing: 24, mainAxisSpacing: 24,
              childAspectRatio: cols == 1 ? 1.4 : 1.0,
              children: services.map((s) => _ServiceCard(num: s.$1, title: s.$2, desc: s.$3, tags: s.$4)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final String num, title, desc;
  final List<String> tags;
  const _ServiceCard({required this.num, required this.title, required this.desc, required this.tags});

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
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _hover ? AppColors.bg3 : AppColors.bg2,
          border: Border.all(color: _hover ? AppColors.border2 : AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        transform: Matrix4.identity()..translate(0.0, _hover ? -4.0 : 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.num, style: AppText.mono.copyWith(color: AppColors.accent, fontSize: 12, letterSpacing: 1.2)),
            const SizedBox(height: 16),
            Text(widget.title, style: AppText.h4.copyWith(color: AppColors.text)),
            const SizedBox(height: 12),
            Expanded(
              child: Text(widget.desc, style: AppText.body.copyWith(color: AppColors.text2, fontSize: 15)),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 6, runSpacing: 6,
              children: widget.tags.map((t) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(t, style: AppText.mono.copyWith(fontSize: 11, color: AppColors.text2)),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// STACK
// ────────────────────────────────────────────────────────────────────────────

class StackSection extends StatelessWidget {
  final Map<String, String> dict;
  const StackSection({super.key, required this.dict});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = width < 700 ? 1 : (width < 1100 ? 2 : 3);

    final cats = [
      (dict['stack.cat1']!, ['React', 'Next.js', 'Angular', 'Vue', 'Astro', 'Flutter Web', 'TypeScript', 'Tailwind']),
      (dict['stack.cat2']!, ['iOS', 'Android', 'Flutter', 'React Native', 'Swift', 'Kotlin', 'RevenueCat']),
      (dict['stack.cat3']!, ['Java', 'Spring Boot', 'Kotlin', 'C# / .NET', 'Node.js', 'NestJS', 'Python', 'FastAPI', 'Go', 'Elixir', 'Rust', 'C++']),
      (dict['stack.cat4']!, ['PostgreSQL', 'Aurora', 'Cassandra', 'Firestore', 'MongoDB', 'Redis', 'BigQuery', 'Pinecone', 'pgvector']),
      (dict['stack.cat5']!, ['AWS', 'Azure', 'GCP', 'Firebase', 'Kubernetes', 'Docker', 'Terraform', 'Cloudflare', 'Vercel']),
      (dict['stack.cat6']!, ['Kafka', 'RabbitMQ', 'Pub/Sub', 'Datadog', 'Sentry', 'OpenTelemetry', 'GitHub Actions']),
      (dict['stack.cat7']!, ['OpenAI', 'Anthropic', 'Gemini', 'LangChain', 'LangGraph', 'MCP', 'Pinecone', 'Weaviate', 'RAG', 'Vertex AI']),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [AppColors.bg, AppColors.bg2, AppColors.bg],
        ),
      ),
      child: _Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHead(kicker: dict['stack.kicker']!, titleHtml: dict['stack.title']!, sub: dict['stack.sub']),
              const SizedBox(height: 64),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 16, runSpacing: 16,
                    children: cats.map((c) {
                      final colWidth = (constraints.maxWidth - (cols - 1) * 16) / cols;
                      return SizedBox(
                        width: colWidth,
                        child: _StackCat(name: c.$1, tags: c.$2),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StackCat extends StatelessWidget {
  final String name;
  final List<String> tags;
  const _StackCat({required this.name, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bg2,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name.toUpperCase(),
              style: AppText.mono.copyWith(fontSize: 12, color: AppColors.text3, letterSpacing: 1.2)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: tags.map((t) => _StackChip(t)).toList(),
          ),
        ],
      ),
    );
  }
}

class _StackChip extends StatefulWidget {
  final String label;
  const _StackChip(this.label);

  @override
  State<_StackChip> createState() => _StackChipState();
}

class _StackChipState extends State<_StackChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.bg3,
          border: Border.all(color: _hover ? AppColors.accent : AppColors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(widget.label, style: AppText.label.copyWith(
          color: _hover ? AppColors.accent : AppColors.text, fontSize: 13,
        )),
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
            ...steps.map((s) => _TimelineStep(num: s.$1, title: s.$2, desc: s.$3, time: s.$4)),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String num, title, desc, time;
  const _TimelineStep({required this.num, required this.title, required this.desc, required this.time});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 20 : 28),
        decoration: BoxDecoration(
          color: AppColors.bg2,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56, height: 56,
              decoration: const BoxDecoration(gradient: AppColors.gradient, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(num, style: AppText.h6.copyWith(color: AppColors.bg, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.h4.copyWith(color: AppColors.text)),
                  const SizedBox(height: 8),
                  Text(desc, style: AppText.body.copyWith(color: AppColors.text2)),
                  const SizedBox(height: 12),
                  Text(time, style: AppText.mono.copyWith(color: AppColors.text3, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
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

  void _submit() {
    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty || _message.text.trim().isEmpty) {
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
                  BoxShadow(color: AppColors.accent.withOpacity(0.08), blurRadius: 60, spreadRadius: 4),
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
  const FooterSection({super.key, required this.dict});

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Brand(),
            const SizedBox(height: 12),
            Text(d['footer.tag']!, style: AppText.body.copyWith(color: AppColors.text3, fontSize: 14)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(d['nav.services']!, style: AppText.body.copyWith(color: AppColors.text2, fontSize: 14)),
            const SizedBox(height: 8),
            Text(d['nav.stack']!, style: AppText.body.copyWith(color: AppColors.text2, fontSize: 14)),
            const SizedBox(height: 8),
            Text(d['nav.process']!, style: AppText.body.copyWith(color: AppColors.text2, fontSize: 14)),
            const SizedBox(height: 8),
            Text(d['nav.contact']!, style: AppText.body.copyWith(color: AppColors.text2, fontSize: 14)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => launchUrl(Uri.parse('mailto:contact@oligontech.com')),
              child: Text('contact@oligontech.com',
                  style: AppText.mono.copyWith(color: AppColors.accent, fontSize: 14)),
            ),
            const SizedBox(height: 8),
            Text(d['footer.copy']!, style: AppText.body.copyWith(color: AppColors.text3, fontSize: 13)),
          ],
        ),
      ];
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
                ? [BoxShadow(color: AppColors.accent.withOpacity(0.25), blurRadius: 24, offset: const Offset(0, 8))]
                : null,
          ),
          transform: Matrix4.identity()..translate(0.0, _hover ? -2.0 : 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.label, style: AppText.label.copyWith(color: AppColors.bg, fontSize: 14)),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 14, color: AppColors.bg),
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
