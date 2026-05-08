# Oligon Technology — Website

Landing institucional da Oligon Technology, software house brasileira.

🌐 Produção: https://oligontech.com
🔥 Firebase Hosting: https://oligon.web.app

## Stack

- HTML/CSS/JS estático puro (zero build step)
- Inter + JetBrains Mono (Google Fonts)
- Firebase Hosting (CDN + HTTPS automático)

## Desenvolvimento

```bash
# Servir localmente (qualquer servidor estático funciona)
cd public && python3 -m http.server 8000
# http://localhost:8000

# Ou usando Firebase emulator
firebase serve --only hosting
```

## Deploy

```bash
firebase deploy --only hosting
```

CI/CD pode ser adicionado depois com GitHub Actions (`.github/workflows/deploy.yml`).

## Estrutura

```
public/
├── index.html          # Landing principal
├── styles.css          # Tema dark, responsivo
├── main.js             # Animações on-scroll, form handler
├── 404.html            # Página de erro
├── robots.txt          # SEO
└── sitemap.xml         # SEO
```

## TODO

- [ ] Adicionar logos/ícones de marca real (favicon, og-image)
- [ ] Conectar form de contato a um endpoint real (Cloud Function ou serviço como Formspree)
- [ ] Adicionar página de portfolio com cases
- [ ] Adicionar versão EN
- [ ] Configurar GitHub Actions para deploy automático no push
