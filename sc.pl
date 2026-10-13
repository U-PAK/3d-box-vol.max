#!/usr/bin/env perl
use Mojolicious::Lite;
use utf8;

# =====================================================================
# FOLDform - Optimizador de Cajas Abiertas (Backend en Perl)
# Autor: phoenix.3301
# Entorno: Replit / Mojolicious::Lite
# =====================================================================

# Autor: phoenix.3301 - Inicio de la lógica del servidor y cálculos
# Autor: phoenix.3301 - Helper matemático para optimización de cajas
helper calculate_box => sub {
    my ($self, $length,$width) = @_;
    return undef unless defined $length && defined$width && $length > 0 &&$width > 0;
    my $sum = $length +$width;
    my $radicand = 1 - (3 * $length * $width) / ($sum * $sum);
    my $cut = ($sum / 6) * (1 - sqrt($radicand > 0 ?$radicand : 0));
    my $boxLength = $length - 2 * $cut;
    my $boxWidth  = $width - 2 * $cut;
    my $volume    =$boxLength * $boxWidth * $cut;
    return {
        cut       => $cut,
        boxLength => $boxLength,
        boxWidth  => $boxWidth,
        volume    => $volume
    };
};

# Autor: phoenix.3301 - Controlador de rutas de la aplicación web
get '/' => sub {
    my $c = shift;
    my $length =$c->param('length');
    $length = 30 unless defined$length && $length =~ /^[0-9.]+$/;
    my $width =$c->param('width');
    $width = 20 unless defined$width && $width =~ /^[0-9.]+$/;
    my $unit =$c->param('unit') // 'cm';

    my $res = $c->calculate_box($length, $width);$c->stash(
        length => $length,
        width  => $width,
        unit   => $unit,
        res    => $res
    );
    $c->render(template => 'index');
};

app->start;

# Autor: phoenix.3301 - Definición de la plantilla de interfaz de usuario
__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html lang="es" class="dark">
<head>
    <!-- Autor: phoenix.3301 - Estilos y tipografías base -->
    <meta charset="UTF-8">
    <title>Foldform — Estudio de Caja 01</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Mono:wght@400;500&family=DM+Sans:wght@400;500;600;700&family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --background: #000;
            --foreground: #ededed;
            --border: #242424;
            --card: #101010;
            --font-sans: 'DM Sans', sans-serif;
            --font-mono: 'DM Mono', monospace;
            --font-serif: 'Space Grotesk', sans-serif;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: var(--font-sans); background: var(--background); color: var(--foreground); min-height: 100vh; }
        .app-shell { min-height: 100vh; display: flex; flex-direction: column; }
        .topbar { height: 64px; display: flex; align-items: center; justify-content: space-between; padding: 0 32px; border-bottom: 1px solid var(--border); background: #050505; }
        .brand-lockup { display: flex; align-items: center; gap: 12px; color: var(--foreground); text-decoration: none; font-weight: 700; font-family: var(--font-serif); }
        .brand-mark { width: 34px; height: 34px; display: grid; place-items: center; background: #333; color: #fff; border-radius: 8px; transform: rotate(-4deg); }
        .main-wrap { max-width: 1200px; margin: 0 auto; padding: 40px 24px; width: 100%; flex: 1; }
        .workspace { display: grid; grid-template-columns: 320px 1fr; gap: 24px; }
        .panel { border: 1px solid #222; border-radius: 12px; background: var(--card); padding: 24px; box-shadow: 0 8px 30px rgba(0,0,0,0.5); }
        .section-title { font-family: var(--font-serif); font-size: 16px; margin-bottom: 20px; color: #fff; }
        .field-group { margin-bottom: 16px; }
        label { display: block; font-family: var(--font-mono); font-size: 11px; text-transform: uppercase; color: #999; margin-bottom: 8px; letter-spacing: 0.05em; }
        input, select { width: 100%; height: 44px; padding: 0 12px; background: #0a0a0a; border: 1px solid #333; border-radius: 6px; color: #fff; font-family: var(--font-mono); font-size: 14px; }
        input:focus, select:focus { outline: 1px solid #666; border-color: #666; }
        .preview-panel { position: relative; overflow: hidden; min-height: 450px; background: #080808; border: 1px solid #222; border-radius: 12px; display: flex; flex-direction: column; }
        .preview-svg { width: 100%; height: 100%; flex: 1; cursor: grab; }
        .preview-svg:active { cursor: grabbing; }
        .results-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-top: 24px; }
        .result-card { background: var(--card); border: 1px solid #222; border-radius: 12px; padding: 20px; }
        .result-label { font-family: var(--font-mono); font-size: 10px; color: #888; text-transform: uppercase; letter-spacing: 0.1em; }
        .result-value { font-family: var(--font-serif); font-size: 28px; margin: 10px 0 4px; color: #fff; }
        .result-unit { font-family: var(--font-mono); font-size: 11px; color: #aaa; }
        .footer { margin-top: 40px; padding: 20px 0; border-top: 1px solid #222; display: flex; justify-content: space-between; font-family: var(--font-mono); font-size: 11px; color: #666; }
        @media(max-width: 850px) { .workspace { grid-template-columns: 1fr; } .results-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="app-shell">
    <header class="topbar">
        <a href="/" class="brand-lockup">
            <span class="brand-mark">▤</span>
            <span>foldform</span>
        </a>
        <div style="font-family: var(--font-mono); font-size: 11px; color: #888;">PERL BACKEND · 3D ENGINE</div>
    </header>
    <main class="main-wrap">
        <form method="GET" action="/" class="workspace">
            <div class="panel">
                <h2 class="section-title">Parámetros de Lámina</h2>
                <div class="field-group">
                    <label for="length">Largo (L)</label>
                    <input type="number" id="length" name="length" step="any" value="<%= $length %>" required>
                </div>
                <div class="field-group">
                    <label for="width">Ancho (W)</label>
                    <input type="number" id="width" name="width" step="any" value="<%= $width %>" required>
                </div>
                <div class="field-group">
                    <label for="unit">Unidad</label>
                    <select id="unit" name="unit">
                        % for my $u (qw(mm cm m in ft)) {
                            <option value="<%= $u \%>" <\%= $unit eq $u ? 'selected' : '' \%>><\%= $u %></option>
                        % }
                    </select>
                </div>
                <button type="submit" style="width:100%; height:44px; background:#222; color:#fff; border:1px solid #444; border-radius:6px; font-family:var(--font-mono); font-weight:500; cursor:pointer; margin-top:10px;">Actualizar Cálculo</button>
            </div>

            <div style="display:flex; flex-direction:column; gap:24px;">
                <div class="preview-panel">
                    <div style="position:absolute; top:16px; left:20px; z-index:2; font-family:var(--font-mono); font-size:11px; color:#aaa;">VISTA 3D INTERACTIVA · ARRASTRA PARA GIRAR</div>
                    <svg id="boxSvg" class="preview-svg" viewBox="0 0 720 440">
                        <defs>
                            <pattern id="grid" width="28" height="28" patternUnits="userSpaceOnUse"><path d="M 28 0 L 0 0 0 28" stroke="#222" fill="none" /></pattern>
                        </defs>
                        <rect width="720" height="440" fill="url(#grid)" />
                    </svg>
                </div>

                <div class="results-grid">
                    <div class="result-card">
                        <div class="result-label">Corte Óptimo (x)</div>
                        <div class="result-value"><%= $res ? sprintf("\%.2f", $res->{cut}) : '—' %></div>
                        <div class="result-unit"><%= $unit %> por esquina</div>
                    </div>
                    <div class="result-card">
                        <div class="result-label">Dimensiones Internas</div>
                        <div style="font-family: var(--font-mono); font-size: 12px; margin-top: 10px; color: #ccc;">
                            L: <%= $res ? sprintf("%.2f", $res->{boxLength}) : '—' \%> <\%=$unit %><br>
                            W: <%= $res ? sprintf("%.2f", $res->{boxWidth}) : '—' \%> <\%=$unit %><br>
                            H: <%= $res ? sprintf("%.2f", $res->{cut}) : '—' \%> <\%=$unit %>
                        </div>
                    </div>
                    <div class="result-card">
                        <div class="result-label">Volumen Máximo</div>
                        <div class="result-value"><%= $res ? sprintf("\%.2f", $res->{volume}) : '—' %></div>
                        <div class="result-unit"><%= $unit %>³</div>
                    </div>
                </div>
            </div>
        </form>

        <footer class="footer">
            <span>foldform · optimizador geométrico</span>
            <span>created by phoenix.3301 | 2026-2027</span>
        </footer>
    </main>
</div>

<!-- Autor: phoenix.3301 - Motor gráfico de proyección 3D en JavaScript -->
<script>
    const length = <%= $length // 30 %>;
    const width = <%= $width // 20 %>;
    const cut = <%= $res ? $res->{cut} : 5 %>;

    let yaw = -0.67, pitch = 0.53, zoom = 1;
    let isDragging = false, startX = 0, startY = 0;
    const svg = document.getElementById('boxSvg');

    function project(x, y, z, L, W, C, scale, yaw, pitch) {
        const cx = L / 2, cy = W / 2, cz = C / 2;
        const px = (x - cx) * scale;
        const py = (y - cy) * scale;
        const pz = (z - cz) * scale;

        const cY = Math.cos(yaw), sY = Math.sin(yaw);
        const cP = Math.cos(pitch), sP = Math.sin(pitch);

        const rx = px * cY - py * sY;
        const ry = px * sY + py * cY;
        const rz = pz;

        const screenY = ry * sP - rz * cP;
        return [360 + rx, 224 + screenY];
    }

    function render3D() {
        const scale = (245 / Math.max(length, width)) * zoom;
        const L = length, W = width, x = cut;

        const b00 = [x, x, 0], b10 = [L - x, x, 0], b11 = [L - x, W - x, 0], b01 = [x, W - x, 0];
        const f00 = [x, 0, x], f10 = [L - x, 0, x], f11 = [L - x, W, x], f01 = [x, W, x];

        const faces = [
            { pts: [b01, b11, f11, f01], fill: '#2a2a2a' },
            { pts: [b00, b01, f01, f00], fill: '#222222' },
            { pts: [b10, b11, f11, f10], fill: '#1a1a1a' },
            { pts: [b00, b10, f10, f00], fill: '#262626' },
            { pts: [b00, b10, b11, b01], fill: '#333333' }
        ];

        let svgContent = svg.querySelector('defs').outerHTML + '<rect width="720" height="440" fill="url(#grid)" />';

        faces.forEach(f => {
            const pointsStr = f.pts.map(pt => project(pt[0], pt[1], pt[2], L, W, x, scale, yaw, pitch).join(',')).join(' ');
            svgContent += `<polygon points="${pointsStr}" fill="${f.fill}" stroke="#444" stroke-width="1.5" stroke-linejoin="round" />`;
        });

        svg.innerHTML = svgContent;
    }

    svg.addEventListener('pointerdown', e => {
        isDragging = true;
        startX = e.clientX;
        startY = e.clientY;
        svg.setPointerCapture(e.pointerId);
    });

    svg.addEventListener('pointermove', e => {
        if (!isDragging) return;
        const dx = e.clientX - startX;
        const dy = e.clientY - startY;
        startX = e.clientX;
        startY = e.clientY;
        yaw += dx * 0.008;
        pitch = Math.max(-0.18, Math.min(1.32, pitch + dy * 0.006));
        render3D();
    });

    svg.addEventListener('pointerup', () => isDragging = false);
    svg.addEventListener('wheel', e => {
        e.preventDefault();
        zoom = Math.max(0.62, Math.min(1.65, zoom * (e.deltaY > 0 ? 0.92 : 1.09)));
        render3D();
    }, { passive: false });

    render3D();
</script>
</body>
</html>