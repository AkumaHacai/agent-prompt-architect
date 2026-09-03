# Маршрутизация установленных скиллов

Выбирай минимальный достаточный набор. В готовом промпте используй точные имена скиллов, доступные в целевой среде. Не утверждай, что скилл установлен, если пользователь не предоставил список.

## Обязательная база для репозитория

| Скилл | Когда включать | Как закрепить в промпте |
| --- | --- | --- |
| `graphify` | Любой вопрос или изменение существующей кодовой базы | Обязателен до плана и правок. Сначала запросить архитектуру, связи, точки входа, аналоги и blast radius; проверить выводы по исходникам. При отсутствии/ошибке/устаревшем индексе — fallback к поиску и чтению кода. |
| `find-skills` | Требуемой способности нет среди установленных скиллов либо пользователь просит подобрать новый | Сначала проверить текущий каталог; не искать замену уже подходящему установленному скиллу. |
| `playwright-cli` | Нужна браузерная проверка, воспроизведение, screenshots, interaction или Playwright-тесты | Использовать после реализации для наблюдаемой проверки. Не считать заменой Graphify или чтению кода. |

## Frontend, UI и дизайн

| Скилл | Когда включать | Граница |
| --- | --- | --- |
| `hallmark` | Greenfield-страница, редизайн, аудит по скриншоту/URL, борьба с AI-slop | Задаёт арт-дирекцию и критику; не заменяет реализацию и browser QA. |
| `impeccable` | Проектирование, редизайн, polishing, UX-аудит, адаптивность, доступность и улучшение frontend | Основной широкий frontend-quality skill; подключать, когда требуется качество интерфейса, а не при любой правке текста. |
| `ui-ux-pro-max` | Web/mobile/desktop UI, компоненты, design system, accessibility, interaction и responsive | Использовать для глубоких UX/UI решений и review. Не дублировать без причины все дизайн-скиллы. |
| `ui-styling` | Реализация на shadcn/ui, Radix, Tailwind или canvas | Выбирать, когда стек или результат действительно соответствует этим технологиям. |
| `design-system` | Токены, архитектура primitive→semantic→component, спецификации компонентов | Обязателен при создании/рефакторинге токенов и системных компонентов; избыточен для локальной правки. |
| `design` | Полная visual identity, logo, corporate identity, HTML presentation или широкий design workflow | Выбирать для комплексной дизайн-задачи, не как универсальный frontend-скилл. |
| `brand` | Brand voice, messaging, visual identity, consistency и style guide | Подключать, когда результат должен следовать бренду или сформировать его. |
| `banner-design` | Баннеры для соцсетей, рекламы, hero и печати | Использовать для баннерного артефакта и вариантов арт-дирекции. |
| `slides` | Стратегические HTML-презентации, Chart.js, responsive slides и copywriting | Использовать для презентаций; не подменять им обычную страницу. |

### Практичные комбинации

- Новый выразительный лендинг: `graphify` при существующем repo + `hallmark` + `impeccable`; `ui-styling` только при соответствующем стеке; `playwright-cli` для QA.
- Локальная UI-правка: `graphify` + `impeccable` или `ui-styling`; не подключать весь дизайн-набор.
- Новая дизайн-система: `graphify` + `design-system` + `ui-ux-pro-max`; `playwright-cli` для состояний компонентов.
- Редизайн по скриншоту: `graphify` + `hallmark` + `impeccable` + `playwright-cli`; потребовать crop/zoom референса.
- Брендовый баннер: `brand` + `banner-design`; `design` добавлять только для более широкой айдентики.

## GSAP и анимация

Подключай `gsap-core` для любой реализации на GSAP, затем только профильные дополнения.

| Скилл | Когда включать |
| --- | --- |
| `gsap-core` | `gsap.to`, `from`, `fromTo`, easing, duration, stagger, defaults, matchMedia и reduced motion. |
| `gsap-react` | React или Next.js: `useGSAP`, refs, context и cleanup. |
| `gsap-frameworks` | Vue, Nuxt, Svelte, SvelteKit и lifecycle/cleanup вне React. |
| `gsap-scrolltrigger` | Scroll-linked, pinning, scrub, triggers и parallax. |
| `gsap-timeline` | Последовательности, хореография, вложенные timelines и playback. |
| `gsap-performance` | Оптимизация FPS, jank, transforms, batching, layout thrashing и `will-change`; добавлять для сложной или проблемной анимации. |
| `gsap-plugins` | ScrollToPlugin, ScrollSmoother, Flip, Draggable, Inertia, Observer, SplitText, SVG/physics и прочие плагины. |
| `gsap-utils` | `clamp`, `mapRange`, `normalize`, `interpolate`, `random`, `snap`, `toArray`, `wrap`, `pipe`. |

Примеры:

- React hero-анимация: `graphify` + `gsap-core` + `gsap-react`; при сложной сцене добавить `gsap-timeline` и `gsap-performance`.
- Scroll-driven landing: `graphify` + `gsap-core` + framework-specific skill + `gsap-scrolltrigger` + `gsap-performance` + `playwright-cli`.
- FLIP-переход: `graphify` + `gsap-core` + framework-specific skill + `gsap-plugins`.

## Ponytail

| Скилл | Когда включать |
| --- | --- |
| `ponytail:ponytail` | Пользователь просит установить intensity либо промпт должен явно работать в выбранном режиме `lite/full/ultra/off`. Не придумывай уровень без требования или устойчивого контекста. |
| `ponytail:ponytail-review` | Сфокусированный review сделанных изменений на переусложнение и удаляемый код. Уместен после значимой реализации, если пользователь хочет такой контроль. |
| `ponytail:ponytail-audit` | Аудит всего репозитория на over-engineering и возможность удаления. Не запускать для локальной задачи. |
| `ponytail:ponytail-gain` | Пользователь просит измерить влияние Ponytail: код, стоимость, время. |
| `ponytail:ponytail-help` | Пользователь просит справку по уровням, командам и возможностям Ponytail. |

## Специализированная разработка

| Скилл | Когда включать |
| --- | --- |
| `dev` | Maintenance самого репозитория `playwright-cli`: rolling dependencies, release и связанные project workflows. Не применять как общий development skill. |

## Правила выбора

1. Начни с результата, а не с максимального числа скиллов.
2. `graphify` обязателен для существующего repo; остальные скиллы условны.
3. Выбери один основной domain skill и добавляй специализированные только для реальной части задачи.
4. Если два скилла сильно перекрываются, укажи каждому отдельную ответственность в промпте либо оставь один.
5. Browser QA, performance review и over-engineering review — отдельные проверки, а не замена реализации.
6. Попроси целевого агента прочитать каждый выбранный `SKILL.md` полностью до действий и соблюдать порядок применения.
7. Если скилл недоступен, агент сообщает это и продолжает лучшим доступным способом, если отсутствие не блокирует результат.

