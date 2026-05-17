// Static i18n maps. PT default, +EN.
// Tags suportadas em valores:
//   <grad>texto</grad>  → renderizado com gradient (ShaderMask)
//   <m>texto</m>        → texto muted (cinza)

class I18n {
  static const supported = ['pt', 'en'];

  static const Map<String, Map<String, String>> dict = {
    'pt': _pt,
    'en': _en,
  };

  static const _pt = {
    'meta.title': 'Oligon Technology · Engenharia de software sob medida',

    'nav.services': 'Serviços',
    'nav.products': 'Produtos',
    'nav.process': 'Processo',
    'nav.contact': 'Contato',
    'nav.cta': 'Vamos conversar',

    'products.kicker': 'Produtos',
    'products.title': 'Software que <grad>criamos</grad>.',
    'products.attendari.title': 'Attendari',
    'products.attendari.tag': 'AI WhatsApp SaaS',
    'products.attendari.desc': 'Atendente virtual com IA no WhatsApp 24/7 pra pequenos negócios brasileiros. Agenda, cobra sinal Pix, responde clientes. Assinatura mensal R\$ 99 – R\$ 699.',
    'products.attendari.status': 'Live',
    'products.attendari.cta': 'attendari.com →',
    'products.soon.title': 'Mais em construção',
    'products.soon.desc': 'Outros produtos Oligon em desenvolvimento.',

    'hero.title.line1': 'Software sob medida',
    'hero.title.line2': 'para times',
    'hero.title.line3': '<grad>ambiciosos</grad>.',
    'hero.lead': 'Construímos produtos, sistemas de IA e plataformas de engenharia em produção. Time sênior, sem abstrações, código que é seu.',
    'hero.ctaPrimary': 'Iniciar um projeto',
    'hero.ctaSecondary': 'Ver serviços',

    'manifesto.line1': 'Não vendemos <m>"transformação digital"</m>.',
    'manifesto.line2': 'Entregamos software que ganha o lugar dele.',
    'manifesto.line2.hl': 'software',

    'services.kicker': 'Serviços',
    'services.title': 'Engenharia, ponta a ponta.',

    'svc1.title': 'Produtos sob medida',
    'svc1.desc': 'Web apps, APIs e infraestrutura cloud production-grade. Arquitetura escalável, CI/CD, observability. Você fica com o código.',
    'svc2.title': 'Aplicativos mobile',
    'svc2.desc': 'iOS/Android nativos ou Flutter cross-platform. Do MVP ao app em escala. Submissão, IAP, push, analytics.',
    'svc3.title': 'IA & agentes',
    'svc3.desc': 'Features com LLM, agentes autônomos, pipelines RAG, servidores MCP. Valor real, não demos.',
    'svc4.title': 'Parceria de engenharia',
    'svc4.desc': 'Advisory técnico, squads embarcados ou retainer mensal. Architecture review, due diligence, cadência real, SLAs claros.',

    'process.kicker': 'Processo',
    'process.title': 'Da ideia ao <grad>produção</grad>.',
    'process.s1.title': 'Discovery',
    'process.s1.desc': 'Conversa inicial gratuita. Entendemos o problema, escopo e critérios de sucesso.',
    'process.s1.time': '1–2 sessões · grátis',
    'process.s2.title': 'Proposta técnica',
    'process.s2.desc': 'Arquitetura, stack, milestones, prazo, investimento. Tudo escrito pra você decidir com calma.',
    'process.s2.time': '3–5 dias úteis',
    'process.s3.title': 'Execução',
    'process.s3.desc': 'Sprints curtas com demo semanal. Progresso real, não slide. Código no seu repo.',
    'process.s3.time': '2–12 semanas por escopo',
    'process.s4.title': 'Handover & suporte',
    'process.s4.desc': 'Documentação, treinamento opcional do time, retainer mensal opcional.',
    'process.s4.time': 'Recorrente ou one-shot',

    'cta.title': 'Tem algo pra construir?',
    'cta.desc': 'Conta o que você tem em mente. A primeira conversa é por nossa conta. Sem compromisso, sem proposta automática.',
    'cta.namePlaceholder': 'Nome',
    'cta.emailPlaceholder': 'email@empresa.com',
    'cta.companyPlaceholder': 'Empresa (opcional)',
    'cta.messagePlaceholder': 'Conta brevemente o que você quer construir...',
    'cta.submit': 'Enviar',
    'cta.altPrefix': 'Prefere email?',

    'footer.tag': 'Engenharia de software sob medida.',
    'footer.copy': '© 2026 Oligon Technology',

    'form.error': '⚠ Preencha os campos obrigatórios',
    'form.opening': '✓ Abrindo seu cliente de email...',

    'privacy.text': 'Não usamos cookies nem rastreio. Armazenamos apenas sua preferência de idioma localmente.',
    'privacy.ok': 'OK',
  };

  static const _en = {
    'meta.title': 'Oligon Technology · Custom software engineering',

    'nav.services': 'Services',
    'nav.products': 'Products',
    'nav.process': 'Process',
    'nav.contact': 'Contact',
    'nav.cta': 'Talk to us',

    'products.kicker': 'Products',
    'products.title': 'Software we <grad>built</grad>.',
    'products.attendari.title': 'Attendari',
    'products.attendari.tag': 'AI WhatsApp SaaS',
    'products.attendari.desc': 'AI receptionist on WhatsApp 24/7 for Brazilian small businesses. Books, charges Pix deposits, replies to customers. Monthly subscription R\$ 99 – R\$ 699.',
    'products.attendari.status': 'Live',
    'products.attendari.cta': 'attendari.com →',
    'products.soon.title': 'More in build',
    'products.soon.desc': 'Other Oligon products in development.',

    'hero.title.line1': 'Custom software',
    'hero.title.line2': 'for ambitious',
    'hero.title.line3': '<grad>teams</grad>.',
    'hero.lead': "We build production-grade products, AI systems and engineering platforms. Senior team, no abstractions, code you own.",
    'hero.ctaPrimary': 'Start a project',
    'hero.ctaSecondary': 'See services',

    'manifesto.line1': 'We don\'t sell <m>"digital transformation"</m>.',
    'manifesto.line2': 'We ship software that earns its place.',
    'manifesto.line2.hl': 'software',

    'services.kicker': 'Services',
    'services.title': 'Engineering, end-to-end.',

    'svc1.title': 'Custom products',
    'svc1.desc': 'Web apps, APIs and production-grade cloud infrastructure. Scalable architecture, CI/CD, observability. You own the code.',
    'svc2.title': 'Mobile apps',
    'svc2.desc': 'Native iOS/Android or cross-platform with Flutter. From MVP to scale. Submission, IAP, push notifications, analytics.',
    'svc3.title': 'AI & agents',
    'svc3.desc': 'LLM-powered features, autonomous agents, RAG pipelines, MCP servers. Real value, not demos.',
    'svc4.title': 'Engineering partnership',
    'svc4.desc': 'Technical advisory, embedded squads or monthly retainer. Architecture review, due diligence, real cadence, clear SLAs.',

    'process.kicker': 'Process',
    'process.title': 'From idea to <grad>shipped</grad>.',
    'process.s1.title': 'Discovery',
    'process.s1.desc': 'Free initial conversation. We understand the problem, scope, and success criteria.',
    'process.s1.time': '1–2 sessions · free',
    'process.s2.title': 'Technical proposal',
    'process.s2.desc': 'Architecture, stack, milestones, timeline, investment. Written so you can decide calmly.',
    'process.s2.time': '3–5 business days',
    'process.s3.title': 'Execution',
    'process.s3.desc': 'Short sprints, weekly demos. Real progress, not slides. Code in your repo.',
    'process.s3.time': '2–12 weeks per scope',
    'process.s4.title': 'Handover & support',
    'process.s4.desc': 'Documentation, optional team training, optional monthly retainer.',
    'process.s4.time': 'Recurring or one-shot',

    'cta.title': 'Got something to build?',
    'cta.desc': "Tell us what you have in mind. The first conversation is on us. No commitment, no auto-proposal.",
    'cta.namePlaceholder': 'Name',
    'cta.emailPlaceholder': 'email@company.com',
    'cta.companyPlaceholder': 'Company (optional)',
    'cta.messagePlaceholder': 'Briefly describe what you want to build...',
    'cta.submit': 'Send',
    'cta.altPrefix': 'Prefer email?',

    'footer.tag': 'Custom software engineering.',
    'footer.copy': '© 2026 Oligon Technology',

    'form.error': '⚠ Required fields',
    'form.opening': '✓ Opening your email client...',

    'privacy.text': 'No cookies, no tracking. We only store your language preference locally.',
    'privacy.ok': 'OK',
  };

}
