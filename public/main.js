// Oligon Technology · site interactions

// 1) Header scroll state · adiciona classe .scrolled depois de 16px
(() => {
  const header = document.querySelector('header');
  if (!header) return;
  const onScroll = () => {
    if (window.scrollY > 16) header.classList.add('scrolled');
    else header.classList.remove('scrolled');
  };
  document.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
})();

// 2) Reveal-on-scroll com IntersectionObserver · sem depender de framework.
//    Adiciona .reveal automaticamente em cards/sections e .visible quando
//    entram no viewport.
(() => {
  if (!('IntersectionObserver' in window)) return;
  const targets = document.querySelectorAll('.card, .stack-cat, .proc-step, .stat, .section-head');
  targets.forEach(el => el.classList.add('reveal'));
  const io = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        io.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
  targets.forEach(el => io.observe(el));
})();

// 3) Submit do form de contato.
//    Sem backend ainda · abre cliente de email com mailto: pré-preenchido.
//    Quando tiver backend (Cloud Function/SendGrid), trocar por fetch().
function submitContact(event) {
  event.preventDefault();
  const form = event.target;
  const name = form.name.value.trim();
  const email = form.email.value.trim();
  const company = form.company.value.trim();
  const message = form.message.value.trim();
  const msgEl = document.getElementById('formMsg');

  if (!name || !email || !message) {
    msgEl.textContent = '⚠ preencha os campos obrigatórios';
    msgEl.style.color = '#FFB200';
    return false;
  }

  const subject = `[Oligon] Contato de ${name}${company ? ' · ' + company : ''}`;
  const body = `Nome: ${name}\nEmail: ${email}${company ? '\nEmpresa: ' + company : ''}\n\nMensagem:\n${message}`;
  const mailto = `mailto:contato@oligontech.com?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;

  window.location.href = mailto;
  msgEl.textContent = '✓ abrindo seu cliente de email...';
  msgEl.style.color = '';

  return false;
}
