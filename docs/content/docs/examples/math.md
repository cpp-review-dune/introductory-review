---
title: "Matemática"
description: "Cómo presentar ejemplos de matemáticas."
lead: "Math typesetting examples."
date: 2021-03-16T10:46:05+01:00
lastmod: 2021-03-16T10:46:05+01:00
draft: false
images: []
menu:
  docs:
    parent: "examples"
weight: 210
toc: true
---

[KaTeX](https://katex.org/) está cambiado por defecto. Es posible habilitar ésto de la siguiente forma  `kaTex = true` en `[options]` sección  `./config/_default/params.toml`.

## Ejemplo 1

Tomado de [Supernova Neutrinos](https://neutrino.leima.is/book/introduction/supernova-neutrinos).

### Subtítulo

```md
Con tres comillas francesas, se visualiza lo que se escribe, no lo que quiero presentar.  La energía promedio de los neutrinos $\langle E \rangle$ emitido durante la explosión de una supernova es del orden de 10MeV, y su luminosidad en la época de la explosión es aproximadamente $10^{52}\mathrm{ergs\cdot s^{-1}}$.
Así, la densidad del número de neutrinos de radio $R$ es:

$$
\begin{equation*}
   n \sim  10^{18} \mathrm{cm^{-3}} \left(\frac{100\mathrm{km}}{R}\right)^2 \left(\frac{10\mathrm{MeV}}{\langle E \rangle}\right).
\end{equation*}
$$
```

### HTML

La energía promedio de los neutrinos $\langle E \rangle$ emitida durante la explosión es del orden de $10MeV$, y la luminosidad de los neutrinos es de aproximadamente $10^{52}\mathrm{ergs\cdot s^{-1}}$.
Así, la densidad del número de neutrinos de radio $R$ es:

$$
\begin{equation*}
   n \sim  10^{18} \mathrm{cm^{-3}} \left(\frac{100\mathrm{km}}{R}\right)^2 \left(\frac{10\mathrm{MeV}}{\langle E \rangle}\right).
\end{equation*}
$$

Termina la prueba.
