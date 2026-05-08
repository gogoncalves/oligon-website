// Oligon · simple i18n. Vanilla JS, no framework.
//
// Como adicionar tradução em um elemento:
//   <h1 data-i18n="hero.title">Texto fallback</h1>
//   <p data-i18n-html="hero.lead">Suporta <strong>HTML</strong></p>
//   <input data-i18n-attr="placeholder:contact.namePlaceholder">
//
// Linguas suportadas: pt (default), en.

window.translations = {
  pt: {
    'meta.title': 'Oligon Technology · Engenharia de software sob medida',
    'meta.description': 'Oligon Technology · Software house brasileira especializada em desenvolvimento sob encomenda, consultoria em TI, web e mobile.',

    'nav.services': 'Serviços',
    'nav.stack': 'Stack',
    'nav.process': 'Processo',
    'nav.contact': 'Contato',
    'nav.cta': 'Falar com a gente →',

    'hero.tag': 'Software house · São Paulo, Brasil',
    'hero.title': 'Software <span class="grad">sob medida</span><br>pra negócios que <span class="grad-2">crescem</span>.',
    'hero.lead': 'Somos uma software house brasileira que constrói produtos digitais (web, mobile e sistemas internos) com engenharia rigorosa e foco em resultado de negócio.',
    'hero.ctaPrimary': 'Conversar sobre seu projeto',
    'hero.ctaSecondary': 'Ver serviços',
    'hero.meta1.num': '100%',
    'hero.meta1.lbl': 'Código próprio<br>sem white label',
    'hero.meta2.num': 'CNPJ',
    'hero.meta2.lbl': 'Empresa formal<br>NF emitida',
    'hero.meta3.num': 'Brasil',
    'hero.meta3.lbl': 'Time local<br>fuso, idioma, cultura',

    'services.kicker': 'O que fazemos',
    'services.title': 'Serviços de engenharia <span class="grad">de ponta a ponta</span>',
    'services.sub': 'De ideia em guardanapo a produto rodando em produção. Cada engagement é desenhado pra resolver um problema concreto.',

    'svc1.title': 'Desenvolvimento sob encomenda',
    'svc1.desc': 'Web apps, APIs, integrações, dashboards internos. Stack moderna, arquitetura escalável, deploy contínuo. Você fica com o código.',
    'svc1.b1': 'Frontend (React, Vue, Flutter Web)',
    'svc1.b2': 'Backend (Node, Python, Go)',
    'svc1.b3': 'Cloud (GCP, AWS, Firebase)',

    'svc2.title': 'Aplicativos mobile',
    'svc2.desc': 'iOS e Android nativos ou cross-platform. Do MVP ao app em escala. Flutter quando faz sentido, Swift/Kotlin quando precisa.',
    'svc2.b1': 'Flutter, React Native',
    'svc2.b2': 'Integração StoreKit, Play Billing, Push',
    'svc2.b3': 'App Store + Play Console submission',

    'svc3.title': 'Consultoria em TI',
    'svc3.desc': 'Audit de sistema legado, escolha de stack, design de arquitetura, code review. Decidimos com você. Não vendemos opinião como produto.',
    'svc3.b1': 'Diagnóstico técnico',
    'svc3.b2': 'Roadmap de modernização',
    'svc3.b3': 'Hiring assessments',

    'svc4.title': 'Web design & desenvolvimento',
    'svc4.desc': 'Sites institucionais, landing pages, e-commerce. Design próprio, performance como prioridade, SEO incluído. Hospedagem e manutenção opcional.',
    'svc4.b1': 'Design system custom',
    'svc4.b2': 'Performance (Lighthouse 95+)',
    'svc4.b3': 'CMS quando precisa',

    'svc5.title': 'Hospedagem & infra',
    'svc5.desc': 'Configuração e operação de cloud, banco de dados, CDN, backup. SLA real, monitoramento 24/7, alertas proativos.',
    'svc5.b1': 'GCP / AWS / Firebase / Vercel',
    'svc5.b2': 'Postgres, MongoDB, Redis',
    'svc5.b3': 'Observability (Datadog, Sentry)',

    'svc6.title': 'Suporte técnico',
    'svc6.desc': 'Suporte recorrente pra produtos em produção: bugs, evoluções, novas features. Contratos mensais com horas dedicadas e SLA de resposta claro.',
    'svc6.b1': 'Pacotes de horas mensais',
    'svc6.b2': 'SLA &lt; 4h em P1',
    'svc6.b3': 'Documentação inclusa',

    'stack.kicker': 'Stack',
    'stack.title': 'Tecnologias que <span class="grad">já entregamos</span> em produção',
    'stack.sub': 'Não temos religião com tools. Escolhemos pelo problema, e dominamos cada uma o suficiente pra colocar em prod com confiança.',
    'stack.cat1': 'Frontend',
    'stack.cat2': 'Mobile',
    'stack.cat3': 'Backend',
    'stack.cat4': 'Banco & dados',
    'stack.cat5': 'Cloud & infra',
    'stack.cat6': 'Eventos & observability',
    'stack.cat7': 'IA & dados',

    'process.kicker': 'Como trabalhamos',
    'process.title': 'Engagement <span class="grad">em 4 etapas</span>',
    'process.s1.title': 'Discovery',
    'process.s1.desc': 'Conversa inicial gratuita. Entendemos o problema, definimos escopo e critérios de sucesso. Sem proposta genérica.',
    'process.s1.time': '1-2 sessões · grátis',
    'process.s2.title': 'Proposta técnica',
    'process.s2.desc': 'Documento com arquitetura, stack escolhido, milestones, prazo e investimento. Tudo escrito pra você decidir com calma.',
    'process.s2.time': '3-5 dias úteis',
    'process.s3.title': 'Sprint de execução',
    'process.s3.desc': 'Sprints curtas com demo semanal. Você acompanha o progresso real, não slide de PowerPoint. Código entregue em repo seu.',
    'process.s3.time': '2-12 semanas conforme escopo',
    'process.s4.title': 'Handover & suporte',
    'process.s4.desc': 'Entrega com documentação técnica, treinamento do seu time (se quiser), e contrato opcional de suporte mensal.',
    'process.s4.time': 'Recorrente ou one-shot',

    'about.kicker': 'Sobre',
    'about.title': 'Engenharia <span class="grad">honesta</span>,<br>sem buzzword.',
    'about.p1': 'A Oligon Technology nasceu da convicção de que software bom é resultado de processo bom, não de hype. Trabalhamos com clientes que valorizam código limpo, arquitetura pensada e prazo cumprido.',
    'about.p2': 'Não somos a maior software house do Brasil. Somos a que você quer ter ao seu lado quando o produto importa.',
    'about.s1.val': 'CNPJ ativo',
    'about.s1.lbl': 'Brasil',
    'about.s2.val': 'NF-e',
    'about.s2.lbl': 'Emissão direta',
    'about.s3.val': 'PJ → PJ',
    'about.s3.lbl': 'Modelo padrão',
    'about.s4.val': 'Seu código',
    'about.s4.lbl': 'Sempre',

    'cta.title': 'Tem um projeto em mente?',
    'cta.desc': 'Conta pra gente o que você quer construir. A primeira conversa é por nossa conta: sem compromisso, sem proposta automática.',
    'cta.namePlaceholder': 'Seu nome',
    'cta.emailPlaceholder': 'email@empresa.com',
    'cta.companyPlaceholder': 'Empresa (opcional)',
    'cta.messagePlaceholder': 'Conta brevemente o que você quer construir...',
    'cta.submit': 'Enviar mensagem',
    'cta.altPrefix': 'Prefere email direto?',

    'footer.tag': 'Engenharia de software sob medida.',
    'footer.copy': '© 2026 Oligon Technology',

    'form.error': '⚠ preencha os campos obrigatórios',
    'form.opening': '✓ abrindo seu cliente de email...',
  },
  en: {
    'meta.title': 'Oligon Technology · Custom software engineering',
    'meta.description': 'Oligon Technology · Brazilian software house specialized in custom development, IT consulting, web and mobile.',

    'nav.services': 'Services',
    'nav.stack': 'Stack',
    'nav.process': 'Process',
    'nav.contact': 'Contact',
    'nav.cta': "Let's talk →",

    'hero.tag': 'Software house · São Paulo, Brazil',
    'hero.title': 'Custom <span class="grad">software</span><br>for businesses that <span class="grad-2">scale</span>.',
    'hero.lead': "We're a Brazilian software house that builds digital products (web, mobile and internal systems) with rigorous engineering and a focus on business outcomes.",
    'hero.ctaPrimary': 'Talk about your project',
    'hero.ctaSecondary': 'View services',
    'hero.meta1.num': '100%',
    'hero.meta1.lbl': 'Original code<br>no white label',
    'hero.meta2.num': 'Tax invoice',
    'hero.meta2.lbl': 'Brazilian entity<br>full compliance',
    'hero.meta3.num': 'Brazil',
    'hero.meta3.lbl': 'Local team<br>timezone, language, culture',

    'services.kicker': 'What we do',
    'services.title': 'End-to-end <span class="grad">engineering services</span>',
    'services.sub': 'From napkin idea to product running in production. Every engagement is designed to solve a concrete problem.',

    'svc1.title': 'Custom development',
    'svc1.desc': 'Web apps, APIs, integrations, internal dashboards. Modern stack, scalable architecture, continuous deployment. You own the code.',
    'svc1.b1': 'Frontend (React, Vue, Flutter Web)',
    'svc1.b2': 'Backend (Node, Python, Go)',
    'svc1.b3': 'Cloud (GCP, AWS, Firebase)',

    'svc2.title': 'Mobile apps',
    'svc2.desc': 'Native iOS/Android or cross-platform. From MVP to scaling app. Flutter when it fits, Swift/Kotlin when it needs to.',
    'svc2.b1': 'Flutter, React Native',
    'svc2.b2': 'StoreKit, Play Billing, Push integration',
    'svc2.b3': 'App Store + Play Console submission',

    'svc3.title': 'IT consulting',
    'svc3.desc': "Legacy system audit, stack selection, architecture design, code review. We decide together. We don't sell opinion as a product.",
    'svc3.b1': 'Technical diagnosis',
    'svc3.b2': 'Modernization roadmap',
    'svc3.b3': 'Hiring assessments',

    'svc4.title': 'Web design & development',
    'svc4.desc': 'Marketing sites, landing pages, e-commerce. Custom design, performance-first, SEO included. Hosting and maintenance optional.',
    'svc4.b1': 'Custom design system',
    'svc4.b2': 'Performance (Lighthouse 95+)',
    'svc4.b3': 'CMS when needed',

    'svc5.title': 'Hosting & infrastructure',
    'svc5.desc': 'Cloud setup and operation, databases, CDN, backups. Real SLA, 24/7 monitoring, proactive alerts.',
    'svc5.b1': 'GCP / AWS / Firebase / Vercel',
    'svc5.b2': 'Postgres, MongoDB, Redis',
    'svc5.b3': 'Observability (Datadog, Sentry)',

    'svc6.title': 'Technical support',
    'svc6.desc': 'Recurring support for products in production: bugs, evolutions, new features. Monthly contracts with dedicated hours and clear response SLA.',
    'svc6.b1': 'Monthly hours packages',
    'svc6.b2': 'SLA &lt; 4h on P1',
    'svc6.b3': 'Documentation included',

    'stack.kicker': 'Stack',
    'stack.title': 'Technologies <span class="grad">we ship</span> to production',
    'stack.sub': "We don't have religion about tools. We pick by the problem, and master each one enough to put it in prod with confidence.",
    'stack.cat1': 'Frontend',
    'stack.cat2': 'Mobile',
    'stack.cat3': 'Backend',
    'stack.cat4': 'Database & data',
    'stack.cat5': 'Cloud & infra',
    'stack.cat6': 'Events & observability',
    'stack.cat7': 'AI & data',

    'process.kicker': 'How we work',
    'process.title': 'Engagement <span class="grad">in 4 stages</span>',
    'process.s1.title': 'Discovery',
    'process.s1.desc': 'Free initial conversation. We understand the problem, define scope and success criteria. No generic proposal.',
    'process.s1.time': '1-2 sessions · free',
    'process.s2.title': 'Technical proposal',
    'process.s2.desc': 'Document with architecture, chosen stack, milestones, timeline and investment. Everything written so you can decide calmly.',
    'process.s2.time': '3-5 business days',
    'process.s3.title': 'Execution sprint',
    'process.s3.desc': 'Short sprints with weekly demo. You follow real progress, not PowerPoint slides. Code delivered to your repo.',
    'process.s3.time': '2-12 weeks per scope',
    'process.s4.title': 'Handover & support',
    'process.s4.desc': 'Delivery with technical documentation, training for your team (if you want), and optional monthly support contract.',
    'process.s4.time': 'Recurring or one-shot',

    'about.kicker': 'About',
    'about.title': '<span class="grad">Honest</span> engineering,<br>no buzzword.',
    'about.p1': "Oligon Technology was born from the conviction that good software is the result of good process, not hype. We work with clients who value clean code, thoughtful architecture and on-time delivery.",
    'about.p2': "We're not the biggest software house in Brazil. We're the one you want by your side when the product matters.",
    'about.s1.val': 'BR entity',
    'about.s1.lbl': 'Active',
    'about.s2.val': 'Tax invoice',
    'about.s2.lbl': 'Direct issuing',
    'about.s3.val': 'B2B model',
    'about.s3.lbl': 'Standard',
    'about.s4.val': 'Your code',
    'about.s4.lbl': 'Always',

    'cta.title': 'Got a project in mind?',
    'cta.desc': "Tell us what you want to build. The first conversation is on us: no commitment, no automated proposal.",
    'cta.namePlaceholder': 'Your name',
    'cta.emailPlaceholder': 'email@company.com',
    'cta.companyPlaceholder': 'Company (optional)',
    'cta.messagePlaceholder': 'Tell us briefly what you want to build...',
    'cta.submit': 'Send message',
    'cta.altPrefix': 'Prefer direct email?',

    'footer.tag': 'Custom software engineering.',
    'footer.copy': '© 2026 Oligon Technology',

    'form.error': '⚠ fill in required fields',
    'form.opening': '✓ opening your email client...',
  }
};

const SUPPORTED = ['pt', 'en'];
const DEFAULT_LANG = 'pt';
const STORAGE_KEY = 'oligon-lang';

function detectLang() {
  const stored = localStorage.getItem(STORAGE_KEY);
  if (stored && SUPPORTED.includes(stored)) return stored;
  // navigator.language ex: 'pt-BR', 'en-US'
  const nav = (navigator.language || '').toLowerCase().slice(0, 2);
  return SUPPORTED.includes(nav) ? nav : DEFAULT_LANG;
}

function applyLang(lang) {
  if (!SUPPORTED.includes(lang)) lang = DEFAULT_LANG;
  const dict = window.translations[lang];

  // <html lang="...">
  document.documentElement.lang = (lang === 'pt' ? 'pt-BR' : 'en');

  // Texto puro
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (dict[key] !== undefined) el.textContent = dict[key];
  });

  // HTML (suporta <span>, <br>, etc)
  document.querySelectorAll('[data-i18n-html]').forEach(el => {
    const key = el.getAttribute('data-i18n-html');
    if (dict[key] !== undefined) el.innerHTML = dict[key];
  });

  // Atributos (placeholder, title, alt, etc)
  // Formato: data-i18n-attr="placeholder:cta.namePlaceholder,title:nav.cta"
  document.querySelectorAll('[data-i18n-attr]').forEach(el => {
    const spec = el.getAttribute('data-i18n-attr');
    spec.split(',').forEach(pair => {
      const [attr, key] = pair.split(':').map(s => s.trim());
      if (dict[key] !== undefined) el.setAttribute(attr, dict[key]);
    });
  });

  // <title> e <meta description>
  if (dict['meta.title']) document.title = dict['meta.title'];
  const metaDesc = document.querySelector('meta[name="description"]');
  if (metaDesc && dict['meta.description']) metaDesc.setAttribute('content', dict['meta.description']);

  // Persistir
  localStorage.setItem(STORAGE_KEY, lang);

  // Atualiza UI do switcher
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.lang === lang);
  });

  // Atualizar atributo do botão pra acessibilidade
  document.documentElement.setAttribute('data-lang', lang);
}

// Bind switcher buttons
function initLangSwitcher() {
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.addEventListener('click', () => applyLang(btn.dataset.lang));
  });
}

// Boot
document.addEventListener('DOMContentLoaded', () => {
  applyLang(detectLang());
  initLangSwitcher();
});
