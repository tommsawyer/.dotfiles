## Dotfiles

Конфиги для macOS: zsh (oh-my-zsh), tmux, neovim, lazygit, delta, k9s. Везде тема kanagawa (wave).

### Установка

```sh
git clone <этот репозиторий> ~/.dotfiles
cd ~/.dotfiles
make install
```

`make install` ставит всё из `files/Brewfile` (включая шрифт JetBrains Mono
Nerd Font), emmet language server, oh-my-zsh и русский словарь для проверки
орфографии. Потом создаёт симлинки на конфиги. Если на месте ссылки лежит
обычный файл, он переименовывается в `*.backup`.

После этого:

- iTerm2: Settings → Profiles → выбрать «Kanagawa» → Other Actions → Set as
  Default. Сам профиль (цвета, шрифт, без меток команд) подключается из
  `files/iterm/profile.json` как dynamic profile. Его guid при смене темы не
  меняется, так что это делается один раз.
- `nvim` при первом запуске сам ставит плагины.

### Цели make

| Цель | Что делает |
|---|---|
| `make install` | всё, что ниже, кроме `check` и `fmt` |
| `make symlinks` | создаёт ссылки на конфиги (список — `LINKS` в Makefile) |
| `make check` | быстрые проверки: zsh, tmux, shellcheck, yaml, lua-language-server, запуск nvim |
| `make fmt` | форматирует Lua через lua_ls, так же, как при сохранении в nvim |
| `make nvim-sync` | обновляет плагины nvim без интерфейса (`Lazy! sync`, пишет `lazy-lock.json`) |
| `make clean` | удаляет ссылки |

### Что куда линкуется

| Файл | Ссылка | Что там |
|---|---|---|
| `files/zshrc` | `~/.zshrc` | oh-my-zsh, fzf, zoxide, `tm`, `Ctrl-G`, подсказки lazygit вместо `git` |
| `files/tmux` | `~/.config/tmux` | prefix `C-f`, `switch.sh` — переключение сессий по `prefix s`, `connect.sh` — общий код для `tm` и `switch.sh` |
| `files/nvim` | `~/.config/nvim` | neovim, подробно ниже |
| `files/bat` | `~/.config/bat` | тема kanagawa |
| `files/lazygit/config.yml` | `~/Library/Application Support/lazygit/config.yml` | цвета, диффы через delta |
| `files/k9s` | `~/Library/Application Support/k9s/` | только чтение, скин kanagawa |
| `files/git/delta.gitconfig` | подключается из `~/.gitconfig` | delta как pager |
| `files/iterm/profile.json` | `~/Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json` | профиль iTerm2 |

## Neovim

Leader — `,`. Если начать комбинацию и подождать полсекунды, which-key покажет
продолжения. Все пути ниже даны относительно `files/nvim/`.

### 1. Файлы

**1.1 Дерево файлов.** `,,` открывает и закрывает дерево. Если открыть его из
файла проекта, этот файл будет подсвечен в дереве. `,a` показывает текущий файл в дереве. Плагин nvim-tree,
настройки в [`lua/plugin/nvim-tree.lua`](files/nvim/lua/plugin/nvim-tree.lua):
dotfiles скрыты (`H` показывает их), `*_templ.go` и `go.sum` тоже скрыты.
При переименовании файла в дереве LSP обновляет импорты.

**1.2 Хлебные крошки.** Над каждым окном показан путь к файлу и функция или
класс, где стоит курсор. Это плагин dropbar, настройки в
[`lua/plugin/dropbar.lua`](files/nvim/lua/plugin/dropbar.lua). `,;` выбирает
элемент по метке. В открывшемся меню `o` открывает папку или файл, `t`
показывает его в дереве, `a` создаёт новый файл рядом. В yaml, json и toml
вместо символов LSP показываются ключи.

**1.3 Поиск.** `<Space>` ищет файлы, `,f` — текст по всему проекту, `,b` —
буферы, `,h` — help, `,d` — символы проекта. Это пикеры snacks.nvim, настройки
в [`lua/plugin/snacks.lua`](files/nvim/lua/plugin/snacks.lua). Что не попадает
в поиск, задано списком `exclude` в начале файла.

**1.4 Открытие и перечитывание.** Файл
[`lua/autocommands.lua`](files/nvim/lua/autocommands.lua). Если запустить
`nvim` без аргументов, откроется последний файл, который правили в этом
проекте. Курсор встаёт на прежнее место. Если файл изменился на диске
(например, его поправил агент), nvim перечитывает его.

### 2. Перемещение

**2.1 Прыжки.** `<CR>` — прыжок по меткам на экране. При поиске через `/`
на совпадениях тоже появляются метки. После оператора `r` действует в месте
по метке, не двигая курсор: например, `yr` + метка + `iw` копирует там слово. `S` выделяет узел treesitter.
Плагин flash, [`lua/plugin/flash.lua`](files/nvim/lua/plugin/flash.lua).

**2.2 По структуре кода.** Текстовые объекты `af`/`if` (функция), `ai`/`ii`
(условие), `al`/`il` (цикл), `aa`/`ia` (параметр), `ac`/`ic` (вызов) и
`as` (выражение). Прыжки `]f` `[f`, `]i` `[i`, `]l` `[l`, `]c` `[c`. Это
treesitter-textobjects, настройки в
[`lua/plugin/treesitter.lua`](files/nvim/lua/plugin/treesitter.lua). Там же
список парсеров treesitter. Подсветку HTML внутри Go-шаблонов задаёт
`after/queries/gotmpl/injections.scm`.

**2.3 По отступам.** `]=` `[=` прыгают к ближайшей строке с другим отступом, `]-` `[-` —
к строке с меньшим отступом (выход из блока). Эти прыжки описаны в
[`lua/mappings.lua`](files/nvim/lua/mappings.lua). Текстовые объекты `a=`/`i=` —
блок по отступу, это scope из snacks. Вертикальные линии отступов рисует
indent-blankline, [`lua/plugin/indent.lua`](files/nvim/lua/plugin/indent.lua).

**2.4 Окна.** `<C-h/j/k/l>` переходит в соседнее окно, а если его нет, создаёт
сплит. `{` и `}` не засоряют jumplist. Всё в
[`lua/mappings.lua`](files/nvim/lua/mappings.lua).

### 3. LSP, автодополнение, форматирование

**3.1 Серверы.** [`lua/plugin/lsp.lua`](files/nvim/lua/plugin/lsp.lua).
Серверы включаются встроенным `vim.lsp.enable` (список в конце файла), а
nvim-lspconfig только поставляет их конфиги. Сами серверы ставятся через
`files/Brewfile`, Mason не используется. Чтобы добавить сервер: добавить его в
Brewfile, вписать в `vim.lsp.enable` и при необходимости настроить через
`vim.lsp.config`. Сейчас отдельно настроены:

- gopls — понимает шаблоны;
- jsonls и yamlls — схемы из schemastore, для yaml ещё GitLab CI;
- basedpyright и ruff — basedpyright даёт типы и hover, ruff — линт и импорты;
- lua_ls;
- emmet — работает и в templ.

Прогресс запуска серверов показывается уведомлениями в правом верхнем углу.

**3.2 Клавиши LSP.** Тот же файл. `K` — документация, `gd` — определение,
`grn` — переименование, `ga` — code action, `]d` `[d` — диагностики. Списки
открываются в Trouble: `grr` — ссылки, `gri`/`gi` — реализации, `grt`/`gy` —
типы, `gO`/`,s` — символы файла, `,t` — все диагностики
([`lua/plugin/trouble.lua`](files/nvim/lua/plugin/trouble.lua)).

**3.3 Автодополнение.** Плагин blink.cmp,
[`lua/plugin/blink.lua`](files/nvim/lua/plugin/blink.lua). Клавиши стандартные:
`<C-y>` — принять, `<C-n>`/`<C-p>` — выбор, `<C-space>` — открыть меню,
`<C-e>` — закрыть. Источники — LSP и сниппеты friendly-snippets.
Документация к пункту меню появляется через полсекунды. Подсказка по
аргументам показывается сама.

**3.4 Форматирование.** Файл форматируется при сохранении через conform,
[`lua/plugin/conform.lua`](files/nvim/lua/plugin/conform.lua). Форматтеры
назначены по типам файлов. Если форматтера нет, файл форматирует LSP. Swift
форматируется, только если в проекте есть `.swift-format`. Импорты Go
поправляются при сохранении, это автокоманда в `lsp.lua`.

**3.5 Kotlin и Swift.** Для Kotlin стоит официальный kotlin-lsp, файл
[`lua/plugin/kotlin.lua`](files/nvim/lua/plugin/kotlin.lua). Для Swift есть сборка, запуск и
тесты на симуляторе: `,xx` открывает меню, `,xb`/`,xr`/`,xt` — сборка, запуск, тесты, файл
[`lua/plugin/xcode.lua`](files/nvim/lua/plugin/xcode.lua). В новом
Xcode-проекте один раз нужно запустить `:XcodebuildSetup`. Отступ в 4 пробела
задан в `after/ftplugin/kotlin.lua` и `swift.lua`.

### 4. Редактирование

- `sa{движение}{символ}` оборачивает текст, `sd{символ}` убирает обёртку,
  `sr{старый}{новый}` меняет её. Это nvim-surround. Там же nvim-autopairs,
  который сам закрывает скобки. Файл
  [`lua/plugin/misc.lua`](files/nvim/lua/plugin/misc.lua).
- `gS`/`gJ` разбивают блок на строки и склеивают обратно (treesj). Парные
  HTML-теги закрываются и переименовываются сами (nvim-ts-autotag). Оба
  плагина в `treesitter.lua`.
- `gc` комментирует, это встроено в nvim. Комментарий не продолжается на
  новой строке, это задано в `autocommands.lua`.

### 5. Git

`]g` `[g` — переход между ханками. `,gp` показывает ханк, `,gu` откатывает
его, `,gb` показывает blame строки. Это gitsigns,
[`lua/plugin/gitsigns.lua`](files/nvim/lua/plugin/gitsigns.lua). `,go`
открывает файл в браузере (snacks gitbrowse). Сам lazygit открывается в tmux
по `C-f g`.

### 6. AI-агенты

Плагин sidekick, [`lua/plugin/sidekick.lua`](files/nvim/lua/plugin/sidekick.lua).
Агент (claude, opencode, …) открывается в отдельной панели tmux справа. Эта панель
переживает перезапуск nvim. Клавиши:

- `,ii` — показать или скрыть агента, `,ic` — выбрать агента;
- `,ie` — попросить объяснить место под курсором, `,is` — отправить это место агенту, `,if` — отправить файл;
- `,ip` — готовые промпты, на русском;
- `,iw` — «допиши код здесь»;
- `<C-.>` — переключиться между nvim и агентом.

### 7. Внешний вид

- Тема kanagawa-wave и её переопределения (дерево, winbar):
  [`lua/plugin/colorscheme.lua`](files/nvim/lua/plugin/colorscheme.lua).
- Интерфейс минимальный: нет ни статус-бара, ни командной строки, мышь
  выключена. Это и остальные опции в
  [`lua/options.lua`](files/nvim/lua/options.lua).
- Уведомления (история — `,n`) и zen-режим (`,z`) дают snacks.
- Markdown рендерится прямо в буфере плагином render-markdown,
  [`lua/plugin/markdown.lua`](files/nvim/lua/plugin/markdown.lua). Перенос
  строк и проверка орфографии (ru + en) включены в
  `after/ftplugin/markdown.lua`.
- Подсказки клавиш: which-key,
  [`lua/plugin/which-key.lua`](files/nvim/lua/plugin/which-key.lua).

### 8. Русская раскладка и привычки

- Обычные команды vim работают в русской раскладке через `langmap`, а `:ц` и
  `:й` срабатывают как `:w` и `:q`. Это задано в `options.lua`.
- Маппинги с leader, Ctrl и клавиши плагинов дублирует langmapper,
  [`lua/plugin/langmapper.lua`](files/nvim/lua/plugin/langmapper.lua).
- hardtime не даёт жать `hjkl` много раз подряд и подсказывает движение
  получше, [`lua/plugin/hardtime.lua`](files/nvim/lua/plugin/hardtime.lua).

### 9. Как устроен конфиг

[`init.lua`](files/nvim/init.lua) ставит lazy.nvim и подключает модули по
порядку: `mappings` → `plugins` → `options` → `autocommands`. В конце
langmapper переводит на русскую раскладку маппинги, созданные раньше него.
[`lua/plugins.lua`](files/nvim/lua/plugins.lua) загружает все файлы из
`lua/plugin/`. Один плагин — один файл, новый плагин — новый файл там же.
Версии плагинов зафиксированы в `lazy-lock.json` и обновляются через
`make nvim-sync`. После правок Lua нужно запустить `make fmt`, затем
`make check`.

## Проекты: tmux

Каждый проект — отдельная сессия tmux, и сессия называется по имени папки.
Prefix — `C-f`. Всё, что ниже, кроме `tm`, настроено в
[`files/tmux/tmux.conf`](files/tmux/tmux.conf). После правок конфиг можно
перечитать через `C-f r`.

**Открыть проект.** `tm` открывает сессию для текущей папки. `tm x` принимает
имя открытой сессии, путь или слово, которое zoxide превратит в папку
(`tm dotf` → `~/.dotfiles`). Если сессии нет, она создаётся. Снаружи tmux команда
подключается к сессии, внутри переключается на неё. По `Tab` дополняются
сессии и папки. Функция `tm` объявлена в [`files/zshrc`](files/zshrc), а логика лежит
в [`files/tmux/connect.sh`](files/tmux/connect.sh).

**Переключиться.** `C-f s` (или `Ctrl-G` прямо в zsh) открывает fzf со
списком сессий и папок из истории zoxide, у которых ещё нет сессии. Справа
показывается превью. `enter` открывает выбранное, `ctrl-x` убивает сессию,
а новое имя + `enter` создаёт сессию. Код в
[`files/tmux/switch.sh`](files/tmux/switch.sh), папки берутся через sesh.
Стандартное дерево сессий осталось на `C-f w`.

**Окна и панели.** `C-f \` и `C-f -` делят окно вбок и вниз, `C-f c` создаёт
новое окно. Всё открывается в текущей папке. `C-f h/j/k/l` переходит между
панелями, `C-f J` присоединяет панель (join), `C-f b` выносит её в отдельное
окно, `C-f !` и `C-f @` включают раскладки main-horizontal и even-horizontal.
Окна нумеруются с 1, а после закрытия окна номера сдвигаются без дыр. Мышь
включена.

**Плавающие панели.** `C-f g` открывает lazygit, `C-f K` — k9s. Обе
панели занимают 90% экрана и закрываются вместе с программой. Нужен tmux 3.7+.

**Статус-бар.** Стоит сверху. Слева имя сессии, которое желтеет, пока нажат
prefix. Дальше окна, у каждого — что сейчас делает AI-агент (берётся из
заголовка его панели). Справа git-ветка, контекст kubectl и время. Цвета
kanagawa, палитра записана комментарием в конфиге. `extended-keys` пропускает
`Shift+Enter` и подобные комбинации в nvim и Claude Code.

## Консольные утилиты

Shell — zsh с oh-my-zsh (тема robbyrussell, плагины git, tmux, golang,
docker-compose), всё в [`files/zshrc`](files/zshrc). Настройки, которые
нужны только на этой машине, кладутся в `~/.zshcustom`, этого файла в
репозитории нет.

**lazygit** — основной способ работать с git. Запускается через `lg` или `C-f g`.
Настройки в [`files/lazygit/config.yml`](files/lazygit/config.yml): цвета
kanagawa, `e` открывает файл в nvim. Диффы рисует delta, а при ширине от 140
колонок — в две колонки. В терминале `git status`, `commit`, `push` и
другие частые команды (включая алиасы вроде `gst`) не выполняются, а печатают,
как сделать то же в lazygit. Этот перехват — функция `git` в `zshrc`. Скрипты
и `$(git …)` он не трогает. Настоящий git вызывается через `command git …`
или `GIT_FORCE=1 git …`.

**delta** — pager для git:
[`files/git/delta.gitconfig`](files/git/delta.gitconfig). Он подключается в
`~/.gitconfig` через `include.path`, это делает `make symlinks`. В самом git
дифф показывается в две колонки, `n`/`N` прыгают между файлами. Добавленные
строки синие, а не зелёные, чтобы лучше отличаться от красных. Конфликты в
стиле `zdiff3`. Подсветка синтаксиса — тема kanagawa из bat.

**k9s** — Kubernetes. Запускается через `C-f K` или `k9s`. Работает только на
чтение: удалить, отредактировать и убить ничего нельзя. Для разовой правки
запускай `k9s --write`. Логи показывают последние 200 строк за 5 минут.
Настройки в [`files/k9s/config.yaml`](files/k9s/config.yaml), скин — в
`files/k9s/skins/kanagawa.yaml`.

**zoxide** запоминает папки, в которых ты бываешь. `z слово` переходит в
лучшую подходящую папку, `zi` выбирает из списка. Эта же история нужна для `tm`
и `C-f s`.

**fzf**: `Ctrl-T` вставляет путь к файлу, `Ctrl-R` ищет по истории команд,
`Alt-C` переходит в папку. Файлы ищутся через `rg` с учётом `.gitignore`,
скрытые файлы показываются. Цвета kanagawa заданы в `FZF_DEFAULT_OPTS` в
`zshrc`.

**Прочее.** Тема bat — в [`files/bat/config`](files/bat/config) и
`themes/kanagawa.tmTheme`, кэш тем пересобирает `make symlinks`. `glow`
рендерит markdown в терминале. Алиасы: `vim` → `nvim`, `rg` всегда с
`--hidden`, `coverage` запускает `go test` и открывает HTML-отчёт о покрытии.
Полный список программ — в [`files/Brewfile`](files/Brewfile).
